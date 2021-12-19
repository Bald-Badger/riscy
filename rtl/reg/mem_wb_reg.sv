import defines::*;

module mem_wb_reg (
	// common
	input clk,
	input rst_n,
	input flush,
	input en,

	// input
	input instr_t	instr_in,
	input data_t	alu_result_in,
	input data_t	mem_data_in_in,
	input data_t	mem_data_out_in,
	input data_t	pc_p4_in,
	input data_t	pc_nxt_in,
	input logic		rd_wren_in,
	input logic		instr_valid_in,
	input data_t	mem_addr_in,

	// output
	output instr_t	instr_out,
	output data_t	alu_result_out,
	output data_t	mem_data_in_out,
	output data_t	mem_data_out_out,
	output data_t	pc_p4_out,
	output data_t	pc_nxt_out,
	output logic	rd_wren_out,
	output logic	instr_valid_out,
	output data_t	mem_addr_out
);

	dffe_wrap #(.WIDTH(XLEN)) instr_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(instr_in),
		.q		(instr_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) alu_result_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(alu_result_in),
		.q		(alu_result_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) mem_data_out_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(mem_data_out_in),
		.q		(mem_data_out_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) mem_data_in_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(mem_data_in_in),
		.q		(mem_data_in_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) pc_p4_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(pc_p4_in),
		.q		(pc_p4_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) pc_nxt_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(flush ? 0 : pc_nxt_in),
		.q		(pc_nxt_out)
	);


	dffe_wrap #(.WIDTH(1)) rd_wren_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(rd_wren_in),
		.q		(rd_wren_out)
	);

	dffe_wrap #(.WIDTH(1)) instr_valid_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(instr_valid_in),
		.q		(instr_valid_out)
	);

	dffe_wrap #(.WIDTH(XLEN)) mem_addr_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(mem_addr_in),
		.q		(mem_addr_out)
	);

endmodule
