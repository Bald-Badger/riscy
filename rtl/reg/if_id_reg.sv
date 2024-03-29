import defines::*;

module if_id_reg # (
	TARGET = GEN_TARGET
) (
	// common
	input clk,
	input rst_n,
	input flush,
	input en,
	
	// input
	input data_t 	pc_in,
	input instr_t 	instr_in,
	input logic		instr_valid_in,

	// output
	output data_t 	pc_out,
	output instr_t 	instr_out,
	output logic	instr_valid_out
);

	dffe_wrap #(.WIDTH(XLEN), .TARGET(TARGET)) pc_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : pc_in),
		.q		(pc_out)
	);

	dffe_wrap #(.WIDTH(XLEN), .TARGET(TARGET)) instr_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? NOP : instr_in),
		.q		(instr_out)
	);

	dffe_wrap #(.WIDTH(1), .TARGET(TARGET)) instr_valid_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? INVALID : instr_valid_in),
		.q		(instr_valid_out)
	);

endmodule
