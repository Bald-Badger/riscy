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

module    sld_signaltap    (
    jtag_state_sdr,
    ir_out,
    jtag_state_cdr,
    ir_in,
    tdi,
    acq_trigger_out,
    jtag_state_uir,
    acq_trigger_in,
    trigger_out,
    acq_data_out,
    acq_data_in,
    jtag_state_udr,
    tdo,
    clrn,
    crc,
    jtag_state_e1dr,
    raw_tck,
    usr1,
    acq_clk,
    shift,
    ena,
    trigger_in,
    update,
`ifdef POST_FIT
	_unassoc_outputs_,
	_unassoc_inputs_,
`endif
    rti);

    parameter    SLD_CURRENT_RESOURCE_WIDTH    =    0;
    parameter    SLD_INVERSION_MASK    =    "0";
    parameter    SLD_POWER_UP_TRIGGER    =    0;
    parameter    SLD_ADVANCED_TRIGGER_6    =    "NONE";
    parameter    SLD_ADVANCED_TRIGGER_9    =    "NONE";
    parameter    SLD_ADVANCED_TRIGGER_7    =    "NONE";
    parameter    SLD_INCREMENTAL_ROUTING    =    0;
    parameter    SLD_TRIGGER_IN_ENABLED    =    0;
    parameter    SLD_STATE_BITS    =    5;
    parameter    SLD_STATE_FLOW_USE_GENERATED    =    0;
    parameter    SLD_INVERSION_MASK_LENGTH    =    1;
    parameter    SLD_DATA_BITS    =    1;
    parameter    SLD_BUFFER_FULL_STOP    =    1;
    parameter    SLD_STATE_FLOW_MGR_ENTITY    =    "state_flow_mgr_entity.vhd";
    parameter    SLD_NODE_CRC_LOWORD    =    50132;
    parameter    SLD_ADVANCED_TRIGGER_5    =    "NONE";
    parameter    SLD_TRIGGER_BITS    =    1;
    parameter    SLD_ADVANCED_TRIGGER_10    =    "NONE";
    parameter    SLD_MEM_ADDRESS_BITS    =    7;
    parameter    SLD_ADVANCED_TRIGGER_ENTITY    =    "basic";
    parameter    SLD_ADVANCED_TRIGGER_4    =    "NONE";
    parameter    SLD_TRIGGER_LEVEL    =    10;
    parameter    SLD_ADVANCED_TRIGGER_8    =    "NONE";
    parameter    SLD_RAM_BLOCK_TYPE    =    "AUTO";
    parameter    SLD_ADVANCED_TRIGGER_2    =    "NONE";
    parameter    SLD_ADVANCED_TRIGGER_1    =    "NONE";
    parameter    SLD_DATA_BIT_CNTR_BITS    =    4;
    parameter    lpm_type    =    "sld_signaltap";
    parameter    SLD_NODE_CRC_BITS    =    32;
    parameter    SLD_SAMPLE_DEPTH    =    16;
    parameter    SLD_ENABLE_ADVANCED_TRIGGER    =    0;
    parameter    SLD_SEGMENT_SIZE    =    0;
    parameter    SLD_NODE_INFO    =    0;
    parameter    SLD_NODE_CRC_HIWORD    =    41394;
    parameter    SLD_TRIGGER_LEVEL_PIPELINE    =    1;
    parameter    SLD_ADVANCED_TRIGGER_3    =    "NONE";

    parameter    ELA_STATUS_BITS    =    4;
    parameter    N_ELA_INSTRS    =    8;
    parameter    SLD_IR_BITS    =    N_ELA_INSTRS;
`ifdef POST_FIT
	parameter	_unassoc_outputs_width_ = 1;
	parameter	_unassoc_inputs_width_ = 1;
`endif

    input    jtag_state_sdr;
    output    [SLD_IR_BITS-1:0]    ir_out;
    input    jtag_state_cdr;
    input    [SLD_IR_BITS-1:0]    ir_in;
    input    tdi;
    output    [SLD_TRIGGER_BITS-1:0]    acq_trigger_out;
    input    jtag_state_uir;
    input    [SLD_TRIGGER_BITS-1:0]    acq_trigger_in;
    output    trigger_out;
    output    [SLD_DATA_BITS-1:0]    acq_data_out;
    input    [SLD_DATA_BITS-1:0]    acq_data_in;
    input    jtag_state_udr;
    output    tdo;
    input    clrn;
    input    [SLD_NODE_CRC_BITS-1:0]    crc;
    input    jtag_state_e1dr;
    input    raw_tck;
    input    usr1;
    input    acq_clk;
    input    shift;
    input    ena;
    input    trigger_in;
    input    update;
    input    rti;
`ifdef POST_FIT
	input 	[ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output 	[ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif

endmodule //sld_signaltap

