module uart_rx # (
	parameter	CLK_FREQ = 5e7,	// clk freq
	parameter	UART_BPS = 9600	// port rate
) (
	input	logic			clk,
	input	logic			rst_n,
	
	input	logic			RX,
	output	logic			uart_done,
	output	logic	[7:0]	uart_data
);


	localparam BPS_CNT  = CLK_FREQ / UART_BPS;


	//reg define
	reg			RX_d0;
	reg			RX_d1;
	reg	[15:0]	clk_cnt;
	reg	[ 3:0]	rx_cnt;
	reg			rx_flag;
	reg	[ 7:0]	rxdata;


	//wire define
	wire       start_flag;


	// double flop RX data
	always_ff @(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin 
			RX_d0 <= 1'b0;
			RX_d1 <= 1'b0;
		end
		else begin
			RX_d0 <= RX;
			RX_d1 <= RX_d0;
		end   
	end


	// RX falling edge as start
	assign  start_flag = RX_d1 & (~RX_d0);


	// start capture when RX falling edge
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			rx_flag <= 1'b0;
		else begin
			if(start_flag)
				rx_flag <= 1'b1;
			else if((rx_cnt == 4'd9)&&(clk_cnt == BPS_CNT/2))
				rx_flag <= 1'b0; // stop rx when the counter reached its half
			else
				rx_flag <= rx_flag;
		end
	end


	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			clk_cnt	<= 16'd0;
			rx_cnt	<= 4'd0;
		end
		else if ( rx_flag ) begin
			if (clk_cnt < BPS_CNT - 1) begin
				clk_cnt	<= clk_cnt + 1'b1;
				rx_cnt	<= rx_cnt;
			end
			else begin
				clk_cnt	<= 16'd0;
				rx_cnt	<= rx_cnt + 1'b1;
			end
		end else begin
				clk_cnt	<= 16'd0;
				rx_cnt	<= 4'd0;
		end
	end


	always_ff @(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin
			rxdata <= 8'd0;
		end else if (rx_flag) begin
			if (clk_cnt == BPS_CNT / 2) begin	// counter reached middle point
				unique case ( rx_cnt )
					4'd1 : rxdata[0] <= RX_d1;	// LSB
					4'd2 : rxdata[1] <= RX_d1;
					4'd3 : rxdata[2] <= RX_d1;
					4'd4 : rxdata[3] <= RX_d1;
					4'd5 : rxdata[4] <= RX_d1;
					4'd6 : rxdata[5] <= RX_d1;
					4'd7 : rxdata[6] <= RX_d1;
					4'd8 : rxdata[7] <= RX_d1;	// MSB
					default:;
				endcase
			end
			else begin
				rxdata <= rxdata;
			end
		end else begin
			rxdata <= 8'd0;
		end
	end


	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			uart_data <= 8'd0;
			uart_done <= 1'b0;
		end
		else if(rx_cnt == 4'd9) begin
			uart_data <= rxdata;
			uart_done <= 1'b1;
		end
		else begin
			uart_data <= 8'd0;
			uart_done <= 1'b0;
		end
	end

endmodule : uart_rx
