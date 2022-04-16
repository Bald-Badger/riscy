package pref_defines;
import defines::*;
import mem_defines::*;

`ifndef _pref_defines_
`define _pref_defines_


localparam	H2F_BASE	= 32'hFC00_0000;
localparam	H2F_LW_BASE	= 32'hFF20_0000;	// not used for now


//////////////////// 7 seg defines ////////////////////

localparam	SEG_BASE		= 32'h0;	// offset from bridge base

localparam	SEG_ADDR_MASK	= 32'h0000_001C;
localparam	SEG_DATA_MASK	= 32'h0000_000F;

localparam	SEG_H0_OFF		= 32'h0;
localparam	SEG_H1_OFF		= 32'h4;
localparam	SEG_H2_OFF		= 32'h8;
localparam	SEG_H3_OFF		= 32'hC;
localparam	SEG_H4_OFF		= 32'h10;
localparam	SEG_H5_OFF		= 32'h14;

localparam	SEG_H0_ADDR		= SEG_BASE + SEG_H0_OFF;
localparam	SEG_H1_ADDR		= SEG_BASE + SEG_H1_OFF;
localparam	SEG_H2_ADDR		= SEG_BASE + SEG_H2_OFF;
localparam	SEG_H3_ADDR		= SEG_BASE + SEG_H3_OFF;
localparam	SEG_H4_ADDR		= SEG_BASE + SEG_H4_OFF;
localparam	SEG_H5_ADDR		= SEG_BASE + SEG_H5_OFF;

//////////////////////////////////////////////////////


//////////////////// UART defines ////////////////////

localparam	UART_BASE		= 32'h0;

// write to here will write one byte of data to transmit fifo
// read from here will load one byte of data from receive fifo
localparam	UART_DATA_OFF	= 32'h0;

//////////////////////////////////////////////////////


`endif

endpackage : pref_defines
