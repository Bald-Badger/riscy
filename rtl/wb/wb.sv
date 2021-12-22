import defines::*;

module wb (
	input	instr_t	instr,
	input	data_t	alu_result,
	input	data_t	mem_data,
	input	data_t	pc_p4,
	output	data_t	wb_data
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

	opcode_t		opcode_formal;
	//assert final ((instr.opcode == SYS) |->  (wb_data== NULL));
	always_comb begin formal:
		opcode_formal = opcode_t'(instr[6:0]);
	end

	always_comb begin: wb_sel_formal 
		case(opcode_formal)
			R: begin
				R_type_wb: assert (wb_data == alu_result) begin
					$display("WB: R-type pass");
				end else begin
					$display("WB: R-type doesn't pass");
				end
			end

			I: begin
				I_type_wb: assert ((wb_data == alu_result) || (instr == NOP)) begin
					$display("WB: I-type pass");
				end else begin
					$display("WB: I-type doesn't pass, wb_data is %d, alu_result is %d", wb_data, alu_result);
				end
			end

			B: begin
				B_type_wb: assert (wb_data == NULL) begin
					$display("WB: B-type pass");
				end else begin
					$display("WB: B-type doesn't pass");
				end
			end

			LUI: begin
				LUI_type_wb: assert (wb_data == alu_result) begin
					$display("WB: LUI-type pass");
				end else begin
					$display("WB: LUI-type doesn't pass");
				end
			end

			AUIPC: begin
				AUIPC_type_wb: assert (wb_data == alu_result) begin
					$display("WB: AUIPC-type pass");
				end else begin
					$display("WB: AUIPC-type doesn't pass");
				end
			end

			JAL: begin
				JAL_type_wb: assert (wb_data == pc_p4) begin
					$display("WB: JAL-type pass");
				end else begin
					$display("WB: JAL-type doesn't pass");
				end
			end

			JALR: begin
				JALR_type_wb: assert (wb_data == pc_p4) begin
					$display("WB: JALR-type pass");
				end else begin
					$display("WB: JALR-type doesn't pass");
				end
			end

			LOAD: begin
				LOAD_type_wb: assert (wb_data == mem_data) begin
					$display("WB: LOAD-type pass");
				end else begin
					$display("WB: LOAD-type doesn't pass");
				end
			end

			STORE: begin
				STORE_type_wb: assert (wb_data == NULL) begin
					$display("WB: STORE-type pass");
				end else begin
					$display("WB: STORE-type doesn't pass");
				end
			end

			MEM: begin
				MEM_type_wb: assert (wb_data == NULL) begin
					$display("WB: MEM-type pass");
				end else begin
					$display("WB: MEM-type doesn't pass");
				end
			end

			SYS: begin
				SYS_type_wb: assert (wb_data == NULL) begin
					$display("WB: SYS-type pass");
				end else begin
					$display("WB: SYS-type doesn't pass");
				end
			end

		endcase
	end
	
endmodule : wb
