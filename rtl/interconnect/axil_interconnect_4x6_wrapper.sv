module axil_interconnect_4x6_wrapper # (
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 16,
	parameter STRB_WIDTH = (DATA_WIDTH/8),
	parameter M_REGIONS = 1,
	parameter M00_BASE_ADDR = 0,
	parameter M00_ADDR_WIDTH = {M_REGIONS{32'd24}},
	parameter M00_CONNECT_READ = 4'b1111,
	parameter M00_CONNECT_WRITE = 4'b1111,
	parameter M00_SECURE = 1'b0,
	parameter M01_BASE_ADDR = 0,
	parameter M01_ADDR_WIDTH = {M_REGIONS{32'd24}},
	parameter M01_CONNECT_READ = 4'b1111,
	parameter M01_CONNECT_WRITE = 4'b1111,
	parameter M01_SECURE = 1'b0,
	parameter M02_BASE_ADDR = 0,
	parameter M02_ADDR_WIDTH = {M_REGIONS{32'd24}},
	parameter M02_CONNECT_READ = 4'b1111,
	parameter M02_CONNECT_WRITE = 4'b1111,
	parameter M02_SECURE = 1'b0,
	parameter M03_BASE_ADDR = 0,
	parameter M03_ADDR_WIDTH = {M_REGIONS{32'd24}},
	parameter M03_CONNECT_READ = 4'b1111,
	parameter M03_CONNECT_WRITE = 4'b1111,
	parameter M03_SECURE = 1'b0,
	parameter M04_BASE_ADDR = 0,
	parameter M04_ADDR_WIDTH = {M_REGIONS{32'd24}},
	parameter M04_CONNECT_READ = 4'b1111,
	parameter M04_CONNECT_WRITE = 4'b1111,
	parameter M04_SECURE = 1'b0,
	parameter M05_BASE_ADDR = 0,
	parameter M05_ADDR_WIDTH = {M_REGIONS{32'd24}},
	parameter M05_CONNECT_READ = 4'b1111,
	parameter M05_CONNECT_WRITE = 4'b1111,
	parameter M05_SECURE = 1'b0
) (
	input	logic		clk,
	input	logic		rst,

	axi_lite_interface	s00,
	axi_lite_interface	s01,
	axi_lite_interface	s02,
	axi_lite_interface	s03,
	axi_lite_interface	m00,
	axi_lite_interface	m01,
	axi_lite_interface	m02,
	axi_lite_interface	m03,
	axi_lite_interface	m04,
	axi_lite_interface	m05
);


axil_interconnect_4x6 # (
	.DATA_WIDTH			(DATA_WIDTH),
	.ADDR_WIDTH			(ADDR_WIDTH),
	.STRB_WIDTH			(STRB_WIDTH),
	.M_REGIONS			(M_REGIONS),
	.M00_BASE_ADDR		(M00_BASE_ADDR),
	.M00_ADDR_WIDTH		(M00_ADDR_WIDTH),
	.M00_CONNECT_READ	(M00_CONNECT_READ),
	.M00_CONNECT_WRITE	(M00_CONNECT_WRITE),
	.M00_SECURE			(M00_SECURE),
	.M01_BASE_ADDR		(M01_BASE_ADDR),
	.M01_ADDR_WIDTH		(M01_ADDR_WIDTH),
	.M01_CONNECT_READ	(M01_CONNECT_READ),
	.M01_CONNECT_WRITE	(M01_CONNECT_WRITE),
	.M01_SECURE			(M01_SECURE),
	.M02_BASE_ADDR		(M02_BASE_ADDR),
	.M02_ADDR_WIDTH		(M02_ADDR_WIDTH),
	.M02_CONNECT_READ	(M02_CONNECT_READ),
	.M02_CONNECT_WRITE	(M02_CONNECT_WRITE),
	.M02_SECURE			(M02_SECURE),
	.M03_BASE_ADDR		(M03_BASE_ADDR),
	.M03_ADDR_WIDTH		(M03_ADDR_WIDTH),
	.M03_CONNECT_READ	(M03_CONNECT_READ),
	.M03_CONNECT_WRITE	(M03_CONNECT_WRITE),
	.M03_SECURE			(M03_SECURE),
	.M04_BASE_ADDR		(M04_BASE_ADDR),
	.M04_ADDR_WIDTH		(M04_ADDR_WIDTH),
	.M04_CONNECT_READ	(M04_CONNECT_READ),
	.M04_CONNECT_WRITE	(M04_CONNECT_WRITE),
	.M04_SECURE			(M04_SECURE),
	.M05_BASE_ADDR		(M05_BASE_ADDR),
	.M05_ADDR_WIDTH		(M05_ADDR_WIDTH),
	.M05_CONNECT_READ	(M05_CONNECT_READ),
	.M05_CONNECT_WRITE	(M05_CONNECT_WRITE),
	.M05_SECURE			(M05_SECURE)
) interconnect_4x6 (
	// s00
	.s00_axil_awaddr	(s00.slave.axil_awaddr),
	.s00_axil_awprot	(s00.slave.axil_awprot),
	.s00_axil_awvalid	(s00.slave.axil_awvalid),
	.s00_axil_awready	(s00.slave.axil_awready),
	.s00_axil_wdata		(s00.slave.axil_wdata),
	.s00_axil_wstrb		(s00.slave.axil_wstrb),
	.s00_axil_wvalid	(s00.slave.axil_wvalid),
	.s00_axil_wready	(s00.slave.axil_wready),
	.s00_axil_bresp		(s00.slave.axil_bresp),
	.s00_axil_bvalid	(s00.slave.axil_bvalid),
	.s00_axil_bready	(s00.slave.axil_bready),
	.s00_axil_araddr	(s00.slave.axil_araddr),
	.s00_axil_arprot	(s00.slave.axil_arprot),
	.s00_axil_arvalid	(s00.slave.axil_arvalid),
	.s00_axil_arready	(s00.slave.axil_arready),
	.s00_axil_rdata		(s00.slave.axil_rdata),
	.s00_axil_rresp		(s00.slave.axil_rresp),
	.s00_axil_rvalid	(s00.slave.axil_rvalid),
	.s00_axil_rready	(s00.slave.axil_rready),

	// s01
	.s01_axil_awaddr	(s01.slave.axil_awaddr),
	.s01_axil_awprot	(s01.slave.axil_awprot),
	.s01_axil_awvalid	(s01.slave.axil_awvalid),
	.s01_axil_awready	(s01.slave.axil_awready),
	.s01_axil_wdata		(s01.slave.axil_wdata),
	.s01_axil_wstrb		(s01.slave.axil_wstrb),
	.s01_axil_wvalid	(s01.slave.axil_wvalid),
	.s01_axil_wready	(s01.slave.axil_wready),
	.s01_axil_bresp		(s01.slave.axil_bresp),
	.s01_axil_bvalid	(s01.slave.axil_bvalid),
	.s01_axil_bready	(s01.slave.axil_bready),
	.s01_axil_araddr	(s01.slave.axil_araddr),
	.s01_axil_arprot	(s01.slave.axil_arprot),
	.s01_axil_arvalid	(s01.slave.axil_arvalid),
	.s01_axil_arready	(s01.slave.axil_arready),
	.s01_axil_rdata		(s01.slave.axil_rdata),
	.s01_axil_rresp		(s01.slave.axil_rresp),
	.s01_axil_rvalid	(s01.slave.axil_rvalid),
	.s01_axil_rready	(s01.slave.axil_rready),

	// s02
	.s02_axil_awaddr	(s02.slave.axil_awaddr),
	.s02_axil_awprot	(s02.slave.axil_awprot),
	.s02_axil_awvalid	(s02.slave.axil_awvalid),
	.s02_axil_awready	(s02.slave.axil_awready),
	.s02_axil_wdata		(s02.slave.axil_wdata),
	.s02_axil_wstrb		(s02.slave.axil_wstrb),
	.s02_axil_wvalid	(s02.slave.axil_wvalid),
	.s02_axil_wready	(s02.slave.axil_wready),
	.s02_axil_bresp		(s02.slave.axil_bresp),
	.s02_axil_bvalid	(s02.slave.axil_bvalid),
	.s02_axil_bready	(s02.slave.axil_bready),
	.s02_axil_araddr	(s02.slave.axil_araddr),
	.s02_axil_arprot	(s02.slave.axil_arprot),
	.s02_axil_arvalid	(s02.slave.axil_arvalid),
	.s02_axil_arready	(s02.slave.axil_arready),
	.s02_axil_rdata		(s02.slave.axil_rdata),
	.s02_axil_rresp		(s02.slave.axil_rresp),
	.s02_axil_rvalid	(s02.slave.axil_rvalid),
	.s02_axil_rready	(s02.slave.axil_rready),

	// s03
	.s03_axil_awaddr	(s03.slave.axil_awaddr),
	.s03_axil_awprot	(s03.slave.axil_awprot),
	.s03_axil_awvalid	(s03.slave.axil_awvalid),
	.s03_axil_awready	(s03.slave.axil_awready),
	.s03_axil_wdata		(s03.slave.axil_wdata),
	.s03_axil_wstrb		(s03.slave.axil_wstrb),
	.s03_axil_wvalid	(s03.slave.axil_wvalid),
	.s03_axil_wready	(s03.slave.axil_wready),
	.s03_axil_bresp		(s03.slave.axil_bresp),
	.s03_axil_bvalid	(s03.slave.axil_bvalid),
	.s03_axil_bready	(s03.slave.axil_bready),
	.s03_axil_araddr	(s03.slave.axil_araddr),
	.s03_axil_arprot	(s03.slave.axil_arprot),
	.s03_axil_arvalid	(s03.slave.axil_arvalid),
	.s03_axil_arready	(s03.slave.axil_arready),
	.s03_axil_rdata		(s03.slave.axil_rdata),
	.s03_axil_rresp		(s03.slave.axil_rresp),
	.s03_axil_rvalid	(s03.slave.axil_rvalid),
	.s03_axil_rready	(s03.slave.axil_rready),

	// m00
	.m00_axil_awaddr	(m00.master.axil_awaddr),
	.m00_axil_awprot	(m00.master.axil_awprot),
	.m00_axil_awvalid	(m00.master.axil_awvalid),
	.m00_axil_awready	(m00.master.axil_awready),
	.m00_axil_wdata		(m00.master.axil_wdata),
	.m00_axil_wstrb		(m00.master.axil_wstrb),
	.m00_axil_wvalid	(m00.master.axil_wvalid),
	.m00_axil_wready	(m00.master.axil_wready),
	.m00_axil_bresp		(m00.master.axil_bresp),
	.m00_axil_bvalid	(m00.master.axil_bvalid),
	.m00_axil_bready	(m00.master.axil_bready),
	.m00_axil_araddr	(m00.master.axil_araddr),
	.m00_axil_arprot	(m00.master.axil_arprot),
	.m00_axil_arvalid	(m00.master.axil_arvalid),
	.m00_axil_arready	(m00.master.axil_arready),
	.m00_axil_rdata		(m00.master.axil_rdata),
	.m00_axil_rresp		(m00.master.axil_rresp),
	.m00_axil_rvalid	(m00.master.axil_rvalid),
	.m00_axil_rready	(m00.master.axil_rready),

	// m01
	.m01_axil_awaddr	(m01.master.axil_awaddr),
	.m01_axil_awprot	(m01.master.axil_awprot),
	.m01_axil_awvalid	(m01.master.axil_awvalid),
	.m01_axil_awready	(m01.master.axil_awready),
	.m01_axil_wdata		(m01.master.axil_wdata),
	.m01_axil_wstrb		(m01.master.axil_wstrb),
	.m01_axil_wvalid	(m01.master.axil_wvalid),
	.m01_axil_wready	(m01.master.axil_wready),
	.m01_axil_bresp		(m01.master.axil_bresp),
	.m01_axil_bvalid	(m01.master.axil_bvalid),
	.m01_axil_bready	(m01.master.axil_bready),
	.m01_axil_araddr	(m01.master.axil_araddr),
	.m01_axil_arprot	(m01.master.axil_arprot),
	.m01_axil_arvalid	(m01.master.axil_arvalid),
	.m01_axil_arready	(m01.master.axil_arready),
	.m01_axil_rdata		(m01.master.axil_rdata),
	.m01_axil_rresp		(m01.master.axil_rresp),
	.m01_axil_rvalid	(m01.master.axil_rvalid),
	.m01_axil_rready	(m01.master.axil_rready),

	// m02
	.m02_axil_awaddr	(m02.master.axil_awaddr),
	.m02_axil_awprot	(m02.master.axil_awprot),
	.m02_axil_awvalid	(m02.master.axil_awvalid),
	.m02_axil_awready	(m02.master.axil_awready),
	.m02_axil_wdata		(m02.master.axil_wdata),
	.m02_axil_wstrb		(m02.master.axil_wstrb),
	.m02_axil_wvalid	(m02.master.axil_wvalid),
	.m02_axil_wready	(m02.master.axil_wready),
	.m02_axil_bresp		(m02.master.axil_bresp),
	.m02_axil_bvalid	(m02.master.axil_bvalid),
	.m02_axil_bready	(m02.master.axil_bready),
	.m02_axil_araddr	(m02.master.axil_araddr),
	.m02_axil_arprot	(m02.master.axil_arprot),
	.m02_axil_arvalid	(m02.master.axil_arvalid),
	.m02_axil_arready	(m02.master.axil_arready),
	.m02_axil_rdata		(m02.master.axil_rdata),
	.m02_axil_rresp		(m02.master.axil_rresp),
	.m02_axil_rvalid	(m02.master.axil_rvalid),
	.m02_axil_rready	(m02.master.axil_rready),

	// m03
	.m03_axil_awaddr	(m03.master.axil_awaddr),
	.m03_axil_awprot	(m03.master.axil_awprot),
	.m03_axil_awvalid	(m03.master.axil_awvalid),
	.m03_axil_awready	(m03.master.axil_awready),
	.m03_axil_wdata		(m03.master.axil_wdata),
	.m03_axil_wstrb		(m03.master.axil_wstrb),
	.m03_axil_wvalid	(m03.master.axil_wvalid),
	.m03_axil_wready	(m03.master.axil_wready),
	.m03_axil_bresp		(m03.master.axil_bresp),
	.m03_axil_bvalid	(m03.master.axil_bvalid),
	.m03_axil_bready	(m03.master.axil_bready),
	.m03_axil_araddr	(m03.master.axil_araddr),
	.m03_axil_arprot	(m03.master.axil_arprot),
	.m03_axil_arvalid	(m03.master.axil_arvalid),
	.m03_axil_arready	(m03.master.axil_arready),
	.m03_axil_rdata		(m03.master.axil_rdata),
	.m03_axil_rresp		(m03.master.axil_rresp),
	.m03_axil_rvalid	(m03.master.axil_rvalid),
	.m03_axil_rready	(m03.master.axil_rready),

	// m04
	.m04_axil_awaddr	(m04.master.axil_awaddr),
	.m04_axil_awprot	(m04.master.axil_awprot),
	.m04_axil_awvalid	(m04.master.axil_awvalid),
	.m04_axil_awready	(m04.master.axil_awready),
	.m04_axil_wdata		(m04.master.axil_wdata),
	.m04_axil_wstrb		(m04.master.axil_wstrb),
	.m04_axil_wvalid	(m04.master.axil_wvalid),
	.m04_axil_wready	(m04.master.axil_wready),
	.m04_axil_bresp		(m04.master.axil_bresp),
	.m04_axil_bvalid	(m04.master.axil_bvalid),
	.m04_axil_bready	(m04.master.axil_bready),
	.m04_axil_araddr	(m04.master.axil_araddr),
	.m04_axil_arprot	(m04.master.axil_arprot),
	.m04_axil_arvalid	(m04.master.axil_arvalid),
	.m04_axil_arready	(m04.master.axil_arready),
	.m04_axil_rdata		(m04.master.axil_rdata),
	.m04_axil_rresp		(m04.master.axil_rresp),
	.m04_axil_rvalid	(m04.master.axil_rvalid),
	.m04_axil_rready	(m04.master.axil_rready),

	// m05
	.m05_axil_awaddr	(m05.master.axil_awaddr),
	.m05_axil_awprot	(m05.master.axil_awprot),
	.m05_axil_awvalid	(m05.master.axil_awvalid),
	.m05_axil_awready	(m05.master.axil_awready),
	.m05_axil_wdata		(m05.master.axil_wdata),
	.m05_axil_wstrb		(m05.master.axil_wstrb),
	.m05_axil_wvalid	(m05.master.axil_wvalid),
	.m05_axil_wready	(m05.master.axil_wready),
	.m05_axil_bresp		(m05.master.axil_bresp),
	.m05_axil_bvalid	(m05.master.axil_bvalid),
	.m05_axil_bready	(m05.master.axil_bready),
	.m05_axil_araddr	(m05.master.axil_araddr),
	.m05_axil_arprot	(m05.master.axil_arprot),
	.m05_axil_arvalid	(m05.master.axil_arvalid),
	.m05_axil_arready	(m05.master.axil_arready),
	.m05_axil_rdata		(m05.master.axil_rdata),
	.m05_axil_rresp		(m05.master.axil_rresp),
	.m05_axil_rvalid	(m05.master.axil_rvalid),
	.m05_axil_rready	(m05.master.axil_rready)
);

endmodule : axil_interconnect_4x6_wrapper
