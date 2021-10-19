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
module flvds_tx (
    tx_in,
    tx_inclock,
    tx_enable,
    sync_inclock,
    tx_pll_enable,
    pll_areset,
    tx_out,
    tx_outclock,
    tx_coreclock,
    tx_locked
);

	parameter number_of_channels = 1;
	parameter deserialization_factor = 4;
	parameter registered_input = "ON";
	parameter multi_clock = "OFF";
	parameter inclock_period = 0;
	parameter outclock_divide_by = 1;
	parameter inclock_boost = 0;
	parameter center_align_msb = "UNUSED";
	parameter intended_device_family = "APEX20KE";
	parameter output_data_rate = 0;
	parameter inclock_data_alignment = "EDGE_ALIGNED";
	parameter outclock_alignment = "EDGE_ALIGNED";
	parameter common_rx_tx_pll = "ON";
	parameter outclock_resource = "AUTO";
	parameter use_external_pll = "OFF";
	parameter preemphasis_setting = 0;
	parameter vod_setting = 0;
	parameter differential_drive = 0;

	parameter lpm_type = "altlvds_tx";
	parameter clk_src_is_pll = "off";
	parameter coreclock_divide_by = "2";
	parameter outclock_multiply_by = 1;
	parameter outclock_duty_cycle = 50;
	parameter pll_self_reset_on_loss_lock = "OFF";

    parameter width_des_channels_ = deserialization_factor*number_of_channels;

	parameter PLL_M_VALUE = (((output_data_rate * inclock_period)
		+ (5 * 100000)) / 1000000);
	parameter STRATIX_INCLOCK_BOOST =
		((output_data_rate !=0) && (inclock_period !=0))
			? PLL_M_VALUE : ((inclock_boost == 0) ? deserialization_factor
			: inclock_boost);
	parameter CLOCK_PERIOD = (deserialization_factor > 2) ? inclock_period :
		10000;
    parameter PHASE_OUTCLOCK = (outclock_alignment == "EDGE_ALIGNED") ?
		0:
		(outclock_alignment == "CENTER_ALIGNED") ?
		((0.5 * inclock_period / STRATIX_INCLOCK_BOOST) +
		0.5):
		(outclock_alignment == "45_DEGREES") ?
			((0.125 * inclock_period / STRATIX_INCLOCK_BOOST) +
				0.5):
		(outclock_alignment == "90_DEGREES") ?
		((0.25 * inclock_period / STRATIX_INCLOCK_BOOST) +
			0.5):
		(outclock_alignment == "135_DEGREES") ?
			((0.375 * inclock_period / STRATIX_INCLOCK_BOOST) +
				0.5):
		(outclock_alignment == "180_DEGREES") ?
			((0.5 * inclock_period / STRATIX_INCLOCK_BOOST) +
				0.5):
		(outclock_alignment == "225_DEGREES") ?
			((0.625 * inclock_period / STRATIX_INCLOCK_BOOST) +
				0.5):
		(outclock_alignment == "270_DEGREES") ?
			((0.75 * inclock_period / STRATIX_INCLOCK_BOOST) +
				0.5):
		(outclock_alignment == "315_DEGREES") ?
			((0.875 * inclock_period / STRATIX_INCLOCK_BOOST) +
				0.5): 0;
	parameter PHASE_INCLOCK = (inclock_data_alignment == "EDGE_ALIGNED")?
			0 :
		(inclock_data_alignment == "CENTER_ALIGNED") ?
			(0.5 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5:
		(inclock_data_alignment == "45_DEGREES") ?
			(0.125 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5:
		(inclock_data_alignment == "90_DEGREES") ?
			(0.25 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5:
		(inclock_data_alignment == "135_DEGREES") ?
			(0.375 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5:
		(inclock_data_alignment == "180_DEGREES") ?
			(0.5 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5:
		(inclock_data_alignment == "225_DEGREES") ?
			(0.625 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5:
		(inclock_data_alignment == "270_DEGREES") ?
			(0.75 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5:
		(inclock_data_alignment == "315_DEGREES") ?
			(0.875 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5: 0;
    parameter STX_PHASE_OUTCLOCK  = ((outclock_divide_by == 1) ||
		(outclock_alignment == "45_DEGREES") ||
		(outclock_alignment == "90_DEGREES") ||
		(outclock_alignment == "135_DEGREES")) ?
			PHASE_OUTCLOCK + PHASE_INCLOCK:
		((outclock_alignment == "180_DEGREES") ||
		(outclock_alignment == "CENTER_ALIGNED")) ?
			PHASE_INCLOCK :
		(outclock_alignment == "225_DEGREES") ?
			((0.125 * inclock_period / STRATIX_INCLOCK_BOOST) +
				0.5 + PHASE_INCLOCK):
		(outclock_alignment == "270_DEGREES") ?
			((0.25 * inclock_period / STRATIX_INCLOCK_BOOST) +
				0.5 + PHASE_INCLOCK):
		(outclock_alignment == "315_DEGREES") ?
			((0.375 * inclock_period / STRATIX_INCLOCK_BOOST) +
				0.5 + PHASE_INCLOCK): PHASE_INCLOCK;
	parameter STXII_PHASE_OUTCLOCK = STX_PHASE_OUTCLOCK - (0.5 *
		inclock_period / STRATIX_INCLOCK_BOOST);
    parameter STXII_PHASE_INCLOCK = PHASE_INCLOCK - (0.5 *
		inclock_period / STRATIX_INCLOCK_BOOST);

	localparam tx_data_width = ( deserialization_factor % 2 == 0 ) ?
		deserialization_factor : deserialization_factor * 2;

	localparam TXDATA_FROM_PHASE_SHIFT_4_4 = 4'd12;
	localparam TXDATA_FROM_PHASE_SHIFT_6_6 = 6'd56;
	localparam TXDATA_FROM_PHASE_SHIFT_7_7 = 7'd99;
	localparam TXDATA_FROM_PHASE_SHIFT_8_4 = 8'd204;
	localparam TXDATA_FROM_PHASE_SHIFT_8_8 = 8'd240;
	localparam TXDATA_FROM_PHASE_SHIFT_10_10 = 10'd992;
	localparam TXDATA_FROM_PHASE_SHIFT_4_2 = 4'd5;
	localparam TXDATA_FROM_PHASE_SHIFT_5_5 = 5'd19;
	localparam TXDATA_FROM_PHASE_SHIFT_6_2 = 6'd42;
	localparam TXDATA_FROM_PHASE_SHIFT_8_2 = 8'd170;
	localparam TXDATA_FROM_PHASE_SHIFT_9_9 = 9'd391;
	localparam TXDATA_FROM_PHASE_SHIFT_10_2 = 10'd682;

	localparam tx_count_upto_number = tx_data_width / 2;
	localparam oclk_count_upto_number = deserialization_factor;
	localparam tx_counter_size =
		( tx_count_upto_number <= 2 ) ?  1 : (
		( tx_count_upto_number <= 4 ) ?  2 : (
		( tx_count_upto_number <= 8 ) ?  3 : (
		( tx_count_upto_number <= 14 ) ?  4 : (
		( tx_count_upto_number <= 18 ) ?  5 : tx_count_upto_number ))));
	localparam oclk_counter_size =
		( oclk_count_upto_number <= 2 ) ?  1 : (
		( oclk_count_upto_number <= 4 ) ?  2 : (
		( oclk_count_upto_number <= 8 ) ?  3 : (
		( oclk_count_upto_number <= 14 ) ?  4 : (
		( oclk_count_upto_number <= 18 ) ?  5 : oclk_count_upto_number ))));

	localparam use_new_coreclk_ckt = (deserialization_factor%2 == 1) && (coreclock_divide_by == 1) ? "TRUE" : "FALSE";

    input  [ width_des_channels_ - 1 : 0 ] tx_in;
    input tx_inclock;
    input tx_enable;
    input sync_inclock;
    input tx_pll_enable;
    input pll_areset;

    output [ number_of_channels - 1 : 0 ] tx_out;
    output tx_outclock;
    output tx_coreclock;
    output tx_locked;

	wire tx_inclock_or_pll;
	wire [5:0] pll_outclock;
	wire [3:0] pll_extclock;
	wire [ deserialization_factor - 1 : 0 ] oclk_din;
	wire [ deserialization_factor - 1 : 0 ] outclk_data_l;
	wire [ deserialization_factor - 1 : 0 ] outclk_data_h;
	wire locked;
	wire sclkout0;
	wire sclkout1;
	wire enable0;
	wire enable1;
	wire [5:0] clk_ena;
	wire [3:0] ext_clk_ena;
	wire oclk_ddo_clk;
	wire oclk_ddo_clk_l;
	wire oclk_ddo_clk_h;
	//wire oclk_shrg_ld_ctrl;
	wire [ oclk_counter_size - 1 : 0 ] oclk_ld_cntr_out;
	wire [ tx_counter_size - 1 : 0 ] tx_ld_cntr_out;
	wire slow_clock;
	wire fast_clock;
	wire out_clock;

	wire tx_shrg_ld_ctrl;
	wire tx_oclk_ld_ctrl;
	wire sync_dffe_q;

	assign tx_coreclock = slow_clock;
	assign clk_ena = 6'b111111;
	assign ext_clk_ena = 4'b1111;

	wire[tx_counter_size-1:0] h_ff_q;
	wire[tx_counter_size-1:0] l_ff_q;
	wire[tx_counter_size-1:0] h_s_ff_q;
	wire[tx_counter_size-1:0] l_s_ff_q;
	wire[tx_counter_size-1:0] h_us_ff_q;
	wire[tx_counter_size-1:0] l_us_ff_q;


	dffep sync_dffe (
		.q( sync_dffe_q ),
		.ck( slow_clock ),
		.en( 1'b1 ),
		.d( ~sync_dffe_q ),
		.s( 1'b0 ),
		.r( 1'b0)
	);

	dffep h_ff[tx_counter_size-1:0] (
		.q( h_ff_q ),
		.ck( fast_clock ),
		.en( sync_dffe_q ),
		.d( tx_ld_cntr_out ),
		.s( 1'b0 ),
		.r( 1'b0)
	);

	dffep l_ff[tx_counter_size-1:0] (
		.q( l_ff_q ),
		.ck( fast_clock ),
		.en( ~sync_dffe_q ),
		.d( tx_ld_cntr_out ),
		.s( 1'b0 ),
		.r( 1'b0)
	);

	dffep h_us_ff[tx_counter_size-1:0] (
		.q( h_us_ff_q ),
		.ck( fast_clock ),
		.en( sync_dffe_q ),
		.d( h_ff_q ),
		.s( 1'b0 ),
		.r( 1'b0)
	);

	dffep l_us_ff[tx_counter_size-1:0] (
		.q( l_us_ff_q ),
		.ck( fast_clock ),
		.en( ~sync_dffe_q ),
		.d( l_ff_q ),
		.s( 1'b0 ),
		.r( 1'b0)
	);

	dffep h_s_ff[tx_counter_size-1:0] (
		.q( h_s_ff_q ),
		.ck( fast_clock ),
		.en( ~sync_dffe_q ),
		.d( h_us_ff_q ),
		.s( 1'b0 ),
		.r( 1'b0)
	);

	dffep l_s_ff[tx_counter_size-1:0] (
		.q( l_s_ff_q ),
		.ck( fast_clock ),
		.en( sync_dffe_q ),
		.d( l_us_ff_q ),
		.s( 1'b0 ),
		.r( 1'b0)
	);



	dffep load_ff (
		.q( tx_shrg_ld_ctrl ),
		.ck( fast_clock ),
		.en( 1'b1 ),
		.d( ((h_ff_q == h_s_ff_q) & sync_dffe_q) | ((l_ff_q == l_s_ff_q) & ~sync_dffe_q) ),
		.s( 1'b0 ),
		.r( 1'b0)
	);

	
	lpm_counter #(
		.lpm_width( tx_counter_size ),
		.lpm_modulus( tx_count_upto_number )
	) load_cntr (
		.clock(fast_clock),
		.aclr(pll_areset),
		.aload(1'b0),
		.aset(1'b0),
		.cin(1'b1),
		.clk_en(1'b1),
		.cnt_en(1'b1),
		.data(1'b0),
		.sclr(1'b0),
		.sload(1'b0),
		.sset(1'b0),
		.updown(sync_dffe_q),
		.q(tx_ld_cntr_out)
	);

	lpm_counter #(
		.lpm_width( oclk_counter_size ),
		.lpm_modulus( oclk_count_upto_number ),
		.lpm_port_updown( "PORT_UNUSED" ),
		.lpm_direction("UP")
	) outclk_load_cntr (
		.clock(fast_clock),
		.aclr(pll_areset),
		.aload(1'b0),
		.aset(1'b0),
		.cin(1'b1),
		.clk_en(1'b1),
		.cnt_en(1'b1),
		.data(1'b0),
		.sclr(1'b0),
		.sload(1'b0),
		.sset(1'b0),
		.updown(1'b1),
		.q(oclk_ld_cntr_out)
	);

	assign tx_oclk_ld_ctrl = ( oclk_ld_cntr_out == 0 ) ? 1'b1 : 1'b0;

`include "altera_mf_macros.i"

	generate
	genvar i, j;

	if( FEATURE_FAMILY_STRATIXIII( intended_device_family ) || FEATURE_FAMILY_CYCLONEIII( intended_device_family )) begin
		wire pll_lock_sync_q;

		dffep pll_lock_sync (
			.q( pll_lock_sync_q ),
			.ck( locked ),
			.en( 1'b1 ),
			.d( 1'b1 ),
			.s( 1'b0 ),
			.r( pll_areset )
		);

		assign tx_locked = locked & pll_lock_sync_q;
	end
	else begin
		assign tx_locked = locked;
	end


	if( IS_FAMILY_STRATIXII( intended_device_family ) ) begin
		assign slow_clock = pll_outclock[0];
		assign fast_clock = sclkout0;

		stratixii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( STXII_PHASE_INCLOCK ),
			.clk1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk2_phase_shift( 1 ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, tx_inclock} ),
			.ena( tx_pll_enable ),
			.areset( pll_areset ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock ),
			.locked( locked ),
			.enable0( enable0 ),
			.enable1( enable1 )
		);
	end
	else if( IS_FAMILY_STRATIXIII( intended_device_family ) ) begin
		assign slow_clock = (deserialization_factor%2==0)? pll_outclock[1] : pll_outclock[2];
		assign fast_clock = pll_outclock[0];
		assign out_clock = (deserialization_factor%2==0)? pll_outclock[0] : pll_outclock[1];

		stratixiii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk2_divide_by( deserialization_factor ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( STXII_PHASE_INCLOCK ),
			.clk1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk2_phase_shift( 1 ),
			.m( 0 )
		) pll (
			.areset( pll_areset ),
 			.clkswitch( 1'b0 ),
			.configupdate( 1'b0 ),
			.fbin( feedback ),
			.inclk( {1'b0, tx_inclock} ),
			.pfdena( 1'b1 ),
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.scanclk( 1'b0 ),
			.scanclkena( 1'b1 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock ),
			.fbout( feedback ),
			.locked( locked ),
			.phasecounterselect( {1'b0, 1'b0, 1'b0, 1'b0} )
		);
	end
	else if( IS_FAMILY_STRATIXIV( intended_device_family ) ) begin
		assign slow_clock = (deserialization_factor%2==0)? pll_outclock[1] : pll_outclock[2];
		assign fast_clock = pll_outclock[0];
		assign out_clock = (deserialization_factor%2==0)? pll_outclock[0] : pll_outclock[1];

		stratixiv_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk2_divide_by( deserialization_factor ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( STXII_PHASE_INCLOCK ),
			.clk1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk2_phase_shift( 1 ),
			.m( 0 )
		) pll (
			.areset( pll_areset ),
 			.clkswitch( 1'b0 ),
			.configupdate( 1'b0 ),
			.fbin( feedback ),
			.inclk( {1'b0, tx_inclock} ),
			.pfdena( 1'b1 ),
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.scanclk( 1'b0 ),
			.scanclkena( 1'b1 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock ),
			.fbout( feedback ),
			.locked( locked ),
			.phasecounterselect( {1'b0, 1'b0, 1'b0, 1'b0} )
		);
	end
	else if( IS_FAMILY_STRATIX( intended_device_family ) ) begin
		assign slow_clock = pll_outclock[2];
		assign fast_clock = pll_outclock[0];

		stratix_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( STXII_PHASE_INCLOCK ),
			.clk1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk2_phase_shift( 1 ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, tx_inclock} ),
			.ena( tx_pll_enable ),
			.areset( pll_areset ),
			.clkena( clk_ena ),
			.extclkena( ext_clk_ena ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scanaclr( 1'b0 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock ),
			.extclk( pll_extclock ),
			.locked( locked ),
			.enable0( enable0 ),
			.enable1( enable1 )
		);
	end
	else if( IS_FAMILY_STRATIXGX( intended_device_family ) ) begin
		assign slow_clock = pll_outclock[2];
		assign fast_clock = pll_outclock[0];

		stratixgx_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( STXII_PHASE_INCLOCK ),
			.clk1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk2_phase_shift( 1 ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, tx_inclock} ),
			.ena( tx_pll_enable ),
			.areset( pll_areset ),
			.clkena( clk_ena ),
			.extclkena( ext_clk_ena ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scanaclr( 1'b0 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock ),
			.extclk( pll_extclock ),
			.locked( locked ),
			.enable0( enable0 ),
			.enable1( enable1 )
		);
	end
	else if( IS_FAMILY_CYCLONE( intended_device_family ) ) begin
		assign slow_clock = pll_outclock[1];
		assign fast_clock = pll_outclock[0];
		assign out_clock = (deserialization_factor%2==0)? pll_outclock[0] : pll_outclock[1];

		cyclone_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( STXII_PHASE_INCLOCK ),
			.clk1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk2_phase_shift( 1 ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, tx_inclock} ),
			.ena( tx_pll_enable ),
			.areset( pll_areset ),
			.clkena( clk_ena ),
			.extclkena( ext_clk_ena ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scanaclr( 1'b0 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock ),
			.extclk( pll_extclock ),
			.locked( locked ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.comparator( 1'b0 )
		);
	end
	else if( IS_FAMILY_CYCLONEII( intended_device_family ) ) begin
		assign slow_clock = (deserialization_factor%2==0)? pll_outclock[1] : pll_outclock[2];
		assign fast_clock = pll_outclock[0];
		assign out_clock = (deserialization_factor%2==0)? pll_outclock[0] : pll_outclock[1];

		cycloneii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( STXII_PHASE_INCLOCK ),
			.clk1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk2_phase_shift( 1 ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, tx_inclock} ),
			.ena( tx_pll_enable ),
			.areset( pll_areset ),
			.pfdena( 1'b1 ),
			.clkswitch( 1'b0 ),
			.clk( pll_outclock[3:0] ),
			.locked( locked ),
			.sbdin (1'b0 ),
			.testclearlock (1'b0 )
		);
	end
	else if( FEATURE_FAMILY_CYCLONEIII( intended_device_family ) ) begin
		assign slow_clock = (deserialization_factor%2==0)? pll_outclock[1] : pll_outclock[2];
		assign fast_clock = pll_outclock[0];
		assign out_clock = (deserialization_factor%2==0)? pll_outclock[0] : pll_outclock[1];

		cycloneiii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk2_divide_by( deserialization_factor ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( STXII_PHASE_INCLOCK ),
			.clk1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk2_phase_shift( 1 ),
			.m( 0 )
		) pll (
			.areset( pll_areset ),
 			.clkswitch( 1'b0 ),
			.configupdate( 1'b0 ),
			.fbin( feedback ),
			.inclk( {1'b0, tx_inclock} ),
			.pfdena( 1'b1 ),
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.scanclk( 1'b0 ),
			.scanclkena( 1'b1 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock ),
			.fbout( feedback ),
			.locked( locked ),
			.phasecounterselect( {1'b0, 1'b0, 1'b0} )
		);
	end

	for( i = 0 ; i < number_of_channels ; i = i + 1 ) begin : channel 
		wire [ tx_data_width - 1 : 0 ] tx_in_regd;
		wire [ tx_data_width - 1 : 0 ] tx_in_after_x2;
		wire datain_l;
		wire datain_h;
		wire [ tx_data_width/2 - 1 : 0 ] data_l;
		wire [ tx_data_width/2 - 1 : 0 ] data_h;

		for( j = 0 ; j < tx_data_width ; j = j + 1 ) begin : dsplit
			if( j % 2 ) begin
				assign data_h[ tx_data_width/2 - j/2 - 1 ] = tx_in_regd[j];
			end
			else begin
				assign data_l[ tx_data_width/2 - j/2 - 1 ] = tx_in_regd[j];
			end
		end

		lpm_shiftreg #(
			.lpm_width( tx_data_width / 2 ),
			.lpm_direction( "RIGHT" )
		) shrg_l (
			.enable(1'b1),
			.load(tx_shrg_ld_ctrl),
			.sclr(1'b0),
			.aclr(pll_areset),
			.clock(fast_clock),
			.data(data_l),
			.sset(1'b0),
			.shiftin(1'b0),
			.aset(1'b0),
			.shiftout(datain_l) );

		lpm_shiftreg #(
			.lpm_width( tx_data_width / 2 ),
			.lpm_direction( "RIGHT" )
		) shrg_h (
			.enable(1'b1),
			.load(tx_shrg_ld_ctrl),
			.sclr(1'b0),
			.aclr(pll_areset),
			.clock(fast_clock),
			.data(data_h),
			.sset(1'b0),
			.shiftin(1'b0),
			.aset(1'b0),
			.shiftout(datain_h) );


		altddio_out #(
			.width( 1 )
		) tx_ddo (
			.outclock(fast_clock),
			.datain_h(datain_h),
			.aclr(pll_areset),
			.sclr(1'b0),
			.sset(1'b0),
			.datain_l(datain_l),
			.dataout(tx_out[i]),
			.aset(1'b0),
			.oe(1'b1),
			.outclocken(1'b1) );

		if( deserialization_factor % 2 ) begin // Odd deser factors
			wire [ deserialization_factor - 1 : 0 ] tx_in_sync_l_regd;
			wire [ deserialization_factor - 1 : 0 ] tx_in_sync_h_regd;



			dffep sync_a_l_ff[deserialization_factor-1:0] (
				.q( tx_in_sync_l_regd ),
				.ck( ~slow_clock ),
				.en( 1'b1 ),
				.d( tx_in[ deserialization_factor * ( i + 1 ) - 1 :
					deserialization_factor * i ] ),
				.s( 1'b0 ),
				.r( pll_areset)
			);
			if(FEATURE_FAMILY_CYCLONE(intended_device_family) || FEATURE_FAMILY_CYCLONEII(intended_device_family) )
			begin
				assign tx_in_after_x2[ deserialization_factor - 1 : 0 ] = tx_in_sync_l_regd;
			end
			else begin
			dffep sync_b_l_ff[deserialization_factor-1:0] (
				.q( tx_in_after_x2[deserialization_factor-1:0] ),
				.ck( ~slow_clock ),
				.en( 1'b1 ),
				.d( tx_in_sync_l_regd ),
				.s( 1'b0 ),
				.r( pll_areset)
			);
			end

			dffep sync_a_h_ff[deserialization_factor-1:0] (
				.q( tx_in_sync_h_regd ),
				.ck( slow_clock ),
				.en( 1'b1 ),
				.d( tx_in[ deserialization_factor * ( i + 1 ) - 1 :
					deserialization_factor * i ] ),
				.s( 1'b0 ),
				.r( pll_areset)
			);

			dffep sync_b_h_ff[deserialization_factor-1:0] (
				.q( tx_in_after_x2[ 2 * deserialization_factor - 1 :
					deserialization_factor ] ),
				.ck( ~slow_clock ),
				.en( 1'b1 ),
				.d( tx_in_sync_h_regd ),
				.s( 1'b0 ),
				.r( pll_areset)
			);
		end
		else begin // Even deser factors
			assign tx_in_after_x2 = tx_in[ deserialization_factor * ( i + 1 )
				- 1 : deserialization_factor * i ];
		end

		if( registered_input == "TX_CLKIN" ) begin
			dffep tx_in_ff[ tx_data_width - 1 : 0 ] (
				.q( tx_in_regd ),
				.ck( tx_inclock ),
				.en( 1'b1 ),
				.d( tx_in_after_x2[ tx_data_width - 1 : 0 ] ),
				.s( 1'b0 ),
				.r( pll_areset )
			);
		end
		else if( registered_input == "TX_CORECLK" ||
			( registered_input == "ON" ) ) begin
			dffep tx_in_ff[ tx_data_width - 1 : 0 ] (
				.q( tx_in_regd ),
				.ck( slow_clock ),
				.en( 1'b1 ),
				.d( tx_in_after_x2[ tx_data_width - 1 : 0 ] ),
				.s( 1'b0 ),
				.r( pll_areset )
			);
		end
		else begin
			assign tx_in_regd = tx_in_after_x2;
		end
	end

	if ((deserialization_factor%2 == 1) || 
		(((deserialization_factor == 6) || (deserialization_factor == 10)) && 
			(outclock_multiply_by == 2) && (outclock_divide_by == deserialization_factor)))
	begin
		if (outclock_multiply_by == 2)
		begin
			assign outclk_data_l = (deserialization_factor == 5) ? ((use_new_coreclk_ckt == "TRUE") ? 5'd11 : 5'd13) :
					 (deserialization_factor == 7) ? ((use_new_coreclk_ckt == "TRUE") ? 7'd102 : 7'd27) :
					 (deserialization_factor == 9) ? ((use_new_coreclk_ckt == "TRUE") ? 9'd460 : 9'd115) : 0;
			assign outclk_data_h = (deserialization_factor == 5) ? ((use_new_coreclk_ckt == "TRUE") ? 5'd26 : 5'd11) :
					 (deserialization_factor == 7) ? ((use_new_coreclk_ckt == "TRUE") ? 7'd108 : 7'd51) :
					 (deserialization_factor == 9) ? ((use_new_coreclk_ckt == "TRUE") ? 9'd412 : 9'd103) : 0;
		end
		else
		begin
			if (outclock_duty_cycle != 50)
			begin
	 			assign outclk_data_l = (deserialization_factor == 5) ? ((use_new_coreclk_ckt == "TRUE") ? 5'd25 : 5'd28) :
						  (deserialization_factor == 7) ? ((use_new_coreclk_ckt == "TRUE") ? 7'd113 : 7'd120) :
						  (deserialization_factor == 9) ? ((use_new_coreclk_ckt == "TRUE") ? 9'd124 : 9'd31) : 0;
	 			assign outclk_data_h = (deserialization_factor == 5) ? ((use_new_coreclk_ckt == "TRUE") ? 5'd25: 5'd25) :
						  (deserialization_factor == 7) ? ((use_new_coreclk_ckt == "TRUE") ? 7'd113 : 7'd113) :
						  (deserialization_factor == 9) ? ((use_new_coreclk_ckt == "TRUE") ? 9'd124 : 9'd31) : 0;
			end
			else
			begin
	 			assign outclk_data_l = (deserialization_factor == 5) ? ((use_new_coreclk_ckt == "TRUE") ? 5'd24 : 5'd28) :
						  (deserialization_factor == 7) ? ((use_new_coreclk_ckt == "TRUE") ? 7'd112 : 7'd120) :
						  (deserialization_factor == 9) ? ((use_new_coreclk_ckt == "TRUE") ? 9'd60 : 9'd15) :
						  (deserialization_factor == 6) ? 6'd54 :
						  (deserialization_factor == 10) ? 10'd924 : 0;
	 			assign outclk_data_h = (deserialization_factor == 5) ? ((use_new_coreclk_ckt == "TRUE") ? 5'd25 : 5'd24) :
						  (deserialization_factor == 7) ? ((use_new_coreclk_ckt == "TRUE") ? 7'd113 : 7'd112) :
						  (deserialization_factor == 9) ? ((use_new_coreclk_ckt == "TRUE") ? 9'd124 : 9'd31) :
						  (deserialization_factor == 6) ? 6'd36 :
						  (deserialization_factor == 10) ? 10'd792 : 0;
			end
		end
	end
	else
	begin
		if (deserialization_factor == 4)
			assign outclk_data_l = (outclock_duty_cycle == 2) ? 4'd10 : (outclock_duty_cycle == 4) ? 4'd12 : 0;
		else if (deserialization_factor == 6)
			assign outclk_data_l = (outclock_duty_cycle == 2) ? 6'd42 : (outclock_duty_cycle == 6) ? 6'd56 : 0;
		else if (deserialization_factor == 8)
			assign outclk_data_l = (outclock_duty_cycle == 2) ? 8'd170 : (outclock_duty_cycle == 4) ? 8'd204 : 
					(outclock_duty_cycle == 8) ? 8'd240 : 0 ;
		else if (deserialization_factor == 10)
			assign outclk_data_l = (outclock_duty_cycle == 2) ? 10'd682 : (outclock_duty_cycle == 10) ? 10'd992 : 0;
		else if (deserialization_factor == 5)
			assign outclk_data_l = (outclock_duty_cycle == 5) ? 5'd19 : 0;
		else if (deserialization_factor == 7)
			assign outclk_data_l = (outclock_duty_cycle == 7) ? 7'd120 : 0;
		else if (deserialization_factor == 9)
			assign outclk_data_l = (outclock_duty_cycle == 9) ? 9'd391 : 0;
		 	 
	 	assign outclk_data_h = outclk_data_l;
	end

	if( outclock_divide_by > 1 ) begin
		if( outclock_divide_by == 2 ) begin
			if( deserialization_factor == 4 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_4_2;
			end
			else if( deserialization_factor == 6 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_6_2;
			end
			else if( deserialization_factor == 8 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_8_2;
			end
			else if( deserialization_factor == 10 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_10_2;
			end
		end
		else if( outclock_divide_by == 4 ) begin
			if( deserialization_factor == 4 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_4_4;
			end
			else if( deserialization_factor == 8 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_8_4;
			end
		end
		else if( outclock_divide_by == 5 ) begin
			if( deserialization_factor == 5 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_5_5;
			end
		end
		else if( outclock_divide_by == 6 ) begin
			if( deserialization_factor == 6 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_6_6;
			end
		end
		else if( outclock_divide_by == 7 ) begin
			if( deserialization_factor == 7 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_7_7;
			end
		end
		else if( outclock_divide_by == 8 ) begin
			if( deserialization_factor == 8 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_8_8;
			end
		end
		else if( outclock_divide_by == 9 ) begin
			if( deserialization_factor == 9 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_9_9;
			end
		end
		else if( outclock_divide_by == 10 ) begin
			if( deserialization_factor == 10 ) begin
				assign oclk_din = TXDATA_FROM_PHASE_SHIFT_10_10;
			end
		end
	end

	if (outclock_divide_by > 1) begin 

		if (deserialization_factor %2 == 1) begin // Odd deser
			if( IS_FAMILY_CYCLONE( intended_device_family ) )
			begin
				assign tx_outclock = pll_extclock[0];
			end
			else
			begin
			lpm_shiftreg #(
				.lpm_width( deserialization_factor ),
				.lpm_direction( "RIGHT" )
			) oclk_shrg_l (
				.enable(1'b1),
				.load(tx_oclk_ld_ctrl),
				.sclr(1'b0),
				.aclr(pll_areset),
				.clock(out_clock),
				.data(outclk_data_l),
				.sset(1'b0),
				.shiftin(1'b0),
				.aset(1'b0),
				.shiftout(oclk_ddo_clk_l) );
	
			lpm_shiftreg #(
				.lpm_width( deserialization_factor ),
				.lpm_direction( "RIGHT" )
			) oclk_shrg_h (
				.enable(1'b1),
				.load(tx_oclk_ld_ctrl),
				.sclr(1'b0),
				.aclr(pll_areset),
				.clock(out_clock),
				.data(outclk_data_h),
				.sset(1'b0),
				.shiftin(1'b0),
				.aset(1'b0),
				.shiftout(oclk_ddo_clk_h) );
	
			altddio_out #(
				.width( 1 )
			) oclk_ddo (
				.outclock(out_clock),
				.datain_h(oclk_ddo_clk_h),
				.aclr(pll_areset),
				.datain_l(oclk_ddo_clk_l),
				.dataout(tx_outclock),
				.aset(1'b0),
				.sclr(1'b0),
				.sset(1'b0),
				.oe(1'b1),
				.outclocken(1'b1) );
			end
		end
		else begin	// Even deser
			lpm_shiftreg #(
				.lpm_width( deserialization_factor ),
				.lpm_direction( "RIGHT" )
			) oclk_shrg (
				.enable(1'b1),
				.load(tx_oclk_ld_ctrl),
				.sclr(1'b0),
				.aclr(pll_areset),
				.clock(out_clock),
				.data(oclk_din),
				.sset(1'b0),
				.shiftin(1'b0),
				.aset(1'b0),
				.shiftout(oclk_ddo_clk) );
			
			altddio_out #(
				.width( 1 )
			) oclk_ddo (
				.outclock(out_clock),
				.datain_h(oclk_ddo_clk),
				.aclr(pll_areset),
				.datain_l(oclk_ddo_clk),
				.dataout(tx_outclock),
				.aset(1'b0),
				.sclr(1'b0),
				.sset(1'b0),
				.oe(1'b1),
				.outclocken(1'b1) );
		end
	end
	else begin
		assign tx_outclock = fast_clock;
	end
	endgenerate
endmodule

