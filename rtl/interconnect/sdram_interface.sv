interface sdram_interface ();

	// all outputs except sdram_data_io is inout
	logic			sdram_clk_o;
	logic			sdram_cke_o;
	logic	[1:0]	sdram_dqm_o;
	logic			sdram_cas_o;
	logic			sdram_ras_o;
	logic			sdram_we_o;
	logic			sdram_cs_o;
	logic	[1:0]	sdram_ba_o;
	logic	[12:0]	sdram_addr_o;
	logic	[15:0]	sdram_data_io;	// inout

endinterface : sdram_interface
