import defines::*;

module fetch (
	// general input
	input	logic	clk, 
	input	logic	rst_n,

	// input
	input	data_t	pc_bj,
	input 	logic	pc_sel,
	input 	logic	stall,
	input	logic	flush,
	input	logic	go,

	// output
	output	data_t	pc_p4_out,
	output	data_t	pc_out,
	output	instr_t	instr,
	output	logic	taken,
	output	logic	instr_valid
);
	instr_t instr_raw;
	assign instr = 	(~instr_valid)	? NOP : 
					(flush)			? NOP : // mask the output as if flushed
									instr_raw;
	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			instr_valid <= INVALID;
		else
			instr_valid <= go;
	end

	data_t pc, pc_p4;
	
	always_ff @(posedge clk) begin : pc_delay
		if (stall)
			pc_out <= pc_out;
		else
			pc_out <= pc;
	end
	
	assign pc_p4_out = pc_out + 4;

	pc pc_inst (
		// input
		.clk	(clk),
		.rst_n	(rst_n),
		.pc_bj	(pc_bj),
		.pc_sel	(pc_sel),
		.stall	(stall),

		// output
		.pc		(pc),
		.pc_p4	(pc_p4)
	);


	instr_mem instr_mem_inst (
		.clk	(clk),
		.rst_n	(rst_n),
		.rden	(~flush),
		.stall	(stall),
		.addr	(pc),
		.instr	(instr_raw)
	);


	// not implemented yet
	branch_predict branch_predictor (
		.instr	(instr),
		.taken	(taken)
	);
	
endmodule : fetch
