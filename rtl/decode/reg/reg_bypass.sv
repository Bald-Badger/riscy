`include "../../opcode.vh"

module reg_bypass (
	input clk,
	input rst_n,

	input [`XLEN-1:0] rd_data,
	input rd_wren,
	input [4:0] rd_addr,

	input [4:0] rs1_addr,
	input [4:0] rs2_addr,
	input 		rs1_rden,
	input 		rs2_rden,

	output [`XLEN-1:0] rs1_data,
	output [`XLEN-1:0] rs2_data
);

	localparam DEPTH = 5'd32;
	reg [`XLEN-1:0] registers [DEPTH-1:0]; 

	integer i;
	always_ff @(posedge clk or negedge rst_n) begin
		for (i = 0; i < DEPTH; i++) begin
			if (~rst_n) begin
				registers[i] <= 0;
			end else if (rd_wren && ( rd_addr != 5'b0 ) && (rd_addr == i)) begin
				registers[i] <= rd_data;
			end else begin
				registers[i] <= registers[i];
			end
		end
	end
	

	// bypass logic
	wire bypass_rs1 = (rd_wren && rs1_rden) && (rs1_addr == rd_addr);
	wire bypass_rs2 = (rd_wren && rs2_rden) && (rs2_addr == rd_addr);

	assign rs1_data = 	rs1_addr == 5'b0	? 0:
						bypass_rs1 			? rd_data : 
						rs1_rden 			? registers[rs1_addr]: 0;
	assign rs2_data = 	rs2_addr == 5'b0	? 0:
						bypass_rs2 			? rd_data : 
						rs2_rden 			? registers[rs2_addr]: 0;
	
endmodule