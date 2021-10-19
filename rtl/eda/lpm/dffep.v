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
////////////////////// DFF primitive with enable
////////////////////////////////////////////////////////////////////////////////

primitive dffep (q, ck, en, d, s, r);
	output q; // dff output
	input ck; // clock
	input en; // clock enable
	input d; // dff data input
	input s; // async set
	input r; // async reset

	reg q;
	initial q=1'b0;

	table
	//  ck  en  d  s  r  :  q  :  q+
// rising transitions on ck
		p   1  0  0  ?  :  ?  :  0;		
		p   1  1  ?  0  :  ?  :  1;
		p   1  1  ?  1  :  ?  :  0;
		p   0  ?  ?  1  :  ?  :  0;
		p   0  ?  1  0  :  ?  :  1;
		p   0  ?  0  0  :  ?  :  -;
// falling transitions on ck
		n   ?  ?  0  0  :  ?  :  -;
		n   ?  ?  ?  1  :  ?  :  0;
		n   ?  ?  1  0  :  ?  :  1;
// transition on reset
		?   ?  ?  ?  p  :  ?  :  0;
		?   ?  ?  0  n  :  ?  :  -;
		?   ?  ?  x  n  :  ?  :  -;	// to handle time 0 transition in modelsim
		?   ?  ?  1  n  :  ?  :  1;
// transition on set
		?   ?  ?  p  0  :  ?  :  1;
		?   ?  ?  n  0  :  ?  :  -;
		?   ?  ?  *  1  :  ?  :  0;
// set/reset precedence over ck transition & reset precedence over set
		*   ?  ?  ?  1  :  ?  :  0;
		*   ?  ?  1  0  :  ?  :  1;
// data changes on steady ck
		?   ?  *  0  0  :  ?  :  -;
		?   ?  *  ?  1  :  ?  :  0;
		?   ?  *  1  0  :  ?  :  1;
// level sensitive descriptions
		?   ?  ?  ?  1  :  ?  :  0;
		?   ?  ?  1  0  :  ?  :  1;	
		?   0  ?  0  0  :  ?  :  -;	
// transitions on en
		?   *  ?  0  0  :  ?  :  -;
		?   *  ?  ?  1  :  ?  :  0;
		?   *  ?  1  0  :  ?  :  1;
	endtable
endprimitive

