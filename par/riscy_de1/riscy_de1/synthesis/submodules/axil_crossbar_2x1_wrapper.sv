module axil_crossbar_2x1_wrapper (
	input logic clk,
	input logic rst,
	axi_lite_interface s00,
	axi_lite_interface s01,
	axi_lite_interface m00
);

	axil_crossbar_2x1 crossbar (
		.clk				(clk),
		.rst				(rst),

		// s00
		.s00_axil_awaddr	(s00.s_axil_awaddr),
		.s00_axil_awprot	(s00.s_axil_awprot),
		.s00_axil_awvalid	(s00.s_axil_awvalid),
		.s00_axil_awready	(s00.s_axil_awready),
		.s00_axil_wdata		(s00.s_axil_wdata),
		.s00_axil_wstrb		(s00.s_axil_wstrb),
		.s00_axil_wvalid	(s00.s_axil_wvalid),
		.s00_axil_wready	(s00.s_axil_wready),
		.s00_axil_bresp		(s00.s_axil_bresp),
		.s00_axil_bvalid	(s00.s_axil_bvalid),
		.s00_axil_bready	(s00.s_axil_bready),
		.s00_axil_araddr	(s00.s_axil_araddr),
		.s00_axil_arprot	(s00.s_axil_arprot),
		.s00_axil_arvalid	(s00.s_axil_arvalid),
		.s00_axil_arready	(s00.s_axil_arready),
		.s00_axil_rdata		(s00.s_axil_rdata),
		.s00_axil_rresp		(s00.s_axil_rresp),
		.s00_axil_rvalid	(s00.s_axil_rvalid),
		.s00_axil_rready	(s00.s_axil_rready),

		// s01
		.s01_axil_awaddr	(s01.s_axil_awaddr),
		.s01_axil_awprot	(s01.s_axil_awprot),
		.s01_axil_awvalid	(s01.s_axil_awvalid),
		.s01_axil_awready	(s01.s_axil_awready),
		.s01_axil_wdata		(s01.s_axil_wdata),
		.s01_axil_wstrb		(s01.s_axil_wstrb),
		.s01_axil_wvalid	(s01.s_axil_wvalid),
		.s01_axil_wready	(s01.s_axil_wready),
		.s01_axil_bresp		(s01.s_axil_bresp),
		.s01_axil_bvalid	(s01.s_axil_bvalid),
		.s01_axil_bready	(s01.s_axil_bready),
		.s01_axil_araddr	(s01.s_axil_araddr),
		.s01_axil_arprot	(s01.s_axil_arprot),
		.s01_axil_arvalid	(s01.s_axil_arvalid),
		.s01_axil_arready	(s01.s_axil_arready),
		.s01_axil_rdata		(s01.s_axil_rdata),
		.s01_axil_rresp		(s01.s_axil_rresp),
		.s01_axil_rvalid	(s01.s_axil_rvalid),
		.s01_axil_rready	(s01.s_axil_rready),

		// m00
		.m00_axil_awaddr	(m00.m_axil_awaddr),
		.m00_axil_awprot	(m00.m_axil_awprot),
		.m00_axil_awvalid	(m00.m_axil_awvalid),
		.m00_axil_awready	(m00.m_axil_awready),
		.m00_axil_wdata		(m00.m_axil_wdata),
		.m00_axil_wstrb		(m00.m_axil_wstrb),
		.m00_axil_wvalid	(m00.m_axil_wvalid),
		.m00_axil_wready	(m00.m_axil_wready),
		.m00_axil_bresp		(m00.m_axil_bresp),
		.m00_axil_bvalid	(m00.m_axil_bvalid),
		.m00_axil_bready	(m00.m_axil_bready),
		.m00_axil_araddr	(m00.m_axil_araddr),
		.m00_axil_arprot	(m00.m_axil_arprot),
		.m00_axil_arvalid	(m00.m_axil_arvalid),
		.m00_axil_arready	(m00.m_axil_arready),
		.m00_axil_rdata		(m00.m_axil_rdata),
		.m00_axil_rresp		(m00.m_axil_rresp),
		.m00_axil_rvalid	(m00.m_axil_rvalid),
		.m00_axil_rready	(m00.m_axil_rready)
	);
	
endmodule : axil_crossbar_2x1_wrapper
