module axil_crossbar_2x1_wrapper (
	input	logic				clk,
	input	logic				rst,
	
	axil_interface.axil_slave	s00,
	axil_interface.axil_slave	s01,
	axil_interface.axil_master	m00
);

	axil_crossbar_2x1 crossbar (
		.clk				(clk),
		.rst				(rst),

		// s00
		.s00_axil_awaddr	(s00.axil_awaddr),
		.s00_axil_awprot	(s00.axil_awprot),
		.s00_axil_awvalid	(s00.axil_awvalid),
		.s00_axil_awready	(s00.axil_awready),
		.s00_axil_wdata		(s00.axil_wdata),
		.s00_axil_wstrb		(s00.axil_wstrb),
		.s00_axil_wvalid	(s00.axil_wvalid),
		.s00_axil_wready	(s00.axil_wready),
		.s00_axil_bresp		(s00.axil_bresp),
		.s00_axil_bvalid	(s00.axil_bvalid),
		.s00_axil_bready	(s00.axil_bready),
		.s00_axil_araddr	(s00.axil_araddr),
		.s00_axil_arprot	(s00.axil_arprot),
		.s00_axil_arvalid	(s00.axil_arvalid),
		.s00_axil_arready	(s00.axil_arready),
		.s00_axil_rdata		(s00.axil_rdata),
		.s00_axil_rresp		(s00.axil_rresp),
		.s00_axil_rvalid	(s00.axil_rvalid),
		.s00_axil_rready	(s00.axil_rready),

		// s01
		.s01_axil_awaddr	(s01.axil_awaddr),
		.s01_axil_awprot	(s01.axil_awprot),
		.s01_axil_awvalid	(s01.axil_awvalid),
		.s01_axil_awready	(s01.axil_awready),
		.s01_axil_wdata		(s01.axil_wdata),
		.s01_axil_wstrb		(s01.axil_wstrb),
		.s01_axil_wvalid	(s01.axil_wvalid),
		.s01_axil_wready	(s01.axil_wready),
		.s01_axil_bresp		(s01.axil_bresp),
		.s01_axil_bvalid	(s01.axil_bvalid),
		.s01_axil_bready	(s01.axil_bready),
		.s01_axil_araddr	(s01.axil_araddr),
		.s01_axil_arprot	(s01.axil_arprot),
		.s01_axil_arvalid	(s01.axil_arvalid),
		.s01_axil_arready	(s01.axil_arready),
		.s01_axil_rdata		(s01.axil_rdata),
		.s01_axil_rresp		(s01.axil_rresp),
		.s01_axil_rvalid	(s01.axil_rvalid),
		.s01_axil_rready	(s01.axil_rready),

		// m00
		.m00_axil_awaddr	(m00.axil_awaddr),
		.m00_axil_awprot	(m00.axil_awprot),
		.m00_axil_awvalid	(m00.axil_awvalid),
		.m00_axil_awready	(m00.axil_awready),
		.m00_axil_wdata		(m00.axil_wdata),
		.m00_axil_wstrb		(m00.axil_wstrb),
		.m00_axil_wvalid	(m00.axil_wvalid),
		.m00_axil_wready	(m00.axil_wready),
		.m00_axil_bresp		(m00.axil_bresp),
		.m00_axil_bvalid	(m00.axil_bvalid),
		.m00_axil_bready	(m00.axil_bready),
		.m00_axil_araddr	(m00.axil_araddr),
		.m00_axil_arprot	(m00.axil_arprot),
		.m00_axil_arvalid	(m00.axil_arvalid),
		.m00_axil_arready	(m00.axil_arready),
		.m00_axil_rdata		(m00.axil_rdata),
		.m00_axil_rresp		(m00.axil_rresp),
		.m00_axil_rvalid	(m00.axil_rvalid),
		.m00_axil_rready	(m00.axil_rready)
	);
	
endmodule : axil_crossbar_2x1_wrapper
