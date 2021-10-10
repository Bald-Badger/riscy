// top module of the processor

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

module proc(
	input logic clk,
	input logic rst_n,
	output logic ebreak_start	// actually 3 cycles after ebreak, pipeline cleared
);

	// stage-specific common data wires
	data_t 	pc_f, pc_d, pc_x; // pc_m, pc_w;
	data_t 	pcp4_f, pcp4_d, pcp4_x, pcp4_m, pcp4_w;
	instr_t	instr_f, instr_d, instr_x, instr_m, instr_w;
	data_t 	rs1_d, rs1_x, rs2_d, rs2_x, rs2_m;
	data_t 	imm_d, imm_x;
	data_t 	alu_result_x, alu_result_m, alu_result_w;
	logic 	rd_wren_x, rd_wren_m, rd_wren_w;
	data_t 	mem_data_m, mem_data_w;
	logic	branch_take_f, branch_take_d;
	logic	branch_taken_actual;


	// global control wire

	logic 		pc_sel;
	// for exe forward
	fwd_sel_t	fwd_a, fwd_b, fwd_m2m;
	// for branching forward
	branch_fwd_t fwd_rs1, fwd_rs2;	
	// for memory forwad from latter stage to ID to read rs2
	store_fwd_t fwd_store;

	// stall and flush
	logic		stall_if_id, stall_id_ex,
				stall_ex_mem, stall_mem_wb;
	logic		flush_if_id, flush_id_ex,
				flush_ex_mem, flush_mem_wb;
	// ebreak
	logic ebreak;
	logic ebreak_stall;	// stall from ebreak, waiting pipeline clear

	// global data wire
	data_t wb_data;
	data_t pc_bj;
	data_t ex_ex_fwd_data;
	data_t mem_ex_fwd_data;
	data_t mem_mem_fwd_data;
	always_comb begin : fwd_data_assign
		ex_ex_fwd_data = alu_result_m;
		mem_ex_fwd_data = wb_data;
		mem_mem_fwd_data = wb_data;
	end


	// external signal
	logic ebreak_return;
	assign ebreak_return = 1'b0;

	// fetch stage	
	fetch fetch_inst (
		// general
		.clk			(clk),
		.rst_n			(rst_n),

		// input
		.pc_bj			(pc_bj),
		.pc_sel			(pc_sel),
		.en_instr_mem	(ENABLE),
		.stall			(stall_if_id | ebreak_stall),

		// output
		.pc_p4			(pcp4_f),
		.pc				(pc_f),
		.instr			(instr_f),
		.taken			(branch_take_f)
	);


	// fetch-decode reg
	if_id_reg if_id_reg_inst (
		// general
		.clk			(clk),
		.rst_n			(rst_n),
		.flush			(flush_if_id),
		.en				((!stall_if_id) & (!ebreak_stall)),

		// input
		.pc_p4_in		(pcp4_f),
		.pc_in			(pc_f),
		.instr_in		(instr_f),
		.branch_take_in	(branch_take_f),
		
		// output
		.pc_p4_out		(pcp4_d),
		.pc_out			(pc_d),
		.instr_out		(instr_d),
		.branch_take_out(branch_take_d)
	);


	// decode stage
	// wire used first in decode stage
	r_t rd_addr;
	always_comb begin
		rd_addr = instr_w.rd;
	end

	decode decode_inst (
		// general
		.clk		(clk),
		.rst_n		(rst_n),

		// input
		.pc			(pc_d),
		.instr		(instr_d),
		.wd			(wb_data),
		.waddr		(rd_addr),
		.wren		(rd_wren_w),
		
		// for branch forwarding
		.ex_data	(alu_result_x),
		.mem_data	(alu_result_m),
		.wb_data	(wb_data),
		.fwd_rs1	(fwd_rs1),
		.fwd_rs2	(fwd_rs2),

		// output
		.pc_bj		(pc_bj),
		.pc_sel		(pc_sel),
		.rs1		(rs1_d),
		.rs2		(rs2_d),
		.imm		(imm_d),
		.branch_taken(branch_taken_actual)
	);

	data_t rs2_d_after_fwd;
	always_comb begin : rs2_d_after_fwd_assign
		rs2_d_after_fwd =	(fwd_store == RS_STORE_SEL) ? rs2_d :
							(fwd_store == EX_ID_STORE_SEL) ? alu_result_x :
							(fwd_store == MEM_ID_STORE_SEL) ? alu_result_m :
							(fwd_store == WB_ID_STORE_SEL) ? alu_result_w :
							NULL;
	end

	// decode-execute stage reg
	id_ex_reg id_ex_reg_inst (
		// common
		.clk		(clk),
		.rst_n		(rst_n),
		.flush		(flush_id_ex),
		.en			(!stall_id_ex),

		// input
		.instr_in	(instr_d),
		.rs1_in		(rs1_d),
		.rs2_in		(rs2_d_after_fwd),
		.pc_in		(pc_d),
		.imm_in		(imm_d),
		.pc_p4_in	(pcp4_d),

		//output
		.instr_out	(instr_x),
		.rs1_out	(rs1_x),
		.rs2_out	(rs2_x),
		.pc_out		(pc_x),
		.imm_out	(imm_x),
		.pc_p4_out	(pcp4_x)
	);


	// execute stage
	execute execute_inst (
		// ctrl
		.fwd_a				(fwd_a),
		.fwd_b				(fwd_b),

		// input
		.rs1				(rs1_x),
		.rs2				(rs2_x),
		.pc					(pc_x),
		.imm				(imm_x),
		.instr				(instr_x),

		.ex_ex_fwd_data		(ex_ex_fwd_data),
		.mem_ex_fwd_data	(mem_ex_fwd_data),

		// output
		.alu_result			(alu_result_x),
		.rd_wren			(rd_wren_x)
	);


	// execute-memory stage reg
	ex_mem_reg ex_mem_reg_inst (
		// common
		.clk			(clk),
		.rst_n			(rst_n),
		.flush			(flush_ex_mem),
		.en				(!stall_ex_mem),

		// input
		.instr_in		(instr_x),
		.alu_result_in	(alu_result_x),
		.rs2_in			(rs2_x),
		.pc_p4_in		(pcp4_x),
		.rd_wren_in		(rd_wren_x),

		// output
		.instr_out		(instr_m),
		.alu_result_out	(alu_result_m),
		.rs2_out		(rs2_m),
		.pc_p4_out		(pcp4_m),
		.rd_wren_out	(rd_wren_m)
	);


	// memory stage
	memory memory_inst (
		// input
		.clk				(clk),
		.rst_n				(rst_n),
		.addr				(alu_result_m),
		.data_in_raw		(rs2_m),
		.mem_mem_fwd_data	(mem_mem_fwd_data),
		.fwd_m2m			(fwd_m2m),
		.instr				(instr_m),
		
		// output
		.data_out			(mem_data_m)
	);


	// memory-write-back stage reg
	mem_wb_reg mem_wb_reg_inst (
		// common
		.clk			(clk),
		.rst_n			(rst_n),
		.flush			(flush_mem_wb),
		.en				(!stall_mem_wb),

		// input
		.instr_in		(instr_m),
		.alu_result_in	(alu_result_m),
		.mem_data_in	(mem_data_m),
		.pc_p4_in		(pcp4_m),
		.rd_wren_in		(rd_wren_m),

		// output
		.instr_out		(instr_w),
		.alu_result_out	(alu_result_w),
		.mem_data_out	(mem_data_w),
		.pc_p4_out		(pcp4_w),
		.rd_wren_out	(rd_wren_w)
	);


	// write-back stage
	wb wb_inst (
		// input
		.instr		(instr_w),
		.alu_result	(alu_result_w),
		.mem_data	(mem_data_w),
		.pc_p4		(pcp4_w),

		// output
		.wb_data	(wb_data)
	);

	hazard_ctrl hazard_ctrl_inst (
		// input signal
		.instr_f		(instr_f),
		.instr_d		(instr_d),
		.instr_x		(instr_x),
		.instr_m		(instr_m),
		.instr_w		(instr_w),

		.id_ex_wr_rd	(rd_wren_x),
		.ex_mem_wr_rd	(rd_wren_m),
		.mem_wb_wr_rd	(rd_wren_w),

		.branch_predict	(branch_take_d),
		.branch_actual	(branch_taken_actual),
		
		// output
		// forwarding signal
		.fwd_a			(fwd_a),
		.fwd_b			(fwd_b),
		.fwd_m2m		(fwd_m2m),

		.fwd_rs1		(fwd_rs1),
		.fwd_rs2		(fwd_rs2),

		.fwd_store		(fwd_store),

		// stall signal
		.stall_if_id	(stall_if_id),
		.stall_id_ex	(stall_id_ex),
		.stall_ex_mem	(stall_ex_mem),
		.stall_mem_wb	(stall_mem_wb),

		// flush signal
		.flush_if_id	(flush_if_id),
		.flush_id_ex	(flush_id_ex),
		.flush_ex_mem	(flush_ex_mem),
		.flush_mem_wb	(flush_mem_wb)
	);


