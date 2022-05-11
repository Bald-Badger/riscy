// synopsys translate_off
`timescale 1ns / 1ps
// synopsys translate_on

import defines::*;
import axi_defines::*;
import mem_defines::*;

module riscy_core_axil_qsys  (
	input	logic 				clk,
	input	logic				rst,
	input	logic				go,
	input	logic	[9:0]		boot_pc,

	/*
	* AXI lite master interface
	*/
	output	logic	[31:0]		awaddr,
	output	logic	[2:0]		awprot,
	output	logic				awvalid,
	input	logic				awready,
	output	logic	[31:0]		wdata,
	output	logic	[3:0]		wstrb,
	output	logic				wvalid,
	input	logic				wready,
	input	logic	[1:0]		bresp,
	input	logic				bvalid,
	output	logic				bready,
	output	logic	[31:0]		araddr,
	output	logic	[2:0]		arprot,
	output	logic				arvalid,
	input	logic				arready,
	input	logic	[31:0]		rdata,
	input	logic	[1:0]		rresp,
	input	logic				rvalid,
	output	logic				rready
);

	axil_interface axil_bus ();

	proc_axil proc (
		.clk					(clk),
		.rst_n					(~rst),
		.go						(go),
		.boot_pc				(boot_pc),
		.axil_bus_master		(axil_bus.axil_master)
	);

	
	always_comb begin : interface_linking
		awaddr					= axil_bus.axil_awaddr;
		awprot					= axil_bus.axil_awprot;
		awvalid					= axil_bus.axil_awvalid;
		axil_bus.axil_awready	= awready;
		wdata					= axil_bus.axil_wdata;
		wstrb					= axil_bus.axil_wstrb;
		wvalid					= axil_bus.axil_wvalid;
		axil_bus.axil_wready	= wready;
		axil_bus.axil_bresp		= bresp;
		axil_bus.axil_bvalid	= bvalid;
		bready					= axil_bus.axil_bready;
		araddr					= axil_bus.axil_araddr;
		arprot					= axil_bus.axil_arprot;
		arvalid					= axil_bus.axil_arvalid;
		axil_bus.axil_arready	= arready;
		axil_bus.axil_rdata		= rdata;
		axil_bus.axil_rresp		= rresp;
		axil_bus.axil_rvalid	= rvalid;
		rready					= axil_bus.axil_rready;
	end

endmodule : riscy_core_axil_qsys
