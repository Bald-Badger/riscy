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
////////////////////////////////////////////////////////////////////////////////
////////////////////////// ALTSHIFT_TAPS for Formal Verification ///////////////
////////////////////////////////////////////////////////////////////////////////
module altshift_taps (
	shiftin,
	clock,
	clken,
	aclr,
`ifdef POST_FIT
	_unassoc_inputs_,
	_unassoc_outputs_,
`endif
	shiftout,
	taps
);

	parameter number_of_taps = 1;
	parameter tap_distance = 1;
	parameter width = 1;
	parameter lpm_type = "altshift_taps";
	parameter lpm_hint = "UNUSED";
	parameter intended_device_family = "UNUSED";
	parameter power_up_state = "CLEARED";
	parameter width_taps_ = width*number_of_taps;
`ifdef POST_FIT
	parameter _unassoc_inputs_width_ = 1;
	parameter _unassoc_outputs_width_ = 1;
`endif

	input [width-1:0] shiftin;
	input clock,clken;
	input aclr;
	// Extra bus for connecting signals unassociated with defined ports
`ifdef POST_FIT
	input [ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output [ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif
	output [width-1:0] shiftout;
	output [width_taps_-1:0] taps;

`ifndef GATES_TO_GATES
	wire clk_w = clock & clken;

	generate
	if(number_of_taps==1) begin
		wire [width-1:0] out;
   	shiftreg #(width, tap_distance) tap_stage (out, shiftin, clk_w, aclr);
		assign shiftout = out;
		assign taps = out;
	end
	else begin
		wire [width*(number_of_taps-1):1] tap_out;
		shiftreg #(width, tap_distance) tap_stage[1:number_of_taps] ({shiftout,tap_out}, {tap_out,shiftin}, clk_w, aclr);
		assign taps = {shiftout,tap_out};
	end
	endgenerate
`endif
			
endmodule

`ifndef GATES_TO_GATES
// Creates shift registers of specified width - output of this set 
// of shift registers 'q' is the output of one of the taps

module shiftreg (tap_q, tap_d, tap_clk, tap_aclr);
	parameter width = 1;
	parameter tap_distance = 1;

	input [width-1:0] tap_d;
	input tap_clk;
	input tap_aclr;
	output [width-1:0] tap_q;

   wire [width-1:0] out;
   wire [width*(tap_distance-1) : 1] t;

	assign tap_q = out;

   dff_bus #(width) shiftreg_stage[1:tap_distance] ({out,t},{t,tap_d},tap_clk,tap_aclr);
	

endmodule

// Creates the width of registers

module dff_bus (q, d, clk, aclr);
	parameter width = 1;
	
	input [width-1:0] d;
	input clk;
	input aclr;
	output [width-1:0] q;

	generate
	if(width==1) begin
   	dffep reg_prim_inst (q,clk,1'b1,d,1'b0,aclr);
	end
	else begin
   	dffep reg_prim_inst[width-1:0] (q,clk,1'b1,d,1'b0,aclr);
	end
	endgenerate
endmodule
`endif
