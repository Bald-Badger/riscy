// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

module top_with_sdram (
	input logic clk,
	input logic rst_n
);

	logic			ebreak_start;
	logic			sdram_clk;
	logic			sdram_cke;
	logic			sdram_cs_n;
	logic			sdram_ras_n;
	logic			sdram_cas_n;
	logic        	sdram_we_n;
	logic	[ 1:0]	sdram_ba;
	logic	[12:0]	sdram_addr;
	wire	[15:0]	sdram_data;
	logic	[ 1:0]	sdram_dqm;


	proc_hier proc_dut (
		.osc_clk		(clk),
		.but_rst_n		(rst_n),
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


	sdr sdram_functional_model(    
		.Clk			(sdram_clk),
		.Cke			(sdram_cke),
		.Cs_n			(sdram_cs_n),
		.Ras_n			(sdram_ras_n),
		.Cas_n			(sdram_cas_n),
		.We_n			(sdram_we_n),
		.Ba				(sdram_ba),
		.Addr			(sdram_addr),
		.Dq				(sdram_data),
		.Dqm			(sdram_dqm)
	);

endmodule : top_with_sdram