`include "../opcode.svh"

module fetch(
	// general input
	input clk, 
	input rst_n,

	// input
	input	data_t	pc_bj,
	input 			pc_sel,

	// output
	output	data_t	pc_p4,
	output	data_t	pc,
	output	data_t	instr,
	output	r_t		rd
);

	pc pc_inst (
		.clk	(clk),
		.rst_n	(rst_n),
		.pc_bj	(pc_bj),
		.pc_sel	(pc_sel),
		.pc		(pc),
		.pc_p4	(pc_p4)
	);

	instr_mem instr_mem_inst (
		.clk	(clk),
		.rden	(1'b1),		// TODO: TBD
		.addr	(pc),
		.instr	(instr)
	);
	
endmodule
