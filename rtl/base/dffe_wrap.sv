import defines::*;

// synopsys translate_off
// `timescale 1 ps / 1 ps
// synopsys translate_on

// quartus have dffe primitive but not parameterizable, i dont like it

module dffe_wrap #(
	WIDTH = XLEN
) (
	input clk,
	input en,
	input rst_n,
	input logic[WIDTH-1:0] d,
	output logic[WIDTH-1:0] q
);
 
 dff_wrap #(.WIDTH(WIDTH)) dff_inst (
	 // Output
	.q(q),
	// Input
	.d(({WIDTH{en}}&d) | (q&~{WIDTH{en}})),
	.clk(clk),
	.rst_n(rst_n)
);

endmodule
