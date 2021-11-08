import defines::*;
import alu_defines::*;

module divider (
	input	logic	clk,
	input	instr_t	instr,
	input	data_t 	a_in,
	input	data_t	b_in,

	output	logic	valid,
	output	data_t 	c_out
);

logic [39:0]	divide_result;
logic [39:0]	remainder;

logic [39:0]	div_a_in, div_b_in;

data_t			overflow_out;
data_t			div_by_0_out;

reg [3:0]		div_counter;
logic			div_instr;

always_comb begin : div_instr_flag_assign
	div_instr = instr.funct3[2];
end

assign valid = (div_counter == DIV_LATENCY);

always_ff @(posedge clk) begin : div_counter_update
	if (valid) begin
		div_counter <= 4'b0;	// reset counter
	end else if ( (instr.funct7 == M_INSTR) && div_instr ) begin
		div_counter <= (div_counter + 4'b1);
	end else begin
		div_counter <= 4'b0;	// reset counter
	end
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


div divide_signed_inst (
		.clock		( clk ),
		.denom		( div_b_in ),
		.numer		( div_a_in ),
		.quotient	( divide_result ),
		.remain		( remainder )
);


div_out_case_t div_out_case, div_out_case_reg;
data_t overflow_result, div_by_0_result;
always_ff @( posedge clk ) begin : special_case_reg
	if (div_counter == 4'b0) begin
		overflow_result		<= overflow_out;
		div_by_0_result		<= div_by_0_out;
		div_out_case_reg	<= div_out_case;
	end else begin
		overflow_result		<= overflow_result;
		div_by_0_result		<= div_by_0_result;
		div_out_case_reg	<= div_out_case_reg;
	end
end


always_comb begin : c_out_assign
	unique case (div_out_case_reg)
		normal_div		: c_out = divide_result[(XLEN-1):0];
		normal_rem		: c_out = remainder[(XLEN-1):0];
		overflow_div	: c_out = overflow_result;
		div_by_0_div	: c_out = div_by_0_result;
	endcase
end


always_comb begin : div_sel
	unique case (instr.funct3)
		DIV:	begin
			if (b_in == 0) begin
				div_out_case = div_by_0_div;
			end else if (a_in == 32'h1000_0000 && b_in == 32'hFFFF_FFFF) begin
				div_out_case = overflow_div;
			end else begin
				div_out_case = normal_div;
			end	
		end

		DIVU:	begin
			if (b_in == 0) begin
				div_out_case = div_by_0_div;
			end else begin
				div_out_case = normal_div;
			end	
		end

		REM:	begin
			if (b_in == 0) begin
				div_out_case = div_by_0_div;
			end else if (a_in == 32'h1000_0000 && b_in == 32'hFFFF_FFFF) begin
				div_out_case = overflow_div;
			end else begin
				div_out_case = normal_rem;
			end
				
		end

		REMU:	begin
			if (b_in == 0) begin
				div_out_case = div_by_0_div;
			end else begin
				div_out_case = normal_rem;
			end
		end

		default: begin
			div_out_case = normal_rem;
		end
	endcase
end


// beahvour spec: riscv-spec p45
always_comb begin : div_by_0_sel
	unique case (instr.funct3)
		DIVU:		div_by_0_out = {XLEN{1'b1}};
		REMU:		div_by_0_out = a_in;
		DIV:		div_by_0_out = {XLEN{1'b1}};
		REM:		div_by_0_out = a_in;
		default:	div_by_0_out = NULL;
	endcase
end


always_comb begin : overflow_sel
	unique case (instr.funct3)
		DIV:		overflow_out = {{1'b1}, {(XLEN-1){1'b0}}};
		REM:		overflow_out = 1'b0;
		default:	overflow_out = NULL;
	endcase
end

endmodule : divider
