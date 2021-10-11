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
//////////////////////////////// LPM_LATCH for Formal Verification ///////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module latch_blk (
// INTERFACE BEGIN
 	data,          // input data
 	dq,          	// input data
  	q,             // latch output	
	gate,          // control
	aset,          // async set
	aclr           // async clear
);
// INTERFACE END
//// default parameters ////
parameter lpm_type = "lpm_latch";
parameter lpm_width = 1;
parameter lpm_avalue = -1;   
parameter lpm_pvalue = "UNUSED";
parameter lpm_hint = "UNUSED";

//// constants ////
//// port declarations ////

input  [lpm_width-1:0] data;
input  [lpm_width-1:0] dq;
input  gate, aset, aclr;
output [lpm_width-1:0] q;

//// nets/registers ////

wire [lpm_width-1:0] q;

// IMPLEMENTATION BEGIN
/////////////// latch logic ////////////////////////////////////

assign q = 
         aclr ? {lpm_width{1'b0}} : 
              ( aset ? (lpm_avalue == -1) 
                   ? {lpm_width{1'b1}} : lpm_avalue 
                         : (gate ? data : dq));

// IMPLEMENTATION END
endmodule

module lpm_latch (
// INTERFACE BEGIN
 	data,          // input data
	q,             // latch output	
	gate,          // control
	aset,          // async set
	aclr,          // async clear
	aconst
);
// INTERFACE END
//// default parameters ////
parameter lpm_type = "lpm_latch";
parameter lpm_width = 1;
parameter lpm_avalue = "UNUSED";
parameter lpm_pvalue = "UNUSED";
parameter lpm_hint = "UNUSED";

localparam int_aval = (lpm_avalue == "UNUSED")? -1 : str_to_int(lpm_avalue);
//// constants ////
//// port declarations ////

input  [lpm_width-1:0] data;
input  gate, aset, aclr, aconst;
output [lpm_width-1:0] q;

// IMPLEMENTATION BEGIN

/////////////// special purpose functions //////////////////////////
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

`ifdef GATES_TO_GATES
wire [lpm_width-1:0] q;

latch_blk #(lpm_type,lpm_width,int_aval,lpm_pvalue,lpm_hint) latch_blk_inst ( .dq(q), .data(data), .q(q), .gate(gate), .aset(aset), .aclr(aclr) );

`else

reg [lpm_width-1:0] q;

always @(data or gate or aclr or aset)
    begin
        if (aclr)
            q = {lpm_width{1'b0}};
        else if (aset)
            q = (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                        : str_to_int(lpm_avalue);
        else if (gate)
            q = data;
    end

`endif
// IMPLEMENTATION END
endmodule

