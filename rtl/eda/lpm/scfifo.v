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
module scfifo (
	data,
	clock,
	wrreq,
	rdreq,
	aclr,
	sclr,
`ifdef POST_FIT
	_unassoc_inputs_,
	_unassoc_outputs_,
`endif
	q,
	usedw,
	full,
	empty,
	almost_full,
	almost_empty
);

	parameter lpm_width = 1;
	parameter lpm_widthu = 1;
	parameter lpm_numwords = 1;
	parameter lpm_showahead = "OFF";
	parameter lpm_hint = "UNUSED";
	parameter overflow_checking = "ON";
	parameter underflow_checking = "ON";
	parameter allow_rwcycle_when_full = "OFF";
	parameter almost_full_value = 0;
	parameter almost_empty_value = 0;
	parameter use_eab = "ON";
	parameter lpm_type = "scfifo";
	parameter intended_device_family = "UNUSED";
	parameter add_ram_output_register = "OFF";
`ifdef POST_FIT
	parameter _unassoc_inputs_width_ = 1;
	parameter _unassoc_outputs_width_ = 1;
`endif
	parameter maximum_depth = 0;

	input [lpm_width-1:0] data;
	input clock;
	input wrreq;
	input rdreq;
	input aclr;
	input sclr;
	// Extra bus for connecting signals unassociated with defined ports
`ifdef POST_FIT
	input [ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output [ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif
	output [lpm_width-1:0] q;
	output [lpm_widthu-1:0] usedw;
	output full;
	output empty;
	output almost_full;
	output almost_empty;

endmodule
