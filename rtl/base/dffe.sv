module dffe (
	input clk,
	input en,
	input rst,
	input d,
	output q
 );
 
 parameter WIDTH = 32;
 
 dff #(.WIDTH(WIDTH)) dffe_inst (
	 // Output
	.q(q),
	// Input
	.d(({WIDTH{en}}&d) | (q&~{WIDTH{en}})),
	.clk(clk),
	.rst(rst)
);

endmodule
