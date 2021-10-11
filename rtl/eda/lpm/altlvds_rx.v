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
module altlvds_rx (
    rx_in,
    rx_inclock,
    rx_enable,
    rx_deskew,
    rx_pll_enable,
    rx_data_align,
    rx_reset,
    rx_dpll_reset,
    rx_dpll_hold,
    rx_dpll_enable,
    rx_fifo_reset,
    rx_channel_data_align,
    rx_cda_reset,
    rx_data_align_reset,
    rx_coreclk,
    pll_areset,
    rx_out,
    rx_outclock,
    rx_locked,
    rx_dpa_locked,
    rx_cda_max, 
	 rx_divfwdclk,
	 rx_readclock, 
	 rx_syncclock 
);

	parameter number_of_channels = 1;
	parameter deserialization_factor = 4;
	parameter registered_output = "ON";
	parameter inclock_period = 0;
	parameter inclock_boost = 0;
	parameter cds_mode = "UNUSED";
	parameter intended_device_family = "UNUSED";
	parameter input_data_rate =0;
	parameter inclock_data_alignment = "EDGE_ALIGNED";
	parameter registered_data_align_input = "ON";
	parameter common_rx_tx_pll = "ON";
	parameter enable_dpa_fifo = "OFF";
	parameter use_dpll_rawperror = "OFF";
	parameter use_coreclock_input = "OFF";
	parameter dpll_lock_count = 0; 
	parameter dpll_lock_window = 0;
	parameter outclock_resource = "AUTO";
	parameter data_align_rollover = 4;
	parameter lose_lock_on_one_change = "OFF";
	parameter reset_fifo_at_first_lock = "ON";
	parameter implement_in_les = "OFF";

	parameter enable_dpa_mode = "OFF";
	parameter use_external_pll = "OFF";
	parameter lpm_hint = "UNUSED";
	parameter lpm_type = "altlvds_rx";

   parameter clk_src_is_pll = "off";

   parameter port_rx_data_align = "PORT_CONNECTIVITY";
	parameter pll_operation_mode = "NORMAL";

	parameter rx_align_data_reg = "RISING_EDGE";
	parameter use_no_phase_shift = "ON";
	parameter x_on_bitslip = "ON";

	parameter buffer_implementation = "RAM";
	parameter enable_soft_cdr_mode = "OFF"; 	
	parameter inclock_phase_shift = 0;	
	parameter sim_dpa_output_clock_phase_shift = 0;

	parameter dpa_initial_phase_value = 0;
	parameter enable_dpa_align_to_rising_edge_only = "OFF";
	parameter enable_dpa_initial_phase_selection = "OFF";
	parameter sim_dpa_is_negative_ppm_drift = "OFF";
	parameter sim_dpa_net_ppm_variation = 0;
	parameter pll_self_reset_on_loss_lock = "OFF";

   parameter width_des_channels_ = deserialization_factor*number_of_channels;

   input [number_of_channels -1 :0] rx_in;
   input rx_inclock;
   input rx_enable;
   input rx_deskew;
   input rx_pll_enable;
   input rx_data_align;
   input [number_of_channels -1 :0] rx_reset;
   input [number_of_channels -1 :0] rx_dpll_reset;
   input [number_of_channels -1 :0] rx_dpll_hold;
   input [number_of_channels -1 :0] rx_dpll_enable;
   input [number_of_channels -1 :0] rx_fifo_reset;
   input [number_of_channels -1 :0] rx_channel_data_align;
   input [number_of_channels -1 :0] rx_cda_reset;
   input rx_data_align_reset;
   input [number_of_channels -1 :0] rx_coreclk;
   input pll_areset;
	input	rx_readclock;
	input	rx_syncclock;

   output [width_des_channels_ -1: 0] rx_out;
   output rx_outclock;
   output rx_locked;
   output [number_of_channels -1: 0] rx_dpa_locked;
   output [number_of_channels -1: 0] rx_cda_max;
   output [number_of_channels -1: 0] rx_divfwdclk; 

