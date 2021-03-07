import defines::*;

module fetch(
	// general input
	input clk, 
	input rst_n,

	// input
	input	data_t	pc_bj,
	input 	logic	pc_sel,
	input	logic	en_instr_mem,
	input 	logic	stall,

	// output
	output	data_t	pc_p4,
	output	data_t	pc,
	output	data_t	instr,
	output	logic	taken
);

	pc pc_inst (
		// input
		.clk	(clk),
		.rst_n	(rst_n),
		.pc_bj	(pc_bj),
		.pc_sel	(pc_sel),
		.stall	(stall),

		// output
		.pc		(pc),
		.pc_p4	(pc_p4)
	);

	instr_mem instr_mem_inst (
		.clk	(clk),
		.rst_n	(rst_n),
		.rden	(en_instr_mem),
		.addr	(pc),
		.instr	(instr)
	);

	branch_predict branch_predictor (
		.instr	(instr),
		.taken	(taken)
	);
	
endmodule
