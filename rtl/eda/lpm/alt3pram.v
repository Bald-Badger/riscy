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
module alt3pram (
	wren,
	data,
	wraddress,
	inclock,
	inclocken,
	rden_a,
	rden_b,
	rdaddress_a,
	rdaddress_b,
	outclock,
	outclocken,
	aclr,
`ifdef POST_FIT
	_unassoc_inputs_,
	_unassoc_outputs_,
`endif
	qa,
	qb
);

	parameter width = 1;
	parameter widthad = 1;
	parameter numwords = 0;
	parameter write_aclr = "ON";
	parameter intended_device_family = "unused";
	parameter lpm_file = "UNUSED";
	parameter rdaddress_aclr_a = "ON";
	parameter rdaddress_aclr_b = "ON";
	parameter indata_reg = "INCLOCK";
	parameter indata_aclr = "ON";
	parameter write_reg = "INCLOCK";
	parameter rdaddress_reg_a = "INCLOCK";
	parameter rdaddress_reg_b = "INCLOCK";
	parameter outdata_reg_a = "OUTCLOCK";
	parameter outdata_reg_b = "OUTCLOCK";
	parameter outdata_aclr_a = "ON";
	parameter outdata_aclr_b = "ON";
	parameter rdcontrol_aclr_a = "ON";
	parameter rdcontrol_aclr_b = "ON";
	parameter rdcontrol_reg_a = "INCLOCK";
	parameter rdcontrol_reg_b = "INCLOCK";
	parameter use_eab = "ON";
	parameter maximum_depth = 0;
	parameter ram_block_type = "AUTO";

`ifdef POST_FIT
	parameter _unassoc_inputs_width_ = 1;
	parameter _unassoc_outputs_width_ = 1;
`endif

	parameter lpm_type = "alt3pram";
	parameter lpm_hint = "UNUSED";

	input [width-1:0] data;
	input [widthad-1:0] wraddress, rdaddress_a, rdaddress_b;
	input inclock, inclocken, outclock, outclocken;
	input wren, rden_a, rden_b, aclr;
	// Extra bus for connecting signals unassociated with defined ports
`ifdef POST_FIT
	input [ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output [ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif
	output [width-1:0] qa, qb;

endmodule
