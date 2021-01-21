`include "../opcode.vh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module instr_mem (
	address,
	clk,
	rden,
	q
);
	input		[`XLEN-1:0] address;
	input					clk;
	input					rden;
	output	reg	[`XLEN-1:0] q;

	mem #(
		.ENTRY  (1024), 
		.WIDTH  (`XLEN)
		) instr_mem_inst (
		.address(address),
		.clk	(clk),
		.data	(32'bX),
		.rden	(rden),
		.wren	(1'b0),
		.q		(q)
	);

endmodule
