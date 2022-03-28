import defines::*;

module pc (
	//input
	input logic		clk, 
	input logic		rst_n,
	input data_t	pc_bj,
	input logic		pc_sel, // 1 for bj, 0 for p4
	input logic		stall, 

	//output
	output data_t 	pc,
	output data_t 	pc_p4
);

	logic[XLEN-1:0] boot_pc [0:0];	

	assign pc_p4 = pc + 32'd4; // 32 bits in byte-addressable memory system, so 32/8 = 4

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n)
			if (BOOT_TYPE == BINARY_BOOT) begin
				pc <= boot_pc[0];
			end else if (BOOT_TYPE == RARS_BOOT) begin
				pc <= NULL;
			end else begin
				pc <= NULL;
			end
		else if (stall)
			pc <= pc;
		else if (pc_sel)
			pc <= pc_bj;
		else
			pc <= pc_p4;
	end

	// synopsys translate_off
	initial begin
		if (BOOT_TYPE == BINARY_BOOT) begin
			$readmemh("boot.cfg", boot_pc);
			$display("DUT: boot mode: binary");
			$display("DUT: booting from pc = %h", boot_pc[0]);
		end else if (BOOT_TYPE == RARS_BOOT) begin
			$display("DUT: boot mode: RARS");
			$display("DUT: booting from pc = %h", 0);
		end
	end
	// synopsys translate_on

endmodule : pc
