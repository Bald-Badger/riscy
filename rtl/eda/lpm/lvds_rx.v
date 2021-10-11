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
module lvds_rx (
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
	parameter intended_device_family = "APEX20KE";
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
	parameter lose_lock_on_one_change ="OFF" ;
	parameter reset_fifo_at_first_lock ="ON" ;

	parameter enable_dpa_mode = "OFF";
	parameter use_external_pll = "OFF";
	parameter lpm_hint = "UNUSED";
	parameter lpm_type = "altlvds_rx";

   parameter clk_src_is_pll = "off";

   parameter port_rx_data_align = "PORT_CONNECTIVITY";
	parameter x_on_bitslip = "on";

	parameter buffer_implementation = "RAM";
	parameter enable_soft_cdr_mode = "OFF"; 	
	parameter inclock_phase_shift = 0;	


   parameter STRATIX_INCLOCK_BOOST = ((input_data_rate !=0) && (inclock_period !=0))
		  ? (((input_data_rate * inclock_period) + (5 * 100000)) / 1000000) :
		 ((inclock_boost == 0) ? deserialization_factor : inclock_boost);


   parameter PHASE_SHIFT = (inclock_data_alignment == "EDGE_ALIGNED")? 0:
		(inclock_data_alignment == "CENTER_ALIGNED")? (0.5 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5 :
		(inclock_data_alignment == "45_DEGREES")? (0.125 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5 :
		(inclock_data_alignment == "90_DEGREES")? (0.25 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5 :
		(inclock_data_alignment == "135_DEGREES")? (0.375 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5 :
		(inclock_data_alignment == "180_DEGREES")? (0.5 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5 :
		(inclock_data_alignment == "225_DEGREES")? (0.625 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5 :
		(inclock_data_alignment == "270_DEGREES")? (0.75 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5 :
		(inclock_data_alignment == "315_DEGREES")? (0.875 * inclock_period / STRATIX_INCLOCK_BOOST) + 0.5 : 0;
	parameter CLOCK_PERIOD = (deserialization_factor > 2) ? inclock_period :
		10000;
	parameter STXII_PHASE_SHIFT = PHASE_SHIFT -
		(0.5 * inclock_period / STRATIX_INCLOCK_BOOST);

    parameter width_des_channels_ = deserialization_factor*number_of_channels;

	localparam pll_type = "fast";
	localparam dpaswitch = (enable_dpa_mode == "ON")? 1'b1 : 1'b0;

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
	 

	wire [ width_des_channels_ - 1 : 0 ] rx_out_regd;
	wire [5:0] pll_outclock;
	wire [ deserialization_factor - 1 : 0 ] oclk_din;
    wire [width_des_channels_ -1: 0] rx_out_int;
	wire locked;
	wire [5:0] clk_ena;
	wire [3:0] ext_clk_ena;
	wire rx_data_align_regd;
    wire fast_clock;
    wire slow_clock;
	wire rxenable1;
	wire rxenable0;
	wire enable0;
	wire enable1;
	wire sclkout0;
	wire sclkout1;
	wire feedback;
	wire locked_wire, locked_reg;

`include "altera_mf_macros.i"

	generate
	if( port_rx_data_align == "PORT_UNUSED" ) begin
		assign rxenable1 = 1'b0;
	end
	else if( port_rx_data_align == "PORT_USED" ) begin
		assign rxenable1 = enable1;
	end
	else begin
`ifdef LVDS_RX_DATA_ALIGN_MODE
		assign rxenable1 = enable1;
`else
		assign rxenable1 = 1'b0;
`endif
	end
	endgenerate

	assign rx_outclock = slow_clock;
	assign clk_ena = 6'b111111;
	assign ext_clk_ena = 4'b1111;

	generate
	wire rxclk;
	genvar i;

	if( IS_FAMILY_STRATIXII( intended_device_family ) ) begin
		assign rx_locked = locked;
		assign slow_clock = pll_outclock[0];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			sclkout0 : rx_inclock;
		assign rxclk = slow_clock;

		stratixii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b0 ),
			.scanread( 1'b0 ),
			.scanwrite( 1'b0 ),
			.sclkout( {sclkout1, sclkout0 } ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);
	end
	else if( IS_FAMILY_STRATIXIIGX( intended_device_family ) ) begin
		assign rx_locked = locked;
		assign slow_clock = pll_outclock[0];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			sclkout0 : rx_inclock;
		assign rxclk = slow_clock;

		stratixiigx_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b0 ),
			.scanread( 1'b0 ),
			.scanwrite( 1'b0 ),
			.sclkout( {sclkout1, sclkout0 } ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);
	end
	else if( IS_FAMILY_ARRIAGX( intended_device_family ) ) begin
		assign rx_locked = locked;
		assign slow_clock = pll_outclock[0];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			sclkout0 : rx_inclock;
		assign rxclk = slow_clock;

		arriagx_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b0 ),
			.scanread( 1'b0 ),
			.scanwrite( 1'b0 ),
			.sclkout( {sclkout1, sclkout0 } ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);
	end
	else if( IS_FAMILY_STRATIX( intended_device_family ) ) begin
		assign rx_locked = (pll_type == "fast" ) ? ~ locked : locked;
		assign slow_clock = pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;
		assign rxclk = slow_clock;

		if( registered_data_align_input == "ON" ) begin
			dffep data_align_ff (
				.q( rx_data_align_regd ),
				.ck( slow_clock ),
				.en( 1'b1 ),
				.d( rx_data_align ),
				.s( 1'b0 ),
				.r( 1'b0 )
			);
		end
		else begin
			assign rx_data_align_regd = 1'b0;
		end

		stratix_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b1 ),
			.scanaclr( 1'b0 ),
			.comparator( rx_data_align_regd ),
			.clkena( clk_ena ),
			.extclkena( ext_clk_ena ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);
	end
	else if( IS_FAMILY_STRATIXGX( intended_device_family ) ) begin
		assign rx_locked = (pll_type == "fast" ) ? ~ locked : locked;
		assign slow_clock = pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;

		if( use_coreclock_input == "ON" ) begin
			assign rxclk = rx_coreclk;
		end
		else begin
			assign rxclk = slow_clock;
		end

		if( registered_data_align_input == "ON" ) begin
			dffep data_align_ff (
				.q( rx_data_align_regd ),
				.ck( slow_clock ),
				.en( 1'b1 ),
				.d( rx_data_align ),
				.s( 1'b0 ),
				.r( 1'b0 )
			);
		end
		else begin
			assign rx_data_align_regd = 1'b0;
		end

		stratixgx_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b1 ),
			.scanaclr( 1'b0 ),
			.comparator( rx_data_align_regd ),
			.clkena( clk_ena ),
			.extclkena( ext_clk_ena ),
			.clk ( pll_outclock ),
			.enable0( enable0 ),
			.enable1( enable1 ),
			.locked( locked )
		);
	end
	else if( IS_FAMILY_STRATIXIII(intended_device_family) ) begin
		assign rx_locked = locked;
		assign slow_clock = pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;
		assign rxclk = slow_clock;
		assign rxenable0 = pll_outclock[1];
		dffep pll_lock_sync_ff (locked_reg, locked_wire, 1'b1, 1'b1, 1'b0, pll_areset);
		assign locked = locked_wire && locked_reg;

		stratixiii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.areset( pll_areset ),
			.fbin( feedback ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scanclkena( 1'b1 ),
			.scandata( 1'b0 ),
			.configupdate( 1'b0 ),
			.clk ( pll_outclock ),
			.locked( locked_wire ),
			.fbout( feedback )
		);
	end
	else if( IS_FAMILY_STRATIXIV(intended_device_family) ) begin
		assign rx_locked = locked;
		assign slow_clock = pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;
		assign rxclk = slow_clock;
		assign rxenable0 = pll_outclock[1];
		dffep pll_lock_sync_ff (locked_reg, locked_wire, 1'b1, 1'b1, 1'b0, pll_areset);
		assign locked = locked_wire && locked_reg;

		stratixiv_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( pll_type ),
			.vco_multiply_by( STRATIX_INCLOCK_BOOST ),
			.vco_divide_by( 1 ),
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.inclk0_input_frequency( CLOCK_PERIOD ),
			.clk0_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk0_divide_by( deserialization_factor ),
			.clk1_multiply_by( STRATIX_INCLOCK_BOOST ),
			.clk1_divide_by( deserialization_factor ),
			.clk2_multiply_by( 1 ),
			.clk2_divide_by( 1 ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.areset( pll_areset ),
			.fbin( feedback ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scanclkena( 1'b1 ),
			.scandata( 1'b0 ),
			.configupdate( 1'b0 ),
			.clk ( pll_outclock ),
			.locked( locked_wire ),
			.fbout( feedback )
		);
	end

	for( i = 0 ; i < number_of_channels ; i = i + 1 ) begin : channel
		wire bit_slip;
		wire fifo_reset;
		wire rxreset;
		wire rxdpllreset;
		wire rxdpahold;
		wire core_clk;

		if( IS_FAMILY_STRATIXII( intended_device_family ) ) begin
			assign bit_slip = rx_channel_data_align[i];

			if( enable_dpa_mode == "ON" ) begin
				assign rxreset = rx_reset[i];
				assign rxdpahold = rx_dpll_hold[i];
				assign fifo_reset = rx_fifo_reset[i];
			end
			else begin
				assign rxreset = `DEFAULT_ZERO;
				assign rxdpahold = `DEFAULT_ZERO;
				assign fifo_reset = 1'b0;
			end

			stratixii_lvds_receiver #(
				.channel_width( deserialization_factor ),
				.x_on_bitslip( x_on_bitslip )
			) rx (
				.dpareset( rxreset ),
				.dpahold( rxdpahold ),
				.dpaswitch( dpaswitch ),
				.fiforeset( fifo_reset ),
				.bitslip( bit_slip ),
				.bitslipreset( rx_cda_reset[i] ),
				.dpalock( rx_dpa_locked[i] ),
				.bitslipmax( rx_cda_max[i] ),
				.clk0( fast_clock ),
				.enable0( enable0 ),
				.serialfbk( `DEFAULT_ZERO ),
				.datain( rx_in[i] ),
				.dataout( rx_out_int[ deserialization_factor*(i+1) - 1 :
					deserialization_factor*i ] ) );
		end
		else if( IS_FAMILY_STRATIXIII( intended_device_family ) ) begin
			assign bit_slip = rx_channel_data_align[i];

			if( enable_dpa_mode == "ON" ) begin
				assign rxreset = rx_reset[i];
				assign rxdpahold = rx_dpll_hold[i];
				assign fifo_reset = rx_fifo_reset[i];
			end
			else begin
				assign rxreset = `DEFAULT_ZERO;
				assign rxdpahold = `DEFAULT_ZERO;
				assign fifo_reset = 1'b0;
			end

			stratixiii_lvds_receiver #(
				.channel_width( deserialization_factor ),
				.x_on_bitslip( x_on_bitslip )
			) rx (
				.dpareset( rxreset ),
				.dpahold( rxdpahold ),
				.dpaswitch( dpaswitch ),
				.fiforeset( fifo_reset ),
				.bitslip( bit_slip ),
				.bitslipreset( rx_cda_reset[i] ),
				.dpalock( rx_dpa_locked[i] ),
				.bitslipmax( rx_cda_max[i] ),
				.clk0( fast_clock ),
				.enable0( rxenable0 ),
				.serialfbk( `DEFAULT_ZERO ),
				.datain( rx_in[i] ),
				.dataout( rx_out_int[ deserialization_factor*(i+1) - 1 :
					deserialization_factor*i ] ) );
		end
		else if( IS_FAMILY_STRATIXIV( intended_device_family ) ) begin
			assign bit_slip = rx_channel_data_align[i];

			if( enable_dpa_mode == "ON" ) begin
				assign rxreset = rx_reset[i];
				assign rxdpahold = rx_dpll_hold[i];
				assign fifo_reset = rx_fifo_reset[i];
			end
			else begin
				assign rxreset = `DEFAULT_ZERO;
				assign rxdpahold = `DEFAULT_ZERO;
				assign fifo_reset = 1'b0;
			end

			stratixiv_lvds_receiver #(
				.channel_width( deserialization_factor ),
				.x_on_bitslip( x_on_bitslip )
			) rx (
				.dpareset( rxreset ),
				.dpahold( rxdpahold ),
				.dpaswitch( dpaswitch ),
				.fiforeset( fifo_reset ),
				.bitslip( bit_slip ),
				.bitslipreset( rx_cda_reset[i] ),
				.dpalock( rx_dpa_locked[i] ),
				.bitslipmax( rx_cda_max[i] ),
				.clk0( fast_clock ),
				.enable0( rxenable0 ),
				.serialfbk( `DEFAULT_ZERO ),
				.datain( rx_in[i] ),
				.dataout( rx_out_int[ deserialization_factor*(i+1) - 1 :
					deserialization_factor*i ] ) );
		end
		else if( IS_FAMILY_STRATIXIIGX( intended_device_family ) ) begin
			assign bit_slip = rx_channel_data_align[i];

			if( enable_dpa_mode == "ON" ) begin
				assign rxreset = rx_reset[i];
				assign rxdpahold = rx_dpll_hold[i];
				assign fifo_reset = rx_fifo_reset[i];
			end
			else begin
				assign rxreset = `DEFAULT_ZERO;
				assign rxdpahold = `DEFAULT_ZERO;
				assign fifo_reset = 1'b0;
			end

			stratixiigx_lvds_receiver #(
				.channel_width( deserialization_factor ),
				.x_on_bitslip( x_on_bitslip )
			) rx (
				.dpareset( rxreset ),
				.dpahold( rxdpahold ),
				.dpaswitch( dpaswitch ),
				.fiforeset( fifo_reset ),
				.bitslip( bit_slip ),
				.bitslipreset( rx_cda_reset[i] ),
				.dpalock( rx_dpa_locked[i] ),
				.bitslipmax( rx_cda_max[i] ),
				.clk0( fast_clock ),
				.enable0( enable0 ),
				.serialfbk( `DEFAULT_ZERO ),
				.datain( rx_in[i] ),
				.dataout( rx_out_int[ deserialization_factor*(i+1) - 1 :
					deserialization_factor*i ] ) );
		end
		else if( IS_FAMILY_ARRIAGX( intended_device_family ) ) begin
			assign bit_slip = rx_channel_data_align[i];

			if( enable_dpa_mode == "ON" ) begin
				assign rxreset = rx_reset[i];
				assign rxdpahold = rx_dpll_hold[i];
				assign fifo_reset = rx_fifo_reset[i];
			end
			else begin
				assign rxreset = `DEFAULT_ZERO;
				assign rxdpahold = `DEFAULT_ZERO;
				assign fifo_reset = 1'b0;
			end

			arriagx_lvds_receiver #(
				.channel_width( deserialization_factor ),
				.x_on_bitslip( x_on_bitslip )
			) rx (
				.dpareset( rxreset ),
				.dpahold( rxdpahold ),
				.dpaswitch( dpaswitch ),
				.fiforeset( fifo_reset ),
				.bitslip( bit_slip ),
				.bitslipreset( rx_cda_reset[i] ),
				.dpalock( rx_dpa_locked[i] ),
				.bitslipmax( rx_cda_max[i] ),
				.clk0( fast_clock ),
				.enable0( enable0 ),
				.serialfbk( `DEFAULT_ZERO ),
				.datain( rx_in[i] ),
				.dataout( rx_out_int[ deserialization_factor*(i+1) - 1 :
					deserialization_factor*i ] ) );
		end
		else if( IS_FAMILY_STRATIX( intended_device_family ) ) begin
			assign bit_slip = rx_data_align_regd;

			stratix_lvds_receiver #(
				.channel_width( deserialization_factor )
			) rx (
				.enable1( rxenable1 ),
				.clk0( fast_clock ),
				.enable0( enable0 ),
				.datain( rx_in[i] ),
				.dataout( rx_out_int[ deserialization_factor*(i+1) - 1 :
					deserialization_factor*i ] ) );
		end
		else if( IS_FAMILY_STRATIXGX( intended_device_family ) ) begin
			if( enable_dpa_mode == "ON" ) begin
				assign rxreset = rx_reset[i];
				assign rxdpllreset = rx_dpll_reset[i];
				assign bit_slip = rx_channel_data_align[i];
				if( use_coreclock_input == "ON" ) begin
					assign core_clk = rx_coreclk[i];
				end
				else begin
					assign core_clk = slow_clock;
				end
			end
			else begin
				assign rxreset = 1'b0;
				assign rxdpllreset = 1'b0;
				assign bit_slip = 1'b0;
				assign core_clk = `DEFAULT_ZERO;
			end

			stratixgx_lvds_receiver #(
				.channel_width( deserialization_factor )
			) rx (
				.dpareset( rxreset ),
				.dpllreset( rxdpllreset ),
				.bitslip( bit_slip ),
				.coreclk( core_clk ),
				.enable1( rxenable1 ),
				.clk0( fast_clock ),
				.enable0( enable0 ),
				.datain( rx_in[i] ),
				.dataout( rx_out_int[ deserialization_factor*(i+1) - 1 :
					deserialization_factor*i ] ) );
		end
	end

	if( registered_output == "ON" ) begin
		dffep rx_out_ff[ width_des_channels_ - 1 : 0 ] (
			.q( rx_out_regd[ width_des_channels_ - 1 : 0 ] ),
			.ck( rxclk ),
			.en( 1'b1 ),
			.d( rx_out_int[ width_des_channels_ - 1 : 0 ] ),
			.s( 1'b0 ),
			.r( 1'b0 )
		);
		assign rx_out = rx_out_regd;
	end
	else begin
		assign rx_out = rx_out_int;
	end
	endgenerate
endmodule
