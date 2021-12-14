import defines::*;

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

/*
TODO: merge instrtion memory
place holder for instruction memory
will merge instruction memory to mem system in future versons
*/

module instr_mem (
	input data_t	addr,
	input logic		clk,
	input logic 	rst_n,
	input logic		rden,
	input logic		stall,

	output instr_t	instr
);

	instr_t instr_raw; 
	always_comb begin : switch_endian
		if (BOOT_TYPE == BINARY_BOOT) begin
			instr =	(ENDIANESS == BIG_ENDIAN) ? instr_t'(instr_raw) : 
					instr_t'(swap_endian(data_t'(instr_raw)));
		end else if (BOOT_TYPE == RARS_BOOT) begin
			instr = instr_t'(instr_raw);
		end else begin
			instr = NULL;
		end
	end

	generate
		case (BOOT_TYPE)
			BINARY_BOOT: begin
				rom instr_mem_inst (
					.addr		(addr[13:2]),
					.clk		(clk),
					.rden		(rden),
					.clken		(~stall),
					.q			(instr_raw)
				);
			end
			RARS_BOOT: begin
				rom_32b_1024wd	instr_mem_inst (
					.address	( addr[11:2] ),
					.clock		( clk ),
					.clken		( ~stall ),
					.rden		( rden ),
					.q			( instr_raw )
				);
			end
		endcase
	endgenerate
endmodule : instr_mem
