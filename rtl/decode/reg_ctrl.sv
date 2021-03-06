import defines::*;

module reg_ctrl (
	input instr_t instr,

	output r_t rs1_addr,
	output r_t rs2_addr,
	output logic rs1_rden,
	output logic rs2_rden
);
	localparam ENABLE = 1'b1;
	localparam DISABLE = 1'b0;

	opcode_t opcode;
	always_comb begin
		opcode = opcode_t'(instr.opcode);
		
		rs1_rden =	(opcode == JALR)	? ENABLE :
					(opcode == B) 		? ENABLE :
					(opcode == LOAD) 	? ENABLE :
					(opcode == STORE)	? ENABLE :
					(opcode == I) 		? ENABLE :
					(opcode == R) 		? ENABLE :
					(opcode == MEM) 	? ENABLE :
					DISABLE;

		rs2_rden =	(opcode == B) 		? ENABLE :
					(opcode == STORE) 	? ENABLE :
					(opcode == R) 		? ENABLE :
					DISABLE;

		rs1_addr = 	(rs1_rden) ? instr.rs1 : 5'b0;
		rs2_addr = 	(rs2_rden) ? instr.rs2 : 5'b0;
	end

	
						
endmodule
