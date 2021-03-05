`include "../opcode.svh"

module registers (
	input clk,
	input rst_n,

	input data_t instr,

	input data_t rd_data,
	input logic rd_wren,
	input r_t rd_addr,

	output data_t rs1_data,
	output data_t rs2_data
);

	r_t rs1_addr, rs2_addr;
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
