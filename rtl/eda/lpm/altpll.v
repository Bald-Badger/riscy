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
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// ALTPLL for Formal Verification //////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN

module altpll ( 
// INTERFACE BEGIN
	inclk, fbin, pllena, clkswitch, areset, pfdena, clkena, extclkena,
	scanclk, scanaclr, scandata, scanread, scanwrite, clk, extclk, clkbad,
	activeclock, clkloss, locked ,scandataout, scandone, sclkout0, sclkout1,
	enable0, enable1, configupdate, fbout, phasecounterselect, phasedone, 
	phasestep, phaseupdown, scanclkena, vcooverrange, vcounderrange, fbmimicbidir, fref, icdrclk
);

// INTERFACE END
//// default parameters ////

	parameter intended_device_family = "CYCLONE IV E";
	parameter operation_mode = "unused";
	parameter pll_type = "AUTO";
	parameter qualify_conf_done = "OFF";
	parameter compensate_clock = "CLK0";
	parameter scan_chain = "LONG";
	parameter primary_clock = "INCLK0";
	parameter inclk0_input_frequency = 1;
	parameter inclk1_input_frequency = 0;
	parameter gate_lock_signal = "NO";
	parameter gate_lock_counter = 0;
	parameter lock_high = 1;
	parameter lock_low = 1;
	parameter valid_lock_multiplier = 1;
	parameter invalid_lock_multiplier = 5;
	parameter switch_over_type = "AUTO";
	parameter switch_over_on_lossclk = "OFF" ;
	parameter switch_over_on_gated_lock = "OFF" ;
	parameter switch_over_counter = 0;
	parameter enable_switch_over_counter = "OFF";
	parameter feedback_source = "EXTCLK0" ;
	parameter bandwidth = 0;
	parameter bandwidth_type = "AUTO";
	parameter spread_frequency = 0;
	parameter down_spread = "0";
	parameter simulation_type = "functional";
	parameter source_is_pll = "off";
	parameter skip_vco = "OFF";
	parameter clk5_multiply_by = 1;
	parameter clk4_multiply_by = 1;
	parameter clk3_multiply_by = 1;
	parameter clk2_multiply_by = 1;
	parameter clk1_multiply_by = 1;
	parameter clk0_multiply_by = 1;
	parameter clk5_divide_by = 1;
	parameter clk4_divide_by = 1;
	parameter clk3_divide_by = 1;
	parameter clk2_divide_by = 1;
	parameter clk1_divide_by = 1;
	parameter clk0_divide_by = 1;
	parameter clk5_phase_shift = "0";
	parameter clk4_phase_shift = "0";
	parameter clk3_phase_shift = "0";
	parameter clk2_phase_shift = "0";
	parameter clk1_phase_shift = "0";
	parameter clk0_phase_shift = "0";
	parameter clk5_time_delay = "0";
	parameter clk4_time_delay = "0";
	parameter clk3_time_delay = "0";
	parameter clk2_time_delay = "0";
	parameter clk1_time_delay = "0";
	parameter clk0_time_delay = "0";
	parameter clk5_duty_cycle = 50;
	parameter clk4_duty_cycle = 50;
	parameter clk3_duty_cycle = 50;
	parameter clk2_duty_cycle = 50;
	parameter clk1_duty_cycle = 50;
	parameter clk0_duty_cycle = 50;
	parameter extclk3_multiply_by = 1;
	parameter extclk2_multiply_by = 1;
	parameter extclk1_multiply_by = 1;
	parameter extclk0_multiply_by = 1;
	parameter extclk3_divide_by = 1;
	parameter extclk2_divide_by = 1;
	parameter extclk1_divide_by = 1;
	parameter extclk0_divide_by = 1;
	parameter extclk3_phase_shift = "0";
	parameter extclk2_phase_shift = "0";
	parameter extclk1_phase_shift = "0";
	parameter extclk0_phase_shift = "0";
	parameter extclk3_time_delay = "0";
	parameter extclk2_time_delay = "0";
	parameter extclk1_time_delay = "0";
	parameter extclk0_time_delay = "0";
	parameter extclk3_duty_cycle = 50;
	parameter extclk2_duty_cycle = 50;
	parameter extclk1_duty_cycle = 50;
	parameter extclk0_duty_cycle = 50;
	parameter vco_min = 0;
	parameter vco_max = 0;
	parameter vco_center = 0;
	parameter pfd_min = 0;
	parameter pfd_max = 0;
	parameter m_initial = 0;
	parameter m = 0;
	parameter n = 1;
	parameter m2 = 1;
	parameter n2 = 1;
	parameter ss = 1;
	parameter l0_high = 1;
	parameter l1_high = 1;
	parameter g0_high = 1;
	parameter g1_high = 1;
	parameter g2_high = 1;
	parameter g3_high = 1;
	parameter e0_high = 1;
	parameter e1_high = 1;
	parameter e2_high = 1;
	parameter e3_high = 1;
	parameter l0_low = 1;
	parameter l1_low = 1;
	parameter g0_low = 1;
	parameter g1_low = 1;
	parameter g2_low = 1;
	parameter g3_low = 1;
	parameter e0_low = 1;
	parameter e1_low = 1;
	parameter e2_low = 1;
	parameter e3_low = 1;
	parameter l0_initial = 1;
	parameter l1_initial = 1;
	parameter g0_initial = 1;
	parameter g1_initial = 1;
	parameter g2_initial = 1;
	parameter g3_initial = 1;
	parameter e0_initial = 1;
	parameter e1_initial = 1;
	parameter e2_initial = 1;
	parameter e3_initial = 1;
	parameter l0_mode = "BYPASS" ;
	parameter l1_mode = "BYPASS" ;
	parameter g0_mode = "BYPASS" ;
	parameter g1_mode = "BYPASS" ;
	parameter g2_mode = "BYPASS" ;
	parameter g3_mode = "BYPASS" ;
	parameter e0_mode = "BYPASS" ;
	parameter e1_mode = "BYPASS" ;
	parameter e2_mode = "BYPASS" ;
	parameter e3_mode = "BYPASS" ;
	parameter l0_ph = 0;
	parameter l1_ph = 0;
	parameter g0_ph = 0;
	parameter g1_ph = 0;
	parameter g2_ph = 0;
	parameter g3_ph = 0;
	parameter e0_ph = 0;
	parameter e1_ph = 0;
	parameter e2_ph = 0;
	parameter e3_ph = 0;
	parameter m_ph = 0;
	parameter l0_time_delay = 0;
	parameter l1_time_delay = 0;
	parameter g0_time_delay = 0;
	parameter g1_time_delay = 0;
	parameter g2_time_delay = 0;
	parameter g3_time_delay = 0;
	parameter e0_time_delay = 0;
	parameter e1_time_delay = 0;
	parameter e2_time_delay = 0;
	parameter e3_time_delay = 0;
	parameter m_time_delay = 0;
	parameter n_time_delay = 0;
	parameter extclk3_counter = "E3" ;
	parameter extclk2_counter = "E2" ;
	parameter extclk1_counter = "E1" ;
	parameter extclk0_counter = "E0" ;
	parameter clk5_counter = "G0" ;
	parameter clk4_counter = "G0" ;
	parameter clk3_counter = "G0" ;
	parameter clk2_counter = "G0" ;
	parameter clk1_counter = "G0" ;
	parameter clk0_counter = "G0" ;
	parameter charge_pump_current = 2;
	parameter loop_filter_r = " 1.000000";
	parameter loop_filter_c = 5;
	parameter lpm_type = "altpll";
	parameter lpm_hint = "UNUSED";
	parameter c0_high = 0;
	parameter c0_initial = 0;
	parameter c0_low = 0;
	parameter c0_mode = "BYPASS";
	parameter c0_ph = 0;
	parameter c1_high = 0;
	parameter c1_initial = 0;
	parameter c1_low = 0;
	parameter c1_mode = "BYPASS";
	parameter c1_ph = 0;
	parameter c1_use_casc_in = "OFF";
	parameter c2_high = 0;
	parameter c2_initial = 0;
	parameter c2_low = 0;
	parameter c2_mode = "BYPASS";
	parameter c2_ph = 0;
	parameter c2_use_casc_in = "OFF";
	parameter c3_high = 0;
	parameter c3_initial = 0;
	parameter c3_low = 0;
	parameter c3_mode = "BYPASS";
	parameter c3_ph = 0;
	parameter c3_use_casc_in = "OFF";
	parameter c4_high = 0;
	parameter c4_initial = 0;
	parameter c4_low = 0;
	parameter c4_mode = "BYPASS";
	parameter c4_ph = 0;
	parameter c4_use_casc_in = "OFF";
	parameter c5_high = 0;
	parameter c5_initial = 0;
	parameter c5_low = 0;
	parameter c5_mode = "BYPASS";
	parameter c5_ph = 0;
	parameter c5_use_casc_in = "OFF";
	parameter enable0_counter = "L0";
	parameter enable1_counter = "L0";
	parameter sclkout0_phase_shift = "0";
	parameter sclkout1_phase_shift = "0";
	parameter vco_divide_by = 0;
	parameter vco_multiply_by = 0;
	parameter vco_post_scale = 0;
	parameter clk0_output_frequency = 0;
	parameter clk1_output_frequency = 0;
	parameter clk2_output_frequency = 0;
	parameter c0_test_source = 5;
	parameter c1_test_source = 5;
	parameter c2_test_source = 5;
	parameter c3_test_source = 5;
	parameter c4_test_source = 5;
	parameter c5_test_source = 5;
	parameter m_test_source = 5;

	parameter port_activeclock = "PORT_CONNECTIVITY";
	parameter port_clkbad0 = "PORT_CONNECTIVITY";
	parameter port_clkbad1 = "PORT_CONNECTIVITY";
	parameter port_clkena0 = "PORT_CONNECTIVITY";
	parameter port_clkena1 = "PORT_CONNECTIVITY";
	parameter port_clkena2 = "PORT_CONNECTIVITY";
	parameter port_clkena3 = "PORT_CONNECTIVITY";
	parameter port_clkena4 = "PORT_CONNECTIVITY";
	parameter port_clkena5 = "PORT_CONNECTIVITY";
	parameter port_clkloss = "PORT_CONNECTIVITY";
	parameter port_extclk0 = "PORT_CONNECTIVITY";
	parameter port_extclk1 = "PORT_CONNECTIVITY";
	parameter port_extclk2 = "PORT_CONNECTIVITY";
	parameter port_extclk3 = "PORT_CONNECTIVITY";
	parameter port_extclkena0 = "PORT_CONNECTIVITY";
	parameter port_extclkena1 = "PORT_CONNECTIVITY";
	parameter port_extclkena2 = "PORT_CONNECTIVITY";
	parameter port_extclkena3 = "PORT_CONNECTIVITY";

	parameter port_areset = "PORT_CONNECTIVITY";
	parameter port_clk0 = "PORT_CONNECTIVITY";
	parameter port_clk1 = "PORT_CONNECTIVITY";
	parameter port_clk2 = "PORT_CONNECTIVITY";
	parameter port_clk3 = "PORT_CONNECTIVITY";
	parameter port_clk4 = "PORT_CONNECTIVITY";
	parameter port_clk5 = "PORT_CONNECTIVITY";
	parameter port_clk6 = "PORT_CONNECTIVITY";
	parameter port_clk7 = "PORT_CONNECTIVITY";
	parameter port_clk8 = "PORT_CONNECTIVITY";
	parameter port_clk9 = "PORT_CONNECTIVITY";
	parameter port_clkswitch = "PORT_CONNECTIVITY";
	parameter port_enable0 = "PORT_CONNECTIVITY";
	parameter port_enable1 = "PORT_CONNECTIVITY";
	parameter port_fbin = "PORT_CONNECTIVITY";
	parameter port_inclk0 = "PORT_CONNECTIVITY";
	parameter port_inclk1 = "PORT_CONNECTIVITY";
	parameter port_pfdena = "PORT_CONNECTIVITY";
	parameter port_pllena = "PORT_CONNECTIVITY";
	parameter port_scanaclr = "PORT_CONNECTIVITY";
	parameter port_scanclk = "PORT_CONNECTIVITY";
	parameter port_scandata = "PORT_CONNECTIVITY";
	parameter port_scandataout = "PORT_CONNECTIVITY";
	parameter port_scandone = "PORT_CONNECTIVITY";
	parameter port_scanread = "PORT_CONNECTIVITY";
	parameter port_scanwrite = "PORT_CONNECTIVITY";
	parameter port_sclkout0 = "PORT_CONNECTIVITY";
	parameter port_sclkout1 = "PORT_CONNECTIVITY";
	parameter self_reset_on_gated_loss_lock = "OFF";
	parameter port_locked = "PORT_CONNECTIVITY";
	parameter port_vcooverrange = "PORT_CONNECTIVITY";
	parameter port_vcounderrange = "PORT_CONNECTIVITY";
	parameter width_phasecounterselect = 4;



	parameter c6_high = 0;
	parameter c6_initial = 0;
	parameter c6_low = 0;
	parameter c6_mode = "BYPASS";
	parameter c6_ph = 0;
	parameter c6_test_source = 5;
	parameter c6_use_casc_in = "OFF";
	parameter c7_high = 0;
	parameter c7_initial = 0;
	parameter c7_low = 0;
	parameter c7_mode = "BYPASS";
	parameter c7_ph = 0;
	parameter c7_test_source = 5;
	parameter c7_use_casc_in = "OFF";
	parameter c8_high = 0;
	parameter c8_initial = 0;
	parameter c8_low = 0;
	parameter c8_mode = "BYPASS";
	parameter c8_ph = 0;
	parameter c8_test_source = 5;
	parameter c8_use_casc_in = "OFF";
	parameter c9_high = 0;
	parameter c9_initial = 0;
	parameter c9_low = 0;
	parameter c9_mode = "BYPASS";
	parameter c9_ph = 0;
	parameter c9_test_source = 5;
	parameter c9_use_casc_in = "OFF";
	parameter clk0_use_even_counter_mode = "OFF";
	parameter clk0_use_even_counter_value = "OFF";
	parameter clk1_use_even_counter_mode = "OFF";
	parameter clk1_use_even_counter_value = "OFF";
	parameter clk2_use_even_counter_mode = "OFF";
	parameter clk2_use_even_counter_value = "OFF";
	parameter clk3_use_even_counter_mode = "OFF";
	parameter clk3_use_even_counter_value = "OFF";
	parameter clk4_use_even_counter_mode = "OFF";
	parameter clk4_use_even_counter_value = "OFF";
	parameter clk5_use_even_counter_mode = "OFF";
	parameter clk5_use_even_counter_value = "OFF";
	parameter clk6_divide_by = 0;
	parameter clk6_duty_cycle = 50;
	parameter clk6_multiply_by = 0;
	parameter clk6_phase_shift = "0";
	parameter clk6_use_even_counter_mode = "OFF";
	parameter clk6_use_even_counter_value = "OFF";
	parameter clk7_divide_by = 0;
	parameter clk7_duty_cycle = 50;
	parameter clk7_multiply_by = 0;
	parameter clk7_phase_shift = "0";
	parameter clk7_use_even_counter_mode = "OFF";
	parameter clk7_use_even_counter_value = "OFF";
	parameter clk8_divide_by = 0;
	parameter clk8_duty_cycle = 50;
	parameter clk8_multiply_by = 0;
	parameter clk8_phase_shift = "0";
	parameter clk8_use_even_counter_mode = "OFF";
	parameter clk8_use_even_counter_value = "OFF";
	parameter clk9_divide_by = 0;
	parameter clk9_duty_cycle = 50;
	parameter clk9_multiply_by = 0;
	parameter clk9_phase_shift = "0";
	parameter clk9_use_even_counter_mode = "OFF";
	parameter clk9_use_even_counter_value = "OFF";
	parameter lock_window_ui = " 0.05";
	parameter self_reset_on_loss_lock = "OFF";
	parameter vco_frequency_control = "AUTO";
	parameter vco_phase_shift_step = 0;
	parameter width_clock = 6;
	parameter port_configupdate = "PORT_CONNECTIVITY";
	parameter port_fbout = "PORT_CONNECTIVITY";
	parameter port_phasecounterselect = "PORT_CONNECTIVITY";
	parameter port_phasedone = "PORT_CONNECTIVITY";
	parameter port_phasestep = "PORT_CONNECTIVITY";
	parameter port_phaseupdown = "PORT_CONNECTIVITY";
	parameter port_scanclkena = "PORT_CONNECTIVITY";

	parameter charge_pump_current_bits = 9999;
	parameter loop_filter_c_bits = 9999;
	parameter loop_filter_r_bits = 9999;

	parameter clk6_counter = "E0";
	parameter clk7_counter = "E1";
	parameter clk8_counter = "E2";
	parameter clk9_counter = "E3";
	parameter scan_chain_mif_file = "UNUSED";
	parameter sim_gate_lock_device_behavior = "OFF";
	parameter   using_fbmimicbidir_port = "OFF";

	parameter dpa_divide_by = 1;
	parameter dpa_divider = 0;
	parameter dpa_multiply_by = 0;


        //// port declarations ////

	input [1:0] inclk;
	input fbin;
	input pllena;
	input clkswitch;
	input areset;
	input pfdena;
	input [5:0] clkena;
	input [3:0] extclkena;
	input scanclk;
	input scanaclr;
	input scandata;
	input scanread;
	input scanwrite;
	input configupdate;
	input [width_phasecounterselect-1:0] phasecounterselect;
	input phasestep;
	input phaseupdown;
	input scanclkena;
	output phasedone;
	output fbout;
	output [width_clock-1:0] clk;
	output [3:0] extclk;
	output [1:0] clkbad;
	output activeclock;
	output clkloss;
	output locked;
	output enable0;
	output enable1;
	output scandataout;
	output scandone;
	output sclkout0;
	output sclkout1;
	output vcooverrange;
	output vcounderrange;
	output fref;
	output icdrclk;
	inout fbmimicbidir;

	wire locked_wire;
	wire locked_reg;
	wire feedback;

