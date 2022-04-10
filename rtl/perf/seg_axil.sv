import defines::*;
import pref_defines::*;
import axi_defines::*;

module seg_axil (
	// Inputs
	input			clk,
	input			rst,

	// axi
	input			cfg_awvalid_i,
	input	[4:0]	cfg_awaddr_i,
	input			cfg_wvalid_i,
	input	[31:0]	cfg_wdata_i,
	input	[ 3:0]	cfg_wstrb_i,
	input			cfg_bready_i,
	input			cfg_arvalid_i,
	input	[4:0]	cfg_araddr_i,
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

	// 7-Seg output
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

	always_comb begin
		read_addr_handshake = cfg_arready_o && cfg_arvalid_i;
		read_data_handshake = cfg_rready_i && cfg_rvalid_o;
		write_addr_handshake = cfg_awready_o && cfg_awvalid_i;
		write_data_handshake = cfg_wready_o && cfg_wvalid_i;
		write_resp_handshake = cfg_bready_i && cfg_bvalid_o;
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

		unique case (state)

			IDLE:	begin
				if (cfg_arvalid_i) begin
					cfg_arready_o = 1'b1;
					nxt_state = R_RESP;
				end else if (cfg_awvalid_i) begin
					cfg_awready_o = 1'b1;
					if (cfg_wvalid_i) begin
						cfg_wready_o = 1'b1;
						nxt_state = W_RESP;
					end else begin
						nxt_state = W_DATA;
					end
				end else begin
					nxt_state	= IDLE;
				end
			end

			W_DATA:	begin
				if (cfg_wvalid_i) begin
					cfg_wready_o = 1'b1;
					nxt_state = W_RESP;
				end begin
					nxt_state = W_DATA;
				end
			end

			W_RESP:	begin
				cfg_bvalid_o = VALID;
				if (write_resp_handshake) begin
					nxt_state = IDLE;
				end else begin
					nxt_state = W_RESP;
				end
			end

			R_RESP:	begin
				cfg_rvalid_o = VALID;
				unique case (rd_addr_latch & SEG_ADDR_MASK)
					SEG_H0_OFF:	begin
						cfg_rdata_o = {{28'b0}, {seg_mem[0]}};
					end

					SEG_H0_OFF:	begin
						cfg_rdata_o = {{28'b0}, {seg_mem[1]}};
					end

					SEG_H0_OFF:	begin
						cfg_rdata_o = {{28'b0}, {seg_mem[2]}};
					end

					SEG_H0_OFF:	begin
						cfg_rdata_o = {{28'b0}, {seg_mem[3]}};
					end

					SEG_H0_OFF:	begin
						cfg_rdata_o = {{28'b0}, {seg_mem[4]}};
					end

					SEG_H0_OFF:	begin
						cfg_rdata_o = {{28'b0}, {seg_mem[5]}};
					end

					default:	begin
						cfg_rdata_o = NULL;
					end
				endcase
				if (read_data_handshake) begin
					nxt_state = IDLE;
				end else begin
					nxt_state = R_RESP;
				end
			end

			default:begin
				nxt_state		= IDLE;
				cfg_awready_o	= 1'b0;
				cfg_wready_o	= 1'b0;
				cfg_bvalid_o	= INVALID;
				cfg_bresp_o		= RESP_OKAY;
				cfg_arready_o	= 1'b0;
				cfg_rvalid_o	= INVALID;
				cfg_rdata_o		= NULL;
				cfg_rresp_o		= RESP_OKAY;
			end

		endcase
	end

	// (* RAM_STYLE="logic" *)
	logic	[3:0]	seg_mem [0:5];

	logic	[4:0]	seg_address, wr_addr_latch, rd_addr_latch;
	assign	seg_address = cfg_awaddr_i[4:0] & SEG_ADDR_MASK;

	logic	[3:0]	seg_data, data_latch;
	assign	seg_data = cfg_wdata_i[3:0];

	always_ff @( posedge clk ) begin
		if (write_addr_handshake)
			wr_addr_latch <= seg_address;
		if (write_data_handshake)
			data_latch <= seg_data;
		if (read_addr_handshake);
			rd_addr_latch <= cfg_araddr_i[4:0];
	end

	integer i;

	always_ff @( posedge clk, posedge rst) begin
		if (rst) begin
			for (i = 0; i < 6; i++) begin
				seg_mem[i] <= 4'b0;
			end
		end else begin
			if (write_resp_handshake) begin
				for (i = 0; i < 6*4; i+=4) begin
					if (i == wr_addr_latch) begin
						seg_mem[i>>2] <= data_latch;
					end else begin
						seg_mem[i>>2] <= seg_mem[i>>2];
					end
				end
			end else begin
				for (i = 0; i < 6; i++) begin
					seg_mem[i] <= seg_mem[i];
				end
			end
		end
	end

	hex7seg h0 (
		.a	(seg_mem[0]),
		.y	(hex0)
	);

	hex7seg h1 (
		.a	(seg_mem[1]),
		.y	(hex1)
	);

	hex7seg h2 (
		.a	(seg_mem[2]),
		.y	(hex2)
	);

	hex7seg h3 (
		.a	(seg_mem[3]),
		.y	(hex3)
	);

	hex7seg h4 (
		.a	(seg_mem[4]),
		.y	(hex4)
	);

	hex7seg h5 (
		.a	(seg_mem[5]),
		.y	(hex5)
	);
	
endmodule : seg_axil