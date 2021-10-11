module mem_sys (
	input logic			clk,
	input logic			rst_n,
	input data_t		addr,
	input data_t		data_in,
	input logic[3:0]	be,			// byte enable
	input logic			wr,
	input logic			rd,
	input logic			valid,

	output data_t		d_out,
	output logic		ready		
);


// dcache nets
data_t		data_in_dcache,
			data_out_dcache;

data_t		data_in_sram,
			data_out_sram;

logic		en_dcache;
inedx_t		index_dacahe;
logic		en_dcache;
logic		comp_dcache;
logic		write_dcache;
tag_t		tag_in_dcache,
			tag_out_dcache;
logic		valid_in_dcache,
			valid_out_dcahce;

logic		hit_dcache;
logic		dirty_dcache;

// icache wires
// TODO: 

// SRAM wires
data_t		addr_sram;
data_t		data_in_sram,
			data_out_sram;

logic		rd_sram, wr_sram;
logic		ready_sram, valid_sram;
	

cache dcache(
	// input nets
	.clk		(clk),
	.rst_n		(rst_n),
	.en			(en_dcache),
	.index		(index_dacahe),
	.comp		(comp_dcache),
	.write		(write_dcache),
	.tag_in		(tag_in_dcache),
	.data_in	(data_in_dcache),
	.valid_in	(valid_in_dcache),

	// output nets
	.hit		(hit_dcache),
	.dirty		(dirty_dcache),
	.tag_out	(tag_out_dcache),
	.data_out	(data_out_dcache),
	.valid_out	(valid_out_dcahce)
);


sram_model sram (
	.clk		(clk),
	.rst_n		(rst_n),
	.addr		(addr_sram),
	.data_in	(data_in_sram),
	.wr			(wr_sram),
	.rd			(rd_sram),
	.valid		(valid_sram),

	.ready		(ready_sram),
	.data_out	(data_out_sram)
);

mem_ctrl mem_ctrl_inst(

);

// TODO: implement instruction cache
// cache icache();
	
endmodule: mem_sys
