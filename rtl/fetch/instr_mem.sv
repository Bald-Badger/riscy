`include "../opcode.vh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module instr_mem (
	addr,
	clk,
	rden,
	instr
);
	input		[`XLEN-1:0] addr;
	input					clk;
	input					rden;
	output		[`XLEN-1:0] instr;

	mem #(
		.ENTRY  (1024), 
		.WIDTH  (`XLEN)
		) instr_mem_inst (
		.address(addr),
		.clk	(clk),
		.data	(32'b0),
		.rden	(rden),
		.wren	(1'b0),
		.q		(instr)
	);

endmodule
