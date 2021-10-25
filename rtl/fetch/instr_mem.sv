import defines::*;

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
	input logic		rden,
	input logic		stall,

	output instr_t	instr
);

	// may need to switch endianess for data in and out of memory
	
	// TODO: switch instr endian after merge instr mem to main mem
	// switch data endianess to big when reading if necessary
	/*
	instr_t instr_raw; 
	always_comb begin : switch_endian
		instr = (ENDIANESS == BIG_ENDIAN) ? instr_raw : 
			instr_t'(
				swap_endian(
					data_t'(instr_raw)
							)
					);
	end
	*/

	rom_32b_1024wd	instr_mem_inst (
		.address	( addr[11:2] ),
		.clock		( clk ),
		.clken		( ~stall ),
		.rden		( rden ),
		.q			( instr )	// TODO:
	);

endmodule : instr_mem
