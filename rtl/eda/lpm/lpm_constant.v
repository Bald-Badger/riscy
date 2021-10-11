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
//////////////////////////////// LPM_CONSTANT for Formal Verification ////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module lpm_constant (
// INTERFACE BEGIN
	result
);
// INTERFACE END
//// default parameters ////

parameter lpm_type = "lpm_constant";
parameter lpm_width = 1;
parameter lpm_cvalue = 0;
parameter lpm_strength = "UNUSED";
parameter lpm_hint = "UNUSED";

//// constants ////
//// port declarations ////

output [lpm_width-1:0] result;

//// pullups/pulldowns ////
//// nets/registers ////

// IMPLEMENTATION BEGIN
/////////////// net assignments ////////////////////////////////////

assign result = lpm_cvalue;

// IMPLEMENTATION END
endmodule
// MODEL END
