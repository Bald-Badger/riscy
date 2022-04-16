`timescale 1ns / 1ps

import defines::*;

module uart_axil_tb ();
	
	logic clk, rst, rst_n;
	assign rst = ~rst_n;

	logic TX, RX;

	axi_lite_interface axil_bus (
		.clk	(clk),
		.rst	(rst)
	);

	clkrst #(.FREQ(FREQ)) clkrst_inst (
		.clk	(clk),
		.rst_n	(rst_n),
		.go		()
	);

	data_t addr, data_in, data_out;
	logic wren, rden, valid, done;

	mem_sys_axil memory_system (
		.clk			(clk),
		.rst_n			(rst_n),

		.addr			(addr),
		.data_in		(data_in),
		.wr				(wren),
		.rd				(rden),
		.valid			(valid),
		.be				(4'b1111),
		
		.data_out		(data_out),
		.done			(done),

		.m_axil_clk 	(axil_bus.m_axil_clk),
		.m_axil_rst		(axil_bus.m_axil_rst),
		.m_axil_awaddr	(axil_bus.m_axil_awaddr),
		.m_axil_awprot	(axil_bus.m_axil_awprot),
		.m_axil_awvalid	(axil_bus.m_axil_awvalid),
		.m_axil_awready	(axil_bus.m_axil_awready),
		.m_axil_wdata	(axil_bus.m_axil_wdata),
		.m_axil_wstrb	(axil_bus.m_axil_wstrb),
		.m_axil_wvalid	(axil_bus.m_axil_wvalid),
		.m_axil_wready	(axil_bus.m_axil_wready),
		.m_axil_bresp	(axil_bus.m_axil_bresp),
		.m_axil_bvalid	(axil_bus.m_axil_bvalid),
		.m_axil_bready	(axil_bus.m_axil_bready),
		.m_axil_araddr	(axil_bus.m_axil_araddr),
		.m_axil_arprot	(axil_bus.m_axil_arprot),
		.m_axil_arvalid	(axil_bus.m_axil_arvalid),
		.m_axil_arready	(axil_bus.m_axil_arready),
		.m_axil_rdata	(axil_bus.m_axil_rdata),
		.m_axil_rresp	(axil_bus.m_axil_rresp),
		.m_axil_rvalid	(axil_bus.m_axil_rvalid),
		.m_axil_rready	(axil_bus.m_axil_rready)
	);

	uart_axil my_uart (
		.clk		(clk),
		.rst		(rst),
		.awvalid_i	(axil_bus.s_axil_awvalid),
		.awaddr_i	(axil_bus.s_axil_awaddr),
		.wvalid_i	(axil_bus.s_axil_wvalid),
		.wdata_i	(axil_bus.s_axil_wdata),
		.wstrb_i	(axil_bus.s_axil_wstrb),
		.bready_i	(axil_bus.s_axil_bready),
		.arvalid_i	(axil_bus.s_axil_arvalid),
		.araddr_i	(axil_bus.s_axil_araddr),
		.rready_i	(axil_bus.s_axil_rready),

		.awready_o	(axil_bus.s_axil_awready),
		.wready_o	(axil_bus.s_axil_wready),
		.bvalid_o	(axil_bus.s_axil_bvalid),
		.bresp_o	(axil_bus.s_axil_bresp),
		.arready_o	(axil_bus.s_axil_arready),
		.rvalid_o	(axil_bus.s_axil_rvalid),
		.rdata_o	(axil_bus.s_axil_rdata),
		.rresp_o	(axil_bus.s_axil_rresp),

		.awprot_i	(axil_bus.s_axil_awprot),
		.arprot_i	(axil_bus.s_axil_arprot),

		.uart_rx	(RX),
		.uart_tx	(TX)
	);

initial begin
	init ();
	write_simp(32'h0, 32'h7);
	repeat(10000) @(posedge clk);
end

task init ();
	addr = 0;
	data_in = 0;
	wren = 0;
	rden = 0;
	valid = 0;
	repeat(100) @(posedge clk);
endtask

task  write_simp(input data_t a, input data_t d);
	fork
		begin
			repeat(100) @(posedge clk);
			$display("write timeout!");
			$stop();
		end

		begin
		wren	= 1;
		valid	= 1;
		addr	= a;
		data_in	= d;
		@(posedge done);
		@(posedge clk);
		valid = 0;
		wren = 0;
		end
	join_any
	disable fork;
endtask

endmodule : uart_axil_tb

module clkrst #(
	FREQ = FREQ
) (
	output logic clk,
	output logic rst_n,
	output logic go
);

	localparam period = 1e12/FREQ;	// in ps
	localparam half_period = period/2;

	initial begin
		clk		= 1'b0;
		rst_n	= 1'b0;
		go		= 1'b0;
		repeat(5) @(negedge clk);
		#100;
		rst_n	= 1'b1;
		repeat(233) @(negedge clk);
		go		= 1'b1;
		@(negedge clk);
		go		= 1'b0;
	end

	always #half_period begin
      clk = ~clk;
    end
	
endmodule : clkrst
