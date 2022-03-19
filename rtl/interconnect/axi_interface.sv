interface axi_interface # (
	// Width, default everything to 32 bits
	parameter WIDTH = 32,
	// Width of AXI ID signal
	parameter ID_WIDTH = 8
) (
	input logic clk,
	input logic rst
);

	// Width of address bus in bits
	localparam ADDR_WIDTH = WIDTH;
	// Width of input (slave) AXI interface data bus in bits
	localparam DATA_WIDTH = WIDTH;
	// Width of input (slave) AXI interface wstrb (width of data bus in words)
	localparam STRB_WIDTH = (DATA_WIDTH/8);


	// master interface
	logic [ID_WIDTH-1:0]	m_axi_awid;
	logic [ADDR_WIDTH-1:0]	m_axi_awaddr;
	logic [7:0]				m_axi_awlen;
	logic [2:0]				m_axi_awsize;
	logic [1:0]				m_axi_awburst;
	logic					m_axi_awlock;
	logic [3:0]				m_axi_awcache;
	logic [2:0]				m_axi_awprot;
	logic [3:0]				m_axi_awqos;
	logic [3:0]				m_axi_awregion;
	logic					m_axi_awuser;
	logic					m_axi_awvalid;
	logic					m_axi_awready;
	logic [DATA_WIDTH-1:0]	m_axi_wdata;
	logic [STRB_WIDTH-1:0]	m_axi_wstrb;
	logic					m_axi_wlast;
	logic					m_axi_wuser;
	logic					m_axi_wvalid;
	logic					m_axi_wready;
	logic [ID_WIDTH-1:0]	m_axi_bid;
	logic [1:0]				m_axi_bresp;
	logic					m_axi_buser;
	logic					m_axi_bvalid;
	logic					m_axi_bready;
	logic [ID_WIDTH-1:0]	m_axi_arid;
	logic [ADDR_WIDTH-1:0]	m_axi_araddr;
	logic [7:0]				m_axi_arlen;
	logic [2:0]				m_axi_arsize;
	logic [1:0]				m_axi_arburst;
	logic					m_axi_arlock;
	logic [3:0]				m_axi_arcache;
	logic [2:0]				m_axi_arprot;
	logic [3:0]				m_axi_arqos;
	logic [3:0]				m_axi_arregion;
	logic					m_axi_aruser;
	logic					m_axi_arvalid;
	logic					m_axi_arready;
	logic [ID_WIDTH-1:0]    m_axi_rid;
	logic [DATA_WIDTH-1:0]  m_axi_rdata;
	logic [1:0]				m_axi_rresp;
	logic					m_axi_rlast;
	logic					m_axi_ruser;
	logic					m_axi_rvalid;
	logic					m_axi_rready;


	// slave interface
	logic [ID_WIDTH-1:0]	s_axi_awid;
	logic [ADDR_WIDTH-1:0]	s_axi_awaddr;
	logic [7:0]				s_axi_awlen;
	logic [2:0]				s_axi_awsize;
	logic [1:0]				s_axi_awburst;
	logic					s_axi_awlock;
	logic [3:0]				s_axi_awcache;
	logic [2:0]				s_axi_awprot;
	logic [3:0]				s_axi_awqos;
	logic					s_axi_awuser;
	logic					s_axi_awvalid;
	logic					s_axi_awready;
	logic [DATA_WIDTH-1:0]	s_axi_wdata;
	logic [STRB_WIDTH-1:0]	s_axi_wstrb;
	logic					s_axi_wlast;
	logic					s_axi_wuser;
	logic					s_axi_wvalid;
	logic					s_axi_wready;
	logic [ID_WIDTH-1:0]	s_axi_bid;
	logic [1:0]				s_axi_bresp;
	logic					s_axi_buser;
	logic					s_axi_bvalid;
	logic					s_axi_bready;
	logic [ID_WIDTH-1:0]	s_axi_arid;
	logic [ADDR_WIDTH-1:0]	s_axi_araddr;
	logic [7:0]				s_axi_arlen;
	logic [2:0]				s_axi_arsize;
	logic [1:0]				s_axi_arburst;
	logic					s_axi_arlock;
	logic [3:0]				s_axi_arcache;
	logic [2:0]				s_axi_arprot;
	logic [3:0]				s_axi_arqos;
	logic					s_axi_aruser;
	logic					s_axi_arvalid;
	logic					s_axi_arready;
	logic [ID_WIDTH-1:0]    s_axi_rid;
	logic [DATA_WIDTH-1:0]  s_axi_rdata;
	logic [1:0]				s_axi_rresp;
	logic					s_axi_rlast;
	logic					s_axi_ruser;
	logic					s_axi_rvalid;
	logic					s_axi_rready;


	// wire linking
	assign s_axi_awid		= m_axi_awid;
	assign s_axi_awaddr		= m_axi_awaddr;
	assign s_axi_awlen		= m_axi_awlen;
	assign s_axi_awsize		= m_axi_awsize;
	assign s_axi_awburst	= m_axi_awburst;
	assign s_axi_awlock		= m_axi_awlock;
	assign s_axi_awcache	= m_axi_awcache;
	assign s_axi_awprot		= m_axi_awprot;
	assign s_axi_awqos		= m_axi_awqos;
	assign s_axi_awuser		= m_axi_awuser;
	assign s_axi_awvalid	= m_axi_awvalid;
	assign s_axi_wdata		= m_axi_wdata;
	assign s_axi_wstrb		= m_axi_wstrb;
	assign s_axi_wlast		= m_axi_wlast;
	assign s_axi_wuser		= m_axi_wuser;
	assign s_axi_wvalid		= m_axi_wvalid;
	assign s_axi_bready		= m_axi_bready;
	assign s_axi_arid		= m_axi_arid;
	assign s_axi_araddr		= m_axi_araddr;
	assign s_axi_arlen		= m_axi_arlen;
	assign s_axi_arsize		= m_axi_arsize;
	assign s_axi_arburst	= m_axi_arburst;
	assign s_axi_arlock		= m_axi_arlock;
	assign s_axi_arcache	= m_axi_arcache;
	assign s_axi_arqos		= m_axi_arqos;
	assign s_axi_aruser		= m_axi_aruser;
	assign s_axi_arprot		= m_axi_arprot;
	assign s_axi_arvalid	= m_axi_arvalid;
	assign s_axi_rready		= m_axi_rready;
	
	assign m_axi_buser		= s_axi_buser;
	assign m_axi_ruser		= s_axi_ruser;
	assign m_axi_awready	= s_axi_awready;
	assign m_axi_wready		= s_axi_wready;
	assign m_axi_bid		= s_axi_bid;
	assign m_axi_bresp		= s_axi_bresp;
	assign m_axi_bvalid		= s_axi_bvalid;
	assign m_axi_arready	= s_axi_arready;
	assign m_axi_rid		= s_axi_rid;
	assign m_axi_rdata		= s_axi_rdata;
	assign m_axi_rresp		= s_axi_rresp;
	assign m_axi_rlast		= s_axi_rlast;
	assign m_axi_rvalid		= s_axi_rvalid;

endinterface : axi_interface
