`timescale 1ps/1ps
import defines::*;
import mem_defines::*;

module mem_sys_tb ();
	//logic define
	logic		clk, clk_50m, clk_100m, clk_100m_shift;
	logic		rst_n, but_rst_n;
	logic		locked;

	pll_clk	pll_inst (
	.areset		(~but_rst_n),
	.inclk0		(clk),
	.locked		(locked),
	.c0			(clk_50m),
	.c1			(clk_100m),
	.c2			(clk_100m_shift)
	);

	initial begin
		clk = 0;
		but_rst_n = 0;                      
		#100000;
		but_rst_n = 1;
	end

assign rst_n = (but_rst_n & locked);

// 50MHz
always #10000 clk = ~clk; 

data_t	addr;
data_t	data_in, data_out;
logic	wr, rd, valid, done;
logic	sdram_init_done;

task init();
	addr = 0;
	data_in = 0;
	wr = 0;
	rd = 0;
	valid = 0;
	@(posedge sdram_init_done);
	$stop();
endtask 

task  single_w_r_test();
	@(posedge clk_50m);
	wr = 1;
	valid = 1;
	addr = 0;
	data_in = $urandom();
	@(posedge done);
	@(posedge clk_50m);
	wr = 0;
	rd = 1;
	@(posedge done);
	@(posedge clk_50m);
	valid = 0;
	rd = 0;
	assert (data_in == data_out) 
	else   $error("single_w_r test failed");
endtask

initial begin
	init();
	single_w_r_test();
	$stop();
end

mem_sys mem_sys_inst (
	.clk_50m		(clk_50m),
	.clk_100m		(clk_100m),
	.clk_100m_shift	(clk_100m_shift),
	.rst_n			(rst_n),

	.addr			(addr),
	.data_in		(data_in),
	.wr				(wr),
	.rd				(rd),
	.valid			(valid),
	
	.data_out		(data_out),
	.done			(done),
	.sdram_init_done(sdram_init_done)
);

endmodule : mem_sys_tb
