interface sdram_interface #(
	// by bits it means "pin couont"
	// sdram's addr is input as row and col
	parameter ADDR_BITS	= 13,
	parameter BA_BITS	= 2,
	parameter DQ_BITS	= 16,
	parameter DQM_BITS	= 2
) ();

	// all outputs except sdram_data_io is output
	wire						sdram_clk;
	wire						sdram_cke;
	wire [DQM_BITS - 1 : 0]		sdram_dqm;
	wire						sdram_cas_n;
	wire						sdram_ras_n;
	wire						sdram_we_n;
	wire						sdram_cs_n;
	wire [BA_BITS - 1 : 0]		sdram_ba;
	wire [ADDR_BITS - 1 : 0]	sdram_addr;
	wire [DQ_BITS - 1 : 0]		sdram_dq;	// inout

endinterface : sdram_interface
