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
//////////////////////////////// LPM_COMPARE for Formal Verification /////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module lpm_compare (
// INTERFACE BEGIN
        dataa, datab,     // input data to be compared
	clock,            // pipeline clock
        clken,            // clock enable
	aclr,             // asynch clear
        alb, aeb, agb,    // <,=,> comparison outputs 
        aleb, aneb, ageb  // <,=,> comparison outputs
);
// INTERFACE END
//// default parameters ////

parameter lpm_type = "lpm_compare";
parameter lpm_width = 1;
parameter lpm_representation = "UNSIGNED";
parameter lpm_pipeline = 0;
parameter lpm_hint = "UNUSED";
parameter intended_device_family = "UNUSED";

//// port declarations ////

input  [lpm_width-1:0] dataa, datab;
input  clock;
input  clken;
input  aclr;
output alb, aeb, agb, aleb, aneb, ageb;

//// constants ////
//// variables ////

integer dataa_int,datab_int;
integer i;

//// nets/registers ////

reg [lpm_pipeline:0] l_pipe,e_pipe,g_pipe;   // <,=,> pipelines
reg [lpm_pipeline:0] le_pipe,ne_pipe,ge_pipe;   // <=,!=,>= pipelines
reg [lpm_width-1:0]  not_a, not_b;

// IMPLEMENTATION BEGIN
//////////////////////////// asynchronous logic ////////////////////////////////////////

// ************** Compare logic  *************** //

always @(dataa or datab)
begin 
            dataa_int = dataa;
            datab_int = datab;
            not_a = ~dataa;
            not_b = ~datab;

            if (lpm_representation == "SIGNED")
            begin
                if (dataa[lpm_width-1] == 1)
                    dataa_int = (not_a) * (-1) - 1;
                if (datab[lpm_width-1] == 1)
                    datab_int = (not_b) * (-1) - 1;
            end

            l_pipe[lpm_pipeline]  = (dataa_int < datab_int);
            e_pipe[lpm_pipeline]  = (dataa_int == datab_int);
            g_pipe[lpm_pipeline]  = (dataa_int > datab_int);
            le_pipe[lpm_pipeline] = (dataa_int <= datab_int);
            ne_pipe[lpm_pipeline] = (dataa_int != datab_int);
            ge_pipe[lpm_pipeline] = (dataa_int >= datab_int);
end

/////////////////////////// net assignments //////////////////////////

assign alb  = l_pipe[0];
assign aeb  = e_pipe[0];
assign agb  = g_pipe[0];
assign aleb = le_pipe[0];
assign aneb = ne_pipe[0];
assign ageb = ge_pipe[0];

//////////////////////////// synchronous logic  ////////////////////////////////////////

// ************** Pipeline logic ************ //
`ifndef FORMALITY
generate if (lpm_pipeline > 0) begin
`endif
always @(posedge aclr or posedge clock)

begin
  // ********* asynch clear
   if (aclr)
      for (i = 0; i < lpm_pipeline; i = i + 1)
	begin
           l_pipe[i]  <= 'b0;
           e_pipe[i]  <= 'b0;
           g_pipe[i]  <= 'b0;
           le_pipe[i] <= 'b0;
           ge_pipe[i] <= 'b0;
           ne_pipe[i] <= 'b0;
        end
   else
   begin
      if (clken)
         for (i = 0; i < lpm_pipeline; i = i + 1)
         begin
           l_pipe[i]  <= l_pipe[i+1];
           e_pipe[i]  <= e_pipe[i+1];
           g_pipe[i]  <= g_pipe[i+1];
           le_pipe[i] <= le_pipe[i+1];
           ge_pipe[i] <= ge_pipe[i+1];
           ne_pipe[i] <= ne_pipe[i+1];
         end
   end
end
`ifndef FORMALITY
end
endgenerate
`endif
// IMPLEMENTATION END
endmodule
// MODEL END
