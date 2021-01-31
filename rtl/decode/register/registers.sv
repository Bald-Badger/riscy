`include "../../opcode.vh"

module registers (
	input clk,
	input rst_n,

	input [`XLEN-1:0] instr,

	input [`XLEN-1:0] rd_data,
	input rd_wren,
	input [4:0] rd_addr,

	output [`XLEN-1:0] rs1_data,
	output [`XLEN-1:0] rs2_data
);

	wire [4:0] rs1_addr, rs2_addr;
	wire rs1_rden, rs2_rden;

	reg_bypass reg_pass_inst (
		.clk		(clk),
		.rst_n		(rst_n),
		.rd_data	(rd_data),
		.rd_wren	(rd_wren),
		.rd_addr	(rd_addr),
		.rs1_addr	(rs1_addr),
		.rs2_addr	(rs2_addr),
		.rs1_rden	(rs1_rden),
		.rs2_rden	(rs2_rden),
		.rs1_data	(rs1_data),
		.rs2_data	(rs2_data)
	);

	reg_ctrl reg_ctrl_inst (
		.instr(instr),
		.rs1_addr(rs1_addr),
		.rs2_addr(rs2_addr),
		.rs1_rden(rs1_rden),
		.rs2_rden(rs2_rden)
	);
	
endmodule
