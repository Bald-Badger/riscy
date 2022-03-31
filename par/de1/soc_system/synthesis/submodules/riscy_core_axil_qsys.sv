// synopsys translate_off
`timescale 1ns / 1ps
// synopsys translate_on

import defines::*;
import axi_defines::*;
import mem_defines::*;

module riscy_core_axil_qsys  (
	input logic 					clk,
	input logic						rst,

	/*
	* AXI lite master interfaces
	*/
	output	logic	[25:0]				awaddr,
	output	logic	[2:0]				awprot,
	output	logic						awvalid,
	input	logic						awready,
	output	logic	[31:0]				wdata,
	output	logic	[3:0]				wstrb,
	output	logic						wvalid,
	input	logic						wready,
	input	logic	[1:0]				bresp,
	input	logic						bvalid,
	output	logic						bready,
	output	logic	[25:0]				araddr,
	output	logic	[2:0]				arprot,
	output	logic						arvalid,
	input	logic						arready,
	input	logic	[31:0]				rdata,
	input	logic	[1:0]				rresp,
	input	logic						rvalid,
	output	logic						rready
);

	axi_lite_interface axil_bus (
		.clk					(clk),
		.rst					(rst)
	);

	proc_axil proc (
		.clk					(clk),
		.rst_n					(~rst),
		.axil_bus_master		(axil_bus)
	);

	
	always_comb begin : interface_linking
		awaddr					= axil_bus.m_axil_awaddr;
		awprot					= axil_bus.m_axil_awprot;
		awvalid					= axil_bus.m_axil_awvalid;
		axil_bus.s_axil_awready	= awready;
		wdata					= axil_bus.m_axil_wdata;
		wstrb					= axil_bus.m_axil_wstrb;
		wvalid					= axil_bus.m_axil_wvalid;
		axil_bus.s_axil_wready	= wready;
		axil_bus.s_axil_bresp	= bresp;
		axil_bus.s_axil_bvalid	= bvalid;
		bready					= axil_bus.m_axil_bready;
		araddr					= axil_bus.m_axil_araddr;
		arprot					= axil_bus.m_axil_arprot;
		arvalid					= axil_bus.m_axil_arvalid;
		axil_bus.s_axil_arready	= arready;
		axil_bus.s_axil_rdata	= rdata;
		axil_bus.s_axil_rresp	= rresp;
		axil_bus.s_axil_rvalid	= rvalid;
		rready					= axil_bus.m_axil_rready;
	end

endmodule : riscy_core_axil_qsys
