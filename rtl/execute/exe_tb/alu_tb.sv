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

	localparam ITER = 10000;
	logic[XLEN-1:0] shamt_mask = 32'h0000001F;

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
			b_in = $urandom() & shamt_mask;
			c_gold = a_in << b_in[4:0];
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
			b_in = $urandom() & shamt_mask;
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
			b_in = $urandom() & shamt_mask;
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

	initial begin
		init();
		$display("Hajimaruyo!");
		R_test();
		$stop();
	end

endmodule