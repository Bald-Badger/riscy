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
`define DEFAULT_ZERO 1'b0

module lvds_tx (
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

	parameter inclock_phase_shift = 0;
	parameter outclock_phase_shift = 0;
	parameter use_no_phase_shift = "ON";

	parameter lpm_type = "altlvds_tx";
	parameter clk_src_is_pll = "off";

    parameter width_des_channels_ = deserialization_factor*number_of_channels;

	parameter PLL_M_VALUE = (((output_data_rate * inclock_period)
		+ (5 * 100000)) / 1000000);
	parameter STRATIX_INCLOCK_BOOST =
		((output_data_rate !=0) && (inclock_period !=0))
			? PLL_M_VALUE : ((inclock_boost == 0) ? deserialization_factor
			: inclock_boost);
	parameter CLOCK_PERIOD = (deserialization_factor > 2) ? inclock_period :
		10000;
    parameter PHASE_OUTCLOCK =  (outclock_alignment == "UNUSED") ?
	   outclock_phase_shift :
		(outclock_alignment == "EDGE_ALIGNED") ?
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
	parameter PHASE_INCLOCK =  (inclock_data_alignment == "UNUSED") ?  
		inclock_phase_shift :
		(inclock_data_alignment == "EDGE_ALIGNED")?
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
      (outclock_alignment == "UNUSED") ?
      ((outclock_phase_shift >= ((0.5 * inclock_period / STRATIX_INCLOCK_BOOST))) ?
         PHASE_OUTCLOCK + PHASE_INCLOCK - ((0.5 * inclock_period / STRATIX_INCLOCK_BOOST)) :
         PHASE_OUTCLOCK + PHASE_INCLOCK) :
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

`include "altera_mf_macros.i"

	localparam TXDATA_FROM_PHASE_SHIFT_4_2 = 4'd10;
	localparam TXDATA_FROM_PHASE_SHIFT_5_5 = 5'd19;
	localparam TXDATA_FROM_PHASE_SHIFT_6_2 = 6'd42;
	localparam TXDATA_FROM_PHASE_SHIFT_8_2 = 8'd170;
	localparam TXDATA_FROM_PHASE_SHIFT_9_9 = 9'd391;
	localparam TXDATA_FROM_PHASE_SHIFT_10_2 = 10'd682;
	localparam TXDATA_FROM_PHASE_SHIFT_X_1 = 0;

	localparam TXDATA_FROM_PHASE_SHIFT_4_4 =
		FEATURE_FAMILY_STRATIXII( intended_device_family ) ? 4'd12 : 4'd3;

	localparam TXDATA_FROM_PHASE_SHIFT_6_6 =
		FEATURE_FAMILY_STRATIXII( intended_device_family ) ? 6'd56 : 6'd35;

	localparam TXDATA_FROM_PHASE_SHIFT_7_7 =
		FEATURE_FAMILY_STRATIXII( intended_device_family ) ? 7'd120 : 7'd99;

	localparam TXDATA_FROM_PHASE_SHIFT_8_4 =
		FEATURE_FAMILY_STRATIXII( intended_device_family ) ? 8'd204 : 8'd51;

	localparam TXDATA_FROM_PHASE_SHIFT_8_8 =
		FEATURE_FAMILY_STRATIXII( intended_device_family ) ? 8'd240 : 8'd195;

	localparam TXDATA_FROM_PHASE_SHIFT_10_10 =
		FEATURE_FAMILY_STRATIXII( intended_device_family ) ? 10'd992 : 10'd899;

	localparam CLK0_MULTIPLY_FACTOR = STRATIX_INCLOCK_BOOST;
	localparam CLK0_DIVIDE_FACTOR =
		IS_FAMILY_STRATIXII( intended_device_family ) ?
		deserialization_factor : (
		IS_FAMILY_STRATIX( intended_device_family ) ? 1 : (
		IS_FAMILY_STRATIXGX( intended_device_family ) ? 1 : 1 ) );
	localparam CLK0_PHASE_SHIFT =
		IS_FAMILY_STRATIXII( intended_device_family ) ? STXII_PHASE_INCLOCK : (
		IS_FAMILY_STRATIX( intended_device_family ) ? PHASE_INCLOCK : (
		IS_FAMILY_STRATIXGX( intended_device_family ) ?
		PHASE_INCLOCK : 1 ) );

	localparam CLK1_MULTIPLY_FACTOR = STRATIX_INCLOCK_BOOST;
	localparam CLK1_DIVIDE_FACTOR =
		IS_FAMILY_STRATIXII( intended_device_family ) ?
		deserialization_factor : (
		IS_FAMILY_STRATIX( intended_device_family ) ? 1 : (
		IS_FAMILY_STRATIXGX( intended_device_family ) ? 1 : 1 ) );
	localparam CLK1_PHASE_SHIFT =
		IS_FAMILY_STRATIXII( intended_device_family ) ? STXII_PHASE_INCLOCK : (
		IS_FAMILY_STRATIX( intended_device_family ) ? STX_PHASE_OUTCLOCK : (
		IS_FAMILY_STRATIXGX( intended_device_family ) ?
		STX_PHASE_OUTCLOCK : 1 ) );

	localparam CLK2_MULTIPLY_FACTOR =
		IS_FAMILY_STRATIXII( intended_device_family ) ? 1 : (
		IS_FAMILY_STRATIX( intended_device_family ) ? STRATIX_INCLOCK_BOOST : (
		IS_FAMILY_STRATIXGX( intended_device_family ) ? STRATIX_INCLOCK_BOOST :
		1 ) );
	localparam CLK2_DIVIDE_FACTOR =
		IS_FAMILY_STRATIXII( intended_device_family ) ? 1 : (
		IS_FAMILY_STRATIX( intended_device_family ) ? deserialization_factor : (
		IS_FAMILY_STRATIXGX( intended_device_family ) ?
		deserialization_factor : 1 ) );
	localparam CLK2_PHASE_SHIFT =
		IS_FAMILY_STRATIXII( intended_device_family ) ? 1 : (
		IS_FAMILY_STRATIX( intended_device_family ) ? PHASE_INCLOCK : (
		IS_FAMILY_STRATIXGX( intended_device_family ) ?
		PHASE_INCLOCK : 1 ) );

	localparam pll_type = "fast";
	localparam bypass_serializer = ( outclock_divide_by == 1 ) ? "true" :
		"false";
	localparam invert_clock = ( outclock_divide_by == 1 ) &&
		( ( outclock_alignment == "CENTER_ALIGNED" ) ||
			(outclock_alignment == "180_DEGREES") ) ? "true" : "false";
	localparam use_falling_clock_edge = (
		(outclock_alignment == "180_DEGREES")   ||
		(outclock_alignment == "CENTER_ALIGNED") ||
		(outclock_alignment == "225_DEGREES")    ||
		(outclock_alignment == "270_DEGREES")    ||
		(outclock_alignment == "315_DEGREES") ) ?
			"true" : "false";

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

	wire tx_inclock_or_pll;
	wire [5:0] pll_outclock;
	wire [ deserialization_factor - 1 : 0 ] oclk_din;
	wire locked;
	wire sclkout0;
	wire sclkout1;
	wire enable0;
	wire enable1;
	wire [5:0] clk_ena;
	wire [3:0] ext_clk_ena;
	wire fast_clock;
	wire fast_clock2;
	wire slow_clock;
	wire fast_enable;
	wire fast_enable2;
	wire [ width_des_channels_ - 1 : 0 ] tx_in_regd;
	wire locked_wire, locked_reg, feedback;

	assign tx_coreclock = slow_clock;
	assign clk_ena = 6'b111111;
	assign ext_clk_ena = 4'b1111;

	function [79:0] int2str;
		input i;
		integer i;
		reg [79:0] s;
		integer j;
		reg [7:0] d;
	begin
		s = 0;
		for( j = 0 ; i > 0 ; j = j + 1 ) begin
			d = 48 + ( i % 10 );
			s[ j * 8 + 7 -: 8 ] = d;
			i = i / 10;
		end
		int2str = s;
	end
	endfunction

	generate
	genvar i;

	if( IS_FAMILY_STRATIXII( intended_device_family ) ) begin
		assign tx_locked = locked;
		assign slow_clock = pll_outclock[0];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			sclkout0 : tx_inclock;
		assign fast_enable = ( use_external_pll == "OFF" ) ?
			enable0 : tx_enable;
		assign fast_clock2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			sclkout0 : sclkout1;
		assign fast_enable2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			enable0 : enable1;
		stratixii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( CLK0_MULTIPLY_FACTOR ),
			.clk0_divide_by( CLK0_DIVIDE_FACTOR ),
			.clk1_multiply_by( CLK1_MULTIPLY_FACTOR ),
			.clk1_divide_by( CLK1_DIVIDE_FACTOR ),
			.clk2_multiply_by( CLK2_MULTIPLY_FACTOR ),
			.clk2_divide_by( CLK2_DIVIDE_FACTOR ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( int2str( CLK0_PHASE_SHIFT ) ),
			.clk1_phase_shift( int2str( CLK1_PHASE_SHIFT ) ),
			.clk2_phase_shift( int2str( CLK2_PHASE_SHIFT ) ),
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
			.scanread( 1'b0 ),
			.scanwrite( 1'b0 ),
			.sclkout( { sclkout1, sclkout0 } ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);

		stratixii_lvds_transmitter # (
			.preemphasis_setting( 0 ),
			.vod_setting( 0 ),
			.differential_drive( 0 ),
			.channel_width( deserialization_factor ),
			.bypass_serializer( bypass_serializer ),
			.invert_clock( invert_clock ),
			.use_falling_clock_edge( use_falling_clock_edge )
		) tx_oclk (
			.clk0( fast_clock2 ),
			.enable0( fast_enable2 ),
			.serialdatain( `DEFAULT_ZERO ),
			.postdpaserialdatain( `DEFAULT_ZERO ),
			.datain( oclk_din ),
			.dataout( tx_outclock )) ;
	end
	else if( IS_FAMILY_STRATIXIIGX( intended_device_family ) ) begin
		assign tx_locked = locked;
		assign slow_clock = pll_outclock[0];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			sclkout0 : tx_inclock;
		assign fast_enable = ( use_external_pll == "OFF" ) ?
			enable0 : tx_enable;
		assign fast_clock2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			sclkout0 : sclkout1;
		assign fast_enable2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			enable0 : enable1;
		stratixiigx_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( CLK0_MULTIPLY_FACTOR ),
			.clk0_divide_by( CLK0_DIVIDE_FACTOR ),
			.clk1_multiply_by( CLK1_MULTIPLY_FACTOR ),
			.clk1_divide_by( CLK1_DIVIDE_FACTOR ),
			.clk2_multiply_by( CLK2_MULTIPLY_FACTOR ),
			.clk2_divide_by( CLK2_DIVIDE_FACTOR ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( int2str( CLK0_PHASE_SHIFT ) ),
			.clk1_phase_shift( int2str( CLK1_PHASE_SHIFT ) ),
			.clk2_phase_shift( int2str( CLK2_PHASE_SHIFT ) ),
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
			.scanread( 1'b0 ),
			.scanwrite( 1'b0 ),
			.sclkout( { sclkout1, sclkout0 } ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);

		stratixiigx_lvds_transmitter # (
			.preemphasis_setting( 0 ),
			.vod_setting( 0 ),
			.differential_drive( 0 ),
			.channel_width( deserialization_factor ),
			.bypass_serializer( bypass_serializer ),
			.invert_clock( invert_clock ),
			.use_falling_clock_edge( use_falling_clock_edge )
		) tx_oclk (
			.clk0( fast_clock2 ),
			.enable0( fast_enable2 ),
			.serialdatain( `DEFAULT_ZERO ),
			.postdpaserialdatain( `DEFAULT_ZERO ),
			.datain( oclk_din ),
			.dataout( tx_outclock )) ;
	end
	else if( IS_FAMILY_ARRIAGX( intended_device_family ) ) begin
		assign tx_locked = locked;
		assign slow_clock = pll_outclock[0];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			sclkout0 : tx_inclock;
		assign fast_enable = ( use_external_pll == "OFF" ) ?
			enable0 : tx_enable;
		assign fast_clock2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			sclkout0 : sclkout1;
		assign fast_enable2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			enable0 : enable1;
		arriagx_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( CLK0_MULTIPLY_FACTOR ),
			.clk0_divide_by( CLK0_DIVIDE_FACTOR ),
			.clk1_multiply_by( CLK1_MULTIPLY_FACTOR ),
			.clk1_divide_by( CLK1_DIVIDE_FACTOR ),
			.clk2_multiply_by( CLK2_MULTIPLY_FACTOR ),
			.clk2_divide_by( CLK2_DIVIDE_FACTOR ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( int2str( CLK0_PHASE_SHIFT ) ),
			.clk1_phase_shift( int2str( CLK1_PHASE_SHIFT ) ),
			.clk2_phase_shift( int2str( CLK2_PHASE_SHIFT ) ),
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
			.scanread( 1'b0 ),
			.scanwrite( 1'b0 ),
			.sclkout( { sclkout1, sclkout0 } ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);

		arriagx_lvds_transmitter # (
			.preemphasis_setting( 0 ),
			.vod_setting( 0 ),
			.differential_drive( 0 ),
			.channel_width( deserialization_factor ),
			.bypass_serializer( bypass_serializer ),
			.invert_clock( invert_clock ),
			.use_falling_clock_edge( use_falling_clock_edge )
		) tx_oclk (
			.clk0( fast_clock2 ),
			.enable0( fast_enable2 ),
			.serialdatain( `DEFAULT_ZERO ),
			.postdpaserialdatain( `DEFAULT_ZERO ),
			.datain( oclk_din ),
			.dataout( tx_outclock )) ;
	end
	else if( IS_FAMILY_STRATIX( intended_device_family ) ) begin
		assign tx_locked = (pll_type == "fast" ) ? ~ locked : locked;
		assign slow_clock = pll_outclock[2];
		assign fast_clock = pll_outclock[0];
		assign fast_enable = enable1;
		assign fast_clock2 = pll_outclock[1];
		assign fast_enable2 = enable1;
		stratix_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( CLK0_MULTIPLY_FACTOR ),
			.clk0_divide_by( CLK0_DIVIDE_FACTOR ),
			.clk1_multiply_by( CLK1_MULTIPLY_FACTOR ),
			.clk1_divide_by( CLK1_DIVIDE_FACTOR ),
			.clk2_multiply_by( CLK2_MULTIPLY_FACTOR ),
			.clk2_divide_by( CLK2_DIVIDE_FACTOR ),
			.clk0_phase_shift( int2str( CLK0_PHASE_SHIFT ) ),
			.clk1_phase_shift( int2str( CLK1_PHASE_SHIFT ) ),
			.clk2_phase_shift( int2str( CLK2_PHASE_SHIFT ) ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, tx_inclock} ),
			.ena( tx_pll_enable ),
			.areset( pll_areset ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b1 ),
			.clkena( clk_ena ),
			.scanaclr( 1'b0 ),
			.comparator( `DEFAULT_ZERO ),
			.extclkena( ext_clk_ena ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);

		stratix_lvds_transmitter # (
			.channel_width( deserialization_factor ),
			.bypass_serializer( bypass_serializer ),
			.invert_clock( invert_clock ),
			.use_falling_clock_edge( use_falling_clock_edge )
		) tx_oclk (
			.clk0( fast_clock2 ),
			.enable0( fast_enable2 ),
			.datain( oclk_din ),
			.dataout( tx_outclock )) ;
	end
	else if( IS_FAMILY_STRATIXGX( intended_device_family ) ) begin
		assign tx_locked = (pll_type == "fast" ) ? ~ locked : locked;
		assign slow_clock = pll_outclock[2];
		assign fast_clock2 = pll_outclock[1];
		assign fast_enable2 = enable1;
		assign fast_clock = pll_outclock[0];
		assign fast_enable = enable1;

		stratixgx_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( CLK0_MULTIPLY_FACTOR ),
			.clk0_divide_by( CLK0_DIVIDE_FACTOR ),
			.clk1_multiply_by( CLK1_MULTIPLY_FACTOR ),
			.clk1_divide_by( CLK1_DIVIDE_FACTOR ),
			.clk2_multiply_by( CLK2_MULTIPLY_FACTOR ),
			.clk2_divide_by( CLK2_DIVIDE_FACTOR ),
			.clk0_phase_shift( int2str( CLK0_PHASE_SHIFT ) ),
			.clk1_phase_shift( int2str( CLK1_PHASE_SHIFT ) ),
			.clk2_phase_shift( int2str( CLK2_PHASE_SHIFT ) ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, tx_inclock} ),
			.ena( tx_pll_enable ),
			.areset( pll_areset ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b1 ),
			.clkena( clk_ena ),
			.scanaclr( 1'b0 ),
			.comparator( `DEFAULT_ZERO ),
			.extclkena( ext_clk_ena ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);

		stratixgx_lvds_transmitter # (
			.channel_width( deserialization_factor ),
			.bypass_serializer( bypass_serializer ),
			.invert_clock( invert_clock ),
			.use_falling_clock_edge( use_falling_clock_edge )
		) tx_oclk (
			.clk0( fast_clock2 ),
			.enable0( fast_enable2 ),
			.datain( oclk_din ),
			.dataout( tx_outclock )) ;
	end
	else if( IS_FAMILY_STRATIXIII( intended_device_family ) ) begin
		assign tx_locked = locked;
		assign slow_clock = pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : tx_inclock;
		assign fast_enable = ( use_external_pll == "OFF" ) ?
			pll_outclock[1] : tx_enable;
		assign fast_clock2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			pll_outclock[0] : pll_outclock[3];
		assign fast_enable2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			pll_outclock[1] : pll_outclock[4];
		dffep pll_lock_sync_ff (locked_reg, locked_wire, 1'b1, 1'b1, 1'b0, pll_areset);
		assign locked = locked_wire && locked_reg;
		
		stratixiii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( CLK0_MULTIPLY_FACTOR ),
			.clk0_divide_by( CLK0_DIVIDE_FACTOR ),
			.clk1_multiply_by( CLK1_MULTIPLY_FACTOR ),
			.clk1_divide_by( CLK1_DIVIDE_FACTOR ),
			.clk2_multiply_by( CLK2_MULTIPLY_FACTOR ),
			.clk2_divide_by( CLK2_DIVIDE_FACTOR ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( int2str( CLK0_PHASE_SHIFT ) ),
			.clk1_phase_shift( int2str( CLK1_PHASE_SHIFT ) ),
			.clk2_phase_shift( int2str( CLK2_PHASE_SHIFT ) ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, tx_inclock} ),
			.areset( pll_areset ),
			.fbin( feedback ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b0 ),
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.scanclkena( 1'b1 ),
			.clk ( pll_outclock ),
			.configupdate( 1'b0 ),
			.locked( locked_wire ),
			.fbout ( feedback )
		);

		stratixiii_lvds_transmitter # (
			.preemphasis_setting( 0 ),
			.vod_setting( 0 ),
			.differential_drive( 0 ),
			.channel_width( deserialization_factor ),
			.bypass_serializer( bypass_serializer ),
			.invert_clock( invert_clock ),
			.use_falling_clock_edge( use_falling_clock_edge )
		) tx_oclk (
			.clk0( fast_clock2 ),
			.enable0( fast_enable2 ),
			.serialdatain( `DEFAULT_ZERO ),
			.postdpaserialdatain( `DEFAULT_ZERO ),
			.dpaclkin( 1'b0 ),
			.datain( oclk_din ),
			.dataout( tx_outclock )) ;
	end
	else if( IS_FAMILY_STRATIXIV( intended_device_family ) ) begin
		assign tx_locked = locked;
		assign slow_clock = pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : tx_inclock;
		assign fast_enable = ( use_external_pll == "OFF" ) ?
			pll_outclock[1] : tx_enable;
		assign fast_clock2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			pll_outclock[0] : pll_outclock[3];
		assign fast_enable2 = ( STXII_PHASE_OUTCLOCK == STXII_PHASE_INCLOCK ) ?
			pll_outclock[1] : pll_outclock[4];
		dffep pll_lock_sync_ff (locked_reg, locked_wire, 1'b1, 1'b1, 1'b0, pll_areset);
		assign locked = locked_wire && locked_reg;
		
		stratixiv_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( CLK0_MULTIPLY_FACTOR ),
			.clk0_divide_by( CLK0_DIVIDE_FACTOR ),
			.clk1_multiply_by( CLK1_MULTIPLY_FACTOR ),
			.clk1_divide_by( CLK1_DIVIDE_FACTOR ),
			.clk2_multiply_by( CLK2_MULTIPLY_FACTOR ),
			.clk2_divide_by( CLK2_DIVIDE_FACTOR ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_INCLOCK ),
			.sclkout1_phase_shift( STXII_PHASE_OUTCLOCK ),
			.clk0_phase_shift( int2str( CLK0_PHASE_SHIFT ) ),
			.clk1_phase_shift( int2str( CLK1_PHASE_SHIFT ) ),
			.clk2_phase_shift( int2str( CLK2_PHASE_SHIFT ) ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, tx_inclock} ),
			.areset( pll_areset ),
			.fbin( feedback ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b0 ),
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.scanclkena( 1'b1 ),
			.clk ( pll_outclock ),
			.configupdate( 1'b0 ),
			.locked( locked_wire ),
			.fbout ( feedback )
		);

		stratixiv_lvds_transmitter # (
			.preemphasis_setting( 0 ),
			.vod_setting( 0 ),
			.differential_drive( 0 ),
			.channel_width( deserialization_factor ),
			.bypass_serializer( bypass_serializer ),
			.invert_clock( invert_clock ),
			.use_falling_clock_edge( use_falling_clock_edge )
		) tx_oclk (
			.clk0( fast_clock2 ),
			.enable0( fast_enable2 ),
			.serialdatain( `DEFAULT_ZERO ),
			.postdpaserialdatain( `DEFAULT_ZERO ),
			.dpaclkin( 1'b0 ),
			.datain( oclk_din ),
			.dataout( tx_outclock )) ;
	end
	for( i = 0 ; i < number_of_channels ; i = i + 1 ) begin : channel
		if( IS_FAMILY_STRATIXII( intended_device_family ) ) begin
			stratixii_lvds_transmitter # (
				.preemphasis_setting( 0 ),
				.vod_setting( 0 ),
				.differential_drive( 0 ),
				.channel_width( deserialization_factor ),
				.bypass_serializer( "false" ),
				.invert_clock( "false" ),
				.use_falling_clock_edge( "false" )
			) tx (
				.clk0( fast_clock ),
				.enable0( fast_enable ),
				.serialdatain ( `DEFAULT_ZERO ),
				.postdpaserialdatain( `DEFAULT_ZERO ),
				.datain( tx_in_regd[ deserialization_factor * ( i + 1 ) - 1 -:
					deserialization_factor ] ),
				.dataout( tx_out[i] ));
		end
		else if( IS_FAMILY_STRATIXIII( intended_device_family ) ) begin
			stratixiii_lvds_transmitter # (
				.preemphasis_setting( 0 ),
				.vod_setting( 0 ),
				.differential_drive( 0 ),
				.channel_width( deserialization_factor ),
				.bypass_serializer( "false" ),
				.invert_clock( "false" ),
				.use_falling_clock_edge( "false" )
			) tx (
				.clk0( fast_clock ),
				.enable0( fast_enable ),
				.dpaclkin( 1'b0 ),
				.serialdatain ( `DEFAULT_ZERO ),
				.postdpaserialdatain( `DEFAULT_ZERO ),
				.datain( tx_in_regd[ deserialization_factor * ( i + 1 ) - 1 -:
					deserialization_factor ] ),
				.dataout( tx_out[i] ));
		end
		else if( IS_FAMILY_STRATIXIV( intended_device_family ) ) begin
			stratixiv_lvds_transmitter # (
				.preemphasis_setting( 0 ),
				.vod_setting( 0 ),
				.differential_drive( 0 ),
				.channel_width( deserialization_factor ),
				.bypass_serializer( "false" ),
				.invert_clock( "false" ),
				.use_falling_clock_edge( "false" )
			) tx (
				.clk0( fast_clock ),
				.enable0( fast_enable ),
				.dpaclkin( 1'b0 ),
				.serialdatain ( `DEFAULT_ZERO ),
				.postdpaserialdatain( `DEFAULT_ZERO ),
				.datain( tx_in_regd[ deserialization_factor * ( i + 1 ) - 1 -:
					deserialization_factor ] ),
				.dataout( tx_out[i] ));
		end
		else if( IS_FAMILY_STRATIXIIGX( intended_device_family ) ) begin
			stratixiigx_lvds_transmitter # (
				.preemphasis_setting( 0 ),
				.vod_setting( 0 ),
				.differential_drive( 0 ),
				.channel_width( deserialization_factor ),
				.bypass_serializer( "false" ),
				.invert_clock( "false" ),
				.use_falling_clock_edge( "false" )
			) tx (
				.clk0( fast_clock ),
				.enable0( fast_enable ),
				.serialdatain ( `DEFAULT_ZERO ),
				.postdpaserialdatain( `DEFAULT_ZERO ),
				.datain( tx_in_regd[ deserialization_factor * ( i + 1 ) - 1 -:
					deserialization_factor ] ),
				.dataout( tx_out[i] ));
		end
		else if( IS_FAMILY_ARRIAGX( intended_device_family ) ) begin
			arriagx_lvds_transmitter # (
				.preemphasis_setting( 0 ),
				.vod_setting( 0 ),
				.differential_drive( 0 ),
				.channel_width( deserialization_factor ),
				.bypass_serializer( "false" ),
				.invert_clock( "false" ),
				.use_falling_clock_edge( "false" )
			) tx (
				.clk0( fast_clock ),
				.enable0( fast_enable ),
				.serialdatain ( `DEFAULT_ZERO ),
				.postdpaserialdatain( `DEFAULT_ZERO ),
				.datain( tx_in_regd[ deserialization_factor * ( i + 1 ) - 1 -:
					deserialization_factor ] ),
				.dataout( tx_out[i] ));
		end
		else if( IS_FAMILY_STRATIX( intended_device_family ) ) begin
			stratix_lvds_transmitter # (
				.channel_width( deserialization_factor ),
				.bypass_serializer( "false" ),
				.invert_clock( "false" ),
				.use_falling_clock_edge( "false" )
			) tx (
				.clk0( fast_clock ),
				.enable0( fast_enable ),
				.datain( tx_in_regd[ deserialization_factor * ( i + 1 ) - 1 -:
					deserialization_factor ] ),
				.dataout( tx_out[i] ));
		end
		else if( IS_FAMILY_STRATIXGX( intended_device_family ) ) begin
			stratixgx_lvds_transmitter # (
				.channel_width( deserialization_factor ),
				.bypass_serializer( "false" ),
				.invert_clock( "false" ),
				.use_falling_clock_edge( "false" )
			) tx (
				.clk0( fast_clock ),
				.enable0( fast_enable ),
				.datain( tx_in_regd[ deserialization_factor * ( i + 1 ) - 1 -:
					deserialization_factor ] ),
				.dataout( tx_out[i] ));
		end
	end

	if( registered_input == "TX_CLKIN" ) begin
		dffep tx_in_ff[ width_des_channels_ - 1 : 0 ] (
			.q( tx_in_regd ),
			.ck( tx_inclock ),
			.en( 1'b1 ),
			.d( tx_in ),
			.s( 1'b0 ),
			.r( 1'b0 )
		);
	end
	else if( registered_input == "TX_CORECLK" ||
		( registered_input == "ON" ) ) begin
		dffep tx_in_ff[ width_des_channels_ - 1 : 0 ] (
			.q( tx_in_regd ),
			.ck( slow_clock ),
			.en( 1'b1 ),
			.d( tx_in ),
			.s( 1'b0 ),
			.r( 1'b0 )
		);
	end
	else begin
		assign tx_in_regd = tx_in;
	end

	if( outclock_divide_by == 1 ) begin
		assign oclk_din = TXDATA_FROM_PHASE_SHIFT_X_1;
	end
	else if( outclock_divide_by == 2 ) begin
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
	endgenerate
endmodule
