`include "../opcode.vh"

module if_id_reg (
	// common
	input clk,
	input rst_n,
	input flush,
	input en,
	// input
	input [`XLEN-1:0] 	pc_p4_in,
	input [`XLEN-1:0] 	pc_in,
	input [`XLEN-1:0] 	instr_in,
	input [4:0] 		rd_in,
	// output
	output [`XLEN-1:0] 	pc_p4_out,
	output [`XLEN-1:0] 	pc_out,
	output [`XLEN-1:0] 	instr_out,
	output [4:0] 		rd_out
);

	dffe #(.WIDTH(`XLEN)) pc_p4_reg (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.d(pc_p4_in),
		.q(pc_p4_out)
	);

	dffe #(.WIDTH(`XLEN)) pc_reg (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.d(pc_in),
		.q(pc_out)
	);

	dffe #(.WIDTH(`XLEN)) instr_reg (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.d(instr_in),
		.q(instr_out)
	);

	dffe #(.WIDTH(5)) rd_reg (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.d(rd_in),
		.q(rd_out)
	);
	
endmodule
