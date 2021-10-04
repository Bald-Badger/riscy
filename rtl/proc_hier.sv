//processor instance with peripherals

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

module proc_hier (
	input logic osc_clk,
	input logic but_rst_n,
	output logic ebreak_start
);
	logic	clk, rst_n, locked;

	assign rst_n = (but_rst_n & locked);
	
	pll	pll_inst (
		.areset		(~but_rst_n),
		.inclk0		(osc_clk),
		.c0			(clk),
		.locked		(locked)
	);

	proc processor_inst (
		.clk		(clk),
		.rst_n		(rst_n),
		.ebreak_start	(ebreak_start)
	);
	
endmodule