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
module altlvds_tx (
    tx_in,
    tx_inclock,
    tx_enable,
    sync_inclock,
    tx_pll_enable,
    pll_areset,
    tx_out,
    tx_outclock,
    tx_coreclock,
    tx_locked,
	 tx_syncclock
);

	parameter number_of_channels = 1;
	parameter deserialization_factor = 4;
	parameter registered_input = "ON";
	parameter multi_clock = "OFF";
	parameter inclock_period = 0;
	parameter outclock_divide_by = 1;
	parameter inclock_boost = 0;
	parameter center_align_msb = "UNUSED";
	parameter intended_device_family = "UNUSED";
	parameter output_data_rate = 0;
	parameter inclock_data_alignment = "EDGE_ALIGNED";
	parameter outclock_alignment = "EDGE_ALIGNED";
	parameter common_rx_tx_pll = "ON";
	parameter outclock_resource = "AUTO";
	parameter use_external_pll = "OFF";
	parameter preemphasis_setting = 0;
	parameter vod_setting = 0;
	parameter differential_drive = 0;
	parameter implement_in_les = "OFF";

	parameter lpm_type = "altlvds_tx";
	parameter lpm_hint = "UNUSED";
	parameter clk_src_is_pll = "off";

	parameter coreclock_divide_by = 2;
	parameter outclock_multiply_by = 1;
	parameter outclock_duty_cycle = 50;

	parameter inclock_phase_shift = 0;
	parameter outclock_phase_shift = 0;
	parameter use_no_phase_shift = "ON";
	parameter pll_self_reset_on_loss_lock = "OFF";

	parameter width_des_channels_ = deserialization_factor*number_of_channels;

    input  [ width_des_channels_ - 1 : 0 ] tx_in;
    input tx_inclock;
    input tx_enable;
    input sync_inclock;
    input tx_pll_enable;
    input pll_areset;
	 input tx_syncclock;

    output [ number_of_channels - 1 : 0 ] tx_out;
    output tx_outclock;
    output tx_coreclock;
    output tx_locked;

`include "altera_mf_macros.i"

	generate
	if( IS_FAMILY_CYCLONE( intended_device_family ) ||
		 IS_FAMILY_CYCLONEII( intended_device_family ) ||
		 FEATURE_FAMILY_CYCLONEIII( intended_device_family ) ||
		( implement_in_les == "ON" ) ) begin
		flvds_tx
		#(
			.number_of_channels( number_of_channels ),
			.deserialization_factor( deserialization_factor ),
			.registered_input( registered_input ),
			.multi_clock( multi_clock ),
			.inclock_period( inclock_period ),
			.outclock_divide_by( outclock_divide_by ),
			.inclock_boost( inclock_boost ),
			.center_align_msb( center_align_msb ),
			.intended_device_family( intended_device_family ),
			.output_data_rate( output_data_rate ),
			.inclock_data_alignment( inclock_data_alignment ),
			.outclock_alignment( outclock_alignment ),
			.common_rx_tx_pll( common_rx_tx_pll ),
			.outclock_resource( outclock_resource ),
			.use_external_pll( use_external_pll ),
			.preemphasis_setting( preemphasis_setting ),
			.vod_setting( vod_setting ),
			.differential_drive( differential_drive ),
			.clk_src_is_pll( clk_src_is_pll ),
			.coreclock_divide_by( coreclock_divide_by ),
			.outclock_multiply_by( outclock_multiply_by ),
			.outclock_duty_cycle( outclock_duty_cycle ),
			.pll_self_reset_on_loss_lock( pll_self_reset_on_loss_lock )
		) tx_blk (
			.tx_in(tx_in),
			.tx_inclock(tx_inclock),
			.tx_enable(tx_enable),
			.sync_inclock(sync_inclock),
			.tx_pll_enable(tx_pll_enable),
			.pll_areset(pll_areset),
			.tx_out(tx_out),
			.tx_outclock(tx_outclock),
			.tx_coreclock(tx_coreclock),
			.tx_locked(tx_locked)
		);
	end
	else begin
		lvds_tx
		#(
			.number_of_channels( number_of_channels ),
			.deserialization_factor( deserialization_factor ),
			.registered_input( registered_input ),
			.multi_clock( multi_clock ),
			.inclock_period( inclock_period ),
			.outclock_divide_by( outclock_divide_by ),
			.inclock_boost( inclock_boost ),
			.center_align_msb( center_align_msb ),
			.intended_device_family( intended_device_family ),
			.output_data_rate( output_data_rate ),
			.inclock_data_alignment( inclock_data_alignment ),
			.outclock_alignment( outclock_alignment ),
			.common_rx_tx_pll( common_rx_tx_pll ),
			.outclock_resource( outclock_resource ),
			.use_external_pll( use_external_pll ),
			.preemphasis_setting( preemphasis_setting ),
			.vod_setting( vod_setting ),
			.differential_drive( differential_drive ),
			.clk_src_is_pll( clk_src_is_pll ),
			.inclock_phase_shift ( inclock_phase_shift ),
			.outclock_phase_shift( outclock_phase_shift ),
			.use_no_phase_shift( use_no_phase_shift )
		) tx_blk (
			.tx_in(tx_in),
			.tx_inclock(tx_inclock),
			.tx_enable(tx_enable),
			.sync_inclock(sync_inclock),
			.tx_pll_enable(tx_pll_enable),
			.pll_areset(pll_areset),
			.tx_out(tx_out),
			.tx_outclock(tx_outclock),
			.tx_coreclock(tx_coreclock),
			.tx_locked(tx_locked),
			.tx_syncclock( tx_syncclock )
		);
	end
	endgenerate
endmodule

