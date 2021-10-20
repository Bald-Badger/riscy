//processor instance with peripherals

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

module proc_hier (
	input	logic osc_clk,
	input	logic but_rst_n,
	output	logic ebreak_start
);
	logic	rst_n, locked;
	logic	clk_50m;			//main clock
	logic	clk_100m;			//sdram controller clk
	logic	clk_100m_shift;		//shifted clk for sdram output

	assign	rst_n = (but_rst_n & locked);
	
	pll_clk	pll_inst (
		.areset			(~but_rst_n),
		.inclk0			(osc_clk),
		.locked			(locked),
		.c0				(clk_50m),
		.c1				(clk_100m),
		.c2				(clk_100m_shift)
	);

	proc processor_inst (
		.clk			(clk_50m),
		.clk_100m		(clk_100m),
		.clk_100m_shift	(clk_100m_shift),
		.rst_n			(rst_n),
		.ebreak_start	(ebreak_start)
	);
	
endmodule