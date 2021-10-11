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
///////////////////////////////////////////////////////////////////////////////
///////////////////// LPM_SHIFTREG  for Formal Verification ////////////////////
///////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN
module lpm_shiftreg (
// INTERFACE BEGIN
	data,       // Data input to the shift register.
	clock,      // Positive-edge-triggered clock. (Required)
	enable,     // Clock enable input
	shiftin,    // Serial shift data input.
	load,       // Synchronous parallel load. High (1): load operation;
	          	//                            low (0): shift operation.
	aclr,       // Asynchronous clear input.
	aset,       // Asynchronous set input.
	sclr,       // Synchronous clear input.
	sset,       // Synchronous set input.
	q,          // Data output from the shift register.
	shiftout    // Serial shift data output.
);
// INTERFACE END
//// default parameters ////

	parameter lpm_width  = 1;  // Width of the data[] and q ports
	parameter lpm_direction = "LEFT";
	parameter lpm_avalue = "UNUSED";    // Value loaded by aset
	parameter lpm_svalue = "UNUSED";		// Value loaded by sset
	parameter lpm_pvalue = "UNUSED";
	parameter lpm_type = "lpm_shiftreg";
	parameter lpm_hint  = "UNUSED";

	
//// port declarations ////

input  [lpm_width-1:0] data;
input clock, enable, shiftin, load;
input aclr, aset;
input sclr, sset;

output [lpm_width-1:0] q;
output shiftout;

wire [lpm_width-1:0] set_w;
wire [lpm_width-1:0] rst_w;
wire [lpm_width-1:0] on_aset_value, on_sset_value;
wire [lpm_width-1:0] q_out, d_in;

// function definition
// (used to convert lpm_avalue and lpm_svalue to binary)


function integer str_to_int;
   input [8*16:1] s;

   reg [8*16:1] reg_s;
   reg [8:1] digit;
   reg [8:1] tmp;
   integer m, ivalue;

   begin
      ivalue = 0;
      reg_s = s;
      for (m=1; m<=16; m= m+1)
      begin
         tmp = reg_s[128:121];
         digit = tmp & 8'b00001111;
         reg_s = reg_s << 8;
         ivalue = ivalue * 10 + digit;
      end
      str_to_int = ivalue;
   end
endfunction

/////////////// net assignments ////////////////////////////////////

assign q = q_out;
generate 
	if (lpm_direction=="RIGHT") begin
		assign shiftout = q_out[0];
	end
	else begin
		assign shiftout = q_out[lpm_width-1];
	end
endgenerate

assign on_aset_value = (lpm_avalue == "UNUSED") ?
                        {lpm_width{1'b1}} : str_to_int(lpm_avalue);

assign on_sset_value = (lpm_svalue == "UNUSED") ?
                        {lpm_width{1'b1}} : str_to_int(lpm_svalue);


generate
	if (lpm_width==1) begin
		assign d_in = (sclr)? 1'b0 : ( (sset)? on_sset_value : shiftin);
	end 
	else if (lpm_direction=="RIGHT") begin
		assign d_in = (sclr)? {lpm_width{1'b0}} : (
							(sset)? on_sset_value : (
								(load && enable)? data : 
									{shiftin, q_out[lpm_width-1:1]} ));
	end
	else begin
		assign d_in = (sclr)? {lpm_width{1'b0}} : (
							(sset)? on_sset_value : (
								(load && enable)? data : 
									{q_out[lpm_width-2:0], shiftin} ));
	end
endgenerate
 
assign rst_w = (aclr)? {lpm_width{1'b1}} : (
					(aset)? ~on_aset_value : {lpm_width{1'b0}} );
					
assign set_w = (!aclr && aset)? on_aset_value : {lpm_width{1'b0}};


// The Shift Register
dffep shiftreg_ff[lpm_width-1 : 0] (q_out, clock, enable, d_in, set_w, rst_w);

endmodule
// MODEL END
