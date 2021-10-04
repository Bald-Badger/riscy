// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

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
		rst_n = 1'b1;
		repeat(10) @(negedge clk);
		rst_n = 1'b0;
		repeat(10) @(negedge clk);
		#5;
		rst_n = 1'b1;
		repeat(1000) @(negedge clk);
		$stop();
	end

	always #half_period begin
      clk = ~clk;
    end
	
endmodule : clkrst
