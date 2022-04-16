// state machine for handling R/W via axi-lite bus

import defines::*;
import mem_defines::*;
import axi_defines::*;

module mem_sys_axil #(
	localparam WIDTH = XLEN
) (
	input	logic					clk,
	input	logic					rst_n,

	input	cache_addr_t			addr,			// still 32 bits
	input	data_t					data_in,
	input	logic					wr,
	input	logic					rd,
	input	logic					valid,
	input	logic					[BYTES-1:0] be,	// for write only
	
	output	data_t					data_out,
	output	logic					done,

	// AXI-Lite master interface
	output	logic 					m_axil_clk,		// bus clock
	output	logic 					m_axil_rst,		// bus reset, active high
	output	logic [WIDTH-1:0]		m_axil_awaddr,	// Write address
	output	logic [2:0]				m_axil_awprot,	// Write protection level, see axi_defines.sv
	output	logic					m_axil_awvalid,	// Write address valid, signaling valid write address and control information.
	input	logic					m_axil_awready,	// Write address ready (from slave), ready to accept an address and associated control signals
	output	logic [WIDTH-1:0]		m_axil_wdata,	// Write data
	output	logic [WIDTH/8-1:0]		m_axil_wstrb,	// Write data strobe (byte select)
	output	logic					m_axil_wvalid,	// Write data valid, write data and strobes are available
	input	logic					m_axil_wready,	// Write data ready, slave can accept the write data
	input	logic [1:0]				m_axil_bresp,	// Write response (from slave)
	input	logic					m_axil_bvalid,	// Write response valid, signaling a valid write response
	output	logic					m_axil_bready,	// Write response ready (from master) can accept a write response
	output	logic [WIDTH-1:0]		m_axil_araddr,	// Read address
	output	logic [2:0]				m_axil_arprot,	// Read protection level, see axi_defines.sv
	output	logic					m_axil_arvalid,	// Read address valid,  signaling valid read address and control information
	input	logic					m_axil_arready,	// Read address ready (from slave), ready to accept an address and associated control signals
	input	logic [WIDTH-1:0]		m_axil_rdata,	// Read data
	input	logic [1:0]				m_axil_rresp,	// Read response (from slave)
	input	logic					m_axil_rvalid,	// Read response valid, the channel is signaling the required read data
	output	logic					m_axil_rready	// Read response ready (from master), can accept the read data and response information
	// end AXI-Lite master interface
);

	logic	rst;
	assign rst = ~rst_n;

	logic rden, wren;
	//assign rdrn = rd;
	//assign wren = wr;
	assign rden = rd && valid;
	assign wren = wr && valid;

	typedef enum logic[2:0] {
		IDLE,
		R_ADDR,
		R_DATA,
		W_ADDR,
		W_DATA,
		W_RESP,
		BAD
	} state_t;

	state_t state, nxt_state;

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
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
		read_addr_handshake = m_axil_arready && m_axil_arvalid && rden;
		read_data_handshake = m_axil_rready && m_axil_rvalid && rden;
		write_addr_handshake = m_axil_awready && m_axil_awvalid && wren;
		write_data_handshake = m_axil_wready && m_axil_wvalid && wren;
		write_resp_handshake = m_axil_bready && m_axil_bvalid && wren;
		read_handshake = {read_addr_handshake, read_data_handshake};
		write_handshake = {write_addr_handshake, write_data_handshake, write_resp_handshake};
	end

	always_comb begin
		data_out		= NULL;
		done			= 1'b0;
		nxt_state		= IDLE;

		// general
		m_axil_clk		= clk;
		m_axil_rst		= ~rst_n;

		// write
		m_axil_awaddr	= NULL;
		m_axil_awprot	= basic_awport;
		m_axil_awvalid	= INVALID;
		m_axil_wdata	= NULL;
		m_axil_wstrb	= be;
		m_axil_wvalid	= INVALID;
		m_axil_bready	= READY;

		// read
		m_axil_araddr	= NULL;
		m_axil_arprot	= basic_awport;
		m_axil_arvalid	= INVALID;
		m_axil_rready	= READY;

		/*
		input signals:
		m_axil_awready,	// Write address ready (from slave), ready to accept address / ctrl
		m_axil_wready,	// Write data ready, slave can accept the write data
		m_axil_bresp,	// Write response (from slave)
		m_axil_bvalid,	// Write response valid

		m_axil_arready,	// Read address ready (from slave), ready to accept an address and associated control signals
		m_axil_rdata,	// Read data
		m_axil_rresp,	// Read response (from slave)
		m_axil_rvalid,	// Read response valid, the channel is signaling the required read data
		*/

		unique case (state)
			IDLE: begin
				if (rden) begin
					m_axil_rready	= READY;
					m_axil_araddr	= addr;
					m_axil_arvalid	= VALID;
					if (read_handshake == 2'b00) begin
						nxt_state		= R_ADDR;
						done			= 1'b0;
						data_out		= NULL;
					end else if (read_handshake == 2'b10) begin
						nxt_state		= R_DATA;
						done			= 1'b0;
						data_out		= NULL;
					end else if (read_handshake == 2'b11) begin
						nxt_state		= IDLE;
						done			= DONE;
						data_out		= m_axil_rdata;
					end else begin
						nxt_state		= BAD;
						done			= 1'b0;
						data_out		= NULL;
					end
				end else if (wren) begin
					m_axil_awaddr	= addr;
					m_axil_awvalid	= VALID;
					m_axil_wdata	= data_in;
					m_axil_wvalid	= VALID;
					if (write_handshake == 3'b000) begin
						nxt_state	= W_ADDR;
						done		= 1'b0;
					end else if (write_handshake == 3'b100) begin
						nxt_state	= W_DATA;
						done		= 1'b0;
					end else if (write_handshake == 3'b110) begin
						nxt_state	= W_RESP;
						done		= 1'b0;
					end else if (write_handshake == 3'b111) begin
						nxt_state	= IDLE;
						done		= DONE;
					end else begin
						nxt_state	= BAD;
						done		= 1'b0;
					end
				end else begin
					nxt_state = IDLE;
				end
			end

			R_ADDR: begin
				m_axil_rready	= READY;
				m_axil_araddr	= addr;
				m_axil_arvalid	= VALID;
				if (read_handshake == 2'b00) begin
					nxt_state	= R_ADDR;
					done		= 1'b0;
					data_out	= NULL;
				end else if (read_handshake == 2'b10) begin
					nxt_state	= R_DATA;
					done		= 1'b0;
					data_out	= NULL;
				end else if (read_handshake == 2'b11) begin
					nxt_state	= IDLE;
					done		= DONE;
					data_out	= m_axil_rdata;
				end else begin
					nxt_state	= BAD;
					done		= 1'b0;
					data_out	= NULL;
				end
			end

			R_DATA: begin
				m_axil_rready = READY;
				if (read_handshake == 2'b00) begin
					nxt_state	= R_DATA;
					done		= 1'b0;
					data_out	= NULL;
				end else if (read_handshake == 2'b01) begin
					nxt_state	= IDLE;
					done		= DONE;
					data_out	= m_axil_rdata;
				end else begin
					nxt_state	= BAD;
					done		= 1'b0;
					data_out	= NULL;
				end
			end

			W_ADDR: begin
				m_axil_awaddr	= addr;
				m_axil_awvalid	= VALID;
				m_axil_wdata	= data_in;
				m_axil_wvalid	= VALID;
				if (write_handshake == 3'b000) begin
					nxt_state	= W_ADDR;
					done		= 1'b0;
				end else if (write_handshake == 3'b100) begin
					nxt_state	= W_DATA;
					done		= 1'b0;
				end else if (write_handshake == 3'b110) begin
					nxt_state	= W_RESP;
					done		= 1'b0;
				end else if (write_handshake == 3'b111) begin
					nxt_state	= IDLE;
					done		= DONE;
				end else begin
					nxt_state	= BAD;
					done		= 1'b0;
				end
			end

			W_DATA: begin
				m_axil_awaddr	= NULL;
				m_axil_awvalid	= INVALID;
				m_axil_wdata	= data_in;
				m_axil_wvalid	= VALID;
				if (write_handshake == 3'b000) begin
					nxt_state	= W_DATA;
					done		= 1'b0;
				end else if (write_handshake == 3'b010) begin
					nxt_state	= W_RESP;
					done		= 1'b0;
				end else if (write_handshake == 3'b011) begin
					nxt_state	= IDLE;
					done		= DONE;
				end else begin
					nxt_state	= BAD;
					done		= 1'b0;
				end
			end

			W_RESP: begin
				m_axil_awaddr	= NULL;
				m_axil_awvalid	= INVALID;
				m_axil_wdata	= NULL;
				m_axil_wvalid	= INVALID;
				if (write_handshake == 3'b000) begin
					nxt_state	= W_RESP;
					done		= 1'b0;
				end else if (write_handshake == 3'b001) begin
					nxt_state	= IDLE;
					done		= DONE;
				end else begin
					nxt_state	= BAD;
					done		= 1'b0;
				end
			end

			BAD: begin
				nxt_state = BAD;
			end

			default: begin
				data_out		= NULL;
				done			= 1'b0;
				nxt_state		= IDLE;
				m_axil_awaddr	= NULL;
				m_axil_awprot	= basic_awport;
				m_axil_awvalid	= INVALID;
				m_axil_wdata	= NULL;
				m_axil_wstrb	= be;
				m_axil_wvalid	= INVALID;
				m_axil_bready	= VALID;
				m_axil_araddr	= NULL;
				m_axil_arprot	= basic_awport;
				m_axil_arvalid	= INVALID;
				m_axil_rready	= VALID;
			end
		endcase
	end

//////////////////////////// Formal Verifivation //////////////////////////////////

	/////////// read handshake ///////////
	property read_handshake_success;
		disable iff (m_axil_rst)
		@(posedge m_axil_clk) read_addr_handshake |=> ##[0 : MEM_ACCESS_TIMEOUT] read_data_handshake;
	endproperty

	assert property(read_handshake_success)
		else $error("AXI-L read timeout");
	/////////////////////////////////////


	/////////// write handshake ///////////
	property write_addr_handshake_success;
		disable iff (m_axil_rst)
		@(posedge m_axil_clk) write_addr_handshake |=> ##[0 : MEM_ACCESS_TIMEOUT] write_resp_handshake;
	endproperty

	assert property(write_addr_handshake_success)
		else $error("AXI-L write addr -> resp timeout");


	property write_data_handshake_success;
		disable iff (m_axil_rst)
		@(posedge m_axil_clk) write_data_handshake |=> ##[0 : MEM_ACCESS_TIMEOUT] write_resp_handshake;
	endproperty

	assert property(write_data_handshake_success)
		else $error("AXIL write data -> resp timeout");
	/////////////////////////////////////

////////////////////////// End Formal Verifivation /////////////////////////////////

endmodule : mem_sys_axil
