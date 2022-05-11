interface axil_interface # (
	// Width of address bus in bits
	parameter ADDR_WIDTH		= 32
) ();

	// Width of AXI interface data bus in bits
	localparam DATA_WIDTH		= 32;
	// Width of data bus in words
	localparam STRB_WIDTH		= (DATA_WIDTH/8);

	// bus signals
	logic	[ADDR_WIDTH-1:0]	axil_awaddr;
	logic	[2:0]				axil_awprot;
	logic						axil_awvalid;
	logic						axil_awready;
	logic	[DATA_WIDTH-1:0]	axil_wdata;
	logic	[STRB_WIDTH-1:0]	axil_wstrb;	
	logic						axil_wvalid;
	logic						axil_wready;
	logic	[1:0]				axil_bresp;
	logic						axil_bvalid;
	logic						axil_bready;
	logic	[ADDR_WIDTH-1:0]	axil_araddr;
	logic	[2:0]				axil_arprot;
	logic						axil_arvalid;
	logic						axil_arready;
	logic	[DATA_WIDTH-1:0]	axil_rdata;
	logic	[1:0]				axil_rresp;
	logic						axil_rvalid;
	logic						axil_rready;

	modport axil_master (
		output					axil_awaddr,
		output					axil_awprot,
		output					axil_awvalid,
		input					axil_awready,
		output					axil_wdata,
		output					axil_wstrb,	
		output					axil_wvalid,
		input					axil_wready,
		input					axil_bresp,
		input					axil_bvalid,
		output					axil_bready,
		output					axil_araddr,
		output					axil_arprot,
		output					axil_arvalid,
		input					axil_arready,
		input					axil_rdata,
		input					axil_rresp,
		input					axil_rvalid,
		output					axil_rready
	);

	modport axil_slave (
		input					axil_awaddr,
		input					axil_awprot,
		input					axil_awvalid,
		output					axil_awready,
		input					axil_wdata,
		input					axil_wstrb,	
		input					axil_wvalid,
		output					axil_wready,
		output					axil_bresp,
		output					axil_bvalid,
		input					axil_bready,
		input					axil_araddr,
		input					axil_arprot,
		input					axil_arvalid,
		output					axil_arready,
		output					axil_rdata,
		output					axil_rresp,
		output					axil_rvalid,
		input					axil_rready
	);

endinterface : axil_interface
