// axil slave to simp master

import defines::*;
import pref_defines::*;
import axi_defines::*;

/*
here I define the simp interface:
input 	logics:
	addr
	data_in
	wr
	rd
	valid
	be

output	logics
	data_out
	done

valid must stay high until done is asserted
handshake is valid && done
done only assert for one cycle
on a read; addr, rd, valid, be must hold until done
on a write; addr, wr, valid, be must hold until done
data_out must valid when handshake
must not read-when-write
slave must finally assert done regardless of r/w success
*/

module axil2simp # (
	parameter	ADDR_WIDTH = 16
) (
	// Inputs
	input 	logic						clk,
	input 	logic						rst,

	// axi
	input 	logic						awvalid_i,
	input 	logic	[ADDR_WIDTH - 1:0]	awaddr_i,
	input 	logic						wvalid_i,
	input 	logic	[31:0]				wdata_i,
	input 	logic	[ 3:0]				wstrb_i,
	input 	logic						bready_i,
	input 	logic						arvalid_i,
	input 	logic	[ADDR_WIDTH - 1:0]	araddr_i,
	input 	logic						rready_i,

	output	logic						awready_o,
	output	logic						wready_o,
	output	logic						bvalid_o,
	output	logic	[1:0]				bresp_o,
	output	logic						arready_o,
	output	logic						rvalid_o,
	output	logic	[31:0]				rdata_o,
	output	logic	[ 1:0]				rresp_o,

	// unused AXI signal
	input 	logic	[ 2:0]				awprot_i,
	input 	logic	[ 2:0]				arprot_i,

	// simp master interface
	output 	logic	[31:0]				simp_addr,
	output 	logic	[31:0]				simp_data_in,
	output 	logic						simp_wr,
	output 	logic						simp_rd,
	output 	logic						simp_valid,
	output 	logic	[ 3:0]				simp_be,

	input	logic	[31:0]				simp_data_out,
	input	logic						simp_done
);

	typedef enum logic[2:0] {
		IDLE,
		W_DATA,
		W_RESP,
		W_SIMP,
		R_RESP,
		R_DONE
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
		read_addr_handshake		= arready_o && arvalid_i;
		read_data_handshake		= rready_i && rvalid_o;
		write_addr_handshake	= awready_o && awvalid_i;
		write_data_handshake	= wready_o && wvalid_i;
		write_resp_handshake	= bready_i && bvalid_o;
	end

	logic simp_handshake;
	assign simp_handshake = simp_valid && simp_done;

	data_t simp_addr_reg;
	data_t simp_data_out_reg;

	always_ff @( posedge clk ) begin
		if (read_addr_handshake)
			simp_addr_reg <= araddr_i;
		else if (write_addr_handshake)
			simp_addr_reg <= awaddr_i;
		else
			simp_addr_reg <= simp_addr_reg;
	end

	always_ff @( posedge clk ) begin
		if (write_data_handshake)
			simp_data_in <= wdata_i;
		else
			simp_data_in <= simp_data_in;
	end

	always_ff @( posedge clk ) begin
		if (simp_valid && simp_done && simp_rd)
			simp_data_out_reg <= simp_data_out;
		else
			simp_data_out_reg <= simp_data_out_reg;	
	end

	always_comb begin : fsm
		nxt_state		= IDLE;
		awready_o		= 1'b0;
		wready_o		= 1'b0;
		bvalid_o		= INVALID;
		bresp_o			= RESP_OKAY;
		arready_o		= 1'b0;
		rvalid_o		= INVALID;
		rdata_o			= NULL;
		rresp_o			= RESP_OKAY;

		simp_addr		= NULL;
		simp_wr			= DISABLE;
		simp_rd			= DISABLE;
		simp_valid		= VALID;
		simp_be			= 4'b0;

		unique case (state)

			IDLE:	begin
				arready_o			= 1'b1;
				if (arvalid_i) begin
					nxt_state		= R_RESP;
				end else if (awvalid_i) begin
					awready_o		= 1'b1;
					if (wvalid_i) begin
						wready_o	= 1'b1;
						nxt_state	= W_SIMP;
					end else begin
						nxt_state	= W_DATA;
					end
				end else begin
					nxt_state		= IDLE;
				end
			end

			W_DATA:	begin
				if (wvalid_i) begin
					wready_o = 1'b1;
					nxt_state = W_SIMP;
				end begin
					nxt_state = W_DATA;
				end
			end

			W_SIMP:	begin
				simp_addr		= simp_addr_reg;
				simp_wr			= ENABLE;
				simp_valid		= VALID;
				simp_be			= wstrb_i;

				if (simp_handshake) begin
					nxt_state	= W_RESP;
				end else begin
					nxt_state	= W_SIMP;
				end
			end

			W_RESP: begin
				bvalid_o = VALID;
				if (write_resp_handshake) begin
					nxt_state = IDLE;
				end else begin
					nxt_state = W_RESP;
				end
			end

			R_RESP:	begin
				simp_addr		= simp_addr_reg;
				simp_rd			= ENABLE;
				simp_valid		= VALID;
				simp_be			= 4'b1111;
				if (simp_handshake) begin
					nxt_state	= R_DONE;
				end else begin
					nxt_state	= R_RESP;
				end
			end

			R_DONE: begin
				rvalid_o		= VALID;
				rdata_o			= simp_data_out_reg;
				if (rready_i)
					nxt_state	= IDLE;
				else
					nxt_state	= R_DONE;
			end

			default:begin
				nxt_state	= IDLE;
				awready_o	= 1'b0;
				wready_o	= 1'b0;
				bvalid_o	= INVALID;
				bresp_o		= RESP_OKAY;
				arready_o	= 1'b0;
				rvalid_o	= INVALID;
				rdata_o		= NULL;
				rresp_o		= RESP_OKAY;
			end

		endcase
	end
	
endmodule : axil2simp
