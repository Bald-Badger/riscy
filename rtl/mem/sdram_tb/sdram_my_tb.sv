//****************************************Copyright (c)***********************************//
//?????www.openedv.com
//?????http://openedv.taobao.com 
//????????????"????"?????FPGA & STM32???
//??????????
//Copyright(C) ???? 2018-2028
//All rights reserved                               
//----------------------------------------------------------------------------------------
// File name:           sdram_tb
// Last modified Date:  2018/3/18 8:41:06
// Last Version:        V1.0
// Descriptions:        SDRAM????
//----------------------------------------------------------------------------------------
// Created by:          ????
// Created date:        2018/3/18 8:41:06
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//
`timescale 1ns/1ns
import defines::*;
import mem_defines::*;

module sdram_my_tb;

//reg define
reg         clock_50m;                    //50Mhz????
reg         rst_n;                        //????????
                                          
//logic define                             
logic        sdram_clk;                    //SDRAM ????    
logic        sdram_cke;                    //SDRAM ????    
logic        sdram_cs_n;                   //SDRAM ??    
logic        sdram_ras_n;                  //SDRAM ???    
logic        sdram_cas_n;                  //SDRAM ???    
logic        sdram_we_n;                   //SDRAM ???    
logic [ 1:0] sdram_ba;                     //SDRAM Bank??    
logic [12:0] sdram_addr;                   //SDRAM ?/???    
wire [15:0] sdram_data;                   //SDRAM ??    
logic [ 1:0] sdram_dqm;                    //SDRAM ????    
                                          
logic        led;                          //led???

//*****************************************************
//**                    main code
//***************************************************** 

//??????????
initial begin
  clock_50m = 0;
  rst_n     = 0;                      
  #100                                    //????100ns
  rst_n     = 1;
end

//??50Mhz??,????20ns
always #10 clock_50m = ~clock_50m; 

logic[23:0] addr;
logic wr, rd, valid, done, sdram_init_done;
SDRAM_8_wd_t data_line_in, data_line_out;

//??SDRAM??????
sdram sdram_ctrl_inst(
    .clk            (clock_50m),          //FPGA???50M
    .rst_n          (rst_n),              //??????????
        
    .sdram_clk      (sdram_clk),          //SDRAM ????
    .sdram_cke      (sdram_cke),          //SDRAM ????
    .sdram_cs_n     (sdram_cs_n),         //SDRAM ??
    .sdram_ras_n    (sdram_ras_n),        //SDRAM ???
    .sdram_cas_n    (sdram_cas_n),        //SDRAM ???
    .sdram_we_n     (sdram_we_n),         //SDRAM ???
    .sdram_ba       (sdram_ba),           //SDRAM Bank??
    .sdram_addr     (sdram_addr),         //SDRAM ?/???
    .sdram_data     (sdram_data),         //SDRAM ??
    .sdram_dqm      (sdram_dqm),          //SDRAM ????
    
	// user control interface
	// a transaction is complete when valid && done
	.addr			(addr),
	.wr				(wr),
	.rd				(rd),
	.valid			(valid),
	.data_line_in	(data_line_in),
	.data_line_out	(data_line_out),
	.done			(done),
	.sdram_init_done(sdram_init_done)
);  

task write_test();
	@(posedge clock_50m);
	addr = 20;
	data_line_in = 128'hfedc_ba98_7654_3210_0123_4567_89ab_cdef;
	wr = 1;
	valid = 1;
	@(posedge done);
	@(negedge clock_50m);
	wr = 0;
	valid = 0;
endtask

task read_test();
	@(posedge clock_50m);
	addr = 20;
	rd = 1;
	valid = 1;
	@(posedge done);
	@(negedge clock_50m);
	rd = 0;
	valid = 0;
endtask


initial begin
	addr = 0;
	wr = 0;
	rd = 0;
	valid = 0;
	data_line_in = 0;
	@(posedge sdram_init_done);
	write_test();
	$stop();
	read_test();
	repeat(100) @(negedge clock_50m);
	$stop();
end


//??SDRAM????    
sdr u_sdram(    
    .Clk            (sdram_clk),          //SDRAM ????
    .Cke            (sdram_cke),          //SDRAM ????
    .Cs_n           (sdram_cs_n),         //SDRAM ??
    .Ras_n          (sdram_ras_n),        //SDRAM ???
    .Cas_n          (sdram_cas_n),        //SDRAM ???
    .We_n           (sdram_we_n),         //SDRAM ???
    .Ba             (sdram_ba),           //SDRAM Bank??
    .Addr           (sdram_addr),         //SDRAM ?/???
    .Dq             (sdram_data),         //SDRAM ??
    .Dqm            (sdram_dqm)           //SDRAM ????
    );
    
endmodule : sdram_my_tb
