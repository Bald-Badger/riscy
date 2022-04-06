// synopsys translate_off
`timescale 1ns / 1ps
// synopsys translate_on

import defines::*;
import mem_defines::*;

module sdram_axi_qsys #(
	// row_w + col_w + bank_w = addr_w
	parameter	SDRAM_MHZ			= 50,
	parameter	SDRAM_ADDR_W		= 25,
	parameter	SDRAM_COL_W			= 10,
	parameter	SDRAM_READ_LATENCY	= 2
) (
	input 						clk,
	input 						rst,

	// AXI interface
	input						axi_awvalid,
	input	[25:0]				axi_awaddr,
	input	[17:0]				axi_awid,
	input	[ 7:0]				axi_awlen,
	input	[ 1:0]				axi_awburst,
	input						axi_wvalid,
	input	[31:0]				axi_wdata,
	input	[ 3:0]				axi_wstrb,
	input						axi_wlast,
	input						axi_bready,
	input						axi_arvalid,
	input	[25:0]				axi_araddr,
	input	[17:0]				axi_arid,
	input	[ 7:0]				axi_arlen,
	input	[ 1:0]				axi_arburst,
	input						axi_rready,
	output						axi_awready,
	output						axi_wready,
	output						axi_bvalid,
	output	[ 1:0]				axi_bresp,
	output	[17:0]				axi_bid,
	output						axi_arready,
	output						axi_rvalid,
	output	[31:0]				axi_rdata,
	output	[ 1:0]				axi_rresp,
	output	[17:0]				axi_rid,
	output						axi_rlast,

	// axi signal that are not used
	input	[ 2:0]				axi_awsize,
	input	[ 2:0]				axi_arsize,

	// SDRAM interface
	output						sdram_clk,
	output						sdram_cke,
	output	[ 1: 0]				sdram_dqm,
	output						sdram_cas_n,
	output						sdram_ras_n,
	output						sdram_we_n,
	output						sdram_cs_n,
	output	[ 1: 0]				sdram_ba,
	output	[12: 0]				sdram_addr,
	inout	[15: 0]				sdram_dq
);

	wire [ 15:0]				sdram_data_in_w;
	wire [ 15:0]				sdram_data_out_w;
	wire						sdram_data_out_en_w;

	iobuf # (
		.WIDTH					(16)
	) databuf (
		.o						(sdram_data_in_w),
		.io						(sdram_dq),
		.i						(sdram_data_out_w),
		.en						(~sdram_data_out_en_w)
	);

	sdram_axi # (
		.SDRAM_MHZ				(SDRAM_MHZ),
		.SDRAM_ADDR_W			(SDRAM_ADDR_W),
		.SDRAM_COL_W			(SDRAM_COL_W),
		.SDRAM_READ_LATENCY		(SDRAM_READ_LATENCY)
	) u_sdram (
		.clk_i					(clk)
		,.rst_i					(rst)

		// AXI port
		,.inport_awvalid_i		(axi_awvalid)
		,.inport_awaddr_i		(axi_awaddr)
		,.inport_awid_i			(axi_awid)
		,.inport_awlen_i		(axi_awlen)
		,.inport_awburst_i		(axi_awburst)
		,.inport_wvalid_i		(axi_wvalid)
		,.inport_wdata_i		(axi_wdata)
		,.inport_wstrb_i		(axi_wstrb)
		,.inport_wlast_i		(axi_wlast)
		,.inport_bready_i		(axi_bready)
		,.inport_arvalid_i		(axi_arvalid)
		,.inport_araddr_i		(axi_araddr)
		,.inport_arid_i			(axi_arid)
		,.inport_arlen_i		(axi_arlen)
		,.inport_arburst_i		(axi_arburst)
		,.inport_rready_i		(axi_rready)
		,.inport_awready_o		(axi_awready)
		,.inport_wready_o		(axi_wready)
		,.inport_bvalid_o		(axi_bvalid)
		,.inport_bresp_o		(axi_bresp)
		,.inport_bid_o			(axi_bid)
		,.inport_arready_o		(axi_arready)
		,.inport_rvalid_o		(axi_rvalid)
		,.inport_rdata_o		(axi_rdata)
		,.inport_rresp_o		(axi_rresp)
		,.inport_rid_o			(axi_rid)
		,.inport_rlast_o		(axi_rlast)

		// SDRAM Interface
		,.sdram_clk_o			(sdram_clk)
		,.sdram_cke_o			(sdram_cke)
		,.sdram_cs_o			(sdram_cs_n)	// yep
		,.sdram_ras_o			(sdram_ras_n)	// yep
		,.sdram_cas_o			(sdram_cas_n)	// yep
		,.sdram_we_o			(sdram_we_n)	// yep
		,.sdram_dqm_o			(sdram_dqm)
		,.sdram_addr_o			(sdram_addr)
		,.sdram_ba_o			(sdram_ba)
		,.sdram_data_input_i	(sdram_data_in_w)
		,.sdram_data_output_o	(sdram_data_out_w)
		,.sdram_data_out_en_o	(sdram_data_out_en_w)
	);

endmodule : sdram_axi_qsys
