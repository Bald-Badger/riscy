package mem_defines;
import defines::*;

`ifndef _mem_defines_
`define _mem_defines_


/*

Address repersentation:
31-------------------13 12----------3     2          1-0
        tag(19)           index(10)   set_off(1)  byte_off(2)

cache line:
valid0 - dirty0 - tag0 - data0 - X - \
valid1 - dirty1 - tag1 - data1 - X - X - LRU - reserve
   1        1      19      32    3   7    1       8  

*/

typedef logic		offset_t;

typedef logic 		valid_t;
typedef logic 		dirty_t;
typedef logic[18:0]	tag_t;
//typedef logic[31:0] data_t; // already defined in defines.sv
typedef logic[2:0]	x3_t;
typedef logic[6:0]	x7_t;
typedef logic		lru_t;
typedef logic[7:0]	reserve_t;

typedef struct packed{
	valid_t		v0;
	dirty_t		d0;
	tag_t		tag0;
	data_t		data0;
	x3_t		x3_0;
	valid_t		v1;
	dirty_t		d1;
	tag_t		tag1;
	data_t		data1;
	x3_t		x3_1;
	x7_t		x7;
	lru_t		lru;
	reserve_t	reserve;
} cache_line_t;

`endif

endpackage : mem_defines
