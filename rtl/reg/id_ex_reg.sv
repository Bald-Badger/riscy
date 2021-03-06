import defines::*;

module id_ex_reg (
	// common
	input clk,
	input rst_n,
	input flush,
	input en,

	// input
	input instr_t	instr_in,
	input data_t 	rs1_in,
	input data_t 	pc_in,
	input data_t 	rs2_in,
	input data_t	imm_in,
	input data_t	pc_p4_in,	

	// output
	output instr_t	instr_out,
	output data_t 	rs1_out,
	output data_t 	pc_out,
	output data_t 	rs2_out,
	output data_t	imm_out,
	output data_t	pc_p4_out
);

	dffe #(.WIDTH(XLEN)) instr_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(instr_in),
		.q		(instr_out)
	);

	dffe #(.WIDTH(XLEN)) rs1_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(rs1_in),
		.q		(rs1_out)
	);

	dffe #(.WIDTH(XLEN)) pc_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(pc_in),
		.q		(pc_out)
	);

	dffe #(.WIDTH(XLEN)) rs2_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(rs2_in),
		.q		(rs2_out)
	);

	dffe #(.WIDTH(XLEN)) imm_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(imm_in),
		.q		(imm_out)
	);
	
	dffe #(.WIDTH(XLEN)) pc_p4_reg (
		.clk	(clk),
		.en		(en),
		.rst_n	(rst_n),
		.d		(pc_p4_in),
		.q		(pc_p4_out)
	);
	
endmodule
