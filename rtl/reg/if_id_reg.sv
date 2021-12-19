import defines::*;

module if_id_reg (
	// common
	input clk,
	input rst_n,
	input flush,
	input en,
	
	// input
	input data_t 	pc_p4_in,
	input data_t 	pc_in,
	input data_t	pc_nxt_in,
	input instr_t 	instr_in,
	input logic		branch_take_in,
	input logic		instr_valid_in,

	// output
	output data_t 	pc_p4_out,
	output data_t 	pc_out,
	output data_t	pc_nxt_out,
	output instr_t 	instr_out,
	output logic	branch_take_out,
	output logic	instr_valid_out
);

	dffe_wrap #(.WIDTH(XLEN)) pc_p4_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : pc_p4_in),
		.q		(pc_p4_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) pc_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : pc_in),
		.q		(pc_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) pc_nxt_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : pc_nxt_in),
		.q		(pc_nxt_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) instr_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? NOP : instr_in),
		.q		(instr_out)
	);

	dffe_wrap #(.WIDTH(1)) branch_take_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 1'b0 : branch_take_in),
		.q		(branch_take_out)
	);

	dffe_wrap #(.WIDTH(1)) instr_valid_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? INVALID : instr_valid_in),
		.q		(instr_valid_out)
	);

endmodule
