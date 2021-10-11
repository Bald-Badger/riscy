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
module altserial_flash_loader(
	asmi_access_granted,
	asmi_access_request,
	data0out,
	dclkin,
	noe,
	scein,
	sdoin);

	parameter	enable_shared_access = "OFF";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altserial_flash_loader";


	input	asmi_access_granted;
	output	asmi_access_request;
	output	data0out;
	input	dclkin;
	input	noe;
	input	scein;
	input	sdoin;

endmodule

