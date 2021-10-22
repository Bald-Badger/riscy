import defines::*;

module fetch(
	// general input
	input	logic	clk, 
	input	logic	rst_n,

	// input
	input	data_t	pc_bj,
	input 	logic	pc_sel,
	input	logic	en_instr_mem,
	input 	logic	stall,
	input	logic	flush,

	// output
	output	data_t	pc_p4_out,
	output	data_t	pc_out,
	output	data_t	instr,
	output	logic	taken
);
	data_t instr_raw;
	assign instr = (flush) ? NOP : instr_raw;	// mask the output as if masked
	data_t pc, pc_p4;
	assign pc_p4_out = pc_p4 - 4;
	assign pc_out = pc - 4;

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
		.stall	(stall),
		.addr	(pc),
		.instr	(instr_raw)
	);

	branch_predict branch_predictor (
		.instr	(instr),
		.taken	(taken)
	);
	
endmodule
