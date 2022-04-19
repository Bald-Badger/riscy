import defines::*;
import mem_defines::*;
import axi_defines::*;

module mem_sys_axil_wrapper (
	input	logic				clk,
	input	logic				rst_n,

	input	cache_addr_t		addr,			// still 32 bits
	input	data_t				data_in,
	input	logic				wr,
	input	logic				rd,
	input	logic				valid,
	input	logic				[BYTES-1:0] be,	// for write only

	output	data_t				data_out,
	output	logic				done,

	axil_interface.axil_master	axil_bus
);

	mem_sys_axil mem_sys (
		.clk				(clk),
		.rst_n				(rst_n),
		.addr				(addr),
		.data_in			(data_in),
		.wr					(wr),
		.rd					(rd),
		.valid				(valid),
		.be					(be),
		.data_out			(data_out),
		.done				(done),
		.m_axil_awaddr		(axil_bus.axil_awaddr),
		.m_axil_awprot		(axil_bus.axil_awprot),
		.m_axil_awvalid		(axil_bus.axil_awvalid),
		.m_axil_awready		(axil_bus.axil_awready),
		.m_axil_wdata		(axil_bus.axil_wdata),
		.m_axil_wstrb		(axil_bus.axil_wstrb),
		.m_axil_wvalid		(axil_bus.axil_wvalid),
		.m_axil_wready		(axil_bus.axil_wready),
		.m_axil_bresp		(axil_bus.axil_bresp),
		.m_axil_bvalid		(axil_bus.axil_bvalid),
		.m_axil_bready		(axil_bus.axil_bready),
		.m_axil_araddr		(axil_bus.axil_araddr),
		.m_axil_arprot		(axil_bus.axil_arprot),
		.m_axil_arvalid		(axil_bus.axil_arvalid),
		.m_axil_arready		(axil_bus.axil_arready),
		.m_axil_rdata		(axil_bus.axil_rdata),
		.m_axil_rresp		(axil_bus.axil_rresp),
		.m_axil_rvalid		(axil_bus.axil_rvalid),
		.m_axil_rready		(axil_bus.axil_rready)
	);

endmodule : mem_sys_axil_wrapper
