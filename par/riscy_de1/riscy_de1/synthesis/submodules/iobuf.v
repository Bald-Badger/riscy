/*
when en is high, io maps to o
when en is low, i maps to io and o
*/

module iobuf (
	input	en,	// 3-State enable input
	input	i,	// buffer input
	output	o,	// buffer output
	inout	io	// buffer inout
);

	bufif0 (io, i, en);

	buf (o, io);

endmodule
