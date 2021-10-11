import defines::*;
import mem_defines::*;

module cache (
	// input nets
	input logic		clk,
	input logic		rst_n,
	input logic		en,
	input index_t	index,
	input logic		comp,
	input logic		write,
	input tag_t		tag_in,
	input data_t	data_in,
	input logic		valid_in,

	// output nets
	output logic	hit,
	output logic	dirty,
	output tag_t	tag_out,
	output data_t	data_out,
	output logic	valid
);
	
endmodule : cache
