`timescale 1 ps / 1 ps

module mem_sys (
	input logic			clk_50m,
	input logic			clk_100m,
	input logic			clk_100m_shift,
	input logic			rst_n,

	input data_t		addr,
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

logic		en_dcache;
index_t		index_dacahe;
logic		comp_dcache;
logic		write_dcache;
tag_t		tag_in_dcache,
			tag_out_dcache;
logic		valid_dcache,
			ready_dcahce;


logic		hit0_dcache, hit1_dache;
logic		dirty0_dcache, dirty1_dcache;
logic		valid0_dache, valid1_dcache;

// icache wires
// TODO: 

// SRAM net
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


// TODO: implement instruction cache
// cache icache();


cache dcache(
	// input nets
	.clk		(clk_50m),
	.index		(0),
	.valid		(valid_dcache),
	.rd			(0),
	.wr			(0),
	.tag_in		(tag_in_dcache),
	.data_in	(0),
	.way_sel	(WAY_SEL_NONE),

	// output nets
	.hit0		(hit0_dcache),
	.hit1		(hit1_dache),
	.dirty0		(dirty0_dcache),
	.dirty1		(dirty1_dcache),
	.valid0		(valid0_dache),
	.valid1		(valid1_dache),
	.tag_out	(tag_out_dcache),
	.data_out	(data_out_dcache),
	.ready		(ready_dcahce)
);


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
	.wr				(wr),
	.rd				(rd),
	.valid			(valid),
	.data_line_in	(data_line_in),
	.data_line_out	(data_line_out),
	.done			(done),
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
