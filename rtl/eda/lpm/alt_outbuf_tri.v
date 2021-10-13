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
///////////////////////////////////////////////////////////////////////////////
// alt_outbuf_tri for Formal Verification
///////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN

module alt_outbuf_tri (
// INTERFACE BEGIN
	i,
	oe,
    o
// INTERFACE END
);

//Parameter Declaration
parameter io_standard = "none";
parameter current_strength = "none";
parameter location = "none";
parameter slow_slew_rate = "off";
parameter enable_bus_hold = "off";
parameter weak_pull_up_resistor = "off";
parameter termination = "none";

//Input Ports Declaration
input i;
input oe;

//Outout Ports Declaration
output o;

// IMPLEMENTATION BEGIN 
assign o = (oe == 1'b1) ? i : 1'bz;


// IMPLEMENTATION END
endmodule 
// MODEL END