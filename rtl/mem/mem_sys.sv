`timescale 1 ps / 1 ps

import defines::*;
import mem_defines::*;

module mem_sys (
	input logic			clk_50m,
	input logic			clk_100m,
	input logic			clk_100m_shift,
	input logic			rst_n,

	input cache_addr_t	addr,
	input data_t		data_in,
	input logic			wr,
	input logic			rd,
	input logic			valid,
	
	output data_t		d_out,
	output logic		done
);

// sdram nets
logic			sdram_wr;
logic			sdram_rd;
logic			sdram_valid;
logic			sdram_done;

// dcache nets
logic			rd_dcache, wr_data_dcache, wr_flag_dcache, en_dcache;
logic			hit0_dcache, hit1_dcache;
logic			valid0_dcache, valid1_dcache;
logic			dirty0_dcache, dirty1_dcache;
tag_t			tag0_dcache, tag1_dcache;
logic			lru_dcache;
flag_line_t		flag_line_in_dcache, flag_line_out_dcache;
data_line_t		data_line_in_dcache, data_line_out_dcache;
data_line_t		data_line_dcache;
flag_line_t		flag_line_dcache;
logic			load_dcache_line;
logic			clr_dcache_line;
index_t			index;
tag_t			tag;
logic[1:0]		word_off;
logic			one_dcache;
data_t			data_out_dcache;
logic			done_dcache;

always_comb begin : dcache_flag_assign
	valid0_dcache	= flag_line_dcache.valid0;
	valid1_dcache	= flag_line_dcache.valid1;
	dirty0_dcache	= flag_line_dcache.dirty0;
	dirty1_dcache	= flag_line_dcache.dirty1;
	tag0_dcache		= flag_line_dcache.tag0;
	tag1_dcache		= flag_line_dcache.tag1;
	lru_dcache		= flag_line_dcache.lru;
	hit0_dcache		= (tag == tag0_dcache);
	hit1_dcache		= (tag == tag1_dcache);
end


always_comb begin : cache_addr_assign
	index			= addr.index;
	tag				= addr.tag;
	word_off		= addr.word_off;
end


always_ff @(posedge clk_50m, negedge rst_n) begin
	if (~rst_n || clr_dcache_line) begin
		data_line_dcache <= empty_data_line;
		flag_line_dcache <= empty_flag_line;
	end else if (load_dcache_line) begin
		data_line_dcache <= data_line_out_dcache;
		flag_line_dcache <= flag_line_out_dcache;
	end else begin
		data_line_dcache <= data_line_dcache;
		flag_line_dcache <= flag_line_dcache;
	end
end

cache dcache(
	// input nets
	.clk			(clk_50m),
	.en				(en_dcache),
	.index			(index),
	.rd				(rd_dcache),
	.wr_data		(wr_data_dcache),
	.wr_flag		(wr_flag_dcache),
	.flag_line_in	(flag_line_in_dcache),
	.data_line_in	(data_line_in_dcache),

	// output nets
	.flag_line_out	(flag_line_out_dcache),
	.data_line_out	(data_line_out_dcache)
);

// dummy load for icache, used to estimate area
cache icache(
	// input nets
	.clk			(clk_50m),
	.en				(en_dcache),
	.index			(index),
	.rd				(rd_dcache),
	.wr_data		(wr_data_dcache),
	.wr_flag		(wr_flag_dcache),
	.flag_line_in	(flag_line_in_dcache),
	.data_line_in	(data_line_in_dcache),

	// output nets
	.flag_line_out	(flag_line_out_dcache),
	.data_line_out	(data_line_out_dcache)
);


typedef enum logic[3:0] {
	IDLE,
	GET,
	CHECK,
	WR_CHECK,
	RD_CHECK,
	DONE,
	EVICT,
	LOAD
} cache_ctrl_state_t;

cache_ctrl_state_t dcache_state, next_dcache_state;
always_ff @( posedge clk_50m, negedge rst_n ) begin
	if (~rst_n)
		dcache_state <= IDLE;
	else 
		dcache_state <= next_dcache_state;
end

always_comb begin : dcache_ctrl_fsm
	next_dcache_state = IDLE;
	clr_dcache_line		= DISABLE;
	load_dcache_line	= DISABLE;
	en_dcache			= DISABLE;
	rd_dcache			= DISABLE;
	wr_data_dcache		= DISABLE;
	wr_flag_dcache		= DISABLE;
	done_dcache			= 1'b0;
	data_out_dcache		= NULL;
	flag_line_in_dcache	= empty_flag_line;
	data_line_in_dcache	= empty_data_line;

	unique case (dcache_state)
		IDLE : begin
			if ((wr || rd) && valid) begin
				next_dcache_state <= CHECK;
				en_dcache = ENABLE;
				wr_data_dcache = wr;
				wr_flag_dcache = wr;
				rd_dcache = rd;
				load_dcache_line <= ENABLE;
			end else begin
				next_dcache_state <= IDLE;
				clr_dcache_line <= ENABLE;
			end
		end

		CHECK : begin
			if ((hit0_dcache && valid0_dcache) || (hit1_dcache && valid1_dcache)) begin
				next_dcache_state = DONE;
			end else if (
				(~hit0_dcache && ~hit1_dcache) &&
				(valid0_dcache && valid1_dcache) &&
				(
					(lru_dcache && dirty1_dcache) ||
					(~lru_dcache && dirty0_dcache)
				)
			) begin
				next_dcache_state = EVICT;
			end else begin
				next_dcache_state = LOAD;
			end
		end

		DONE : begin
			next_dcache_state	= IDLE;
			done_dcache			= 1'b1;
			en_dcache			= ENABLE;
			wr_data_dcache		= wr;
			wr_flag_dcache		= wr || rd;
			rd_dcache			= rd;
			if (wr) begin	// store instr as if hit
				data_out_dcache		= NULL;
				if (hit0_dcache && valid0_dcache) begin
					unique case (word_off)
						2'b00: begin
							data_line_in_dcache.data0w0	= data_in;
							data_line_in_dcache.data0w1	= data_line_dcache.data0w1;
							data_line_in_dcache.data0w2	= data_line_dcache.data0w2;
							data_line_in_dcache.data0w3	= data_line_dcache.data0w3;
							data_line_in_dcache.data1w0	= data_line_dcache.data1w0;
							data_line_in_dcache.data1w1	= data_line_dcache.data1w1;
							data_line_in_dcache.data1w2	= data_line_dcache.data1w2;
							data_line_in_dcache.data1w3	= data_line_dcache.data1w3;
							flag_line_in_dcache.valid0	= VALID;
							flag_line_in_dcache.dirty0	= DIRTY;
							flag_line_in_dcache.tag0	= tag;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b1;
							flag_line_in_dcache.x5		= 5'b0;
						end
						2'b01: begin
							data_line_in_dcache.data0w0	= data_line_dcache.data0w0;
							data_line_in_dcache.data0w1	= data_in;
							data_line_in_dcache.data0w2	= data_line_dcache.data0w2;
							data_line_in_dcache.data0w3	= data_line_dcache.data0w3;
							data_line_in_dcache.data1w0	= data_line_dcache.data1w0;
							data_line_in_dcache.data1w1	= data_line_dcache.data1w1;
							data_line_in_dcache.data1w2	= data_line_dcache.data1w2;
							data_line_in_dcache.data1w3	= data_line_dcache.data1w3;
							flag_line_in_dcache.valid0	= VALID;
							flag_line_in_dcache.dirty0	= DIRTY;
							flag_line_in_dcache.tag0	= tag;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b1;
							flag_line_in_dcache.x5		= 5'b0;
						end
						2'b10: begin
							data_line_in_dcache.data0w0	= data_line_dcache.data0w0;
							data_line_in_dcache.data0w1	= data_line_dcache.data0w1;
							data_line_in_dcache.data0w2	= data_in;
							data_line_in_dcache.data0w3	= data_line_dcache.data0w3;
							data_line_in_dcache.data1w0	= data_line_dcache.data1w0;
							data_line_in_dcache.data1w1	= data_line_dcache.data1w1;
							data_line_in_dcache.data1w2	= data_line_dcache.data1w2;
							data_line_in_dcache.data1w3	= data_line_dcache.data1w3;
							flag_line_in_dcache.valid0	= VALID;
							flag_line_in_dcache.dirty0	= DIRTY;
							flag_line_in_dcache.tag0	= tag;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b1;
							flag_line_in_dcache.x5		= 5'b0;
						end
						2'b11: begin
							data_line_in_dcache.data0w0	= data_line_dcache.data0w0;
							data_line_in_dcache.data0w1	= data_line_dcache.data0w1;
							data_line_in_dcache.data0w2	= data_line_dcache.data0w2;
							data_line_in_dcache.data0w3	= data_in;
							data_line_in_dcache.data1w0	= data_line_dcache.data1w0;
							data_line_in_dcache.data1w1	= data_line_dcache.data1w1;
							data_line_in_dcache.data1w2	= data_line_dcache.data1w2;
							data_line_in_dcache.data1w3	= data_line_dcache.data1w3;
							flag_line_in_dcache.valid0	= VALID;
							flag_line_in_dcache.dirty0	= DIRTY;
							flag_line_in_dcache.tag0	= tag;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b1;
							flag_line_in_dcache.x5		= 5'b0;
						end
					endcase
				end else if (hit1_dcache && valid1_dcache) begin
					unique case (word_off)
						2'b00: begin
							data_line_in_dcache.data0w0	= data_line_dcache.data0w0;
							data_line_in_dcache.data0w1	= data_line_dcache.data0w1;
							data_line_in_dcache.data0w2	= data_line_dcache.data0w2;
							data_line_in_dcache.data0w3	= data_line_dcache.data0w3;
							data_line_in_dcache.data1w0	= data_in;
							data_line_in_dcache.data1w1	= data_line_dcache.data1w1;
							data_line_in_dcache.data1w2	= data_line_dcache.data1w2;
							data_line_in_dcache.data1w3	= data_line_dcache.data1w3;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= VALID;
							flag_line_in_dcache.dirty1	= DIRTY;
							flag_line_in_dcache.tag1	= tag;
							flag_line_in_dcache.lru		= 1'b0;
							flag_line_in_dcache.x5		= 5'b0;
						end
						2'b01: begin
							data_line_in_dcache.data0w0	= data_line_dcache.data0w0;
							data_line_in_dcache.data0w1	= data_line_dcache.data0w1;
							data_line_in_dcache.data0w2	= data_line_dcache.data0w2;
							data_line_in_dcache.data0w3	= data_line_dcache.data0w3;
							data_line_in_dcache.data1w0	= data_line_dcache.data1w0;
							data_line_in_dcache.data1w1	= data_in;
							data_line_in_dcache.data1w2	= data_line_dcache.data1w2;
							data_line_in_dcache.data1w3	= data_line_dcache.data1w3;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= VALID;
							flag_line_in_dcache.dirty1	= DIRTY;
							flag_line_in_dcache.tag1	= tag;
							flag_line_in_dcache.lru		= 1'b0;
							flag_line_in_dcache.x5		= 5'b0;
						end
						2'b10: begin
							data_line_in_dcache.data0w0	= data_line_dcache.data0w0;
							data_line_in_dcache.data0w1	= data_line_dcache.data0w1;
							data_line_in_dcache.data0w2	= data_line_dcache.data0w2;
							data_line_in_dcache.data0w3	= data_line_dcache.data0w3;
							data_line_in_dcache.data1w0	= data_line_dcache.data1w0;
							data_line_in_dcache.data1w1	= data_line_dcache.data1w1;
							data_line_in_dcache.data1w2	= data_in;
							data_line_in_dcache.data1w3	= data_line_dcache.data1w3;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= VALID;
							flag_line_in_dcache.dirty1	= DIRTY;
							flag_line_in_dcache.tag1	= tag;
							flag_line_in_dcache.lru		= 1'b0;
							flag_line_in_dcache.x5		= 5'b0;
						end
						2'b11: begin
							data_line_in_dcache.data0w0	= data_line_dcache.data0w0;
							data_line_in_dcache.data0w1	= data_line_dcache.data0w1;
							data_line_in_dcache.data0w2	= data_line_dcache.data0w2;
							data_line_in_dcache.data0w3	= data_line_dcache.data0w3;
							data_line_in_dcache.data1w0	= data_line_dcache.data1w0;
							data_line_in_dcache.data1w1	= data_line_dcache.data1w1;
							data_line_in_dcache.data1w2	= data_line_dcache.data1w2;
							data_line_in_dcache.data1w3	= data_in;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= VALID;
							flag_line_in_dcache.dirty1	= DIRTY;
							flag_line_in_dcache.tag1	= tag;
							flag_line_in_dcache.lru		= 1'b0;
							flag_line_in_dcache.x5		= 5'b0;
						end
					endcase
				end else begin
					$error("cache access err: cant hit on write");
					data_line_in_dcache = empty_data_line;
					flag_line_in_dcache = empty_flag_line;
				end
			end else begin	// load instr as if hit
				data_line_in_dcache = empty_data_line;
				if (hit0_dcache && valid0_dcache) begin
					unique case (word_off)
						2'b00: begin
							data_out_dcache				= data_line_dcache.data0w0;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= ~flag_line_dcache.lru;
							flag_line_in_dcache.x5		= 5'b0;
						end 

						2'b01: begin
							data_out_dcache				= data_line_dcache.data0w1;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= ~flag_line_dcache.lru;
							flag_line_in_dcache.x5		= 5'b0;
						end

						2'b10: begin
							data_out_dcache				= data_line_dcache.data0w2;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= ~flag_line_dcache.lru;
							flag_line_in_dcache.x5		= 5'b0;
						end

						2'b11: begin
							data_out_dcache				= data_line_dcache.data0w3;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= ~flag_line_dcache.lru;
							flag_line_in_dcache.x5		= 5'b0;
						end
					endcase
				end else if (hit1_dcache && valid1_dcache) begin
					unique case (word_off)
						2'b00: begin
							data_out_dcache				= data_line_dcache.data1w0;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= ~flag_line_dcache.lru;
							flag_line_in_dcache.x5		= 5'b0;
						end 

						2'b01: begin
							data_out_dcache				= data_line_dcache.data1w1;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= ~flag_line_dcache.lru;
							flag_line_in_dcache.x5		= 5'b0;
						end

						2'b10: begin
							data_out_dcache				= data_line_dcache.data1w2;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= ~flag_line_dcache.lru;
							flag_line_in_dcache.x5		= 5'b0;
						end

						2'b11: begin
							data_out_dcache				= data_line_dcache.data1w3;
							flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
							flag_line_in_dcache.lru		= ~flag_line_dcache.lru;
							flag_line_in_dcache.x5		= 5'b0;
						end
					endcase
				end else begin
					$error("cache access err: cant hit on read");
					data_out_dcache = NULL;
					flag_line_in_dcache = empty_flag_line;
				end
			end
		end

		EVICT : begin
			if (sdram_done) begin
				next_dcache_state = LOAD;
			end else begin
				next_dcache_state = EVICT;
			end
		end

		LOAD : begin
			if (sdram_done) begin
				next_dcache_state = DONE;
			end else begin
				next_dcache_state = LOAD;
			end
		end

		default: begin
			next_dcache_state <= IDLE;
		end
	endcase
end

// SDRAM net
logic			sdram_clk;   
logic			sdram_cke;
logic			sdram_cs_n;   
logic			sdram_ras_n;
logic			sdram_cas_n;
logic        	sdram_we_n;
logic	[ 1:0]	sdram_ba;
logic	[12:0]	sdram_addr;
wire	[15:0]	sdram_data;
logic	[ 1:0]	sdram_dqm;

// top level of a sdram controller
sdram sdram_ctrl_inst(
    .clk_50m		(clk_50m),
    .rst_n			(rst_n),
        
    .sdram_clk		(sdram_clk),
    .sdram_cke		(sdram_cke),
    .sdram_cs_n		(sdram_cs_n),
    .sdram_ras_n	(sdram_ras_n),
    .sdram_cas_n	(sdram_cas_n),
    .sdram_we_n		(sdram_we_n),
    .sdram_ba		(sdram_ba),
    .sdram_addr		(sdram_addr),
    .sdram_data		(sdram_data),
    .sdram_dqm		(sdram_dqm),
    
	// user control interface
	// a transaction is complete when valid && done
	.addr			(addr),
	.wr				(sdram_wr),
	.rd				(sdram_rd),
	.valid			(sdram_valid),
	.data_line_in	(data_line_in),
	.data_line_out	(data_line_out),
	.done			(sdram_done),
	.sdram_init_done(sdram_init_done)
); 


// functional model of a physical sdram module
// synthesis translate_off
sdr u_sdram(    
    .Clk			(sdram_clk),
    .Cke			(sdram_cke),
    .Cs_n			(sdram_cs_n),
    .Ras_n			(sdram_ras_n),
    .Cas_n			(sdram_cas_n),
    .We_n			(sdram_we_n),
    .Ba				(sdram_ba),
    .Addr			(sdram_addr),
    .Dq				(sdram_data),
    .Dqm			(sdram_dqm)
);
// synthesis translate_on

endmodule: mem_sys
