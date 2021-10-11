package mem_defines;
import defines::*;

`ifndef _mem_defines_
`define _mem_defines_

// note: EP4cE10 FPGA have 46 M9K blocks

/*
	Cache model:



	cache line:
	X - valid0 - dirty0 - tag0 - data0 - \
	X - valid1 - dirty1 - tag1 - data1 - X - LRU
	2      1        1      20     32     15   1

	writing policy:	write back - write back to memory when evict
					write allocate - miss-write are being written into cache
	replacement policy:	LRU: evict the least recent used way

*/

/*
	Address representation:
	31-------------------13 12----------4     3-2           1-0
			tag(19)           index(9)     word_off(2)   byte_off(2)
*/

localparam tag_len		= 19;
localparam index_len	= 9;
localparam word_off		= 2;
localparam byte_off		= 2;

typedef logic[9:0]	index_t;

typedef logic 		valid_t;
typedef logic 		dirty_t;
typedef logic[19:0]	tag_t;
typedef logic[1:0]	x2_t;
typedef logic[14:0]	x15_t;
typedef logic		lru_t;

typedef struct packed{
	x2_t		x2_0;
	valid_t		v0;
	dirty_t		d0;
	tag_t		tag0;
	data_t		data0;
	x2_t		x2_1;
	valid_t		v1;
	dirty_t		d1;
	tag_t		tag1;
	data_t		data1;
	x15_t		x15;
	lru_t		lru;
} cache_line_t;

// {en, comp, write}
typedef enum logic[2:0] {
	CACHE_IDLE		= 3'b000,	// does nothing
	COMP_READ		= 3'b110,	// load instr
	COMP_WRITE		= 3'b111,	// store instr
	ACCESS_READ		= 3'b100,	// 
	ACCESS_WRITE	= 3'b101,
	CACHE_ERR_1		= 3'b001,
	CACHE_ERR_2		= 3'b010,
	CACHE_ERR_3		= 3'b011,
} cache_access_t;

`endif

endpackage : mem_defines
