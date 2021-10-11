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
module altddio_out (
	aclr,
	aset,
	sclr,
	sset,
	datain_h,
	datain_l,
	dataout,
	oe,
	oe_out,
	outclock,
	outclocken
);

	parameter	intended_device_family = "UNUSED";
	parameter	extend_oe_disable = "OFF";
	parameter	invert_output = "OFF";
	parameter	oe_reg = "UNREGISTERED";
	parameter	power_up_high = "OFF";
	parameter	width = 1;
	parameter	lpm_type = "altddio_out";
	parameter	lpm_hint = "UNUSED";

	input	aclr;
	input	aset;
	input	sclr;
	input	sset;
	input	[width-1:0]	datain_h;
	input	[width-1:0]	datain_l;
	input	oe;
	input	outclock;
	input	outclocken;

	output	[width-1:0]	dataout;
	output   [width-1:0] oe_out;

`include "altera_mf_macros.i"

//// nets/registers ////

	wire   [width-1:0] oreg, odreg;
	wire   [width-1:0] latched_dataout;

	wire   [width-1:0] enreg,enpsreg;
	wire   [width-1:0] oe_actual;

	wire [width-1:0] dataout_tmp;
	wire [width-1:0] actual_datain_h, actual_datain_l, actual_enreg,
		actual_enpsreg, actual_oreg, actual_odreg;
	wire actual_oe;

	assign actual_datain_h = {width{~sclr}} & datain_h | {width{sset & ~sclr}};
	assign actual_datain_l = {width{~sclr}} & datain_l | {width{sset & ~sclr}};

	assign actual_enreg = ({width{~sclr}} & enreg) | {width{sset & ~sclr}};
	assign actual_enpsreg = ({width{~sclr}} & enpsreg) | {width{sset & ~sclr}};
	assign actual_oreg = ({width{~sclr}} & oreg) | {width{sset & ~sclr}};
	assign actual_odreg = ({width{~sclr}} & odreg) | {width{sset & ~sclr}};
	assign actual_oe = (sclr)? 1'b0 : (sset? 1'b1 : oe);

	generate

	if(width==1) begin
		dffep oreg_reg (
			.q(oreg),
			.ck(outclock),
			.en(outclocken),
			.d(actual_datain_h),
			.s(aset),
			.r(aclr)
		);
	end
	else begin
		dffep oreg_reg[width-1:0] (
			.q(oreg),
			.ck(outclock),
			.en(outclocken),
			.d(actual_datain_h),
			.s(aset),
			.r(aclr)
		);
	end

	if(width==1) begin
		dffep odreg_reg (
			.q(odreg),
			.ck(outclock),
			.en(outclocken),
			.d(actual_datain_l),
			.s(aset),
			.r(aclr)
		);
	end
	else begin
		dffep odreg_reg[width-1:0] (
			.q(odreg),
			.ck(outclock),
			.en(outclocken),
			.d(actual_datain_l),
			.s(aset),
			.r(aclr)
		);
	end

	if(width==1) begin
		dffep enreg_reg (
			.q(enreg),
			.ck(outclock),
			.en(outclocken),
			.d(actual_oe),
			.s(aset),
			.r(aclr)
		);
	end
	else begin
		dffep enreg_reg[width-1:0] (
			.q(enreg),
			.ck(outclock),
			.en(outclocken),
			.d(actual_oe),
			.s(aset),
			.r(aclr)
		);
	end

	if(width==1) begin
		dffep enpsreg_reg (
			.q(enpsreg),
			.ck(~outclock),
			.en(outclocken),
			.d(actual_enreg),
			.s(aset),
			.r(aclr)
		);
	end
	else begin
		dffep enpsreg_reg[width-1:0] (
			.q(enpsreg),
			.ck(~outclock),
			.en(outclocken),
			.d(actual_enreg),
			.s(aset),
			.r(aclr)
		);
	end

genvar i;
for (i=0; i < width; i=i+1) begin:bit

assign oe_actual[i] = ((extend_oe_disable == "ON") ?
	(enreg[i] & enpsreg[i]) :
	(((oe_reg == "REGISTERED") && (extend_oe_disable != "ON")) ?  enreg[i] : oe)
	);

assign dataout_tmp[i] = (oe_actual[i]) ? ((outclock) ? oreg[i] : odreg[i]) :
	1'bz;

assign dataout[i] =
	(FEATURE_FAMILY_HAS_INVERTED_OUTPUT_DDIO(intended_device_family) &&
	(invert_output == "ON"))? ~dataout_tmp[i] : dataout_tmp[i];
assign oe_out[i] = oe_actual[i];

end

endgenerate

endmodule //altddio_out

