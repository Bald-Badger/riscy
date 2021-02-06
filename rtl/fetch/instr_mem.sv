`include "../opcode.svh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module instr_mem (
	input data_t	addr,
	input 			clk,
	input 			rden,

	output data_t	instr
);

	parameter DEPTH = 256;

	mem #(
		.ENTRY  (DEPTH), 
		.WIDTH  (XLEN)
		) instr_mem_inst (
		.address(addr),
		.clk	(clk),
		.data	(NULL),
		.rden	(rden),
		.wren	(1'b0),
		.q		(instr)
	);

endmodule
