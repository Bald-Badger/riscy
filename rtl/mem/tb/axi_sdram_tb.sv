`timescale 1 ns / 1 ps

import defines::*;
import mem_defines::*;
import axi_defines::*;

module axi_sdram_tb ();
	//logic define
	logic		clk, clk_50m;
	logic		rst_n;
	integer 	err;
	integer		break_mark;
	integer		i, iter;	// test length for random test
	// memory space in words(to limit simulation size)
	localparam 	mem_space = 8192;	
	// limit test mem size for coverage
	localparam	rand_test_mem_space = mem_space; // in 32bit word
	localparam	rand_test_addr_mask = 32'h0000_7FFC;
	reg [XLEN-1:0] ref_mem [0:mem_space-1];

		// 50MHz
	always #10000 clk = ~clk;
	assign clk_50m = clk;

	initial begin
		clk = 0;
		rst_n = 0;                      
		#1000;
		rst_n = 1;
	end

	axi_interface axi_sdram (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_lite_interface axil_sdram (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axil_axi_adapter # (
		.USER_ID	(0)
	) adapter (
		.axil_bus	(axil_sdram),
		.axi_bus	(axi_sdram)
	);

	sdram_interface sdram_bus ();

	sdram_axi_wrapper sdram_axi (
		.clk_i		(clk),
		.rst_i		(~rst_n),
		.axi_bus	(axi_sdram),
		.sdram_bus	(sdram_bus)
	);

	sdr sdram (
		.Clk	(sdram_bus.sdram_clk),
		.Cke	(sdram_bus.sdram_cke),
		.Cs_n	(sdram_bus.sdram_cs_n),
		.Ras_n	(sdram_bus.sdram_ras_n),
		.Cas_n	(sdram_bus.sdram_cas_n),
		.We_n	(sdram_bus.sdram_we_n),
		.Addr	(sdram_bus.sdram_addr),
		.Ba		(sdram_bus.sdram_ba),
		.Dq		(sdram_bus.sdram_dq),
		.Dqm	(sdram_bus.sdram_dqm)
	);

	cache_addr_t	addr, addr_in;
	data_t	data_in, data_out;
	data_t	data1, data2, data3, data4;
	logic	wr, rd, valid, done;

	mem_sys_axil_wrapper master (
		.clk		(clk),
		.rst_n		(rst_n),
		.addr		(addr),
		.data_in	(data_in),
		.wr			(wr),
		.rd			(rd),
		.valid		(valid),
		.be			(4'b1111),
		.data_out	(data_out),
		.done		(done),
		.axil_bus	(axil_sdram)	
	);

task init();
	err		= 0;
	addr	= 0;
	data_in	= 0;
	wr		= 0;
	rd		= 0;
	valid	= 0;
	iter	= 0;
	#200000000;
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

task long_r_w_test();	// a full flush of cache
	err = 0;
	for (i = 0; i < mem_space; i++) begin
		addr = 0;
		addr = (i << 2);
		write_cache(addr, i);
		ref_mem[i] = i;
	end

	for (i = 0; i < mem_space; i++) begin
		addr = 0;
		addr = (i << 2);
		read_cache(addr, data1);
		assert (ref_mem[i] == data1) 
		else begin
			err = 1;
			break_mark = i;
			$display("long_r_w_test failed at iter=%d, expected:%h get:%h", break_mark, ref_mem[i], data1);
		end
	end

	if (err) begin
		$display("long_r_w_test failed at iter=%d", break_mark);
		err = 0;
	end else begin
		$display("long_r_w_test passed");
	end
endtask

task smoke_test();
	single_w_r_test_1();
	single_w_r_test_2();
	single_w_r_test_3();
	write_2_way_test();
	evict_test_1();
	evict_test_2();
	long_r_w_test();
endtask

task  write_cache(input cache_addr_t a, input data_t d);
	fork
		begin
			repeat(100) @(posedge clk_50m);
			$display("write timeout!");
			$stop();
		end

		begin
		wr		= 1;
		valid	= 1;
		addr_in	= a;
		data_in	= d;
		@(posedge done);
		@(posedge clk_50m);
		valid = 0;
		wr = 0;
		end
	join_any
	disable fork;
endtask

task read_cache(input cache_addr_t a, output data_t d);
	fork
		begin
			repeat(100) @(posedge clk_50m);
			$display("read timeout!");
			$stop();
		end

		begin
			rd		= 1;
			valid	= 1;
			addr_in	= a;
			@(posedge done);
			@(posedge clk_50m);
			valid = 0;
			rd = 0;
			d = data_out;
		end
	join_any
	disable fork;
endtask

task rand_test();
	iter = 233333;
	err = 0;
	// init to random
	for (i = 0; i < mem_space; i++) begin
		addr = 0;
		addr = (i << 2);
		data1 = $urandom();
		write_cache(addr, data1);
		ref_mem[i] = data1;
	end

	for (i = 0; i < iter; i++) begin
		data2 = $urandom();
		data3 = $urandom();
		addr = $urandom() && rand_test_addr_mask;
		if (data2[0] == 1) begin	// write
			write_cache(addr, data3);
			ref_mem[addr>>2] = data3;
		end else begin	// read
			read_cache(addr, data4);
			data3 = ref_mem[addr >> 2];
			assert (data4 == data3) 
			else begin
				err = 1;
				break_mark = i;
				$display("rand_test failed at iter=%d, expected:%h get:%h", break_mark, data3, data4);
			end
		end
	end
	if (err) begin
		$display("rand_test failed");
		err = 0;
	end else begin
		$display("rand_test passed");
	end	
endtask

initial begin : main
	init();
	smoke_test();
	rand_test();
	$stop();
end

endmodule : axi_sdram_tb
