// state machine for handling R/W via axi-lite bus

import defines::*;
import mem_defines::*;
import axi_defines::*;
`include "./axi_lite_interface.sv";

module mem_sys_axil #(
	parameter WIDTH = XLEN
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
);

	logic	rst;
	assign rst = ~rst_n;

	typedef enum logic[2:0] {
		IDLE,
		READ_INIT,
		READ_RESP,
		WRITE_ADDR,
		WRITE_DATA,
		WRITE_RESP
	} state_t;

	state_t state, nxt_state;

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			state <= IDLE;
		else
			state <= nxt_state;
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
		m_axil_bready	= VALID;

		// read
		m_axil_araddr	= NULL;
		m_axil_arprot	= basic_awport;
		m_axil_arvalid	= INVALID;
		m_axil_rready	= VALID;

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
				if (valid && rd && ~m_axil_arready) begin
					nxt_state = READ_INIT;
					m_axil_araddr = addr;
					m_axil_arvalid = VALID;
					m_axil_rready	= VALID;
				end else if (valid && rd && m_axil_arready) begin
					nxt_state = READ_RESP;
					m_axil_araddr = addr;
					m_axil_arvalid = VALID;
					m_axil_rready	= VALID;
				end else if (valid && wr && ~m_axil_awready) begin
					nxt_state = WRITE_ADDR;
					m_axil_awaddr	= addr;
					m_axil_awvalid	= VALID;
					m_axil_wdata	= data_in;
					m_axil_wvalid	= VALID;
				end else if (valid && wr && m_axil_awready) begin
					nxt_state = WRITE_DATA;
					m_axil_awaddr	= addr;
					m_axil_awvalid	= VALID;
					m_axil_wdata	= data_in;
					m_axil_wvalid	= VALID;
				end else begin
					nxt_state = IDLE;
				end
			end

			READ_INIT: begin
				m_axil_araddr = addr;
				m_axil_arvalid = VALID;
				m_axil_rready = VALID;
				if (m_axil_arready) begin
					nxt_state = READ_RESP;
				end else begin
					nxt_state = READ_INIT;
				end
			end

			READ_RESP: begin
				m_axil_rready = VALID;
				if (m_axil_rvalid) begin
					nxt_state = IDLE;
					done = 1'b1;
					data_out = m_axil_rdata;
				end else begin
					nxt_state = READ_RESP;
					done = 1'b0;
					data_out = NULL;
				end
			end

			WRITE_ADDR: begin
				m_axil_awaddr	= addr;
				m_axil_awvalid	= VALID;
				m_axil_wdata	= data_in;
				m_axil_wvalid	= VALID;
				if (m_axil_awready && ~m_axil_wready) begin
					nxt_state = 
				end else if (~m_axil_awready && ~m_axil_wready) begin
					nxt_state = 
				end else begin

				end
			end

			WRITE_DATA: begin
				m_axil_awaddr	= NULL;
				m_axil_awvalid	= INVALID;
				m_axil_wdata	= data_in;
				m_axil_wvalid	= VALID;
				if (m_axil_wready) begin
					nxt_state = 
				end else begin
					nxt_state = 
				end
			end

			WRITE_RESP: begin
				m_axil_awaddr	= NULL;
				m_axil_awvalid	= INVALID;
				m_axil_wdata	= NULL;
				m_axil_wvalid	= INVALID;
				if (m_axil_bvalid) begin
					nxt_state = IDLE;
					done = 1'b1;
				end else begin
					nxt_state = WRITE_RESP;
					done = 1'b0;
				end
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

endmodule : mem_sys_axil
