import defines::*;
import axi_defines::*;
`timescale 1ns / 1ps

module axil_ram_sv_wrapper # 
(
    // Width of data bus in bits
    parameter DATA_WIDTH = 32,
    // Width of address bus in bits
    parameter ADDR_WIDTH = 16,
    // Width of wstrb (width of data bus in words)
    parameter STRB_WIDTH = (DATA_WIDTH/8),
    // Extra pipeline register on output
    parameter PIPELINE_OUTPUT = 1
) (
	input logic clk,
	input logic rst,
	axi_lite_interface axil_bus
);

	axil_ram # (
		.DATA_WIDTH			(DATA_WIDTH),
		.ADDR_WIDTH			(ADDR_WIDTH),
		.STRB_WIDTH			(DATA_WIDTH/8),
		.PIPELINE_OUTPUT	(PIPELINE_OUTPUT)
	) axil_ram (
		.clk				(clk),
		.rst				(rst),
		.s_axil_awaddr		(axil_bus.s_axil_awaddr),
		.s_axil_awprot		(axil_bus.s_axil_awprot),
		.s_axil_awvalid		(axil_bus.s_axil_awvalid),
		.s_axil_awready		(axil_bus.s_axil_awready),
		.s_axil_wdata		(axil_bus.s_axil_wdata),
		.s_axil_wstrb		(axil_bus.s_axil_wstrb),
		.s_axil_wvalid		(axil_bus.s_axil_wvalid),
		.s_axil_wready		(axil_bus.s_axil_wready),
		.s_axil_bresp		(axil_bus.s_axil_bresp),
		.s_axil_bvalid		(axil_bus.s_axil_bvalid),
		.s_axil_bready		(axil_bus.s_axil_bready),
		.s_axil_araddr		(axil_bus.s_axil_araddr),
		.s_axil_arprot		(axil_bus.s_axil_arprot),
		.s_axil_arvalid		(axil_bus.s_axil_arvalid),
		.s_axil_arready		(axil_bus.s_axil_arready),
		.s_axil_rdata		(axil_bus.s_axil_rdata),
		.s_axil_rresp		(axil_bus.s_axil_rresp),
		.s_axil_rvalid		(axil_bus.s_axil_rvalid),
		.s_axil_rready		(axil_bus.s_axil_rready)
	);

endmodule : axil_ram_sv_wrapper
