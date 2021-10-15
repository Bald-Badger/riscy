// written under guidence from:
// https://pages.cs.wisc.edu/~sinclair/courses/cs552/spring2020/includes/cacheDesign.html

import defines::*;
import mem_defines::*;

module cache (
	// input nets
	input logic			clk,
	input index_t		index,
	input logic			valid,
	input logic			rd,
	input logic			wr,
	input tag_t			tag_in,
	input data_t		data_in,
	input way_sel_t		way_sel,

	// output nets
	output logic		hit0,
	output logic		hit1,
	output logic		dirty0,
	output logic		dirty1,
	output logic		valid0,
	output logic		valid1,
	output tag_t		tag_out,
	output data_t		data_out,
	output logic		ready
);

localparam way0_sel_be = 32'hffff_0000;
localparam way1_sel_be = 32'h0000_ffff;

data_line_t data_line_in, data_line_out;
flag_line_t flag_line_in, flag_line_out;
cache_line_t cache_line_in, cache_line_out;

always_comb begin : cache_line_assemble
	cache_line_out.data = data_line_out;
	cache_line_out.flag = flag_line_out;
	cache_line_in.data = data_line_in;
	cache_line_in.flag = flag_line_in;
end

ram_48b_512wd cache_flag_block (
	.address		(index),
	.clock			(clk),
	.data			(flag_line_in),
	.rden			(rd),
	.wren			(wr),
	.q				(flag_line_out)
);

ram_256b_512wd cache_data_block (
	.address		(index),
	.byteena		(
		(way_sel == WAY_SEL_W0)		? be_w0 :
		(way_sel == WAY_SEL_W1)		? be_w1 :
		(way_sel == WAY_SEL_ALL)	? be_all :
									  be_none
	),
	.clock			(clk),
	.data			(data_line_in),
	.rden			(rd),
	.wren			(wr),
	.q				(data_line_out)
);
	
endmodule : cache


/*
typedef enum logic[4:0] {
	IDLE, RD_CHECK_0, RD_CHECK_1,		// check hit or not
	RD_WB_0, RD_WB_1, RD_WB_2, RD_WB_3,	// write back to mem
	RD_RW_0, RD_RW_1, RD_RW_2, RD_RW_3,	// read from mem
	RD_DONE,							// actual read from cache as if hit, set done flag
	WR_CHECK_0, WR_CHECK_1,				// check hit or not
	WR_WB_0, WR_WB_1, WR_WB_2, WR_WB_3,	// write back to mem
	WR_WW_0, WR_WW_1, WR_WW_2, WR_WW_3,	// read from mem
	WR_DONE								// write to cache as if hit, set done flag
} state_t;

state_t state, nxt_state;

always_ff @(posedge clk or negedge rst_n)
	if (!rst_n)
		state <= IDLE;
	else
		state <= nxt_state;

logic hit0, hit1
always_comb begin : cache_ctrl_fsm

	nxt_state = IDLE;
	hit0 = 1'b0;
	hit1 = 1'b0;
	unique case (param)
		IDLE: begin
			
		end

		RD_CHECK_0: begin
			
		end

		RD_CHECK_1: begin
			
		end

		RD_WB_0: begin
			
		end

		RD_WB_1: begin
			
		end

		RD_WB_2: begin
			
		end

		RD_WB_3: begin
			
		end

		RD_RW_0: begin
			
		end

		RD_RW_1: begin
			
		end

		RD_RW_2: begin
			
		end

		RD_RW_3: begin
			
		end

		RD_DONE: begin
			
		end

		WR_CHECK_0: begin
			
		end

		WR_CHECK_1: begin
			
		end

		WR_WB_0: begin
			
		end

		WR_WB_1: begin
			
		end

		WR_WB_2: begin
			
		end

		WR_WB_3: begin
			
		end

		WR_WW_0: begin
			
		end

		WR_WW_1: begin
			
		end

		WR_WW_2: begin
			
		end

		WR_WW_3: begin
			
		end

		WR_DONE: begin
			
		end

		default: begin
			nxt_state = IDLE;
		end
	endcase
end
*/
