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
/////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// ALTDDIO_BIDIR  for Formal Verification /////////////////
/////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module altddio_bidir (
// INTERFACE BEGIN
    datain_h,  // input data to be output of padio port at the
               // rising edge of outclock
    datain_l,  // input data to be output of padio port at the
               // falling edge of outclock
    inclock,   // input reference clock to sample data by
    inclocken, // inclock enable
    outclock,  // input reference clock to register data output
    outclocken,// outclock enable
    aset,      // asynchronous set
    aclr,      // asynchronous clear
    sset,      // synchronous set
    sclr,      // synchronous clear
    oe,        // output enable for padio port
    oe_out,    // 
    dataout_h, // data sampled from the padio port at the rising edge of inclock
    dataout_l, // data sampled from the padio port at the falling edge of inclock
    combout,   // combinatorial output directly fed by padio
    dqsundelayedout, // undelayed DQS signal to the PLD core
    padio      // bidirectional DDR port

);
// INTERFACE END
//// default parameters ////

parameter width = 1; 
parameter power_up_high = "OFF";
parameter oe_reg = "UNREGISTERED";
parameter extend_oe_disable = "OFF";
parameter intended_device_family = "UNUSED";
parameter implement_input_in_lcell = "OFF";
parameter invert_output = "OFF";
parameter lpm_type = "altddio_bidir";
parameter lpm_hint = "UNUSED";

//// constants ////
//// variables ////

//// port declarations ////

input [width-1:0] datain_l,datain_h;
input inclock,outclock;
input inclocken,outclocken;
input aset;
input aclr;
input sset;
input sclr;
input oe;
output [width-1:0] oe_out;
output [width-1:0] dataout_h;
output [width-1:0] dataout_l;
output [width-1:0] combout;
output [width-1:0] dqsundelayedout;
inout  [width-1:0] padio;

//// nets/registers ////

// IMPLEMENTATION BEGIN

// ********************** synchronous logic ***************** //

// ***************** ddio logic ***************** //

// ddio input

altddio_in #(
		.width(width),
		.intended_device_family(intended_device_family),
		.power_up_high(power_up_high)
	    ) ddio_in (
    .datain(padio),
    .inclock(inclock),
    .inclocken(inclocken),
    .aset(aset),
    .aclr(aclr),
    .sset(sset),
    .sclr(sclr),
    .dataout_h(dataout_h),
    .dataout_l(dataout_l)
);

// ddio output

altddio_out #(
		.width(width),
		.intended_device_family(intended_device_family),
		.power_up_high(power_up_high),
               	.oe_reg(oe_reg),
                .extend_oe_disable(extend_oe_disable)
	     ) ddio_out (
    .datain_h(datain_h),
    .datain_l(datain_l),
    .outclock(outclock),
    .oe(oe),
    .outclocken(outclocken),
    .aset(aset),
    .aclr(aclr),
    .sset(sset),
    .sclr(sclr),
	 .oe_out(oe_out),
    .dataout(padio)
);

// ********************** asynchronous logic ***************** //

assign combout = padio;
assign dqsundelayedout = padio;


// IMPLEMENTATION END
endmodule
// MODEL END
