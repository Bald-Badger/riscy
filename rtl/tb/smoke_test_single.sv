import defines::*;
`timescale 1ns/1ns

module smoke_test_single ();
	
	proc_hier proc_hier_inst();

	int error = 0;
	int fd;
	initial begin
		@(posedge proc_hier_inst.ebreak_start);
		assert (proc_hier_inst.processor_inst.decode_inst.registers_inst.reg_bypass_inst.registers[10] == 42)
				else error = 1;
		assert (proc_hier_inst.processor_inst.decode_inst.registers_inst.reg_bypass_inst.registers[17] == 93)
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
