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
//////////////////////////////// Pipeline (Internal)  for Formal Verification ////////////
//////////////////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN
module pipeline_internal_fv (
// INTERFACE BEGIN
	clk,         // clock
	ena,         // clock enable
	clr,         // async clear
	d,           // data in
	piped        // output
);
// INTERFACE END
//// top level parameters ////
parameter data_width = 1;
parameter latency = 1;
//// port declarations ////

// data input ports
input  [data_width - 1 : 0] d;

// control signals
input clk,ena,clr;

// output ports
output [data_width - 1 : 0] piped;

wire [data_width-1 : 0] out;
wire [data_width*(latency-1) : 1] t;
wire [data_width*latency-1 : 0] d_w;

assign piped = out;

//// nets/registers ////

// IMPLEMENTATION BEGIN
generate
if(latency==0) begin
	assign out = d;
end
else if(latency==1) begin
	assign d_w = ena? d : out;
	dff_bus #(data_width) p (.q(out), .clk(clk), .d(d_w), .clr(clr));
end
else begin
	assign d_w = ena? {t,d} : {out,t};
	dff_bus #(data_width) p[1:latency] (.q({out,t}), .clk(clk), .d(d_w), .clr(clr));
end
endgenerate
// IMPLEMENTATION END
endmodule
// MODEL END

module dff_bus (q, clk, d, clr);
parameter data_width = 1;
input [data_width-1 : 0] d;
input clk, clr;
output [data_width-1 : 0] q;

generate 
if(data_width==1) begin
	dffep reg_prim_inst (q,clk,1'b1,d,1'b0,clr);
end 
else begin
	dffep reg_prim_inst[data_width-1:0] (q,clk,1'b1,d,1'b0,clr);
end
endgenerate
endmodule

