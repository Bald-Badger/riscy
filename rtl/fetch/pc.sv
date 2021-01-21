module pc (
	//input
	pc_nxt,
	clk, rst,
	//output
	pc
);

	parameter N = 32;
	input[N-1:0] pc_nxt;
	input clk, rst;
	output[N-1:0] pc;

	dff #(
        .WIDTH(N)
        ) pc_ff (
		//outout
		.q(pc),
		//input
		.d(pc_nxt),
		.clk(clk),
		.rst(rst)
	);

endmodule
