import defines::*;

module pc (
	//input
	input clk, 
	input rst_n,
	input data_t pc_bj,
	input pc_sel,			// 1 for bj, 0 for p4
	input stall, 

	//output
	output data_t pc,
	output data_t pc_p4
);

	assign pc_p4 = pc + 32'd4; // 32 bits in byte-addressable, so 32/8 = 4

	always_ff @(negedge clk or negedge rst_n) begin
		if (~rst_n) pc <= -4;	// funking sketchy, but can get around bug
		else if (stall) pc <= pc;
		else if (pc_sel) pc <= pc_bj;
		else pc <= pc_p4;
	end

endmodule
