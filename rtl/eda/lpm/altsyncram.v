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
module altsyncram (
	wren_a,
	wren_b,
	rden_a,
	rden_b,
	data_a,
	data_b,
	address_a,
	address_b,
	clock0,
	clock1,
	clocken0,
	clocken1,
	clocken2,
	clocken3,
	aclr0,
	aclr1,
	byteena_a,
	byteena_b,
	addressstall_a,
	addressstall_b,
`ifdef POST_FIT
	_unassoc_inputs_,
	_unassoc_outputs_,
`endif
	eccstatus,
	q_a,
	q_b
);

	parameter address_aclr_a = "UNUSED";
	parameter address_aclr_b = "NONE";
	parameter address_reg_b = "CLOCK1";
	parameter byte_size = 8;
	parameter byteena_aclr_a = "UNUSED";
	parameter byteena_aclr_b = "NONE";
	parameter byteena_reg_b = "CLOCK1";
	parameter clock_enable_input_a = "NORMAL";
	parameter clock_enable_input_b = "NORMAL";
	parameter clock_enable_output_a = "NORMAL";
	parameter clock_enable_output_b = "NORMAL";
	parameter indata_aclr_a = "UNUSED";
	parameter indata_aclr_b = "NONE";
	parameter indata_reg_b = "CLOCK1";
	parameter init_file = "UNUSED";
	parameter init_file_layout = "PORT_A";
	parameter intended_device_family = "UNUSED";
	parameter implement_in_les = "OFF";
	parameter lpm_hint = "UNUSED";
	parameter lpm_type = "altsyncram";
	parameter maximum_depth = 0;
	parameter numwords_a = 0;
	parameter numwords_b = 0;
	parameter operation_mode = "BIDIR_DUAL_PORT";
	parameter outdata_aclr_a = "NONE";
	parameter outdata_aclr_b = "NONE";
	parameter outdata_reg_a = "UNREGISTERED";
	parameter outdata_reg_b = "UNREGISTERED";
	parameter power_up_uninitialized = "FALSE";
	parameter ram_block_type = "AUTO";
	parameter rdcontrol_aclr_b = "NONE";
	parameter rdcontrol_reg_b = "CLOCK1";
	parameter read_during_write_mode_mixed_ports = "DONT_CARE";
	parameter width_a = 1;
	parameter width_b = 1;
	parameter width_byteena_a = 1;
	parameter width_byteena_b = 1;
	parameter widthad_a = 1;
	parameter widthad_b = 1;
	parameter wrcontrol_aclr_a = "UNUSED";
	parameter wrcontrol_aclr_b = "NONE";
	parameter wrcontrol_wraddress_reg_b = "CLOCK1";

	parameter clock_enable_core_a = "USE_INPUT_CLKEN";
	parameter clock_enable_core_b = "USE_INPUT_CLKEN";
	parameter enable_ecc = "FALSE";
	parameter read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ";
	parameter read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ";

`ifdef POST_FIT
	parameter _unassoc_inputs_width_ = 1;
	parameter _unassoc_outputs_width_ = 1;
`endif
 

	input wren_a, wren_b, rden_a, rden_b;
	input [width_a-1:0] data_a;
	input [width_b-1:0] data_b;
	input [widthad_a-1:0] address_a;
	input [widthad_b-1:0] address_b;
	input clock0, clock1;
	input clocken0, clocken1, clocken2, clocken3;
	input aclr0, aclr1;
	input [width_byteena_a-1:0] byteena_a;
	input [width_byteena_b-1:0] byteena_b;
	input addressstall_a, addressstall_b;
	// Extra bus for connecting signals unassociated with defined ports
`ifdef POST_FIT
	input [ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output [ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif
	output [width_a-1:0] q_a;
	output [width_b-1:0] q_b;
	output   [2:0] eccstatus;


endmodule
