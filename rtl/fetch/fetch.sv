`include "../opcode.vh"

module fetch(
	// general input
	input clk, 
	input rst_n,

	// input
	input	[`XLEN-1:0] pc_bj,
	input 				pc_sel,

	// output
	output	[`XLEN-1:0]	pc_p4,
	output	[`XLEN-1:0]	pc,
	output	[`XLEN-1:0]	instr,
	output	[4:0]		rd
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