`include "altera_mf_macros.i"

	generate
	if( IS_FAMILY_STRATIXII( intended_device_family ) ) begin
		assign locked = locked_wire;

		stratixii_pll 
		#(
			.c0_high(c0_high),
			.c0_initial(c0_initial),
			.c0_low(c0_low),
			.c0_mode(c0_mode),
			.c0_ph(c0_ph),
			.c1_high(c1_high),
			.c1_initial(c1_initial),
			.c1_low(c1_low),
			.c1_mode(c1_mode),
			.c1_ph(c1_ph),
			.c1_use_casc_in(c1_use_casc_in),
			.c2_high(c2_high),
			.c2_initial(c2_initial),
			.c2_low(c2_low),
			.c2_mode(c2_mode),
			.c2_ph(c2_ph),
			.c2_use_casc_in(c2_use_casc_in),
			.c3_high(c3_high),
			.c3_initial(c3_initial),
			.c3_low(c3_low),
			.c3_mode(c3_mode),
			.c3_ph(c3_ph),
			.c3_use_casc_in(c3_use_casc_in),
			.c4_high(c4_high),
			.c4_initial(c4_initial),
			.c4_low(c4_low),
			.c4_mode(c4_mode),
			.c4_ph(c4_ph),
			.c4_use_casc_in(c4_use_casc_in),
			.c5_high(c5_high),
			.c5_initial(c5_initial),
			.c5_low(c5_low),
			.c5_mode(c5_mode),
			.c5_ph(c5_ph),
			.c5_use_casc_in(c5_use_casc_in),
			.clk0_output_frequency(clk0_output_frequency),
			.clk1_output_frequency(clk1_output_frequency),
			.clk2_output_frequency(clk2_output_frequency),
			.enable0_counter(enable0_counter),
			.enable1_counter(enable1_counter),
			.lock_high(lock_high),
			.lock_low(lock_low),
			.sclkout0_phase_shift(sclkout0_phase_shift),
			.sclkout1_phase_shift(sclkout1_phase_shift),
			.switch_over_type(switch_over_type),
			.vco_divide_by(vco_divide_by),
			.vco_multiply_by(vco_multiply_by),
			.vco_post_scale(vco_post_scale),
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (fbin),
			.ena (pllena),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.sclkout ({sclkout1,sclkout0}),
			.scanclk (scanclk),
			.scandata (scandata),
			.scanread (scanread),
			.scanwrite (scanwrite),
			.testin (4'b0000),
			.clk (clk),
			.clkbad (clkbad),
			.activeclock (activeclock),
			.locked (locked_wire),
			.clkloss (clkloss),
			.scandataout (scandataout),
			.scandone (scandone),
			.enable0 (enable0),
			.enable1 (enable1)
		);
	end
	else if( IS_FAMILY_HARDCOPYII( intended_device_family ) ) begin
		assign locked = locked_wire;

		hardcopyii_pll 
		#(
			.c0_high(c0_high),
			.c0_initial(c0_initial),
			.c0_low(c0_low),
			.c0_mode(c0_mode),
			.c0_ph(c0_ph),
			.c1_high(c1_high),
			.c1_initial(c1_initial),
			.c1_low(c1_low),
			.c1_mode(c1_mode),
			.c1_ph(c1_ph),
			.c1_use_casc_in(c1_use_casc_in),
			.c2_high(c2_high),
			.c2_initial(c2_initial),
			.c2_low(c2_low),
			.c2_mode(c2_mode),
			.c2_ph(c2_ph),
			.c2_use_casc_in(c2_use_casc_in),
			.c3_high(c3_high),
			.c3_initial(c3_initial),
			.c3_low(c3_low),
			.c3_mode(c3_mode),
			.c3_ph(c3_ph),
			.c3_use_casc_in(c3_use_casc_in),
			.c4_high(c4_high),
			.c4_initial(c4_initial),
			.c4_low(c4_low),
			.c4_mode(c4_mode),
			.c4_ph(c4_ph),
			.c4_use_casc_in(c4_use_casc_in),
			.c5_high(c5_high),
			.c5_initial(c5_initial),
			.c5_low(c5_low),
			.c5_mode(c5_mode),
			.c5_ph(c5_ph),
			.c5_use_casc_in(c5_use_casc_in),
			.clk0_output_frequency(clk0_output_frequency),
			.clk1_output_frequency(clk1_output_frequency),
			.clk2_output_frequency(clk2_output_frequency),
			.enable0_counter(enable0_counter),
			.enable1_counter(enable1_counter),
			.lock_high(lock_high),
			.lock_low(lock_low),
			.sclkout0_phase_shift(sclkout0_phase_shift),
			.sclkout1_phase_shift(sclkout1_phase_shift),
			.switch_over_type(switch_over_type),
			.vco_divide_by(vco_divide_by),
			.vco_multiply_by(vco_multiply_by),
			.vco_post_scale(vco_post_scale),
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
			.e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
			.g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (fbin),
			.ena (pllena),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.sclkout ({sclkout1,sclkout0}),
			.scanclk (scanclk),
			.scandata (scandata),
			.scanread (scanread),
			.scanwrite (scanwrite),
			.testin (4'b0000),
			.clk (clk),
			.clkbad (clkbad),
			.activeclock (activeclock),
			.locked (locked_wire),
			.clkloss (clkloss),
			.scandataout (scandataout),
			.scandone (scandone),
			.enable0 (enable0),
			.enable1 (enable1)
		);
	end
	else if( IS_FAMILY_STRATIXIIGX( intended_device_family ) ) begin
		assign locked = locked_wire;

		stratixiigx_pll 
		#(
			.c0_high(c0_high),
			.c0_initial(c0_initial),
			.c0_low(c0_low),
			.c0_mode(c0_mode),
			.c0_ph(c0_ph),
			.c1_high(c1_high),
			.c1_initial(c1_initial),
			.c1_low(c1_low),
			.c1_mode(c1_mode),
			.c1_ph(c1_ph),
			.c1_use_casc_in(c1_use_casc_in),
			.c2_high(c2_high),
			.c2_initial(c2_initial),
			.c2_low(c2_low),
			.c2_mode(c2_mode),
			.c2_ph(c2_ph),
			.c2_use_casc_in(c2_use_casc_in),
			.c3_high(c3_high),
			.c3_initial(c3_initial),
			.c3_low(c3_low),
			.c3_mode(c3_mode),
			.c3_ph(c3_ph),
			.c3_use_casc_in(c3_use_casc_in),
			.c4_high(c4_high),
			.c4_initial(c4_initial),
			.c4_low(c4_low),
			.c4_mode(c4_mode),
			.c4_ph(c4_ph),
			.c4_use_casc_in(c4_use_casc_in),
			.c5_high(c5_high),
			.c5_initial(c5_initial),
			.c5_low(c5_low),
			.c5_mode(c5_mode),
			.c5_ph(c5_ph),
			.c5_use_casc_in(c5_use_casc_in),
			.clk0_output_frequency(clk0_output_frequency),
			.clk1_output_frequency(clk1_output_frequency),
			.clk2_output_frequency(clk2_output_frequency),
			.enable0_counter(enable0_counter),
			.enable1_counter(enable1_counter),
			.lock_high(lock_high),
			.lock_low(lock_low),
			.sclkout0_phase_shift(sclkout0_phase_shift),
			.sclkout1_phase_shift(sclkout1_phase_shift),
			.switch_over_type(switch_over_type),
			.vco_divide_by(vco_divide_by),
			.vco_multiply_by(vco_multiply_by),
			.vco_post_scale(vco_post_scale),
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
			.e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
			.g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (fbin),
			.ena (pllena),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.sclkout ({sclkout1,sclkout0}),
			.scanclk (scanclk),
			.scandata (scandata),
			.scanread (scanread),
			.scanwrite (scanwrite),
			.testin (4'b0000),
			.clk (clk),
			.clkbad (clkbad),
			.activeclock (activeclock),
			.locked (locked_wire),
			.clkloss (clkloss),
			.scandataout (scandataout),
			.scandone (scandone),
			.enable0 (enable0),
			.enable1 (enable1)
		);
	end
	else if( IS_FAMILY_ARRIAGX( intended_device_family ) ) begin
		assign locked = locked_wire;

		arriagx_pll 
		#(
			.c0_high(c0_high),
			.c0_initial(c0_initial),
			.c0_low(c0_low),
			.c0_mode(c0_mode),
			.c0_ph(c0_ph),
			.c1_high(c1_high),
			.c1_initial(c1_initial),
			.c1_low(c1_low),
			.c1_mode(c1_mode),
			.c1_ph(c1_ph),
			.c1_use_casc_in(c1_use_casc_in),
			.c2_high(c2_high),
			.c2_initial(c2_initial),
			.c2_low(c2_low),
			.c2_mode(c2_mode),
			.c2_ph(c2_ph),
			.c2_use_casc_in(c2_use_casc_in),
			.c3_high(c3_high),
			.c3_initial(c3_initial),
			.c3_low(c3_low),
			.c3_mode(c3_mode),
			.c3_ph(c3_ph),
			.c3_use_casc_in(c3_use_casc_in),
			.c4_high(c4_high),
			.c4_initial(c4_initial),
			.c4_low(c4_low),
			.c4_mode(c4_mode),
			.c4_ph(c4_ph),
			.c4_use_casc_in(c4_use_casc_in),
			.c5_high(c5_high),
			.c5_initial(c5_initial),
			.c5_low(c5_low),
			.c5_mode(c5_mode),
			.c5_ph(c5_ph),
			.c5_use_casc_in(c5_use_casc_in),
			.clk0_output_frequency(clk0_output_frequency),
			.clk1_output_frequency(clk1_output_frequency),
			.clk2_output_frequency(clk2_output_frequency),
			.enable0_counter(enable0_counter),
			.enable1_counter(enable1_counter),
			.lock_high(lock_high),
			.lock_low(lock_low),
			.sclkout0_phase_shift(sclkout0_phase_shift),
			.sclkout1_phase_shift(sclkout1_phase_shift),
			.switch_over_type(switch_over_type),
			.vco_divide_by(vco_divide_by),
			.vco_multiply_by(vco_multiply_by),
			.vco_post_scale(vco_post_scale),
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
			.e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
			.g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (fbin),
			.ena (pllena),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.sclkout ({sclkout1,sclkout0}),
			.scanclk (scanclk),
			.scandata (scandata),
			.scanread (scanread),
			.scanwrite (scanwrite),
			.testin (4'b0000),
			.clk (clk),
			.clkbad (clkbad),
			.activeclock (activeclock),
			.locked (locked_wire),
			.clkloss (clkloss),
			.scandataout (scandataout),
			.scandone (scandone),
			.enable0 (enable0),
			.enable1 (enable1)
		);
	end
	else if( IS_FAMILY_CYCLONEII( intended_device_family ) ) begin
		assign locked = locked_wire;

		cycloneii_pll 
		#(
			.c0_high(c0_high),
			.c0_initial(c0_initial),
			.c0_low(c0_low),
			.c0_mode(c0_mode),
			.c0_ph(c0_ph),
			.c1_high(c1_high),
			.c1_initial(c1_initial),
			.c1_low(c1_low),
			.c1_mode(c1_mode),
			.c1_ph(c1_ph),
			.c1_use_casc_in(c1_use_casc_in),
			.c2_high(c2_high),
			.c2_initial(c2_initial),
			.c2_low(c2_low),
			.c2_mode(c2_mode),
			.c2_ph(c2_ph),
			.c2_use_casc_in(c2_use_casc_in),
			.c3_high(c3_high),
			.c3_initial(c3_initial),
			.c3_low(c3_low),
			.c3_mode(c3_mode),
			.c3_ph(c3_ph),
			.c3_use_casc_in(c3_use_casc_in),
			.c4_high(c4_high),
			.c4_initial(c4_initial),
			.c4_low(c4_low),
			.c4_mode(c4_mode),
			.c4_ph(c4_ph),
			.c4_use_casc_in(c4_use_casc_in),
			.c5_high(c5_high),
			.c5_initial(c5_initial),
			.c5_low(c5_low),
			.c5_mode(c5_mode),
			.c5_ph(c5_ph),
			.c5_use_casc_in(c5_use_casc_in),
			.clk0_output_frequency(clk0_output_frequency),
			.clk1_output_frequency(clk1_output_frequency),
			.clk2_output_frequency(clk2_output_frequency),
			.enable0_counter(enable0_counter),
			.enable1_counter(enable1_counter),
			.lock_high(lock_high),
			.lock_low(lock_low),
			.sclkout0_phase_shift(sclkout0_phase_shift),
			.sclkout1_phase_shift(sclkout1_phase_shift),
			.switch_over_type(switch_over_type),
			.vco_divide_by(vco_divide_by),
			.vco_multiply_by(vco_multiply_by),
			.vco_post_scale(vco_post_scale),
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
			.e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
			.g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.ena (pllena),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.clk (clk),
			.locked (locked_wire),
			.sbdin(1'b0),
			.testclearlock(1'b0)
		);
	end
	else if( IS_FAMILY_STRATIX( intended_device_family ) ) begin
		assign locked = ( pll_type == "FAST"  ||  pll_type == "Fast" || pll_type == "fast" ) ? ~locked_wire : locked_wire;

		stratix_pll 
		#(
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
			.e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
			.g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (fbin),
			.ena (pllena),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.clkena (clkena),
			.extclk (extclk),
			.extclkena (extclkena),
			.scanaclr (scanaclr),
			.scanclk (scanclk),
			.scandata (scandata),
			.comparator( 1'b0 ),
			.clk (clk),
			.clkbad (clkbad),
			.activeclock (activeclock),
			.locked (locked_wire),
			.clkloss (clkloss),
			.scandataout (scandataout),
			.enable0 (enable0),
			.enable1 (enable1)
		);
	end
	else if( IS_FAMILY_STRATIXGX( intended_device_family ) ) begin
		assign locked = ( pll_type == "FAST" ||  pll_type == "Fast" || pll_type == "fast" ) ? ~locked_wire : locked_wire;

		stratixgx_pll
		#(
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
			.e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
			.g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (fbin),
			.ena (pllena),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.clkena (clkena),
			.extclk (extclk),
			.extclkena (extclkena),
			.scanaclr (scanaclr),
			.scanclk (scanclk),
			.scandata (scandata),
			.comparator( 1'b0 ),
			.clk (clk),
			.clkbad (clkbad),
			.activeclock (activeclock),
			.locked (locked_wire),
			.clkloss (clkloss),
			.scandataout (scandataout),
			.enable0 (enable0),
			.enable1 (enable1)
		);
	end
	else if( IS_FAMILY_CYCLONE( intended_device_family ) ) begin
		assign locked = ( pll_type == "FAST" ||  pll_type == "Fast" || pll_type == "fast" ) ? ~locked_wire : locked_wire;

		cyclone_pll
		#(
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
			.e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
			.g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (fbin),
			.ena (pllena),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.clkena (clkena),
			.extclk (extclk),
			.extclkena (extclkena),
			.scanaclr (scanaclr),
			.scanclk (scanclk),
			.scandata (scandata),
			.comparator( 1'b0 ),
			.clk (clk),
			.clkbad (clkbad),
			.activeclock (activeclock),
			.locked (locked_wire),
			.clkloss (clkloss),
			.scandataout (scandataout),
			.enable0 (enable0),
			.enable1 (enable1)
		);
	end
	else if( IS_FAMILY_STRATIXIII( intended_device_family ) ) begin
		if (port_areset != "PORT_UNUSED") begin
			dffep pll_lock_sync_ff (locked_reg, locked_wire, 1'b1, 1'b1, 1'b0, areset);
			assign locked = locked_wire && locked_reg;
		end
		else begin
			assign locked = locked_wire;
		end
		assign feedback = (operation_mode=="NORMAL" || operation_mode=="SOURCE_SYNCHRONOUS" 
					|| operation_mode=="NO_COMPENSATION")? fbout : fbin;

		stratixiii_pll 
		#(
			.c0_high(c0_high),
			.c0_initial(c0_initial),
			.c0_low(c0_low),
			.c0_mode(c0_mode),
			.c0_ph(c0_ph),
			.c1_high(c1_high),
			.c1_initial(c1_initial),
			.c1_low(c1_low),
			.c1_mode(c1_mode),
			.c1_ph(c1_ph),
			.c1_use_casc_in(c1_use_casc_in),
			.c2_high(c2_high),
			.c2_initial(c2_initial),
			.c2_low(c2_low),
			.c2_mode(c2_mode),
			.c2_ph(c2_ph),
			.c2_use_casc_in(c2_use_casc_in),
			.c3_high(c3_high),
			.c3_initial(c3_initial),
			.c3_low(c3_low),
			.c3_mode(c3_mode),
			.c3_ph(c3_ph),
			.c3_use_casc_in(c3_use_casc_in),
			.c4_high(c4_high),
			.c4_initial(c4_initial),
			.c4_low(c4_low),
			.c4_mode(c4_mode),
			.c4_ph(c4_ph),
			.c4_use_casc_in(c4_use_casc_in),
			.c5_high(c5_high),
			.c5_initial(c5_initial),
			.c5_low(c5_low),
			.c5_mode(c5_mode),
			.c5_ph(c5_ph),
			.c5_use_casc_in(c5_use_casc_in),
			.clk0_output_frequency(clk0_output_frequency),
			.clk1_output_frequency(clk1_output_frequency),
			.clk2_output_frequency(clk2_output_frequency),
			.enable0_counter(enable0_counter),
			.enable1_counter(enable1_counter),
			.lock_high(lock_high),
			.lock_low(lock_low),
			.sclkout0_phase_shift(sclkout0_phase_shift),
			.sclkout1_phase_shift(sclkout1_phase_shift),
			.switch_over_type(switch_over_type),
			.vco_divide_by(vco_divide_by),
			.vco_multiply_by(vco_multiply_by),
			.vco_post_scale(vco_post_scale),
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
			.e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
			.g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (feedback),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.scanclk (scanclk),
			.scandata (scandata),
			.clk (clk),
			.clkbad (clkbad),
			.activeclock (activeclock),
			.locked (locked_wire),
			.scandataout (scandataout),
			.scandone (scandone),
			.fbout (fbout),
			.phasecounterselect(phasecounterselect),
			.configupdate(configupdate),
			.phasestep(phasestep),
			.phaseupdown(phaseupdown),
			.scanclkena(scanclkena),
			.phasedone (phasedone),
			.vcooverrange (vcooverrange),
			.vcounderrange (vcounderrange)
		);
	end
	else if( FEATURE_FAMILY_CYCLONEIII( intended_device_family ) ) begin
		if (port_areset != "PORT_UNUSED") begin
			dffep pll_lock_sync_ff (locked_reg, locked_wire, 1'b1, 1'b1, 1'b0, areset);
			assign locked = locked_wire && locked_reg;
		end
		else begin
			assign locked = locked_wire;
		end
		assign feedback = (operation_mode=="NORMAL" || operation_mode=="SOURCE_SYNCHRONOUS" 
					|| operation_mode=="NO_COMPENSATION")? fbout : fbin;

		cycloneiii_pll 
		#(
			.c0_high(c0_high),
			.c0_initial(c0_initial),
			.c0_low(c0_low),
			.c0_mode(c0_mode),
			.c0_ph(c0_ph),
			.c1_high(c1_high),
			.c1_initial(c1_initial),
			.c1_low(c1_low),
			.c1_mode(c1_mode),
			.c1_ph(c1_ph),
			.c1_use_casc_in(c1_use_casc_in),
			.c2_high(c2_high),
			.c2_initial(c2_initial),
			.c2_low(c2_low),
			.c2_mode(c2_mode),
			.c2_ph(c2_ph),
		        .c2_use_casc_in(c2_use_casc_in),
			.c3_high(c3_high),
			.c3_initial(c3_initial),
			.c3_low(c3_low),
			.c3_mode(c3_mode),
			.c3_ph(c3_ph),
			.c3_use_casc_in(c3_use_casc_in),
			.c4_high(c4_high),
			.c4_initial(c4_initial),
			.c4_low(c4_low),
			.c4_mode(c4_mode),
			.c4_ph(c4_ph),
			.c4_use_casc_in(c4_use_casc_in),
			.clk0_output_frequency(clk0_output_frequency),
			.clk1_output_frequency(clk1_output_frequency),
			.clk2_output_frequency(clk2_output_frequency),
			.enable0_counter(enable0_counter),
			.enable1_counter(enable1_counter),
			.lock_high(lock_high),
			.lock_low(lock_low),
			.sclkout0_phase_shift(sclkout0_phase_shift),
			.sclkout1_phase_shift(sclkout1_phase_shift),
			.switch_over_type(switch_over_type),
			.vco_divide_by(vco_divide_by),
			.vco_multiply_by(vco_multiply_by),
			.vco_post_scale(vco_post_scale),
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
 		        .e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
		        .g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (fbin),
			      .clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.scanclk (scanclk),
			.scandata (scandata),
			.clk (clk),
			.clkbad (clkbad),
 			.activeclock (activeclock),
		        .locked (locked_wire),
			.scandataout (scandataout),
			.scandone (scandone),
			.fbout (fbout),
			.phasecounterselect(phasecounterselect),
			.configupdate(configupdate),
			.phasestep(phasestep),
			.phaseupdown(phaseupdown),
			.phasedone (phasedone),
			.vcooverrange (vcooverrange),
			.vcounderrange (vcounderrange),
 			.scanclkena(scanclkena)
		);
	      end
	else if( IS_FAMILY_STRATIXIV( intended_device_family ) ) begin
		if (port_areset != "PORT_UNUSED") begin
			dffep pll_lock_sync_ff (locked_reg, locked_wire, 1'b1, 1'b1, 1'b0, areset);
			assign locked = locked_wire && locked_reg;
		end
		else begin
			assign locked = locked_wire;
		end
		assign feedback = (operation_mode=="NORMAL" || operation_mode=="SOURCE_SYNCHRONOUS" 
					|| operation_mode=="NO_COMPENSATION")? fbout : fbin;

		stratixiv_pll 
		#(
			.c0_high(c0_high),
			.c0_initial(c0_initial),
			.c0_low(c0_low),
			.c0_mode(c0_mode),
			.c0_ph(c0_ph),
			.c1_high(c1_high),
			.c1_initial(c1_initial),
			.c1_low(c1_low),
			.c1_mode(c1_mode),
			.c1_ph(c1_ph),
			.c1_use_casc_in(c1_use_casc_in),
			.c2_high(c2_high),
			.c2_initial(c2_initial),
			.c2_low(c2_low),
			.c2_mode(c2_mode),
			.c2_ph(c2_ph),
			.c2_use_casc_in(c2_use_casc_in),
			.c3_high(c3_high),
			.c3_initial(c3_initial),
			.c3_low(c3_low),
			.c3_mode(c3_mode),
			.c3_ph(c3_ph),
			.c3_use_casc_in(c3_use_casc_in),
			.c4_high(c4_high),
			.c4_initial(c4_initial),
			.c4_low(c4_low),
			.c4_mode(c4_mode),
			.c4_ph(c4_ph),
			.c4_use_casc_in(c4_use_casc_in),
			.c5_high(c5_high),
			.c5_initial(c5_initial),
			.c5_low(c5_low),
			.c5_mode(c5_mode),
			.c5_ph(c5_ph),
			.c5_use_casc_in(c5_use_casc_in),
			.clk0_output_frequency(clk0_output_frequency),
			.clk1_output_frequency(clk1_output_frequency),
			.clk2_output_frequency(clk2_output_frequency),
			.enable0_counter(enable0_counter),
			.enable1_counter(enable1_counter),
			.lock_high(lock_high),
			.lock_low(lock_low),
			.sclkout0_phase_shift(sclkout0_phase_shift),
			.sclkout1_phase_shift(sclkout1_phase_shift),
			.switch_over_type(switch_over_type),
			.vco_divide_by(vco_divide_by),
			.vco_multiply_by(vco_multiply_by),
			.vco_post_scale(vco_post_scale),
			.operation_mode(operation_mode),
			.qualify_conf_done(qualify_conf_done),
			.compensate_clock(compensate_clock),
			.pll_type(pll_type),
			.scan_chain(scan_chain),
			.primary_clock(primary_clock),
			.inclk0_input_frequency(inclk0_input_frequency),
			.inclk1_input_frequency(inclk1_input_frequency),
			.gate_lock_signal(gate_lock_signal),
			.gate_lock_counter(gate_lock_counter),
			.valid_lock_multiplier(valid_lock_multiplier),
			.invalid_lock_multiplier(invalid_lock_multiplier),
			.switch_over_on_lossclk(switch_over_on_lossclk),
			.switch_over_on_gated_lock(switch_over_on_gated_lock),
			.enable_switch_over_counter(enable_switch_over_counter),
			.switch_over_counter(switch_over_counter),
			.feedback_source(feedback_source),
			.bandwidth(bandwidth),
			.bandwidth_type(bandwidth_type),
			.spread_frequency(spread_frequency),
			.down_spread(down_spread),
			.simulation_type(simulation_type),
			.clk5_multiply_by(clk5_multiply_by),
			.clk4_multiply_by(clk4_multiply_by),
			.clk3_multiply_by(clk3_multiply_by),
			.clk2_multiply_by(clk2_multiply_by),
			.clk1_multiply_by(clk1_multiply_by),
			.clk0_multiply_by(clk0_multiply_by),
			.clk5_divide_by(clk5_divide_by),
			.clk4_divide_by(clk4_divide_by),
			.clk3_divide_by(clk3_divide_by),
			.clk2_divide_by(clk2_divide_by),
			.clk1_divide_by(clk1_divide_by),
			.clk0_divide_by(clk0_divide_by),
			.clk5_phase_shift(clk5_phase_shift),
			.clk4_phase_shift(clk4_phase_shift),
			.clk3_phase_shift(clk3_phase_shift),
			.clk2_phase_shift(clk2_phase_shift),
			.clk1_phase_shift(clk1_phase_shift),
			.clk0_phase_shift(clk0_phase_shift),
			.clk5_time_delay(clk5_time_delay),
			.clk4_time_delay(clk4_time_delay),
			.clk3_time_delay(clk3_time_delay),
			.clk2_time_delay(clk2_time_delay),
			.clk1_time_delay(clk1_time_delay),
			.clk0_time_delay(clk0_time_delay),
			.clk5_duty_cycle(clk5_duty_cycle),
			.clk4_duty_cycle(clk4_duty_cycle),
			.clk3_duty_cycle(clk3_duty_cycle),
			.clk2_duty_cycle(clk2_duty_cycle),
			.clk1_duty_cycle(clk1_duty_cycle),
			.clk0_duty_cycle(clk0_duty_cycle),
			.extclk3_multiply_by(extclk3_multiply_by),
			.extclk2_multiply_by(extclk2_multiply_by),
			.extclk1_multiply_by(extclk1_multiply_by),
			.extclk0_multiply_by(extclk0_multiply_by),
			.extclk3_divide_by(extclk3_divide_by),
			.extclk2_divide_by(extclk2_divide_by),
			.extclk1_divide_by(extclk1_divide_by),
			.extclk0_divide_by(extclk0_divide_by),
			.extclk3_phase_shift(extclk3_phase_shift),
			.extclk2_phase_shift(extclk2_phase_shift),
			.extclk1_phase_shift(extclk1_phase_shift),
			.extclk0_phase_shift(extclk0_phase_shift),
			.extclk3_time_delay(extclk3_time_delay),
			.extclk2_time_delay(extclk2_time_delay),
			.extclk1_time_delay(extclk1_time_delay),
			.extclk0_time_delay(extclk0_time_delay),
			.extclk3_duty_cycle(extclk3_duty_cycle),
			.extclk2_duty_cycle(extclk2_duty_cycle),
			.extclk1_duty_cycle(extclk1_duty_cycle),
			.extclk0_duty_cycle(extclk0_duty_cycle),
			.vco_min(vco_min),
			.vco_max(vco_max),
			.vco_center(vco_center),
			.pfd_min(pfd_min),
			.pfd_max(pfd_max),
			.m_initial(m_initial),
			.m(m),
			.n(n),
			.m2(m2),
			.n2(n2),
			.ss(ss),
			.l0_high(l0_high),
			.l1_high(l1_high),
			.g0_high(g0_high),
			.g1_high(g1_high),
			.g2_high(g2_high),
			.g3_high(g3_high),
			.e0_high(e0_high),
			.e1_high(e1_high),
			.e2_high(e2_high),
			.e3_high(e3_high),
			.l0_low(l0_low),
			.l1_low(l1_low),
			.g0_low(g0_low),
			.g1_low(g1_low),
			.g2_low(g2_low),
			.g3_low(g3_low),
			.e0_low(e0_low),
			.e1_low(e1_low),
			.e2_low(e2_low),
			.e3_low(e3_low),
			.l0_initial(l0_initial),
			.l1_initial(l1_initial),
			.g0_initial(g0_initial),
			.g1_initial(g1_initial),
			.g2_initial(g2_initial),
			.g3_initial(g3_initial),
			.e0_initial(e0_initial),
			.e1_initial(e1_initial),
			.e2_initial(e2_initial),
			.e3_initial(e3_initial),
			.l0_mode(l0_mode),
			.l1_mode(l1_mode),
			.g0_mode(g0_mode),
			.g1_mode(g1_mode),
			.g2_mode(g2_mode),
			.g3_mode(g3_mode),
			.e0_mode(e0_mode),
			.e1_mode(e1_mode),
			.e2_mode(e2_mode),
			.e3_mode(e3_mode),
			.l0_ph(l0_ph),
			.l1_ph(l1_ph),
			.g0_ph(g0_ph),
			.g1_ph(g1_ph),
			.g2_ph(g2_ph),
			.g3_ph(g3_ph),
			.e0_ph(e0_ph),
			.e1_ph(e1_ph),
			.e2_ph(e2_ph),
			.e3_ph(e3_ph),
			.m_ph(m_ph),
			.l0_time_delay(l0_time_delay),
			.l1_time_delay(l1_time_delay),
			.g0_time_delay(g0_time_delay),
			.g1_time_delay(g1_time_delay),
			.g2_time_delay(g2_time_delay),
			.g3_time_delay(g3_time_delay),
			.e0_time_delay(e0_time_delay),
			.e1_time_delay(e1_time_delay),
			.e2_time_delay(e2_time_delay),
			.e3_time_delay(e3_time_delay),
			.m_time_delay(m_time_delay),
			.n_time_delay(n_time_delay),
			.extclk3_counter(extclk3_counter),
			.extclk2_counter(extclk2_counter),
			.extclk1_counter(extclk1_counter),
			.extclk0_counter(extclk0_counter),
			.clk5_counter(clk5_counter),
			.clk4_counter(clk4_counter),
			.clk3_counter(clk3_counter),
			.clk2_counter(clk2_counter),
			.clk1_counter(clk1_counter),
			.clk0_counter(clk0_counter),
			.charge_pump_current(charge_pump_current),
			.loop_filter_r(loop_filter_r),
			.loop_filter_c(loop_filter_c)
		) pll0 (
			.inclk (inclk),
			.fbin (feedback),
			.clkswitch (clkswitch),
			.areset (areset),
			.pfdena (pfdena),
			.scanclk (scanclk),
			.scandata (scandata),
			.clk (clk),
			.clkbad (clkbad),
			.activeclock (activeclock),
			.locked (locked_wire),
			.scandataout (scandataout),
			.scandone (scandone),
			.fbout (fbout),
			.phasecounterselect(phasecounterselect),
			.configupdate(configupdate),
			.phasestep(phasestep),
			.phaseupdown(phaseupdown),
			.scanclkena(scanclkena),
			.phasedone (phasedone),
			.vcooverrange (vcooverrange),
			.vcounderrange (vcounderrange)
		);
	end
	endgenerate
endmodule
