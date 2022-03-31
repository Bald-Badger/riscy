module sdram_axi_wrapper (
	input			clk_i,
	input			rst_i,
	
	axi_interface	axi_bus,
	sdram_interface sdram_bus
);

wire [ 15:0]		sdram_data_in_w;
wire [ 15:0]		sdram_data_out_w;
wire				sdram_data_out_en_w;

sdram_axi u_sdram (
	 .clk_i					(clk_i)
	,.rst_i					(rst_i)

	// AXI port
	,.inport_awvalid_i		(axi_bus.s_axi_awvalid)
	,.inport_awaddr_i		(axi_bus.s_axi_awaddr)
	,.inport_awid_i			(axi_bus.m_axi_awid)
	,.inport_awlen_i		(axi_bus.s_axi_awlen)
	,.inport_awburst_i		(axi_bus.s_axi_awburst)
	,.inport_wvalid_i		(axi_bus.s_axi_wvalid)
	,.inport_wdata_i		(axi_bus.s_axi_wdata)
	,.inport_wstrb_i		(axi_bus.s_axi_wstrb)
	,.inport_wlast_i		(axi_bus.s_axi_wlast)
	,.inport_bready_i		(axi_bus.s_axi_bready)
	,.inport_arvalid_i		(axi_bus.s_axi_arvalid)
	,.inport_araddr_i		(axi_bus.s_axi_araddr)
	,.inport_arid_i			(axi_bus.s_axi_arid)
	,.inport_arlen_i		(axi_bus.s_axi_arlen)
	,.inport_arburst_i		(axi_bus.s_axi_arburst)
	,.inport_rready_i		(axi_bus.s_axi_rready)
	,.inport_awready_o		(axi_bus.s_axi_awready)
	,.inport_wready_o		(axi_bus.s_axi_wready)
	,.inport_bvalid_o		(axi_bus.s_axi_bvalid)
	,.inport_bresp_o		(axi_bus.s_axi_bresp)
	,.inport_bid_o			(axi_bus.s_axi_bid)
	,.inport_arready_o		(axi_bus.s_axi_arready)
	,.inport_rvalid_o		(axi_bus.s_axi_rvalid)
	,.inport_rdata_o		(axi_bus.s_axi_rdata)
	,.inport_rresp_o		(axi_bus.s_axi_rresp)
	,.inport_rid_o			(axi_bus.s_axi_rid)
	,.inport_rlast_o		(axi_bus.s_axi_rlast)

	// SDRAM Interface
	,.sdram_clk_o			(sdram_bus.sdram_clk)
	,.sdram_cke_o			(sdram_bus.sdram_cke)
	,.sdram_cs_o			(sdram_bus.sdram_cs_n)	// yep
	,.sdram_ras_o			(sdram_bus.sdram_ras_n)	// yep
	,.sdram_cas_o			(sdram_bus.sdram_cas_n)	// yep
	,.sdram_we_o			(sdram_bus.sdram_we_n)	// yep
	,.sdram_dqm_o			(sdram_bus.sdram_dqm)
	,.sdram_addr_o			(sdram_bus.sdram_addr)
	,.sdram_ba_o			(sdram_bus.sdram_ba)
	,.sdram_data_input_i	(sdram_data_in_w)
	,.sdram_data_output_o	(sdram_data_out_w)
	,.sdram_data_out_en_o	(sdram_data_out_en_w)
);

iobuf # (
	.WIDTH	(16)
) databuf (
	.o		(sdram_data_in_w),
	.io		(sdram_bus.sdram_dq),
	.i		(sdram_data_out_w),
	.en		(~sdram_data_out_en_w)
);

endmodule : sdram_axi_wrapper
