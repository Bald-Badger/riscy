import defines::*;
import mem_defines::*;

module cache (
	// input nets
	input logic				clk,
	input logic				en,
	input index_t			index,
	input logic				rd,
	input logic				wr_data,
	input logic				wr_flag,
	input flag_line_t		flag_line_in,
	input data_line_t		data_line_in,
	input data_line_en_t	data_line_en,

	// output nets
	output flag_line_t		flag_line_out,
	output data_line_t		data_line_out
);


ram_48b_512wd cache_flag_block (
	.address		(index),
	.clock			(clk),
	.data			(flag_line_in),
	.rden			(rd && en),
	.wren			(wr_flag && en),
	.q				(flag_line_out)
);


ram_256b_512wd cache_data_block (
	.address		(index),
	.byteena		(data_line_en),
	.clock			(clk),
	.data			(data_line_in),
	.rden			(rd && en),
	.wren			(wr_data && en),
	.q				(data_line_out)
);
	
endmodule : cache
