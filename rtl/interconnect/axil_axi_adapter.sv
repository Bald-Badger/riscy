// WARNING! for single R/W only

module axil_axi_adapter # (
	parameter			USER_ID		= 0
)
(
	axi_lite_interface	axil_bus,	// slave axil bus
	axi_interface		axi_bus		// master axi bus
);
	
	// wire linking
	assign axi_bus.m_axi_awid		= USER_ID;	// don't care
	assign axi_bus.m_axi_awaddr		= axil_bus.s_axil_awaddr;
	assign axi_bus.m_axi_awlen		= 0;	// single burst
	assign axi_bus.m_axi_awsize		= 3'b010;	// 4 byte per single burst (1 word)
	assign axi_bus.m_axi_awburst	= 2'b00;	// fixed burst len ? the spec say should be 2'b01, INCR
	assign axi_bus.m_axi_awlock		= 1'b0;	// normal
	assign axi_bus.m_axi_awcache	= 4'b0000; 	// Device Non-bufferable
	assign axi_bus.m_axi_awprot		= axil_bus.s_axil_awprot;
	assign axi_bus.m_axi_awqos		= 0;
	assign axi_bus.m_axi_awuser		= 0;
	assign axi_bus.m_axi_awvalid	= axil_bus.s_axil_awvalid;
	assign axi_bus.m_axi_wdata		= axil_bus.s_axil_wdata;
	assign axi_bus.m_axi_wstrb		= axil_bus.s_axil_wstrb;
	assign axi_bus.m_axi_wlast		= (axil_bus.s_axil_wvalid || axi_bus.m_axi_wready);	// TODO: BUG?
	assign axi_bus.m_axi_wuser		= 0;
	assign axi_bus.m_axi_wvalid		= axil_bus.s_axil_wvalid;
	// assign axi_bus.m_axi_buser		= 0; // don't care
	assign axi_bus.m_axi_bready		= axil_bus.s_axil_bready;
	assign axi_bus.m_axi_arid		= USER_ID;	// don't care
	assign axi_bus.m_axi_araddr		= axil_bus.s_axil_araddr;
	assign axi_bus.m_axi_arlen		= 0;	// single
	assign axi_bus.m_axi_arsize		= 3'b010;	// 4 byte burst (1 word)
	assign axi_bus.m_axi_arburst	= 2'b00;	// fixed burst len
	assign axi_bus.m_axi_arlock		= 1'b0;	// normal
	assign axi_bus.m_axi_arcache	= 4'b0000; // Device Non-bufferable
	assign axi_bus.m_axi_arqos		= 0;
	assign axi_bus.m_axi_aruser		= 0;
	assign axi_bus.m_axi_arprot		= axil_bus.s_axil_arprot;
	assign axi_bus.m_axi_arvalid	= axil_bus.s_axil_arvalid;
	//assign axi_bus.m_axi_ruser		= 0; // don't care
	assign axi_bus.m_axi_rready		= axil_bus.s_axil_rready;

	assign axil_bus.s_axil_awready	= axi_bus.m_axi_awready;
	assign axil_bus.s_axil_wready	= axi_bus.m_axi_wready;
	// assign axi_bus.m_axi_bid		= 0;	// don't care
	assign axil_bus.s_axil_bresp	= axi_bus.m_axi_bresp;
	assign axil_bus.s_axil_bvalid	= axi_bus.m_axi_bvalid;
	assign axil_bus.s_axil_arready	= axi_bus.m_axi_arready;
	// assign axi_bus.m_axi_rid		= 0;	// don't care
	assign axil_bus.s_axil_rdata	= axi_bus.m_axi_rdata;
	assign axil_bus.s_axil_rresp	= axi_bus.m_axi_rresp;
	//assign axi_bus.s_axi_rlast	= ;	// don't care
	assign axil_bus.s_axil_rvalid	= axi_bus.m_axi_rvalid;

endmodule : axil_axi_adapter
