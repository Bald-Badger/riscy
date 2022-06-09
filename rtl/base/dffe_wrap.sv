import defines::*;

// synopsys translate_off
`timescale 1 ns / 1 ps
// synopsys translate_on

module dffe_wrap #(
	parameter WIDTH = XLEN,
	parameter TARGET = GEN_TARGET
) (
	input clk,
	input en,
	input rst_n,
	input logic[WIDTH-1:0] d,
	output logic[WIDTH-1:0] q
);


	genvar i;	// number of dffe
	generate
		if (TARGET == ALTERA) begin
			for (i = 0; i < WIDTH;i++) begin : dffe_generate_loop_altera
				dffe dffe_gen(
					.d		(d[i]),
					.clk	(clk),
					.clrn	(rst_n),
					.prn	(1'b1),
					.ena	(en),
					.q		(q[i])
				);
			end
		end else if (TARGET == XILINX) begin
			for (i = 0; i < WIDTH;i++) begin : dffe_generate_loop_xilinx
				FDRE dffe_gen(
					.D		(d[i]),
					.C		(clk),
					.R		(rst_n),
					.CE		(en),
					.Q		(q[i])
				);
			end
		end else begin
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
