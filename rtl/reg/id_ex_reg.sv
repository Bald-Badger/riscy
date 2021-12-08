import defines::*;

module id_ex_reg (
	// common
	input clk,
	input rst_n,
	input flush,
	input en,

	// input
	input instr_t	instr_in,
	input data_t 	rs1_in,
	input data_t 	pc_in,
	input data_t 	rs2_in,
	input data_t	imm_in,
	input data_t	pc_p4_in,
	input logic		branch_taken_in,
	input logic		instr_valid_in,

	// output
	output instr_t	instr_out,
	output data_t 	rs1_out,
	output data_t 	pc_out,
	output data_t 	rs2_out,
	output data_t	imm_out,
	output data_t	pc_p4_out,
	output logic	branch_taken_out,
	output logic	instr_valid_out
);

	dffe_wrap #(.WIDTH(XLEN)) instr_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? NOP : instr_in),
		.q		(instr_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) rs1_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : rs1_in),
		.q		(rs1_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) pc_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : pc_in),
		.q		(pc_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) rs2_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : rs2_in),
		.q		(rs2_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) imm_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : imm_in),
		.q		(imm_out)
	);
	
	dffe_wrap #(.WIDTH(XLEN)) pc_p4_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : pc_p4_in),
		.q		(pc_p4_out)
	);

	dffe_wrap #(.WIDTH(1)) branch_taken_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 1'b0 : branch_taken_in),
		.q		(branch_taken_out)
	);

	dffe_wrap #(.WIDTH(1)) instr_valid_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(instr_valid_in),
		.q		(instr_valid_out)
	);
	
endmodule
