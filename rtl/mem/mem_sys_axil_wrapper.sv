import defines::*;
import mem_defines::*;
import axi_defines::*;

module mem_sys_axil_wrapper (
	input	logic			clk,
	input	logic			rst_n,

	input	cache_addr_t	addr,			// still 32 bits
	input	data_t			data_in,
	input	logic			wr,
	input	logic			rd,
	input	logic			valid,
	input	logic			[BYTES-1:0] be,	// for write only

	output	data_t			data_out,
	output	logic			done,

	axi_lite_interface		axil_bus
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
		.m_axil_awaddr		(axil_bus.m_axil_awaddr),
		.m_axil_awprot		(axil_bus.m_axil_awprot),
		.m_axil_awvalid		(axil_bus.m_axil_awvalid),
		.m_axil_awready		(axil_bus.m_axil_awready),
		.m_axil_wdata		(axil_bus.m_axil_wdata),
		.m_axil_wstrb		(axil_bus.m_axil_wstrb),
		.m_axil_wvalid		(axil_bus.m_axil_wvalid),
		.m_axil_wready		(axil_bus.m_axil_wready),
		.m_axil_bresp		(axil_bus.m_axil_bresp),
		.m_axil_bvalid		(axil_bus.m_axil_bvalid),
		.m_axil_bready		(axil_bus.m_axil_bready),
		.m_axil_araddr		(axil_bus.m_axil_araddr),
		.m_axil_arprot		(axil_bus.m_axil_arprot),
		.m_axil_arvalid		(axil_bus.m_axil_arvalid),
		.m_axil_arready		(axil_bus.m_axil_arready),
		.m_axil_rdata		(axil_bus.m_axil_rdata),
		.m_axil_rresp		(axil_bus.m_axil_rresp),
		.m_axil_rvalid		(axil_bus.m_axil_rvalid),
		.m_axil_rready		(axil_bus.m_axil_rready)
	);

endmodule : mem_sys_axil_wrapper
