package axi_defines;
import defines::*;

`ifndef _axi_defines_
`define _axi_defines_

typedef struct packed {
	bit b0;	// 1 for Privileged access
	bit b1;	// 1 for Non-secure access
	bit b2;	// 1 for Instruction access
} awport_t;

// unprovileged, secure, data access
localparam basic_awport = 3'b000;


`endif

endpackage : axi_defines
