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
//////////////////////////////// LPM_DECODE for Formal Verification //////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module lpm_decode (
// INTERFACE BEGIN
	data,
	enable,
	clock,
	aclr,
	clken,
	eq
);
// INTERFACE END
//// default parameters ////

parameter lpm_type = "lpm_decode";
parameter lpm_width = 1;
parameter lpm_decodes = 1;   // width of decoded output
parameter lpm_pipeline = 0;
parameter lpm_hint = "UNUSED";
parameter intended_device_family = "UNUSED";

//// constants ////
//// variables ////

//// port declarations ////
input  [lpm_width-1:0] data;   // encoded data
input  enable;                 // decode enable
input  clock;                  // clock
input  aclr;                   // asynch clear
input  clken;                  // clock enable

output [lpm_decodes-1:0] eq;   // decoded output

//// nets/registers ////

wire [lpm_width - 1:0]   decin; 
wire enable_reg;
wire [lpm_decodes - 1:0] decout;

// IMPLEMENTATION BEGIN

//////////////////////////// asynchronous logic ////////////////////////////

// ******* DECODER logic ********* //


assign decout = (enable_reg) ? (1 << decin) : 'b0;

//////////////////////////// synchronous logic /////////////////////////////



generate
if (lpm_pipeline > 0)
begin
	pipeline_internal_fv #(1,1) enable_reg_inst (
                .clk(clock),
                .ena(clken) ,
                .clr(aclr),
                .d(enable),
                .piped(enable_reg)
                );
	pipeline_internal_fv #(lpm_width,1) input_latency (
                .clk(clock),
                .ena(clken),
                .clr(aclr),
                .d(data),
                .piped(decin)
                );
end
else
	begin
		assign decin = data;
		assign enable_reg = enable;
	end
endgenerate


generate

if (lpm_pipeline > 0)
begin
pipeline_internal_fv #(lpm_decodes,lpm_pipeline - 1) output_latency (
                .clk(clock),
                .ena(clken) ,
                .clr(aclr),
                .d(decout),
                .piped(eq)
                );
end
else
	assign eq = decout;
endgenerate

// IMPLEMENTATION END
endmodule
// MODEL END
