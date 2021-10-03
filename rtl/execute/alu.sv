import defines::*;
import alu_define::*;

module alu (
	input instr_t	instr,
	input data_t 	a_in,
	input data_t 	b_in,

	output data_t 	c_out,
	output logic	rd_wr
);

	data_t	and_result,
			or_result,
			xor_result,
			set_result,
			shift_result,
			add_sub_result
			mult_div_rem_result;


	logic[4:0]	shamt;
	shift_type_t shift_type;
	logic 		sub_func;
	opcode_t 	opcode;
	funct3_t 	funct3;

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
	logic[XLEN: 0] adder_out;

	logic set_signed_flag;  
	logic set_unsigned_flag;
	//logic adder_msb;
	always_comb begin : add_suber
		invA =	((funct3 == SLT) 	? 1'b1 :
				(funct3 == SLTI) 	? 1'b1 :
				(funct3 == SLTU) 	? 1'b1 :
				(funct3 == SLTIU)	? 1'b1 :
				1'b0) & (opcode == I); // only I type should need to invert A;
		invB =	(funct3 == SUB & sub_func) ? 1'b1 : 1'b0;

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
		set_flag = 	(funct3 == SLT & $signed(adder_out[XLEN-1:0]) > 32'b0) ? 1'b1 :
					(funct3 == SLTU & $signed(adder_out[XLEN-1:0]) > 33'b0) ? 1'b1 :
					1'b0;
		*/
		set_signed_flag = ($signed(a_in) < $signed(b_in)) ? 1'b1 : 1'b0;
		set_unsigned_flag = ($unsigned(a_in) < $unsigned(b_in)) ? 1'b1 : 1'b0;
		set_flag = 	(funct3 == SLT & set_signed_flag) ? 1'b1 :
					(funct3 == SLTU & set_unsigned_flag) ? 1'b1 :
					1'b0;
	end


	mult_div mul_div_remer(
		.instr(instr),
		.a_in(a_in),
		.b_in(b_in),
		.c_out(mult_div_rem_result)
	);
	
	always_comb begin : output_sel
		c_out = NULL;
		rd_wr = 1'b0;
		unique case (opcode)

			R: begin
				rd_wr = 1'b1;
				unique case (instr.funct7)
					M_INSTR: begin
						mult_div_rem_result;
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
				rd_wr = 1'b1;
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
				rd_wr = 1'b0;
			end

			LUI: begin
				c_out = b_in; // should already be extended imm
				rd_wr = 1'b1;
			end

			AUIPC: begin
				c_out = add_sub_result;
				rd_wr = 1'b1;
			end

			JAL: begin
				c_out = add_sub_result;
				rd_wr = 1'b1;
			end

			JALR: begin
				c_out = add_sub_result;
				rd_wr = 1'b1;
			end

			LOAD: begin
				c_out = add_sub_result;
				rd_wr = 1'b1;
			end

			STORE: begin
				c_out = add_sub_result;
				rd_wr = 1'b0;
			end

			MEM: begin
				c_out = NULL;
				rd_wr = 1'b0;
			end

			SYS: begin
				c_out = NULL;
				rd_wr = 1'b0;
			end

			default: begin
				c_out = NULL;
				rd_wr = 1'b0;
			end
		endcase
	end
	
endmodule
