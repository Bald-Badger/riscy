// top module of the processor

// synopsys translate_off
`timescale 1ns / 1ps
// synopsys translate_on

import defines::*;
import axi_defines::*;

module proc_axi (
	input	logic 		clk,					// clock from PLL, frequency is defines::FREQ
	input	logic 		rst_n,					// global reset

	axi_interface	axi_bus_master
);

	axi_lite_interface data_bus_lite (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_lite_interface instr_bus_lite (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_interface data_bus (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_interface instr_bus (
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
		.s00	(instr_bus),
		.s01	(data_bus),
		.m00	(axi_bus_master)
	);

	proc processor (
		.clk			(clk),
		.rst_n			(rst_n),
		.data_bus		(data_bus_lite),
		.instr_bus		(instr_bus_lite)
	);

endmodule : proc_axi
