import defines::*;
import pref_defines::*;
import axi_defines::*;


module uart_axil #(
	parameter	CLK_FREQ = 5e7,
	parameter	UART_BPS = 9600,
	parameter	FIFO_WIDTH_TX = 10,	// FIFO depth = 2^WIDTH
	parameter	FIFO_WIDTH_RX = 5
) (
	// Inputs
	input			clk,
	input			rst,

	// axi
	input			cfg_awvalid_i,
	input	[3:0]	cfg_awaddr_i,
	input			cfg_wvalid_i,
	input	[31:0]	cfg_wdata_i,
	input	[ 3:0]	cfg_wstrb_i,
	input			cfg_bready_i,
	input			cfg_arvalid_i,
	input	[3:0]	cfg_araddr_i,
	input			cfg_rready_i,

	// Outputs
	output			cfg_awready_o,
	output			cfg_wready_o,
	output			cfg_bvalid_o,
	output	[1:0]	cfg_bresp_o,
	output			cfg_arready_o,
	output			cfg_rvalid_o,
	output	[31:0]	cfg_rdata_o,
	output	[ 1:0]	cfg_rresp_o,

	// unused AXI signal
	input	[ 2:0]	cfg_awprot_i,
	input	[ 2:0]	cfg_arprot_i,

	// UART TX/RX
	input	logic	uart_rx,
	output	logic	uart_tx
);

	// UART module wire
	logic uart_send_data, rx_done, tx_done
	logic [7:0] tx_data, rx_data;


	// five channels' handshake
	logic read_addr_handshake, read_data_handshake;
	logic write_addr_handshake, write_data_handshake, write_resp_handshake;

	always_comb begin
		read_addr_handshake = cfg_arready_o && cfg_arvalid_i;
		read_data_handshake = cfg_rready_i && cfg_rvalid_o;
		write_addr_handshake = cfg_awready_o && cfg_awvalid_i;
		write_data_handshake = cfg_wready_o && cfg_wvalid_i;
		write_resp_handshake = cfg_bready_i && cfg_bvalid_o;
	end


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
		IDLE_TX,
		TX
	} UART_TX_STATE_T;
	UART_TX_STATE_T state_tx, nxt_state_tx;

	always_ff @( posedge clk, posedge rst ) begin
		if (rst)
			state_tx <= IDLE_TX
		else
			state_tx <= nxt_state_tx;
	end


	always_comb begin : uart_tx_fsm

		unique case (state_tx)
			IDLE_TX: 	begin

			end

			TX:			begin
				
			end

			default:	begin
				
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
	

endmodule : uart_axil
