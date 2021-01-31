`include "../../opcode.vh"

module reg_ctrl (
	input [`XLEN-1:0] instr,

	output [4:0] rs1_addr,
	output [4:0] rs2_addr,
	output rs1_rden,
	output rs2_rden
);
	localparam ENABLE = 1'b1;
	localparam DISABLE = 1'b0;
	wire[6:0] opcode = instr[6:0];
	assign rs1_rden =	(opcode == `JALR)	? ENABLE :
						(opcode == `B) 		? ENABLE :
						(opcode == `LOAD) 	? ENABLE :
						(opcode == `STORE) 	? ENABLE :
						(opcode == `I) 		? ENABLE :
						(opcode == `R) 		? ENABLE :
						(opcode == `MEM) 	? ENABLE :
						DISABLE;

	assign rs2_rden =	(opcode == `B) 		? ENABLE :
						(opcode == `STORE) 	? ENABLE :
						(opcode == `R) 		? ENABLE :
						DISABLE;

	assign rs1_addr = 	(rs1_rden) ? instr[19:15]: 5'b0;
	assign rs2_addr = 	(rs1_rden) ? instr[24:20]: 5'b0;
						
endmodule