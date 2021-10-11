// functional model of a sram inetrface
// not 

import defines::*;
import mem_defines::*;

module sram_model(
	input logic		clk,
	input logic		rst_n,
	input data_t	addr,
	input data_t	data_in,
	input logic		wr,
	input logic		rd,
	input logic		valid,

	output logic	ready,
	output data_t	data_out
);
	
endmodule : sram_model
