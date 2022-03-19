import defines::*;
import axi_defines::*;
`timescale 1ns / 1ps

module axi_ram_sv_wrapper # 
(
    // Width of data bus in bits
    parameter DATA_WIDTH = 32,
    // Width of address bus in bits
    parameter ADDR_WIDTH = 16,
    // Width of wstrb (width of data bus in words)
    parameter STRB_WIDTH = (DATA_WIDTH/8),
    // Extra pipeline register on output
    parameter PIPELINE_OUTPUT = 0
) (
	input logic clk,
	input logic rst,
	axi_interface axi_bus
);

	axi_ram # (
		.DATA_WIDTH			(DATA_WIDTH),
		.ADDR_WIDTH			(ADDR_WIDTH),
		.STRB_WIDTH			(DATA_WIDTH/8),
		.PIPELINE_OUTPUT	(PIPELINE_OUTPUT)
	) axi_ram (
		.clk				(clk),
		.rst				(rst),
		.s_axi_awid			(axi_bus.s_axi_awid),
		.s_axi_awaddr		(axi_bus.s_axi_awaddr),
		.s_axi_awlen		(axi_bus.s_axi_awlen),
		.s_axi_awsize		(axi_bus.s_axi_awsize),
		.s_axi_awburst		(axi_bus.s_axi_awburst),
		.s_axi_awlock		(axi_bus.s_axi_awlock),
		.s_axi_awcache		(axi_bus.s_axi_awcache),
		.s_axi_awprot		(axi_bus.s_axi_awprot),
		.s_axi_awvalid		(axi_bus.s_axi_awvalid),
		.s_axi_awready		(axi_bus.s_axi_awready),
		.s_axi_wdata		(axi_bus.s_axi_wdata),
		.s_axi_wstrb		(axi_bus.s_axi_wstrb),
		.s_axi_wlast		(axi_bus.s_axi_wlast),
		.s_axi_wvalid		(axi_bus.s_axi_wvalid),
		.s_axi_wready		(axi_bus.s_axi_wready),
		.s_axi_bid			(axi_bus.s_axi_bid),
		.s_axi_bresp		(axi_bus.s_axi_bresp),
		.s_axi_bvalid		(axi_bus.s_axi_bvalid),
		.s_axi_bready		(axi_bus.s_axi_bready),
		.s_axi_arid			(axi_bus.s_axi_arid),
		.s_axi_araddr		(axi_bus.s_axi_araddr),
		.s_axi_arlen		(axi_bus.s_axi_arlen),
		.s_axi_arsize		(axi_bus.s_axi_arsize),
		.s_axi_arburst		(axi_bus.s_axi_arburst),
		.s_axi_arlock		(axi_bus.s_axi_arlock),
		.s_axi_arcache		(axi_bus.s_axi_arcache),
		.s_axi_arprot		(axi_bus.s_axi_arprot),
		.s_axi_arvalid		(axi_bus.s_axi_arvalid),
		.s_axi_arready		(axi_bus.s_axi_arready),
		.s_axi_rid			(axi_bus.s_axi_rid),
		.s_axi_rdata		(axi_bus.s_axi_rdata),
		.s_axi_rresp		(axi_bus.s_axi_rresp),
		.s_axi_rlast		(axi_bus.s_axi_rlast),
		.s_axi_rvalid		(axi_bus.s_axi_rvalid),
		.s_axi_rready		(axi_bus.s_axi_rready)
	);

endmodule : axi_ram_sv_wrapper
