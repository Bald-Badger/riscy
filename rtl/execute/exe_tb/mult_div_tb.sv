import defines::*;
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module mult_div_tb();
	
	instr_t instr;
	data_t a_in, b_in, c_out;
	
	logic[79:0] c_mul_gold;
	data_t c_ref;
	int i;
	int err;
	logic cor;
	assign cor = c_ref == c_out;
	int itr = 1000000;

	mult_div iDUT (
		.instr(instr),
		.a_in(a_in),
		.b_in(b_in),
		.c_out(c_out)
	);

	logic[63:0] a_ex, b_ex;

	initial begin
		#10
		DIV_by_0_test();
		DIVU_by_0_test();
		REM_by_0_test();
		REMU_by_0_test();
		DIV_overflow_test();
		REM_overflow_test();
		DIV_test();
		DIVU_test();
		REM_test();
		REMU_test();
		MULHSU_test();
		MULH_test();
		MUL_test();
		MULHU_test();
		#10;
		$stop();
	end


task DIV_by_0_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = DIV;
		a_in = $random();
		b_in = 0;
		c_ref = 32'hFFFF_FFFF;
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("DIV_by_0_test fail");
	else
		$display("DIV_by_0_test pass");
endtask


task DIVU_by_0_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = DIVU;
		a_in = $random();
		b_in = 0;
		c_ref = 32'hFFFF_FFFF;
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("DIVU_by_0_test fail");
	else
		$display("DIVU_by_0_test pass");
endtask


task REM_by_0_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = REM;
		a_in = $random();
		b_in = 0;
		c_ref = a_in;
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("REM_by_0_test fail");
	else
		$display("REM_by_0_test pass");
endtask


task REMU_by_0_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = REMU;
		a_in = $random();
		b_in = 0;
		c_ref = a_in;
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("REMU_by_0_test fail");
	else
		$display("REMU_by_0_test pass");
endtask


task DIV_overflow_test();
	instr = NULL;
	instr.funct3 = DIV;
	a_in = 32'h8000_0000;
	b_in = 32'hFFFF_FFFF;
	c_ref = a_in;
	#5;
	assert (c_ref == c_out) 
	else   err = 1;
	#5;
	if (err)
		$display("DIV_overflow_test fail");
	else
		$display("DIV_overflow_test pass");
endtask


task REM_overflow_test();
	instr = NULL;
	instr.funct3 = REM;
	a_in = 32'h8000_0000;
	b_in = 32'hFFFF_FFFF;
	c_ref = 0;
	#5;
	assert (c_ref == c_out) 
	else   err = 1;
	#5;
	if (err)
		$display("REM_overflow_test fail");
	else
		$display("REM_overflow_test pass");
endtask


task DIV_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = DIV;
		a_in = $random();
		b_in = $random()>>>5;
		a_ex = {{32{a_in[31]}},{a_in}};
		b_ex = {{32{b_in[31]}},{b_in}};
		c_mul_gold = $signed(a_ex) / $signed(b_ex);
		c_ref = c_mul_gold[31:0];
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("DIV test fail");
	else
		$display("DIV test pass");
endtask


task DIVU_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = DIVU;
		a_in = $random();
		b_in = $random();
		c_mul_gold = $unsigned(a_in) / $unsigned(b_in);
		c_ref = c_mul_gold[31:0];
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("DIVU test fail");
	else
		$display("DIVU test pass");
endtask


task REM_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = REM;
		a_in = $random();
		b_in = $random() >>> 5;
		a_ex = {{32{a_in[31]}},{a_in}};
		b_ex = {{32{b_in[31]}},{b_in}};
		c_mul_gold = $signed(a_ex) % $signed(b_ex);
		c_ref = c_mul_gold[31:0];
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("REM test fail");
	else
		$display("REM test pass");

endtask


task REMU_test();
		// REMU test
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = REMU;
		a_in = $random();
		b_in = $random() >> 5;
		c_mul_gold = $unsigned(a_in) % $unsigned(b_in);
		c_ref = c_mul_gold[31:0];
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("REMU test fail");
	else
		$display("REMU test pass");
endtask


task MULHSU_test();
		err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = MULHSU;
		a_in = $random();
		b_in = $random();
		a_ex = {{32{a_in[31]}},{a_in}};
		b_ex = {{32'b0},{b_in}};
		c_mul_gold = $signed(a_ex) * $unsigned(b_ex);
		c_ref = c_mul_gold[2*XLEN-1:XLEN];
		#5;
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("MULHSU test fail");
	else
		$display("MULHSU test pass");
endtask


task MULH_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = MULH;
		a_in = $random();
		b_in = $random();
		c_mul_gold = $signed(a_in) * $signed(b_in);
		c_ref = c_mul_gold[2*XLEN-1:XLEN];
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("MULH test fail");
	else
		$display("MULH test pass");
endtask


task MUL_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = MUL;
		a_in = $random();
		b_in = $random();
		c_mul_gold = $signed(a_in) * $signed(b_in);
		c_ref = c_mul_gold[31:0];
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("MUL test fail");
	else
		$display("MUL test pass");	
endtask	


task MULHU_test();
	err = 0;
	for (i = 0; i < itr; i++) begin
		instr = NULL;
		instr.funct3 = MULHU;
		a_in = $random();
		b_in = $random();
		c_mul_gold = $unsigned(a_in) * $unsigned(b_in);
		c_ref = c_mul_gold[2*XLEN-1:XLEN];
		#5
		assert (c_ref == c_out) 
		else   err = 1;
		#5;
	end
	if (err)
		$display("MULHU test fail");
	else
		$display("MULHU test pass");
endtask

endmodule