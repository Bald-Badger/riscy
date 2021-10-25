// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

module div_tb ();
	
	logic	clk;	// for multi-cycle computation
	instr_t	instr;
	data_t 	a_in;
	data_t 	b_in;
	integer err;

	data_t 	c_out;
	logic	rd_wr;
	logic	div_result_valid;

	task init();
		clk = 1'b0;
		instr = NOP;
		a_in = NULL;
		b_in = NULL;
		err = 0;
	endtask

	initial begin
		init();
		@(negedge clk);
		a_in = 32'd12;
		b_in = 32'd6;
		instr.opcode = R;
		instr.funct7 = M_INSTR;
		instr.funct3 = DIV;
		@(posedge div_result_valid)
		#1;
		assert (c_out == a_in / b_in) 
		else   err = 1;
		
		@(negedge div_result_valid)

		a_in = 32'd18;
		@(posedge div_result_valid)
		#1;
		assert (c_out == a_in / b_in) 
		else   err = 1;
		@(negedge div_result_valid)
		instr = NOP;
		if (err)
			$display("test failed");
		else 
			$display("test passed");
	end

	alu alu_inst (
		// clk for multi-cycle computation
		.clk				(clk),
		
		// input
		.instr				(instr),
		.a_in				(a_in),
		.b_in				(b_in),

		// output
		.c_out				(c_out),
		.rd_wr				(),
		.div_result_valid	(div_result_valid)
	);

	localparam period = 1e12/FREQ;	// in ps
	localparam half_period = period/2;

	initial begin
		repeat(150) @(negedge clk);
		$display("timeout");
		$stop();
	end

	always #half_period begin
      clk = ~clk;
    end

endmodule : div_tb
