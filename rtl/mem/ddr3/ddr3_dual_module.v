/****************************************************************************************
#########################################################################################
#  PROPERTY OF NANYA TECHNOLOGY -- FOR UNRESTRICTED INTERNAL USE ONLY --				#
#  UNAUTHORIZED REPRODUCTION AND/OR DISTRIBUTION IS STRICTLY PROHIBITED.				#
#  THIS PRODUCT IS PROTECTED UNDER COPYRIGHT LAW AS AN UNPUBLISHED WORK.				#
#  CREATED 2009(C) BY NANYA TECHNOLOGY CORPORATION.	ALL RIGHTS RESERVED.			  #
#########################################################################################
*
*	File Name:  ddr3_mcp.v
*
* Dependencies:  ddr3.v, ddr3_parameters.vh
*
*  Description:  Behavioral Model of 2Gb DDR3 (Double Data Rate 3) SDRAM multi-chip 
*				package model
*
****************************************************************************************/
 `timescale 1ps / 1ps

module ddr3_dual_module (
	ddr3_reset_n,
	ddr3_ck_p,
	ddr3_ck_n,
	ddr3_cke,
	ddr3_cs_n,
	ddr3_ras_n,
	ddr3_cas_n,
	ddr3_we_n,
	ddr3_dm,
	ddr3_ba,
	ddr3_addr,
	ddr3_dq,
	ddr3_dqs_p,
	ddr3_dqs_n,
	ddr3_odt
);

	`define sg125
	`define x16
	`define DUAL_RANK

	`include "ddr3_parameters.vh"
	localparam RANK = 2; // 2 sdram mmodule in parallel

	// Declare Ports
	input						ddr3_reset_n;		// reset
	input	[0:0]				ddr3_ck_p;			// clk
	input	[0:0]				ddr3_ck_n;		// clk, reversed
	input	[CS_BITS-1:0]		ddr3_cke;		// clock enable
	input	[CS_BITS-1:0]		ddr3_cs_n;		// chip sel
	input						ddr3_ras_n;	
	input						ddr3_cas_n;
	input						ddr3_we_n;
	input	[DM_BITS*RANK-1:0]	ddr3_dm;	// data mask
	input	[BA_BITS-1:0]		ddr3_ba;			// ow many ddr3_bank ddr3_address bits are used
	input	[ADDR_BITS-1:0] 	ddr3_addr;
	inout	[DQ_BITS*RANK-1:0]	ddr3_dq; 		// data
	inout	[DQS_BITS*RANK-1:0]	ddr3_dqs_p;		// data strobe
	inout	[DQS_BITS*RANK-1:0]	ddr3_dqs_n;
	input	[CS_BITS-1:0]		ddr3_odt;		// On Die Termination

	wire  [DQS_BITS*RANK-1:0]  tddr3_dqs_n;		// x8 only, NC, high impedence

	ddr3 rank0 (
		.rst_n		(ddr3_reset_n),
		.ck			(ddr3_ck_p), 
		.ck_n		(ddr3_ck_n),
		.cke		(ddr3_cke), 
		.cs_n		(ddr3_cs_n),
		.ras_n		(ddr3_ras_n), 
		.cas_n		(ddr3_cas_n), 
		.we_n		(ddr3_we_n), 
		.dm_tdqs	(ddr3_dm[DM_BITS-1:0]), 
		.ba			(ddr3_ba), 
		.addr		(ddr3_addr), 
		.dq			(ddr3_dq[DQ_BITS-1:0]), 
		.dqs		(ddr3_dqs_p[DQS_BITS-1:0]),
		.dqs_n		(ddr3_dqs_n[DQS_BITS-1:0]),
		.tdqs_n		(tddr3_dqs_n[DQS_BITS-1:0]),
		.odt		(ddr3_odt)
	);

	ddr3 rank1 (
		.rst_n		(ddr3_reset_n),
		.ck			(ddr3_ck_p), 
		.ck_n		(ddr3_ck_n),
		.cke		(ddr3_cke), 
		.cs_n		(ddr3_cs_n),
		.ras_n		(ddr3_ras_n), 
		.cas_n		(ddr3_cas_n), 
		.we_n		(ddr3_we_n), 
		.dm_tdqs	(ddr3_dm[DM_BITS*2-1:DM_BITS]), 
		.ba			(ddr3_ba), 
		.addr		(ddr3_addr), 
		.dq			(ddr3_dq[DQ_BITS*2-1:DQ_BITS]), 
		.dqs		(ddr3_dqs_p[DQS_BITS*2-1:DQS_BITS]),
		.dqs_n		(ddr3_dqs_n[DQS_BITS*2-1:DQS_BITS]),
		.tdqs_n		(tddr3_dqs_n[DQS_BITS*2-1:DQS_BITS]),
		.odt		(ddr3_odt)
	);

endmodule
