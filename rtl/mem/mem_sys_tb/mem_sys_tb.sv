`timescale 1ps/1ps
import defines::*;
import mem_defines::*;

module mem_sys_tb ();
	//logic define
	logic		clk, clk_50m, clk_100m, clk_100m_shift;
	logic		rst_n, but_rst_n;
	logic		locked;
	integer 	err;

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

cache_addr_t	addr, addr_in;
data_t	data_in, data_out;
data_t	data1, data2, data3, data4;
logic	wr, rd, valid, done;
logic	sdram_init_done;

task init();
	err = 0;
	addr = 0;
	data_in = 0;
	wr = 0;
	rd = 0;
	valid = 0;
	@(posedge sdram_init_done);
endtask 


// test that write then read at inedx0 tag0 way0;
task  single_w_r_test_1();
	@(posedge clk_50m);
	wr = 1;
	valid = 1;
	addr_in = 0;
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
	else   err = 1;
	if (err) begin
		$display("single_w_r_1 test failed");
		err = 0;
	end else begin
		$display("single_w_r_1 test passed");
	end
endtask

// test write at index1, tag1, off0
task  single_w_r_test_2();
	err = 0;
	data1 = $urandom();
	addr = cache_addr_t'(0);
	addr.index = 9'b1;
	addr.tag = 19'b1;
	write_cache(addr, data1);
	read_cache(addr, data2);
	assert (data1 == data2) 
	else   err = 1;
	if (err) begin
		$display("single_w_r_2 test failed");
		err = 0;
	end else begin
		$display("single_w_r_2 test passed");
	end
	data1 = 0;
	data2 = 0;
endtask

// test write at index1, tag1
task  single_w_r_test_3();
	err = 0;
	data1 = $urandom();
	addr = cache_addr_t'(0);
	addr.index = 9'b1;
	addr.tag = 19'b1;
	addr.word_off = 2'b10;
	write_cache(addr, data1);
	read_cache(addr, data2);
	assert (data1 == data2) 
	else   err = 1;
	if (err) begin
		$display("single_w_r_3 test failed");
		err = 0;
	end else begin
		$display("single_w_r_3 test passed");
	end
	data1 = 0;
	data2 = 0;
endtask

// write 2 time to same index, new data should go to way 2
task write_2_way_test();
	err = 0;
	data1 = $urandom();
	data2 = $urandom();
	addr = cache_addr_t'(0);
	write_cache(addr, data1);
	addr.tag = 1;
	write_cache(addr, data2);
	addr.tag = 0;
	read_cache(addr, data3);
	addr.tag = 1;
	read_cache(addr, data4);
	assert (data1 == data3) 
	else   err = 1;
	assert (data2 == data4) 
	else   err = 1;
	if (err) begin
		$display("write_2_way_test failed");
		err = 0;
	end else begin
		$display("write_2_way_test passed");
	end	
endtask

// write 3 time to the same index, oldest data should evict
task evict_test_1();
	err = 0;
	data1 = $urandom();
	data2 = $urandom();
	data3 = $urandom();
	addr = cache_addr_t'(0);

	addr.tag = 0;
	write_cache(addr, data1);

	addr.tag = 1;
	write_cache(addr, data2);

	addr.tag = 2;
	write_cache(addr, data3);	// should evict way 0

	read_cache(addr, data4);

	assert (data3 == data4) 
	else   err = 1;
	if (err) begin
		$display("evict_test_1 failed");
		err = 0;
	end else begin
		$display("evict_test_1 passed");
	end	

endtask

// write 3 time to the same index, then read oldest data from memory
task evict_test_2();
	err = 0;
	data1 = $urandom();
	data2 = $urandom();
	data3 = $urandom();
	addr = cache_addr_t'(0);

	addr.tag = 0;
	write_cache(addr, data1);	// install on way 0

	addr.tag = 1;
	write_cache(addr, data2);	// install on way 1

	addr.tag = 2;
	write_cache(addr, data3);	// should evict way 0

	addr.tag = 0;

	read_cache(addr, data4);	// should evict way 1

	assert (data1 == data4) 
	else   err = 1;
	if (err) begin
		$display("evict_test_2 failed");
		err = 0;
	end else begin
		$display("evict_test_2 passed");
	end	

endtask


task  write_cache(input cache_addr_t a, input data_t d);
	wr = 1;
	valid = 1;
	addr_in = a;
	data_in = d;
	@(posedge done);
	@(posedge clk_50m);
	valid = 0;
	wr = 0;
endtask

task read_cache(input cache_addr_t a, output data_t d);
	rd = 1;
	valid = 1;
	addr_in = a;
	@(posedge done);
	@(posedge clk_50m);
	valid = 0;
	rd = 0;
	d = data_out;
endtask

initial begin : main
	init();
	single_w_r_test_1();
	single_w_r_test_2();
	single_w_r_test_3();
	write_2_way_test();
	evict_test_1();
	evict_test_2();
	@(posedge clk_50m);
	@(posedge clk_50m);
	@(posedge clk_50m);
	$stop();
end

mem_sys mem_sys_inst (
	.clk_50m		(clk_50m),
	.clk_100m		(clk_100m),
	.clk_100m_shift	(clk_100m_shift),
	.rst_n			(rst_n),

	.addr			(addr_in),
	.data_in		(data_in),
	.wr				(wr),
	.rd				(rd),
	.valid			(valid),
	
	.data_out		(data_out),
	.done			(done),
	.sdram_init_done(sdram_init_done)
);

endmodule : mem_sys_tb
