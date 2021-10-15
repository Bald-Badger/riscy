package mem_defines;
import defines::*;

`ifndef _mem_defines_
`define _mem_defines_

// note: EP4cE10 FPGA have 46 M9K blocks

/*
	Cache model:

	cache flag line:
	valid0 - dirty0 - tag0 - valid1 - dirty1 - tag1 - LRU - X  
	|-----------------------flag----48b---------------------|
	   1        1      19       1        1       19     1   5

	cache data line:
	data0w0 - data0w1 - data0w2 - data0w3 - data1w0 - data1w1 - data1w2 - data1w3
	|----------------------------data----256b-----------------------------------|
	   32        32       32        32        32        32        32        32    

	writing policy:	write back - write back to memory when evict
					write allocate - miss-write are being written into cache
	replacement policy:	LRU: evict the least recent used way

	Address representation:
	31-------------------13 12----------4     3-2           1-0
			tag(19)            index(9)    word_off(2)   byte_off(2)
*/

localparam	tag_len				= 19;
localparam	index_len			= 9;
localparam	word_off			= 2;
localparam	byte_off			= 2;
localparam	sdram_addr_len		= 24;		// 2^24 words
localparam	sdram_word			= 16;		// 16 bit word
localparam  sdram_access_len	= 10'd8;	// 8 16-bit word each access 

typedef logic [index_len - 1 : 0]	index_t;
typedef logic [tag_len - 1 : 0]		tag_t;
typedef logic [4 : 0]				x5_t;

typedef struct packed{
	logic		valid0;
	logic		dirty0;
	tag_t		tag0;
	logic		valid1;
	logic		dirty1;
	tag_t		tag1;
	logic		lru;
	x5_t		x5;
} flag_line_t;

typedef struct packed {
	data_t		data0w0;
	data_t		data0w1;
	data_t		data0w2;
	data_t		data0w3;
	data_t		data1w0;
	data_t		data1w1;
	data_t		data1w2;
	data_t		data1w3;
} data_line_t;

typedef struct {
	flag_line_t	flag;
	data_line_t	data;
} cache_line_t;

// {en, comp, write}
// for more info visit:
// https://pages.cs.wisc.edu/~sinclair/courses/cs552/spring2020/includes/cacheDesign.html
typedef enum logic [2:0] {
	CACHE_IDLE		= 3'b000,	// does nothing
	COMP_READ		= 3'b110,	// load instr
	COMP_WRITE		= 3'b111,	// store instr
	ACCESS_READ		= 3'b100,	// cache to ram
	ACCESS_WRITE	= 3'b101,	// ram to cache
	CACHE_ERR_1		= 3'b001,	// should not occur
	CACHE_ERR_2		= 3'b010,	// should not occur
	CACHE_ERR_3		= 3'b011	// should not occur
} cache_access_mode_t;

typedef logic[sdram_addr_len - 1 : 0]	sdram_addr_t;
typedef logic[sdram_word - 1:0]			sdram_wd_t;
typedef struct packed {
	sdram_wd_t	w0;
	sdram_wd_t	w1;
	sdram_wd_t	w2;
	sdram_wd_t	w3;
	sdram_wd_t	w4;
	sdram_wd_t	w5;
	sdram_wd_t	w6;
	sdram_wd_t	w7;
} sdram_8_wd_t;

typedef enum logic[3:0] {
	RD_DISABLE = 4'b0000,
	RDW0 = 4'b1000,
	RDW1 = 4'b1001,
	RDW2 = 4'b1010,
	RDW3 = 4'b1011,
	RDW4 = 4'b1100,
	RDW5 = 4'b1101,
	RDW6 = 4'b1110,
	RDW7 = 4'b1111
} rd_index_t;


localparam be_none	= 32'h0000_0000;
localparam be_w0	= 32'hffff_0000;
localparam be_w1	= 32'h0000_ffff;
localparam be_all	= 32'hffff_ffff;

typedef enum logic[1:0] {
	WAY_SEL_NONE	= 2'b00,
	WAY_SEL_W0		= 2'b01,
	WAY_SEL_W1		= 2'b10,
	WAY_SEL_ALL		= 2'b11
} way_sel_t;

`endif

endpackage : mem_defines
