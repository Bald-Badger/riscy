`include "../opcode.svh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module dffe (
	input clk,
	input en,
	input rst_n,
	input d,
	output q
 );
 
 parameter WIDTH  = XLEN;
 
 dff #(.WIDTH(WIDTH)) dffe_inst (
	 // Output
	.q(q),
	// Input
	.d(({WIDTH{en}}&d) | (q&~{WIDTH{en}})),
	.clk(clk),
	.rst_n(rst_n)
);

endmodule
