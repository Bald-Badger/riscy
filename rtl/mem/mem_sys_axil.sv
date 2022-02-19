// state machine for handling R/W via axi-lite bus

import defines::*;
import mem_defines::*;
import axi_defines::*;
`include "./axi_lite_interface.sv";

module mem_sys_axil #(
	parameter WIDTH = XLEN
) (
	input	logic						clk,
	input	logic						rst_n,

	input	cache_addr_t				addr,			// still 32 bits
	input	data_t						data_in,
	input	logic						wr,
	input	logic						rd,
	input	logic						valid,
	input	logic						[BYTES-1:0] be,	// for write only
	
	output	data_t						data_out,
	output	logic						done,

	// AXI-Lite master interface
	output	logic 						m_axil_clk,
	output	logic 						m_axil_rst,
	output	logic [WIDTH-1:0]			m_axil_awaddr,
	output	logic [2:0]					m_axil_awprot,
	output	logic						m_axil_awvalid,
	input	logic						m_axil_awready,
	output	logic [WIDTH-1:0]			m_axil_wdata,
	output	logic [WIDTH/8-1:0]			m_axil_wstrb,
	output	logic						m_axil_wvalid,
	input	logic						m_axil_wready,
	input	logic [1:0]					m_axil_bresp,
	input	logic						m_axil_bvalid,
	output	logic						m_axil_bready,
	output	logic [WIDTH-1:0]			m_axil_araddr,
	output	logic [2:0]					m_axil_arprot,
	output	logic						m_axil_arvalid,
	input	logic						m_axil_arready,
	input	logic [WIDTH-1:0]			m_axil_rdata,
	input	logic [1:0]					m_axil_rresp,
	input	logic						m_axil_rvalid,
	output	logic						m_axil_rready
);

	logic	rst;
	assign rst = ~rst_n;

	typedef enum logic[2:0] {
		IDLE,
		READ,
		WRITE
	} state_t;

	state_t state, nxt_state;

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			state <= IDLE;
		else
			state <= nxt_state;
	end

	always_comb begin
		nxt_state		= IDLE;
		m_axil_awaddr	= NULL;
		m_axil_awprot	= basic_awport;
		m_axil_awvalid	= INVALID;
		m_axil_wdata	= NULL;
		m_axil_wstrb	= 4'b0;
		m_axil_wvalid	= INVALID;
		m_axil_bready	= INVALID;
		m_axil_araddr	= NULL;
		m_axil_arprot	= basic_awport;
		m_axil_arvalid	= INVALID;
		m_axil_rready	= INVALID;

		unique case (state)
			
			IDLE: begin
				
			end

			READ: begin
				
			end

			WRITE: begin
				
			end

			default: begin
				nxt_state		= IDLE;
				m_axil_awaddr	= NULL;
				m_axil_awprot	= basic_awport;
				m_axil_awvalid	= INVALID;
				m_axil_wdata	= NULL;
				m_axil_wstrb	= 4'b0;
				m_axil_wvalid	= INVALID;
				m_axil_bready	= INVALID;
				m_axil_araddr	= NULL;
				m_axil_arprot	= basic_awport;
				m_axil_arvalid	= INVALID;
				m_axil_rready	= INVALID;
			end
		endcase
	end

endmodule : mem_sys_axil
