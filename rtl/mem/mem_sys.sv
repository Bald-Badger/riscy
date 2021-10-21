`timescale 1 ps / 1 ps

import defines::*;
import mem_defines::*;

module mem_sys (
	input logic			clk_50m,
	input logic			clk_100m,
	input logic			clk_100m_shift,
	input logic			rst_n,

	input cache_addr_t	addr,			// still 32 bits
	input data_t		data_in,
	input logic			wr,
	input logic			rd,
	input logic			valid,
	input logic			[BYTES-1:0] be,	// for write only
	
	output data_t		data_out,
	output logic		done,
	output logic 		sdram_init_done
);

// sdram nets
logic			sdram_wr;
logic			sdram_rd;
logic			sdram_valid;
logic			sdram_done;
sdram_8_wd_t	sdram_line_in;
sdram_8_wd_t	sdram_line_out;
sdram_8_wd_t	sdram_line_buffer;	// updates on sdram done
logic			[sdram_addr_len-1 : 0] sdram_user_addr;

// dcache nets
logic			rd_dcache, wr_data_dcache, wr_flag_dcache, en_dcache;
logic			hit0_dcache, hit1_dcache;
logic			hit0_check_dcache, hit1_check_dcache;	// from dacache wire, not data_line_dcache
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
data_t			data_out_dcache;
logic			done_dcache;
data_line_en_t	data_line_en_dcache;


always_comb begin : data_out_mux
	data_out = data_out_dcache;
	done = done_dcache;
end


always_comb begin : dcache_flag_assign
	valid0_dcache	=	flag_line_dcache.valid0;
	valid1_dcache	=	flag_line_dcache.valid1;
	dirty0_dcache	=	flag_line_dcache.dirty0;
	dirty1_dcache	=	flag_line_dcache.dirty1;
	tag0_dcache		=	flag_line_dcache.tag0;
	tag1_dcache		=	flag_line_dcache.tag1;
	lru_dcache		=	flag_line_dcache.lru;
end


always_comb begin : dcache_hit_assign
	if (valid && rd) begin
		hit0_dcache = ((tag == tag0_dcache) && valid0_dcache) ? 1'b1 : 1'b0;
		hit1_dcache = ((tag == tag1_dcache) && valid1_dcache) ? 1'b1 : 1'b0;
		hit0_check_dcache = ((tag == flag_line_out_dcache.tag0) && flag_line_out_dcache.valid0) ? 1'b1 : 1'b0;
		hit1_check_dcache = ((tag == flag_line_out_dcache.tag1) && flag_line_out_dcache.valid1) ? 1'b1 : 1'b0;
	end else if (valid && wr) begin
		hit0_dcache = ((tag == tag0_dcache) || ~valid0_dcache) ? 1'b1 : 1'b0;
		hit1_dcache = ((tag == tag1_dcache) || ~valid1_dcache) ? 1'b1 : 1'b0;
		hit0_check_dcache = ((tag == flag_line_out_dcache.tag0) || ~flag_line_out_dcache.valid0) ? 1'b1 : 1'b0;
		hit1_check_dcache = ((tag == flag_line_out_dcache.tag1) || ~flag_line_out_dcache.valid1) ? 1'b1 : 1'b0;
	end else begin
		hit0_dcache = 1'b0;
		hit1_dcache = 1'b0;
		hit0_check_dcache = 1'b0;
		hit1_check_dcache =1'b0;
	end
end


always_comb begin : cache_addr_assign
	index			= addr.index;
	tag				= addr.tag;
	word_off		= addr.word_off;
end


always_ff @(posedge clk_50m, negedge rst_n) begin
	if (~rst_n) begin
		data_line_dcache <= empty_data_line;
		flag_line_dcache <= empty_flag_line;
	end else if (clr_dcache_line) begin
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


// loads sdram output whenever done,
// no reset signal cuz afraids timing issue
always_ff @( posedge clk_100m) begin : sdram_buffer_load
	if (sdram_done)
		sdram_line_buffer <= sdram_line_out;
	else
		sdram_line_buffer <= sdram_line_buffer;
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
	.data_line_en	(data_line_en_dcache),

	// output nets
	.flag_line_out	(flag_line_out_dcache),
	.data_line_out	(data_line_out_dcache)
);


typedef enum logic[2:0] {
	IDLE,
	CHECK,
	DONE,
	EVICT,
	LOAD,
	LOAD2
} cache_ctrl_state_t;


cache_ctrl_state_t dcache_state, next_dcache_state;
always_ff @( posedge clk_50m, negedge rst_n ) begin
	if (~rst_n)
		dcache_state <= IDLE;
	else 
		dcache_state <= next_dcache_state;
end


always_comb begin : dcache_ctrl_fsm
	next_dcache_state	= IDLE;
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
	data_line_en_dcache = 32'hffff_ffff;	// defalut enable all

	sdram_valid			= DISABLE;
	sdram_wr			= DISABLE;		
	sdram_rd			= DISABLE;
	sdram_line_in		= 127'b0;
	sdram_user_addr		= 24'b0;

	unique case (dcache_state)
		IDLE : begin
			load_dcache_line = ENABLE;
			if ((rd || wr) && valid) begin
				next_dcache_state	= CHECK;
				en_dcache			= ENABLE;
				rd_dcache			= ENABLE;
				clr_dcache_line		= DISABLE;
			end else begin
				next_dcache_state	= IDLE;
				en_dcache			= DISABLE;
				rd_dcache			= DISABLE;
				clr_dcache_line		= ENABLE;
			end
		end

		CHECK : begin
			load_dcache_line = ENABLE;
			if (hit0_check_dcache || hit1_check_dcache) begin
				next_dcache_state = DONE;
			end else if (
				(~hit0_check_dcache && ~hit1_check_dcache) &&
				(flag_line_out_dcache.valid0 && flag_line_out_dcache.valid1) &&
				(
					(flag_line_out_dcache.lru && flag_line_out_dcache.dirty1) ||
					(~flag_line_out_dcache.lru && flag_line_out_dcache.dirty0)
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
			if (wr) begin	// store as if hit
				data_out_dcache		= NULL;
				if (hit0_check_dcache) begin
					if (DEBUG_MEM_SYS) begin
						$strobe("wrote value:%d to index:%d way:%b word:%d", data_in, index, 1'b0, word_off);
					end
					unique case (word_off)
						2'b00: begin
							data_line_en_dcache			=	{{be},{4'b1111},{4'b1111},{4'b1111},
															{4'b1111},{4'b1111},{4'b1111},{4'b1111}};
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
							data_line_en_dcache			=	{{4'b1111},{be},{4'b1111},{4'b1111},
															{4'b1111},{4'b1111},{4'b1111},{4'b1111}};
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
							data_line_en_dcache			=	{{4'b1111},{4'b1111},{be},{4'b1111},
															{4'b1111},{4'b1111},{4'b1111},{4'b1111}};
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
							data_line_en_dcache			=	{{4'b1111},{4'b1111},{4'b1111},{be},
															{4'b1111},{4'b1111},{4'b1111},{4'b1111}};
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
				end else if (hit1_check_dcache && ~hit0_check_dcache) begin
					if (DEBUG_MEM_SYS) begin
						$strobe("wrote value:%d to index:%d way:%b word:%d", data_in, index, 1'b1, word_off);
					end
					unique case (word_off)
						2'b00: begin
							data_line_en_dcache			=	{{4'b1111},{4'b1111},{4'b1111},{4'b1111},
															{be},{4'b1111},{4'b1111},{4'b1111}};
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
							data_line_en_dcache			=	{{4'b1111},{4'b1111},{4'b1111},{4'b1111},
															{4'b1111},{be},{4'b1111},{4'b1111}};
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
							data_line_en_dcache			=	{{4'b1111},{4'b1111},{4'b1111},{4'b1111},
															{4'b1111},{4'b1111},{be},{4'b1111}};
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
							data_line_en_dcache			=	{{4'b1111},{4'b1111},{4'b1111},{4'b1111},
															{4'b1111},{4'b1111},{4'b1111},{be}};
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
					data_line_in_dcache = empty_data_line;
					flag_line_in_dcache = empty_flag_line;
				end
			end else begin	// load as if hit
				data_line_in_dcache = empty_data_line;
				if (hit0_check_dcache) begin
					unique case (word_off)
						2'b00: begin
							data_out_dcache				= data_line_out_dcache.data0w0;
							flag_line_in_dcache.valid0	= flag_line_out_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_out_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_out_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_out_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_out_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_out_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b1;
							flag_line_in_dcache.x5		= 5'b0;
						end 

						2'b01: begin
							data_out_dcache				= data_line_out_dcache.data0w1;
							flag_line_in_dcache.valid0	= flag_line_out_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_out_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_out_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_out_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_out_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_out_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b1;
							flag_line_in_dcache.x5		= 5'b0;
						end

						2'b10: begin
							data_out_dcache				= data_line_out_dcache.data0w2;
							flag_line_in_dcache.valid0	= flag_line_out_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_out_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_out_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_out_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_out_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_out_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b1;
							flag_line_in_dcache.x5		= 5'b0;
						end

						2'b11: begin
							data_out_dcache				= data_line_out_dcache.data0w3;
							flag_line_in_dcache.valid0	= flag_line_out_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_out_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_out_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_out_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_out_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_out_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b1;
							flag_line_in_dcache.x5		= 5'b0;
						end
					endcase
				end else if (hit1_check_dcache && ~hit0_check_dcache) begin
					unique case (word_off)
						2'b00: begin
							data_out_dcache				= data_line_out_dcache.data1w0;
							flag_line_in_dcache.valid0	= flag_line_out_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_out_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_out_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_out_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_out_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_out_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b0;
							flag_line_in_dcache.x5		= 5'b0;
						end 

						2'b01: begin
							data_out_dcache				= data_line_out_dcache.data1w1;
							flag_line_in_dcache.valid0	= flag_line_out_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_out_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_out_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_out_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_out_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_out_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b0;
							flag_line_in_dcache.x5		= 5'b0;
						end

						2'b10: begin
							data_out_dcache				= data_line_out_dcache.data1w2;
							flag_line_in_dcache.valid0	= flag_line_out_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_out_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_out_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_out_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_out_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_out_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b0;
							flag_line_in_dcache.x5		= 5'b0;
						end

						2'b11: begin
							data_out_dcache				= data_line_out_dcache.data1w3;
							flag_line_in_dcache.valid0	= flag_line_out_dcache.valid0;
							flag_line_in_dcache.dirty0	= flag_line_out_dcache.dirty0;
							flag_line_in_dcache.tag0	= flag_line_out_dcache.tag0;
							flag_line_in_dcache.valid1	= flag_line_out_dcache.valid1;
							flag_line_in_dcache.dirty1	= flag_line_out_dcache.dirty1;
							flag_line_in_dcache.tag1	= flag_line_out_dcache.tag1;
							flag_line_in_dcache.lru		= 1'b0;
							flag_line_in_dcache.x5		= 5'b0;
						end
					endcase
				end else begin
					data_out_dcache = NULL;
					flag_line_in_dcache = empty_flag_line;
				end
			end
		end

		EVICT : begin
			sdram_valid		= ENABLE;
			sdram_wr		= ENABLE;
			sdram_user_addr	= (~lru_dcache) ?	{{flag_line_dcache.tag0[11:0]},index,{3'b0}}:
												{{flag_line_dcache.tag1[11:0]},index,{3'b0}};
			if (sdram_done) begin
				// no need to update flags
				// cuz flags will be updated in load stage
				// right?... 
				next_dcache_state	= LOAD;
				if (DEBUG_MEM_SYS) begin
					$display("evicted way %b", lru_dcache);
				end
			end else begin
				next_dcache_state	= EVICT;			
				sdram_line_in	= (~lru_dcache) ? {
						{data_line_dcache.data0w0},
						{data_line_dcache.data0w1},
						{data_line_dcache.data0w2},
						{data_line_dcache.data0w3}
					} : {
						{data_line_dcache.data1w0},
						{data_line_dcache.data1w1},
						{data_line_dcache.data1w2},
						{data_line_dcache.data1w3}
					};
			end
		end

		LOAD : begin
			sdram_valid							= ENABLE;
			sdram_rd							= ENABLE;
			// not {{addr[24:4]},{4'b0}} because this addr is in 16bit word, not 8 bit word
			sdram_user_addr						= {{addr[24:4]},{3'b0}};
			if (sdram_done) begin
				next_dcache_state				= LOAD2;
				en_dcache						= ENABLE;
				wr_data_dcache					= ENABLE;
				wr_flag_dcache					= ENABLE;
				if (~lru_dcache) begin	// overwrite way 0
					data_line_in_dcache.data0w0	= {{sdram_line_buffer.w0},{sdram_line_buffer.w1}};
					data_line_in_dcache.data0w1	= {{sdram_line_buffer.w2},{sdram_line_buffer.w3}};
					data_line_in_dcache.data0w2	= {{sdram_line_buffer.w4},{sdram_line_buffer.w5}};
					data_line_in_dcache.data0w3	= {{sdram_line_buffer.w6},{sdram_line_buffer.w7}};
					data_line_in_dcache.data1w0	= data_line_dcache.data1w0;
					data_line_in_dcache.data1w1	= data_line_dcache.data1w1;
					data_line_in_dcache.data1w2	= data_line_dcache.data1w2;
					data_line_in_dcache.data1w3	= data_line_dcache.data1w3;
					flag_line_in_dcache.valid0	= VALID;
					flag_line_in_dcache.dirty0	= CLEAN;
					flag_line_in_dcache.tag0	= tag;
					flag_line_in_dcache.valid1	= flag_line_dcache.valid1;
					flag_line_in_dcache.dirty1	= flag_line_dcache.dirty1;
					flag_line_in_dcache.tag1	= flag_line_dcache.tag1;
					flag_line_in_dcache.lru		= flag_line_dcache.lru;	// only filp in DONE state
					flag_line_in_dcache.x5		= 5'b0;
				end else begin			// overwrite way 1
					data_line_in_dcache.data0w0	= data_line_dcache.data0w0;
					data_line_in_dcache.data0w1	= data_line_dcache.data0w1;
					data_line_in_dcache.data0w2	= data_line_dcache.data0w2;
					data_line_in_dcache.data0w3	= data_line_dcache.data0w3;
					data_line_in_dcache.data1w0	= {{sdram_line_buffer.w0},{sdram_line_buffer.w1}};
					data_line_in_dcache.data1w1	= {{sdram_line_buffer.w2},{sdram_line_buffer.w3}};
					data_line_in_dcache.data1w2	= {{sdram_line_buffer.w4},{sdram_line_buffer.w5}};
					data_line_in_dcache.data1w3	= {{sdram_line_buffer.w6},{sdram_line_buffer.w7}};
					flag_line_in_dcache.valid0	= flag_line_dcache.valid0;
					flag_line_in_dcache.dirty0	= flag_line_dcache.dirty0;
					flag_line_in_dcache.tag0	= flag_line_dcache.tag0;
					flag_line_in_dcache.valid1	= VALID;
					flag_line_in_dcache.dirty1	= CLEAN;
					flag_line_in_dcache.tag1	= tag;
					flag_line_in_dcache.lru		= flag_line_dcache.lru;	// only filp in DONE state
					flag_line_in_dcache.x5		= 5'b0;	
				end
			end else begin
				next_dcache_state			= LOAD;
				en_dcache					= DISABLE;
				wr_data_dcache				= DISABLE;
				wr_flag_dcache				= DISABLE;
			end
		end

		LOAD2: begin
			next_dcache_state			= DONE;
			en_dcache					= ENABLE;
			rd_dcache					= ENABLE;
		end

		default: begin
			next_dcache_state 			= IDLE;
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
	.clk_100m		(clk_100m),
	.clk_100m_shift	(clk_100m_shift),
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
	.addr			(sdram_user_addr),
	.wr				(sdram_wr),
	.rd				(sdram_rd),
	.valid			(sdram_valid),
	.data_line_in	(sdram_line_in),
	.data_line_out	(sdram_line_out),
	.done			(sdram_done),
	.sdram_init_done(sdram_init_done)
); 


// start function modules and asseraions
// synthesis translate_off
sdr sdram_functional_model(    
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


always_ff @(negedge clk_50m) begin : checks
	assert (~((dcache_state == DONE) && ~(hit0_check_dcache || hit1_check_dcache)))
	else begin
		$error("Assertion hit_check failed! at time=%t", $realtime);
		$strobe("hit0 = %b, hit1=%b", hit0_check_dcache, hit1_check_dcache);
	end
end
// synthesis translate_on

endmodule: mem_sys
