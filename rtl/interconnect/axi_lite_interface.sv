interface axi_lite_interface # (
	// Width, default everything to 32 bits
	parameter WIDTH = 32,
	// Width of AXI ID signal
	parameter AXI_ID_WIDTH = 8,
	// When adapting to a wider bus, re-pack full-width burst instead of passing through narrow burst if possible
	parameter CONVERT_BURST = 1,
	// When adapting to a wider bus, re-pack all bursts instead of passing through narrow burst if possible
	parameter CONVERT_NARROW_BURST = 0
) (
	input logic clk,
	input logic rst
);

	// Width of address bus in bits
	localparam ADDR_WIDTH = WIDTH;
	// Width of input (slave) AXI interface data bus in bits
	localparam AXI_DATA_WIDTH = WIDTH;
	// Width of input (slave) AXI interface wstrb (width of data bus in words)
	localparam AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8);
	// Width of output (master) AXI lite interface data bus in bits
	localparam AXIL_DATA_WIDTH = WIDTH;
	// Width of output (master) AXI lite interface wstrb (width of data bus in words)
	localparam AXIL_STRB_WIDTH = (AXIL_DATA_WIDTH/8);

	// master modport
	logic							m_axil_clk;
	logic							m_axil_rst;
	logic	[ADDR_WIDTH-1:0]		m_axil_awaddr;
	logic	[2:0]					m_axil_awprot;
	logic							m_axil_awvalid;
	logic							m_axil_awready;
	logic	[AXIL_DATA_WIDTH-1:0]	m_axil_wdata;
	logic	[AXIL_STRB_WIDTH-1:0]	m_axil_wstrb;	
	logic							m_axil_wvalid;
	logic							m_axil_wready;
	logic	[1:0]					m_axil_bresp;
	logic							m_axil_bvalid;
	logic							m_axil_bready;
	logic	[ADDR_WIDTH-1:0]		m_axil_araddr;
	logic	[2:0]					m_axil_arprot;
	logic							m_axil_arvalid;
	logic							m_axil_arready;
	logic	[AXIL_DATA_WIDTH-1:0]	m_axil_rdata;
	logic	[1:0]					m_axil_rresp;
	logic							m_axil_rvalid;
	logic							m_axil_rready;

	// slave modport
	logic							s_axil_clk;
	logic							s_axil_rst;
	logic [AXIL_DATA_WIDTH-1:0]		s_axil_awaddr;
	logic [2:0]						s_axil_awprot;
	logic							s_axil_awvalid;
	logic							s_axil_awready;
	logic [AXIL_DATA_WIDTH-1:0]		s_axil_wdata;
	logic [AXIL_STRB_WIDTH-1:0]		s_axil_wstrb;
	logic							s_axil_wvalid;
	logic							s_axil_wready;
	logic [1:0]						s_axil_bresp;
	logic							s_axil_bvalid;
	logic							s_axil_bready;
	logic [ADDR_WIDTH-1:0]			s_axil_araddr;
	logic [2:0]						s_axil_arprot;
	logic							s_axil_arvalid;
	logic							s_axil_arready;
	logic [AXIL_DATA_WIDTH-1:0]		s_axil_rdata;
	logic[1:0]						s_axil_rresp;
	logic							s_axil_rvalid;
	logic							s_axil_rready;


	//assign m_axil_clk		= clk;
	//assign m_axil_rst		= rst;

	assign s_axil_clk		= m_axil_clk;
	assign s_axil_rst		= m_axil_rst;
	assign s_axil_awaddr	= m_axil_awaddr;
	assign s_axil_awprot	= m_axil_awprot;
	assign s_axil_awvalid	= m_axil_awvalid;
	assign m_axil_awready	= s_axil_awready;
	assign s_axil_wdata		= m_axil_wdata;
	assign s_axil_wstrb		= m_axil_wstrb;
	assign s_axil_wvalid	= m_axil_wvalid;
	assign m_axil_wready	= s_axil_wready;
	assign m_axil_bresp		= s_axil_bresp;
	assign m_axil_bvalid	= s_axil_bvalid;
	assign s_axil_bready	= m_axil_bready;
	assign s_axil_araddr	= m_axil_araddr;
	assign s_axil_arprot	= m_axil_arprot;
	assign s_axil_arvalid	= m_axil_arvalid;
	assign m_axil_arready	= s_axil_arready;
	assign m_axil_rdata		= s_axil_rdata;
	assign m_axil_rresp		= s_axil_rresp;
	assign m_axil_rvalid	= s_axil_rvalid;
	assign s_axil_rready	= m_axil_rready;


	modport master (
		output						m_axil_clk,
		output						m_axil_rst,

		output						m_axil_awaddr,
		output						m_axil_awprot,
		output						m_axil_awvalid,
		input						m_axil_awready,
		output						m_axil_wdata,
		output						m_axil_wstrb,	
		output						m_axil_wvalid,
		input						m_axil_wready,
		input						m_axil_bresp,
		input						m_axil_bvalid,
		output						m_axil_bready,
		output						m_axil_araddr,
		output						m_axil_arprot,
		output						m_axil_arvalid,
		input						m_axil_arready,
		input						m_axil_rdata,
		input						m_axil_rresp,
		input						m_axil_rvalid,
		output						m_axil_rready
	);

	modport slave (
		input						s_axil_clk,
		input						s_axil_rst,

		input						s_axil_awaddr,
		input						s_axil_awprot,
		input						s_axil_awvalid,
		output						s_axil_awready,
		input						s_axil_wdata,
		input						s_axil_wstrb,	
		input						s_axil_wvalid,
		output						s_axil_wready,
		output						s_axil_bresp,
		output						s_axil_bvalid,
		input						s_axil_bready,
		input						s_axil_araddr,
		input						s_axil_arprot,
		input						s_axil_arvalid,
		output						s_axil_arready,
		output						s_axil_rdata,
		output						s_axil_rresp,
		output						s_axil_rvalid,
		input						s_axil_rready
	);

