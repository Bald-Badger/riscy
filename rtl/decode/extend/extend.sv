`include "../../opcode.vh"

module extend (
    input [`XLEN-1:0] instr,
	output [`XLEN-1:0] imm
);
    
	wire[6:0] opcode = instr[6:0];
	 
	assign imm =	(opcode == `LUI)	? {instr[31:12], 12'b0}:
					(opcode == `AUIPC) 	? {instr[31:12], 12'b0}:
					(opcode == `JAL) 	? {32'd4}: // rd = pc + 4
					(opcode == `JALR) 	? {32'd4}: // rd = pc + 4
					(opcode == `B) 		? {instr[31]*20, instr[7], instr[30:25], instr[11:8], 0}:
					(opcode == `LOAD) 	? {instr[31]*20, instr[31:20]}:
					(opcode == `STORE) 	? {instr[31]*20, instr[31:25], instr[11:7]}:
					(opcode == `I) 		? {instr[31]*20, instr[31:20]}:
					`NULL;

endmodule