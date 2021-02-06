`include "../opcode.svh"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module mem (
	address,
	clk,
	data,
	rden,
	wren,
	q
);

	parameter ENTRY = 1024;
	parameter WIDTH = XLEN;

	input		[WIDTH-1:0] address;
	input					clk;
	input		[WIDTH-1:0] data;
	input					rden;
	input	               	wren;
	output		[WIDTH-1:0] q;

	reg     [WIDTH-1:0] mem  [0:ENTRY-1];

	assign q = rden ? mem [address] : 0;

	always_ff @( posedge clk) begin
		if (wren) begin
			mem[address] <= data;
		end
	end

// synopsys translate_off
	initial begin
		for (int i=0; i<ENTRY; ++i) begin
			mem[i] = 32'bX;
		end

		$readmemh("test.img", mem);
	end
// synopsys translate_on


endmodule
