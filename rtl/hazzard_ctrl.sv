import defines::*;

module hazzard_ctrl (
	// input signal
	input instr_t instr_f,
	input instr_t instr_d,
	input instr_t instr_x,
	input instr_t instr_m,
	input instr_t instr_w,

	input logic ex_mem_wr_rd,
	input logic mem_wb_wr_rd,

	input logic branch_predict,
	input logic branch_actual,

	// forwarding signal
	output fwd_sel_t fwd_a,
	output fwd_sel_t fwd_b,
	output fwd_sel_t fwd_m2m,

	output branch_fwd_t fwd_rs1,
	output branch_fwd_t fwd_rs2,

	// stall signal
	output logic stall_if_id,
	output logic stall_id_ex,
	output logic stall_ex_mem,
	output logic stall_mem_wb,

	// flush signal
	output logic flush_if_id,
	output logic flush_id_ex,
	output logic flush_ex_mem,
	output logic flush_mem_wb
);
	

	r_t id_ex_rs1, id_ex_rs2, ex_mem_rs2, ex_mem_rd, mem_wb_rd;
	logic mem_store;
	always_comb begin : input_sig
		id_ex_rs1 = instr_x.rs1;
		id_ex_rs2 = instr_x.rs2;
		ex_mem_rs2 = instr_m.rs2;
		ex_mem_rd = instr_m.rd;
		mem_wb_rd = instr_w.rd;
		mem_store = (instr_m.opcode == STORE);
	end


	// reference: book p579
	// we can see that hazzard_1's forwarding have
	// higher proority than that of hazzard_2's
	logic hazzard_1a, hazzard_1b;	// ex - ex data hazzard
	logic hazzard_2a, hazzard_2b;	// mem - ex data hazzard
	logic hazzard_3;				// mem - mem data hazzard

	always_comb begin : data_hazzard_detect

		hazzard_1a =	(ex_mem_wr_rd) &&
						(ex_mem_rd != X0) &&
						(ex_mem_rd == id_ex_rs1);
	
		hazzard_1b =	(ex_mem_wr_rd) &&
						(ex_mem_rd != X0) &&
						(ex_mem_rd == id_ex_rs2);

		hazzard_2a =	(mem_wb_wr_rd) &&
						(mem_wb_rd != X0) &&
						(!(hazzard_1a)) &&
						(mem_wb_rd == id_ex_rs1);
		
		hazzard_2b =	(mem_wb_wr_rd) &&
						(mem_wb_rd != X0) &&
						(!(hazzard_2a)) &&
						(mem_wb_rd == id_ex_rs2);
	
		hazzard_3 =		(mem_store) &&
						(ex_mem_rd != X0) && 
						(mem_wb_rd == ex_mem_rs2);

	end


	always_comb begin : forward_sig_assign

		fwd_a =	hazzard_1a ? EX_EX_FWD_SEL :
				hazzard_2a ? MEM_EX_FWD_SEL :
				RS_SEL;

		fwd_b = hazzard_1b ? EX_EX_FWD_SEL :
				hazzard_2b ? MEM_EX_FWD_SEL :
				RS_SEL;
		
		fwd_m2m = hazzard_3 ? MEM_MEM_FWD_SEL : RS_SEL;

	end

	// hazzard when load follows a branch
	// a true hazzard and does not be resolven by forwarding
	logic hazzard_4a, hazzard_4b;	// load - branch
	logic hazzard_5a, hazzard_5b;	// load - whatever - branch
	logic hazzard_4, hazzard_5;

	// hazzard when branch can use data from exe stage
	logic hazzard_6a;	// can fwd to rs1
	logic hazzard_6b;	// can fwd to rs2

	// hazzard when branch can use data from mem stage
	logic hazzard_7a;	// can fwd to rs1
	logic hazzard_7b;	// can fwd to rs2

	// hazzard when branch can use data from wb stage
	logic hazzard_8a;	// can fwd to rs1
	logic hazzard_8b;	// can fwd to rs2


	always_comb begin : control_hazzard_detect

		hazzard_4a =	(instr_x.opcode == LOAD) &&
						(instr_d.opcode == B) &&
						(instr_x.rd != X0) &&
						(instr_x.rd == instr_d.rs1);
		
		hazzard_4b =	(instr_x.opcode == LOAD) &&
						(instr_d.opcode == B) &&
						(instr_x.rd != X0) &&
						(instr_x.rd == instr_d.rs2);
		
		hazzard_4 = hazzard_4a || hazzard_4b;
		
		hazzard_5a =	(instr_m.opcode == LOAD) &&
						(instr_d.opcode == B) &&
						(!hazzard_4a) &&
						(instr_m.rd != X0) &&
						(instr_m.rd == instr_d.rs1);

		hazzard_5b =	(instr_m.opcode == LOAD) &&
						(instr_d.opcode == B) &&
						(!hazzard_4a) &&
						(instr_m.rd != X0) &&
						(instr_m.rd == instr_d.rs2);
		
		hazzard_5 = hazzard_5a || hazzard_5b;
		
		hazzard_6a =	(instr_d.opcode == B) &&
						(!hazzard_4a) &&
						(instr_x.rd != X0) &&
						(instr_x.rd == instr_d.rs1);
		
		hazzard_6b =	(instr_d.opcode == B) &&
						(!hazzard_4b) &&
						(instr_x.rd != X0) &&
						(instr_x.rd == instr_d.rs2);
		
		hazzard_7a =	(instr_d.opcode == B) &&
						(!hazzard_5a) &&
						(!hazzard_6a) &&
						(instr_m.rd != X0) &&
						(instr_m.rd == instr_d.rs1);
		
		hazzard_7b =	(instr_d.opcode == B) &&
						(!hazzard_5b) &&
						(!hazzard_6b) &&
						(instr_m.rd != X0) &&
						(instr_m.rd == instr_d.rs2);

		hazzard_8a =	(instr_d.opcode == B) &&
						(!hazzard_7a) &&
						(instr_w.rd != X0) &&
						(instr_w.rd == instr_d.rs1);

		hazzard_8b =	(instr_d.opcode == B) &&
						(!hazzard_7b) &&
						(instr_w.rd != X0) &&
						(instr_w.rd == instr_d.rs2);

	end

	always_comb begin : branch_fwd_assign

		fwd_rs1 =	hazzard_6a ? B_EX_SEL :
					hazzard_7a ? B_MEM_SEL :
					hazzard_8a ? B_WB_SEL :
					B_RS_SEL;

		fwd_rs2 =	hazzard_6b ? B_EX_SEL :
					hazzard_7b ? B_MEM_SEL :
					hazzard_8b ? B_WB_SEL :
					B_RS_SEL;

	end


	always_comb begin : stall_assign
		stall_if_id = hazzard_4 || hazzard_5;
		stall_id_ex = DISABLE;
		stall_ex_mem = DISABLE;
		stall_mem_wb = DISABLE;
	end


	logic jump;
	always_comb begin : flush_crtl_signal_assign
		jump = (instr_d.opcode == JAL) || (instr_d.opcode == JALR);
	end
	always_comb begin : flush_assign // TODO:
		flush_if_id = DISABLE;
		flush_id_ex = DISABLE;
		flush_ex_mem = DISABLE;
		flush_mem_wb = DISABLE;
	end
	
	
endmodule : hazzard_ctrl
