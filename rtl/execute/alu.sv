import defines::*;
import alu_defines::*;

module alu (
	input logic		clk,	// for multi-cycle computation
	input instr_t	instr,
	input data_t 	a_in,
	input data_t 	b_in,

	output data_t 	c_out,
	output logic	rd_wr,
	output logic	div_result_valid,
	output logic	mul_result_valid
);

	data_t			and_result,
					or_result,
					xor_result,
					set_result,
					shift_result,
					add_sub_result,
					mult_result,
					div_rem_result;

	logic [4:0]		shamt;
	shift_type_t	shift_type;
	logic 			sub_func;
	opcode_t 		opcode;
	funct3_t 		funct3;

	always_comb begin
		funct3 = 	instr.funct3;
		opcode = 	instr.opcode;
		shamt  = 	instr.rs2;
		shift_type = shift_type_t'(instr[30]); // 0 for logical, 1 for arith
		sub_func = (opcode == R) & instr[30];
	end
	
	
	logic 		invA, invB, plus1;		// for add/suber
	logic		set_flag;


	always_comb begin : ander
		and_result = (opcode == R) ?	a_in & b_in : 
										a_in & get_imm(instr);
	end

	always_comb begin : orer
		or_result = (opcode == R) ?	a_in | b_in : 
									a_in | get_imm(instr);
	end

	always_comb begin : xorer
		xor_result = (opcode == R) ?	a_in ^ b_in : 
										a_in ^ get_imm(instr);
	end

	always_comb begin : seter
		set_result = set_flag ? 32'b1 : NULL;
	end

	always_comb begin : shifter
		shift_result = NULL;
		unique case ({shift_type, funct3, opcode})
			{logical, SLL, R}: 		shift_result = a_in 			<<	b_in[4:0];
			{logical, SRL, R}: 		shift_result = a_in 			>>	b_in[4:0];
			{arithmetic, SRA, R}:	shift_result = $signed(a_in)	>>>	b_in[4:0];
			{logical, SLLI, I}:		shift_result = a_in 			<<	$unsigned(shamt);
			{logical, SRLI, I}:		shift_result = a_in 			>>	$unsigned(shamt);
			{arithmetic, SRAI, I}:	shift_result = $signed(a_in) 	>>>	$unsigned(shamt);
			default: 				shift_result = NULL;
		endcase
	end

	data_t adder_in1, adder_in2;
	logic [XLEN: 0]	adder_out;

	logic set_signed_flag;  
	logic set_unsigned_flag;
	//logic adder_msb;
	always_comb begin : add_suber
		invA =	((funct3 == SLT) 	? ENABLE :
				(funct3 == SLTI) 	? ENABLE :
				(funct3 == SLTU) 	? ENABLE :
				(funct3 == SLTIU)	? ENABLE :
				DISABLE) & (opcode == I); // only I type should need to invert A;
		invB =	(funct3 == SUB & sub_func) ? ENABLE : DISABLE;

		plus1 = invA | invB;	// A - B = A + ~B + 1
		adder_in1 = invA ? ~a_in : a_in;
		// there should not be any instr in I-type that need to inv B
		// so hopefully no bug here.
		adder_in2 = (opcode == I)	? get_imm(instr) // TODO: this line might not need
									: (invB ? ~b_in : b_in);

		adder_out = $unsigned(adder_in1) + $unsigned(adder_in2);
		add_sub_result = plus1 ? (adder_out[XLEN-1:0] + 1) : adder_out[XLEN-1:0];

		// I could not use one single adder to achieve both add, sub, and set
		/*
		set_flag = 	(funct3 == SLT & $signed(adder_out[XLEN-1:0]) > 32'b0) ? ENABLE :
					(funct3 == SLTU & $signed(adder_out[XLEN-1:0]) > 33'b0) ? ENABLE :
					DISABLE;
		*/
		set_signed_flag = ($signed(a_in) < $signed(b_in)) ? ENABLE : DISABLE;
		set_unsigned_flag = ($unsigned(a_in) < $unsigned(b_in)) ? ENABLE : DISABLE;
		set_flag = 	(funct3 == SLT & set_signed_flag) ? ENABLE :
					(funct3 == SLTU & set_unsigned_flag) ? ENABLE :
					DISABLE;
	end


	// TODO: use generate on flag M_SUPPORT
	multiplier multiplierer (
		.clk	(clk),
		.instr	(instr),
		.a_in	(a_in),
		.b_in	(b_in),
		.valid	(mul_result_valid),
		.c_out	(mult_result)
	);
	
	// TODO: use generate on flag M_SUPPORT
	divider dividerer (
		.clk	(clk),
		.instr	(instr),
		.a_in	(a_in),
		.b_in	(b_in),
		.valid	(div_result_valid),
		.c_out	(div_rem_result)
	);


	logic div_instr;
	always_comb begin : output_sel
		c_out = NULL;
		rd_wr = DISABLE;
		div_instr = funct3[2];
		unique case (opcode)
			R: begin
				rd_wr = ENABLE;
				unique case (instr.funct7)
					M_INSTR: begin
						if (div_instr) begin	// div instruction
							c_out = div_rem_result;
						end else begin
							c_out = mult_result;
						end
					end

					default: begin
						unique case (funct3)
							ADD:	c_out = add_sub_result;	// same as SUB
							AND: 	c_out = and_result;
							OR: 	c_out = or_result;
							XOR: 	c_out = xor_result;
							SLT: 	c_out = set_result;
							SLTU:	c_out = set_result;
							SLL: 	c_out = shift_result;
							SRL: 	c_out = shift_result;	// same as SRA
							default:c_out = NULL;
						endcase
					end
				endcase
			end
			
			I: begin
				rd_wr = ENABLE;
				unique case (funct3)
					ADD:		c_out = add_sub_result;	// same as SUB
					AND: 		c_out = and_result;
					OR: 		c_out = or_result;
					XOR: 		c_out = xor_result;
					SLT: 		c_out = set_result;
					SLTU:		c_out = set_result;
					SLL: 		c_out = shift_result;
					SRL: 		c_out = shift_result;	// same as SRA
					default:	c_out = NULL;
				endcase
			end

			B: begin
				c_out = NULL;
				rd_wr = DISABLE;
			end

			LUI: begin
				c_out = b_in; // should already be extended imm
				rd_wr = ENABLE;
			end

			AUIPC: begin
				c_out = add_sub_result;
				rd_wr = ENABLE;
			end

			JAL: begin
				c_out = add_sub_result;
				rd_wr = ENABLE;
			end

			JALR: begin
				c_out = add_sub_result;
				rd_wr = ENABLE;
			end

			LOAD: begin
				c_out = add_sub_result;
				rd_wr = ENABLE;
			end

			STORE: begin
				c_out = add_sub_result;
				rd_wr = DISABLE;
			end

			MEM: begin
				c_out = NULL;
				rd_wr = DISABLE;
			end

			SYS: begin
				c_out = NULL;
				rd_wr = DISABLE;
			end

			default: begin
				c_out = NULL;
				rd_wr = DISABLE;
			end
		endcase
	end
	
endmodule
