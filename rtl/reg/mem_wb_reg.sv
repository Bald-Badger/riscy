`include "../opcode.svh"

module ex_mem_reg (
	// common
	input clk,
	input rst_n,
	input flush,
	input en,

	// input
	input instr_t	instr_in,
	input data_t	alu_result_in,
	input data_t	mem_data_in,
	input r_t		rd_in,
	input data_t	pc_p4_in,	

	// output
	output instr_t	instr_out,
	output data_t	alu_result_out,
	output data_t	mem_data_out,
	output r_t		rd_out,
	output data_t	pc_p4_out
);

	dffe #(.WIDTH(XLEN)) instr_reg (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.d(instr_in),
		.q(instr_out)
	);

	dffe #(.WIDTH(XLEN)) alu_result_reg (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.d(alu_result_in),
		.q(alu_result_out)
	);

	dffe #(.WIDTH(XLEN)) mem_data_reg (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.d(mem_data_in),
		.q(mem_data_out)
	);

	dffe #(.WIDTH(5)) rd_reg (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.d(rd_in),
		.q(rd_out)
	);

	dffe #(.WIDTH(XLEN)) pc_p4_reg (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.d(pc_p4_in),
		.q(pc_p4_out)
	);

endmodule