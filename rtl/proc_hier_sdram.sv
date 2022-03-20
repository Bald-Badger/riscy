// synopsys translate_off
`timescale 1 ns / 1 ps
// synopsys translate_on

import defines::*;

module proc_hier_sdram (
	input	logic			osc_clk,
	input	logic			but_rst_n,
	output	logic			ebreak_start,
	sdram_interface			sdram_bus
);

	logic clk, clk_sdram, rst_n, locked;

	assign rst_n = (but_rst_n & locked);

	pll_clk	pll_inst (
		.areset			(~but_rst_n),
		.inclk0			(osc_clk),
		.locked			(locked),
		.c0				(clk),			// main system clock
		.c1				(clk_sdram)		// SDRAM clock
	);

	axi_interface data_bus (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_lite_interface data_bus_lite (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_interface instr_bus (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_lite_interface instr_bus_lite (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_interface ram_bus (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axil_axi_adapter # (
		.USER_ID	(0)
	) instr_axil_to_axi_adapter (
		.axil_bus	(instr_bus_lite),
		.axi_bus	(instr_bus)
	);

	axil_axi_adapter # (
		.USER_ID	(1)
	) data_axil_to_axi_adapter (
		.axil_bus	(data_bus_lite),
		.axi_bus	(data_bus)
	);

	axi_interconnect_2x1_wrapper inter_connect (
		.clk	(clk),
		.rst	(~rst_n),
		.s00	(data_bus),
		.s01	(instr_bus),
		.m00	(ram_bus)
	);

	proc_axil proc_dut (
		.clk			(clk),
		.rst_n			(rst_n),
		.ebreak_start	(ebreak_start),
		.data_bus		(data_bus_lite),
		.instr_bus		(instr_bus_lite)
	);	

	sdram_axi_wrapper sdram_ctrl (
		.clk_i			(clk),
		.rst_i			(~rst_n),
		.axi_bus		(ram_bus),
		.sdram_bus		(sdram_bus)
	);
	
endmodule : proc_hier_sdram
