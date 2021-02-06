`include "../../opcode.svh"

module pc_adder (
	input instr_t instr,
	input data_t pc,
	input data_t rs1,
	input data_t rs2,

	output data_t pc_bj,	// no one likes bj
							// bj makes it hard
							// to predict
	output bj_sel
);

	localparam taken = 1'b1;
	localparam not_taken = 1'b0;

	opcode_t opcode = get_opcode(instr);
	funct3_t funct3 = get_funct3(instr);

	wire [XLEN+1:0] rs_diff_unsign = ({1'b0, rs2} - {1'b0, rs1}); // 34 bits
	wire [XLEN:0] rs_diff_sign = $signed(rs2) - $signed(rs1); // 33 bits
	wire beq_take	= (rs_diff_sign == 34'b0);				// pass
	wire bne_take 	= ~beq_take;						// pass
	wire blt_take 	= $signed(rs_diff_sign[XLEN:0]) > 0;
	wire bltu_take 	= $signed(rs_diff_unsign[XLEN:0]) > 0;	// pass
	wire bge_take 	= ~blt_take;
	wire bgeu_take 	= ~bltu_take;

	wire branch_taken =	((funct3 == BEQ && beq_take)	? taken :
						(funct3 == BNE && bne_take) 	? taken :
						(funct3 == BLT && blt_take) 	? taken :
						(funct3 == BLTU && bltu_take) 	? taken :
						(funct3 == BGE && bge_take) 	? taken :
						(funct3 == BGEU && bgeu_take) 	? taken :
						not_taken) && (opcode == B);


	/*
	possible combos:
	1. pc + imm (branch and JAL)
	2. rs1 + imm (JALR)
	*/
	data_t pc_add_comp =	(branch_taken)		? pc  :
							(opcode == JAL)		? pc  :
							(opcode == JALR)	? rs1 :
							NULL;

	// for B and JAL, the imm is counted in multiple of 2 bytes
	// for JALR, the imm is counted in multuple of single byte
	data_t imm = 	(branch_taken)		? get_imm(instr):
					(opcode == JAL)		? {instr[31]*12, instr[19:12], instr[20], instr[30:21], 1'b0}:  
					(opcode == JALR)	? {instr[31]*20, instr[31:20]} :  // the get_imm for JAL and JALR is 4, for ALU
					NULL;
	
	data_t pc_add = pc_add_comp + imm;

	// JALR should mask the last bit to 0
	assign pc_bj = (opcode == JALR) ? {pc_add[31:1], 1'b0} : pc_add;

	// 1 for branch/jump, 0 for pc + 4
	assign bj_sel = (branch_taken)		? 1'b1 :
					(opcode == JAL)		? 1'b1 :
					(opcode == JALR)	? 1'b1 :
					1'b0;

endmodule
