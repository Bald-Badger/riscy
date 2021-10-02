import defines::*;

module top (
	input logic osc_clk,
	input logic but_rst_n
);
	logic	clk, rst_n, locked;
	logic	ebreak_start;

	assign rst_n = (but_rst_n & locked);
	
	pll	pll_inst (
	.areset ( but_rst_n ),
	.inclk0 ( osc_clk ),
	.c0 ( clk ),
	.locked ( locked )
	);

	proc processor_inst (
		.clk			(clk),
		.rst_n			(rst_n),
		.ebreak_start	(ebreak_start)
	);
	
endmodule
