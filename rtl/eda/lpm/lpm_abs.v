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
//////////////////////////////// LPM_ABS for Formal Verification /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module lpm_abs (
// INTERFACE BEGIN
	data,
	result,
	overflow
);
// INTERFACE END
//// default parameters ////

parameter lpm_type = "lpm_abs";
parameter lpm_width = 1;
parameter lpm_hint = "UNUSED";

//// constants ////
//// variables ////

//// port declarations ////

input  signed [lpm_width-1:0] data;
output [lpm_width-1:0] result;
output overflow;

//// pullups/pulldowns ////
//// nets/registers ////

// IMPLEMENTATION BEGIN

// ******* ABS logic ********* //

assign result   = (data[lpm_width - 1] == 1'b1) ? -data : data;
assign overflow = (result == ( 1 << (lpm_width-1) ));

// IMPLEMENTATION END
endmodule
// MODEL END
