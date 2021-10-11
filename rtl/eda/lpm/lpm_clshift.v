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
//////////////////////////////// LPM_CLSHIFT for Formal Verification /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN

`define LEFT  1'b0
`define RIGHT 1'b1

module lpm_clshift (
// INTERFACE BEGIN
	data,
	distance,
	direction,
	result,
	underflow,
	overflow
);
// INTERFACE END
//// default parameters ////

parameter lpm_type = "lpm_clshift";
parameter lpm_width = 1;       // Width of data
parameter lpm_widthdist = 0;   // Width of distance of data shift
parameter lpm_shifttype = "LOGICAL"; // Type of shift
parameter lpm_hint = "UNUSED";

//// constants ////
//// variables ////

//// port declarations ////

input  signed [lpm_width-1:0] data;              // input data
input  [lpm_widthdist-1:0] distance;      // shift distance
input  direction;                         // shift direction

output [lpm_width-1:0] result;            // shifted data
output underflow;                         
output overflow;

//// nets/registers ////

reg signed [lpm_width-1:0] shifted_data;
reg overflow, underflow;

// IMPLEMENTATION BEGIN
function arith_overflow;
	input signed [lpm_width-1:0] data_in;
	input [lpm_widthdist-1:0] shift_dist;
	reg signed [lpm_width-1:0] shifted_data;
	begin
		if (lpm_width==shift_dist)
			arith_overflow = (~&data_in[lpm_width-1:0] && |data_in[lpm_width-1:0]);
      else begin
		// overflow in case of neither all 0's nor all 1's 
		// in most significant 'distance' number of bits
			shifted_data = (data_in >>> lpm_width-shift_dist-1);
			arith_overflow = !(shifted_data=='b0 || shifted_data== {lpm_width{1'b1}});
		end
	end
endfunction

// ******* Barrel-shifter logic ********* //

///// Shifter 
always @(data or distance or direction)
begin
	if (distance > 0)
	begin
		case (lpm_shifttype)
			"LOGICAL"    : 
		    	begin
				shifted_data = 
				   (direction == `RIGHT) ? data >> distance  : data << distance;
				underflow = (direction == `RIGHT) ? 
					((data != 0) && ((distance >= lpm_width) || (shifted_data == 'b0))) :
                                        1'b0;
				overflow  = (direction == `LEFT) ?
					((data != 0) && ((distance >= lpm_width) || ((data >> (lpm_width-distance)) != 0))) :
					1'b0;
		    	end
			"ARITHMETIC" :
		    	begin
				shifted_data =
				   (direction == `RIGHT) ? data >>> distance : data <<< distance;
                                underflow = 
					(direction == `RIGHT) ? (
                                        ((data > 0) && ((distance >= lpm_width) || (shifted_data == 'b0)))
                                        |
                                        ((data < 0) && ((data != {lpm_width{1'b1}}) && ((distance >= lpm_width - 1) | (shifted_data == {lpm_width{1'b1}}))))
					) : 1'b0;
				overflow = 
					(direction == `LEFT) ? (
 					    arith_overflow(data, distance)
					) : 1'b0;
		    	end
			"ROTATE"     :
		    	begin
				shifted_data =
				   (direction == `RIGHT) ? 
					((data >> distance) | (data << (lpm_width - distance))) : 
					((data << distance) | (data >> (lpm_width - distance))) ;
				overflow  = 1'b0;
				underflow = 1'b0;
		    	end
			default      :	// same as logical shift (also covers "UNUSED") 
		    	begin
				shifted_data =
                                   (direction == `RIGHT) ? data >> distance  : data << distance;
                                underflow = (direction == `RIGHT) ?
                                        ((data != 0) && ((distance >= lpm_width) || (shifted_data == 'b0))) :
                                        1'b0;
                                overflow  = (direction == `LEFT) ?
                                        ((data != 0) && ((distance >= lpm_width) || ((data >> (lpm_width - distance)) != 0))) :
                                        1'b0;

		    	end
		endcase
	end
	else
	begin
		shifted_data = data; underflow = 1'b0 ; overflow = 1'b0 ;
	end
end

///// Overflow/underflow

///// Output
assign result = shifted_data;

// IMPLEMENTATION END
endmodule
// MODEL END
