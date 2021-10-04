// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;
module top_with_clock();

	logic	clk, rst_n;
	logic	ebreak_start;

	clkrst #(
		.FREQ			(FREQ)
	) clk_rst_gen_nst (
		.clk			(clk),
		.rst_n			(rst_n)
	);

	proc_hier proc_hier_inst (
		.osc_clk			(clk),
		.but_rst_n			(rst_n),
		.ebreak_start	(ebreak_start)
	);
	
endmodule
