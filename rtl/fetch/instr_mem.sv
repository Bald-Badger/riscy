`include "../opcode.svh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

// TODO: use little endian!
/*
   for now, I use big endian for instructions
   and data in little endian as instruction are always 32b
*/

module instr_mem (
	input data_t	addr,
	input logic		clk,
	input logic 	rst_n,
	input 			rden,

	output instr_t	instr
);

	// may need to switch endianess for data in and out of memory
	instr_t instr_raw; 

	// switch data endianess to big when reading if necessary
	always_comb begin : switch_endian
		instr = (ENDIANESS == BIG_ENDIAN) ? instr_raw : 
			instr_t'(
				swap_endian(
					data_t'(instr_raw)
							)
					);
	end

	mem #(
		.ADDR_WIDTH	(XLEN),
		.BYTES		(BYTES),
		.TYPE		(BLANK_MEM)
	) instr_mem_inst (
		.waddr		(NULL),
		.raddr		(addr),
		.be			(W_EN_BIG | W_EN_LITTLE),	// 4'hF
		.wdata		(NULL),
		.we			(DISABLE),
		.re			(rden),
		.clk		(clk),
		.rst_n		(rst_n),
		.q			(instr_raw)
	); 

endmodule : instr_mem
