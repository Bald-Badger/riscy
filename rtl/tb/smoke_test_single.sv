import defines::*;
`timescale 1ns/1ns

module smoke_test_single ();
	
	int error = 0;
	int fd;

	logic clk, rst_n, ebreak_start;
	clkrst clkrst_inst(
		.clk	(clk),
		.rst_n	(rst_n)
	);

	proc_hier top_inst (
		.osc_clk		(clk),
		.but_rst_n		(rst_n),
		.ebreak_start	(ebreak_start)
	);

	initial begin
		@(posedge ebreak_start);
		assert (top_inst.processor_inst.decode_inst.registers_inst.reg_bypass_inst.registers[10] == 42)
				else error = 1;
		assert (top_inst.processor_inst.decode_inst.registers_inst.reg_bypass_inst.registers[17] == 93)
				else error = 1;
		
		fd = $fopen("./result.txt", "w");
		if (!fd) begin
			$display("file open failed");
			$stop();
		end

		if (error)begin
			$display("test failed");
			$fwrite(fd, "fail");
		end
			
		else begin
			$display("test passed");
			$fwrite(fd, "success");
		end
		$fclose(fd);
		$stop();
	end	
endmodule

module clkrst #(
	FREQ = FREQ
) (
	output logic clk,
	output logic rst_n
);

	localparam period = 1e12/FREQ;	// in ps
	localparam half_period = period/2;

	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		repeat(2) @(negedge clk);
		#1;
		rst_n = 1'b1;
		repeat(1000) @(negedge clk);
		$stop();
	end

	always #half_period begin
      clk = ~clk;
    end
	
endmodule : clkrst
