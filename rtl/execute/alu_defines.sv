package alu_defines;

`ifndef _alu_define_svh_
`define _alu_define_svh_

`define PY_PATH string'("../../python")

localparam DIV_LATENCY = 12;

typedef enum logic[1:0] { 
	a_add_b,
	a_sub_b,
	b_add_a,
	b_sub_a
} add_sub_op_t;

typedef enum logic {  
	unsigned_op	= 1'b0,
	signed_op	= 1'b1
} sign_t;

typedef enum logic {  
	logical 	= 1'b0,
	arithmetic	= 1'b1
} shift_type_t;

typedef enum logic[2:0] {  
	and_result_sel,
	or_result_sel,
	xor_result_sel,
	set_result_sel,
	shift_result_sel,
	add_sub_result_sel
} result_sel_t;

typedef enum logic[2:0] {
	normal_div,
	normal_rem,
	overflow_div,
	div_by_0_div
} div_out_case_t;


`endif

endpackage : alu_defines
