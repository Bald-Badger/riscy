`include "../opcode.svh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module data_mem (
	input data_t	addr,
	input data_t	data_in,
	input instr_t	instr,
	input 			clk,

	output data_t	data_out
);

	opcode_t		opcode;
	logic 			wren, rden;

	always_comb begin
		opcode = instr.opcode;
		rden = (opcode == LOAD);
		wren = (opcode == STORE);
	end

	mem #(
		.ADDR_WIDTH	(XLEN),
		.BYTES		(BYTES)
	) data_mem_inst (
		.waddr		(addr),
		.raddr		(addr),
		.be			(),
		.wdata		(),
		.we			(wren),
		.re			(rden,
		.clk		(clk),
		.q			(instr)
	);

endmodule : data_mem
