`include "../opcode.svh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

// TODO: use little endian!

module instr_mem (
	input data_t	addr,
	input 			clk,
	input 			rden,

	output data_t	instr
);

	mem #(
		.ADDR_WIDTH	(XLEN),
		.BYTES		(BYTES)
	) instr_mem_inst (
		.waddr		(NULL),
		.raddr		(addr),
		.be			(W_EN),
		.wdata		(NULL),
		.we			(DISABLE),
		.re			(rden),
		.clk		(clk),
		.q			(instr)
	);

endmodule : instr_mem
