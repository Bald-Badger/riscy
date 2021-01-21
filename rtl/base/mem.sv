`include "../opcode.vh"

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
	parameter WIDTH = 32;

	input		[WIDTH-1:0] address;
	input					clk;
	input		[WIDTH-1:0] data;
	input					rden;
	input	               	wren;
	output	reg	[WIDTH-1:0] q;

	reg     [WIDTH-1:0] mem  [0:ENTRY-1];

	always_ff @(posedge clk) begin
		q <= rden ? mem [address] : 0;
	end

	always_ff @( posedge clk) begin
		if (wren) begin
			mem[address] <= data;
		end
	end

	initial begin
		for (int i=0; i<ENTRY; ++i) begin
			mem[i] = 32'b0;
		end

		$readmemh("test.img", mem);
	end



endmodule
