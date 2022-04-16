module uart_tx # (
	parameter	CLK_FREQ = 5e7,	// clk freq
	parameter	UART_BPS = 9600	// port rate
) (
	input	logic			clk,
	input	logic			rst_n,
	
	input	logic			uart_en,
	input	logic	[7:0]	uart_din,
	output	logic			TX,
	output	logic			tx_done
);


	logic[19:0] BPS_CNT;
	assign BPS_CNT = CLK_FREQ / UART_BPS;


	//reg define
	reg			uart_en_d0; 
	reg			uart_en_d1;  
	reg	[15:0]	clk_cnt;
	reg	[ 3:0]	tx_cnt;
	reg			tx_flag;
	reg	[ 7:0]	tx_data;


	//wire define
	wire		en_flag;


	// rising edge of enable
	assign en_flag = (~uart_en_d1) & uart_en_d0;


	//negedge for tx_flag means tx done
	reg dff1, dff2;
	always_ff @ (posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			dff1	<= 1'b0;
			dff2	<= 1'b0;
		end else begin
			dff1	<= tx_flag;
			dff2	<= dff1;
		end
	end
	assign tx_done = (!dff1) & (dff2);


	// double flop uart_en signal
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			uart_en_d0	<= 1'b0;
			uart_en_d1	<= 1'b0;
		end
		else begin
			uart_en_d0	<= uart_en;
			uart_en_d1	<= uart_en_d0;
		end
	end


	// start tx
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			tx_flag	<= 1'b0;
			tx_data	<= 8'd0;
		end else if (en_flag) begin
				tx_flag	<= 1'b1;
				tx_data	<= uart_din;
		// bug: this stop flag should work, but original code use BPS_CNT / 2
		end else if ((tx_cnt == 4'd9)&&(clk_cnt == BPS_CNT - 9)) begin 
				tx_flag	<= 1'b0;
				tx_data	<= 8'd0;
		end else begin
				tx_flag	<= tx_flag;
				tx_data	<= tx_data;
		end 
	end


	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			clk_cnt	<= 16'd0;
			tx_cnt	<= 4'd0;
		end
		else if (tx_flag) begin
			if (clk_cnt	< BPS_CNT - 1) begin
				clk_cnt	<= clk_cnt + 1'b1;
				tx_cnt	<= tx_cnt;
			end
			else begin
				clk_cnt	<= 16'd0;
				tx_cnt	<= tx_cnt + 1'b1;
			end
		end
		else begin
			clk_cnt	<= 16'd0;
			tx_cnt	<= 4'd0;
		end
	end


	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			TX <= 1'b1;
		end else if (tx_flag) begin
			case(tx_cnt)
				4'd0: TX <= 1'b0;		// start bit
				4'd1: TX <= tx_data[0];	// LSB
				4'd2: TX <= tx_data[1];
				4'd3: TX <= tx_data[2];
				4'd4: TX <= tx_data[3];
				4'd5: TX <= tx_data[4];
				4'd6: TX <= tx_data[5];
				4'd7: TX <= tx_data[6];
				4'd8: TX <= tx_data[7];	// MSB
				4'd9: TX <= 1'b1;		// stop bit
				default: ;
			endcase
		end else begin
			TX <= 1'b1;	// HIGH when IDLE
		end
	end

endmodule : uart_tx
	 