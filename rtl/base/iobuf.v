/*
when en is high, io maps to o
when en is low, i maps to io and o
*/

module iobuf # (
	parameter WIDTH = 1
) (
	input					en,	// 3-State enable input
	input	[WIDTH - 1 : 0] i,	// buffer input
	output	[WIDTH - 1 : 0] o,	// buffer output
	inout	[WIDTH - 1 : 0] io	// buffer inout
);

genvar index;

generate
	for (index=0; index < WIDTH; index = index + 1) begin : iobuf_gen
		bufif0 (io[index], i[index], en);
		buf (o[index], io[index]);
	end
endgenerate

endmodule : iobuf
