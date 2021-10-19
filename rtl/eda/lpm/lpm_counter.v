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
///////////////////// LPM_COUNTER  for Formal Verification ////////////////////
///////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module lpm_counter (
// INTERFACE BEGIN
     data,           // parallel optional data
     clock,          // clock
     clk_en,          // clock enable
     cnt_en,         // counter enable
     updown,         // count direction
     aclr,aset,aload,// asynchronous clear,set,load
     sclr,sset,sload,// synchronous  clear,set,load
     cin,            // carry in
     cout,           // carry out
     q,              // counter output
     eq              // counter decode output
);
// INTERFACE END
//// default parameters ////

parameter lpm_type = "lpm_counter";
parameter lpm_width = 1;
parameter lpm_modulus = 0;
parameter lpm_direction = "DEFAULT";
parameter lpm_avalue = "UNUSED";
parameter lpm_svalue = "UNUSED";
parameter lpm_pvalue = 0;
parameter lpm_hint = "UNUSED";
parameter intended_device_family = "UNUSED";
parameter lpm_port_updown = "PORT_CONNECTIVITY";

//// constants ////
//// port declarations ////

input  [lpm_width-1:0] data;
input  clock, clk_en, cnt_en, updown;
input  aset, aclr, aload;
input  sset, sclr, sload;
input  cin;
output cout;
output [lpm_width-1:0] q;
output [15:0] eq;

wire [lpm_width-1:0] on_aset_value,on_sset_value;
wire [lpm_width-1:0] set_w;
wire [lpm_width-1:0] rst_w;
wire actual_updown;
wire clk_w;

wire [lpm_width-1:0] q_out, d_in;
wire [lpm_width-1:0] modulus_w;
reg cout;

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

assign modulus_w = (lpm_modulus!=0)? lpm_modulus-1 : {lpm_width{1'b0}};

assign actual_updown = (lpm_direction == "UP")? 1'b1 : (
					(lpm_direction == "DOWN")? 1'b0 : (
						(lpm_port_updown == "PORT_UNUSED") ?  1'b1 : updown 
					));

assign on_aset_value = (lpm_avalue == "UNUSED") ? 
								{lpm_width{1'b1}} : str_to_int(lpm_avalue);

assign on_sset_value = (lpm_svalue == "UNUSED") ? 
								{lpm_width{1'b1}} : str_to_int(lpm_svalue);

assign clk_w = clock;

assign set_w = (aset==1)? on_aset_value : (
				(aload==1)? data : {lpm_width{1'b0}});


assign rst_w = (aclr)? {lpm_width{1'b1}} : (
	// reset appropriate bits when aset is asserted and aset_value is specified
					(aset)? ~on_aset_value : (
	// load the 0's in the data
					(aload)? ~data : {lpm_width{1'b0}}
					));


assign d_in[0] = sclr? 1'b0 : (
						sset? on_sset_value[0] : (
							sload? data[0] : (

					(cnt_en & cin)? (
						((actual_updown==0) && (lpm_modulus!=0) && (q_out==0))? 
							modulus_w[0] : (
								((actual_updown==1) && (lpm_modulus!=0) && 
									(q_out==lpm_modulus-1))?
										1'b0 : ~q_out[0] )
						) : q_out[0] ))) ;

generate
genvar i;
for (i=1; i<lpm_width; i=i+1) begin:dat
   assign d_in[i] = sclr? 1'b0 : (
							sset? on_sset_value[i] : (
								sload? data[i] : (
			(cnt_en & cin)? (
				(actual_updown==1)? (
				(lpm_modulus!=0 && q_out==lpm_modulus-1)? 
	// modulus up count : reset count to 0 after counting up to lpm_modulus-1
					1'b0 : 
								(&q_out[i-1:0])^q_out[i] ) : (
				((lpm_modulus!=0) && (q_out==0))? 
	// modulus down count : reset count to lpm_modulus-1 after counting down to 0
					modulus_w[i] : 
								~(|q_out[i-1:0])^q_out[i] )
				) : (
					q_out[i]
				))));
end
endgenerate

assign q = q_out;

assign eq = 16'b0;

/////////////// synchronous logic //////////////////////////////////
// ****************** carry out logic ****************** //

always @(cin or actual_updown or q_out)
begin
  // *** when counter counts upto 2^lpm_width - 1
  if (lpm_modulus == 0)
     cout = (cin && (
                     (actual_updown==0 && q_out==0) ||
                     (actual_updown==1 && (
                            (q_out == ((1 << lpm_width)-1)) ||
                            (q_out == {lpm_width{1'b1}})
                                          )
                     )
                    )
            ) ? 1'b1 : 1'b0;
  else
  // *** when counter counts upto lpm_modulus-1
     cout = (cin && (
                     (actual_updown==0 && q_out==0) ||
                     (actual_updown==1 && (
                            (q_out == (lpm_modulus-1)) ||
                            (q_out == {lpm_width{1'b1}})
                                          )
                     )
                    )
            ) ? 1'b1 : 1'b0;
end

// The Counter
dffep counter_ff[lpm_width-1:0] (q_out, clk_w, clk_en, d_in, set_w, rst_w);

endmodule
