// written under guidence from:
// https://pages.cs.wisc.edu/~sinclair/courses/cs552/spring2020/includes/cacheDesign.html

import defines::*;
import mem_defines::*;

module cache (
	// input nets
	input logic			clk,
	input logic			en,
	input index_t		index,
	input logic			rd,
	input logic			wr,
	input flag_line_t	flag_line_in,
	input data_line_t	data_line_in,

	// output nets
	output flag_line_t	flag_line_out,
	output data_line_t	data_line_out
);

/*
cache_line_t cache_line_in, cache_line_out;
always_comb begin : cache_line_assemble
	cache_line_out.data = data_line_out;
	cache_line_out.flag = flag_line_out;
	cache_line_in.data = data_line_in;
	cache_line_in.flag = flag_line_in;
end
*/
ram_48b_512wd cache_flag_block (
	.address		(index),
	.clock			(clk),
	.data			(flag_line_in),
	.rden			(rd && en),
	.wren			(wr && en),
	.q				(flag_line_out)
);

ram_256b_512wd cache_data_block (
	.address		(index),
	.clock			(clk),
	.data			(data_line_in),
	.rden			(rd && en),
	.wren			(wr && en),
	.q				(data_line_out)
);
	
endmodule : cache
