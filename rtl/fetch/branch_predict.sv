import defines::*;

module branch_predict (
	input instr_t instr,
	output branch_take_t taken
);

	// a very naive branch predictor, act as placeholder
	// backward-taken-forward-not-taken
	data_t branch_imm = {instr[31]*20, instr[7], instr[30:25], instr[11:8], 1'b0};
	always_comb begin : predictor
		taken =	(instr.opcode != B) ? DONT_CARE :
				$signed(branch_imm > 0) ? NOT_TAKEN :
				TAKEN;
	end
	
endmodule