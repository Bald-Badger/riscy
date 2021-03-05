`include "../opcode.svh"

module ex_mem_reg (
	// common
	input clk,
	input rst_n,
	input flush,
	input en,

	// input
	input instr_t	instr_in,
	input data_t	alu_result_in,
	input data_t 	rs2_in,
	input data_t	pc_p4_in,
	input logic		rd_wren_in,

	// output
	output instr_t	instr_out,
	output data_t	alu_result_out,
	output data_t 	rs2_out,
	output data_t	pc_p4_out,
	output logic	rd_wren_out
);

	dffe #(.WIDTH(XLEN)) instr_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(instr_in),
		.q		(instr_out)
	);

	dffe #(.WIDTH(XLEN)) alu_result_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(alu_result_in),
		.q		(alu_result_out)
	);

	dffe #(.WIDTH(XLEN)) rs2_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(rs2_in),
		.q		(rs2_out)
	);

	dffe #(.WIDTH(XLEN)) pc_p4_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(pc_p4_in),
		.q		(pc_p4_out)
	);

	dffe #(.WIDTH(1)) rd_wren_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(rd_wren_in),
		.q		(rd_wren_out)
	);

endmodule
