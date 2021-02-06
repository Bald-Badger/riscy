`include "../../opcode.svh"

module extend (
    input instr_t instr,
	output data_t imm
);

	assign imm = get_imm(instr);

endmodule