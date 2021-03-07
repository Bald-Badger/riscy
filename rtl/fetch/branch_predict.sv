import defines::*;

module branch_predict (
	input instr_t instr,
	output branch_take_t taken
);

	// a very naive branch predictor, act as placeholder
	// backward-taken-forward-not-taken
	always_comb begin : predictor
		taken =	(instr.opcode != B) ? DONT_CARE :
				(instr[XLEN-1]) ? TAKEN :
				NOT_TAKEN;
	end

endmodule
