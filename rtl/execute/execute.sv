`include "../opcode.svh"

module execute (
	// ctrl 
	input fwd_sel_t fwd_a,
	input fwd_sel_t fwd_b,

	// input
	input data_t rs1,
	input data_t pc,
	input data_t rs2,
	input data_t imm,
	input instr_t instr,

	// fwd data
	input data_t ex_ex_fwd_data,
	input data_t mem_ex_fwd_data,

	// output
	output data_t alu_result,
	output logic rd_wren
);

	data_t a_out, b_out;

	ex_mux ex_mux_inst (
		// input
		.instr				(instr),
		.pc					(pc),
		.rs1				(rs1),
		.rs2				(rs2),
		.imm				(imm),
		.ex_ex_fwd_data		(ex_ex_fwd_data),
		.mem_ex_fwd_data	(mem_ex_fwd_data),
		.fwd_a(fwd_a),
		.fwd_b(fwd_b),

		// output
		.a_out(a_out),
		.b_out(b_out)
	);

	alu alu_inst (
		// input
		.instr	(instr),
		.a_in	(a_in),
		.b_in	(b_in),

		// output
		.c_out	(c_out),
		.rd_wr	(rd_wren)
	);
	
endmodule
