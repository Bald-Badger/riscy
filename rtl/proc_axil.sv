// top module of the processor

// synopsys translate_off
`timescale 1ns / 1ps
// synopsys translate_on

import defines::*;
import axi_defines::*;

module proc_axil (
	input	logic 		clk,					// clock from PLL, frequency is defines::FREQ
	input	logic 		rst_n,					// global reset
	input	logic		go,

	axi_lite_interface	axil_bus_master
);

	axi_lite_interface data_bus_lite (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_lite_interface instr_bus_lite (
		.clk	(clk),
		.rst	(~rst_n)
	);
	
	axil_crossbar_2x1_wrapper cross_bar (
		.clk	(clk),
		.rst	(~rst_n),
		.s00	(data_bus_lite),
		.s01	(instr_bus_lite),
		.m00	(axil_bus_master)
	);

	proc processor (
		.clk			(clk),
		.rst_n			(rst_n),
		.go				(go),
		.data_bus		(data_bus_lite),
		.instr_bus		(instr_bus_lite)
	);

endmodule : proc_axil
