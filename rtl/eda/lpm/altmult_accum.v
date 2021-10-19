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
// This version is the 6.1 model with the dffep using positional connections.  
// Modelsim does not like UDPs signals connected by name

// Copyright (C) 1991-2006 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// ALTMULT_ACCUM for Formal Verification ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN

`define W_FRACTION_ROUND 15
`define W_SIGN 2
`define W_MSB 17

module altmult_accum (
// INTERFACE BEGIN
	dataa,datab,                 // multiplicand,multiplier
	accum_sload_upper_data,	     // sync load for upper data bits
	scanina, scaninb,	     // optional inputs to a/b scanchain
	sourcea,sourceb,	     // a/b source
	mult_round,	        // variable control for multiplier rounding
	mult_saturation,        // variable control for multiplier saturation 
	accum_round,	        // variable control for accumulator rounding
	accum_saturation,       // variable control for accumulator saturation 
        addnsub,                     // add/subtract accum mode
        accum_sload,                 // accumulator sync load
        signa,signb,                 // sign bits
        clock0,clock1,clock2,clock3, // clock inputs clk[3:0]
	ena0,ena1,ena2,ena3,         // clock enable inputs ena[3:0]
        aclr0,aclr1,aclr2,aclr3,     // async clear inputs [3:0]
        result,                      // result
        overflow,                    // overflow/underflow from accumulator
        scanouta,scanoutb,            // scan out
	mult_is_saturated,accum_is_saturated // mult/accum saturated flags
);
// INTERFACE END
//// top level parameters ////

parameter width_a               = 1;              // Width of the dataa[] operand of each multiplier.
parameter width_b               = 1;              // Width of the datab[] operand of each multiplier.
parameter width_result          = 1;              // Width of the result[] of each multiplier.
parameter width_upper_data      = 1; // Upper data width for sload
parameter lpm_type              = "altmult_accum";  // lpm type
parameter lpm_hint              = "UNUSED"; 

//// A port related parameters ////

// Input registers for A

parameter input_source_a  = "DATAA"; // Input source for dataa input
parameter input_reg_a  = "CLOCK0";
parameter input_aclr_a = "ACLR3";

// Sign representation for A
parameter representation_a       = "UNSIGNED";

// signa port registers/pipeline

parameter sign_reg_a             = "CLOCK0";
parameter sign_aclr_a            = "ACLR3";
parameter sign_pipeline_reg_a    = "CLOCK0";
parameter sign_pipeline_aclr_a   = "ACLR3";

// Input registers for B 

parameter input_source_b  = "DATAB"; // Input source for datab input
parameter input_reg_b   = "CLOCK0";
parameter input_aclr_b  = "ACLR3";

// Sign representation for B
parameter representation_b       = "UNSIGNED";

// signb port registers/pipeline

parameter sign_reg_b             = "CLOCK0";
parameter sign_aclr_b            = "ACLR3";
parameter sign_pipeline_reg_b    = "CLOCK0";
parameter sign_pipeline_aclr_b   = "ACLR3";

// addnsub register/pipe clock/clear
parameter addnsub_reg               = "CLOCK0";
parameter addnsub_aclr              = "ACLR3";
parameter addnsub_pipeline_reg      = "CLOCK0";
parameter addnsub_pipeline_aclr     = "ACLR3";

// accumulator direction
parameter accum_direction           = "ADD";

// accumulator sload clock/clear
parameter accum_sload_reg           = "CLOCK0";
parameter accum_sload_aclr          = "ACLR3";
parameter accum_sload_pipeline_reg  = "CLOCK0";
parameter accum_sload_pipeline_aclr = "ACLR3";

// multiplier output reg/clear

parameter multiplier_reg            = "CLOCK0";
parameter multiplier_aclr           = "ACLR3";

// output register/clear

parameter output_reg                = "CLOCK0";
parameter output_aclr               = "ACLR3";


// misc

parameter extra_multiplier_latency       = 0;
parameter extra_accumulator_latency      = 0;
parameter dedicated_multiplier_circuitry = "AUTO";
parameter dsp_block_balancing            = "Auto";
parameter intended_device_family         = "UNUSED";

parameter port_addnsub 			= "PORT_CONNECTIVITY";
parameter port_signa 			= "PORT_CONNECTIVITY";
parameter port_signb 			= "PORT_CONNECTIVITY";

// saturation and rounding

parameter mult_saturation_reg = "CLOCK0";
parameter mult_saturation_aclr = "ACLR3";
parameter mult_round_reg = "CLOCK0";
parameter mult_round_aclr = "ACLR3";

parameter accum_saturation_reg = "CLOCK0";
parameter accum_saturation_aclr = "ACLR3";
parameter accum_saturation_pipeline_reg = "CLOCK0";
parameter accum_saturation_pipeline_aclr = "ACLR3";

parameter accum_round_reg = "CLOCK0";
parameter accum_round_aclr = "ACLR3";
parameter accum_round_pipeline_reg = "CLOCK0";
parameter accum_round_pipeline_aclr = "ACLR3";

parameter multiplier_rounding = "NO";
parameter multiplier_saturation = "NO";
parameter accumulator_rounding = "NO";
parameter accumulator_saturation = "NO";
parameter port_mult_is_saturated = "UNUSED";
parameter port_accum_is_saturated = "UNUSED";


// Upper data
parameter accum_sload_upper_data_aclr = "ACLR3";
parameter accum_sload_upper_data_pipeline_aclr = "ACLR3";
parameter accum_sload_upper_data_pipeline_reg = "CLOCK0";
parameter accum_sload_upper_data_reg = "CLOCK0";

// Local parameters
parameter max_width = ( width_a >= width_b ) ? width_a : width_b;

`ifdef MULT_NORMALIZE_SIZE
parameter normalized_width = ( dedicated_multiplier_circuitry != "NO" ) ?
    ( ( max_width <= 9 ) ? 9 : ( ( max_width <= 18 ) ? 18 : max_width ) ) : 1;
`else
parameter normalized_width = 1;
`endif

// when accum saturation is enabled,
// accumulator always accumulates to 48 or 49 bits  (18.30/18.31 output)
parameter width_accum_output = (width_result == 49)? 49 : 48; 
parameter width_output = (accumulator_rounding !="NO" || 
			accumulator_saturation !="NO")? width_accum_output :
			  width_result;
