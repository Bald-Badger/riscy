module sdram_axil_qsys (
	input				clk,
	input				rst,

	input  wire [25:0]	s_axil_awaddr,
	input  wire [2:0]	s_axil_awprot,
	input  wire			s_axil_awvalid,
	output wire			s_axil_awready,
	input  wire [31:0]	s_axil_wdata,
	input  wire [3:0]	s_axil_wstrb,
	input  wire			s_axil_wvalid,
	output wire			s_axil_wready,
	output wire [1:0]	s_axil_bresp,
	output wire			s_axil_bvalid,
	input  wire			s_axil_bready,
	input  wire [25:0]	s_axil_araddr,
	input  wire [2:0]	s_axil_arprot,
	input  wire			s_axil_arvalid,
	output wire			s_axil_arready,
	output wire [32:0]	s_axil_rdata,
	output wire [1:0]	s_axil_rresp,
	output wire			s_axil_rvalid,
	input  wire			s_axil_rready,

	// SDRAM interface
	output				sdram_clk,
	output				sdram_cke,
	output	[ 1: 0]		sdram_dqm,
	output				sdram_cas_n,
	output				sdram_ras_n,
	output				sdram_we_n,
	output				sdram_cs_n,
	output	[ 1: 0]		sdram_ba,
	output	[12: 0]		sdram_addr,
	inout	[15: 0]		sdram_dq
);

	sdram_axi_qsys sdram_ctrl (
		.clk			(clk),
		.rst			(rst),

		// AXI interface
		.axi_awvalid(s_axil_awvalid),
		.axi_awaddr(s_axil_awaddr),
		.axi_awid(0),
		.axi_awlen(0),
		.axi_awburst(2'b00),
		.axi_wvalid(s_axil_wvalid),
		.axi_wdata(s_axil_wdata),
		.axi_wstrb(s_axil_wstrb),
		.axi_wlast(1'b1),
		.axi_bready(s_axil_bready),
		.axi_arvalid(s_axil_arvalid),
		.axi_araddr(s_axil_araddr),
		.axi_arid(0),
		.axi_arlen(0),
		.axi_arburst(2'b00),
		.axi_rready(s_axil_rready),
		.axi_awready(s_axil_awready),
		.axi_wready(s_axil_wready),
		.axi_bvalid(s_axil_bvalid),
		.axi_bresp(s_axil_bresp),
		.axi_bid(),
		.axi_arready(s_axil_arready),
		.axi_rvalid(s_axil_rvalid),
		.axi_rdata(s_axil_rdata),
		.axi_rresp(s_axil_rresp),
		.axi_rid(),
		.axi_rlast(),

			// axi signal that are not used
		.axi_awsize(3'b010),
		.axi_arsize(3'b010),

			// SDRAM interface
		.sdram_clk(sdram_clk),
		.sdram_cke(sdram_cke),
		.sdram_dqm(sdram_dqm),
		.sdram_cas_n(sdram_cas_n),
		.sdram_ras_n(sdram_ras_n),
		.sdram_we_n(sdram_we_n),
		.sdram_cs_n(sdram_cs_n),
		.sdram_ba(sdram_ba),
		.sdram_addr(sdram_addr),
		.sdram_dq(sdram_dq)
	);
	
endmodule