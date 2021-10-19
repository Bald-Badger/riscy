// Copyright (C) 2020 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// LPM_ADD_SUB for Formal Verification /////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module lpm_add_sub (
// INTERFACE BEGIN
	dataa,
	datab,
	cin,
	add_sub,
	clock,
	aclr,
	clken,
`ifdef POST_FIT
	_unassoc_inputs_,
	_unassoc_outputs_,
`endif
	result,
	cout,
	overflow
);
// INTERFACE END
//// default parameters ////

	parameter lpm_type = "lpm_add_sub";
	parameter lpm_width = 1;                 // width of dataa,datab,result
	parameter lpm_representation = "SIGNED"; // type of addition/subtraction
	parameter lpm_direction = "DEFAULT";     // add or sub
	parameter lpm_pipeline = 0;              // latency
	parameter lpm_hint = "UNUSED";
	parameter intended_device_family = "UNUSED";
`ifdef POST_FIT
	parameter _unassoc_inputs_width_ = 1;
	parameter _unassoc_outputs_width_ = 1;
`endif

//// port declarations ////

	input  [lpm_width - 1:0] dataa;
	input  [lpm_width - 1:0] datab;
	input  cin,add_sub;
	input  clock,aclr,clken;
	// Extra bus for connecting signals unassociated with defined ports
`ifdef POST_FIT
	input [ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output [ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif
	output [lpm_width - 1:0] result;
	output cout,overflow;

endmodule
