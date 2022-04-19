module uart_monitor # (
	parameter	CLK_FREQ = 5e7,
	parameter	UART_BPS = 9600
) (
	input	logic			clk,
	input	logic			rst,
	input	logic			RX,
	output	logic [7:0]		char
);

	logic done;
	logic [7:0] data, data_latch;

	always_ff @(posedge clk or posedge rst) begin
		if (rst)
			data_latch <= 8'b0;
		else if (done)
			data_latch <= data;
		else
			data_latch <= data_latch;
	end

	assign char = data_latch;

	uart_rx # (
		.CLK_FREQ	(CLK_FREQ),
		.UART_BPS	(UART_BPS)
	) myRX (
		.clk		(clk),
		.rst_n		(~rst),
		.RX			(RX),
		.uart_done	(done),
		.uart_data	(data)
	);
	
endmodule : uart_monitor
