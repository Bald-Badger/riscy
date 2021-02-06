`include "../opcode.svh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module dff(
	clk,
	rst_n,
	d,
	q
);

parameter WIDTH = XLEN;

    input 			    clk;
	input 			    rst_n;
	input	[WIDTH-1:0]	d;
	output 	[WIDTH-1:0]	q;

	reg     [WIDTH:0]	state;
	assign 	q = state;
	
	always_ff @ (posedge clk or negedge rst_n)
		if (!rst_n)
			state <= 0;
		else 
			state <= d;

endmodule
