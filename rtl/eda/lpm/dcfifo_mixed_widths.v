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
//////////////////////////////////////////////////////////////////////////
// dcfifo_mixed_widths parameterized megafunction component declaration
//////////////////////////////////////////////////////////////////////////
module dcfifo_mixed_widths(
	aclr,
	data,
	q,
	rdclk,
	rdempty,
	rdfull,
	rdreq,
	rdusedw,
`ifdef POST_FIT
	_unassoc_inputs_,
	_unassoc_outputs_,
`endif
	wrclk,
	wrempty,
	wrfull,
	wrreq,
	wrusedw);

	parameter	add_ram_output_register = "OFF";
	parameter	add_usedw_msb_bit = "OFF";
	parameter	clocks_are_synchronized = "FALSE";
	parameter	delay_rdusedw = 1;
	parameter	delay_wrusedw = 1;
	parameter	intended_device_family = "UNUSED";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_numwords = 1;
	parameter	lpm_showahead = "OFF";
	parameter	lpm_type = "dcfifo_mixed_widths";
	parameter	lpm_width = 1;
	parameter	lpm_width_r = 0;
	parameter	lpm_widthu = 1;
	parameter	lpm_widthu_r = 1;
	parameter	overflow_checking = "ON";
	parameter	rdsync_delaypipe = 3;
	parameter	underflow_checking = "ON";
	parameter	use_eab = "ON";
	parameter	write_aclr_synch = "OFF";
	parameter	wrsync_delaypipe = 3;
`ifdef POST_FIT
	parameter _unassoc_inputs_width_ = 1;
	parameter _unassoc_outputs_width_ = 1;
`endif


	input	aclr;
	input	[lpm_width-1:0]	data;
	output	[lpm_width_r-1:0]	q;
	input	rdclk;
	output	rdempty;
	output	rdfull;
	input	rdreq;
	output	[lpm_widthu_r-1:0]	rdusedw;
	input	wrclk;
	output	wrempty;
	output	wrfull;
	input	wrreq;
	output	[lpm_widthu-1:0]	wrusedw;
	// Extra bus for connecting signals unassociated with defined ports
`ifdef POST_FIT
	input [ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output [ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif

endmodule // dcfifo_mixed_widths

