import defines::*;

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
	input data_t	pc_in,
	input logic		rd_wren_in,
	input logic		instr_valid_in,

	// output
	output instr_t	instr_out,
	output data_t	alu_result_out,
	output data_t 	rs2_out,
	output data_t	pc_out,
	output logic	rd_wren_out,
	output logic	instr_valid_out
);

	dffe_wrap #(.WIDTH(XLEN), .GEN_TARGET(TARGET)) instr_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(instr_in),
		.q		(instr_out)
	);

	dffe_wrap #(.WIDTH(XLEN), .GEN_TARGET(TARGET)) alu_result_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(alu_result_in),
		.q		(alu_result_out)
	);

	dffe_wrap #(.WIDTH(XLEN), .GEN_TARGET(TARGET)) rs2_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(rs2_in),
		.q		(rs2_out)
	);

	dffe_wrap #(.WIDTH(XLEN), .GEN_TARGET(TARGET)) pc_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(pc_in),
		.q		(pc_out)
	);

	dffe_wrap #(.WIDTH(1), .GEN_TARGET(TARGET)) rd_wren_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(rd_wren_in),
		.q		(rd_wren_out)
	);

	dffe_wrap #(.WIDTH(1), .GEN_TARGET(TARGET)) instr_valid_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(instr_valid_in),
		.q		(instr_valid_out)
	);

endmodule
