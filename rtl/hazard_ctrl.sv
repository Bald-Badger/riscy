import defines::*;

module hazard_ctrl (
	// input signal
	input instr_t instr_f,
	input instr_t instr_d,
	input instr_t instr_x,
	input instr_t instr_m,
	input instr_t instr_w,

	input logic id_ex_wr_rd,
	input logic ex_mem_wr_rd,
	input logic mem_wb_wr_rd,

	input logic sdram_init_done,

	input logic mem_access_done,

	input logic branch_predict,
	input logic branch_actual,

	// forwarding signal
	output fwd_sel_t fwd_a,
	output fwd_sel_t fwd_b,
	output fwd_sel_t fwd_m2m,

	output branch_fwd_t fwd_rs1,
	output branch_fwd_t fwd_rs2,

	output store_fwd_t fwd_store,

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
	logic mem_store, mem_load;
	always_comb begin : input_sig
		id_ex_rs1	= instr_x.rs1;
		id_ex_rs2	= instr_x.rs2;
		ex_mem_rs2	= instr_m.rs2;
		ex_mem_rd	= instr_m.rd;
		mem_wb_rd	= instr_w.rd;
		mem_store	= (instr_m.opcode == STORE);
		mem_load	= (instr_m.opcode == LOAD);
	end

	logic data_mem_stall;	// pipeline stall from data memory access
	always_comb begin : data_mem_stall_assign
		data_mem_stall = (mem_store || mem_load) && ~mem_access_done;
	end


	// reference: book p579
	// we can see that hazard_1's forwarding have
	// higher proority than that of hazard_2's
	logic hazard_1a, hazard_1b;	// ex - ex data hazard
	logic hazard_2a, hazard_2b;	// mem - ex data hazard
	logic hazard_3;				// mem - mem data hazard

	// TODO: add forward logic for instr out of base instruction
	// e.g. fence, csr, mult, div. etc
	logic ex_mem_rs1_rd, mem_wb_rs1_rd;
	assign ex_mem_rs1_rd =	(instr_x.opcode == JALR) ? 1'b1 :
							(instr_x.opcode == B) ? 1'b1 :
							(instr_x.opcode == LOAD) ? 1'b1 :
							(instr_x.opcode == I) ? 1'b1 :
							(instr_x.opcode == R) ? 1'b1 :
							(instr_x.opcode == MEM) ? 1'b1 : 1'b0;

	assign mem_wb_rs1_rd =	(instr_m.opcode == JALR) ? 1'b1 :
							(instr_m.opcode == B) ? 1'b1 :
							(instr_m.opcode == LOAD) ? 1'b1 :
							(instr_m.opcode == I) ? 1'b1 :
							(instr_m.opcode == R) ? 1'b1 :
							(instr_m.opcode == MEM) ? 1'b1 : 1'b0;

	logic ex_mem_rs2_rd, mem_wb_rs2_rd;
	assign ex_mem_rs2_rd =	(instr_x.opcode == R) ? 1'b1 :
							(instr_x.opcode == B) ? 1'b1 : 1'b0;
	assign mem_wb_rs2_rd =	(instr_m.opcode == R) ? 1'b1 :
							(instr_m.opcode == B) ? 1'b1 : 1'b0;


	always_comb begin : data_hazard_detect

		hazard_1a =	(ex_mem_wr_rd) &&
					(ex_mem_rd != X0) &&
					(ex_mem_rd == id_ex_rs1) &&
					ex_mem_rs1_rd;

		hazard_1b =	(ex_mem_wr_rd) &&
					(ex_mem_rd != X0) &&
					(ex_mem_rd == id_ex_rs2) &&
					ex_mem_rs2_rd;

		hazard_2a =	(mem_wb_wr_rd) &&
					(mem_wb_rd != X0) &&
					(!(hazard_1a)) &&
					(mem_wb_rd == id_ex_rs1) &&
					mem_wb_rs1_rd;

		hazard_2b =	(mem_wb_wr_rd) &&
					(mem_wb_rd != X0) &&
					(!(hazard_2a)) &&
					(mem_wb_rd == id_ex_rs2) &&
					mem_wb_rs2_rd;
	
		hazard_3 =	(mem_store) &&
					(ex_mem_rd != X0) && 
					(mem_wb_wr_rd) &&
					(mem_wb_rd == ex_mem_rs2);
	end


	always_comb begin : forward_sig_assign

		fwd_a =	hazard_1a ? EX_EX_FWD_SEL :
				hazard_2a ? MEM_EX_FWD_SEL :
				RS_SEL;

		fwd_b = hazard_1b ? EX_EX_FWD_SEL :
				hazard_2b ? MEM_EX_FWD_SEL :
				RS_SEL;
		
		fwd_m2m = hazard_3 ? MEM_MEM_FWD_SEL : RS_SEL;

	end

	// hazard when load follows a branch
	// a true hazard and does not be resolven by forwarding
	// both hazard 4 and harrard 5 requires to stall pipeline on F and D stages
	logic hazard_4a, hazard_4b;	// load - branch
	logic hazard_5a, hazard_5b;	// load - whatever - branch
	logic hazard_4, hazard_5;

	// hazard when branch can use data from exe stage
	logic hazard_6a;	// can fwd to rs1
	logic hazard_6b;	// can fwd to rs2

	// hazard when branch can use data from mem stage
	logic hazard_7a;	// can fwd to rs1
	logic hazard_7b;	// can fwd to rs2

	// hazard when branch can use data from wb stage
	logic hazard_8a;	// can fwd to rs1
	logic hazard_8b;	// can fwd to rs2


	always_comb begin : control_hazard_detect

		hazard_4a =	(instr_x.opcode == LOAD) &&
					(instr_d.opcode == B) &&
					(instr_x.rd != X0) &&
					(id_ex_wr_rd) &&
					(instr_x.rd == instr_d.rs1);
		
		hazard_4b =	(instr_x.opcode == LOAD) &&
					(instr_d.opcode == B) &&
					(instr_x.rd != X0) &&
					(id_ex_wr_rd) &&
					(instr_x.rd == instr_d.rs2);
		
		hazard_4 = hazard_4a || hazard_4b;
		
		hazard_5a =	(instr_m.opcode == LOAD) &&
					(instr_d.opcode == B) &&
					(!hazard_4a) &&
					(instr_m.rd != X0) &&
					(ex_mem_wr_rd) &&
					(instr_m.rd == instr_d.rs1);

		hazard_5b =	(instr_m.opcode == LOAD) &&
					(instr_d.opcode == B) &&
					(!hazard_4a) &&
					(instr_m.rd != X0) &&
					(ex_mem_wr_rd) &&
					(instr_m.rd == instr_d.rs2);
		
		hazard_5 = hazard_5a || hazard_5b;
		
		hazard_6a =	(instr_d.opcode == B) &&
					(!hazard_4a) &&
					(instr_x.rd != X0) &&
					(id_ex_wr_rd) &&
					(instr_x.rd == instr_d.rs1);
		
		hazard_6b =	(instr_d.opcode == B) &&
					(!hazard_4b) &&
					(instr_x.rd != X0) &&
					(id_ex_wr_rd) &&
					(instr_x.rd == instr_d.rs2);
		
		hazard_7a =	(instr_d.opcode == B) &&
					(!hazard_5a) &&
					(!hazard_6a) &&
					(instr_m.rd != X0) &&
					(ex_mem_wr_rd) &&
					(instr_m.rd == instr_d.rs1);
		
		hazard_7b =	(instr_d.opcode == B) &&
					(!hazard_5b) &&
					(!hazard_6b) &&
					(instr_m.rd != X0) &&
					(ex_mem_wr_rd) &&
					(instr_m.rd == instr_d.rs2);

		hazard_8a =	(instr_d.opcode == B) &&
					(!hazard_7a) &&
					(instr_w.rd != X0) &&
					(mem_wb_wr_rd) &&
					(instr_w.rd == instr_d.rs1);

		hazard_8b =	(instr_d.opcode == B) &&
					(!hazard_7b) &&
					(instr_w.rd != X0) &&
					(mem_wb_wr_rd) &&
					(instr_w.rd == instr_d.rs2);

	end

	always_comb begin : branch_fwd_assign

		fwd_rs1 =	hazard_6a ? B_EX_SEL :
					hazard_7a ? B_MEM_SEL :
					hazard_8a ? B_WB_SEL :
					B_RS_SEL;

		fwd_rs2 =	hazard_6b ? B_EX_SEL :
					hazard_7b ? B_MEM_SEL :
					hazard_8b ? B_WB_SEL :
					B_RS_SEL;

	end


	always_comb begin : stall_assign
		stall_if_id		= hazard_4 || hazard_5 || data_mem_stall || ~sdram_init_done;
		stall_id_ex		= stall_if_id || data_mem_stall;
		stall_ex_mem	= data_mem_stall;
		stall_mem_wb	= data_mem_stall;	// stall for mem-mem fwd
	end


	// hazard when a store can use its value from later pipeline
	// instead of reading it from register files
	logic hazard_9a;	// ex - decode fwd to rs2
	logic hazard_9b;	// mem - decode fwd to rs2
	logic hazard_9c;	// wb - decode fwd to rs2

	always_comb begin : store_hazzard_detect
		hazard_9a =	(instr_d.opcode == STORE) &&
					(instr_x.rd != X0) &&
					(id_ex_wr_rd) &&
					(instr_x.rd == instr_d.rs2);
		
		hazard_9b =	(instr_d.opcode == STORE) &&
					(instr_m.rd != X0) &&
					(ex_mem_wr_rd) &&
					(!hazard_9a) &&
					(instr_m.rd == instr_d.rs2);

		hazard_9c =	(instr_d.opcode == STORE) &&
					(instr_m.rd != X0) &&
					(mem_wb_wr_rd) &&
					(!hazard_9b) &&
					(instr_w.rd == instr_d.rs2);
	end

	always_comb begin : store_fwd_assign
		fwd_store =	(hazard_9a)	? EX_ID_STORE_SEL:
					(hazard_9b)	? MEM_ID_STORE_SEL:
					(hazard_9c)	? WB_ID_STORE_SEL:
					RS_STORE_SEL;
	end


	logic jump;
	always_comb begin : flush_crtl_signal_assign
		jump = (instr_d.opcode == JAL) || (instr_d.opcode == JALR);
	end
	always_comb begin : flush_assign
		flush_if_id = jump || branch_actual;
		flush_id_ex = DISABLE;
		flush_ex_mem = DISABLE;
		flush_mem_wb = DISABLE;
	end
	
	
endmodule : hazard_ctrl
