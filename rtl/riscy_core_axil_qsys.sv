// synopsys translate_off
`timescale 1ns / 1ps
// synopsys translate_on

import defines::*;
import axi_defines::*;

module riscy_core_axil_qsys (
	input logic 					clk,
	input logic						rst,

	/*
	 * AXI master interface
	 */
	output logic [7:0]				awid,
	output logic [7:0]				wid,
	output logic [31:0]				awaddr,
	output logic [3:0]				awlen,
	output logic [2:0]				awsize,
	output logic [1:0]				awburst,
	output logic [1:0]				awlock,
	output logic [3:0]				awcache,
	output logic [2:0]				awprot,
	//output logic [3:0]				awqos,
	//output logic [3:0]				awregion,
	output logic					awuser,
	output logic					awvalid,
	input  logic					awready,
	output logic [31:0]				wdata,
	output logic [3:0]				wstrb,
	output logic					wlast,
	//output logic					wuser,
	output logic					wvalid,
	input  logic					wready,
	input  logic [7:0]				bid,
	input  logic [1:0]				bresp,
	//input  logic					buser,
	input  logic					bvalid,
	output logic					bready,
	output logic [7:0]				arid,
	output logic [31:0]				araddr,
	output logic [3:0]				arlen,
	output logic [2:0]				arsize,
	output logic [1:0]				arburst,
	output logic [1:0]				arlock,
	output logic [3:0]				arcache,
	output logic [2:0]				arprot,
	//output logic [3:0]				arqos,
	//output logic [3:0]				arregion,
	output logic					aruser,
	output logic					arvalid,
	input  logic					arready,
	input  logic [7:0]				rid,
	input  logic [31:0]				rdata,
	input  logic [1:0]				rresp,
	input  logic					rlast,
	//input  logic					ruser,
	input  logic					rvalid,
	output logic					rready
);

	axi_interface axi_bus (
		.clk			(clk),
		.rst			(rst)
	);

	proc_axi core (
		.clk			(clk),
		.rst_n			(~rst),
		.axi_bus_master	(axi_bus)
	);

	always_comb begin
		awid					= axi_bus.m_axi_awid;
		wid						= awid;	// this signal in not in the spec
		awaddr					= axi_bus.m_axi_awaddr;
		awlen					= axi_bus.m_axi_awlen;
		awsize					= axi_bus.m_axi_awsize;
		awburst					= axi_bus.m_axi_awburst;
		awlock					= axi_bus.m_axi_awlock;
		awcache					= axi_bus.m_axi_awcache;
		awprot					= axi_bus.m_axi_awprot;
		//awqos					= axi_bus.m_axi_awqos;
		awuser					= axi_bus.m_axi_awuser;
		awvalid					= axi_bus.m_axi_awvalid;
		wdata					= axi_bus.m_axi_wdata;
		wstrb					= axi_bus.m_axi_wstrb;
		wlast					= axi_bus.m_axi_wlast;
		//wuser					= axi_bus.m_axi_wuser;
		wvalid					= axi_bus.m_axi_wvalid;
		bready					= axi_bus.m_axi_bready;
		arid					= axi_bus.m_axi_arid;
		araddr					= axi_bus.m_axi_araddr;
		arlen					= axi_bus.m_axi_arlen;
		arsize					= axi_bus.m_axi_arsize;
		arburst					= axi_bus.m_axi_arburst;
		arlock					= axi_bus.m_axi_arlock;
		arcache					= axi_bus.m_axi_arcache;
		//arqos					= axi_bus.m_axi_arqos;
		aruser					= axi_bus.m_axi_aruser;
		arprot					= axi_bus.m_axi_arprot;
		arvalid					= axi_bus.m_axi_arvalid;
		rready					= axi_bus.m_axi_rready;

		//axi_bus.m_axi_buser		= buser;
		//axi_bus.m_axi_ruser		= ruser;
		axi_bus.m_axi_awready	= awready;
		axi_bus.m_axi_wready	= wready;
		axi_bus.m_axi_bid		= bid;
		axi_bus.m_axi_bresp		= bresp;
		axi_bus.m_axi_bvalid	= bvalid;
		axi_bus.m_axi_arready	= arready;
		axi_bus.m_axi_rid		= rid;
		axi_bus.m_axi_rdata		= rdata;
		axi_bus.m_axi_rresp		= rresp;
		axi_bus.m_axi_rlast		= rlast;
		axi_bus.m_axi_rvalid	= rvalid;
	end

endmodule : riscy_core_axil_qsys
