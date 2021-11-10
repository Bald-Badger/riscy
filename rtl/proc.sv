// top module of the processor

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

module proc(
	input	logic 			clk,			// clock from PLL, frequency is defines::FREQ
	input	logic 			clk_100m,		// clock to SDRAM FIFO
	input	logic 			clk_100m_shift,	// clock to SDRAM
	input	logic 			rst_n,			// global reset
	output	logic			ebreak_start,	// 3 cycles after ebreak instruction
	
	// SDRAM hardware pins, don't touch
	output	logic			sdram_clk, 
	output	logic			sdram_cke,
	output	logic			sdram_cs_n,   
	output	logic			sdram_ras_n,
	output	logic			sdram_cas_n,
	output	logic        	sdram_we_n,
	output	logic	[ 1:0]	sdram_ba,
	output	logic	[12:0]	sdram_addr,
	inout	wire	[15:0]	sdram_data,
	output	logic	[ 1:0]	sdram_dqm
	// end don't touch
);
	// sdram init done signal;
	logic		sdram_init_done;

	// stage-specific common data wires
	// signal naming shceme:
	// e.g.		xxx_f => xxx signal in fetch stage
	// e.g.		xxx_d => xxx signal in decode stafe
	data_t 		pc_f, pc_d, pc_x; // program counter of current instruction
	data_t 		pcp4_f, pcp4_d, pcp4_x, pcp4_m, pcp4_w;	// program counter + 4
	instr_t		instr_f, instr_d, instr_x, instr_m, instr_w;	// instruction in each stage
	data_t 		rs1_d, rs1_x, rs1_m, rs2_d, rs2_x, rs2_m;	// data in register file #1
	data_t 		imm_d, imm_x;	// immidiate value
	data_t 		alu_result_x, alu_result_m, alu_result_w;	// alu computation result
	logic 		rd_wren_x, rd_wren_m, rd_wren_w;	// register write enable
	data_t 		mem_data_m, mem_data_w;	// data load from memory
	logic		branch_take_f, branch_take_d;	// branch perdictor output from fetch stage
	logic		branch_taken_actual;			// actual branch result from decode stage

	// synthesis translate_off
	data_t		instr_raw;	// for debug
	assign instr_raw = data_t'(instr_f);
	// synthesis translate_on

	// global control wire
	logic 			pc_sel;			// should pc update to pc+4 or branch/jump result, 1 for bj, 0 for p4
	logic			execute_busy;	// execute stage computing, must stall pipeline

	id_fwd_sel_t	fwd_id_rs1, fwd_id_rs2;	// control signal for data forwarding to decode stage
	ex_fwd_sel_t	fwd_ex_rs1, fwd_ex_rs2;	// control signal for data forwarding to exe stage
	mem_fwd_sel_t	fwd_mem_rs1, fwd_mem_rs2; // control signal for data forwarding to mem stage

	// stall and flush
	logic		stall_pc,					// stall PC register
				stall_if_id, stall_id_ex,	// stall pipeline stage register
				stall_ex_mem, stall_mem_wb;
	logic		flush_pc,
				flush_if_id, flush_id_ex,
				flush_ex_mem, flush_mem_wb;

	// ebreak
	logic		ebreak;			// ebreak instruction appear in decode stage
	logic		ebreak_stall;	// stall from ebreak, waiting pipeline clear
	logic		ebreak_return;	// wait for debugger return executation to core
	assign		ebreak_return = 1'b0;	// disable debugger return

	// memory access done flag
	logic		mem_access_done;

	// global data wire
	data_t		wb_data;		// write-back data
	data_t		pc_bj;			// pc branch / jump target
	
	// signal naming is kind of f*ked up
	data_t		ex_ex_fwd_data;		// fwd data from mem stage to exe stage
	data_t		mem_ex_fwd_data;	// fwd data from wb stage to exe stage
	data_t		mem_mem_fwd_data;	// fwd data from wb stage to mem stage
	always_comb begin : fwd_data_assign
		ex_ex_fwd_data = (instr_m.opcode == LOAD) ? mem_data_m : alu_result_m;
		mem_ex_fwd_data = wb_data;
		mem_mem_fwd_data = wb_data;
	end


	// fetch stage	
	fetch fetch_inst (
		// general
		.clk			(clk),
		.rst_n			(rst_n),

		// input
		.pc_bj			(pc_bj),
		.pc_sel			(pc_sel),
		.stall			(stall_pc),
		.flush			(flush_pc),

		// output
		.pc_p4_out		(pcp4_f),
		.pc_out			(pc_f),
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
		.instr_in		(
			(stall_pc && ~stall_if_id)	? NOP : 
			(flush_pc) 					? NOP : instr_f
		),
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
		.clk			(clk),
		.rst_n			(rst_n),

		// input
		.pc				(pc_d),
		.instr			(instr_d),
		.wd				(wb_data),
		.waddr			(rd_addr),
		.wren			(rd_wren_w),
		
		// for branch forwarding
		.ex_data		(alu_result_x),
		.mem_data		((instr_m.opcode == LOAD) ? mem_data_m : alu_result_m),
		.wb_data		((instr_w.opcode == LOAD) ? mem_data_w : alu_result_w),
		.fwd_rs1		(fwd_id_rs1),
		.fwd_rs2		(fwd_id_rs2),

		// output
		.pc_bj			(pc_bj),
		.pc_sel			(pc_sel),	// 1 for bj, 0 for p4
		.rs1			(rs1_d),
		.rs2			(rs2_d),
		.imm			(imm_d),
		.branch_taken	(branch_taken_actual)
	);


	data_t rs2_d_after_fwd;
	always_comb begin : rs2_d_after_fwd_assign
		unique case (fwd_id_rs2)
			RS_ID_SEL: 	rs2_d_after_fwd = rs2_d;
			EX_ID_SEL:	rs2_d_after_fwd = alu_result_x;
			MEM_ID_SEL:	rs2_d_after_fwd = alu_result_m;
			WB_ID_SEL:	rs2_d_after_fwd = alu_result_w;
			default:	rs2_d_after_fwd = NULL;
		endcase
	end


	// decode-execute stage reg
	id_ex_reg id_ex_reg_inst (
		// common
		.clk		(clk),
		.rst_n		(rst_n),
		.flush		(flush_id_ex),
		.en			(!stall_id_ex),

		// input
		.instr_in	(
			(stall_if_id && ~stall_id_ex)	? NOP : 
			(flush_if_id)					? NOP : instr_d
		),
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
		// clk for multi-cycle computation
		.clk				(clk),

		// ctrl
		.fwd_a				(fwd_ex_rs1),
		.fwd_b				(fwd_ex_rs2),

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
		.rd_wren			(rd_wren_x),
		.execute_busy		(execute_busy)
	);


	// execute-memory stage reg
	ex_mem_reg ex_mem_reg_inst (
		// common
		.clk			(clk),
		.rst_n			(rst_n),
		.flush			(flush_ex_mem),
		.en				(!stall_ex_mem),

		// input
		.instr_in		(
			(stall_id_ex && ~stall_ex_mem)	? NOP :
			(flush_id_ex)					? NOP : instr_x
		),
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
		.clk_100m			(clk_100m),
		.clk_100m_shift		(clk_100m_shift),
		.rst_n				(rst_n),
		.addr				(alu_result_m),
		.data_in_raw		(rs2_m),
		.mem_mem_fwd_data	(mem_mem_fwd_data),
		.fwd_m2m			(fwd_mem_rs2),
		.instr				(instr_m),
		
		// output
		.data_out			(mem_data_m),
		.sdram_init_done	(sdram_init_done),
		.done				(mem_access_done),

		// SDRAM hardware pins
		.sdram_clk			(sdram_clk), 
		.sdram_cke			(sdram_cke),
		.sdram_cs_n			(sdram_cs_n),
		.sdram_ras_n		(sdram_ras_n),
		.sdram_cas_n		(sdram_cas_n),
		.sdram_we_n			(sdram_we_n),
		.sdram_ba			(sdram_ba),
		.sdram_addr			(sdram_addr),
		.sdram_data			(sdram_data),
		.sdram_dqm			(sdram_dqm)
	);


	// memory-write-back stage reg
	mem_wb_reg mem_wb_reg_inst (
		// common
		.clk			(clk),
		.rst_n			(rst_n),
		.flush			(flush_mem_wb),
		.en				(!stall_mem_wb),

		// input
		.instr_in		(
			stall_ex_mem ? NOP :
			flush_ex_mem ? NOP : instr_m 
		),
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
		.instr_f			(instr_f),
		.instr_d			(instr_d),
		.instr_x			(instr_x),
		.instr_m			(instr_m),
		.instr_w			(instr_w),

		.ex_rd_write		(rd_wren_x),
		.mem_rd_write		(rd_wren_m),
		.wb_rd_write		(rd_wren_w),

		.sdram_init_done	(sdram_init_done),
		.execute_busy		(execute_busy),
		.mem_access_done	(mem_access_done),
		
		// output
		// forwarding signal
		.fwd_id_rs1			(fwd_id_rs1),
		.fwd_id_rs2			(fwd_id_rs2),

		.fwd_ex_rs1			(fwd_ex_rs1),
		.fwd_ex_rs2			(fwd_ex_rs2),

		.fwd_mem_rs1		(fwd_mem_rs1),
		.fwd_mem_rs2		(fwd_mem_rs2),

		// stall signal
		.stall_pc			(stall_pc),
		.stall_if_id		(stall_if_id),
		.stall_id_ex		(stall_id_ex),
		.stall_ex_mem		(stall_ex_mem),
		.stall_mem_wb		(stall_mem_wb),

		// flush signal
		.flush_pc			(flush_pc),
		.flush_if_id		(flush_if_id),
		.flush_id_ex		(flush_id_ex),
		.flush_ex_mem		(flush_ex_mem),
		.flush_mem_wb		(flush_mem_wb)
	);


// TODO: change ebreak status to "instr.w == ebreak"
// TODO: stall pipeline for all instruction after ebreak until ebreak_returm
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
