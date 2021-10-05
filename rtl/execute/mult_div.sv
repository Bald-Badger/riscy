import defines::*;

module mult_div (
	input instr_t	instr,
	input data_t 	a_in,
	input data_t	b_in,

	output data_t 	c_out
);

logic[79:0]	mult_result;
logic[39:0]	divide_result;
logic[39:0]	remainder;

logic [39:0] mult_a_in, mult_b_in;
logic [39:0] div_a_in, div_b_in;

data_t overflow_out;
data_t div_by_0_out;


always_comb begin : mult_a_in_assign
	unique case (instr.funct3)
		MUL:	mult_a_in = {{8{a_in[31]}}, a_in[31:0]};
		MULH:	mult_a_in = {{8{a_in[31]}}, a_in[31:0]};
		MULHSU:	mult_a_in = {{8{a_in[31]}}, a_in[31:0]};
		MULHU:	mult_a_in = {8'b0, a_in[31:0]};
		default:mult_a_in = 40'b0;
	endcase
end


always_comb begin : mult_b_in_assign
	unique case (instr.funct3)
		MUL:	mult_b_in = {{8{b_in[31]}}, b_in[31:0]};
		MULH:	mult_b_in = {{8{b_in[31]}}, b_in[31:0]};
		MULHSU:	mult_b_in = {8'b0, b_in[31:0]};
		MULHU:	mult_b_in = {8'b0, b_in[31:0]};
		default:mult_b_in = 40'b0;
	endcase
end


always_comb begin : div_a_in_assign
	unique case (instr.funct3)
		DIV:	div_a_in = {{8{a_in[31]}}, a_in[31:0]};
		DIVU:	div_a_in = {8'b0, a_in[31:0]};
		REM:	div_a_in = {{8{a_in[31]}}, a_in[31:0]};
		REMU:	div_a_in = {8'b0, a_in[31:0]};
		default:div_a_in = 40'b0; 
	endcase
end


always_comb begin : div_b_in_assign
	unique case (instr.funct3)
		DIV:	div_b_in = {{8{b_in[31]}}, b_in[31:0]};
		DIVU:	div_b_in = {8'b0, b_in[31:0]};
		REM:	div_b_in = {{8{b_in[31]}}, b_in[31:0]};
		REMU:	div_b_in = {8'b0, b_in[31:0]};
		default:div_b_in = 40'b0; 
	endcase
end


// MULHSU: signed rs1 x unsign rs2
mult mult_signed_inst (
		.dataa ( mult_a_in ),
		.datab ( mult_b_in ),
		.result ( mult_result )
	);


div divide_signed_inst (
		.denom ( div_b_in ),
		.numer ( div_a_in ),
		.quotient ( divide_result ),
		.remain ( remainder )
	);


always_comb begin : mult_div_sel
	unique case (instr.funct3)
		MUL:	c_out = mult_result[31:0];
		MULH:	c_out = mult_result[63:32];
		MULHSU:	c_out = mult_result[63:32];
		MULHU:	c_out = mult_result[63:32];
		DIV:	begin
			if (b_in == 0)
				c_out = div_by_0_out;
			else if (a_in == 32'h1000_0000 && b_in == 32'hFFFF_FFFF)
				c_out = overflow_out;
			else
				c_out = divide_result[31:0];
		end
		DIVU:	begin
			if (b_in == 0)
				c_out = div_by_0_out;
			else
				c_out = divide_result[31:0];
		end
		REM:	begin
			if (b_in == 0)
				c_out = div_by_0_out;
			else if (a_in == 32'h1000_0000 && b_in == 32'hFFFF_FFFF)
				c_out = overflow_out;
			else
				c_out = remainder[31:0];
		end
		REMU:	begin
			if (b_in == 0)
				c_out = div_by_0_out;
			else
				c_out = remainder[31:0];
		end
		default:c_out = NULL;
	endcase
end


// beahvour discription: riscv-spec p45
always_comb begin : div_by_0_sel
	unique case (instr.funct3)
		DIVU:	div_by_0_out = {XLEN{1'b1}};
		REMU:	div_by_0_out = a_in;
		DIV:	div_by_0_out = {XLEN{1'b1}};
		REM:	div_by_0_out = b_in;
		default:div_by_0_out = NULL;
	endcase
end


always_comb begin : overflow_sel
	unique case (instr.funct3)
		DIV:	overflow_out = {{1'b1}, {(XLEN-1){1'b0}}};
		REM:	overflow_out = 1'b0;
		default:overflow_out = NULL;
	endcase
end


endmodule
