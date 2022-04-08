// reference: https://github.com/ultraembedded/core_soc/blob/master/src_v/gpio.v

import pref_defines::*;
import axi_defines::*

module seg_axil (
	// Inputs
	input			clk,
	input			rst,

	// axi
	input			cfg_awvalid_i,
	input	[31:0]	cfg_awaddr_i,
	input			cfg_wvalid_i,
	input	[31:0]	cfg_wdata_i,
	input	[ 3:0]	cfg_wstrb_i,
	input			cfg_bready_i,
	input			cfg_arvalid_i,
	input	[31:0]	cfg_araddr_i,
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

	// 7Seg output
	output	[6:0]	hex0,
	output	[6:0]	hex1,
	output	[6:0]	hex2,
	output	[6:0]	hex3,
	output	[6:0]	hex4,
	output	[6:0]	hex5
);

	typedef enum logic[2:0] {
		IDLE,
		W_ADDR,
		W_DATA,
		W_RESP,
		R_ADDR,
		R_RESP
	} state_t;

	state_t state, nxt_state;

	always_ff @( posedge clk, posedge rst ) begin
		if (rst)
			state <= IDLE;
		else
			state <= nxt_state;
	end

	// five channels' handshake
	logic read_addr_handshake, read_data_handshake;
	logic write_addr_handshake, write_data_handshake, write_resp_handshake;
	logic [1:0] read_handshake;
	logic [2:0] write_handshake;

	always_comb begin
		read_addr_handshake = cfg_arready_o && cfg_arvalid_i;
		read_data_handshake = cfg_rready_i && cfg_rvalid_o;
		write_addr_handshake = cfg_awready_o && cfg_awvalid_i;
		write_data_handshake = cfg_wready_o && cfg_wvalid_i;
		write_resp_handshake = cfg_bready_i && cfg_bvalid_o;
		read_handshake = {read_addr_handshake, read_data_handshake};
		write_handshake = {write_addr_handshake, write_data_handshake, write_resp_handshake};
	end

	always_comb begin : fsm
		nxt_state		= IDLE;
		cfg_awready_o	= 1'b0;
		cfg_wready_o	= 1'b0;
		cfg_bvalid_o	= INVALID;
		cfg_bresp_o		= RESP_OKAY;
		cfg_arready_o	= 1'b0;
		cfg_rvalid_o	= INVALID;
		cfg_rdata_o		= NULL;
		cfg_rresp_o		= RESP_OKAY;

		/*
		input			cfg_awvalid_i,
		input	[31:0]	cfg_awaddr_i,
		input			cfg_wvalid_i,
		input	[31:0]	cfg_wdata_i,
		input	[ 3:0]	cfg_wstrb_i,
		input			cfg_bready_i,
		input			cfg_arvalid_i,
		input	[31:0]	cfg_araddr_i,
		input			cfg_rready_i,
		*/

		unique case (state)

			IDLE:	begin
				if (cfg_arvalid_i) begin
					cfg_arready_o = 1'b1;
					nxt_state = R_RESP;
				end else if (cfg_awvalid_i) begin
					
				end else begin
					nxt_state	= IDLE;
				end
			end

			W_ADDR:	begin
				
			end

			W_DATA:	begin
				
			end

			W_RESP:	begin
				
			end

			R_RESP:	begin
				cfg_rvalid_o = VALID;
				if (read_data_handshake) begin
					nxt_state = IDLE;
				end else begin
					nxt_state = R_RESP;
				end
			end

			default:begin
				
			end

		endcase
	end



	logic	[3:0]	a0,a1,a2,a3,a4,a5;

	hex7seg h0 (
		.a	(a0),
		.y	(hex0)
	);

	hex7seg h1 (
		.a	(a1),
		.y	(hex1)
	);

	hex7seg h2 (
		.a	(a2),
		.y	(hex2)
	);

	hex7seg h3 (
		.a	(a3),
		.y	(hex3)
	);

	hex7seg h4 (
		.a	(a4),
		.y	(hex4)
	);

	hex7seg h5 (
		.a	(a5),
		.y	(hex5)
	);
	
endmodule : seg_axil