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
	input logic m_axil_clk,
	input logic m_axil_rst
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

	modport master (
		input						m_axil_clk,
		input						m_axil_rst,

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
		input						m_axil_clk,
		input						m_axil_rst,

		input						m_axil_awaddr,
		input						m_axil_awprot,
		input						m_axil_awvalid,
		output						m_axil_awready,
		input						m_axil_wdata,
		input						m_axil_wstrb,	
		input						m_axil_wvalid,
		output						m_axil_wready,
		output						m_axil_bresp,
		output						m_axil_bvalid,
		input						m_axil_bready,
		input						m_axil_araddr,
		input						m_axil_arprot,
		input						m_axil_arvalid,
		output						m_axil_arready,
		output						m_axil_rdata,
		output						m_axil_rresp,
		output						m_axil_rvalid,
		input						m_axil_rready
	);
	
endinterface //axi_lite_interface
