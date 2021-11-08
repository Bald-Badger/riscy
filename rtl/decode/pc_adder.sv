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

	wire [XLEN+1:0] rs_diff_unsign = ({1'b0, op2} - {1'b0, op1}); // 34 bits
	wire [XLEN:0] rs_diff_sign = $signed(op2) - $signed(op1); // 33 bits
	wire beq_take	= (rs_diff_sign == 34'b0);				// pass
	wire bne_take 	= ~beq_take;						// pass
	wire blt_take 	= $signed(rs_diff_sign[XLEN:0]) > 0;
	wire bltu_take 	= $signed(rs_diff_unsign[XLEN:0]) > 0;	// pass
	wire bge_take 	= ~blt_take;
	wire bgeu_take 	= ~bltu_take;

	assign branch_taken =	((funct3 == BEQ && beq_take)	? taken :
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
	data_t pc_add_comp;
	always_comb begin
		pc_add_comp =	(branch_taken)		? pc  :
						(opcode == JAL)		? pc  :
						(opcode == JALR)	? op1 :
						NULL;
	end

	// for B and JAL, the imm is counted in multiple of 2 bytes
	// for JALR, the imm is counted in multuple of single byte
	data_t imm;
	always_comb begin
		imm = NULL;
		unique case (opcode)
			B:			imm = {{20{instr[31]}} , instr[7], instr[30:25], instr[11:8], 1'b0};
			JAL:		imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
			JALR:		imm = {{20{instr[31]}}, instr[31:20]};
			default:	imm	= NULL;
		endcase
	end
	
	data_t pc_add, pc_add_carry;

	assign pc_add_carry = pc_add_comp + imm; 
	assign pc_add = pc_add_carry[XLEN-1 : 0];

	// JALR should mask the last bit to 0
	assign pc_bj = (opcode == JALR) ? {pc_add[31:1], 1'b0} : pc_add;

	// 1 for branch/jump, 0 for pc + 4
	assign pc_sel = (branch_taken)		? 1'b1 :
					(opcode == JAL)		? 1'b1 :
					(opcode == JALR)	? 1'b1 :
					1'b0;

endmodule : pc_adder
