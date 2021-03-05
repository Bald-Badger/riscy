// Quartus Prime SystemVerilog Template
//
// Simple Dual-Port RAM with different read/write addresses and single read/write clock
// and with a control for writing single bytes into the memory word; byte enable
// byte_enabled_simple_dual_port_ram
// refer: https://www.intel.com/content/www/us/en/programmable/quartushelp/13.0/mergedProjects/hdl/vlog/vlog_pro_ram_inferred.htm

`include "../opcode.svh"

module mem
	#(	
		parameter int
		TYPE = BLANK_MEM,
		ADDR_WIDTH = 32,
		BYTE_WIDTH = 8,
		BYTES = 4,
		WIDTH = BYTES * BYTE_WIDTH
)
( 
	input [ADDR_WIDTH-1:0] waddr,
	input [ADDR_WIDTH-1:0] raddr,
	input [BYTES-1:0] be,
	input [XLEN-1:0] wdata, 
	input we, re, clk, rst_n,
	output reg [WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a multi-dimensional packed array to model individual bytes within the word
	logic [BYTES-1:0][BYTE_WIDTH-1:0] ram[0:WORDS-1];

	always_ff@(posedge clk or negedge rst_n) begin	// TODO: del reset in actual FPGA run
		if (!rst_n) begin
			init_mem();
		end else if (we) begin
			// edit this code if using other than four bytes per word
				if(be[0]) ram[waddr][0] <= wdata[7:0];
				if(be[1]) ram[waddr][1] <= wdata[15:8];
				if(be[2]) ram[waddr][2] <= wdata[23:16];
				if(be[3]) ram[waddr][3] <= wdata[31:24];
		end
		q <= (re ? ram[raddr] : 32'b0); // read entire 32b
	end

task init_mem;
	begin
		if (TYPE == BLANK_MEM) begin
			for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
				ram[waddr][0] <= 32'b0;
				ram[waddr][1] <= 32'b0;
				ram[waddr][2] <= 32'b0;
				ram[waddr][3] <= 32'b0;
			end 
		end else if (TYPE == UNINT_MEM) begin
			for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
				ram[waddr][0] <= 32'bX;
				ram[waddr][1] <= 32'bX;
				ram[waddr][2] <= 32'bX;
				ram[waddr][3] <= 32'bX;
			end 
		end else if (TYPE == INSTR_MEM) begin
			// TODO:
		end else if (TYPE == DATA_MEM) begin
			// TODO:
		end
	end
endtask

endmodule : mem
