import defines::*;

module branch_predict (
	input	instr_t	instr,
	output	logic	taken
);

	always_comb begin : predictor
		unique case (PREDICTOR)
			P_TAKEN:	taken = TAKEN;
			P_N_TAKEN:	taken = NOT_TAKEN;
			BTFNT:		taken =	(instr.opcode != B)	? NOT_TAKEN :	// no action if not branch instrution
								(instr[XLEN-1])		? TAKEN :		// PC pffset is negative value, branch take
								NOT_TAKEN;							// PC offset is positive value, branch (not) take
			default:	taken = NOT_TAKEN;
		endcase
	end

endmodule : branch_predict
