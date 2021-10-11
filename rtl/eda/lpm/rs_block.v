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
////////////////////////////////////////////////////////////////////////////
// Rounding and Saturation Block
////////////////////////////////////////////////////////////////////////////
module rs_block(rs_output, sat_overflow, round, saturate, datain, sign);

parameter width_sign=1;			// width of the sign bits
parameter width_total=32;		// width of the result
//parameter width_fraction_round=15;	// width of fraction to round to
parameter width_msb=17;	// width of fraction to round to
parameter block_type="default";
parameter round_type="NEAREST_INTEGER";
parameter saturate_type="ASYMMETRIC";
parameter family="STRATIX II";

input round;
input saturate;
input [width_total-1 : 0] datain;	// the input to round/saturate
input sign;
output [width_total-1 : 0] rs_output;		// output of the rs_block
output sat_overflow;

wire [width_total-1 : 0] sat_out;
wire [width_total-1 : 0] rs_output;
wire sat_overflow;
wire [width_total-1 : 0] round_out;
wire round_adder_const;

`include "altera_mf_macros.i"

generate 
if(width_total > width_msb+1) begin
	wire signed 
		[width_total : width_total-(width_msb+1)] 
			signed_data_top;
	wire signed 
		[width_total : width_total-(width_msb+1)] 
			round_adder_top;
	wire signed [width_total : 0] round_adder_out;

	assign signed_data_top = 
		{sign & datain[width_total - 1],
		datain[width_total-1 : width_total-(width_msb+1)]};

	assign round_adder_const = (! FEATURE_FAMILY_STRATIXIII( family ) ) ? 1'b1 : (
			(datain[width_total-width_msb-1] == 1'b1)? ( 		// atleast 0.5
			 	( |datain[width_total-width_msb-2:0] )? 1'b1 : (			// greater than 0.5
												// Exactly 0.5
					((round_type=="nearest_integer") || (round_type=="NEAREST_INTEGER"))? 1'b1 : (
											 	// round_type=="nearest_even"
						(datain[width_total-width_msb])? 1'b1 : 1'b0 
					)
				)
			) : 1'b0
		);
			
	assign round_adder_top = signed_data_top + round_adder_const ;

	assign round_adder_out = {round_adder_top,
		datain[width_total-(width_msb+2) : 0]};

	assign round_out = (round)? round_adder_out [width_total-1 : 0] : datain;
end
else begin
	assign round_out = datain;
end
endgenerate

generate 
if (block_type=="mac_mult")
	assign sat_overflow = (saturate)? 
	 // for the multiplier this is the only valid case when saturation occurs
 		(round_out[width_total-1]==1'b0 && round_out[width_total-2]==1'b1) : 
  		1'b0;
else begin
    // if saturation is enabled and if any of the sign bits are different, 
    // set sat_overflow

	assign sat_overflow = (saturate)? (
   	~&round_out[width_total-1 : width_total-width_sign] &&
    	|round_out[width_total-1 : width_total-width_sign]) : 1'b0;
end
endgenerate

wire top_bit;
assign top_bit = round_out[width_total-1];
assign sat_out = (saturate && sat_overflow)? 
	(
	(round_out[width_total-1] && 
	((saturate_type=="symmetric") || saturate_type=="SYMMETRIC"))? 
		// if this is negative overflow in symmetric saturation, make -ve number one more 
		// (i.e., limit max negative to 2^(n-1)+1 )
			{{(width_sign){top_bit}},
	 			{(width_msb-width_sign-1){!top_bit}},
				top_bit,
				{(width_total-width_msb){!top_bit}}} : 
			{{width_sign{top_bit}},
	 			{width_total-width_sign{!top_bit}}} 

	) : round_out;

generate 
if(width_total >= width_msb) begin
	assign rs_output = round? 
		(sat_out & {{width_msb{1'b1}},{width_total-width_msb{1'b0}}}) : sat_out;
end 
else begin
// should not get here under normal circumstances
	assign rs_output = (round)? {width_total{1'b0}} : sat_out;
end
endgenerate
endmodule
