// megafunction wizard: %LPM_MULT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: lpm_mult 

// ============================================================
// File Name: mult.v
// Megafunction Name(s):
// 			lpm_mult
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 21.1.0 Build 842 10/21/2021 SJ Lite Edition
// ************************************************************


//Copyright (C) 2021  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and any partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel FPGA IP License Agreement, or other applicable license
//agreement, including, without limitation, that your use is for
//the sole purpose of programming logic devices manufactured by
//Intel and sold by Intel or its authorized distributors.  Please
//refer to the applicable agreement for further details, at
//https://fpgasoftware.intel.com/eula.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module mult (
	clock,
	dataa,
	datab,
	result);

	input	  clock;
	input	[39:0]  dataa;
	input	[39:0]  datab;
	output	[79:0]  result;

	wire [79:0] sub_wire0;
	wire [79:0] result = sub_wire0[79:0];

	lpm_mult	lpm_mult_component (
				.clock (clock),
				.dataa (dataa),
				.datab (datab),
				.result (sub_wire0),
				.aclr (1'b0),
				.clken (1'b1),
				.sclr (1'b0),
				.sum (1'b0));
	defparam
		lpm_mult_component.lpm_hint = "MAXIMIZE_SPEED=5",
		lpm_mult_component.lpm_pipeline = 6,
		lpm_mult_component.lpm_representation = "SIGNED",
		lpm_mult_component.lpm_type = "LPM_MULT",
		lpm_mult_component.lpm_widtha = 40,
		lpm_mult_component.lpm_widthb = 40,
		lpm_mult_component.lpm_widthp = 80;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: AutoSizeResult NUMERIC "1"
// Retrieval info: PRIVATE: B_isConstant NUMERIC "0"
// Retrieval info: PRIVATE: ConstantB NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: LPM_PIPELINE NUMERIC "6"
// Retrieval info: PRIVATE: Latency NUMERIC "1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: SignedMult NUMERIC "1"
// Retrieval info: PRIVATE: USE_MULT NUMERIC "1"
// Retrieval info: PRIVATE: ValidConstant NUMERIC "0"
// Retrieval info: PRIVATE: WidthA NUMERIC "40"
// Retrieval info: PRIVATE: WidthB NUMERIC "40"
// Retrieval info: PRIVATE: WidthP NUMERIC "80"
// Retrieval info: PRIVATE: aclr NUMERIC "0"
// Retrieval info: PRIVATE: clken NUMERIC "0"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: PRIVATE: optimize NUMERIC "0"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_HINT STRING "MAXIMIZE_SPEED=5"
// Retrieval info: CONSTANT: LPM_PIPELINE NUMERIC "6"
// Retrieval info: CONSTANT: LPM_REPRESENTATION STRING "SIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MULT"
// Retrieval info: CONSTANT: LPM_WIDTHA NUMERIC "40"
// Retrieval info: CONSTANT: LPM_WIDTHB NUMERIC "40"
// Retrieval info: CONSTANT: LPM_WIDTHP NUMERIC "80"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: USED_PORT: dataa 0 0 40 0 INPUT NODEFVAL "dataa[39..0]"
// Retrieval info: USED_PORT: datab 0 0 40 0 INPUT NODEFVAL "datab[39..0]"
// Retrieval info: USED_PORT: result 0 0 80 0 OUTPUT NODEFVAL "result[79..0]"
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: @dataa 0 0 40 0 dataa 0 0 40 0
// Retrieval info: CONNECT: @datab 0 0 40 0 datab 0 0 40 0
// Retrieval info: CONNECT: result 0 0 80 0 @result 0 0 80 0
// Retrieval info: GEN_FILE: TYPE_NORMAL mult.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL mult.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mult.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mult.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mult_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mult_bb.v FALSE
// Retrieval info: LIB_FILE: lpm