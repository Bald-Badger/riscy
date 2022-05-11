module seg_axil_wrapper (
	input	logic				clk,
	input	logic				rst,

	axil_interface.axil_slave	s00
);

	seg_axil segs (
		.clk	(clk),
		.rst	(rst),

		// AXI inputs
		.cfg_awvalid_i	(s00.axil_awvalid),
		.cfg_awaddr_i	(s00.axil_awaddr),
		.cfg_wvalid_i	(s00.axil_wvalid),
		.cfg_wdata_i	(s00.axil_wdata),
		.cfg_wstrb_i	(s00.axil_wstrb),
		.cfg_bready_i	(s00.axil_bready),
		.cfg_arvalid_i	(s00.axil_arvalid),
		.cfg_araddr_i	(s00.axil_araddr),
		.cfg_rready_i	(s00.axil_rready),

		// Outputs
		.cfg_awready_o	(s00.axil_awready),
		.cfg_wready_o	(s00.axil_wready),
		.cfg_bvalid_o	(s00.axil_bvalid),
		.cfg_bresp_o	(s00.axil_bresp),
		.cfg_arready_o	(s00.axil_arready),
		.cfg_rvalid_o	(s00.axil_rvalid),
		.cfg_rdata_o	(s00.axil_rdata),
		.cfg_rresp_o	(s00.axil_rresp),

		// unused AXI signal
		.cfg_awprot_i	(s00.axil_awprot),
		.cfg_arprot_i	(s00.axil_arprot),

		.hex0			(),
		.hex1			(),
		.hex2			(),
		.hex3			(),
		.hex4			(),
		.hex5			()
	);
	
endmodule : seg_axil_wrapper
