import defines::*;

module decode (
	// general
	input logic			clk,
	input logic 		rst_n,

	// input 
	input data_t 		pc,
	input instr_t		instr,
	input data_t 		wd, // write back data
	input r_t 			waddr,
	input logic 		wren,
	input data_t		ex_data,
	input data_t		mem_data,
	input data_t		wb_data,
	input id_fwd_sel_t	fwd_rs1,
	input id_fwd_sel_t	fwd_rs2,

	// output
	output data_t 		pc_bj,
	output logic 		pc_sel,
	output data_t 		rs1,
	output data_t 		rs2,
	output data_t 		imm,
	output logic		branch_taken
);
	
	pc_adder pc_adder_inst (
		// input 
		.instr			(instr),
		.pc				(pc),
		.rs1			(rs1),
		.rs2			(rs2),
		.ex_data		(ex_data),
		.mem_data		(mem_data),
		.wb_data		(wb_data),
		.fwd_rs1		(fwd_rs1),
		.fwd_rs2		(fwd_rs2),

		// output
		.pc_bj			(pc_bj),
		.pc_sel			(pc_sel),
		.pc_nxt			(pc_nxt),
		.branch_taken	(branch_taken)
	);

	registers registers_inst (
		// general
		.clk			(clk),
		.rst_n			(rst_n),

		// input 
		.instr			(instr),
		.rd_data		(wd),
		.rd_wren		(wren),
		.rd_addr		(waddr),

		// output
		.rs1_data		(rs1),
		.rs2_data		(rs2)
	);

	extend extend_inst (
		// input 
		.instr			(instr),

		// output
		.imm			(imm)
	);

endmodule : decode
