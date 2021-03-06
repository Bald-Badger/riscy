import defines::*;

module proc_hier();

	logic clk, rst_n;

	clkrst #(
		.FREQ	(FREQ)
	) clk_rst_gen_nst (
		.clk	(clk),
		.rst_n	(rst_n)
	);

	proc processor_inst (
		.clk	(clk),
		.rst_n	(rst_n)
	);
	
endmodule
