import defines::*;
import pref_defines::*;
import axi_defines::*;


module uart_axil #(
	parameter	CLK_FREQ 				= 5e7,
	parameter	UART_BPS				= 9600,
	parameter	FIFO_WIDTH_TX			= 10,	// FIFO depth = 2^WIDTH
	parameter	FIFO_WIDTH_RX			= 5,
	parameter	ADDR_WIDTH				= 4
) (
	// Inputs
	input	logic						clk,
	input	logic						rst,

	// axi-lite
	input	logic						awvalid_i,
	input	logic	[ADDR_WIDTH - 1:0]	awaddr_i,
	input	logic						wvalid_i,
	input	logic	[31:0]				wdata_i,
	input	logic	[ 3:0]				wstrb_i,
	input	logic						bready_i,
	input	logic						arvalid_i,
	input	logic	[ADDR_WIDTH - 1:0]	araddr_i,
	input	logic						rready_i,

	// Outputs
	output	logic						awready_o,
	output	logic						wready_o,
	output	logic						bvalid_o,
	output	logic	[1:0]				bresp_o,
	output	logic						arready_o,
	output	logic						rvalid_o,
	output	logic	[31:0]				rdata_o,
	output	logic	[ 1:0]				rresp_o,

	// unused AXI signal
	input	logic	[ 2:0]				awprot_i,
	input	logic	[ 2:0]				arprot_i,

	// UART TX/RX
	input	logic						uart_rx,
	output	logic						uart_tx,
	input	logic						uart_cts,	// high: master cannot take input
	output	logic						uart_rts	// high: we cannot take input
);

	assign uart_rts = 1'b0;	// disable flow control for now

	// UART module wire
	logic			uart_send_data, rx_done_raw, rx_done, tx_done;
	logic	[7:0]	tx_data, rx_data;

	// SIMP bus wire
	logic	[31:0]	simp_addr;
	logic	[31:0]	simp_data_in;
	logic			simp_wr;
	logic			simp_rd;
	logic			simp_valid;
	logic	[ 3:0]	simp_be;

	logic	[31:0]	simp_data_out;
	logic			simp_done;

	// operation define
	logic			op_write_tx_fifo, op_write_tx_fifo_done;
	logic			op_read_rx_fifo, op_read_rx_fifo_done;
	logic			op_read_rx_num, op_read_rx_num_done;

	always_comb begin : op_assign
		op_write_tx_fifo	= simp_valid && simp_wr && (simp_addr == UART_DATA_ADDR);
		op_read_rx_fifo		= simp_valid && simp_rd && (simp_addr == UART_DATA_ADDR);
		op_read_rx_num		= simp_valid && simp_rd && (simp_addr == UART_RX_DATA_NUM_ADDR);
	end

	assign			simp_done	=	op_write_tx_fifo_done ||
									op_read_rx_fifo_done ||
									op_read_rx_num_done;

	// TX side logic
	logic	[7:0]	fifo_in_tx, fifo_out_tx;
	logic			fifo_wr_en_tx, fifo_rd_en_tx;
	logic			fifo_empty_tx;


	fifo # (
		.BUF_WIDTH			(FIFO_WIDTH_TX),
		.DATA_WIDTH			(8)
	) uart_tx_fifo (
		.clk				(clk),
		.rst				(rst),
		.buf_in				(fifo_in_tx),
		.buf_out			(fifo_out_tx),
		.wr_en				(fifo_wr_en_tx),
		.rd_en				(fifo_rd_en_tx),
		.buf_empty			(fifo_empty_tx),
		.buf_full			(),
		.buf_almost_full	(),
		.fifo_counter		()
	);


	typedef enum logic [1:0] {
		IDLE_FIFO_TX,
		WRITE_FIFO_TX
	} uart_tx_fifo_state_t;
	uart_tx_fifo_state_t state_fifo_tx, nxt_state_fifo_tx;

	always_ff @( posedge clk, posedge rst ) begin
		if (rst)
			state_fifo_tx <= IDLE_FIFO_TX;
		else
			state_fifo_tx <= nxt_state_fifo_tx;
	end


	always_comb begin : uart_tx_fifo_state_fsm
		nxt_state_fifo_tx		= IDLE_FIFO_TX;
		fifo_in_tx				= 8'b0;
		fifo_wr_en_tx			= 1'b0;
		op_write_tx_fifo_done	= 1'b0;

		unique case (state_fifo_tx)

			IDLE_FIFO_TX: 	begin
				if (op_write_tx_fifo) begin
					nxt_state_fifo_tx	= WRITE_FIFO_TX;
				end else begin
					nxt_state_fifo_tx	= IDLE_FIFO_TX;
				end
			end

			WRITE_FIFO_TX:	begin
				fifo_in_tx				= (ENDIANESS == BIG_ENDIAN) ? simp_data_in[7:0] : simp_data_in[31:24];
				fifo_wr_en_tx			= ENABLE;
				nxt_state_fifo_tx		= IDLE_FIFO_TX;
				op_write_tx_fifo_done	= DONE;
			end

			default:	begin
				nxt_state_fifo_tx		= IDLE_FIFO_TX;
				fifo_in_tx				= 8'b0;
				fifo_wr_en_tx			= 1'b0;
				op_write_tx_fifo_done	= 1'b0;
			end
		endcase

	end

	typedef enum logic [1:0] {
		IDLE_TX,
		WAIT_LOAD_TX,
		TRANSMIT_TX
	} uart_tx_state_t;
	uart_tx_state_t state_uart_tx, nxt_state_uart_tx;
	
	always_ff @( posedge clk or posedge rst) begin
		if (rst)
			state_uart_tx <= IDLE_TX;
		else
			state_uart_tx <= nxt_state_uart_tx;
	end

	always_comb begin : uart_tx_state_fsm

		nxt_state_uart_tx	= IDLE_TX;
		tx_data				= fifo_out_tx;
		fifo_rd_en_tx		= DISABLE;
		uart_send_data		= DISABLE;
	
		unique case (state_uart_tx)
			IDLE_TX:		begin
				if (~fifo_empty_tx) begin
					nxt_state_uart_tx	= WAIT_LOAD_TX;
					fifo_rd_en_tx		= ENABLE;
				end else begin
					nxt_state_uart_tx	= IDLE_TX;
				end
			end

			WAIT_LOAD_TX:	begin
				nxt_state_uart_tx		= TRANSMIT_TX;
				uart_send_data			= ENABLE;
			end

			TRANSMIT_TX:	begin
				if (tx_done) begin
					nxt_state_uart_tx	= IDLE_TX;
				end else begin
					nxt_state_uart_tx	= TRANSMIT_TX;
				end
			end

			default:		begin
				nxt_state_uart_tx	= IDLE_TX;
				tx_data				= fifo_out_tx;
				fifo_rd_en_tx		= DISABLE;
				uart_send_data		= DISABLE;
			end
		endcase
	end


	// RX side logic
	logic	[7:0]	fifo_in_rx, fifo_out_rx;
	logic			fifo_wr_en_rx, fifo_rd_en_rx;
	logic			fifo_counter_rx;
	logic			rx_done_ff0, rx_done_ff1;

	always_ff @(posedge clk, posedge rst) begin : rx_done_pos_edge_detect
		if (rst) begin
			rx_done_ff0 <= 1'b0;
			rx_done_ff1 <= 1'b1;
		end else begin
			rx_done_ff0 <= rx_done_raw;
			rx_done_ff1 <= rx_done_ff0;
		end
	end

	assign rx_done = rx_done_ff1 && ~rx_done_ff0;

	fifo # (
		.BUF_WIDTH			(FIFO_WIDTH_TX),
		.DATA_WIDTH			(8)
	) uart_rx_fifo (
		.clk				(clk),
		.rst				(rst),
		.buf_in				(fifo_in_rx),
		.buf_out			(fifo_out_rx),
		.wr_en				(fifo_wr_en_rx),
		.rd_en				(fifo_rd_en_rx),
		.buf_empty			(),
		.buf_full			(),
		.buf_almost_full	(),
		.fifo_counter		(fifo_counter_rx)
	);


	typedef enum logic [2:0] {
		IDLE_RX,
		LOAD_CHAR_RX,
		READ_NUM_RX
	} uart_rx_state_t;
	uart_rx_state_t state_uart_rx, nxt_state_uart_rx;
	
	always_ff @( posedge clk or posedge rst) begin
		if (rst)
			state_uart_rx <= IDLE_RX;
		else
			state_uart_rx <= nxt_state_uart_rx;
	end

	always_comb begin : fifo_rx_ctrl
		fifo_in_rx		= rx_done ? rx_data : 8'b0;
		fifo_wr_en_rx	= rx_done;
	end

	data_t	rx_num_big, rx_num_small;
	assign rx_num_big = { {(XLEN-FIFO_WIDTH_TX){1'b0}} {fifo_counter_rx} };
	assign rx_num_small = swap_endian(rx_num_big);

	data_t	rx_data_big, rx_data_small;
	assign rx_data_big = {{24'b0}, {fifo_out_rx}};
	assign rx_data_small = {{fifo_out_rx}, {24'b0}};

	always_comb begin : uart_rx_fifo_state_fsm

		nxt_state_uart_rx		= IDLE_RX;
		fifo_rd_en_rx			= DISABLE;
		op_read_rx_fifo_done	= DISABLE;
		op_read_rx_num_done		= DISABLE;
		simp_data_out			= NULL;

		unique case (state_uart_rx)
			IDLE_RX: begin
				if (op_read_rx_fifo) begin
					nxt_state_uart_rx	= LOAD_CHAR_RX;
					fifo_rd_en_rx		= ENABLE;
				end else if (op_read_rx_num) begin
					nxt_state_uart_rx	= READ_NUM_RX;
				end else begin
					nxt_state_uart_rx	= IDLE_RX;
				end
			end

			LOAD_CHAR_RX: begin
				nxt_state_uart_rx		= IDLE_RX;
				op_read_rx_fifo_done	= DONE;
				simp_data_out			= (ENDIANESS == BIG_ENDIAN) ? rx_data_big : rx_data_small;
			end

			READ_NUM_RX: begin
				nxt_state_uart_rx	= IDLE_RX;
				op_read_rx_num_done	= DONE;
				simp_data_out		= (ENDIANESS == BIG_ENDIAN) ? rx_num_big : rx_num_small;
			end

			default: begin
				nxt_state_uart_rx		= IDLE_RX;
				fifo_rd_en_rx			= DISABLE;
				op_read_rx_fifo_done	= DISABLE;
				simp_data_out			= NULL;
			end

		endcase
	end


	uart # (
		.CLK_FREQ	(CLK_FREQ),
		.UART_BPS	(UART_BPS)
	) my_uart (
		// input
		.clk		(clk),
		.rst_n		(~rst),
		.RX			(uart_rx),
		.send_data	(uart_send_data),
		.tx_data	(tx_data),

		// output
		.TX			(uart_tx),
		.rx_done	(rx_done_raw),
		.tx_done	(tx_done),
		.rx_data	(rx_data)
	);


	// connect everything with same name
	axil2simp #(
		.ADDR_WIDTH	(ADDR_WIDTH)
	) axil_to_simp_bridge 
	(
		.*
	);
	

endmodule : uart_axil
