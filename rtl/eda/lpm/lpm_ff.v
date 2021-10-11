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
////////////////////////////////////////////////////////////////////////////////
/////////////////////////// LPM_FF Model for Formal Verification ///////////////
////////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN
module lpm_ff (
// INTERFACE BEGIN
   q,             // ff output	
 	data,          // input data
	clock,         // clock
	enable,        // enable
	aclr,          // async clear
	aset,          // async set
	sclr,          // sync clear
	sset,          // sync set
	aload,         // async load
	sload         	// sync load
);
// INTERFACE END
//// default parameters ////

parameter lpm_width  = 1;
parameter lpm_avalue = "UNUSED";
parameter lpm_svalue = "UNUSED";
parameter lpm_pvalue = "UNUSED";
parameter lpm_fftype = "DFF";
parameter lpm_hint = "UNUSED";
parameter lpm_type = "lpm_ff";

//// ports ////

input  [lpm_width-1:0] data;
input  clock, enable;
input  aclr, aset;
input  sclr, sset;
input  aload, sload ;
output [lpm_width-1:0] q;

wire [lpm_width-1:0] on_aset_value, on_sset_value;
wire [lpm_width-1:0] d_w;
wire [lpm_width-1:0] rst_w, set_w;

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

// IMPLEMENTATION BEGIN
assign on_aset_value = (lpm_avalue == "UNUSED") ?
                        {lpm_width{1'b1}} : str_to_int(lpm_avalue);

assign on_sset_value = (lpm_svalue == "UNUSED") ?
                        {lpm_width{1'b1}} : str_to_int(lpm_svalue);


generate if (lpm_fftype=="TFF") begin
	assign set_w = (aset==1)? on_aset_value : (
							(aload==1)? data : {lpm_width{1'b0}});

	assign rst_w = (aclr)? {lpm_width{1'b1}} : (
						(aset)? (~on_aset_value) : (
            			(aload)? ~data : {lpm_width{1'b0}}
						));

	assign d_w = (sclr==1)? {lpm_width{1'b0}} : (
						(sset==1)? on_sset_value : (
							(sload==1)? data : data ^ q ));

end else begin
	// aload and sload are NOT applicable if the fftype is DFF
	assign set_w = (aset==1)? on_aset_value : {lpm_width{1'b0}};

	assign rst_w = (aclr)? {lpm_width{1'b1}} : (
// reset appropriate bits when aset is asserted and aset_value is specified
            (aset)? (~on_aset_value) : {lpm_width{1'b0}}
			);

	assign d_w = (sclr==1)? {lpm_width{1'b0}} : (
						(sset==1)? on_sset_value : data );

end

endgenerate


// The lpm_ff
dffep lpm_ff_inst[lpm_width-1:0] (q, clock, enable, d_w, set_w, rst_w);

// IMPLEMENTATION END

endmodule
// MODEL END
