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
module altparallel_flash_loader(
	flash_addr,
	flash_clk,
	flash_data,
	flash_nadv,
	flash_nce,
	flash_noe,
	flash_nreset,
	flash_nwe,
	fpga_conf_done,
	fpga_data,
	fpga_dclk,
	fpga_nconfig,
	fpga_nstatus,
	fpga_pgm,
	pfl_clk,
	pfl_flash_access_granted,
	pfl_flash_access_request,
	pfl_nreconfigure,
	pfl_nreset);

	parameter	addr_width = 20;
	parameter	auto_restart = "OFF";
	parameter	burst_mode = 0;
	parameter	burst_mode_intel = 0;
	parameter	burst_mode_spansion = 0;
	parameter	clk_divisor = 1;
	parameter	conf_data_width = 1;
	parameter	dclk_divisor = 1;
	parameter	enhanced_flash_programming = 0;
	parameter	features_cfg = 1;
	parameter	features_pgm = 1;
	parameter	fifo_size = 16;
	parameter	flash_data_width = 16;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altparallel_flash_loader";
	parameter	normal_mode = 1;
	parameter	option_bits_start_address = 0;
	parameter	page_clk_divisor = 1;
	parameter	page_mode = 0;
	parameter	safe_mode_halt = 0;
	parameter	safe_mode_retry = 1;
	parameter	safe_mode_revert = 0;
	parameter	safe_mode_revert_addr = 0;
	parameter	tristate_checkbox = 0;


	output	[addr_width-1:0]	flash_addr;
	output	flash_clk;
	inout	[flash_data_width-1:0]	flash_data;
	output	flash_nadv;
	output	flash_nce;
	output	flash_noe;
	output	flash_nreset;
	output	flash_nwe;
	input	fpga_conf_done;
	output	[conf_data_width-1:0]	fpga_data;
	output	fpga_dclk;
	output	fpga_nconfig;
	input	fpga_nstatus;
	input	[2:0]	fpga_pgm;
	input	pfl_clk;
	input	pfl_flash_access_granted;
	output	pfl_flash_access_request;
	input	pfl_nreconfigure;
	input	pfl_nreset;

endmodule