`include "altera_mf_macros.i"

	generate
	if( IS_FAMILY_CYCLONE( intended_device_family ) || IS_FAMILY_CYCLONEII( intended_device_family ) || FEATURE_FAMILY_CYCLONEIII( intended_device_family ) || 
		( implement_in_les == "ON" ) ) begin
		flvds_rx
		#(
			.number_of_channels( number_of_channels ),
			.deserialization_factor( deserialization_factor ),
			.registered_output( registered_output ),
			.inclock_period( inclock_period ),
			.inclock_boost( inclock_boost ),
			.intended_device_family( intended_device_family ),
			.inclock_data_alignment( inclock_data_alignment ),
			.common_rx_tx_pll( common_rx_tx_pll ),
			.outclock_resource( outclock_resource ),
			.use_external_pll( use_external_pll ),
			.clk_src_is_pll( clk_src_is_pll ),
			.cds_mode( cds_mode ),
			.input_data_rate( input_data_rate ),
			.registered_data_align_input( registered_data_align_input ),
			.enable_dpa_fifo( enable_dpa_fifo ),
			.use_dpll_rawperror( use_dpll_rawperror ),
			.use_coreclock_input( use_coreclock_input ),
			.dpll_lock_count( dpll_lock_count ),
			.dpll_lock_window( dpll_lock_window ),
			.data_align_rollover( data_align_rollover ),
			.lose_lock_on_one_change( lose_lock_on_one_change ),
			.reset_fifo_at_first_lock( reset_fifo_at_first_lock ),
			.enable_dpa_mode( enable_dpa_mode ),
			.port_rx_data_align( port_rx_data_align ) ,
			.pll_self_reset_on_loss_lock( pll_self_reset_on_loss_lock)
		) rx_blk (
			.rx_in(rx_in),
			.rx_inclock(rx_inclock),
			.rx_enable(rx_enable),
			.rx_pll_enable(rx_pll_enable),
			.pll_areset(pll_areset),
			.rx_out(rx_out),
			.rx_outclock(rx_outclock),
			.rx_coreclk(rx_coreclk),
			.rx_locked(rx_locked),
			.rx_deskew(rx_deskew),
			.rx_data_align(rx_data_align),
			.rx_reset(rx_reset),
			.rx_dpll_reset(rx_dpll_reset),
			.rx_dpll_hold(rx_dpll_hold),
			.rx_dpll_enable(rx_dpll_enable),
			.rx_fifo_reset(rx_fifo_reset),
			.rx_channel_data_align(rx_channel_data_align),
			.rx_cda_reset(rx_cda_reset),
			.rx_data_align_reset(rx_data_align_reset),
			.rx_dpa_locked(rx_dpa_locked),
			.rx_cda_max(rx_cda_max),
	 		.rx_syncclock( rx_syncclock )
		);
	end
	else begin
		lvds_rx
		#(
			.number_of_channels( number_of_channels ),
			.deserialization_factor( deserialization_factor ),
			.registered_output( registered_output ),
			.inclock_period( inclock_period ),
			.inclock_boost( inclock_boost ),
			.intended_device_family( intended_device_family ),
			.inclock_data_alignment( inclock_data_alignment ),
			.common_rx_tx_pll( common_rx_tx_pll ),
			.outclock_resource( outclock_resource ),
			.use_external_pll( use_external_pll ),
			.clk_src_is_pll( clk_src_is_pll ),
			.cds_mode( cds_mode ),
			.input_data_rate( input_data_rate ),
			.registered_data_align_input( registered_data_align_input ),
			.enable_dpa_fifo( enable_dpa_fifo ),
			.use_dpll_rawperror( use_dpll_rawperror ),
			.use_coreclock_input( use_coreclock_input ),
			.dpll_lock_count( dpll_lock_count ),
			.dpll_lock_window( dpll_lock_window ),
			.data_align_rollover( data_align_rollover ),
			.lose_lock_on_one_change( lose_lock_on_one_change ),
			.reset_fifo_at_first_lock( reset_fifo_at_first_lock ),
			.enable_dpa_mode( enable_dpa_mode ),
			.port_rx_data_align( port_rx_data_align ),
			.x_on_bitslip( x_on_bitslip ),
			.buffer_implementation( buffer_implementation ),
			.enable_soft_cdr_mode( enable_soft_cdr_mode ), 
			.inclock_phase_shift( inclock_phase_shift )
		) rx_blk (
			.rx_in(rx_in),
			.rx_inclock(rx_inclock),
			.rx_enable(rx_enable),
			.rx_pll_enable(rx_pll_enable),
			.pll_areset(pll_areset),
			.rx_out(rx_out),
			.rx_outclock(rx_outclock),
			.rx_coreclk(rx_coreclk),
			.rx_locked(rx_locked),
			.rx_deskew(rx_deskew),
			.rx_data_align(rx_data_align),
			.rx_reset(rx_reset),
			.rx_dpll_reset(rx_dpll_reset),
			.rx_dpll_hold(rx_dpll_hold),
			.rx_dpll_enable(rx_dpll_enable),
			.rx_fifo_reset(rx_fifo_reset),
			.rx_channel_data_align(rx_channel_data_align),
			.rx_cda_reset(rx_cda_reset),
			.rx_dpa_locked(rx_dpa_locked),
			.rx_cda_max(rx_cda_max),
	 		.rx_divfwdclk( rx_divfwdclk ),
	 		.rx_readclock( rx_readclock ),
	 		.rx_syncclock( rx_syncclock )
		);
	end
	endgenerate
endmodule
