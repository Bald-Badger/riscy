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

	// opcode = R, instr.funct7 = M_INSTR, div_instr&div_result_valid
	// opcode = R, instr.funct7 = M_INSTR, mul_result_vaild&~div_instr
	// opcode = R, compare cout, when R, rd_wr = enable 

	// opcode = I, rd_wr = enable 
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
					ADDI:		c_out = add_sub_result;	// same as SUB
					ANDI: 		c_out = and_result;
					ORI: 		c_out = or_result;
					XORI: 		c_out = xor_result;
					SLTI: 		c_out = set_result;
					SLTIU:		c_out = set_result;
					SLLI: 		c_out = shift_result;
					SRLI: 		c_out = shift_result;	// same as SRA
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

			ATOMIC: begin
				c_out = a_in;
				rd_wr = ENABLE;
			end

			default: begin
				c_out = NULL;
				rd_wr = DISABLE;
			end
		endcase
	end

	opcode_t		opcode_formal;
	funct3_t		funct3_formal;
	shift_type_t	shift_type_formal;
	logic [4:0]     shamt_formal;
	logic			sub_func_formal;

	data_t			c_out_formal;
	logic			rd_wr_formal;
	logic			div_instr_formal;
	

	always_comb begin : formal
		opcode_formal = opcode_t'(instr[6:0]);
		funct3_formal = instr[14:12];

		shamt_formal  = instr[24:20];
		shift_type_formal = shift_type_t'(instr[30]);
		sub_func_formal = (opcode == R) & instr[30];
	end


	assert final((opcode_formal == opcode) 
			&&(funct3 == funct3_formal)
			&&(shamt == shamt_formal)
			&&(shift_type == shift_type_formal)
			&&(sub_func == sub_func_formal))
	else  $display("checker failed at instr/opcode");

	logic[63:0]  mult_a_in;
	logic[63:0]  mult_b_in;

	logic carry_bit, carry_bit_i;
	data_t c_gold, c_gold_i;

	logic[63:0]  mult_raw;

	logic[31:0]  mult_result_formal;

	logic mul_result_valid_formal, div_result_valid_formal;

	assign mult_a_in = {{32{a_in[31]}}, {a_in[31:0]}};

	assign mult_b_in = {{32{b_in[31]}}, {b_in[31:0]}};

	assign mult_raw  = mult_a_in * mult_b_in;

	always_comb begin: mult
		case (funct3_formal)
			MUL:		mult_result_formal = mult_raw[31:0];
			MULH:		mult_result_formal = mult_raw[63:32];
			MULHSU:		mult_result_formal = mult_raw[63:32];
			MULHU:		mult_result_formal = mult_raw[63:32];
			default:	mult_result_formal = NULL;
		endcase
	end

	always_comb begin: output_sel_formal
		c_out_formal = NULL;
		rd_wr_formal = rd_wr;

		mul_result_valid_formal = mul_result_valid;

		div_result_valid_formal = div_result_valid;

		div_instr_formal = funct3_formal[2]; //for div, =1   for mult, = 0

		{carry_bit, c_gold} = a_in + b_in;

		{carry_bit_i, c_gold_i} = a_in + data_t'({ {20{instr[31]}} , instr[31:20]});

		case (opcode_formal)
			R: begin
				unique case(instr[31:25]) //function 7
					M_INSTR: begin
						if (~div_instr)begin
							c_out_formal = mult_result_formal;
							assert property (@(posedge clk) (div_instr) |-> ##[12:12] ((c_out_formal == c_out) && (mul_result_valid && ~div_result_valid)))
							else $display("R-type multiply output value not match");
						end else begin
							c_out_formal = a_in/b_in;
						end
						// assertion needs here						
					end
					//c_out_formal use as golden value
					default: begin
						unique case (funct3_formal)
							ADD:  c_out_formal = c_gold;
							SUB:  c_out_formal = $signed(a_in) - $signed(b_in);
							AND:  c_out_formal = a_in & b_in;
							OR:   c_out_formal = a_in | b_in;
							XOR:  c_out_formal = a_in ^ b_in;
							SLT:  c_out_formal = ($signed(a_in) < $signed(b_in)) ? 32'b1 : 32'b0;
							SLTU: c_out_formal = (a_in < b_in) ? 32'b1 : 32'b0;
							SLL:  c_out_formal = a_in << b_in[4:0];
							SRL:  c_out_formal = a_in >> b_in[4:0];
							default: c_out_formal = NULL;
						endcase
					end 
				endcase

			end

			I: begin
				unique case (funct3_formal)
					ADDI: c_out_formal = c_gold_i;
					ANDI: c_out_formal = a_in & (data_t'({ {20{instr[31]}} , instr[31:20]}));
					ORI:  c_out_formal = a_in | data_t'({ {20{instr[31]}} , instr[31:20]});
					XORI: c_out_formal = a_in ^ data_t'({ {20{instr[31]}} , instr[31:20]});
					SLTI:  c_out_formal = ($signed(a_in) < $signed(data_t'({ {20{instr[31]}} , instr[31:20]}))) ? 32'b1: 32'b0;
					SLTIU: c_out_formal = (a_in < data_t'({ {20{instr[31]}} , instr[31:20]})) ? 32'b1: 32'b0;
					SLLI:  c_out_formal = a_in << instr[24:20];
					SRLI:  c_out_formal = a_in >> instr[24:20];
					default: c_out_formal = NULL;
				endcase

				//$diaplay("for I type, c_out is: %d", c_out);
				//$display("for I type, c_out_formal is: %d", c_out_formal);

				//$display("STATEMENT 1 :: time is %0t",$time);

			end

			LUI:begin
				c_out_formal = {instr[31:12], 12'b0};
			end

			default: begin
				c_out_formal = NULL;
			end


			//LOAD
			//STORE

		endcase
	end 
//assume cover  
	assert property(@(posedge clk)(opcode_formal == I) |-> ((rd_wr == rd_wr_formal) 
					&& (c_out_formal == c_out))) 
	else begin
		$display("I-type output value not match, time: %t", $time);
		$display("c out is %d, formal is %d", c_out, c_out_formal);
					//#100
		//$stop();
	end

	assert property(@(posedge clk)(((opcode_formal == I) && ((funct3_formal == SLLI) || (funct3_formal == SRLI)))) |->
					(instr[31:25] == 7'b0)) 
	else begin
		$display("I-type SLLI/SRLI instr not meet requirment"); 
	end  

	assert property(@(posedge clk)((opcode_formal == R) && (instr[31:25] == M_INSTR) && (~div_instr)) |->
					##[6:6] ((c_out_formal == c_out) && (mul_result_valid && ~div_result_valid) && (rd_wr)))
	else begin
		$display("R-type output value not match, time: %t", $time);
		$display("c out is %d, formal is %d, mul_result_vaild is %d, div_result_valid is %d", c_out, c_out_formal, mul_result_valid, div_result_valid);
	end

	assert property(@(posedge clk)((opcode_formal == R) && (instr[31:25] == M_INSTR) && (div_instr)) |->
					##[12:12] ((c_out_formal == c_out) && (~mul_result_valid && div_result_valid) && (rd_wr)))
	else begin
		$display("R-type output value not match, time: %t", $time);
		$display("c out is %d, formal is %d, mul_result_vaild is %d, div_result_valid is %d", c_out, c_out_formal, mul_result_valid, div_result_valid);
	end

	assert property(@(posedge clk)((opcode_formal == R) && (instr[31:25] != M_INSTR)) |->
					((c_out_formal == c_out) && (rd_wr)))
	else begin
		$display("R-type output value not match, time: %t", $time);
		$display("c out is %d, formal is %d, rd_wr is %d", c_out, c_out_formal, rd_wr);
	end


	


	assert property(@(posedge clk)(opcode_formal == LUI) |-> ((rd_wr) && (c_out_formal == c_out)))
	else begin
		$display("LUI output not match, time: %t", $time);
		$display("c out is %d, formal is %d, rd is %d", c_out, c_out_formal, rd_wr); 
	end   


	assert property(@(posedge clk)((opcode_formal == AUIPC) |-> (rd_wr)))
	else begin
		$display("AUIPC-type output value not match, rd_wr value is %d", rd_wr);
	end
				
	assert property(@(posedge clk)(opcode_formal == JAL) |-> (rd_wr))
	else begin
		$display("JAL-type output value not match, rd_wr value is %d", rd_wr);
	end

	assert property(@(posedge clk)(opcode_formal == JALR) |-> (rd_wr))
	else begin
		$display("JALR-type output value not match, rd_wr value is %d", rd_wr);
	end

	assert property(@(posedge clk)(opcode_formal == B) |-> 
					((c_out_formal == NULL) && (~rd_wr)))
	else begin
		$display("B-type output value not match, time: %t", $time);
		$display("c out is %d, formal is %d, rd_wr is %d", c_out, c_out_formal, rd_wr);
	end

	
endmodule
