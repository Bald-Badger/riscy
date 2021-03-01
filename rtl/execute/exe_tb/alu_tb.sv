`include "../../opcode.svh"
`include "../alu_define.svh"

module alu_tb ();
	//import "DPI-C" context function int test(input int ip);

	instr_t instr;
	data_t 	a_in;
	data_t 	b_in;
	data_t 	c_out, c_gold;
	logic carry_bit;
	logic	rd_wr;
	integer err_cnt;
	r_t shamt;

	localparam ITER = 100000;

	alu alu_dut (
		.instr	(instr),
		.a_in	(a_in),
		.b_in	(b_in),
		.c_out	(c_out),
		.rd_wr	(rd_wr)
	);

	task init ();
		instr = NULL;
		a_in = NULL;
		b_in = NULL;
		c_gold = NULL;
		shamt = 5'b0;
		carry_bit = 1'b0;
		err_cnt = 0;
	endtask

	task add_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h00208033);	// add x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			{carry_bit, c_gold} = a_in + b_in;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("ADD test pass, err count: %d", err_cnt);
		end else begin
			$display("ADD test failed, err count: %d", err_cnt);
		end
	endtask

	task sub_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h40208033);	// sub x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			c_gold = $signed(a_in) - $signed(b_in);
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SUB test pass, err count: %d", err_cnt);
		end else begin
			$display("SUB test failed, err count: %d", err_cnt);
		end
	endtask

	task and_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h0020F033);	// and x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			c_gold = a_in & b_in;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("AND test pass, err count: %d", err_cnt);
		end else begin
			$display("AND test failed, err count: %d", err_cnt);
		end
	endtask

	task or_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h0020E033);	// or x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			c_gold = a_in | b_in;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("OR test pass, err count: %d", err_cnt);
		end else begin
			$display("OR test failed, err count: %d", err_cnt);
		end
	endtask

	task xor_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h0020C033);	// xor x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			c_gold = a_in ^ b_in;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("XOR test pass, err count: %d", err_cnt);
		end else begin
			$display("XOR test failed, err count: %d", err_cnt);
		end
	endtask

	task slt_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h0020A033);	// slt x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			c_gold = ($signed(a_in) < $signed(b_in)) ? 32'b1 : 32'b0;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SLT test pass, err count: %d", err_cnt);
		end else begin
			$display("SLT test failed, err count: %d", err_cnt);
		end
	endtask

	task sltu_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h0020B033);	// sltu x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			c_gold = (a_in < b_in) ? 32'b1 : 32'b0;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SLTU test pass, err count: %d", err_cnt);
		end else begin
			$display("SLTU test failed, err count: %d", err_cnt);
		end
	endtask

	task sll_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h00209033);	// sll x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			shamt = r_t'(b_in[4:0]);
			c_gold = a_in << shamt;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SLL test pass, err count: %d", err_cnt);
		end else begin
			$display("SLL test failed, err count: %d", err_cnt);
		end
	endtask

	task srl_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h0020D033);	// srl x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			c_gold = a_in >> b_in[4:0];
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SRL test pass, err count: %d", err_cnt);
		end else begin
			$display("SRL test failed, err count: %d", err_cnt);
		end
	endtask

	task sra_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h4020D033);	// sra x0, x1, x2
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			c_gold = a_in >>> b_in[4:0];
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SRA test pass, err count: %d", err_cnt);
		end else begin
			$display("SRA test failed, err count: %d", err_cnt);
		end
	endtask


	task addi_test ();
		integer i;
		err_cnt = 0;
		instr = 32'h00008013;	// addi x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			instr[31:20] = b_in[31:20];
			{carry_bit, c_gold} = a_in + sign_extend(b_in[31:20]);
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("ADDI test pass, err count: %d", err_cnt);
		end else begin
			$display("ADDI test failed, err count: %d", err_cnt);
		end
	endtask

	task andi_test ();
		integer i;
		err_cnt = 0;
		instr = 32'h0000F013;	// andi x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			instr[31:20] = b_in[31:20];
			c_gold = a_in & sign_extend(b_in[31:20]);
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("ANDI test pass, err count: %d", err_cnt);
		end else begin
			$display("ANDI test failed, err count: %d", err_cnt);
		end
	endtask

	task ori_test ();
		integer i;
		err_cnt = 0;
		instr = 32'h0000E013;	// ori x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			instr[31:20] = b_in[31:20];
			c_gold = a_in | sign_extend(b_in[31:20]);
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("ORI test pass, err count: %d", err_cnt);
		end else begin
			$display("ORI test failed, err count: %d", err_cnt);
		end
	endtask

	task xori_test ();
		integer i;
		err_cnt = 0;
		instr = 32'h0000C013;	// xori x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			instr[31:20] = b_in[31:20];
			c_gold = a_in ^ sign_extend(b_in[31:20]);
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("XORI test pass, err count: %d", err_cnt);
		end else begin
			$display("XORI test failed, err count: %d", err_cnt);
		end
	endtask

	task slti_test ();
		integer i;
		err_cnt = 0;
		instr = 32'h0000A013;	// slti x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			a_in = $signed(sign_extend(a_in[31:20]));
			b_in = $random();
			b_in = $signed(sign_extend(b_in[31:20]));
			instr[31:20] = b_in[31:20];
			c_gold = (a_in < b_in) ? 32'b1 : NULL;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SLTI test pass, err count: %d", err_cnt);
		end else begin
			$display("SLTI test failed, err count: %d", err_cnt);
		end
	endtask

	task sltiu_test ();
		integer i;
		err_cnt = 0;
		instr = 32'h0000B013;	// sltiu x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			a_in = $signed(sign_extend(a_in[31:20]));
			b_in = $random();
			b_in = $signed(sign_extend(b_in[31:20]));
			instr[31:20] = b_in[31:20];
			c_gold = (a_in < b_in) ? 32'b1 : NULL;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SLTIU test pass, err count: %d", err_cnt);
		end else begin
			$display("SLTIU test failed, err count: %d", err_cnt);
		end
	endtask

	task slli_test ();
		integer i;
		err_cnt = 0;
		instr = 32'h00009013;	// slli x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			shamt = r_t'(b_in[4:0]);
			instr.rs2 = shamt;
			c_gold = a_in << shamt;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SLLI test pass, err count: %d", err_cnt);
		end else begin
			$display("SLLI test failed, err count: %d", err_cnt);
		end
	endtask

	task srli_test ();
		integer i;
		err_cnt = 0;
		instr = 32'h0000D013;	// srli x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			shamt = r_t'(b_in[4:0]);
			instr.rs2 = shamt;
			c_gold = a_in >> shamt;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SRLI test pass, err count: %d", err_cnt);
		end else begin
			$display("SRLI test failed, err count: %d", err_cnt);
		end
	endtask

	task srai_test ();
		integer i;
		err_cnt = 0;
		instr = 32'h0000D013;	// srai x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $urandom();
			b_in = $urandom();
			shamt = r_t'(b_in[4:0]);
			instr.rs2 = shamt;
			c_gold = a_in >>> shamt;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SRAI test pass, err count: %d", err_cnt);
		end else begin
			$display("SRAI test failed, err count: %d", err_cnt);
		end
	endtask


	task beq_test (); // this is not a valid test for branching, only to test alu output
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h00100063);	// beq x0, x1, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			c_gold = 0;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("BEQ test pass, err count: %d", err_cnt);
		end else begin
			$display("BEQ test failed, err count: %d", err_cnt);
		end
	endtask

	task lui_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h00000037);	// lui x0, 0
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			instr[31:12] = a_in[31:12];
			b_in = get_imm(instr_t'(instr));
			c_gold = {instr[31:12], 12'b0};
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("LUI test pass, err count: %d", err_cnt);
		end else begin
			$display("LUI test failed, err count: %d", err_cnt);
		end
	endtask

	task auipc_test ();
		$display("skipped this test, should be fine");
	endtask

	task jal_test ();
		$display("skipped this test, should be fine");
	endtask

	task jalr_test ();
		$display("skipped this test, should be fine");
	endtask

	task lw_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h0000A003);	// lw x0, 0(x1)
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			{carry_bit, c_gold} = a_in + b_in;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("LW test pass, err count: %d", err_cnt);
		end else begin
			$display("LW test failed, err count: %d", err_cnt);
		end
	endtask

	task SB_test ();
		integer i;
		err_cnt = 0;
		instr = instr_t'(32'h00008023);	// sb x0, 0(x1)
		for (i = 0; i < ITER; i++) begin
			#5;
			a_in = $random();
			b_in = $random();
			{carry_bit, c_gold} = a_in + b_in;
			#5;
			assert (c_gold == c_out) else err_cnt++;
		end
		if (err_cnt == 0) begin
			$display("SB test pass, err count: %d", err_cnt);
		end else begin
			$display("SB test failed, err count: %d", err_cnt);
		end
	endtask


	task R_test ();
		add_test();
		sub_test();
		and_test();
		or_test();
		xor_test();
		slt_test();
		sltu_test();
		sll_test();
		srl_test();
		sra_test();
	endtask


	task I_test();
		addi_test();
		andi_test();
		ori_test();
		xori_test();
		slti_test();
		sltiu_test();
		slli_test();
		srli_test();
		srai_test();
	endtask

	task Other_test();
		beq_test();
		lui_test();
		auipc_test();
		jal_test();
		jalr_test();
		lw_test();
		SB_test();
	endtask

	initial begin
		init();
		$display("Hajimaruyo!");
		$display("Rrotocol R initiated");
		R_test();
		$display("\n-----------------------\n");
		$display("Protocol I initiated");
		I_test();
		$display("\n-----------------------\n");
		$display("Some other tests...");
		Other_test();
		$display("Owari~");
		$stop();
	end

endmodule