import defines::*;

// synopsys translate_off
`timescale 1 ns / 1 ps
// synopsys translate_on

module dff_wrap #(
	WIDTH = XLEN
) (
	input 	logic 	clk,
	input 	logic 	rst_n,
	input 	logic	[WIDTH-1:0]	d,
	output	logic	[WIDTH-1:0]	q
);

	reg     [WIDTH-1:0]	state;

	assign #(1) q = state;
	//assign 	q = state;
	
	always_ff @ (posedge clk or negedge rst_n)
		if (!rst_n)
			state <= 0;
		else 
			state <= d;

endmodule