// back-up text
/*
	// AXI-Lite master interface
	output	logic 					m_axil_clk,		// bus clock
	output	logic 					m_axil_rst,		// bus reset, active high
	output	logic [WIDTH-1:0]		m_axil_awaddr,	// Write address
	output	logic [2:0]				m_axil_awprot,	// Write protection level, see axi_defines.sv
	output	logic					m_axil_awvalid,	// Write address valid, signaling valid write address and control information.
	input	logic					m_axil_awready,	// Write address ready (from slave), ready to accept an address and associated control signals
	output	logic [WIDTH-1:0]		m_axil_wdata,	// Write data
	output	logic [WIDTH/8-1:0]		m_axil_wstrb,	// Write data strobe (byte select)
	output	logic					m_axil_wvalid,	// Write data valid, write data and strobes are available
	input	logic					m_axil_wready,	// Write data ready, slave can accept the write data
	input	logic [1:0]				m_axil_bresp,	// Write response (from slave)
	input	logic					m_axil_bvalid,	// Write response valid, signaling a valid write response
	output	logic					m_axil_bready,	// Write response ready (from master) can accept a write response
	output	logic [WIDTH-1:0]		m_axil_araddr,	// Read address
	output	logic [2:0]				m_axil_arprot,	// Read protection level, see axi_defines.sv
	output	logic					m_axil_arvalid,	// Read address valid,  signaling valid read address and control information
	input	logic					m_axil_arready,	// Read address ready (from slave), ready to accept an address and associated control signals
	input	logic [WIDTH-1:0]		m_axil_rdata,	// Read data
	input	logic [1:0]				m_axil_rresp,	// Read response (from slave)
	input	logic					m_axil_rvalid,	// Read response valid, the channel is signaling the required read data
	output	logic					m_axil_rready	// Read response ready (from master), can accept the read data and response information
	// end AXI-Lite master interface
*/

endinterface : axi_lite_interface