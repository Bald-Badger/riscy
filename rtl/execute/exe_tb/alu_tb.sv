module top (
	
);
	import "DPI-C" context function int test(input int ip);

	initial begin
		$display("test%d", test(11));
		$stop();
	end

endmodule