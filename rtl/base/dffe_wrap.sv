import defines::*;

// synopsys translate_off
`timescale 1 ns / 1 ps
// synopsys translate_on

module dffe_wrap #(
	parameter WIDTH = XLEN,
	parameter GEN_TARGET = INDEPNDENT
) (
	input clk,
	input en,
	input rst_n,
	input logic[WIDTH-1:0] d,
	output logic[WIDTH-1:0] q
);


	genvar i;	// number of dffe
	generate
		if (GEN_TARGET == ALTERA) begin
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
		end else if (GEN_TARGET == INDEPNDENT) begin
			dffe_wrap_unsyn # (
				.WIDTH	(WIDTH)
			) dffe (
				.clk	(clk),
				.en		(en),
				.rst_n	(rst_n),
				.d		(d),
				.q		(q)
			);
		end
	endgenerate

endmodule : dffe_wrap
