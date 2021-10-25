import defines::*;

module hazard_ctrl (
	// input signal
	input instr_t instr_f,
	input instr_t instr_d,
	input instr_t instr_x,
	input instr_t instr_m,
	input instr_t instr_w,

	input logic ex_rd_write,
	input logic mem_rd_write,
	input logic wb_rd_write,

	input logic sdram_init_done,
	input logic execute_busy,
	input logic mem_access_done,

	// forwarding signal to id stage
	output id_fwd_sel_t fwd_id_rs1,
	output id_fwd_sel_t fwd_id_rs2,

	// forwarding signal to ex stage
	output ex_fwd_sel_t fwd_ex_rs1,
	output ex_fwd_sel_t fwd_ex_rs2,

	// forwarding signal to mem stage
	output mem_fwd_sel_t fwd_mem_rs1,
	output mem_fwd_sel_t fwd_mem_rs2,

	// stall signal
	output logic stall_pc,
	output logic stall_if_id,
	output logic stall_id_ex,
	output logic stall_ex_mem,
	output logic stall_mem_wb,

	// flush signal
	output logic flush_pc,
	output logic flush_if_id,
	output logic flush_id_ex,
	output logic flush_ex_mem,
	output logic flush_mem_wb
);


	r_t id_rs1, id_rs2, ex_rs1, ex_rs2, mem_rs1, mem_rs2, wb_rs1, wb_rs2;
	always_comb begin : rs_assign
		id_rs1	= instr_d.rs1;
		id_rs2	= instr_d.rs2;
		ex_rs1	= instr_x.rs1;
		ex_rs2	= instr_x.rs2;
		mem_rs1	= instr_m.rs1;
		mem_rs2	= instr_m.rs2;
		wb_rs1	= instr_w.rs1;
		wb_rs2	= instr_w.rs2;
	end


	r_t ex_rd, mem_rd, wb_rd;
	always_comb begin : rd_assign
		ex_rd	= instr_x.rd;
		mem_rd	= instr_m.rd;
		wb_rd	= instr_w.rd;
	end


	logic id_rs1_read, id_rs2_read, ex_rs1_read, ex_rs2_read, mem_rs1_read, mem_rs2_read;
	always_comb begin : rs_read_assign
		id_rs1_read		=	((instr_d.opcode == B) || 
							 (instr_d.opcode == JALR));

		id_rs2_read		= 	 (instr_d.opcode == B) ||
							 (instr_d.opcode == STORE);

		ex_rs1_read		=	((instr_x.opcode == R) ||
							 (instr_x.opcode == I) ||
							 (instr_x.opcode == STORE) ||
							 (instr_x.opcode == LOAD) ||
							 (instr_x.opcode == JALR));

		ex_rs2_read		=	((instr_x.opcode == R));

		mem_rs1_read	=	((instr_m.opcode == LOAD) ||
							 (instr_m.opcode == STORE));

		mem_rs2_read	=	 (DISABLE);
	end


	logic hazard_ex2id_1, hazard_ex2id_2;
	logic hazard_mem2id_1, hazard_mem2id_2;
	logic hazard_wb2id_1, hazard_wb2id_2;
	always_comb begin : id_hazard_detect
		hazard_ex2id_1 =	(id_rs1_read) &&
							(id_rs1 != X0) &&
							(ex_rd_write) &&
							(ex_rd == id_rs1);

		hazard_ex2id_2 =	(id_rs2_read) &&
							(id_rs2 != X0) &&
							(ex_rd_write) &&
							(ex_rd == id_rs2);

		hazard_mem2id_1 =	(id_rs1_read) &&
							(id_rs1 != X0) &&
							(mem_rd_write) &&
							(mem_rd == id_rs1);

		hazard_mem2id_2 =	(id_rs2_read) &&
							(id_rs2 != X0) &&
							(mem_rd_write) &&
							(mem_rd == id_rs2);

		hazard_wb2id_1 =	(id_rs1_read) &&
							(id_rs1 != X0) &&
							(wb_rd_write) &&
							(wb_rd == id_rs1);

		hazard_wb2id_2 =	(id_rs2_read) &&
							(id_rs2 != X0) &&
							(wb_rd_write) &&
							(wb_rd == id_rs2);
	end


	logic hazard_mem2ex_1, hazard_mem2ex_2;
	logic hazard_wb2ex_1, hazard_wb2ex_2;
	always_comb begin : ex_hazard_detect
		hazard_mem2ex_1 =	(ex_rs1_read) &&
							(ex_rs1 != X0) &&
							(mem_rd_write) &&
							(mem_rd == ex_rs1);

		hazard_mem2ex_2 =	(ex_rs2_read) &&
							(ex_rs2 != X0) &&
							(mem_rd_write) &&
							(mem_rd == ex_rs2);

		hazard_wb2ex_1 =	(ex_rs1_read) &&
							(ex_rs1 != X0) &&
							(wb_rd_write) &&
							(wb_rd == ex_rs1);

		hazard_wb2ex_2 =	(ex_rs2_read) &&
							(ex_rs2 != X0) &&
							(wb_rd_write) &&
							(wb_rd == ex_rs2);
	end


	logic hazard_wb2mem_1, hazard_wb2mem_2;
	always_comb begin : mem_hazard_detect
		hazard_wb2mem_1 =	(mem_rs1_read) &&
							(mem_rs1 != X0) &&
							(wb_rd_write) &&
							(wb_rd == mem_rs1);

		hazard_wb2mem_2 =	(mem_rs2_read) &&
							(mem_rs2 != X0) &&
							(wb_rd_write) &&
							(wb_rd == mem_rs2);
	end


	always_comb begin : forward_sig_assign
		// forwarding signal to id stage
		fwd_id_rs1	=	hazard_ex2id_1	? EX_ID_SEL :
						hazard_mem2id_1	? MEM_ID_SEL :
						hazard_wb2id_1	? WB_ID_SEL :
						RS_ID_SEL;
		fwd_id_rs2	=	hazard_ex2id_2	? EX_ID_SEL :
						hazard_mem2id_2	? MEM_ID_SEL :
						hazard_wb2id_2	? WB_ID_SEL :
						RS_ID_SEL;

		// forwarding signal to ex stage
		fwd_ex_rs1	=	hazard_mem2ex_1	? MEM_EX_SEL :
						hazard_wb2ex_1	? WB_EX_SEL :
						RS_EX_SEL;
		fwd_ex_rs2	=	hazard_mem2ex_2	? MEM_EX_SEL :
						hazard_wb2ex_2	? WB_EX_SEL :
						RS_EX_SEL;

		// forwarding signal to mem stage
		fwd_mem_rs1 =	hazard_wb2mem_1	? WB_MEM_SEL :
						RS_MEM_SEL;
		fwd_mem_rs2 =	hazard_wb2mem_2	? WB_MEM_SEL :
						RS_MEM_SEL;
	end


	logic jump_d, jump_x;	// jump instruction in decode/exe stage
	always_comb begin : flush_crtl_signal_assign
		jump_d = (instr_d.opcode == JAL) || (instr_d.opcode == JALR);
		jump_x = (instr_x.opcode == JAL) || (instr_x.opcode == JALR);
	end
	always_comb begin : flush_assign
		flush_pc		= jump_d;		// actually masks output
		flush_if_id		= jump_x;
		flush_id_ex		= DISABLE;
		flush_ex_mem	= DISABLE;
		flush_mem_wb	= DISABLE;
	end


	logic data_mem_stall;	// pipeline stall from data memory access
	always_comb begin : data_mem_stall_assign
		data_mem_stall = ((instr_m.opcode == STORE) || (instr_m.opcode == LOAD)) && ~mem_access_done;
	end


	// hazard when load/jump follows a branch
	// a true hazard and does not be resolven by forwarding
	// both hazard 4 and harrard 5 requires to stall pipeline on F and D stages
	logic load_hazard_1a, load_hazard_1b; // load - branch
	logic load_hazard_2a, load_hazard_2b; // load - whatever - branch
	logic load_hazard_1 , load_hazard_2;
	logic decode_use_rs1, decode_use_rs2; // JALR and Branch
	
	always_comb begin : load_branch_stall	// a true hazzard that must stall
		decode_use_rs1	=	((instr_d.opcode == JALR) || (instr_d.opcode == B));

		decode_use_rs2	=	(instr_d.opcode == B);

		load_hazard_1a	=	(instr_x.opcode == LOAD) &&
							(decode_use_rs1) &&
							(instr_x.rd != X0) &&
							(instr_x.rd == instr_d.rs1);
		
		load_hazard_1b	=	(instr_x.opcode == LOAD) &&
							(decode_use_rs2) &&
							(instr_x.rd != X0) &&
							(instr_x.rd == instr_d.rs2);
		
		load_hazard_1		=	load_hazard_1a || load_hazard_1b;
		
		load_hazard_2a	=	(instr_m.opcode == LOAD) &&
							(decode_use_rs1) &&
							(instr_m.rd != X0) &&
							(instr_m.rd == instr_d.rs1);

		load_hazard_2b	=	(instr_m.opcode == LOAD) &&
							(decode_use_rs2) &&
							(instr_m.rd != X0) &&
							(instr_m.rd == instr_d.rs2);
		
		load_hazard_2	=	load_hazard_2a || load_hazard_2b;
	end

	always_comb begin : stall_assign
		stall_pc		= data_mem_stall || ~sdram_init_done || load_hazard_1 || load_hazard_2 || execute_busy;
		stall_if_id		= data_mem_stall || ~sdram_init_done || load_hazard_1 || load_hazard_2 || execute_busy;
		stall_id_ex		= data_mem_stall || ~sdram_init_done || execute_busy;
		stall_ex_mem	= data_mem_stall || ~sdram_init_done;
		stall_mem_wb	= data_mem_stall || ~sdram_init_done;	// stall for mem-mem fwd
	end

endmodule : hazard_ctrl
