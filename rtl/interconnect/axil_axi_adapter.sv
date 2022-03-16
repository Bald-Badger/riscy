module axil_axi_adapter(
	axi_lite_interface	axil_bus,	// slave axil bus
	axi_interface		axi_bus		// master axi bus
);
	
	// wire linking
	assign axi_bus.m_axi_awid		= 0;	// don't care
	assign axi_bus.m_axi_awaddr		= axil_bus.s_axi_awaddr;
	assign axi_bus.m_axi_awlen		= 0;	// single
	assign axi_bus.m_axi_awsize		= 3'b010;	// 4 byte burst (1 word)
	assign axi_bus.m_axi_awburst	= 2'b00;	// fixed burst len
	assign axi_bus.m_axi_awlock		= 1'b0;	// normal
	assign axi_bus.m_axi_awcache	= 4'b0000; // Device Non-bufferable
	assign axi_bus.m_axi_awprot		= axil_bus.s_axi_awprot;
	assign axi_bus.m_axi_awvalid	= axil_bus.s_axi_awvalid;
	assign axi_bus.m_axi_wdata		= axil_bus.s_axi_wdata;
	assign axi_bus.m_axi_wstrb		= axil_bus.s_axi_wstrb;
	assign axi_bus.m_axi_wlast		= axil_bus.s_axi_wvalid;	// BUG?
	assign axi_bus.m_axi_wvalid		= axil_bus.s_axi_wvalid;
	assign axi_bus.m_axi_bready		= axil_bus.s_axi_bready;
	assign axi_bus.m_axi_arid		= 0;	// don't care
	assign axi_bus.m_axi_araddr		= axil_bus.s_axi_araddr;
	assign axi_bus.m_axi_arlen		= 0;	// single
	assign axi_bus.m_axi_arsize		= 3'b010;	// 4 byte burst (1 word)
	assign axi_bus.m_axi_arburst	= 2'b00;	// fixed burst len
	assign axi_bus.m_axi_arlock		= 1'b0;	// normal
	assign axi_bus.m_axi_arcache	= 4'b0000; // Device Non-bufferable
	assign axi_bus.m_axi_arprot		= axil_bus.s_axi_arprot;
	assign axi_bus.m_axi_arvalid	= axil_bus.s_axi_arvalid;
	assign axi_bus.m_axi_rready		= axil_bus.s_axi_rready;

	assign axil_bus.s_axi_wready	= axi_bus.m_axi_wready;
	assign axil_bus.s_axi_bid		= 0;	// don't care
	assign axil_bus.s_axi_bresp		= axi_bus.m_axi_bresp;
	assign axil_bus.s_axi_bvalid	= axi_bus.m_axi_bvalid;
	assign axil_bus.s_axi_arready	= axi_bus.m_axi_arready;
	assign axil_bus.s_axi_rid		= 0;	// don't care
	assign axil_bus.s_axi_rdata		= axi_bus.m_axi_rdata;
	assign axil_bus.s_axi_rresp		= axi_bus.m_axi_rresp;
	assign axil_bus.s_axi_rlast		= axi_bus.m_axi_rvalid;	// don't care
	assign axil_bus.s_axi_rvalid	= axi_bus.m_axi_rvalid;

endmodule