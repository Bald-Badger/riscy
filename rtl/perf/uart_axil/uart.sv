module uart # (
	parameter	CLK_FREQ = 5e7,
	parameter	UART_BPS = 9600
) (
	input	logic			clk,
	input	logic			rst_n,
	input	logic			RX,
	input	logic			send_data,
	input	logic	[7:0]	tx_data,
	
	output	logic			TX,
	output	logic			rx_done,
	output	logic			tx_done,
	output	logic	[7:0]	rx_data
);

	uart_rx # (
		.CLK_FREQ	(CLK_FREQ),
		.UART_BPS	(UART_BPS)
	) myRX (
		.clk		(clk),
		.rst_n		(rst_n),
		.RX			(RX),
		.uart_done	(rx_done),
		.uart_data	(rx_data)
	);

	uart_tx # (
		.CLK_FREQ	(CLK_FREQ),
		.UART_BPS	(UART_BPS)
	) myTX (
		.clk		(clk),
		.rst_n		(rst_n),
		.uart_en	(send_data),
		.uart_din	(tx_data),
		.TX			(TX),
		.tx_done	(tx_done)
	);

endmodule : uart
