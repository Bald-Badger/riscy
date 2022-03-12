// top module of the processor

// synopsys translate_off
`timescale 1ns / 1ps
// synopsys translate_on

import defines::*;
import axi_defines::*;

module proc_axil (
	input	logic 		clk,					// clock from PLL, frequency is defines::FREQ
	input	logic 		rst_n,					// global reset
	output	logic		ebreak_start,			// last instr retire after ebreak instruction

	axi_lite_interface	data_bus,
	axi_lite_interface	instr_bus				
);
	// sdram init done signal;
	logic		sdram_init_done, sdram_init_done_async;
	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			sdram_init_done <= 1'b0;
		else
			sdram_init_done <= sdram_init_done_async;
	end

	logic init_done;
	assign init_done = sdram_init_done;

	// stage-specific common data wires
	// signal naming shceme:
	// e.g.		xxx_f => xxx signal in fetch stage
	// e.g.		xxx_d => xxx signal in decode stafe
	data_t 		pc_f, pc_d, pc_x; // program counter of current instruction
	data_t 		pcp4_f, pcp4_d, pcp4_x, pcp4_m, pcp4_w;	// program counter + 4
	data_t		pc_nxt_d, pc_nxt_x, pc_nxt_m, pc_nxt_w; // for debug
	instr_t		instr_f, instr_d, instr_x, instr_m, instr_w;	// instruction in each stage
	opcode_t	opcode_f, opcode_d, opcode_x, opcode_m, opcode_w;
	logic		instr_valid_f, instr_valid_d, instr_valid_x, instr_valid_m, instr_valid_w;
	// synthesis translate_off
	data_t		instr_raw;	// for debug
	assign		instr_raw = swap_endian(data_t'(instr_f));
	// synthesis translate_on
	data_t 		rs1_d, rs1_x, rs1_m, rs1_w, rs2_d, rs2_x, rs2_m, rs2_w;	// data in register file #1
	data_t 		imm_d, imm_x;	// immidiate value
	data_t 		alu_result_x, alu_result_m, alu_result_w;	// alu computation result
	logic 		rd_wren_x, rd_wren_m, rd_wren_w;	// register write enable
	data_t 		mem_data_in_m, mem_data_in_w;	// data write to memory
	data_t 		mem_data_out_m, mem_data_out_w;	// data read from memory
	data_t		mem_addr_m, mem_addr_w;	// data access addr;
	logic		branch_predict_f, branch_predict_d;	// branch perdictor output from fetch stage
	logic		branch_taken_actual_d, branch_taken_actual_x;	// actual branch result from decode stagen
	logic		branch_mispredict;
	assign		branch_mispredict = branch_taken_actual_d != branch_predict_d;

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
		ex_ex_fwd_data = (instr_m.opcode == LOAD) ? mem_data_out_m : alu_result_m;
		mem_ex_fwd_data = wb_data;
		mem_mem_fwd_data = wb_data;
	end

	// instruction order
	data_t		instr_order;


	// fetch stage	
	fetch_axil fetch_inst (
		// general
		.clk			(clk),
		.rst_n			(rst_n),

		// input
		.pc_bj			(pc_bj),
		.pc_sel			(pc_sel),
		.stall			(stall_pc),
		.flush			(flush_pc),
		.go				(init_done),
		.instr_w		(instr_w),

		// output
		.pc_p4_out		(pcp4_f),
		.pc_out			(pc_f),
		.instr			(instr_f),
		.taken			(branch_predict_f),
		.instr_valid	(instr_valid_f),

		.axil_bus		(instr_bus)
	);


	// fetch-decode reg
	if_id_reg if_id_reg_inst (
		// general
		.clk			(clk),
		.rst_n			(rst_n),
		.flush			(flush_if_id),
		.en				((!stall_if_id) && init_done),

		// input
		.pc_p4_in		(pcp4_f),
		.pc_in			(pc_f),
		.instr_in		(instr_f),
		.branch_take_in	(branch_predict_f),
		.instr_valid_in	(instr_valid_f),
		
		// output
		.pc_p4_out		(pcp4_d),
		.pc_out			(pc_d),
		.instr_out		(instr_d),
		.branch_take_out(branch_predict_d),
		.instr_valid_out(instr_valid_d)
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
		.pc_nxt			(pc_nxt_d),
		.instr			(instr_d),
		.wd				(wb_data),
		.waddr			(rd_addr),
		.wren			(rd_wren_w),
		
		// for branch forwarding
		.ex_data		(alu_result_x),
		.mem_data		((instr_m.opcode == LOAD) ? mem_data_out_m : alu_result_m),
		.wb_data		((instr_w.opcode == LOAD) ? mem_data_out_w : alu_result_w),
		.fwd_rs1		(fwd_id_rs1),
		.fwd_rs2		(fwd_id_rs2),

		// output
		.pc_bj			(pc_bj),
		.pc_sel			(pc_sel),	// 1 for bj, 0 for p4
		.rs1			(rs1_d),
		.rs2			(rs2_d),
		.imm			(imm_d),
		.branch_taken	(branch_taken_actual_d)
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
		.clk				(clk),
		.rst_n				(rst_n),
		.flush				(flush_id_ex),
		.en					(!stall_id_ex),

		// input
		.instr_in	(
			(stall_if_id && ~stall_id_ex)	? NOP : 
			(flush_if_id)					? NOP : instr_d
		),
		.rs1_in				(rs1_d),
		.rs2_in				(rs2_d_after_fwd),
		.pc_in				(pc_d),
		.pc_nxt_in			(pc_nxt_d),
		.imm_in				(imm_d),
		.pc_p4_in			(pcp4_d),
		.branch_taken_in	(branch_taken_actual_d),
		.instr_valid_in		(instr_valid_d),

		//output
		.instr_out			(instr_x),
		.rs1_out			(rs1_x),
		.rs2_out			(rs2_x),
		.pc_out				(pc_x),
		.imm_out			(imm_x),
		.pc_p4_out			(pcp4_x),
		.pc_nxt_out			(pc_nxt_x),
		.branch_taken_out	(branch_taken_actual_x),
		.instr_valid_out	(instr_valid_x)
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
		.pc_nxt_in		(pc_nxt_x),
		.rd_wren_in		(rd_wren_x),
		.instr_valid_in	(instr_valid_x),

		// output
		.instr_out		(instr_m),
		.alu_result_out	(alu_result_m),
		.rs2_out		(rs2_m),
		.pc_p4_out		(pcp4_m),
		.pc_nxt_out		(pc_nxt_m),
		.rd_wren_out	(rd_wren_m),
		.instr_valid_out(instr_valid_m)
	);

	// memory stage
	memory memory_inst (
		// input
		.clk				(clk),
		.rst_n				(rst_n),
		.addr				(alu_result_m),
		.data_in_raw		(rs2_m),
		.mem_mem_fwd_data	(mem_mem_fwd_data),
		.fwd_m2m			(fwd_mem_rs2),
		.instr				(instr_m),
		
		// output
		.data_out			(mem_data_out_m),
		.sdram_init_done	(sdram_init_done_async),
		.done				(mem_access_done),
		.data_in_final		(mem_data_in_m),

		.axil_bus			(data_bus)
	);


	assign mem_addr_m = alu_result_m;
	// memory-write-back stage reg
	mem_wb_reg mem_wb_reg_inst (
		// common
		.clk				(clk),
		.rst_n				(rst_n),
		.flush				(flush_mem_wb),
		.en					(!stall_mem_wb),

		// input
		.instr_in			(
			stall_ex_mem ? NOP :
			flush_ex_mem ? NOP : instr_m 
		),
		.alu_result_in		(alu_result_m),
		.mem_data_in_in		(mem_data_in_m),
		.mem_data_out_in	(mem_data_out_m),
		.pc_p4_in			(pcp4_m),
		.pc_nxt_in			(pc_nxt_m),
		.rd_wren_in			(rd_wren_m),
		.instr_valid_in		(instr_valid_m),
		.mem_addr_in		(mem_addr_m),	// for debug

		// output
		.instr_out			(instr_w),
		.alu_result_out		(alu_result_w),
		.mem_data_in_out	(mem_data_in_w),
		.mem_data_out_out	(mem_data_out_w),
		.pc_p4_out			(pcp4_w),
		.pc_nxt_out			(pc_nxt_w),
		.rd_wren_out		(rd_wren_w),
		.instr_valid_out	(instr_valid_w),
		.mem_addr_out		(mem_addr_w)
	);


	// write-back stage
	wb wb_inst (
		// input
		.instr		(instr_w),
		.alu_result	(alu_result_w),
		.mem_data	(mem_data_out_w),
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

		.instr_valid_d		(instr_valid_d),

		.ex_rd_write		(rd_wren_x),
		.mem_rd_write		(rd_wren_m),
		.wb_rd_write		(rd_wren_w),

		.sdram_init_done	(sdram_init_done),
		.execute_busy		(execute_busy),
		.mem_access_done	(mem_access_done),
		.branch_taken_d		(branch_taken_actual_d),
		.branch_taken_x		(branch_taken_actual_x),
		
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


// TODO: resume pipeline after ebreak return
always_comb begin : ebreak_assign
	ebreak_start = instr_w.opcode == SYS;
end

always_comb begin
	opcode_f = instr_f.opcode;
	opcode_d = instr_d.opcode;
	opcode_x = instr_x.opcode;
	opcode_m = instr_m.opcode;
	opcode_w = instr_w.opcode;
end

endmodule : proc_axil
