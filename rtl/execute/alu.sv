`include "../opcode.svh"
`include "./alu_define.svh"

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
			add_sub_result;

	funct3_t 	funct3 = 	instr.funct3;
	opcode_t 	opcode = 	instr.opcode;
	sign_t		sign_op = 	(funct3 == SLTU) ? unsigned_op:
							(funct3 == SLTIU)? unsigned_op:
							signed_op;
	wire[4:0]	shamt = 	instr.rs2;	// rs2 is at the same position with shamt
	shift_type_t shift_type = shift_type_t'(instr[30]);	// 1 for arith, 0 for logical
	logic 		sub_func = instr[30];		// 1 for sub, 0 for add
	logic 		invA, invB, plus1;		// for add/suber
	logic		adder_msb;
	logic		set_flag;


	always_comb begin : ander
		and_result = a_in & b_in;
	end

	always_comb begin : orer
		or_result = a_in | b_in;
	end

	always_comb begin : xorer
		xor_result = a_in ^ b_in;
	end

	always_comb begin : seter
		set_result = set_flag ? 32'b1 : NULL;
	end

	always_comb begin : shifter
		shift_result = NULL;
		unique case ({shift_type, funct3})
			// BUG!!! funct3 not unique
			{logical, SLL}: 	shift_result = a_in << $unsigned(shamt);	// funct3 of SLL is the same as SLLI
			{logical, SRL}: 	shift_result = a_in >> $unsigned(shamt); 	// funct3 of SRL is the same as SRLI
			{arithmetic, SRA}:	shift_result = a_in >>> $unsigned(shamt);	// funct3 of SRA is the same as SRAI
			default: 			shift_result = NULL;
		endcase
	end

	data_t adder_in1, adder_in2;
	logic[XLEN: 0] adder_out;
	always_comb begin : add_suber
		invA =	(funct3 == SLT) 	? 1 :
				(funct3 == SLTI) 	? 1 :
				(funct3 == SLTU) 	? 1 :
				(funct3 ==  SLTIU)	? 1 :
				0;
		invB =	(funct3 == SUB & sub_func) ? 1 : 0;

		plus1 = invA | invB;
		adder_in1 = invA ? ~a_in : a_in;
		adder_in2 = invB ? ~b_in : b_in;

		adder_out = adder_in1 + adder_in2;
		set_flag = 	(funct3 == SLT & $signed(adder_out) > 0) ? 1 :
					(funct3 == SLTU & $signed(adder_out[XLEN-1:0]) > 0) ? 1 :
					0;

		add_sub_result = plus1 ? (adder_out[XLEN-1:0] + 1) : adder_out[XLEN-1:0];
	end

	always_comb begin : output_sel
		c_out = NULL;
		rd_wr = 1'b0;
		unique case (instr.opcode)

			R: begin
				unique if	(funct3 == ADD)	c_out = add_sub_result; // same as SUB
				else if		(funct3 == AND) c_out = and_result;
				else if		(funct3 == OR) 	c_out = or_result;
				else if		(funct3 == XOR) c_out = xor_result;
				else if		(funct3 == SLT) c_out = set_result;
				else if		(funct3 == SLTU)c_out = set_result;
				else if		(funct3 == SLL) c_out = shift_result;
				else if		(funct3 == SRL) c_out = shift_result;
				else if		(funct3 == SRA) c_out = shift_result;
				else 						c_out = NULL;
				rd_wr = 1'b1;
			end

			I: begin
				unique if	(funct3 == ADDI)	c_out = add_sub_result;
				else if		(funct3 == ANDI) 	c_out = and_result;
				else if		(funct3 == ORI) 	c_out = or_result;
				else if		(funct3 == XORI) 	c_out = xor_result;
				else if		(funct3 == SLTI) 	c_out = set_result;
				else if		(funct3 == SLTIU)	c_out = set_result;
				else if		(funct3 == SLLI) 	c_out = shift_result;
				else if		(funct3 == SRLI) 	c_out = shift_result;
				else if		(funct3 == SRAI) 	c_out = shift_result;
				else 							c_out = NULL;
				rd_wr = 1'b1;
			end

			B: begin
				c_out = NULL;
				rd_wr = 1'b0;
			end

			LUI: begin
				c_out = NULL;
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
