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
module altsource_probe(
	clrn,
	ena,
	ir_in,
	ir_out,
	jtag_state_cdr,
	jtag_state_cir,
	jtag_state_e1dr,
	jtag_state_sdr,
	jtag_state_tlr,
	jtag_state_udr,
	jtag_state_uir,
	probe,
	raw_tck,
	source,
	source_clk,
	source_ena,
	tdi,
	tdo,
	usr1);

	parameter	enable_metastability = "NO";
	parameter	instance_id = "UNUSED";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altsource_probe";
	parameter	probe_width = 1;
	parameter	sld_auto_instance_index = "YES";
	parameter	sld_instance_index = 0;
	parameter	sld_ir_width = 4;
	parameter	sld_node_info = 4746752;
	parameter	source_initial_value = "0";
	parameter	source_width = 1;


	input	clrn;
	input	ena;
	input	[sld_ir_width-1:0]	ir_in;
	output	[sld_ir_width-1:0]	ir_out;
	input	jtag_state_cdr;
	input	jtag_state_cir;
	input	jtag_state_e1dr;
	input	jtag_state_sdr;
	input	jtag_state_tlr;
	input	jtag_state_udr;
	input	jtag_state_uir;
	input	[probe_width-1:0]	probe;
	input	raw_tck;
	output	[source_width-1:0]	source;
	input	source_clk;
	input	source_ena;
	input	tdi;
	output	tdo;
	input	usr1;

endmodule

