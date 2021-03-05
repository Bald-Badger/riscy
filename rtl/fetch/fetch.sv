`include "../opcode.svh"

module fetch(
	// general input
	input clk, 
	input rst_n,

	// input
	input	data_t	pc_bj,
	input 			pc_sel,
	input			en_instr_mem,
	input 			stall,

	// output
	output	data_t	pc_p4,
	output	data_t	pc,
	output	data_t	instr
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
		.rden	(en_instr_mem),
		.addr	(pc),
		.instr	(instr)
	);
	
endmodule
