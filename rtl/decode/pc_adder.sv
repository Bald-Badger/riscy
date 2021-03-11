import defines::*;

module pc_adder (
	input instr_t instr,
	input data_t pc,
	input data_t rs1,
	input data_t rs2,
	input data_t ex_data,
	input data_t mem_data,
	input data_t wb_data,
	input branch_fwd_t fwd_rs1,
	input branch_fwd_t fwd_rs2,

	output data_t pc_bj,	// no one likes bj
							// bj makes it hard
							// to predict
	output logic pc_sel,
	output logic branch_taken
);

	localparam taken = 1'b1;
	localparam not_taken = 1'b0;

	opcode_t opcode;
	funct3_t funct3;
	always_comb begin
		opcode = instr.opcode;
		funct3 = instr.funct3;
	end

	data_t op1, op2;
	always_comb begin : branch_forward_mux
		op1 =	(fwd_rs1 == B_RS_SEL) 	? rs1 :
				(fwd_rs1 == B_EX_SEL) 	? ex_data :
				(fwd_rs1 == B_MEM_SEL)	? mem_data :
				(fwd_rs1 == B_WB_SEL) 	? wb_data :
				rs1;

		op2 =	(fwd_rs2 == B_RS_SEL) 	? rs2 :
				(fwd_rs2 == B_EX_SEL) 	? ex_data :
				(fwd_rs2 == B_MEM_SEL)	? mem_data :
				(fwd_rs2 == B_WB_SEL) 	? wb_data :
				rs2;
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
		imm = get_imm(instr);
	end
	
	logic carry_bit;
	data_t pc_add;
	assign {carry_bit, pc_add} = pc_add_comp + imm;

	// JALR should mask the last bit to 0
	assign pc_bj = (opcode == JALR) ? {pc_add[31:1], 1'b0} : pc_add;

	// 1 for branch/jump, 0 for pc + 4
	assign pc_sel = (branch_taken)		? 1'b1 :
					(opcode == JAL)		? 1'b1 :
					(opcode == JALR)	? 1'b1 :
					1'b0;

endmodule
