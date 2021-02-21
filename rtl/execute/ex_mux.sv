`include "../opcode.svh"

module ex_mux (
	input var instr_t	instr,
	input data_t 	pc,
	input data_t 	rs1,
	input data_t 	rs2,
	input data_t 	imm,
	input data_t 	ex_ex_fwd_data,
	input data_t 	mem_ex_fwd_data,

	input [1:0]		fwd_a,
	input [1:0]		fwd_b,

	output data_t 	a_out,
	output data_t 	b_out
);
	
	// rs1_mux, rs2_mux ctrl signal types
	localparam null_sel = 2'b00;
	localparam rs1_sel 	= 2'b10;
	localparam pc_sel 	= 2'b11;
	localparam rs2_sel 	= 2'b10;
	localparam imm_sel	= 2'b11;

	// fwd mux ctrl signal types
	localparam rs_sel 			= 2'b00;
	localparam ex_ex_fwd_sel 	= 2'b10;
	localparam mem_ex_fwd_sel	= 2'b11;

	logic [1:0] rs1_mux_sel, rs2_mux_sel;
	data_t rs1_mux_out, rs2_mux_out;

	always_comb begin : rs1_mux
		rs1_mux_out = NULL;
		unique case (rs1_mux_sel)
			null_sel:	rs1_mux_out = NULL;
			2'b01:		rs1_mux_out = NULL;
			rs1_sel:	rs1_mux_out = rs1;
			pc_sel:		rs1_mux_out = pc;	
			default:	rs1_mux_out = NULL;
		endcase
	end

	always_comb begin : rs2_mux
		rs2_mux_out = NULL;
		unique case (rs1_mux_sel)
			null_sel:	rs2_mux_out = NULL;
			2'b01:		rs2_mux_out = NULL;
			rs2_sel:	rs2_mux_out = rs2;
			imm_sel:	rs2_mux_out = imm;	
			default:	rs2_mux_out = NULL;
		endcase
	end

	always_comb begin : fwd_a_mux
		a_out = NULL;
		unique case (fwd_a)
			rs_sel:			a_out = rs1_mux_out;
			2'b01:			a_out = rs1_mux_out;
			ex_ex_fwd_sel:	a_out = ex_ex_fwd_data;
			mem_ex_fwd_sel:	a_out = mem_ex_fwd_data;	
			default:		a_out = NULL;
		endcase
	end

	always_comb begin : fwd_b_mux
		b_out = NULL;
		unique case (fwd_b)
			rs_sel:			b_out = rs2_mux_out;
			2'b01:			b_out = rs2_mux_out;
			ex_ex_fwd_sel:	b_out = ex_ex_fwd_data;
			mem_ex_fwd_sel:	b_out = mem_ex_fwd_data;	
			default:		b_out = NULL;
		endcase
	end
	

	always_comb begin : rs_mux_sel_ctrl
		rs1_mux_sel = 2'b00;
		rs2_mux_sel = 2'b00;
		unique case (instr.opcode)
			R: begin
				rs1_mux_sel = rs1_sel;
				rs2_mux_sel = rs2_sel;
			end

			I: begin
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
			
			LOAD: begin	// rs1 + imm
				rs1_mux_sel = rs1_sel;
				rs2_mux_sel = imm_sel;
			end

			STORE: begin // rs1 + imm
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

endmodule
