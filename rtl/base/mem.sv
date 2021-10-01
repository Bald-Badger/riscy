// Quartus Prime SystemVerilog Template
//
// Simple Dual-Port RAM with different read/write addresses and single read/write clock
// and with a control for writing single bytes into the memory word; byte enable
// byte_enabled_simple_dual_port_ram
// refer: https://www.intel.com/content/www/us/en/programmable/quartushelp/13.0/mergedProjects/hdl/vlog/vlog_pro_ram_inferred.htm

// currentlly using a very simple memory map for testing purpose.
// assume 32b vitural memory space and 16b phycial memory space
// ADDR 0x12345678 => 0x1678
// ADDR 0x20000123 => 0x2123
// not implemented yet

// BUG: memory now is word address, not byte address

import defines::*;

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
	output logic [WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH;

	// use a multi-dimensional packed array to model individual bytes within the word
	//logic [BYTES-1:0][BYTE_WIDTH-1:0] ram[0:(WORDS-1)];
	logic [BYTES-1:0][BYTE_WIDTH-1:0] ram[0:MEM_SPACE]; // use small memory for now

	// TODO: change to always_ff in FPGA run
	// TODO: used negedge trigger memory to get around bugs
	always_ff @(negedge clk) begin	
		if (we) begin
			// edit this code if using other than four bytes per word
			if(be[0]) ram[waddr[ADDR_WIDTH-1:2]][0] <= wdata[7:0];
			if(be[1]) ram[waddr[ADDR_WIDTH-1:2]][1] <= wdata[15:8];
			if(be[2]) ram[waddr[ADDR_WIDTH-1:2]][2] <= wdata[23:16];
			if(be[3]) ram[waddr[ADDR_WIDTH-1:2]][3] <= wdata[31:24];
		end else begin
			ram[waddr[ADDR_WIDTH-1:2]][0] <= ram[waddr[ADDR_WIDTH-1:2]][0];
			ram[waddr[ADDR_WIDTH-1:2]][1] <= ram[waddr[ADDR_WIDTH-1:2]][1];
			ram[waddr[ADDR_WIDTH-1:2]][2] <= ram[waddr[ADDR_WIDTH-1:2]][2];
			ram[waddr[ADDR_WIDTH-1:2]][3] <= ram[waddr[ADDR_WIDTH-1:2]][3];
		end
	end

	assign q = (re ? ram[raddr[ADDR_WIDTH-1:2]] : NULL); // read entire 32b

/*
	initial begin
			if (TYPE == BLANK_MEM) begin
				for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
					ram[waddr][0] <= 8'b0;
					ram[waddr][1] <= 8'b0;
					ram[waddr][2] <= 8'b0;
					ram[waddr][3] <= 8'b0;
				end 
			end else if (TYPE == UNINT_MEM) begin
				for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
					ram[waddr][0] <= 8'bX;
					ram[waddr][1] <= 8'bX;
					ram[waddr][2] <= 8'bX;
					ram[waddr][3] <= 8'bX;
				end 
			end else if (TYPE == INSTR_MEM) begin
				$readmemh("instr.asm", ram);
			end else if (TYPE == DATA_MEM) begin
				$readmemh("data.asm", ram);
			end
	end
*/
endmodule : mem
