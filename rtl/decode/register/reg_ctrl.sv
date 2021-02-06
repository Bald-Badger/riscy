`include "../../opcode.svh"

module reg_ctrl (
	input instr_t instr,

	output r_t rs1_addr,
	output r_t rs2_addr,
	output rs1_rden,
	output rs2_rden
);
	localparam ENABLE = 1'b1;
	localparam DISABLE = 1'b0;

	opcode_t opcode = get_opcode(instr);

	assign rs1_rden =	(opcode == JALR)	? ENABLE :
						(opcode == B) 		? ENABLE :
						(opcode == LOAD) 	? ENABLE :
						(opcode == STORE)	? ENABLE :
						(opcode == I) 		? ENABLE :
						(opcode == R) 		? ENABLE :
						(opcode == MEM) 	? ENABLE :
						DISABLE;

	assign rs2_rden =	(opcode == B) 		? ENABLE :
						(opcode == STORE) 	? ENABLE :
						(opcode == R) 		? ENABLE :
						DISABLE;

	assign rs1_addr = 	(rs1_rden) ? get_rs1(instr) : 5'b0;
	assign rs2_addr = 	(rs2_rden) ? get_rs2(instr) : 5'b0;
						
endmodule
