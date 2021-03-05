// top module of the processor
`include "./opcode.svh"

module proc(
	input logic clk,
	input logic rst_n
);
	
	// stage-specific common data wires
	data_t 	pc_f, pc_d, pc_x, pc_m, pc_w;
	data_t 	pcp4_f, pcp4_d, pcp4_x, pcp4_m, pcp4_w;
	instr_t	instr_f, instr_d, instr_x, instr_m, instr_w;
	data_t rs1_d, rs1_x, rs2_d, rs2_x, rs2_m;
	data_t imm_d, imm_x;
	data_t alu_result_x, alu_result_m, alu_result_w;
	logic rd_wren_x, rd_wren_m, rd_wren_w;
	data_t mem_data_m, mem_data_w;

	// global control wire
	fwd_sel_t fwd_a = RS_SEL;	// TODO:
	fwd_sel_t fwd_b = RS_SEL;	// TODO:
	fwd_sel_t fwd_m2m = RS_SEL; // TODO:
	logic pc_sel;

	// global data wire
	data_t wb_data;
	data_t pc_bj;
	data_t ex_ex_fwd_data = alu_result_m;
	data_t mem_ex_fwd_data = wb_data;
	data_t mem_mem_fwd_data = wb_data;


	// fetch stage
		
	
	fetch fetch_inst (
		// general
		.clk			(clk),
		.rst_n			(rst_n),

		// input
		.pc_bj			(pc_bj),
		.pc_sel			(pc_sel),
		.en_instr_mem	(ENABLE), // TODO:
		.stall			(DISABLE), // TODO:

		// output
		.pc_p4			(pcp4_f),
		.pc				(pc_f),
		.instr			(instr_f)
	);


	// fetch-decode reg
	if_id_reg if_id_reg_inst (
		// general
		.clk		(clk),
		.rst_n		(rst_n),
		.flush		(DISABLE),	// TODO:
		.en			(ENABLE),	// TODO:

		// input
		.pc_p4_in	(pcp4_f),
		.pc_in		(pc_f),
		.instr_in	(instr_f),
		
		// output
		.pc_p4_out	(pcp4_d),
		.pc_out		(pc_d),
		.instr_out	(instr_d)
	);


	// decode stage
	// wire used first in decode stage
	
	r_t rd_addr;
	always_comb begin
		rd_addr = instr_w.rd;
	end

	decode decode_inst (
		// general
		.clk	(clk),
		.rst_n	(rst_n),

		// input
		.pc		(pc_d),
		.instr	(instr_d),
		.wd		(wb_data),
		.waddr	(rd_addr),
		.wren	(rd_wren_w),

		// output
		.pc_bj	(pc_bj),
		.pc_sel	(pc_sel),
		.rs1	(rs1_d),
		.rs2	(rs2_d),
		.imm	(imm_d)
	);


	// decode-execute stage reg
	id_ex_reg id_ex_reg_inst (
		// common
		.clk		(clk),
		.rst_n		(rst_n),
		.flush		(DISABLE),
		.en			(ENABLE),

		// input
		.instr_in	(instr_d),
		.rs1_in		(rs1_d),
		.rs2_in		(rs2_d),
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
		.flush			(DISABLE),
		.en				(ENABLE),

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
		.addr				(alu_result_x),
		.data_in_raw		(rs2_m),
		.mem_mem_fwd_data	(wb_data),
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
		.flush			(DISABLE),
		.en				(ENABLE),

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


endmodule : proc
