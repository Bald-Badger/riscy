import defines::*;
import mem_defines::*;
import axi_defines::*;
`timescale 1ns / 1ps

module fetch_axil_tb();
	//logic define
	logic		clk;
	logic		rst_n;

	data_t		pc_bj;
	logic		pc_sel;
	logic		stall;
	logic		flush;
	logic		go;

	data_t		pc_p4_out;
	data_t		pc_out;
	instr_t		instr;
	logic		taken;
	logic		instr_valid;

initial begin
	clk = 0;
	rst_n = 0;
	#1000;
	rst_n = 1;
end

// 50MHz
always #100 clk = ~clk;


initial begin
	pc_bj = 0;
	pc_sel = 0;
	stall = 0;
	flush = 0;
	go = 0;
	repeat(15) @ (posedge clk);
	go = 1;
	repeat(10) @ (posedge clk);
	go = 0;
end

initial begin
	repeat(1000) @ (posedge clk);
	$stop();
end


axi_lite_interface axi0 (
	.clk(clk),
	.rst(~rst_n)
);


fetch_axil fetch_inst (
	.clk			(clk),
	.rst_n			(rst_n),

	.pc_bj			(pc_bj),
	.pc_sel			(pc_sel),
	.stall			(stall),
	.flush			(flush),
	.go				(go),
	.instr_w		(NULL),

	.pc_p4_out		(pc_p4_out),
	.pc_out			(pc_out),
	.instr			(instr),
	.taken			(taken),
	.instr_valid	(instr_valid),

	.axil_bus		(axi0)
);

axil_ram_sv_wrapper ram (
	.axil_bus (axi0)
);

endmodule : fetch_axil_tb
