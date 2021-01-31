`include "../../opcode.vh"

module pc_adder (
	input [`XLEN-1:0] instr,
	input [`XLEN-1:0] pc,
	input [`XLEN-1:0] rs1,
	input [`XLEN-1:0] rs2,

	output[`XLEN-1:0] pc_bj,	// no one likes bj
								// bj makes it hard
								// to predict
	output bj_sel
);
	localparam taken = 1'b1;
	localparam not_taken = 1'b0;

	wire[6:0] opcode = instr[6:0];


	wire[2:0] funct3 = instr[14:12];

	wire [`XLEN+1:0] rs_diff = ({0, rs1} - {0, rs2}); // 34 bits

	wire beq_take	= (rs_diff == 0);
	wire bne_take 	= ~beq_take;
	wire blt_take 	= rs_diff[`XLEN+1];
	wire bltu_take 	= rs_diff[`XLEN];
	wire bge_take 	= ~blt_take;
	wire bgeu_take 	= ~bltu_take;

	wire branch_taken =	((funct3 == `BEQ && beq_take)	? taken :
						(funct3 == `BNE && bne_take) 	? taken :
						(funct3 == `BLT && blt_take) 	? taken :
						(funct3 == `BLTU && bltu_take) 	? taken :
						(funct3 == `BGE && bge_take) 	? taken :
						(funct3 == `BGEU && bgeu_take) 	? taken :
						not_taken) && opcode == `B;


	/*
	possible combos:
	1. pc + imm (branch and JAL)
	2. rs1 + imm (JALR)
	*/
	wire[`XLEN-1:0] pc_add_comp =	(branch_taken)		? pc  :
									(opcode == `JAL)	? pc  :
									(opcode == `JALR)	? rs1 :
									`NULL;

	// for B and JAL, the imm is counted in multiple of 2 bytes
	// for JALR, the imm is counted in multuple of single byte
	wire[`XLEN-1:0] imm = 	(branch_taken)		? {instr[31]*20, instr[7], instr[30:25], instr[11:8], 0}:
							(opcode == `JAL)	? {instr[31]*12, instr[19:12], instr[20], instr[30:21], 0}:
							(opcode == `JALR)	? {instr[31]*20, instr[31:20]} :
							`NULL;
	
	wire[`XLEN-1:0] pc_add = pc_add_comp + imm;

	// JALR should mask the last bit to 0
	assign pc_bj = (opcode == `JALR) ? {pc_add[31:1], 0} : pc_add;

	// 1 for branch/jump, 0 for pc + 4
	assign bj_sel = (branch_taken)		? 1 :
					(opcode == `JAL)	? 1 :
					(opcode == `JALR)	? 1 :
					0;

endmodule
