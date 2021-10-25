import defines::*;

module multiplier (
	input instr_t	instr,
	input data_t 	a_in,
	input data_t	b_in,

	output data_t 	c_out
);

logic[79:0]	mult_result;
logic [39:0] mult_a_in, mult_b_in;


always_comb begin : mult_a_in_assign
	unique case (instr.funct3)
		MUL:		mult_a_in = {{8{a_in[31]}}, a_in[31:0]};
		MULH:		mult_a_in = {{8{a_in[31]}}, a_in[31:0]};
		MULHSU:		mult_a_in = {{8{a_in[31]}}, a_in[31:0]};
		MULHU:		mult_a_in = {8'b0, a_in[31:0]};
		default:	mult_a_in = 40'b0;
	endcase
end


always_comb begin : mult_b_in_assign
	unique case (instr.funct3)
		MUL:		mult_b_in = {{8{b_in[31]}}, b_in[31:0]};
		MULH:		mult_b_in = {{8{b_in[31]}}, b_in[31:0]};
		MULHSU:		mult_b_in = {8'b0, b_in[31:0]};
		MULHU:		mult_b_in = {8'b0, b_in[31:0]};
		default:	mult_b_in = 40'b0;
	endcase
end


// MULHSU: signed rs1 x unsign rs2
mult mult_signed_inst (
		.dataa	( mult_a_in ),
		.datab	( mult_b_in ),
		.result	( mult_result )
);


always_comb begin : mult_sel
	unique case (instr.funct3)
		MUL:		c_out = mult_result[31:0];
		MULH:		c_out = mult_result[63:32];
		MULHSU:		c_out = mult_result[63:32];
		MULHU:		c_out = mult_result[63:32];
		default:	c_out = NULL;
	endcase
end

endmodule : multiplier
