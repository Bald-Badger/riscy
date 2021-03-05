// top module of the processor
`include "./opcode.svh"

module proc(
	input clk,
	input rst_n
);
	
	// from the first pipeline stage
	data_t 	pc_f, pc_d, pc_x, pc_m, pc_w;
	data_t 	pcp4_f, pcpr_d, pcp4_x, pcp4_m, pcp4_w;
	instr_t	instr_f, instr_d, instr_x, instr_m, instr_w;

	logic pc_sel;
	fetch fetch_inst (
		// input
		.pc_bj			(pc_d),
		.pc_sel			(pc_sel),
		.en_instr_mem	(ENABLE), // TODO:
		.stall			(DISABLE), // TOSO:

		// output
		.pc_p4			(pcpd_f),
		.pc				(pc_f),
		.instr			(instr_f)
	);


endmodule : proc
