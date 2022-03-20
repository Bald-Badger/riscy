interface sdram_interface ();

	// all outputs except sdram_data_io is output
	wire			sdram_clk_o;
	wire			sdram_cke_o;
	wire	[1:0]	sdram_dqm_o;
	wire			sdram_cas_o;
	wire			sdram_ras_o;
	wire			sdram_we_o;
	wire			sdram_cs_o;
	wire	[1:0]	sdram_ba_o;
	wire	[12:0]	sdram_addr_o;
	wire	[15:0]	sdram_data_io;	// inout

endinterface : sdram_interface
