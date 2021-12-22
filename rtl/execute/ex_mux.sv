import defines::*;

module ex_mux (
	input instr_t		instr,
	input data_t		pc,
	input data_t		rs1,
	input data_t		rs2,
	input data_t		imm,
	input data_t		ex_ex_fwd_data,
	input data_t		mem_ex_fwd_data,

	input ex_fwd_sel_t	fwd_a,
	input ex_fwd_sel_t	fwd_b,

	output data_t		a_out,
	output data_t		b_out
);
	
	// rs1_mux, rs2_mux ctrl signal types
	localparam null_sel = 2'b00;
	localparam rs1_sel 	= 2'b10;
	localparam pc_sel 	= 2'b11;
	localparam rs2_sel 	= 2'b10;
	localparam imm_sel	= 2'b11;

	
	logic [1:0] rs1_mux_sel, rs2_mux_sel;
	data_t rs1_mux_out, rs2_mux_out;

	always_comb begin : rs1_mux
		unique case (rs1_mux_sel)
			null_sel:	rs1_mux_out = NULL;
			rs1_sel:	rs1_mux_out = rs1;
			pc_sel:		rs1_mux_out = pc;	
			default:	rs1_mux_out = NULL;
		endcase
	end


	always_comb begin : rs2_mux
		unique case (rs2_mux_sel)
			null_sel:	rs2_mux_out = NULL;
			rs2_sel:	rs2_mux_out = rs2;
			imm_sel:	rs2_mux_out = imm;	
			default:	rs2_mux_out = NULL;
		endcase
	end


	always_comb begin : fwd_a_mux
		unique case (fwd_a)
			RS_EX_SEL:		a_out = rs1_mux_out;
			MEM_EX_SEL:		a_out = ex_ex_fwd_data;
			WB_EX_SEL:		a_out = mem_ex_fwd_data;	
			default:		a_out = NULL;
		endcase
	end


	always_comb begin : fwd_b_mux
		unique case (fwd_b)
			RS_EX_SEL:		b_out = rs2_mux_out;
			MEM_EX_SEL:		b_out = ex_ex_fwd_data;
			WB_EX_SEL:		b_out = mem_ex_fwd_data;	
			default:		b_out = NULL;
		endcase
	end

	
	always_comb begin : rs_mux_sel_ctrl
		rs1_mux_sel = 2'b00;
		rs2_mux_sel = 2'b00;
		unique case (instr.opcode)
			R: begin //DONE
				rs1_mux_sel = rs1_sel;
				rs2_mux_sel = rs2_sel;
			end

			I: begin //DONE
				rs1_mux_sel = rs1_sel;
				rs2_mux_sel = imm_sel;
			end

			B: begin
				rs1_mux_sel = rs1_sel;
				rs2_mux_sel = rs2_sel;
			end

			LUI: begin	// imm + 0
				rs1_mux_sel = null_sel;
				rs2_mux_sel = imm_sel;
			end

			AUIPC: begin	// pc + imm
				rs1_mux_sel = pc_sel;
				rs2_mux_sel = imm_sel;
			end

			JAL: begin	// pc + imm, imm = 4
				rs1_mux_sel = pc_sel;
				rs2_mux_sel = imm_sel;
			end

			JALR: begin	// pc + imm, imm = 4
				rs1_mux_sel = pc_sel;
				rs2_mux_sel = imm_sel;
			end
			
			LOAD: begin	// rs1 + imm DONE
				rs1_mux_sel = rs1_sel;
				rs2_mux_sel = imm_sel;
			end

			STORE: begin // rs1 + imm DONE
				rs1_mux_sel = rs1_sel;
				rs2_mux_sel = imm_sel;
			end

			MEM: begin	// riscv-spec.pdf page 27, ignore rs and rd
				rs1_mux_sel = null_sel;
				rs2_mux_sel = null_sel;
			end

			SYS: begin	// no alu need
				rs1_mux_sel = null_sel;
				rs2_mux_sel = null_sel;
			end

			default: begin
				rs1_mux_sel = null_sel;
				rs2_mux_sel = null_sel;
			end
		endcase
	end


	opcode_t		opcode_formal;

	always_comb begin: formal
		opcode_formal = opcode_t'(instr[6:0]); 
	end

	always_comb begin: a_out_formal
		ex_mux_a_out_general: assert ((a_out == NULL) 
									|| (a_out == rs1_mux_out) || 
									(a_out == ex_ex_fwd_data) || 
									(a_out == mem_ex_fwd_data)) begin
			$display("ex-mux: a_out general case pass");
		end else begin
			$display("WB: a_out general case doesn't pass");
		end
			 
	end //automatic

	always_comb begin: b_out_formal
		ex_mux_b_out_general: assert ((b_out == NULL) 
									|| (b_out == rs2_mux_out) || 
									(b_out == ex_ex_fwd_data) || 
									(b_out == mem_ex_fwd_data)) begin
			$display("ex-mux: b_out general case pass");
		end else begin
			$display("WB: b_out general case doesn't pass");
		end

	end //automatic

	always_comb begin: rs1_mux_out_formal
		ex_mux_rs1_out_general: assert ((rs1_mux_out == NULL) 
									||(rs1_mux_out == rs1) || 
										(rs1_mux_out == pc)) begin
			$display("ex-mux: ex_mux_rs1_out_general case pass");
		end else begin
			$display("WB: ex_mux_rs1_out_general case doesn't pass");
		end

	end //automatic

	always_comb begin: rs2_mux_out_formal
		ex_mux_rs2_out_general: assert ((rs2_mux_out == NULL) 
									||(rs2_mux_out == rs2) || 
										(rs2_mux_out == imm)) begin
			$display("ex-mux: ex_mux_rs2_out_general general case pass");
		end else begin
			$display("WB: ex_mux_rs2_out_general case doesn't pass");
		end
	
	end //automatic



	/*
	//RS_EX_SEL: 2'b00
	//MEM_EX_SEL: 2'b01
	//WB_EX_SEL: 2'b10 */

	always_comb begin: opcode_rs1_mux_out_formal
		case (opcode_formal)
			R: begin
				R_rs1_mux_output: assert (rs1_mux_out == rs1) begin
					$display("ex-mux: R type rs1_mux_output pass");
				end else begin
					$display("ex-mux: R type rs1_mux_output don't pass");
				end
			end
			
			I: begin
				I_rs1_mux_output: assert (rs1_mux_out == rs1) begin
					$display("ex-mux: I type rs1_mux_output pass");
				end else begin
					$display("ex-mux: I type rs1_mux_output don't pass");
				end
			end

			B: begin
				B_rs1_mux_output: assert (rs1_mux_out == rs1) begin
					$display("ex-mux: B type rs1_mux_output pass");
				end else begin
					$display("ex-mux: B type rs1_mux_output don't pass");
				end
			end

			LUI: begin
				LUI_rs1_mux_output: assert (rs1_mux_out == NULL) begin
					$display("ex-mux: LUI type rs1_mux_output pass");
				end else begin
					$display("ex-mux: LUI type rs1_mux_output don't pass");
				end				
			end

			AUIPC: begin
				AUIPC_rs1_mux_output: assert (rs1_mux_out == pc) begin
					$display("ex-mux: AUIPC type rs1_mux_output pass");
				end else begin
					$display("ex-mux: AUIPC type rs1_mux_output don't pass");
				end
			end

			JAL: begin
				JAL_rs1_mux_output: assert (rs1_mux_out == pc) begin
					$display("ex-mux: JAL type rs1_mux_output pass");
				end else begin
					$display("ex-mux: JAL type rs1_mux_output don't pass");
				end				
			end

			JALR: begin
				JALR_rs1_mux_output: assert (rs1_mux_out == pc) begin
					$display("ex-mux: JALR type rs1_mux_output pass");
				end else begin
					$display("ex-mux: JALR type rs1_mux_output don't pass");
				end				
			end

			LOAD: begin
				LOAD_rs1_mux_output: assert (rs1_mux_out == rs1) begin
					$display("ex-mux: LOAD type rs1_mux_output pass");
				end else begin
					$display("ex-mux: LOAD type rs1_mux_output don't pass");
				end					
			end

			STORE: begin
				STORE_rs1_mux_output: assert (rs1_mux_out == rs1) begin
					$display("ex-mux: STORE type rs1_mux_output pass");
				end else begin
					$display("ex-mux: STORE type rs1_mux_output don't pass");
				end					
			end

			MEM: begin
				MEM_rs1_mux_output: assert (rs1_mux_out == NULL) begin
					$display("ex-mux: MEM type rs1_mux_output pass");
				end else begin
					$display("ex-mux: MEM type rs1_mux_output don't pass");
				end					
			end

			SYS: begin
				SYS_rs1_mux_output: assert (rs1_mux_out == NULL) begin
					$display("ex-mux: SYS type rs1_mux_output pass");
				end else begin
					$display("ex-mux: SYS type rs1_mux_output don't pass");
				end					
			end

		endcase
	end




	always_comb begin: opcode_rs2_mux_out_formal
		case (opcode_formal)
			R: begin
				R_rs2_mux_output: assert (rs2_mux_out == rs2) begin
					$display("ex-mux: R type rs2_mux_output pass");
				end else begin
					$display("ex-mux: R type rs2_mux_output don't pass");
				end
			end 

			I: begin
				I_rs2_mux_output: assert (rs2_mux_out == imm) begin
					$display("ex-mux: I type rs2_mux_output pass");
				end else begin
					$display("ex-mux: I type rs2_mux_output don't pass");
				end
			end

			B: begin
				B_rs2_mux_output: assert (rs2_mux_out == rs2) begin
					$display("ex-mux: B type rs2_mux_output pass");
				end else begin
					$display("ex-mux: B type rs2_mux_output don't pass, rs2_mux_out %d, rs2 %d", rs2_mux_out, rs2);
				end
			end

			LUI: begin
				LUI_rs2_mux_output: assert (rs2_mux_out == imm) begin
					$display("ex-mux: LUI type rs1_mux_output pass");
				end else begin
					$display("ex-mux: LUI type rs1_mux_output don't pass");
				end				
			end

			AUIPC: begin
				AUIPC_rs2_mux_output: assert (rs2_mux_out == imm) begin
					$display("ex-mux: AUIPC type rs2_mux_output pass");
				end else begin
					$display("ex-mux: AUIPC type rs2_mux_output don't pass");
				end				
			end

			JAL: begin
				JAL_rs2_mux_output: assert ((rs2_mux_out == imm) && (imm == 4)) begin
					$display("ex-mux: JAL type rs2_mux_output pass");
				end else begin
					$display("ex-mux: JAL type rs2_mux_output don't pass");
				end						
			end

			JALR: begin
				JALR_rs2_mux_output: assert ((rs2_mux_out == imm) && (imm == 4)) begin
					$display("ex-mux: JALR type rs2_mux_output pass");
				end else begin
					$display("ex-mux: JALR type rs2_mux_output don't pass");
				end				
			end

			LOAD: begin
				LOAD_rs2_mux_output: assert (rs2_mux_out == imm) begin
					$display("ex-mux: LOAD type rs2_mux_output pass");
				end else begin
					$display("ex-mux: LOAD type rs2_mux_output don't pass");
				end					
			end

			STORE: begin
				STORE_rs2_mux_output: assert (rs2_mux_out == imm) begin
					$display("ex-mux: STORE type rs2_mux_output pass");
				end else begin
					$display("ex-mux: STORE type rs2_mux_output don't pass");
				end					
			end

			MEM: begin
				MEM_rs2_mux_output: assert (rs2_mux_out == NULL) begin
					$display("ex-mux: MEM type rs2_mux_output pass");
				end else begin
					$display("ex-mux: MEM type rs2_mux_output don't pass");
				end					
			end

			SYS: begin
				SYS_rs2_mux_output: assert (rs2_mux_out == NULL) begin
					$display("ex-mux: SYS type rs2_mux_output pass");
				end else begin
					$display("ex-mux: SYS type rs2_mux_output don't pass");
				end					
			end

		endcase
	end

