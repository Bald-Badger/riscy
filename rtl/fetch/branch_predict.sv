import defines::*;

module branch_predict (
	input	instr_t	instr,
	output	logic	taken
);

	// a very naive branch predictor, act as placeholder
	// backward-taken-forward-not-taken
	always_comb begin : predictor
		taken =	(instr.opcode != B)		? 1'b0 :	// no action if not branch instrution
				(instr[XLEN-1])			? 1'b1 :	// PC pffset is negative value, branch take
										  1'b0 ;	// PC offset is positive value, branch (not) take
	end

endmodule : branch_predict
