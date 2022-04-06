module sdram_wb_axil # (
		// AXIL param
		parameter C_AXI_DATA_WIDTH	= 32,// Width of the AXI R&W data
		parameter C_AXI_ADDR_WIDTH	= 16,	// AXI Address width
		parameter		LGFIFO = 4,
`ifdef	FORMAL
		parameter		F_MAXSTALL = 3,
		parameter		F_MAXDELAY = 3,
`endif
		parameter	[0:0]	OPT_READONLY  = 1'b0,
		parameter	[0:0]	OPT_WRITEONLY = 1'b0,
		localparam		AXILLSB = $clog2(C_AXI_DATA_WIDTH/8),

		// SDRAM param
		parameter	SDRAM_MHZ             = 50,
		parameter	SDRAM_ADDR_W          = 25,
		parameter	SDRAM_COL_W           = 10,    
		parameter	SDRAM_BANK_W          = 2,
		parameter	SDRAM_DQM_W           = 2,
		localparam	SDRAM_BANKS           = 2 ** SDRAM_BANK_W,
		localparam	SDRAM_ROW_W           = SDRAM_ADDR_W - SDRAM_COL_W - SDRAM_BANK_W,
		localparam	SDRAM_REFRESH_CNT     = 2 ** SDRAM_ROW_W,
		localparam	SDRAM_START_DELAY     = 100000 / (1000 / SDRAM_MHZ), // 100uS
		localparam	SDRAM_REFRESH_CYCLES  = (64000*SDRAM_MHZ) / SDRAM_REFRESH_CNT-1,
		parameter	SDRAM_READ_LATENCY    = 2,
		parameter	SDRAM_TARGET          = "ALTERA"
) (
	input					clk,
	input					rst

	// AXIL interface
	input	wire			i_axi_awvalid,
	output	wire			o_axi_awready,
	input	wire	[C_AXI_ADDR_WIDTH-1:0]	i_axi_awaddr,
	input	wire	[2:0]		i_axi_awprot,

	// AXI write data channel signals
	input	wire				i_axi_wvalid,
	output	wire				o_axi_wready, 
	input	wire	[C_AXI_DATA_WIDTH-1:0]	i_axi_wdata,
	input	wire	[C_AXI_DATA_WIDTH/8-1:0] i_axi_wstrb,

	// AXI write response channel signals
	output	wire 			o_axi_bvalid,
	input	wire			i_axi_bready,
	output	wire [1:0]		o_axi_bresp,

	// AXI read address channel signals
	input	wire			i_axi_arvalid,
	output	wire			o_axi_arready,
	input	wire	[C_AXI_ADDR_WIDTH-1:0]	i_axi_araddr,
	input	wire	[2:0]		i_axi_arprot,

	// AXI read data channel signals
	output	wire			o_axi_rvalid,
	input	wire			i_axi_rready,
	output	wire [C_AXI_DATA_WIDTH-1:0] o_axi_rdata,
	output	wire [1:0]		o_axi_rresp,

	// SDRAM Interface
	output			sdram_clk_o,
	output			sdram_cke_o,
	output			sdram_cs_o,
	output			sdram_ras_o,
	output			sdram_cas_o,
	output			sdram_we_o,
	output [1:0]	sdram_dqm_o,
	output [12:0]	sdram_addr_o,
	output [1:0]	sdram_ba_o,
	inout [15:0]	sdram_data_io
);

	// wishbone wire
	logic			stb_i;
	logic			we_i;
	logic	[3:0]	sel_i;
	logic			cyc_i;
	logic	[31:0]	addr_i;
	logic	[31:0]	data_i;
	logic	[31:0]	data_o;
	logic			stall_o;
	logic			ack_o;

	// unused
	logic			rst_wb;

	sdram_wishbone # (
		.SDRAM_MHZ			(SDRAM_MHZ),
		.SDRAM_ADDR_W		(SDRAM_ADDR_W),
		.SDRAM_COL_W		(SDRAM_COL_W),
		.SDRAM_BANK_W		(SDRAM_BANK_W),
		.SDRAM_DQM_W		(SDRAM_DQM_W),
		.SDRAM_READ_LATENCY	(SDRAM_READ_LATENCY),
		.SDRAM_TARGET		(SDRAM_TARGET)
	) sdram_ctrl (
		.clk_i				(clk),
		.rst_i				(rst),

		// Wishbone Interface
		.stb_i(stb_i),
		.we_i(we_i),
		.sel_i(sel_i),
		.cyc_i(cyc_i),
		.addr_i(addr_i),
		.data_i(data_i),
		.data_o(data_o),
		.stall_o(stall_o),
		.ack_o(ack_o),

		// SDRAM Interface
		.sdram_clk_o(sdram_clk_o),
		.sdram_cke_o(sdram_cke_o),
		.sdram_cs_o(sdram_cs_o),
		.sdram_ras_o(sdram_ras_o),
		.sdram_cas_o(sdram_cas_o),
		.sdram_we_o(sdram_we_o),
		.sdram_dqm_o(sdram_dqm_o),
		.sdram_addr_o(sdram_addr_o),
		.sdram_ba_o(sdram_ba_o),
		.sdram_data_io(sdram_data_io)
	);
	

	axil_wb_adapter # (
		.C_AXI_DATA_WIDTH(C_AXI_DATA_WIDTH)
		.C_AXI_ADDR_WIDTH(C_AXI_ADDR_WIDTH)
		.LGFIFO(LGFIFO)
		.OPT_READONLY(OPT_READONLY)
		.OPT_WRITEONLY(OPT_WRITEONLY)
	) adapter (
		.i_clk(clk),
		.i_axi_reset_n(~rst),

		.i_axi_awvalid(i_axi_awvalid),
		.o_axi_awready(o_axi_awready),
		.i_axi_awaddr(i_axi_awaddr),
		.i_axi_awprot(i_axi_awprot),

		.i_axi_wvalid(i_axi_wvalid),
		.o_axi_wready(o_axi_wready), 
		.i_axi_wdata(i_axi_wdata),
		.i_axi_wstrb(i_axi_wstrb),

		.o_axi_bvalid(o_axi_bvalid),
		.i_axi_bready(i_axi_bready),
		.o_axi_bresp(o_axi_bresp),

		.i_axi_arvalid(i_axi_arvalid),
		.o_axi_arready(o_axi_arready),
		.i_axi_araddr(i_axi_araddr),
		.i_axi_arprot(i_axi_arprot),

		.o_axi_rvalid(o_axi_rvalid),
		.i_axi_rready(i_axi_rready),
		.o_axi_rdata(o_axi_rdata),
		.o_axi_rresp(o_axi_rresp),

		.o_reset(rst_wb),
		.o_wb_cyc(cyc_i),
		.o_wb_stb(stb_i),
		.o_wb_we(we_i),
		.o_wb_addr(addr_i),
		.o_wb_data(data_i),
		.o_wb_sel(sel_i),
		.i_wb_stall(stall_o),
		.i_wb_ack(ack_o),
		.i_wb_data(data_o),
		.i_wb_err(1'b0)
	);
	
endmodule : sdram_wb_axil
