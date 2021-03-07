import defines::*;

module branch_predict (
	input instr_t instr,
	output logic taken
);

	// a very naive branch predictor, act as placeholder
	// backward-taken-forward-not-taken
	always_comb begin : predictor
		taken =	(instr.opcode != B) ? 1'b0 :
				(instr[XLEN-1]) ? 1'b1 :
				1'b0;
	end

endmodule
