package axi_defines;
import defines::*;

`ifndef _axi_defines_
`define _axi_defines_

typedef struct packed {
	bit b0;	// 1 for Privileged access
	bit b1;	// 1 for Non-secure access
	bit b2;	// 1 for Instruction access
} awport_t;

typedef enum logic[1:0] {
	RESP_OKAY	= 2'b00,	// Normal access success
	RESP_EXOKAY	= 2'b01,	// Exclusive access okay
	RESP_SLVERR	= 2'b10,	// Slave error, rebel slave
	RESP_DECERR	= 2'b11	// Decode error, rebel interconnect
} RESP_t;

// unprovileged, secure, data access
localparam basic_awport = 3'b000;


`endif

endpackage : axi_defines
