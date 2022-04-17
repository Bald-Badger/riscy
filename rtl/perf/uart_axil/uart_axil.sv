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
	output	logic						uart_tx
);

	// UART module wire
	logic			uart_send_data, rx_done, tx_done;
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

	logic			simp_done_tx, simp_done_rx;
	assign			simp_done_rx = 1'b0;
	assign			simp_done = simp_done_tx || simp_done_rx;


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
		WRITE_FIFO_TX,
		READ_FIFO_TX
	} uart_tx_fifo_state_t;
	uart_tx_fifo_state_t state_fifo_tx, nxt_state_fifo_tx;

	always_ff @( posedge clk, posedge rst ) begin
		if (rst)
			state_fifo_tx <= IDLE_FIFO_TX;
		else
			state_fifo_tx <= nxt_state_fifo_tx;
	end


	always_comb begin : uart_tx_fifo_state_fsm
		nxt_state_fifo_tx	= IDLE_FIFO_TX;
		fifo_in_tx		= 8'b0;
		fifo_wr_en_tx	= 1'b0;
		simp_done_tx	= 1'b0;

		unique case (state_fifo_tx)

			IDLE_FIFO_TX: 	begin
				if (simp_wr && simp_valid) begin
					nxt_state_fifo_tx = WRITE_FIFO_TX;
				end else if (simp_rd && simp_valid) begin
					nxt_state_fifo_tx = READ_FIFO_TX;
				end else begin
					// reserved, do nothing for now
					nxt_state_fifo_tx = IDLE_FIFO_TX;
				end
			end

			WRITE_FIFO_TX:	begin
				fifo_in_tx = simp_data_in[7:0];
				fifo_wr_en_tx = ENABLE;
				nxt_state_fifo_tx = IDLE_FIFO_TX;
				simp_done_tx = DONE;
			end

			READ_FIFO_TX:	begin
				simp_done_tx = DONE;
				nxt_state_fifo_tx = IDLE_FIFO_TX;
			end

			default:	begin
				nxt_state_fifo_tx	= IDLE_FIFO_TX;
				fifo_in_tx		= 8'b0;
				fifo_wr_en_tx	= 1'b0;
				simp_done_tx	= 1'b0;
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
		.rx_done	(rx_done),
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
