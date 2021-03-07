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
	input instr_t 	instr_in,
	input branch_take_t branch_take_in,

	// output
	output data_t 	pc_p4_out,
	output data_t 	pc_out,
	output instr_t 	instr_out,
	output branch_take_t branch_take_out
);

	dffe #(.WIDTH(XLEN)) pc_p4_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(pc_p4_in),
		.q		(pc_p4_out)
	);

	dffe #(.WIDTH(XLEN)) pc_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(pc_in),
		.q		(pc_out)
	);

	dffe #(.WIDTH(XLEN)) instr_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(instr_in),
		.q		(instr_out)
	);

	dffe #(.WIDTH(XLEN)) branch_take_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(branch_take_in),
		.q		(branch_take_out)
	);

endmodule
