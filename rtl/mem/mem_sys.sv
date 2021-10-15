`timescale 1 ps / 1 ps

import defines::*;
import mem_defines::*;

module mem_sys (
	input logic			clk_50m,
	input logic			clk_100m,
	input logic			clk_100m_shift,
	input logic			rst_n,

	input cache_addr_t	addr,
	input data_t		data_in,
	input logic			wr,
	input logic			rd,
	input logic			valid,
	
	output data_t		d_out,
	output logic		done
);

// dcache nets
data_t		data_in_dcache,
			data_out_dcache;

data_t		data_in_sram,
			data_out_sram;



logic		rd_dcache, wr_dache, en_dcache;
logic		hit0_dcache, hit1_dache;
logic		dirty0_dcache, dirty1_dcache;
logic		valid0_dache, valid1_dcache;
flag_line_t	flag_line_in_dcache, flag_line_out_dcache;
data_line_t	data_line_in_dcache, data_line_out_dcache;

index_t index;
always_comb begin
	index = addr.index;
end


cache dcache(
	// input nets
	.clk			(clk_50m),
	.en				(en_dcache),
	.index			(index),
	.rd				(rd_dcache),
	.wr				(wr_dache),
	.flag_line_in	(flag_line_in_dcache),
	.data_line_in	(data_line_in_dcache),

	// output nets
	.flag_line_out	(flag_line_out_dcache),
	.data_line_out	(data_line_out_dcache)
);


// dummy load for icache, used to estimate area
cache icache(
	// input nets
	.clk			(clk_50m),
	.en				(en_dcache),
	.index			(index),
	.rd				(rd_dcache),
	.wr				(wr_dache),
	.flag_line_in	(flag_line_in_dcache),
	.data_line_in	(data_line_in_dcache),

	// output nets
	.flag_line_out	(flag_line_out_dcache),
	.data_line_out	(data_line_out_dcache)
);


// SDRAM net
logic			sdram_clk;   
logic			sdram_cke;
logic			sdram_cs_n;   
logic			sdram_ras_n;
logic			sdram_cas_n;
logic        	sdram_we_n;
logic	[ 1:0]	sdram_ba;
logic	[12:0]	sdram_addr;
wire	[15:0]	sdram_data;
logic	[ 1:0]	sdram_dqm;

logic			sdram_wr;
logic			sdram_rd;
logic			sdram_valid;
logic			sdram_done;

// top level of a sdram controller
sdram sdram_ctrl_inst(
    .clk_50m		(clk_50m),
    .rst_n			(rst_n),
        
    .sdram_clk		(sdram_clk),
    .sdram_cke		(sdram_cke),
    .sdram_cs_n		(sdram_cs_n),
    .sdram_ras_n	(sdram_ras_n),
    .sdram_cas_n	(sdram_cas_n),
    .sdram_we_n		(sdram_we_n),
    .sdram_ba		(sdram_ba),
    .sdram_addr		(sdram_addr),
    .sdram_data		(sdram_data),
    .sdram_dqm		(sdram_dqm),
    
	// user control interface
	// a transaction is complete when valid && done
	.addr			(addr),
	.wr				(sdram_wr),
	.rd				(sdram_rd),
	.valid			(sdram_valid),
	.data_line_in	(data_line_in),
	.data_line_out	(data_line_out),
	.done			(sdram_done),
	.sdram_init_done(sdram_init_done)
); 


// functional model of a physical sdram module
// synthesis translate_off
sdr u_sdram(    
    .Clk			(sdram_clk),
    .Cke			(sdram_cke),
    .Cs_n			(sdram_cs_n),
    .Ras_n			(sdram_ras_n),
    .Cas_n			(sdram_cas_n),
    .We_n			(sdram_we_n),
    .Ba				(sdram_ba),
    .Addr			(sdram_addr),
    .Dq				(sdram_data),
    .Dqm			(sdram_dqm)
);
// synthesis translate_on

endmodule: mem_sys
