`timescale 1ps/1ps
import defines::*;
import mem_defines::*;

module atomic_tb ();

//logic define
logic			clk, clk_50m, clk_100m, clk_100m_shift;
logic			rst_n, but_rst_n;
logic			locked;
integer 		err;
integer			break_mark;
integer			i, iter;	// test length for random test
// memory space in 32 bit words(to limit simulation size)
localparam 		mem_space = 16384;	
// limit test mem size for coverage
localparam		rand_test_mem_space = mem_space; // in 32bit word
localparam		addr_mask_w = 32'h0000_FFFC;
localparam		addr_mask_h = 32'h0000_FFFE;
localparam		addr_mask_b = 32'h0000_FFFF;
word_t			ref_mem [0:mem_space-1];

cache_addr_t	addr, addr_in;
instr_s_t		instr;
data_t			data_in, data_out;
word_t			w, d_dut, d_ref, d_ref_raw;
data_t			data1, data2, data3, data4;
logic			valid, done;
logic			sdram_init_done;
logic [2:0]		m;


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


logic			sdram_clk;
logic			sdram_cke;
logic			sdram_cs_n;
logic			sdram_ras_n;
logic			sdram_cas_n;
logic        	sdram_we_n;
logic	[ 1:0]	sdram_ba;
logic	[12:0]	sdram_addr;
wire	[15:0]	sdram_data;
logic	[ 1:0]	sdram_dqm;


reservation_set_t reservation_set_ref [$] = {};


memory memory_inst (
	// input
	.clk				(clk),
	.clk_100m			(clk_100m),
	.clk_100m_shift		(clk_100m_shift),
	.rst_n				(rst_n),
	.addr				(addr_in),
	.data_in_raw		(data_in),
	.mem_mem_fwd_data	(NULL),
	.fwd_m2m			(RS_MEM_SEL),
	.instr				(instr),
	
	// output
	.data_out			(data_out),
	.sdram_init_done	(sdram_init_done),
	.done				(done),

	// SDRAM hardware pins
	.sdram_clk			(sdram_clk), 
	.sdram_cke			(sdram_cke),
	.sdram_cs_n			(sdram_cs_n),
	.sdram_ras_n		(sdram_ras_n),
	.sdram_cas_n		(sdram_cas_n),
	.sdram_we_n			(sdram_we_n),
	.sdram_ba			(sdram_ba),
	.sdram_addr			(sdram_addr),
	.sdram_data			(sdram_data),
	.sdram_dqm			(sdram_dqm)
);


sdr sdram_functional_model(    
		.Clk			(sdram_clk),
		.Cke			(sdram_cke),
		.Cs_n			(sdram_cs_n),
		.Ras_n			(sdram_ras_n),
		.Cas_n			(sdram_cas_n),
		.We_n			(sdram_we_n),
		.Ba				(sdram_ba),
		.Addr			(sdram_addr),
		.Dq				(sdram_data),
		.Dqm			(sdram_dqm)
);


task write_mem (
	input data_t	a,
	input data_t	d,
	input funct3_t	mode	// SB: 000; SH: 001; SW: 010;
);
	fork
		begin
			if (mode == SB) begin
				case (addr[1:0])	// in little endian
					2'b00: begin
						ref_mem[a >> 2].b0 = d[7:0];
					end
					2'b01: begin
						ref_mem[a >> 2].b1 = d[7:0];
					end
					2'b10: begin
						ref_mem[a >> 2].b2 = d[7:0];
					end
					2'b11: begin
						ref_mem[a >> 2].b3 = d[7:0];
					end
				endcase
			end else if (mode == SH) begin
				case (addr[1])
					1'b0: begin
						if (ENDIANESS == LITTLE_ENDIAN) begin
							ref_mem[a>>2].b0 = d[7:0];
							ref_mem[a>>2].b1 = d[15:8];
						end else begin
							ref_mem[a>>2].b0 = d[15:8];
							ref_mem[a>>2].b1 = d[7:0];
						end
					end

					1'b1: begin
						if (ENDIANESS == LITTLE_ENDIAN) begin
							ref_mem[a>>2].b2 = d[7:0];
							ref_mem[a>>2].b3 = d[15:8];
						end else begin
							ref_mem[a>>2].b2 = d[15:8];
							ref_mem[a>>2].b3 = d[7:0];
						end
					end
				endcase
			end else if (mode == SW) begin
				if (ENDIANESS == LITTLE_ENDIAN) begin
					ref_mem[a>>2].b0 = d[7:0];
					ref_mem[a>>2].b1 = d[15:8];
					ref_mem[a>>2].b2 = d[23:16];
					ref_mem[a>>2].b3 = d[31:24];
				end else begin
					ref_mem[a>>2].b0 = d[31:24];
					ref_mem[a>>2].b1 = d[23:16];
					ref_mem[a>>2].b2 = d[15:8];
					ref_mem[a>>2].b3 = d[7:0];	
				end
			end else begin
				$display("bad store funct3");
			end
			addr_in	= a;
			data_in	= d;
			instr.opcode = STORE;
			instr.funct3 = mode;
			valid = 1;
			@(posedge done);
			if (reservation_set_ref[0].valid && reservation_set_ref[0].addr == a) begin
				reservation_set_ref[0].valid = INVALID;
			end
			@(negedge done);
			valid = 0;
			instr = NOP;
		end

		begin
			repeat(100) @(posedge clk_50m);
			$display("write timeout!");
			$stop();
		end
	join_any
	disable fork;
endtask


task read_mem (
	input data_t a,
	input funct3_t mode
);
	d_ref_raw = word_t'(ref_mem[addr >> 2]);
	fork
		begin
			case (mode)
				LB: begin
					case (addr[1:0])
						2'b00: d_ref = sign_extend_b(d_ref_raw.b0);
						2'b01: d_ref = sign_extend_b(d_ref_raw.b1);
						2'b10: d_ref = sign_extend_b(d_ref_raw.b2);
						2'b11: d_ref = sign_extend_b(d_ref_raw.b3);
					endcase
				end 
				LH: begin
					case (addr[1])
						1'b0: begin
							if (ENDIANESS == LITTLE_ENDIAN) begin
								d_ref = sign_extend_h({d_ref_raw.b1, d_ref_raw.b0});
							end else begin
								d_ref = sign_extend_h({d_ref_raw.b0, d_ref_raw.b1});
							end
						end
						1'b1: begin
							if (ENDIANESS == LITTLE_ENDIAN) begin
								d_ref = sign_extend_h({d_ref_raw.b3, d_ref_raw.b2});
							end else begin
								d_ref = sign_extend_h({d_ref_raw.b2, d_ref_raw.b3});
							end
						end
					endcase
				end
				LW: begin
					if (ENDIANESS == LITTLE_ENDIAN) begin
						d_ref = {d_ref_raw.b3, d_ref_raw.b2, d_ref_raw.b1, d_ref_raw.b0};
					end else begin
						d_ref = {d_ref_raw.b0, d_ref_raw.b1, d_ref_raw.b2, d_ref_raw.b3};
					end
				end
				LBU: begin
						case (addr[1:0])
						2'b00: d_ref = zero_extend_b(d_ref_raw.b0);
						2'b01: d_ref = zero_extend_b(d_ref_raw.b1);
						2'b10: d_ref = zero_extend_b(d_ref_raw.b2);
						2'b11: d_ref = zero_extend_b(d_ref_raw.b3);
					endcase
				end
				LHU: begin
					case (addr[1])
						1'b0: begin
							if (ENDIANESS == LITTLE_ENDIAN) begin
								d_ref = zero_extend_h({d_ref_raw.b1, d_ref_raw.b0});
							end else begin
								d_ref = zero_extend_h({d_ref_raw.b0, d_ref_raw.b1});
							end
						end
						1'b1: begin
							if (ENDIANESS == LITTLE_ENDIAN) begin
								d_ref = zero_extend_h({d_ref_raw.b3, d_ref_raw.b2});
							end else begin
								d_ref = zero_extend_h({d_ref_raw.b2, d_ref_raw.b3});
							end
						end
					endcase
				end
				default: begin
					$display("bad load funct3");
				end
			endcase
			addr_in	= a;
			instr.opcode = LOAD;
			instr.funct3 = mode;
			valid = 1;
			@(posedge done);
			#1;
			d_dut = data_out;
			@(negedge done);
			valid = 0;
			instr = NOP;
		end

		begin
			repeat(100) @(posedge clk_50m);
			$display("read timeout!");
			$stop();
		end
	join_any
	disable fork;
endtask


task load_reserved(
	input data_t a
);
	fork
		begin
			d_ref_raw = word_t'(ref_mem[a >> 2]);
			if (ENDIANESS == LITTLE_ENDIAN) begin
				d_ref = {d_ref_raw.b3, d_ref_raw.b2, d_ref_raw.b1, d_ref_raw.b0};
			end else begin
				d_ref = {d_ref_raw.b0, d_ref_raw.b1, d_ref_raw.b2, d_ref_raw.b3};
			end
			addr_in	= a;
			instr = instr_a_t'(instr);
			instr.opcode = ATOMIC;
			instr[31:27] = LR;
			valid = 1;
			@(posedge done);
			reservation_set_ref.push_front({a, VALID});
			//$display("load reserve at addr %h, stack len is %d", a, reservation_set_ref.size());
			#1;
			d_dut = data_out;
			@(negedge done);
			valid = 0;
			instr = NOP;
		end

		begin
			repeat(200) @(posedge clk_50m);
			$display("lr timeout!");
			$stop();
		end
	join_any
	disable fork;
endtask


task store_conditional (
	input data_t	a,
	input data_t	d
);
	fork
		begin
			addr_in	= a;
			data_in	= d;
			instr.opcode = ATOMIC;
			instr[31:27] = SC;
			valid = 1;
			if(reservation_set_ref[0].valid && reservation_set_ref[0].addr == a) begin
				//$display("store-conditional success");
				d_ref = SC_SUCCESS_CODE;
				if (ENDIANESS == LITTLE_ENDIAN) begin
					ref_mem[a>>2].b0 = d[7:0];
					ref_mem[a>>2].b1 = d[15:8];
					ref_mem[a>>2].b2 = d[23:16];
					ref_mem[a>>2].b3 = d[31:24];
				end else begin
					ref_mem[a>>2].b0 = d[31:24];
					ref_mem[a>>2].b1 = d[23:16];
					ref_mem[a>>2].b2 = d[15:8];
					ref_mem[a>>2].b3 = d[7:0];	
				end
			end else begin
				//$display("store-conditional fail at addr%h", a);
				d_ref = SC_FAIL_ECODE;
			end	
			#1;
			wait(done == 1'b1);
			reservation_set_ref.pop_front();
			d_dut = data_out;
			@(posedge clk);
			#1;
			valid = 0;
			instr = NOP;
		end

		begin
			repeat(200) @(posedge clk_50m);
			$display("sc timeout!");
			$stop();
		end
	join_any
	disable fork;
endtask


task atomic_lr_sc_pair_test();
	addr = 4;
	data1 = 32'd3;
	data2 = 32'd7;
	write_mem(addr, data1, SW);
	load_reserved(addr);
	assert (d_dut == d_ref) 
	else   err = 1;
	store_conditional(addr, data2);
	assert (d_dut == d_ref) 
	else   err = 1;
	if (err)
		$display("atomic_lr_sc_pair_test failed");
	else
		$display("atomic_lr_sc_pair_test passed");
endtask


task atomic_lr_sc_fail_test();
	addr = 4;
	data1 = 32'd3;
	data2 = 32'd5;
	data3 = 32'd7;
	write_mem(addr, data1, SW);
	load_reserved(addr);
		assert (d_dut == d_ref) 
		else   err = 1;
	write_mem(addr, data2, SW);		// invaliadte reservation set
	store_conditional(addr, data3);	// this should fail
		assert (d_dut == d_ref) 
		else   err = 1;
	read_mem(addr, LW);
		assert (d_dut == d_ref) 
		else   err = 1;
	if (err)
		$display("atomic_lr_sc_fail_test failed");
	else
		$display("atomic_lr_sc_fail_test passed");
endtask


task nested_lr_sc_suc_test();
	addr = 4;
	data1 = 32'd3;
	data2 = 32'd5;
	data3 = 32'd7;
	write_mem(addr, data1, SW);
	addr = 8;
	write_mem(addr, data2, SW);
	addr = 4;
	load_reserved(addr);
	assert (d_dut == d_ref) 
	else   err = 1;
	addr = 8;
	load_reserved(addr);
	assert (d_dut == d_ref) 
	else   err = 1;
	store_conditional(addr, data3);	// should success
	assert (d_dut == d_ref) 
	else   err = 1;
	addr = 4;
	store_conditional(addr, data3);		// should success
	assert (d_dut == d_ref) 
	else   err = 1;
	if (err)
		$display("nested_lr_sc_suc_test failed");
	else
		$display("nested_lr_sc_suc_test passed");
endtask


task nested_lr_sc_fail_test();
	addr = 4;
	data1 = 32'd3;
	data2 = 32'd5;
	data3 = 32'd7;
	write_mem(addr, data1, SW);
	addr = 8;
	write_mem(addr, data2, SW);
	addr = 4;
	load_reserved(addr);
	assert (d_dut == d_ref) 
	else   err = 1;
	addr = 8;
	load_reserved(addr);
	assert (d_dut == d_ref) 
	else   err = 1;
	addr = 4;
	store_conditional(addr, data3);	// should fail
	assert (d_dut == d_ref) 
	else   err = 1;
	addr = 4;
	store_conditional(addr, data3);	// should success
	assert (d_dut == d_ref) 
	else   err = 1;
	if (err)
		$display("nested_lr_sc_fail_test failed");
	else
		$display("nested_lr_sc_fail_test passed");
endtask


task nested_long_lr_sc_suc_test();
	addr = 4;
	data1 = 32'd3;
	for (i = 0; i < MAX_NEST_LOCK; i++) begin
		write_mem(addr, data1, SW);
		addr = addr + 4;
		data1 = data1 + 2;
	end

	addr = 4;
	data1 = 4;

	for (i = 0; i < MAX_NEST_LOCK-1; i++) begin
		load_reserved(addr);
		assert (d_dut == d_ref) 
		else   err = 1;
		addr = addr + 4;
	end

	addr = addr - 4;

	for (i = 0; i < MAX_NEST_LOCK-1; i++) begin
		store_conditional(addr, data1);	// should success
		assert (d_dut == d_ref) 
		else   err = 1;
		addr = addr - 4;
		data1 = data1 + 2;
	end
	if (err)
		$display("nested_long_lr_sc_suc_test failed");
	else
		$display("nested_long_lr_sc_suc_test passed");
endtask


task init();
	err		= 0;
	addr	= 0;
	data_in	= 0;
	valid	= 0;
	iter	= 0;
	@(posedge sdram_init_done);
endtask 


initial begin : main
	init();
	atomic_lr_sc_pair_test();
	atomic_lr_sc_fail_test();
	nested_lr_sc_suc_test();
	nested_lr_sc_fail_test();
	nested_long_lr_sc_suc_test();
	$stop();
end

endmodule : atomic_tb
