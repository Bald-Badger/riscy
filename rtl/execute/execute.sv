import defines::*;

module execute (
	input	logic			clk,

	// ctrl 
	input	ex_fwd_sel_t	fwd_a,
	input	ex_fwd_sel_t	fwd_b,

	// input
	input	data_t			rs1,
	input	data_t			pc,
	input	data_t			rs2,
	input	data_t			imm,
	input	instr_t			instr,

	// fwd data
	input	data_t			ex_ex_fwd_data,
	input	data_t			mem_ex_fwd_data,

	// output
	output	data_t			alu_result,
	output	logic			rd_wren,
	output	logic			execute_busy
);

	data_t	a, b;
	logic	div_result_valid, mul_result_valid;
	logic	div_busy, mul_busy;
	logic	div_instr, mul_instr;

	always_comb begin : execute_busy_assign
		div_instr		=	(instr.funct3[2]);
		div_busy		=	(instr.funct7 == M_INSTR) &&
							(div_instr) &&
							(~div_result_valid) &&
							(instr.opcode == R);
		mul_instr		=	~div_instr;
		mul_busy		=	(instr.funct7 == M_INSTR) &&
							(mul_instr) &&
							(~mul_result_valid) &&
							(instr.opcode == R); 
		execute_busy	=	mul_busy || div_busy;
	end


	ex_mux ex_mux_inst (
		// input
		.instr				(instr),
		.pc					(pc),
		.rs1				(rs1),
		.rs2				(rs2),
		.imm				(imm),
		.ex_ex_fwd_data		(ex_ex_fwd_data),
		.mem_ex_fwd_data	(mem_ex_fwd_data),
		.fwd_a				(fwd_a),
		.fwd_b				(fwd_b),

		// output
		.a_out				(a),
		.b_out				(b)
	);


	alu alu_inst (
		// clk for multi-cycle computation
		.clk				(clk),
		
		// input
		.instr				(instr),
		.a_in				(a),
		.b_in				(b),

		// output
		.c_out				(alu_result),
		.rd_wr				(rd_wren),
		.div_result_valid	(div_result_valid),
		.mul_result_valid	(mul_result_valid)
	);

	property mul_div_not_equal;
		@(posedge clk) ((instr.opcode == R) && (instr.funct7 == M_INSTR)) |-> (div_result_valid && (~mul_result_valid))
	endproperty 
	
	assume property (mul_div_not_equal) //make sure div_result_valid is not equal when multly and divide
	else begin
		$display("property mul and div not match");
	end;
/////////////////////////////////////////////////////////////
	/*property test;
		@(posedge clk) (((instr.opcode == R) ) |-> (execute_busy == 0))
	endproperty 

	assume property (test)
	else begin
		$display("execute_busy is %d, instr_funct7 is %d " ,execute_busy, instr.funct7);
	end;*/

	property property_ex_busy;
		@(posedge clk) ((instr.opcode !=R) |-> (execute_busy == 0))
	endproperty

	assume property (property_ex_busy) //make sure when instr.opcode !=R, exexcute_busy will keep 0
	else begin
		$display("property_ex_busy not match"); 
	end;
///////////////////////////////////////////////////////////
	property property_ex_busy_div;
		@(posedge clk) (((instr.opcode == R) && (instr.funct7 == M_INSTR) && (instr.funct3[2] == 1)) |->
						##[0:11] (execute_busy == 1))
	endproperty

	assume property(property_ex_busy_div) //make sure when divide, under 12 cycles, exectue_busy is always 1
	else begin
		$display("property_ex_busy_div not match, execute_busy is %d", execute_busy);
	end;

	property property_ex_busy_mul;
		@(posedge clk) (((instr.opcode == R) && (instr.funct7 == M_INSTR) && (instr.funct3[2] == 0)) |->
						##[0:5] (execute_busy == 1))
	endproperty

	assume property(property_ex_busy_mul) //make sure when multiply, under 6 cycles, exectue_busy is always 1
	else begin
		$display("property_ex_busy_mul not match, execute_busy is %d", execute_busy);
	end;





	
endmodule : execute
