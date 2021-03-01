`include "../opcode.svh"

module extend (
    input instr_t instr,
	output data_t imm
);

	always_comb begin
		imm = get_imm(instr);
	end

endmodule