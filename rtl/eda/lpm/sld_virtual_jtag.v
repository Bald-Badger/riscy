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
//
// FV BBox Model for sld_virtual_jtag 
// Generated with 'mega_defn_creator' loader 
//////////////////////////////////////////////////////////////////////////
module sld_virtual_jtag(
	ir_in,
	ir_out,
	jtag_state_cdr,
	jtag_state_cir,
	jtag_state_e1dr,
	jtag_state_e1ir,
	jtag_state_e2dr,
	jtag_state_e2ir,
	jtag_state_pdr,
	jtag_state_pir,
	jtag_state_rti,
	jtag_state_sdr,
	jtag_state_sdrs,
	jtag_state_sir,
	jtag_state_sirs,
	jtag_state_tlr,
	jtag_state_udr,
	jtag_state_uir,
	tck,
	tdi,
	tdo,
	tms,
	virtual_state_cdr,
	virtual_state_cir,
	virtual_state_e1dr,
	virtual_state_e2dr,
	virtual_state_pdr,
	virtual_state_sdr,
	virtual_state_udr,
`ifdef POST_FIT
	_unassoc_outputs_,
	_unassoc_inputs_,
`endif
	virtual_state_uir
);

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "sld_virtual_jtag";
	parameter	sld_auto_instance_index = "NO";
	parameter	sld_instance_index = 0;
	parameter	sld_ir_width = 1;
	parameter	sld_sim_action = "UNUSED";
	parameter	sld_sim_n_scan = 0;
	parameter	sld_sim_total_length = 0;
`ifdef POST_FIT
	parameter	_unassoc_outputs_width_ = 1;
	parameter	_unassoc_inputs_width_ = 1;
`endif

	output	[sld_ir_width-1:0]	ir_in;
	input	[sld_ir_width-1:0]	ir_out;
	output	jtag_state_cdr;
	output	jtag_state_cir;
	output	jtag_state_e1dr;
	output	jtag_state_e1ir;
	output	jtag_state_e2dr;
	output	jtag_state_e2ir;
	output	jtag_state_pdr;
	output	jtag_state_pir;
	output	jtag_state_rti;
	output	jtag_state_sdr;
	output	jtag_state_sdrs;
	output	jtag_state_sir;
	output	jtag_state_sirs;
	output	jtag_state_tlr;
	output	jtag_state_udr;
	output	jtag_state_uir;
	output	tck;
	output	tdi;
	input	tdo;
	output	tms;
	output	virtual_state_cdr;
	output	virtual_state_cir;
	output	virtual_state_e1dr;
	output	virtual_state_e2dr;
	output	virtual_state_pdr;
	output	virtual_state_sdr;
	output	virtual_state_udr;
	output	virtual_state_uir;
`ifdef POST_FIT
	input 	[ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output 	[ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif

endmodule // sld_virtual_jtag

