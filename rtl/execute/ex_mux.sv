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
//((opcode_formal == R) && (instr[31:25] != M_INSTR)) |->
					//((c_out_formal == c_out) && (rd_wr));

	//opcode_t		opcode_formal;

	//always_comb begin: formal
		//opcode_formal = opcode_t'(instr[6:0]); 
	//end


	//property a_out_general;
		//((a_out == rs1_mux_out) || (a_out == ex_ex_fwd_data) || (a_out == mem_ex_fwd_data) || (a_out == NULL));
	//endproperty assert property(a_out_general); //make sure a_out comes from one of the fwd_a mux input

	//property b_out_general;
		//((b_out == rs2_mux_out) || (b_out == ex_ex_fwd_data) || (b_out == mem_ex_fwd_data) || (b_out == NULL));
	//endproperty

	/*assert property(b_out_general); //make sure a_out comes from one of the fwd_a mux input





	property rs1_mux_out_prop;
		((rs1_mux_out == NULL) || (rs1_mux_out == rs1) || (rs1_mux_out == pc));
	endproperty

	assert property(rs1_mux_out_prop); //make sure rs1_out rs1_mux_out comes from one of the rs1_mux input
	
	property rs2_mux_out_prop;
		((rs2_mux_out == NULL) || (rs2_mux_out == rs2) || (rs2_mux_out == imm));
	endproperty

	assert property(rs2_mux_out_prop); //make sure rs1_out rs1_mux_out comes from one of the rs1_mux input

	//RS_EX_SEL: 2'b00
	//MEM_EX_SEL: 2'b01
	//WB_EX_SEL: 2'b10


////////////////////////////////////////////////////////////////////////R type rs1_sel = 2'b10, rs2_sel = 2'b10
	property R_B_a_rs1_mux;
		(((opcode_formal == R) || (opcode_formal == B)) 
						|-> ((rs1_mux_out == rs1)));
	endproperty

	assert property(R_B_a_rs1_mux); //make sure R-type rs1_mux_out is rs1.....

	property R_B_b_rs2_mux;
		(((opcode_formal == R) || (opcode_formal == B)) 
						|-> (rs2_mux_out == rs2));
	endproperty

	assert property(R_B_b_rs2_mux); // make sure R-type rs2_mux_out is rs2.....
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
	property LUI_a_rs1_mux;
		((opcode_formal == LUI) 
						|-> (rs1_mux_out == NULL));
	endproperty

	assert property(LUI_a_rs1_mux);

	property LUI_b_rs2_mux;
		((opcode_formal == LUI) |-> (rs2_mux_out == imm));
	endproperty

	assert property(LUI_b_rs2_mux);
/////////////////////////////////////////////////////////////////////////JAL, JALR rs1_sel = pc, rs2_sel = imm, imm =4
	property JAL_JALR_a_rs1_mux;
		(((opcode_formal == JAL) || (opcode_formal == JALR))
						|-> (rs1_mux_out == pc));
	endproperty

	assert property(JAL_JALR_a_rs1_mux);

	property JAL_JALR_b_rs2_mux;
		(((opcode_formal == JAL) || (opcode_formal == JALR))
						|-> ((rs2_mux_out == imm) && (imm == 4)));
	endproperty

	assert property(JAL_JALR_b_rs2_mux);
///////////////////////////////////////////////////////////////////
	property AUIPC_a_rs1_mux;
		((opcode_formal == AUIPC)
						|-> (rs1_mux_out == pc));
	endproperty

	assert property(AUIPC_a_rs1_mux);

	property AUIPC_b_rs2_mux;
		((opcode_formal == AUIPC)
						|-> (rs2_mux_out == imm));
	endproperty

	assert property(AUIPC_b_rs2_mux);
////////////////////////////////////////////////////////////////////
	property MEM_SYS_output_mux;
		((opcode_formal == MEM) || (opcode_formal == SYS)) 
						|->  ((rs1_mux_out == NULL) || (rs2_mux_out == NULL))
	endproperty

	assert property(MEM_SYS_output_mux);*/

endmodule : ex_mux
