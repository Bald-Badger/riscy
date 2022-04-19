module uart_axil_wrapper #(
	parameter	CLK_FREQ 		= 5e7,
	parameter	UART_BPS		= 9600,
	parameter	FIFO_WIDTH_TX	= 10,	// FIFO depth = 2^WIDTH
	parameter	FIFO_WIDTH_RX	= 5,
	parameter	ADDR_WIDTH		= 4
) (
	input	logic				clk,
	input	logic				rst,

	// UART TX/RX
	input	logic				uart_rx,
	output	logic				uart_tx,
	input	logic				uart_cts,	// high: master cannot take input
	output	logic				uart_rts,	// high: we cannot take input

	axil_interface.axil_slave	s00
);

	uart_axil # (
		.CLK_FREQ				(CLK_FREQ),
		.UART_BPS				(UART_BPS),
		.FIFO_WIDTH_TX			(FIFO_WIDTH_TX),
		.FIFO_WIDTH_RX			(FIFO_WIDTH_RX),
		.ADDR_WIDTH				(ADDR_WIDTH)
	) uarts (
		.clk					(clk),
		.rst					(rst),

		// UARTS
		.uart_rx				(uart_rx),
		.uart_tx				(uart_tx),
		.uart_cts				(uart_cts),
		.uart_rts				(uart_rts),

		// AXI inputs
		.awvalid_i			(s00.axil_awvalid),
		.awaddr_i			(s00.axil_awaddr),
		.wvalid_i			(s00.axil_wvalid),
		.wdata_i			(s00.axil_wdata),
		.wstrb_i			(s00.axil_wstrb),
		.bready_i			(s00.axil_bready),
		.arvalid_i			(s00.axil_arvalid),
		.araddr_i			(s00.axil_araddr),
		.rready_i			(s00.axil_rready),

		// Outputs
		.awready_o			(s00.axil_awready),
		.wready_o			(s00.axil_wready),
		.bvalid_o			(s00.axil_bvalid),
		.bresp_o			(s00.axil_bresp),
		.arready_o			(s00.axil_arready),
		.rvalid_o			(s00.axil_rvalid),
		.rdata_o			(s00.axil_rdata),
		.rresp_o			(s00.axil_rresp),

		// unused AXI signal
		.awprot_i			(s00.axil_awprot),
		.arprot_i			(s00.axil_arprot)
	);
	
endmodule : uart_axil_wrapper
