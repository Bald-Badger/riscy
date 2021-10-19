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
////////////////////////////// ALTDDIO_IN  for Formal Verification //////////////////
/////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module altddio_in (
// INTERFACE BEGIN
    datain,    // DDR input data
    inclock,   // input reference clock to sample data by
    inclocken, // clock enable 
    aset,      // asynchronous set
    aclr,      // asynchronous clear
    sset,      // synchronous set
    sclr,      // synchronous clear
    dataout_h, // data sampled at the rising edge of inclock
    dataout_l  // data sampled at the falling edge of inclock
);
// INTERFACE END
//// default parameters ////

parameter width = 1;
parameter intended_device_family = "UNUSED";
parameter power_up_high = "OFF";
parameter lpm_type = "altddio_in";
parameter lpm_hint = "UNUSED";
parameter invert_input_clocks = "OFF";

//// constants ////
//// variables ////

//// port declarations ////

input [width-1:0] datain;
input inclock;
input inclocken;
input aset;
input aclr;
input sset;
input sclr;
output [width-1:0] dataout_h;
output [width-1:0] dataout_l;

//// nets/registers ////

wire [width-1:0] ddio_datain;
wire actual_inclock;
wire [width-1:0] actual_datain, actual_ddio_datain, actual_dataout_h, actual_dataout_l;

// IMPLEMENTATION BEGIN

// ***************** synchronous logic ***************** //
assign actual_datain = ({width{~sclr}} & datain) | {width{sset & ~sclr}};
assign actual_ddio_datain = ({width{~sclr}} & ddio_datain) | {width{sset & ~sclr}};
assign actual_dataout_h = ({width{~sclr}} & dataout_h) | {width{sset & ~sclr}};
assign actual_dataout_l = ({width{~sclr}} & dataout_l) | {width{sset & ~sclr}};

generate
	if(invert_input_clocks=="OFF") begin
		assign actual_inclock = inclock;
	end
	else begin
		assign actual_inclock = ~inclock;
	end

	if(width==1) begin
		dffep io_in_ff (
			.q(dataout_h),
			.ck(actual_inclock),
			.en(inclocken),
			.d(actual_datain),
			.s(aset),
			.r(aclr)
		);
	end
	else begin
		dffep io_in_ff[width-1:0] (
			.q(dataout_h),
			.ck(actual_inclock),
			.en(inclocken),
			.d(actual_datain),
			.s(aset),
			.r(aclr)
		);
	end

	if(width==1) begin
		dffep ddio_lat_ff (
			.q(dataout_l),
			.ck(actual_inclock),
			.en(inclocken),
			.d(actual_ddio_datain),
			.s(aset),
			.r(aclr)
		);
	end
	else begin
		dffep ddio_lat_ff[width-1:0] (
			.q(dataout_l),
			.ck(actual_inclock),
			.en(inclocken),
			.d(actual_ddio_datain),
			.s(aset),
			.r(aclr)
		);
	end

	if(width==1) begin
		dffep ddio_in_ff (
			.q(ddio_datain),
			.ck(~actual_inclock),
			.en(inclocken),
			.d(datain),
			.s(aset),
			.r(aclr)
		);
	end
	else begin
		dffep ddio_in_ff[width-1:0] (
			.q(ddio_datain),
			.ck(~actual_inclock),
			.en(inclocken),
			.d(datain),
			.s(aset),
			.r(aclr)
		);
	end
endgenerate

// IMPLEMENTATION END
endmodule
// MODEL END