localparam width_sign_accum_rs = width_output - 
										(2*`W_FRACTION_ROUND + (width_output % 2));

//// constants ////
//// variables ////
//// port declarations ////

// data input ports
input [width_a - 1 : 0] dataa;
input [width_b - 1 : 0] datab;
input [width_result-1:width_result-width_upper_data] accum_sload_upper_data;

// scan input ports
input [width_a - 1 : 0] scanina;
input [width_b - 1 : 0] scaninb;

input sourcea;
input sourceb;
input mult_round;
input mult_saturation;
input accum_round;
input accum_saturation;

// clock ports
input clock3;
input clock2;
input clock1;
input clock0;

// asynch clear ports
input aclr3;
input aclr2;
input aclr1;
input aclr0;

// clock enable ports
input ena3;
input ena2;
input ena1;
input ena0;

// control signals
input signa;            // sign of dataa
input signb;            // sign of datab
input addnsub;          // addnsub   (accumulator)
input accum_sload;      // sync load (accumulator)

// output ports
output [width_result -1 : 0] result;
output overflow;
output [width_a -1 : 0] scanouta;
output [width_b -1 : 0] scanoutb;

output mult_is_saturated;
output accum_is_saturated;

//// nets/registers ////

// Data in registers

wire [width_a - 1 : 0] dataa_reg;
wire [width_b - 1 : 0] datab_reg;

// Clocks
wire input_reg_a_clk; // input A reg clock
wire input_reg_b_clk; // input B reg clock

wire addsub_reg_clk,addsub_pipe_clk; // addnsub reg/pipe clocks
wire accum_sload_reg_clk,accum_sload_pipe_clk; // accum sload reg/pipe clocks

wire sign_reg_a_clk,sign_pipe_a_clk; // signa reg/pipe clocks
wire sign_reg_b_clk,sign_pipe_b_clk; // signb reg/pipe clocks

wire multiplier_reg_clk; // multiplier reg clock
wire multiplier_pipe_clk;// multiplier pipe clock
wire output_reg_clk;     // output register clock

// Asynch Clears
wire input_reg_a_clr; // input A reg aclr
wire input_reg_b_clr; // input B reg aclr

wire addsub_reg_clr,addsub_pipe_clr;  // addsub reg/pipe aclr
wire accum_sload_reg_clr,accum_sload_pipe_clr; // accum sload reg/pipe aclr

wire sign_reg_a_clr,sign_pipe_a_clr;  // signa reg/pipe aclr
wire sign_reg_b_clr,sign_pipe_b_clr;  // signb reg/pipe aclr

wire multiplier_reg_clr; // multiplier reg aclr
wire multiplier_pipe_clr;// multiplier pipe aclr
wire output_reg_clr;     // output register aclr

// Clock enables
wire input_reg_a_en;     // input A reg enable
wire input_reg_b_en;     // input B reg enable

wire addsub_reg_en,addsub_pipe_en;  // addnsub1 reg/pipe enable
wire accum_sload_reg_en,accum_sload_pipe_en; // accum sload reg/pipe clock enables

wire sign_reg_a_en,sign_pipe_a_en;  // signa reg/pipe enable
wire sign_reg_b_en,sign_pipe_b_en;  // signb reg/pipe enable

wire multiplier_reg_en;  // multiplier reg enable
wire multiplier_pipe_en; // multiplier pipe enable
wire output_reg_en;      // output register enable


wire signa_rev,signb_rev;

wire  signa_in_reg,signa_in_pipe;                                              // signa reg/pipe
wire signa_reg,signa_pipe;
wire  signb_in_reg,signb_in_pipe;                                              // signb reg/pipe
wire signb_reg,signb_pipe;

//latency
wire signb_late, signb_reg_delayed;
wire signa_late, signa_reg_delayed;
wire addsub_late, addsub_reg_delayed;
wire accum_sload_late, accum_sload_reg_delayed;
wire accum_is_sat_delayed, accum_sat_late;
wire mult_is_sat_delayed, mult_sat_late;

wire addnsub_rev;

wire  addsub_in_reg,addsub_in_pipe;                                              // addsub reg/pipe
wire addsub_reg,addsub_pipe;

wire  accum_sload_in_reg,accum_sload_in_pipe;                                    // accum_sload reg/pipe
wire accum_sload_reg_out,accum_sload_pipe;

// Multiplier registered inputs

wire [width_a - 1 : 0] mult_a_in;
wire [width_b - 1 : 0] mult_b_in;

// Multiplier outputs

wire [width_a + width_b - 1 : 0] mult_out;

// Multiplier registered outputs

wire  [width_a + width_b - 1 : 0] mult_reg;
wire [width_a + width_b - 1 : 0] mult_reg_out,mult_out_delayed;

// Accumulator input/outputs

wire [width_output - 1 : 0] accum_in;
wire [width_output - 1 : 0] accum_in_2;

// Accumulator registered output

wire  [width_output - 1 : 0] add_reg;
wire [width_output : 0] accum_out;
wire [width_output - 1 : 0] accum_reg_out,accum_out_delayed;

// Accumulator overflow

wire  overflow_reg ;
wire overflow_out , overflow_out_delayed , cout;

// data/scanin input
wire [ width_a-1 : 0 ] dataa_in;
wire [ width_b-1 : 0 ] datab_in;

// upper data sload
wire accum_sload_upper_data_reg_clk;
wire accum_sload_upper_data_pipe_clk;
wire accum_sload_upper_data_reg_en;
wire accum_sload_upper_data_pipe_en;
wire accum_sload_upper_data_reg_clr;
wire accum_sload_upper_data_pipe_clr;

wire [width_result-1:width_result-width_upper_data] accum_sload_upper_data_in_reg;
wire [width_result-1:width_result-width_upper_data] accum_sload_upper_data_in_pipe;
wire [width_result-1:width_result-width_upper_data] accum_sload_upper_data_reg_out;
wire [width_result-1:width_result-width_upper_data] accum_sload_upper_data_pipe;

// multiplier rounding/saturation
wire mult_round_clk, mult_round_en, mult_round_clr;
wire mult_round_signal_reg, mult_round_in_reg;
wire [width_a+width_b-1: 0] mult_rs_output;

wire mult_saturation_clk, mult_saturation_clr, mult_saturation_en;
wire mult_saturation_signal_reg, mult_saturation_in_reg;
wire mult_sat_overflow;

// accumulator rounding/saturation
wire [width_output : 0] accum_rs_output;

wire accum_round_clk, accum_round_en, accum_round_clr;
wire accum_round_signal_reg, accum_round_in_reg;

wire accum_round_pipe_clk, accum_round_pipe_clr, accum_round_pipe_en;
wire accum_round_pipe_signal_reg, accum_round_pipe_in_reg;
wire accum_sat_overflow, accum_is_sat_signal, accum_is_sat_reg;

wire accum_saturation_clk, accum_saturation_en, accum_saturation_clr;
wire accum_saturation_pipe_clk, accum_saturation_pipe_en, accum_saturation_pipe_clr;
wire accum_saturation_signal_reg, accum_saturation_pipe_signal_reg;
wire accum_saturation_in_reg, accum_saturation_pipe_in_reg;

// IMPLEMENTATION BEGIN
//////////////////////////// asynchronous logic ////////////////////////////////////////
// Dynamic Source Switching between data and scan

assign dataa_in = ((input_source_a =="DATAA") || 
		   (input_source_a =="VARIABLE" && sourcea == 1'b0))? dataa : 
			scanina;
assign datab_in = ((input_source_b =="DATAB") ||
                   (input_source_b =="VARIABLE" && sourceb == 1'b0))? datab : 
			scaninb;

// ************** Multiplier  *************** //

assign mult_a_in = (input_reg_a == "UNREGISTERED") ? dataa_in : dataa_reg;
assign mult_b_in = (input_reg_b == "UNREGISTERED") ? datab_in : datab_reg;

mult_block #(
	.width_a(width_a),
	.width_b(width_b),
	.normalized_width(normalized_width)
) mult (
	.dataa(mult_a_in),
	.datab(mult_b_in),
	.signa(signa_reg),.signb(signb_reg),
	.product(mult_out)
);

// ************** Multiplier Round & Saturation ************ //
generate
if (multiplier_rounding !="NO" || multiplier_saturation !="NO")
begin

rs_block #( `W_SIGN , width_a+width_b, `W_MSB ) mult_rs (
	.rs_output(mult_rs_output),
	.sat_overflow(mult_sat_overflow),
	.round(multiplier_rounding=="YES" || (multiplier_rounding=="VARIABLE" && mult_round_signal_reg == 1'b1)),
	.saturate(multiplier_saturation=="YES" || (multiplier_saturation=="VARIABLE" && mult_saturation_signal_reg == 1'b1)),
	.datain(mult_out),
	.sign(signa_pipe|signb_pipe)
	);




end
else
    assign mult_rs_output = mult_out;
endgenerate

	
// ************** Accumulator block ******************** //
assign accum_in = (accum_sload_pipe == 1'b1) ? 
         {{width_output-width_result{accum_sload_upper_data_pipe[width_result-1] & (signa_pipe | signb_pipe)}},
	accum_sload_upper_data_pipe, {width_result-width_upper_data{1'b0}}} : (
		(extra_accumulator_latency > 0)? accum_out_delayed : accum_reg_out
		);

generate if (width_output > (width_a+width_b)) 
assign accum_in_2 = 
	{{(width_output-width_a-width_b){mult_reg_out[width_a+width_b-1] & 
	   (signa_pipe | signb_pipe)}},mult_reg_out} ;
else
assign accum_in_2 =
	mult_reg_out[width_a+width_b-1 : 0];
endgenerate

addsub_block #(width_output, width_output) accum (
	.dataa(accum_in),.datab(accum_in_2),
   .signa(signa_pipe | signb_pipe),
	.signb(signa_pipe | signb_pipe),
	.addsub(addsub_pipe),
	.sum(accum_out)
	);
// ************** Accumulator Round & Saturation ************ //
generate
if (accumulator_rounding !="NO" || accumulator_saturation !="NO")
begin

rs_block #( width_sign_accum_rs,
		width_output,
		width_sign_accum_rs+`W_FRACTION_ROUND ) accum_rs (
        .rs_output(accum_rs_output),
	.sat_overflow(accum_sat_overflow),
        .round(accumulator_rounding=="YES" || (accumulator_rounding=="VARIABLE" && accum_round_pipe_signal_reg == 1'b1)),
        .saturate(accumulator_saturation=="YES" || (accumulator_saturation=="VARIABLE" && accum_saturation_pipe_signal_reg == 1'b1)),
        .datain(accum_out[width_output:0]),
        .sign(signa_pipe|signb_pipe)
        );

assign accum_is_sat_signal = (accumulator_saturation=="YES" ||
          (accumulator_saturation=="VARIABLE" && accum_saturation_pipe_signal_reg == 1'b1)) && (accum_sat_overflow);
 
end
else
begin
  assign accum_rs_output = accum_out;
end
endgenerate
/////////////////////////// net assignments //////////////////////////

//////// Register/Pipeline clocks /////////
// input A register clock
assign input_reg_a_clk = 
	((input_reg_a == "CLOCK0") ? clock0
		: ((input_reg_a == "CLOCK1") ? clock1 
			: ((input_reg_a == "CLOCK2") ? clock2
				: ((input_reg_a == "CLOCK3") ? clock3
				: 1'b0))));

// input B register clock
assign input_reg_b_clk = 
	((input_reg_b == "CLOCK0") ? clock0
		: ((input_reg_b == "CLOCK1") ? clock1 
			: ((input_reg_b == "CLOCK2") ? clock2
				: ((input_reg_b == "CLOCK3") ? clock3
				: 1'b0))));


// addsub register clock
assign addsub_reg_clk = 
	((addnsub_reg == "CLOCK0") ? clock0
		: ((addnsub_reg == "CLOCK1") ? clock1 
			: ((addnsub_reg == "CLOCK2") ? clock2
				: ((addnsub_reg == "CLOCK3") ? clock3
				: 1'b0))));

// addsub pipeline clock
assign addsub_pipe_clk = 
	((addnsub_pipeline_reg == "CLOCK0") ? clock0
		: ((addnsub_pipeline_reg == "CLOCK1") ? clock1 
			: ((addnsub_pipeline_reg == "CLOCK2") ? clock2
				: ((addnsub_pipeline_reg == "CLOCK3") ? clock3
				: 1'b0))));

// accum sload register clock
assign accum_sload_reg_clk =
        ((accum_sload_reg == "CLOCK0") ? clock0
                : ((accum_sload_reg == "CLOCK1") ? clock1
                        : ((accum_sload_reg == "CLOCK2") ? clock2
                                : ((accum_sload_reg == "CLOCK3") ? clock3
                                : 1'b0))));

// accum sload pipeline clock 
assign accum_sload_pipe_clk = 
        ((accum_sload_pipeline_reg == "CLOCK0") ? clock0
                : ((accum_sload_pipeline_reg == "CLOCK1") ? clock1
                        : ((accum_sload_pipeline_reg == "CLOCK2") ? clock2
                                : ((accum_sload_pipeline_reg == "CLOCK3") ? clock3
                                : 1'b0))));

// sign register clocks
assign sign_reg_a_clk = 
	((sign_reg_a == "CLOCK0") ? clock0
		: ((sign_reg_a == "CLOCK1") ? clock1 
			: ((sign_reg_a == "CLOCK2") ? clock2
				: ((sign_reg_a == "CLOCK3") ? clock3
				: 1'b0))));


assign sign_reg_b_clk = 
	((sign_reg_b == "CLOCK0") ? clock0
		: ((sign_reg_b == "CLOCK1") ? clock1 
			: ((sign_reg_b == "CLOCK2") ? clock2
				: ((sign_reg_b == "CLOCK3") ? clock3
				: 1'b0))));


// sign pipe clocks
assign sign_pipe_a_clk = 
	((sign_pipeline_reg_a == "CLOCK0") ? clock0
		: ((sign_pipeline_reg_a == "CLOCK1") ? clock1 
			: ((sign_pipeline_reg_a == "CLOCK2") ? clock2
				: ((sign_pipeline_reg_a == "CLOCK3") ? clock3
				: 1'b0))));


assign sign_pipe_b_clk = 
	((sign_pipeline_reg_b == "CLOCK0") ? clock0
		: ((sign_pipeline_reg_b == "CLOCK1") ? clock1 
			: ((sign_pipeline_reg_b == "CLOCK2") ? clock2
				: ((sign_pipeline_reg_b == "CLOCK3") ? clock3
				: 1'b0))));

// mult round clk
assign mult_round_clk =
        ((mult_round_reg == "CLOCK0") ? clock0
                : ((mult_round_reg == "CLOCK1") ? clock1
                        : ((mult_round_reg == "CLOCK2") ? clock2
                                : ((mult_round_reg == "CLOCK3") ? clock3
                                : 1'b0))));

// mult saturation clk
assign mult_saturation_clk =
        ((mult_saturation_reg == "CLOCK0") ? clock0
                : ((mult_saturation_reg == "CLOCK1") ? clock1
                        : ((mult_saturation_reg == "CLOCK2") ? clock2
                                : ((mult_saturation_reg == "CLOCK3") ? clock3
                                : 1'b0))));

// accum round clk
assign accum_round_clk =
        ((accum_round_reg == "CLOCK0") ? clock0
                : ((accum_round_reg == "CLOCK1") ? clock1
                        : ((accum_round_reg == "CLOCK2") ? clock2
                                : ((accum_round_reg == "CLOCK3") ? clock3
                                : 1'b0))));

// accum round pipeline clk
assign accum_round_pipe_clk =
            ((accum_round_pipeline_reg == "CLOCK0") ? clock0
                : ((accum_round_pipeline_reg == "CLOCK1") ? clock1
                    : ((accum_round_pipeline_reg == "CLOCK2") ? clock2
                        : ((accum_round_pipeline_reg == "CLOCK3") ? clock3
                            : 1'b0))));

// accum saturation clk
assign accum_saturation_clk =
        ((accum_saturation_reg == "CLOCK0") ? clock0
                : ((accum_saturation_reg == "CLOCK1") ? clock1
                        : ((accum_saturation_reg == "CLOCK2") ? clock2
                                : ((accum_saturation_reg == "CLOCK3") ? clock3
                                : 1'b0))));

// accum saturation pipeline clk
assign accum_saturation_pipe_clk =
            ((accum_saturation_pipeline_reg == "CLOCK0") ? clock0
                : ((accum_saturation_pipeline_reg == "CLOCK1") ? clock1
                    : ((accum_saturation_pipeline_reg == "CLOCK2") ? clock2
                        : ((accum_saturation_pipeline_reg == "CLOCK3") ? clock3
                            : 1'b0))));

// multiplier register/pipeline clock 
assign multiplier_reg_clk = 
	((multiplier_reg == "CLOCK0") ? clock0
		: ((multiplier_reg == "CLOCK1") ? clock1 
			: ((multiplier_reg == "CLOCK2") ? clock2
				: ((multiplier_reg == "CLOCK3") ? clock3
				: 1'b0))));
assign multiplier_pipe_clk = (multiplier_reg == "UNREGISTERED") ? clock0 : multiplier_reg_clk;

// output register clock
assign output_reg_clk = 
	((output_reg == "CLOCK0") ? clock0
		: ((output_reg == "CLOCK1") ? clock1 
			: ((output_reg == "CLOCK2") ? clock2
				: ((output_reg == "CLOCK3") ? clock3
				: 1'b0))));

// accum sload upper data register clock
assign accum_sload_upper_data_reg_clk =
     ((accum_sload_upper_data_reg == "CLOCK0") ? clock0
       : ((accum_sload_upper_data_reg == "CLOCK1") ? clock1
             : ((accum_sload_upper_data_reg == "CLOCK2") ? clock2
                  : ((accum_sload_upper_data_reg == "CLOCK3") ? clock3
                                : 1'b0))));

// accum sload_upper_data pipeline clock
assign accum_sload_upper_data_pipe_clk =
   ((accum_sload_upper_data_pipeline_reg == "CLOCK0") ? clock0
       : ((accum_sload_upper_data_pipeline_reg == "CLOCK1") ? clock1
             : ((accum_sload_upper_data_pipeline_reg == "CLOCK2") ? clock2
                  : ((accum_sload_upper_data_pipeline_reg == "CLOCK3") ? clock3
                                : 1'b0))));


//////// Register/Pipeline async clear /////////
// input A register clear
assign input_reg_a_clr = 
	((input_aclr_a == "ACLR0") ? aclr0
                : ((input_aclr_a == "ACLR1") ? aclr1
                        : ((input_aclr_a == "ACLR2") ? aclr2
                                : ((input_aclr_a == "ACLR3") ? aclr3
                                : 1'b0))));

// input B register clear
assign input_reg_b_clr = 
	((input_aclr_b == "ACLR0") ? aclr0
                : ((input_aclr_b == "ACLR1") ? aclr1
                        : ((input_aclr_b == "ACLR2") ? aclr2
                                : ((input_aclr_b == "ACLR3") ? aclr3
                                : 1'b0))));


// addsub register/pipe clear signal
assign addsub_reg_clr = 
	((addnsub_aclr == "ACLR0") ? aclr0
                : ((addnsub_aclr == "ACLR1") ? aclr1
                        : ((addnsub_aclr == "ACLR2") ? aclr2
                                : ((addnsub_aclr == "ACLR3") ? aclr3
                                : 1'b0))));


assign addsub_pipe_clr = 
	((addnsub_pipeline_aclr == "ACLR0") ? aclr0
                : ((addnsub_pipeline_aclr == "ACLR1") ? aclr1
                        : ((addnsub_pipeline_aclr == "ACLR2") ? aclr2
                                : ((addnsub_pipeline_aclr == "ACLR3") ? aclr3
                                : 1'b0))));

// accum sload register/pipe clear
assign accum_sload_reg_clr = 
	((accum_sload_aclr == "ACLR0") ? aclr0
                : ((accum_sload_aclr == "ACLR1") ? aclr1
                        : ((accum_sload_aclr == "ACLR2") ? aclr2
                                : ((accum_sload_aclr == "ACLR3") ? aclr3
                                : 1'b0))));


assign accum_sload_pipe_clr = 
	((accum_sload_pipeline_aclr == "ACLR0") ? aclr0
                : ((accum_sload_pipeline_aclr == "ACLR1") ? aclr1
                        : ((accum_sload_pipeline_aclr == "ACLR2") ? aclr2
                                : ((accum_sload_pipeline_aclr == "ACLR3") ? aclr3
                                : 1'b0))));

// accum sload register/pipe clear
assign accum_sload_upper_data_reg_clr =
        ((accum_sload_upper_data_aclr == "ACLR0") ? aclr0
             : ((accum_sload_upper_data_aclr == "ACLR1") ? aclr1
                    : ((accum_sload_upper_data_aclr == "ACLR2") ? aclr2
                           : ((accum_sload_upper_data_aclr == "ACLR3") ? aclr3
                                : 1'b0))));


assign accum_sload_upper_data_pipe_clr =
        ((accum_sload_upper_data_pipeline_aclr == "ACLR0") ? aclr0
            : ((accum_sload_upper_data_pipeline_aclr == "ACLR1") ? aclr1
                    : ((accum_sload_upper_data_pipeline_aclr == "ACLR2") ? aclr2
                            : ((accum_sload_upper_data_pipeline_aclr == "ACLR3") ? aclr3
                                : 1'b0))));


// sign register clear signals
assign sign_reg_a_clr = 
	((sign_aclr_a == "ACLR0") ? aclr0
                : ((sign_aclr_a == "ACLR1") ? aclr1
                        : ((sign_aclr_a == "ACLR2") ? aclr2
                                : ((sign_aclr_a == "ACLR3") ? aclr3
                                : 1'b0))));


assign sign_reg_b_clr = 
	((sign_aclr_b == "ACLR0") ? aclr0
                : ((sign_aclr_b == "ACLR1") ? aclr1
                        : ((sign_aclr_b == "ACLR2") ? aclr2
                                : ((sign_aclr_b == "ACLR3") ? aclr3
                                : 1'b0))));


assign sign_pipe_a_clr = 
	((sign_pipeline_aclr_a == "ACLR0") ? aclr0
                : ((sign_pipeline_aclr_a == "ACLR1") ? aclr1
                        : ((sign_pipeline_aclr_a == "ACLR2") ? aclr2
                                : ((sign_pipeline_aclr_a == "ACLR3") ? aclr3
                                : 1'b0))));


assign sign_pipe_b_clr = 
	((sign_pipeline_aclr_b == "ACLR0") ? aclr0
                : ((sign_pipeline_aclr_b == "ACLR1") ? aclr1
                        : ((sign_pipeline_aclr_b == "ACLR2") ? aclr2
                                : ((sign_pipeline_aclr_b == "ACLR3") ? aclr3
                                : 1'b0))));

// mult round clear
assign mult_round_clr =
        ((mult_round_aclr == "ACLR0") ? aclr0
                : ((mult_round_aclr == "ACLR1") ? aclr1
                        : ((mult_round_aclr == "ACLR2") ? aclr2
                                : ((mult_round_aclr == "ACLR3") ? aclr3
                                : 1'b0))));

// mult saturation clear
assign mult_saturation_clr =
        ((mult_saturation_aclr == "ACLR0") ? aclr0
                : ((mult_saturation_aclr == "ACLR1") ? aclr1
                        : ((mult_saturation_aclr == "ACLR2") ? aclr2
                                : ((mult_saturation_aclr == "ACLR3") ? aclr3
                                : 1'b0))));

// accum round clear
assign accum_round_clr =
        ((accum_round_aclr == "ACLR0") ? aclr0
                : ((accum_round_aclr == "ACLR1") ? aclr1
                        : ((accum_round_aclr == "ACLR2") ? aclr2
                                : ((accum_round_aclr == "ACLR3") ? aclr3
                                : 1'b0))));

// accum round pipeline clear
assign accum_round_pipe_clr =
            ((accum_round_pipeline_aclr == "ACLR0") ? aclr0
                : ((accum_round_pipeline_aclr == "ACLR1") ? aclr1
                    : ((accum_round_pipeline_aclr == "ACLR2") ? aclr2
                        : ((accum_round_pipeline_aclr == "ACLR3") ? aclr3
                            : 1'b0))));

// accum saturation clear
assign accum_saturation_clr =
        ((accum_saturation_aclr == "ACLR0") ? aclr0
                : ((accum_saturation_aclr == "ACLR1") ? aclr1
                        : ((accum_saturation_aclr == "ACLR2") ? aclr2
                                : ((accum_saturation_aclr == "ACLR3") ? aclr3
                                : 1'b0))));

// accum saturation pipeline clear
assign accum_saturation_pipe_clr =
            ((accum_saturation_pipeline_aclr == "ACLR0") ? aclr0
                : ((accum_saturation_pipeline_aclr == "ACLR1") ? aclr1
                    : ((accum_saturation_pipeline_aclr == "ACLR2") ? aclr2
                        : ((accum_saturation_pipeline_aclr == "ACLR3") ? aclr3
                            : 1'b0))));


// multiplier register/pipeline clear signals
assign multiplier_reg_clr = 
	((multiplier_aclr == "ACLR0") ? aclr0
                : ((multiplier_aclr == "ACLR1") ? aclr1
                        : ((multiplier_aclr == "ACLR2") ? aclr2
                                : ((multiplier_aclr == "ACLR3") ? aclr3
                                : 1'b0))));
assign multiplier_pipe_clr = (multiplier_reg == "UNREGISTERED") ? aclr0 : multiplier_reg_clr;

// output register clear signals
assign output_reg_clr = 
	((output_aclr == "ACLR0") ? aclr0
                : ((output_aclr == "ACLR1") ? aclr1
                        : ((output_aclr == "ACLR2") ? aclr2
                                : ((output_aclr == "ACLR3") ? aclr3
                                : 1'b0))));

//////// Register/Pipeline clock enables ////////
// input A register enable
assign input_reg_a_en = 
	((input_reg_a == "CLOCK0") ? ena0 
                : ((input_reg_a == "CLOCK1") ? ena1
                        : ((input_reg_a == "CLOCK2") ? ena2
                                : ((input_reg_a == "CLOCK3") ? ena3
                                : 1'b1))));

// input B register enable
assign input_reg_b_en = 
	((input_reg_b == "CLOCK0") ? ena0 
                : ((input_reg_b == "CLOCK1") ? ena1
                        : ((input_reg_b == "CLOCK2") ? ena2
                                : ((input_reg_b == "CLOCK3") ? ena3
                                : 1'b1))));

// addsub register enables
assign addsub_reg_en = 
	((addnsub_reg == "CLOCK0") ? ena0 
                : ((addnsub_reg == "CLOCK1") ? ena1
                        : ((addnsub_reg == "CLOCK2") ? ena2
                                : ((addnsub_reg == "CLOCK3") ? ena3
                                : 1'b1))));

assign addsub_pipe_en = 
	((addnsub_pipeline_reg == "CLOCK0") ? ena0 
                : ((addnsub_pipeline_reg == "CLOCK1") ? ena1
                        : ((addnsub_pipeline_reg == "CLOCK2") ? ena2
                                : ((addnsub_pipeline_reg == "CLOCK3") ? ena3
                                : 1'b1))));
// accum sload register enable 
assign accum_sload_reg_en =
        ((accum_sload_reg == "CLOCK0") ? ena0
                : ((accum_sload_reg == "CLOCK1") ? ena1
                        : ((accum_sload_reg == "CLOCK2") ? ena2
                                : ((accum_sload_reg == "CLOCK3") ? ena3
                                : 1'b1))));

// accum sload pipeline enable
assign accum_sload_pipe_en =
        ((accum_sload_pipeline_reg == "CLOCK0") ? ena0
                : ((accum_sload_pipeline_reg == "CLOCK1") ? ena1
                        : ((accum_sload_pipeline_reg == "CLOCK2") ? ena2
                                : ((accum_sload_pipeline_reg == "CLOCK3") ? ena3
                                : 1'b1))));

// accum sload upper data register enable
assign accum_sload_upper_data_reg_en =
    ((accum_sload_upper_data_reg == "CLOCK0") ? ena0
         : ((accum_sload_upper_data_reg == "CLOCK1") ? ena1
                 : ((accum_sload_upper_data_reg == "CLOCK2") ? ena2
                       : ((accum_sload_upper_data_reg == "CLOCK3") ? ena3
                                : 1'b1))));

// accum sload upper_data_pipeline enable
assign accum_sload_upper_data_pipe_en =
    ((accum_sload_upper_data_pipeline_reg == "CLOCK0") ? ena0
         : ((accum_sload_upper_data_pipeline_reg == "CLOCK1") ? ena1
                : ((accum_sload_upper_data_pipeline_reg == "CLOCK2") ? ena2
                       : ((accum_sload_upper_data_pipeline_reg == "CLOCK3") ? ena3
                                : 1'b1))));


// sign register/pipe enables
assign sign_reg_a_en = 
	((sign_reg_a == "CLOCK0") ? ena0 
                : ((sign_reg_a == "CLOCK1") ? ena1
                        : ((sign_reg_a == "CLOCK2") ? ena2
                                : ((sign_reg_a == "CLOCK3") ? ena3
                                : 1'b1))));


assign sign_reg_b_en = 
	((sign_reg_b == "CLOCK0") ? ena0 
                : ((sign_reg_b == "CLOCK1") ? ena1
                        : ((sign_reg_b == "CLOCK2") ? ena2
                                : ((sign_reg_b == "CLOCK3") ? ena3
                                : 1'b1))));


assign sign_pipe_a_en = 
	((sign_pipeline_reg_a == "CLOCK0") ? ena0 
                : ((sign_pipeline_reg_a == "CLOCK1") ? ena1
                        : ((sign_pipeline_reg_a == "CLOCK2") ? ena2
                                : ((sign_pipeline_reg_a == "CLOCK3") ? ena3
                                : 1'b1))));


assign sign_pipe_b_en = 
	((sign_pipeline_reg_b == "CLOCK0") ? ena0 
                : ((sign_pipeline_reg_b == "CLOCK1") ? ena1
                        : ((sign_pipeline_reg_b == "CLOCK2") ? ena2
                                : ((sign_pipeline_reg_b == "CLOCK3") ? ena3
                                : 1'b1))));

// mult round en
assign mult_round_en =
        ((mult_round_reg == "CLOCK0") ? ena0
                : ((mult_round_reg == "CLOCK1") ? ena1
                        : ((mult_round_reg == "CLOCK2") ? ena2
                                : ((mult_round_reg == "CLOCK3") ? ena3
                                : 1'b0))));

// mult saturation en
assign mult_saturation_en =
        ((mult_saturation_reg == "CLOCK0") ? ena0
                : ((mult_saturation_reg == "CLOCK1") ? ena1
                        : ((mult_saturation_reg == "CLOCK2") ? ena2
                                : ((mult_saturation_reg == "CLOCK3") ? ena3
                                : 1'b0))));

// accum round en
assign accum_round_en =
        ((accum_round_reg == "CLOCK0") ? ena0
                : ((accum_round_reg == "CLOCK1") ? ena1
                        : ((accum_round_reg == "CLOCK2") ? ena2
                                : ((accum_round_reg == "CLOCK3") ? ena3
                                : 1'b0))));

// accum round pipeline en
assign accum_round_pipe_en =
            ((accum_round_pipeline_reg == "CLOCK0") ? ena0
                : ((accum_round_pipeline_reg == "CLOCK1") ? ena1
                    : ((accum_round_pipeline_reg == "CLOCK2") ? ena2
                        : ((accum_round_pipeline_reg == "CLOCK3") ? ena3
                            : 1'b0))));

// accum saturation en
assign accum_saturation_en =
        ((accum_saturation_reg == "CLOCK0") ? ena0
                : ((accum_saturation_reg == "CLOCK1") ? ena1
                        : ((accum_saturation_reg == "CLOCK2") ? ena2
                                : ((accum_saturation_reg == "CLOCK3") ? ena3
                                : 1'b0))));

// accum saturation pipeline en
assign accum_saturation_pipe_en =
            ((accum_saturation_pipeline_reg == "CLOCK0") ? ena0
                : ((accum_saturation_pipeline_reg == "CLOCK1") ? ena1
                    : ((accum_saturation_pipeline_reg == "CLOCK2") ? ena2
                        : ((accum_saturation_pipeline_reg == "CLOCK3") ? ena3
                            : 1'b0))));

// multiplier register/pipe enables
assign multiplier_reg_en = 
	((multiplier_reg == "CLOCK0") ? ena0 
                : ((multiplier_reg == "CLOCK1") ? ena1
                        : ((multiplier_reg == "CLOCK2") ? ena2
                                : ((multiplier_reg == "CLOCK3") ? ena3
                                : 1'b1))));
assign multiplier_pipe_en = (multiplier_reg == "UNREGISTERED") ? ena0 : multiplier_reg_en;

// output register enables
assign output_reg_en = 
	((output_reg == "CLOCK0") ? ena0 
                : ((output_reg == "CLOCK1") ? ena1
                        : ((output_reg == "CLOCK2") ? ena2
                                : ((output_reg == "CLOCK3") ? ena3
                                : 1'b1))));


// ************** Scan outputs ************ //

assign scanouta = mult_a_in;
assign scanoutb = mult_b_in;

//////////////////////////// synchronous logic  ////////////////////////////////////////

// ************** Data input registers ****** //

// register for A input

generate
if (input_reg_a != "UNREGISTERED") // avoids unreachability in Formal Verification
begin

	dffep mult_dina_ff[ width_a - 1 : 0 ] (
		 dataa_reg,
		 input_reg_a_clk,
		 input_reg_a_en,
		 dataa_in,
		 1'b0,
		 input_reg_a_clr 
	);

end
endgenerate

// register for B input

generate
if (input_reg_b != "UNREGISTERED") // avoids unreachability in Formal Verification
begin

	dffep mult_dinb_ff[ width_b - 1 : 0 ] (
		 datab_reg,
		 input_reg_b_clk,
		 input_reg_b_en,
		 datab_in,
		 1'b0,
		 input_reg_b_clr
	);

end
endgenerate

/********** Rounding and Saturation ********/

generate
if (multiplier_rounding=="VARIABLE" && mult_round_reg != "UNREGISTERED") 
begin

	dffep mult_round_ff (
		mult_round_in_reg,
		mult_round_clk,
		mult_round_en,
		mult_round,
		1'b0,
		mult_round_clr
	);

assign mult_round_signal_reg = mult_round_in_reg;

end
else
assign mult_round_signal_reg = mult_round;
endgenerate

generate
if (multiplier_saturation=="VARIABLE" && mult_saturation_reg != "UNREGISTERED")
begin

	dffep mult_saturation_ff (
		mult_saturation_in_reg,
		mult_saturation_clk,
		mult_saturation_en,
		mult_saturation,
		1'b0,
		mult_saturation_clr
	);

assign mult_saturation_signal_reg = mult_saturation_in_reg;

end
else
assign mult_saturation_signal_reg = mult_saturation;
endgenerate


generate
if (accumulator_rounding=="VARIABLE" && accum_round_reg != "UNREGISTERED")
begin

	dffep accum_round_ff (
		accum_round_in_reg,
		accum_round_clk,
		accum_round_en,
		accum_round,
		1'b0,
		accum_round_clr
	);

assign accum_round_signal_reg = accum_round_in_reg;

end
else
assign accum_round_signal_reg = accum_round;
endgenerate

generate
if (accumulator_rounding=="VARIABLE" && 
		accum_round_pipeline_reg != "UNREGISTERED")
begin

	dffep accum_round_pipe_ff (
		accum_round_pipe_in_reg,
		accum_round_pipe_clk,
		accum_round_pipe_en,
		accum_round_signal_reg,
		1'b0,
		accum_round_pipe_clr
	);
assign accum_round_pipe_signal_reg = accum_round_pipe_in_reg;

end
else
assign accum_round_pipe_signal_reg = accum_round_signal_reg;
endgenerate

generate
if (accumulator_saturation=="VARIABLE" && 
	accum_saturation_reg != "UNREGISTERED")
begin

	dffep accum_saturation_ff (
		accum_saturation_in_reg,
		accum_saturation_clk,
		accum_saturation_en,
		accum_saturation,
		1'b0,
		accum_saturation_clr
	);
assign accum_saturation_signal_reg = accum_saturation_in_reg;

end
else
assign accum_saturation_signal_reg = accum_saturation;
endgenerate

generate
if (accumulator_saturation=="VARIABLE" && 
	  accum_saturation_pipeline_reg != "UNREGISTERED")
begin

	dffep accum_saturation_pipe_ff (
		accum_saturation_pipe_in_reg,
		accum_saturation_pipe_clk,
		accum_saturation_pipe_en,
		accum_saturation_signal_reg,
		1'b0,
		accum_saturation_pipe_clr
	);

assign accum_saturation_pipe_signal_reg = accum_saturation_pipe_in_reg;
end
else
assign accum_saturation_pipe_signal_reg = accum_saturation_signal_reg;
endgenerate


// ************** Sign A/B logic ************ //

assign signa_rev = (port_signa == "PORT_UNUSED")? 
                    ((representation_a != "UNUSED") ? 
                      (representation_a == "SIGNED" ? 1'b1 : 1'b0) : 1'b0
                    ) : (
                   (port_signa == "PORT_USED")? signa : (
                    ((representation_a != "UNUSED") ?
                        (representation_a == "SIGNED" ? 1'b1 : 1'b0) : signa)
                                                       )
                    );
// signa reg

generate
if ((sign_reg_a != "UNREGISTERED") &&
	        ((port_signa!="PORT_UNUSED") || (representation_a=="UNUSED")))
        // don't register a signa_rev if it is permanently set to 1 or 0
begin

	dffep signa_ff (
		signa_in_reg,
		sign_reg_a_clk,
		sign_reg_a_en,
		signa_rev,
		1'b0,
		sign_reg_a_clr
	);

assign signa_reg = signa_in_reg;

end
else
assign signa_reg = signa_rev;
endgenerate


// signa pipe

generate
if ((sign_pipeline_reg_a != "UNREGISTERED") &&
	((port_signa!="PORT_UNUSED") || (representation_a=="UNUSED")))
begin

	dffep signa_pipe_ff (
		signa_in_pipe,
		sign_pipe_a_clk,
		sign_pipe_a_en,
		signa_late,
		1'b0,
		sign_pipe_a_clr
	);

assign signa_pipe = signa_in_pipe;

end
else
assign signa_pipe = signa_late;
endgenerate


// signb reg
assign signb_rev = (port_signb == "PORT_UNUSED")? 
                    ((representation_b != "UNUSED") ?
                      (representation_b == "SIGNED" ? 1'b1 : 1'b0) : 1'b0
                    ) : (
                   (port_signb == "PORT_USED")? signb : (
                    ((representation_b != "UNUSED") ?
                        (representation_b == "SIGNED" ? 1'b1 : 1'b0) : signb)
                                                       )
                    );

generate
if ((sign_reg_b != "UNREGISTERED") &&
	  ((port_signb!="PORT_UNUSED") || (representation_b=="UNUSED")))
begin

	dffep signb_ff (
		signb_in_reg,
		sign_reg_b_clk,
		sign_reg_b_en,
		signb_rev,
		1'b0,
		sign_reg_b_clr
	);

assign signb_reg = signb_in_reg;

end
else
assign signb_reg = signb_rev;
endgenerate


// signb pipe

generate
if ((sign_pipeline_reg_b != "UNREGISTERED") &&
		((port_signb!="PORT_UNUSED") || (representation_b=="UNUSED")))
begin

	dffep signb_pipe_ff (
		signb_in_pipe,
		sign_pipe_b_clk,
		sign_pipe_b_en,
		signb_late,
		1'b0,
		sign_pipe_b_clr
	);

assign signb_pipe = signb_in_pipe;

end
else
assign signb_pipe = signb_late;
endgenerate


// ************** Addnsub (accumulator) ************ //

// addsub
assign addnsub_rev = (port_addnsub == "PORT_UNUSED")?
                     ((accum_direction != "UNUSED") ? 
                     (accum_direction == "ADD" ? 1'b1 : 1'b0) : 
                        1'b1 ) : (
                      (port_addnsub == "PORT_USED")? addnsub : (
                       ((accum_direction != "UNUSED") ?
                         (accum_direction == "ADD" ? 1'b1 : 1'b0) :
                        addnsub)
                                )
                        );
// addsub reg

generate
if ((addnsub_reg != "UNREGISTERED") && (port_addnsub!="PORT_UNUSED"))
begin

	dffep addsub_ff (
		addsub_in_reg,
		addsub_reg_clk,
		addsub_reg_en,
		addnsub_rev,
		1'b0,
		addsub_reg_clr
	);

assign addsub_reg = addsub_in_reg;

end
else
assign addsub_reg = addnsub_rev;
endgenerate


// addsub pipe

generate
if ((addnsub_pipeline_reg != "UNREGISTERED") && (port_addnsub!="PORT_UNUSED"))
begin

	dffep addsub_pipe_ff (
		addsub_in_pipe,
		addsub_pipe_clk,
		addsub_pipe_en,
		addsub_late,
		1'b0,
		addsub_pipe_clr
	);

assign addsub_pipe = addsub_in_pipe;

end
else
assign addsub_pipe = addsub_late;
endgenerate


// ************** Sync load (accumulator) ************ //

// accum_sload reg

generate
if (accum_sload_reg != "UNREGISTERED") // avoids unreachability in Formal Verification
begin

	dffep accum_sload_ff (
		accum_sload_in_reg,
		accum_sload_reg_clk,
		accum_sload_reg_en,
		accum_sload,
		1'b0,
		accum_sload_reg_clr
	);

assign accum_sload_reg_out = accum_sload_in_reg;

end
else
assign accum_sload_reg_out = accum_sload;
endgenerate


// accum_sload pipe

generate
if (accum_sload_pipeline_reg != "UNREGISTERED") // avoids unreachability in Formal Verification
begin

	dffep accum_sload_pipe_ff (
		accum_sload_in_pipe,
		accum_sload_pipe_clk,
		accum_sload_pipe_en,
		accum_sload_late,
		1'b0,
		accum_sload_pipe_clr
	);

assign accum_sload_pipe = accum_sload_in_pipe;

end
else
assign accum_sload_pipe = accum_sload_late;
endgenerate


// accum_sload upper_data_ reg

generate
if (accum_sload_upper_data_reg != "UNREGISTERED")
begin

	dffep accum_sload_upper_data_ff[ width_upper_data - 1 : 0 ] (
		 accum_sload_upper_data_in_reg ,
		 accum_sload_upper_data_reg_clk ,
		 accum_sload_upper_data_reg_en ,
		 accum_sload_upper_data ,
		 1'b0 ,
		 accum_sload_upper_data_reg_clr 
	);

assign accum_sload_upper_data_reg_out = accum_sload_upper_data_in_reg;

end
else
assign accum_sload_upper_data_reg_out = accum_sload_upper_data;
endgenerate


// accum_sload_upper_data pipe

generate
if (accum_sload_upper_data_pipeline_reg != "UNREGISTERED") 
begin

	dffep accum_sload_upper_data_pipe_ff[ width_upper_data - 1 : 0 ] (
		accum_sload_upper_data_in_pipe,
		accum_sload_upper_data_pipe_clk ,
		accum_sload_upper_data_pipe_en ,
		accum_sload_upper_data_reg_out ,
		1'b0 ,
		accum_sload_upper_data_pipe_clr 
	);
assign accum_sload_upper_data_pipe = accum_sload_upper_data_in_pipe; 

end
else
assign accum_sload_upper_data_pipe = accum_sload_upper_data_reg_out; 
endgenerate



// ************** Multiplier output ************ //

generate
if (multiplier_reg != "UNREGISTERED") // avoids unreachability in Formal Verification
begin

	dffep mult_dout_ff[ width_a + width_b - 1 : 0 ] (
		 mult_reg ,
		 multiplier_reg_clk ,
		 multiplier_reg_en ,
		 mult_out_delayed ,
		 1'b0 ,
		 multiplier_reg_clr 
	);

assign mult_reg_out = mult_reg;
end
else
assign mult_reg_out = mult_out_delayed;
endgenerate


// Extra latency control

generate if (extra_multiplier_latency > 0) begin
pipeline_internal_fv #(width_a + width_b,extra_multiplier_latency) mult_latency (
		.clk(multiplier_pipe_clk),
		.ena(multiplier_pipe_en) ,
		.clr(multiplier_pipe_clr),
		.d(mult_rs_output),
		.piped(mult_out_delayed)
		);
end
else
	assign mult_out_delayed = mult_rs_output;
endgenerate

generate if (extra_multiplier_latency > 0) begin
pipeline_internal_fv #(1,extra_multiplier_latency) signa_latency (
      .clk(multiplier_pipe_clk),
      .ena(multiplier_pipe_en) ,
      .clr(multiplier_pipe_clr),
      .d(signa_reg),
      .piped(signa_reg_delayed)
      );

assign signa_late = signa_reg_delayed;
end
else
assign signa_late = signa_reg;
endgenerate

generate if (extra_multiplier_latency > 0) begin
pipeline_internal_fv #(1,extra_multiplier_latency) signb_latency (
      .clk(multiplier_pipe_clk),
      .ena(multiplier_pipe_en) ,
      .clr(multiplier_pipe_clr),
      .d(signb_reg),
      .piped(signb_reg_delayed)
      );

assign signb_late = signb_reg_delayed;
end
else
assign signb_late = signb_reg;
endgenerate

generate if (extra_multiplier_latency > 0) begin
pipeline_internal_fv #(1,extra_multiplier_latency) addsub_latency (
      .clk(multiplier_pipe_clk),
      .ena(multiplier_pipe_en) ,
      .clr(multiplier_pipe_clr),
      .d(addsub_reg),
      .piped(addsub_reg_delayed)
      );

assign addsub_late = addsub_reg_delayed ;
end
else
assign addsub_late = addsub_reg;
endgenerate

generate if (extra_multiplier_latency > 0) begin
pipeline_internal_fv #(1,extra_multiplier_latency) accum_sload_latency (
      .clk(multiplier_pipe_clk),
      .ena(multiplier_pipe_en) ,
      .clr(multiplier_pipe_clr),
      .d(accum_sload_reg_out),
      .piped(accum_sload_reg_delayed)
      );

assign accum_sload_late = accum_sload_reg_delayed;
end
else
assign accum_sload_late = accum_sload_reg_out;
endgenerate

// ************** Accumulator output ************ //

generate
if (output_reg != "UNREGISTERED") // avoids unreachability in Formal Verification
begin

	dffep add_dout_ff[ width_output - 1 : 0 ] (
		add_reg,
		output_reg_clk,
		output_reg_en,
		accum_out_delayed,
		1'b0,
		output_reg_clr
	);

assign accum_reg_out = add_reg;
end
else
assign accum_reg_out = accum_out_delayed;
endgenerate

generate
if (output_reg != "UNREGISTERED") // avoids unreachability in Formal Verification
begin

	dffep overflow_ff (
		overflow_reg,
		output_reg_clk,
		output_reg_en,
		overflow_out_delayed,
		1'b0,
		output_reg_clr
	);

assign overflow = overflow_reg;
end
else
assign overflow = overflow_out_delayed;
endgenerate


// register the accum_is_saturated signal

generate
if (output_reg != "UNREGISTERED" && accumulator_saturation!="NO") 
begin

	dffep accum_is_sat_ff (
		accum_is_sat_reg,
		output_reg_clk,
		output_reg_en,
		accum_is_sat_delayed,
		1'b0,
		output_reg_clr
	);

end
endgenerate


// Extra accumulator latency control
generate if(extra_accumulator_latency > 0) begin
pipeline_internal_fv #(width_output,extra_accumulator_latency) accum_latency (
                .clk(output_reg_clk),
                .ena(output_reg_en) ,
                .clr(output_reg_clr),
                .d(accum_rs_output[width_output - 1:0]),
                .piped(accum_out_delayed)
                );
end
else
	assign accum_out_delayed = accum_rs_output[width_output - 1:0];
endgenerate

generate if(extra_accumulator_latency > 0) begin
pipeline_internal_fv #(1,extra_accumulator_latency) overflow_latency (
                .clk(output_reg_clk),
                .ena(output_reg_en) ,
                .clr(output_reg_clr),
                .d(overflow_out),
                .piped(overflow_out_delayed)
                );
end
else
   assign overflow_out_delayed = overflow_out;
endgenerate

generate if((accumulator_rounding !="NO" || accumulator_saturation !="NO" ||
		multiplier_rounding !="NO" || multiplier_saturation !="NO") && 
			(extra_accumulator_latency > 0)) begin
pipeline_internal_fv #(1,extra_accumulator_latency) accum_sat_latency (
                .clk(output_reg_clk),
                .ena(output_reg_en) ,
                .clr(output_reg_clr),
                .d(accum_is_sat_signal),
                .piped(accum_sat_late)
                );
	assign accum_is_sat_delayed = accum_sat_late;
end
else
	assign accum_is_sat_delayed = accum_is_sat_signal;
endgenerate

generate if((accumulator_rounding !="NO" || accumulator_saturation !="NO" ||
		multiplier_rounding !="NO" || multiplier_saturation !="NO") &&
			(extra_accumulator_latency > 0)) begin
pipeline_internal_fv #(1,extra_accumulator_latency) mult_sat_latency (
                .clk(output_reg_clk),
                .ena(output_reg_en) ,
                .clr(output_reg_clr),
                .d(mult_sat_overflow),
                .piped(mult_sat_late)
                );
	assign mult_is_sat_delayed = mult_sat_late;
end
else
	assign mult_is_sat_delayed = mult_sat_overflow;
endgenerate

assign cout = (addsub_pipe) ? accum_rs_output[width_output]
                : ((accum_in >= mult_reg_out ) ? 1 : 0);

assign overflow_out = (signa_pipe || signb_pipe) ? 
			((mult_reg_out[width_a + width_b - 1] ~^ accum_in[width_output - 1] ^ ~addsub_pipe) & (accum_in[width_output - 1] ^ accum_rs_output[width_output - 1]))
                   : ((addsub_pipe) ? cout : ~cout);

assign result = accum_reg_out[width_result-1:0];
assign mult_is_saturated = (port_mult_is_saturated != "UNUSED" && 						multiplier_saturation!="NO") ? 
				mult_is_sat_delayed : 0;

assign accum_is_saturated = (port_accum_is_saturated!="UNUSED" && 
				accumulator_saturation!="NO") ? (
				(output_reg == "UNREGISTERED")? 
				    accum_is_sat_delayed : accum_is_sat_reg 
                            ) : 0;

// IMPLEMENTATION END
endmodule
// MODEL END
