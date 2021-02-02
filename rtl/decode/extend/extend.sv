`include "../../opcode.vh"

module extend (
    input [`XLEN-1:0] instr,
	output [`XLEN-1:0] imm
);
    
	wire[6:0] opcode = instr[6:0];
	 
	assign imm =	(opcpde == `LUI)	? {instr[31:12], 12'b0}:
					(opcpde == `AUIPC) 	? {instr[31:12], 12'b0}:
					(opcpde == `JAL) 	? {32'd4}: // rd = pc + 4
					(opcpde == `JALR) 	? {32'd4}: // rd = pc + 4
					(opcpde == `B) 		? {instr[31]*20, instr[7], instr[30:25], instr[11:8], 0}:
					(opcpde == `LOAD) 	? {instr[31]*20, instr[31:20]}:
					(opcpde == `STORE) 	? {instr[31]*20, instr[31:25], instr[11:7]}:
					(opcpde == `I) 		? {instr[31]*20, instr[31:20]}:
					`NULL;

endmodule