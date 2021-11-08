//processor instance with peripherals

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

module proc_hier (
	input	logic			osc_clk,
	input	logic			but_rst_n,
	output	logic			ebreak_start,
	// SDRAM hardware pins
	output	logic			sdram_clk, 
	output	logic			sdram_cke,
	output	logic			sdram_cs_n,   
	output	logic			sdram_ras_n,
	output	logic			sdram_cas_n,
	output	logic        	sdram_we_n,
	output	logic	[ 1:0]	sdram_ba,
	output	logic	[12:0]	sdram_addr,
	inout	wire	[15:0]	sdram_data,
	output	logic	[ 1:0]	sdram_dqm
);
	logic	rst_n, locked;		//high on locked meand system clock is now stable
	logic	clk;				//main clock, freq = defines::FREQ
	logic	clk_100m;			//sdram controller clk
	logic	clk_100m_shift;		//shifted clk for sdram output

	assign	rst_n = (but_rst_n & locked);
	
	pll_clk	pll_inst (
		.areset			(~but_rst_n),
		.inclk0			(osc_clk),
		.locked			(locked),
		.c0				(clk),				// main system clock
		.c1				(clk_100m),			// SDRAM IO FIFO clock
		.c2				(clk_100m_shift)	// SDRAM clock
	);

	proc processor_inst (
		.clk			(clk),
		.clk_100m		(clk_100m),
		.clk_100m_shift	(clk_100m_shift),
		.rst_n			(rst_n),
		.ebreak_start	(ebreak_start),

		// SDRAM hardware pins
		.sdram_clk		(sdram_clk),
		.sdram_cke		(sdram_cke),
		.sdram_cs_n		(sdram_cs_n),
		.sdram_ras_n	(sdram_ras_n),
		.sdram_cas_n	(sdram_cas_n),
		.sdram_we_n		(sdram_we_n),
		.sdram_ba		(sdram_ba),
		.sdram_addr		(sdram_addr),
		.sdram_data		(sdram_data),
		.sdram_dqm		(sdram_dqm)
	);
	
endmodule : proc_hier
