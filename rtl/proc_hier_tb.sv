import defines::*;
`timescale 1ns/1ns

module proc_hier_tb ();
	
	proc_hier proc_hier_inst();

	int error = 0;
	initial begin
		@(posedge proc_hier_inst.ebreak_start);
		assert (proc_hier_inst.processor_inst.decode_inst.registers_inst.reg_bypass_inst.registers[10] == 42)
				else error = 1;
		assert (proc_hier_inst.processor_inst.decode_inst.registers_inst.reg_bypass_inst.registers[17] == 93)
				else error = 1;
		if (error)
			$display("test failed");
		else 
			$display("test passed");
		$stop();
	end	
endmodule
