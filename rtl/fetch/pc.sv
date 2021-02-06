`include "../opcode.svh"

module pc (
	//input
	clk, rst_n,
	pc_bj,
	pc_sel,			// 1 for bj, 0 for p4
	//output
	pc,
	pc_p4,
);

	input 	clk, rst_n, pc_sel;
	input	data_t	pc_bj;
	output	data_t	pc, pc_p4;

	data_t pc_nxt;
	assign pc_nxt = pc_sel ? pc_bj : pc_p4;
	assign pc_p4 = pc + 4;

	dff #(
        .WIDTH(XLEN)
        ) pc_ff (
		//outout
		.q(pc),
		//input
		.d(pc_nxt),
		.clk(clk),
		.rst_n(rst_n)
	);

endmodule
