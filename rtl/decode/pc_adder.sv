// computes the branch / jump target PC

import defines::*;

module pc_adder (
	input	instr_t			instr,
	input	data_t			pc,
	input	data_t			rs1,
	input	data_t			rs2,
	input	data_t			ex_data,
	input	data_t			mem_data,
	input	data_t			wb_data,
	input	id_fwd_sel_t	fwd_rs1,
	input	id_fwd_sel_t	fwd_rs2,

	output	data_t			pc_bj,
	output	data_t			pc_nxt,
	output	logic			pc_sel,
	output	logic			branch_taken
);

	localparam taken		= 1'b1;
	localparam not_taken	= 1'b0;

	opcode_t opcode;
	funct3_t funct3;
	always_comb begin
		opcode = instr.opcode;
		funct3 = instr.funct3;
	end

	data_t op1, op2;
	always_comb begin : branch_forward_mux
		op1 =	(fwd_rs1 == RS_ID_SEL) 	? rs1 :
				(fwd_rs1 == EX_ID_SEL) 	? ex_data :
				(fwd_rs1 == MEM_ID_SEL)	? mem_data :
				(fwd_rs1 == WB_ID_SEL) 	? wb_data :
				NULL;

		op2 =	(fwd_rs2 == RS_ID_SEL) 	? rs2 :
				(fwd_rs2 == EX_ID_SEL) 	? ex_data :
				(fwd_rs2 == MEM_ID_SEL)	? mem_data :
				(fwd_rs2 == WB_ID_SEL) 	? wb_data :
				NULL;
	end

/*
	logic [XLEN+1:0] rs_diff_unsign;
	logic [XLEN:0] rs_diff_sign;
	logic beq_take;
	logic bne_take;
	logic blt_take;
	logic bltu_take;
	logic bge_take;
	logic bgeu_take;

	always_comb begin
		rs_diff_unsign	= ({1'b0, op2} - {1'b0, op1});
		rs_diff_sign	= $signed(op2) - $signed(op1);
		beq_take		= (rs_diff_sign == 34'b0);
		bne_take 		= ~beq_take;
		blt_take 		= $signed(rs_diff_sign[XLEN:0]) > 0;
		bltu_take 		= $signed(rs_diff_unsign[XLEN:0]) > 0;
		bge_take 		= ~blt_take;
		bgeu_take 		= ~bltu_take;
	end
*/

	logic beq_take;
	logic bne_take;
	logic blt_take;
	logic bltu_take;
	logic bge_take;
	logic bgeu_take;

	always_comb begin : branck_taken_assign
		beq_take	= (op1 == op2);
		bne_take	= (op1 != op2);
		blt_take	= ($signed(op1) < $signed(op2));
		bltu_take	= ($unsigned(op1) < $unsigned(op2));
		bge_take 	= ($signed(op1) >= $signed(op2));
		bgeu_take	= ($unsigned(op1) >= $unsigned(op2));
	end
	

	always_comb begin
		branch_taken =	
			(
				(funct3 == BEQ && beq_take)		? taken :
				(funct3 == BNE && bne_take) 	? taken :
				(funct3 == BLT && blt_take) 	? taken :
				(funct3 == BLTU && bltu_take) 	? taken :
				(funct3 == BGE && bge_take) 	? taken :
				(funct3 == BGEU && bgeu_take) 	? taken :
				not_taken
			) && (opcode == B);
	end

	/*
	possible combos:
	1. pc + imm (branch and JAL)
	2. rs1 + imm (JALR)
	*/

	// for B and JAL, the imm is counted in multiple of 2 bytes
	// for JALR, the imm is counted in multuple of single byte
	data_t imm;
	always_comb begin
		imm = NULL;
		unique case (opcode)
			B:			imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
			JAL:		imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
			JALR:		imm = {{20{instr[31]}}, instr[31:20]};
			default:	imm	= NULL;
		endcase
	end
	
	data_t pc_add, pc_add_imm, op1_add_imm;

	always_comb begin
		pc_add_imm = pc + imm;
		op1_add_imm = op1 + imm;

		pc_add =	(branch_taken)		? pc_add_imm  :
					(opcode == JAL)		? pc_add_imm  :
					(opcode == JALR)	? op1_add_imm :
					NULL;

		// JALR should mask the last bit to 0
		pc_bj = (opcode == JALR) ? {pc_add[31:1], 1'b0} : pc_add;

		// 1 for branch/jump, 0 for pc + 4
		pc_sel = (branch_taken)		? 1'b1 :
				(opcode == JAL)		? 1'b1 :
				(opcode == JALR)	? 1'b1 :
				1'b0;
		pc_nxt = (pc_sel) ? pc_bj : pc + 32'd4;
	end

endmodule : pc_adder
