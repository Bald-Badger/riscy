`timescale 1ps/1ps
import defines::*;
import mem_defines::*;

module mem_tb ();

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


task word_r_w_test();
	addr = 0;
	data1 = $urandom();
	write_mem(addr, data1, SH);
	read_mem(addr, LBU);
	assert (d_dut == d_ref) 
	else   err = 1;
	if (err)
		$display("word_r_w_test failed");
	else
		$display("word_r_w_test passed");
endtask


task rand_test();
	iter = 23333;

	for (i = 0; i < rand_test_mem_space; i++) begin
		write_mem(((i<<2) & addr_mask_w), i, SW);
	end

	$display("rand_test: mem init finish");

	for (i = 0; i < iter; i++) begin
		data1 = $urandom();
		data2 = $urandom();
		addr = $urandom();
		if (data1[0]) begin	// store
			if(data1[1]) begin
				m = SW;
				addr = addr & addr_mask_w;
			end else if (data1[2]) begin
				m = SH;
				addr = addr & addr_mask_h;
			end else begin
				m = SB;
				addr = addr & addr_mask_b;
			end
			write_mem(addr, data2, m);
		end else begin		// LOAD
			if ((data1[3:1] != LB) && 
				(data1[3:1] != LH) && 
				(data1[3:1] != LW) && 
				(data1[3:1] != LBU) && 
				(data1[3:1] != LHU)) begin
				m = LH;
			end else begin
				m = data1[3:1];
			end
			case (m)
				LB:		addr = addr & addr_mask_b;
				LH:		addr = addr & addr_mask_h;
				LW:		addr = addr & addr_mask_w;
				LBU:	addr = addr & addr_mask_b;
				LHU:	addr = addr & addr_mask_h;
				default:$display("WTF");
			endcase
			read_mem(addr, m);
			#1; 
			assert (d_dut == d_ref) 
			else   begin
				err = 1;
				break_mark = i;
				$display("rand test failed at iter %d", break_mark);
				$stop();
			end
		end
	end
	if (err)
		$display("rand_test failed");
	else
		$display("rand_test passed");
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
	rand_test();
	$stop();
end

endmodule : mem_tb