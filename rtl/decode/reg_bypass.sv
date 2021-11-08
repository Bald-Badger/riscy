import defines::*;

module reg_bypass (
	input	logic	clk,
	input	logic	rst_n,

	input	data_t	rd_data,
	input	logic	rd_wren,
	input	r_t		rd_addr,

	input	r_t		rs1_addr,
	input	r_t		rs2_addr,
	input	logic	rs1_rden,
	input	logic	rs2_rden,

	output	data_t	rs1_data,
	output	data_t	rs2_data
);

	reg [XLEN-1:0] registers [0:31]; 
	integer i;

	always_ff @(negedge clk or negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 32; i++) begin
				registers[i] <= NULL;
			end
		end else begin
			for (i = 0; i < 32; i++) begin
				if ((i == rd_addr) && (rd_wren)) begin
					registers[i] <= rd_data;
				end else begin
					registers[i] <= registers[i];
				end
			end
		end
	end


	// bypass logic
	wire bypass_rs1 = (rd_wren && rs1_rden) && (rs1_addr == rd_addr);
	wire bypass_rs2 = (rd_wren && rs2_rden) && (rs2_addr == rd_addr);

	assign rs1_data = 	rs1_addr == ZERO	? NULL:
						bypass_rs1 			? rd_data : 
						rs1_rden 			? registers[rs1_addr]: 
						NULL;
	assign rs2_data = 	rs2_addr == ZERO	? NULL:
						bypass_rs2 			? rd_data : 
						rs2_rden 			? registers[rs2_addr]: 
						NULL;
	
endmodule : reg_bypass
