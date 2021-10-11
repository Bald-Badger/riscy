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

module flvds_rx (
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
	parameter pll_self_reset_on_loss_lock = "OFF";

	parameter enable_dpa_mode = "OFF";
	parameter use_external_pll = "OFF";
	parameter lpm_hint = "UNUSED";
	parameter lpm_type = "altlvds_rx";

    parameter clk_src_is_pll = "off";
    parameter port_rx_data_align = "PORT_CONNECTIVITY";
    parameter port_rx_channel_data_align = "PORT_CONNECTIVITY";

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

	localparam shiftreg_size = ( deserialization_factor % 2 ) ?
		deserialization_factor : deserialization_factor / 2;

	localparam use_fifo_data_sync = "ON";
	localparam lg_deser_factor = (deserialization_factor <=2)? 1 : (
				(deserialization_factor <=4)? 2 : (
				(deserialization_factor <=8)? 3 : (
				(deserialization_factor <=16)? 4 : deserialization_factor
				)));

    localparam PLL_D_VALUE = ((input_data_rate !=0) && (inclock_period !=0))? 2 : 1;

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
	 input rx_syncclock;   
	 output [width_des_channels_ -1: 0] rx_out;
    output rx_outclock;
    output rx_locked;
    output [number_of_channels -1: 0] rx_dpa_locked;
    output [number_of_channels -1: 0] rx_cda_max;

	wire [5:0] pll_outclock;
	wire [ deserialization_factor - 1 : 0 ] oclk_din;
    wire [width_des_channels_ -1: 0] rx_out_int;
	wire locked;
	wire [5:0] clk_ena;
	wire [3:0] ext_clk_ena;
    wire [width_des_channels_ * 2 - 1: 0] rx_in_il_ch;
    wire [width_des_channels_ * 2 - 1: 0] rx_in_il_ch_regd;
	wire fast_clock;
	wire read_clock;
	wire slow_clock;
	wire sync_clock;
	wire wrcnt_bit0_cout;
	wire enable0;
	wire enable1;
	wire sclkout0;
	wire sclkout1;
   wire [width_des_channels_ -1: 0] rx_shift_reg;
   wire [width_des_channels_ -1: 0] rx_shift_reg1;
   wire [width_des_channels_ -1: 0] rx_shift_reg2;
   wire [width_des_channels_ -1: 0] l_int_reg;
   wire [width_des_channels_ -1: 0] h_int_reg;
   wire feedback;
   wire [number_of_channels -1 :0] rx_in_l;
   wire [number_of_channels -1 :0] rx_in_h;
   wire [number_of_channels -1 :0] rx_in_l_int;
   wire [number_of_channels -1 :0] rx_in_h_int;
   wire bit_slip_regd;
   wire rx_data_align_regd;
   wire bit_slip_int;
   wire [ lg_deser_factor - 1 : 0 ] bit_slip_count_int;

	assign clk_ena = 6'b111111;
	assign ext_clk_ena = 4'b1111;
	assign rx_outclock = read_clock;

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

		assign rx_locked = locked & pll_lock_sync_q;
	end
	else begin
		assign rx_locked = locked;
	end


	if( IS_FAMILY_STRATIXII( intended_device_family ) ) begin
		assign read_clock = ( deserialization_factor % 2 == 0 ) ?
			pll_outclock[0] : pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;

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
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.sclkout( { sclkout1, sclkout0 } ),
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
	else if( IS_FAMILY_STRATIXIII( intended_device_family )) begin
		assign read_clock = ( deserialization_factor % 2 == 0 ) ?
			pll_outclock[1] : pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;

		stratixiii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
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
			.m( 0 ), 
			.inclk1_input_frequency( CLOCK_PERIOD ),
			.operation_mode( "normal" )			
		) pll (
			.areset( pll_areset ),
 			.clkswitch( 1'b0 ),
			.configupdate( 1'b0 ),
			.fbin( feedback ),
			.inclk( {1'b0, rx_inclock} ),
			.pfdena( 1'b1 ),
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.scanclk( 1'b0 ),
			.scanclkena( 1'b1 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock[4:0] ),
			.fbout( feedback ),
			.locked( locked ),
			.phasecounterselect( {1'b0, 1'b0, 1'b0, 1'b0} )
		);
	end
	else if( IS_FAMILY_STRATIXIV( intended_device_family )) begin
		assign read_clock = ( deserialization_factor % 2 == 0 ) ?
			pll_outclock[1] : pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;

		stratixiv_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
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
			.m( 0 ), 
			.inclk1_input_frequency( CLOCK_PERIOD ),
			.operation_mode( "normal" )			
		) pll (
			.areset( pll_areset ),
 			.clkswitch( 1'b0 ),
			.configupdate( 1'b0 ),
			.fbin( feedback ),
			.inclk( {1'b0, rx_inclock} ),
			.pfdena( 1'b1 ),
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.scanclk( 1'b0 ),
			.scanclkena( 1'b1 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock[4:0] ),
			.fbout( feedback ),
			.locked( locked ),
			.phasecounterselect( {1'b0, 1'b0, 1'b0, 1'b0} )
		);
	end
	else if( IS_FAMILY_STRATIX( intended_device_family ) ) begin
		assign read_clock = ( deserialization_factor % 2 == 0 ) ?
			pll_outclock[0] : pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;

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
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.clkena( clk_ena ),
			.extclkena( ext_clk_ena ),
			.scanaclr( 1'b0 ),
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
	else if( IS_FAMILY_STRATIXGX( intended_device_family ) ) begin
		assign read_clock = ( deserialization_factor % 2 == 0 ) ?
			pll_outclock[0] : pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;

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
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.clkena( clk_ena ),
			.extclkena( ext_clk_ena ),
			.scanaclr( 1'b0 ),
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
	else if( FEATURE_FAMILY_CYCLONEIII( intended_device_family )) begin
		assign read_clock = ( deserialization_factor % 2 == 0 ) ?
			pll_outclock[1] : pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;

		cycloneiii_pll #(
			.primary_clock( "inclk0" ),
			.pll_type( "fast" ),
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
			.m( 0 ), 
			.inclk1_input_frequency( CLOCK_PERIOD ),
			.operation_mode( "normal" )			
		) pll (
			.areset( pll_areset ),
 			.clkswitch( 1'b0 ),
			.configupdate( 1'b0 ),
			.fbin( feedback ),
			.inclk( {1'b0, rx_inclock} ),
			.pfdena( 1'b1 ),
			.phasestep( 1'b0 ),
			.phaseupdown( 1'b0 ),
			.scanclk( 1'b0 ),
			.scanclkena( 1'b1 ),
			.scandata( 1'b0 ),
			.clk( pll_outclock[4:0] ),
			.fbout( feedback ),
			.locked( locked ),
			.phasecounterselect( {1'b0, 1'b0, 1'b0} )
		);
	end
	else if( IS_FAMILY_CYCLONEII( intended_device_family )) begin
		assign read_clock = ( deserialization_factor % 2 == 0 ) ?
			pll_outclock[1] : pll_outclock[2];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;

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
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 ),
			.inclk1_input_frequency( CLOCK_PERIOD ),
			.operation_mode( "normal" )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.clk( pll_outclock[2:0] ),
			.locked( locked ),
			.sbdin( 1'b0 ),
			.testclearlock( 1'b0 )
		);
	end
	else if( IS_FAMILY_CYCLONE( intended_device_family ) ) begin
		assign read_clock = pll_outclock[1];
		assign fast_clock = ( use_external_pll == "OFF" ) ?
			pll_outclock[0] : rx_inclock;

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
			.sclkout0_phase_shift( STXII_PHASE_SHIFT ),
			.clk0_phase_shift( STXII_PHASE_SHIFT ),
			.clk2_phase_shift( STXII_PHASE_SHIFT ),
			.m( 0 )
		) pll (
			.inclk( {1'b0, rx_inclock} ), 
			.ena( rx_pll_enable ),
			.areset( pll_areset ),
			.clkena( clk_ena ),
			.extclkena( ext_clk_ena ),
			.scanaclr( 1'b0 ),
			.fbin( 1'b1 ),
			.clkswitch( 1'b0 ),
			.pfdena( 1'b1 ),
			.scanclk( 1'b0 ),
			.scandata( 1'b0 ),
			.comparator( `DEFAULT_ZERO ), 
			.clk( pll_outclock ),
			.locked( locked ),
			.enable0( enable0 ),
			.enable1( enable1 )
		);
	end

	localparam ADD_LATENCY = FEATURE_FAMILY_CYCLONE( intended_device_family ) || FEATURE_FAMILY_CYCLONEII( intended_device_family ); 
	localparam LATENCY = (deserialization_factor % 2 == 1) ? (deserialization_factor / 2 + 1) : (deserialization_factor / 2);
	localparam NUM_OF_SYNC_STAGES = 
	((deserialization_factor == 4 && (ADD_LATENCY == 1)) ? 1 : (LATENCY - 3) + ((ADD_LATENCY == 0) ? 1 : 0) );

	if (NUM_OF_SYNC_STAGES > 0) begin
		pipeline_internal_fv #(number_of_channels,NUM_OF_SYNC_STAGES) l_dffpipe (
		.clk(fast_clock),
		.ena(1'b1),
		.clr(pll_areset),
		.d(rx_in_h_int),
		.piped(rx_in_h));

		pipeline_internal_fv #(number_of_channels,NUM_OF_SYNC_STAGES) h_dffpipe (
		.clk(fast_clock),
		.ena(1'b1),
		.clr(pll_areset),
		.d(rx_in_l_int),
		.piped(rx_in_l));
	end
	else begin
		assign rx_in_h = rx_in_h_int;
		assign rx_in_l = rx_in_l_int;
	end

	if( port_rx_data_align == "PORT_USED" )  begin
		if( registered_data_align_input == "ON" && use_external_pll == "OFF" ) begin
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
			assign rx_data_align_regd = rx_data_align;
		end
		dffep bitslip_ff (
			.q( bit_slip_regd ),
			.ck( fast_clock ),
			.en( 1'b1 ),
			.d( rx_data_align_regd ),
			.s( 1'b0 ),
			.r( 1'b0 )
		);
		assign bit_slip_int = ~bit_slip_regd & rx_data_align_regd;

		lpm_counter #(
			.lpm_width( lg_deser_factor ),
			.lpm_modulus( deserialization_factor ),
			.lpm_direction( "UP" ),
			.lpm_port_updown( "PORT_UNUSED" )
		) bitslip_cntr (
			.clock( fast_clock ),
			.cnt_en( bit_slip_int ),
			.q( bit_slip_count_int ),
			.aclr(1'b0),
			.aload(1'b0),
			.aset(1'b0),
			.cin(1'b1),
			.clk_en(1'b1),
			.data(1'b0),
			.sclr(1'b0),
			.sload(1'b0),
			.sset(1'b0),
			.updown(1'b1)
		);
	end	


	for( i = 0 ; i < number_of_channels ; i = i + 1 ) begin : channel
		wire channel_bit_slip;
		wire channel_bit_slip_regd;
		wire [ lg_deser_factor - 1 : 0 ] channel_bit_slip_count;
		wire [ lg_deser_factor - 1 : 0 ] bit_slip_count;
		wire rx_channel_data_align_regd;
		wire rx_in_sync_h_regd;
		wire rx_in_after_lat_h;
		wire rx_in_sync_l_regd;
		wire [ shiftreg_size - 1 : 0 ] datain_l;
		wire [ shiftreg_size - 1 : 0 ] datain_h;
		wire [ shiftreg_size * 2 - 1 : 0 ] rx_in_interleaved;
		reg h_mux_out;
		reg l_mux_out;
		wire shrg_l_din;
		wire shrg_h_din;
		wire [ shiftreg_size - 1 : 0 ] shrg_l_q;
		wire [ shiftreg_size - 1 : 0 ] shrg_h_q;
		wire [ shiftreg_size - 1 : 0 ] mux_din_h;
		wire [ shiftreg_size - 1 : 0 ] mux_din_l;

		dffep sync_a_h_ff (
			.q( rx_in_sync_h_regd ),
			.ck( fast_clock ),
			.en( 1'b1 ),
			.d( rx_in[i] ),
			.s( 1'b0 ),
			.r( pll_areset )
		);

		dffep sync_a_l_ff (
			.q( rx_in_sync_l_regd ),
			.ck( ~fast_clock ),
			.en( 1'b1 ),
			.d( rx_in[i] ),
			.s( 1'b0 ),
			.r( pll_areset )
		);

		dffep sync_b_l_ff (
			.q( rx_in_l_int[i] ),
			.ck( fast_clock ),
			.en( 1'b1 ),
			.d( rx_in_after_lat_h ),
			.s( 1'b0 ),
			.r( pll_areset )
		);

		if( IS_FAMILY_CYCLONE( intended_device_family )  ||
			IS_FAMILY_CYCLONEII( intended_device_family ) ||
			FEATURE_FAMILY_CYCLONEIII( intended_device_family )) begin
			dffep sync_b_h_ff (
				.q( rx_in_h_int[i] ),
				.ck( fast_clock ),
				.en( 1'b1 ),
				.d( rx_in_sync_h_regd ),
				.s( 1'b0 ),
				.r( pll_areset )
			);

			dffep sync_lat_l_ff (
				.q( rx_in_after_lat_h ),
				.ck( ~fast_clock ),
				.en( 1'b1 ),
				.d( rx_in_sync_l_regd ),
				.s( 1'b0 ),
				.r( pll_areset )
			);
		end
		else begin
			assign rx_in_after_lat_h = rx_in_sync_l_regd;
			assign rx_in_h_int[i] = rx_in_sync_h_regd;
		end
		assign sync_clock = rx_syncclock;

	// Odd Deser Factors
		if (port_rx_data_align != "PORT_UNUSED")
		begin
			lpm_shiftreg #(
				.lpm_width( shiftreg_size - 1),
				.lpm_direction( "LEFT" )
			) shrg_l_int (
				.enable(1'b1),
				.load(1'b0),
				.sclr(1'b0),
				.aclr(pll_areset),
				.clock(fast_clock),
				.data( { shiftreg_size-1 { 1'b0 } } ),
				.sset(1'b0),
				.shiftin( rx_in_l[i] ),
				.aset(1'b0),
				.q( shrg_l_q ) 
			);
		
			lpm_shiftreg #(
				.lpm_width( shiftreg_size - 1),
				.lpm_direction( "LEFT" )
			) shrg_h_int (
				.enable(1'b1),
				.load(1'b0),
				.sclr(1'b0),
				.aclr(pll_areset),
				.clock(fast_clock),
				.data( { shiftreg_size-1 { 1'b0 } } ),
				.sset(1'b0),
				.shiftin( rx_in_h[i] ),
				.aset(1'b0),
				.q( shrg_h_q ) 
			);

			assign mux_din_h = {shrg_h_q,rx_in_h[i]};
			assign mux_din_l = {shrg_l_q,rx_in_l[i]};

			always @ (bit_slip_count or mux_din_h or mux_din_l)
			begin
				h_mux_out = mux_din_h[bit_slip_count];
				l_mux_out = mux_din_l[bit_slip_count];
			end

		end
		assign bit_slip_count = ( port_rx_channel_data_align == "PORT_USED" )? channel_bit_slip_count : bit_slip_count_int;
		assign shrg_h_din = ( port_rx_data_align != "PORT_UNUSED" )? h_mux_out : rx_in_h[i];
		assign shrg_l_din = ( port_rx_data_align != "PORT_UNUSED" )? l_mux_out : rx_in_l[i];
		lpm_shiftreg #(
			.lpm_width( shiftreg_size ),
			.lpm_direction( "LEFT" )
		) shrg_l (
			.enable(1'b1),
			.load(1'b0),
			.sclr(1'b0),
			.aclr(pll_areset),
			.clock(fast_clock),
			.data( { shiftreg_size { 1'b0 } } ),
			.sset(1'b0),
			.shiftin(shrg_l_din),
			.aset(1'b0),
			.q(datain_l) );

		lpm_shiftreg #(
			.lpm_width( shiftreg_size ),
			.lpm_direction( "LEFT" )
		) shrg_h (
			.enable(1'b1),
			.load(1'b0),
			.sclr(1'b0),
			.aclr(pll_areset),
			.clock(fast_clock),
			.data( { shiftreg_size { 1'b0 } } ),
			.sset(1'b0),
			.shiftin(shrg_h_din),
			.aset(1'b0),
			.q(datain_h) );

		for( j = 0 ; j < shiftreg_size * 2 ; j = j + 1 ) begin : ilv
			if( j % 2 ) begin
				assign rx_in_interleaved[j] = datain_l[j/2];
			end
			else begin
				assign rx_in_interleaved[j] = datain_h[j/2];
			end
		end
	
		if( port_rx_channel_data_align == "PORT_USED" )  begin
			if( registered_data_align_input == "ON" && use_external_pll == "OFF" ) begin
				dffep channel_data_align_ff (
					.q( rx_channel_data_align_regd ),
					.ck( slow_clock ),
					.en( 1'b1 ),
					.d( rx_channel_data_align ),
					.s( 1'b0 ),
					.r( 1'b0 )
				);

			end
			else begin
				assign rx_channel_data_align_regd = rx_channel_data_align;
			end
			dffep channel_bitslip_ff (
				.q( channel_bit_slip_regd ),
				.ck( fast_clock ),
				.en( 1'b1 ),
				.d( rx_channel_data_align_regd ),
				.s( 1'b0 ),
				.r( 1'b0 )
			);

			assign channel_bit_slip = ~channel_bit_slip_regd & rx_channel_data_align_regd;

			lpm_counter #(
				.lpm_width( lg_deser_factor ),
				.lpm_modulus( deserialization_factor ),
				.lpm_direction( "UP" ),
				.lpm_port_updown( "PORT_UNUSED" )
			) bitslip_cntr (
				.clock( fast_clock ),
				.cnt_en( channel_bit_slip ),
				.q( channel_bit_slip_count ),
				.aclr(1'b0),
				.aload(1'b0),
				.aset(1'b0),
				.cin(1'b1),
				.clk_en(1'b1),
				.data(1'b0),
				.sclr(1'b0),
				.sload(1'b0),
				.sset(1'b0),
				.updown(1'b1)
			);
		end	

		if( deserialization_factor % 2 == 0 ) begin	// even deser factors
			assign rx_out_int[ deserialization_factor * ( i + 1 ) - 1 :
				deserialization_factor * i ] = rx_in_interleaved;
		end
		else begin		// odd deser factors
			assign rx_in_il_ch[ deserialization_factor * 2 * ( i + 1 ) - 1 :
				deserialization_factor * 2 * i ] =
				{ rx_in_interleaved[ deserialization_factor - 1 : 0 ],
					rx_in_interleaved[ deserialization_factor * 2 - 1 :
						deserialization_factor ] } ;
		end
	end

	if( registered_output == "ON" ) begin
		dffep rx_out_ff[ width_des_channels_ - 1 : 0 ] (
			.q( rx_out ),
			.ck( read_clock ),
			.en( 1'b1 ),
			.d( rx_out_int ),
			.s( 1'b0 ),
			.r( pll_areset )
		);
	end
	else begin
		assign rx_out = rx_out_int;
	end

	if( deserialization_factor % 2 ) begin	// odd deser factors
		wire [3:0] wrcnt;
		wire [4:0] rdcnt;
		wire wr_cnt_bit0;
		wire [ 2 : 0 ] wr_cnt_bit3_1;

		if( IS_FAMILY_CYCLONE( intended_device_family ) ) begin
			lpm_counter #(
				.lpm_width( 1 ),
				.lpm_direction( "UP" ),
				.lpm_port_updown( "PORT_UNUSED" )
			) clk_cntr (
				.clock(read_clock),
				.aclr(1'b0),
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
				.q(slow_clock)
			);
		end
		else begin
			assign slow_clock = pll_outclock[1];
		end

		if( use_fifo_data_sync == "ON" ) begin
			dffep sync_ff [ width_des_channels_ * 2 - 1 : 0 ] (
				.q( rx_in_il_ch_regd ),
				.ck( read_clock ),
				.en( 1'b1 ),
				.d( rx_in_il_ch ),
				.s( 1'b0 ),
				.r( pll_areset )
			);

			altsyncram #(
				.operation_mode( "dual_port" ),
				.widthad_a( 4 ),
				.widthad_b( 5 ),
				.width_a( width_des_channels_ * 2 ),
				.width_b( width_des_channels_ )
			) fifo (
				.address_a( { wrcnt[3:1], ~ wrcnt[0] } ),
				.address_b( rdcnt ),
				.clock0( slow_clock ),
				.clock1( read_clock ),
				.data_a( rx_in_il_ch_regd ),
				.data_b( { width_des_channels_ { 1'b0 } } ),
				.clocken0( 1'b1 ),
				.clocken1( 1'b1 ),
				.aclr0( 1'b0 ),
				.aclr1( 1'b0 ),
				.byteena_a( 1'b0 ),
				.byteena_b( 1'b0 ),
				.addressstall_a( 1'b1 ),
				.addressstall_b( 1'b1 ),
				.wren_a( 1'b1 ),
				.wren_b( 1'b0 ),
				.rden_b( 1'b1 ),
				.rden_a( 1'b1 ),
				.clocken2( 1'b1 ),
				.clocken3( 1'b1 ),
				.q_b( rx_out_int )
			);
			assign wrcnt = { wr_cnt_bit3_1, ~wr_cnt_bit0 };
			lpm_counter #(
				.lpm_width( 1 ),
				.lpm_direction( "UP" ),
				.lpm_port_updown( "PORT_UNUSED" )
			) wr_cntr_bit0 (
				.clock(slow_clock),
				.aclr(1'b0),
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
				.cout( wrcnt_bit0_cout ),
				.q(wr_cnt_bit0)
			
			);

			lpm_counter #(
				.lpm_width( 3 ),
				.lpm_direction( "UP" ),
				.lpm_port_updown( "PORT_UNUSED" )
			) wr_cntr (
				.clock(slow_clock),
				.aclr(pll_areset),
				.aload(1'b0),
				.aset(1'b0),
				.cin( ~wrcnt_bit0_cout ),
				.clk_en(1'b1),
				.cnt_en(1'b1),
				.data(1'b0),
				.sclr(1'b0),
				.sload(1'b0),
				.sset(1'b0),
				.updown(1'b1),
				//.q( wrcnt[3:1] )
				.q( wr_cnt_bit3_1 )
			);

			lpm_counter #(
				.lpm_width( 5 ),
				.lpm_direction( "UP" ),
				.lpm_port_updown( "PORT_UNUSED" )
			) rd_cntr (
				.clock(read_clock),
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
				.q(rdcnt)
			);
		end
		else begin		// use_fifo_data_sync != "ON"
			dffep sync_ff [ width_des_channels_ * 2 - 1 : 0 ] (
				.q( rx_in_il_ch_regd ),
				.ck( slow_clock ),
				.en( 1'b1 ),
				.d( rx_in_il_ch ),
				.s( 1'b0 ),
				.r( 1'b0 )
			);

			dffep muxsel_ff (
				.q( muxsel ),
				.ck( read_clock ),
				.en( 1'b1 ),
				.d( ~muxsel ),
				.s( 1'b0 ),
				.r( 1'b0 )
			);
			assign rx_out_int = muxsel ?
				rx_in_il_ch_regd[ width_des_channels_ * 2 - 1 :
					width_des_channels_ ] :
				rx_in_il_ch_regd[ width_des_channels_ - 1 : 0 ];
		end
	end		// end odd deser factor
	endgenerate
endmodule

