import defines::*;

module reg_ctrl (
	input	instr_t	instr,

	output	r_t		rs1_addr,
	output	r_t		rs2_addr,
	output	logic	rs1_rden,
	output	logic	rs2_rden
);

	opcode_t opcode;
	always_comb begin
		opcode = opcode_t'(instr.opcode);

/*	
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
*/

		case (opcode)
			JALR:		rs1_rden = ENABLE;
			B:			rs1_rden = ENABLE;
			LOAD:		rs1_rden = ENABLE;
			STORE:		rs1_rden = ENABLE;
			I:			rs1_rden = ENABLE;
			R:			rs1_rden = ENABLE;
			MEM:		rs1_rden = ENABLE;
			default:	rs1_rden = DISABLE;
		endcase

		case (opcode)
			B:			rs2_rden = ENABLE;
			STORE:		rs2_rden = ENABLE;
			R:			rs2_rden = ENABLE;
			default:	rs2_rden = DISABLE;
		endcase

		rs1_addr = 	(rs1_rden) ? instr.rs1 : r_t'(ZERO); // read from X0 when no read operation
		rs2_addr = 	(rs2_rden) ? instr.rs2 : r_t'(ZERO);
	end
						
endmodule : reg_ctrl
