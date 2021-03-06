import defines::*;

module wb (
	input instr_t	instr,
	input data_t	alu_result,
	input data_t	mem_data,
	input data_t	pc_p4,
	output data_t	wb_data
);

	opcode_t opcode;
	always_comb begin
		opcode = instr.opcode;
	end

	always_comb begin : wb_sel
		unique case (opcode)

			R: begin
				wb_data = alu_result;
			end

			I: begin
				wb_data = alu_result;
			end

			B: begin
				wb_data = NULL;
			end

			LUI: begin
				wb_data = alu_result;
			end

			AUIPC: begin
				wb_data = alu_result;
			end

			JAL: begin
				wb_data = pc_p4;
			end

			JALR: begin
				wb_data = pc_p4;
			end

			LOAD: begin
				wb_data = mem_data;
			end

			STORE: begin
				wb_data = NULL;
			end

			MEM: begin
				wb_data = NULL;
			end

			SYS: begin
				wb_data = NULL;
			end

			default: begin
				wb_data = NULL;
			end
		endcase
	end
	
endmodule