typedef enum reg[2:0] {
	EBREAK_IDLE,
	EBREAK_CNT_1,
	EBREAK_CNT_2,
	EBREAK_CNT_3,
	EBREAK_WAIT		// wait for return instruction from debugger
} ebreak_state_t;
ebreak_state_t ebreak_state, ebreak_nxt_state;
assign ebreak = (instr_d == EBREAK) ? 1'b1 : 1'b0;
assign ebreak_start = (ebreak_state == EBREAK_WAIT) ? 1'b1 : 1'b0;

always_ff @(posedge clk or negedge rst_n)
  if (!rst_n)
    ebreak_state <= EBREAK_IDLE;
  else
    ebreak_state <= ebreak_nxt_state;

always_comb begin : ebreak_fsm
	ebreak_nxt_state = EBREAK_IDLE;
	ebreak_stall = 1'b0;
	case (ebreak_state)

		EBREAK_IDLE: begin
			if (ebreak) begin
				ebreak_nxt_state = EBREAK_CNT_1;
				ebreak_stall = 1'b1;
			end else begin
				ebreak_nxt_state = EBREAK_IDLE;
				ebreak_stall = 1'b0;
			end
		end

		EBREAK_CNT_1: begin
			ebreak_nxt_state = EBREAK_CNT_2;
			ebreak_stall = 1'b1;
		end

		EBREAK_CNT_2: begin
			ebreak_nxt_state = EBREAK_CNT_3;
			ebreak_stall = 1'b1;
		end

		EBREAK_CNT_3: begin
			ebreak_nxt_state = EBREAK_WAIT;
			ebreak_stall = 1'b0;
		end

		EBREAK_WAIT: begin
			if (ebreak_return) begin
				ebreak_nxt_state = EBREAK_IDLE;
				ebreak_stall = 1'b0;
			end else begin
				ebreak_nxt_state = EBREAK_WAIT;
				ebreak_stall = 1'b1;
			end
		end

		default: begin
			ebreak_nxt_state = EBREAK_IDLE;
			ebreak_stall = 1'b0;
		end

	endcase
end

endmodule : proc