////////////////////////////////////////////////////////////////////////R type rs1_sel = 2'b10, rs2_sel = 2'b10
	/*

/////////////////////////////////////////////////////////////////////////I type rs1_sel=2'b10, imm_sel = 2'b11
	property I_STORE_LOAD_a_rs1_mux;
		(((opcode_formal == I) || (opcode_formal == STORE) || (opcode_formal == LOAD)) 
						|-> ((rs1_mux_out == rs1)));
	endproperty

	assert property(I_STORE_LOAD_a_rs1_mux); //make sure R-type rs1_mux_out is rs1.....

	property I_STORE_LOAD_b_rs2_mux;
		(((opcode_formal == R) || (opcode_formal == STORE) || (opcode_formal == LOAD))
						|-> ((rs2_mux_out == imm)));
	endproperty

	assert property(I_STORE_LOAD_b_rs2_mux); // make sure R-type rs2_mux_out is rs2.....
/////////////////////////////////////////////////////////////////////// LUI: rs1_sel = null_sel,  rs2=imm_sel
/////////////////////////////////////////////////////////////////////////JAL, JALR rs1_sel = pc, rs2_sel = imm, imm =4
////
////////////////////////////////////////////////////////////////////
	property MEM_SYS_output_mux;
		((opcode_formal == MEM) || (opcode_formal == SYS)) 
						|->  ((rs1_mux_out == NULL) || (rs2_mux_out == NULL))
	endproperty

	assert property(MEM_SYS_output_mux);*/

endmodule : ex_mux
