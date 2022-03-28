import defines::*;

// synopsys translate_off
`timescale 1 ns / 1 ps
// synopsys translate_on

module dffe_wrap #(
	WIDTH = XLEN
) (
	input clk,
	input en,
	input rst_n,
	input logic[WIDTH-1:0] d,
	output logic[WIDTH-1:0] q
);

`ifdef ALTERA
	genvar i;	// number of dffe

	generate
		for (i = 0; i < WIDTH;i++) begin : dffe_generate_loop
			dffe dffe_gen(
				.d		(d[i]),
				.clk	(clk),
				.clrn	(rst_n),
				.prn	(1'b1),
				.ena	(en),
				.q		(q[i])
			);
		end
	endgenerate

`else
	dffe_wrap_unsyn # (
		.WIDTH	(WIDTH)
	) dffe (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(d),
		.q		(q)
	);
`endif

endmodule : dffe_wrap
