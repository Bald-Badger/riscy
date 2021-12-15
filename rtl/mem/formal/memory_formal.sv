import defines::*;
import mem_defines::*;

module memory_sva (
    input	logic			clk,
	input	logic			clk_100m,
	input	logic			clk_100m_shift,
	input	logic			rst_n,
	input	data_t			addr,
	input	data_t			data_in_raw,
	input	data_t			mem_mem_fwd_data,
	input	mem_fwd_sel_t 	fwd_m2m, 	// mem to mem forwarding
	input	instr_t			instr,

	output	data_t			data_out,
	output	logic			sdram_init_done,
	output	logic			done,

	// SDRAM hardware pins
	output	logic			sdram_clk, 
	output	logic			sdram_cke,
	output	logic			sdram_cs_n,   
	output	logic			sdram_ras_n,
	output	logic			sdram_cas_n,
	output	logic        	sdram_we_n,
	output	logic	[ 1:0]	sdram_ba,
	output	logic	[12:0]	sdram_addr,
	inout	wire	[15:0]	sdram_data,
	output	logic	[ 1:0]	sdram_dqm
);

assert property (@(posedge clk) ~clk);
    
endmodule