`timescale 1 ns / 1 ps

import defines::*;
import mem_defines::*;
import axi_defines::*;
import pref_defines::*;


module reference_test_axi ();

	localparam REG_DEBUG = DISABLE;
	localparam MEM_DEBUG = DISABLE;
	
	integer error;
	int fd;

	logic clk, rst_n, ebreak_start, go, rst;
	assign rst = ~rst_n;

	logic ref_halt, ref_halt_wait;
	logic kill_ref;
	logic [XLEN-1:0] boot_pc [0:0];

	clkrst #(.FREQ(FREQ)) clkrst_inst (
		.clk	(clk),
		.rst_n	(rst_n),
		.go		(go)
	);

	initial begin
		$readmemh("boot.cfg", boot_pc);
		$display("DUT: boot mode: binary");
		$display("DUT: booting from pc = %h", boot_pc[0] * 4 + 32'h10000);
	end


	axil_interface instr_bus();		// S00
	axil_interface data_bus();		// S01

	axil_interface ram_bus();		// M00
	axil_interface seg_bus();		// M01
	axil_interface uart_bus();		// M02

	// unused placeholder dummy
	axil_interface s02_bus();
	axil_interface s03_bus();

	axil_interface m03_bus();
	axil_interface m04_bus();
	axil_interface m05_bus();


	proc processor (
		.clk			(clk),
		.rst_n			(rst_n),
		.go				(go),
		.boot_pc		(boot_pc[0][9:0]),
		
		.data_bus		(data_bus),
		.instr_bus		(instr_bus)
	);

	axil_ram_sv_wrapper # (
		.ADDR_WIDTH		(26)
	) ram (
		.clk			(clk),
		.rst			(rst),
		.axil_bus		(ram_bus)
	);

	logic [3:0] s0, s1, s2, s3, s4, s5;
	seg_axil_wrapper dummy_seg_display (
		.clk	(clk),
		.rst	(rst),
		.s00	(seg_bus)
	);
	always_comb begin : seg_peek
		s0 = dummy_seg_display.segs.seg_mem[0];
		s1 = dummy_seg_display.segs.seg_mem[1];
		s2 = dummy_seg_display.segs.seg_mem[2];
		s3 = dummy_seg_display.segs.seg_mem[3];
		s4 = dummy_seg_display.segs.seg_mem[4];
		s5 = dummy_seg_display.segs.seg_mem[5];
	end

	logic riscy_uart_rx;
	logic riscy_uart_tx;
	logic riscy_uart_cts;
	logic riscy_uart_rts;
	logic [7:0] uart_char;

	uart_axil_wrapper # (
		.UART_BPS	(UART_BPS)
	) dummy_uart_slave (
		.clk		(clk),
		.rst		(rst),
		.s00		(uart_bus),
		.uart_rx	(riscy_uart_rx),
		.uart_tx	(riscy_uart_tx),
		.uart_cts	(riscy_uart_cts),
		.uart_rts	(riscy_uart_rts)
	);


	uart_monitor # (
		.CLK_FREQ	(FREQ),
		.UART_BPS	(UART_BPS)
	) my_uart_monitor (
		.clk		(clk),
		.rst		(rst),
		.RX			(riscy_uart_tx),
		.char		(uart_char)
	);


	logic uart_driver_en;
	logic uart_driver_done;
	logic[7:0] uart_driver_data;
	uart_tx # (
		.CLK_FREQ	(FREQ),
		.UART_BPS	(UART_BPS)
	) my_uart_driver (
		.clk		(clk),
		.rst_n		(rst_n),

		.TX			(riscy_uart_rx),
		.uart_en	(uart_driver_en),
		.uart_din	(uart_driver_data),
		.tx_done	(uart_driver_done)
	);
	
	assign riscy_uart_cts = 1'b0;

	axil_dummy_master dummy_master_02 (s02_bus);
	axil_dummy_master dummy_master_03 (s03_bus);


	axil_dummy_slave dummy_slave_03 (m03_bus);
	axil_dummy_slave dummy_slave_04 (m04_bus);
	axil_dummy_slave dummy_slave_05 (m05_bus);

	axil_interconnect_4x6_wrapper # (
		.ADDR_WIDTH			(XLEN),

		.M00_BASE_ADDR		(32'h0),
		.M00_ADDR_WIDTH		(32'd26),

		.M01_BASE_ADDR		(SEG_BASE),
		.M01_ADDR_WIDTH		(32'd5),

		.M02_BASE_ADDR		(UART_BASE),
		.M02_ADDR_WIDTH		(32'd5),

		.M03_BASE_ADDR		(32'h8000_0000),
		.M03_ADDR_WIDTH		(32'd0),

		.M04_BASE_ADDR		(32'h8100_0000),
		.M04_ADDR_WIDTH		(32'd0),

		.M05_BASE_ADDR		(32'h8200_0000),
		.M05_ADDR_WIDTH		(32'd0)
	) interconnect_4x6 (
		.clk				(clk),
		.rst				(rst),

		.s00				(instr_bus),
		.s01				(data_bus),
		.s02				(s02_bus),
		.s03				(s03_bus),

		.m00				(ram_bus),
		.m01				(seg_bus),
		.m02				(uart_bus),
		.m03				(m03_bus),
		.m04				(m04_bus),
		.m05				(m05_bus)
	);
	

	ref_hier proc_ref (
		.clk				(clk),
		.rst				(rst),
		.kill				(kill_ref)
	);

	// UART initial input

	task uart_write_char(input logic[7:0] c);
		@(negedge clk);
		uart_driver_en		= ENABLE;
		uart_driver_data	= c;
		repeat(100) @(negedge clk);
		uart_driver_en		= DISABLE;
		@(posedge uart_driver_done);
		uart_driver_data	= 8'b0;
		@(negedge uart_driver_done);
		@(negedge clk);
	endtask

	initial begin
		uart_driver_en		= DISABLE;
		uart_driver_data	= 8'b0;
		@(posedge go);
		repeat(100) @(negedge clk);
		uart_write_char(8'h46);	// char 'F'
	end

	initial begin
		ref_halt = 1'b0;
		wait(ref_halt_wait);
		ref_halt = 1'b1;
	end
	
	always_comb begin
		ref_halt_wait = (data_t'(proc_ref.mem_i_inst_w) == ECALL);
		kill_ref = ref_halt;
	end

	// reg dut wire
	logic 	reg_wr_en_dut;
	r_t 	reg_wr_addr_dut;
	data_t	reg_wr_data_dut;
	always_comb begin : reg_dut_wire_assign
		reg_wr_en_dut	= processor.rd_wren_w;
		reg_wr_addr_dut	= processor.rd_addr;
		reg_wr_data_dut	= processor.wb_data;
	end

	// mem dut wire
	logic	mem_wr_en_dut, mem_rd_en_dut, mem_access_done_dut;
	data_t	mem_wr_data_in_dut, mem_rd_data_out_dut;
	data_t	mem_access_addr_dut;
	always_comb begin : mem_dut_wire_assign
		mem_wr_en_dut		= processor.memory_inst.wren;
		mem_rd_en_dut		= processor.memory_inst.rden;
		mem_access_done_dut	= processor.mem_access_done;
		mem_wr_data_in_dut	= (ENDIANESS == BIG_ENDIAN) ? processor.memory_inst.data_in_final :
								swap_endian(processor.memory_inst.data_in_final);
		mem_rd_data_out_dut	= (ENDIANESS == BIG_ENDIAN) ? processor.memory_inst.memory_system.m_axil_rdata : 
								swap_endian(processor.memory_inst.memory_system.m_axil_rdata);
		mem_access_addr_dut	= processor.memory_inst.addr & word_align_mask;
	end


	// reg ref wire
	logic 	reg_wr_en_ref;
	r_t 	reg_wr_addr_ref;
	data_t	reg_wr_data_ref;
	always_comb begin : reg_reg_wire_assign
		reg_wr_en_ref		= proc_ref.core_ref.rd_writeen_w;
		reg_wr_addr_ref		= r_t'(proc_ref.core_ref.rd_q);
		reg_wr_data_ref		= data_t'(proc_ref.core_ref.rd_val_w);
	end

	assign ebreak_start		= processor.instr_w.opcode == SYS;

	// mem ref wire
	logic	mem_wr_en_ref, mem_rd_en_ref, mem_access_ack_ref;
	data_t	mem_wr_data_in_ref, mem_rd_data_out_ref;
	data_t	mem_access_addr_ref;
	always_comb begin : mem_ref_wire_assign
		mem_wr_en_ref		= (proc_ref.mem_d_wr_w != 4'b0);	// byte enable all 0s
		mem_rd_en_ref		= proc_ref.mem_d_rd_w;
		mem_access_ack_ref	= proc_ref.mem_d_ack_w;
		mem_wr_data_in_ref	= proc_ref.mem_d_data_wr_w;
		mem_rd_data_out_ref	= proc_ref.mem_d_data_rd_w;
		mem_access_addr_ref	= proc_ref.mem_d_addr_w;	
	end

	typedef enum logic {
		READ, WRITE
	} rw_t;

	typedef struct packed {
		rw_t	rw;
		r_t		rw_addr;
		data_t	rw_data;
		integer	sim_time;
		data_t	pc;
		//instr_t	instr;
	} reg_access_t;

	typedef struct packed {
		rw_t	rw;
		data_t	rw_addr;
		data_t	rw_data;
		integer	sim_time;
		data_t	pc;
		//instr_t	instr;
	} mem_access_t;

	typedef struct packed {
		integer	sim_time;
		data_t	pc;
		//instr_t	instr;
	} pc_log_t;

	reg_access_t reg_access_log_ref[$] = {};
	reg_access_t reg_access_log_dut[$] = {};
	mem_access_t mem_access_log_ref[$] = {};
	mem_access_t mem_access_log_dut[$] = {};
	pc_log_t pc_log_ref[$] = {};
	pc_log_t pc_log_dut[$] = {};

	function void push_pc_ref();
		if (pc_log_ref.size() == 0) begin
			pc_log_ref.push_back(
				pc_log_t'(
					{	
						sim_time:	$time,
						pc:			proc_ref.core_ref.pc_q
					}
				)
			);
		end else if (pc_log_ref[pc_log_ref.size()-1].pc == (proc_ref.core_ref.pc_q)) begin 
			// do nothing, duplicative entry
		end else begin
			pc_log_ref.push_back(
				pc_log_t'(
					{	
						sim_time:	$time,
						pc:			proc_ref.core_ref.pc_q
					}
				)
			);
		end
	endfunction

	function void push_pc_dut();
		if (pc_log_dut.size() == 0) begin
			pc_log_dut.push_back(
				pc_log_t'(
					{
						sim_time:	$time,
						pc:			processor.pc_w
					}
				)
			);
		end else if (pc_log_dut[pc_log_dut.size()-1].pc == (processor.pc_w)) begin 
			// do nothing, duplicative entry
		end else begin
			pc_log_dut.push_back(
				pc_log_t'(
					{
						sim_time:	$time,
						pc:			processor.pc_w
					}
				)
			);
		end
	endfunction

	function void compare_pc_log();
		for (integer i = 0; i < ( (pc_log_ref.size() > pc_log_dut.size()) ? pc_log_dut.size() : pc_log_ref.size() ); i++ ) begin
			if (pc_log_ref[i].pc != pc_log_dut[i].pc) begin
				// $display("PC mismatch found at the #%d instr", i + 1);
				return;
			end
		end
		$display("Good: PC flow match");
	endfunction

	always_ff @(posedge clk) begin
		if (~$isunknown(proc_ref.core_ref.pc_q))
			push_pc_ref();
		if (processor.instr_valid_w)
			push_pc_dut();
	end

	function void push_reg_ref();
		if (reg_access_log_ref.size() == 0) begin
			reg_access_log_ref.push_back(
				reg_access_t'({
					rw:			WRITE,
					rw_addr:	reg_wr_addr_ref,
					rw_data:	reg_wr_data_ref,
					sim_time:	$time,
					pc:			(proc_ref.core_ref.pc_q - 32'd4)
					//instr:		instr_t'(proc_ref.core_ref.mem_i_inst_i)
				})
			
			);
			if (REG_DEBUG) begin
				$display(
					"debug: REF REG WRITE %h, to X%d at time=%t with pc=%h",
					reg_wr_data_ref, $unsigned(reg_wr_addr_ref), $time, proc_ref.core_ref.pc_q - 32'd4
				);
			end
		end else if ( reg_access_log_ref[reg_access_log_ref.size()-1].pc == (proc_ref.core_ref.pc_q - 32'd4)) begin 
			// do nothing, duplicative entry
		end else begin
			reg_access_log_ref.push_back(
				reg_access_t'({
					rw:			WRITE,
					rw_addr:	reg_wr_addr_ref,
					rw_data:	reg_wr_data_ref,
					sim_time:	$time,
					pc:			(proc_ref.core_ref.pc_q - 4)
					//instr:		instr_t'(proc_ref.core_ref.mem_i_inst_i)
				})
			);
			if (REG_DEBUG) begin
				$display(
					"debug: REF REG WRITE %h, to X%d at time=%t with pc=%h",
					reg_wr_data_ref, $unsigned(reg_wr_addr_ref), $time, proc_ref.core_ref.pc_q - 32'd4
				);
			end
		end
	endfunction


	function void push_reg_dut();
		if (reg_access_log_dut.size() == 0) begin
			reg_access_log_dut.push_back(
				reg_access_t'({
					rw:			WRITE,
					rw_addr:	reg_wr_addr_dut,
					rw_data:	reg_wr_data_dut,
					sim_time:	$time,
					pc:			(processor.pc_w)
				})
			);
			if (REG_DEBUG) begin
				$display(
					"debug: DUT REG WRITE %h, to X%d at time=%t with pc=%h",
					reg_wr_data_dut, $unsigned(reg_wr_addr_dut), $time, (processor.pc_w)
				);
			end
		end else if (reg_access_log_dut[reg_access_log_dut.size()-1].pc == (processor.pc_w)) begin 
			// do nothing, duplicative entry
		end else begin
			reg_access_log_dut.push_back(
				reg_access_t'({
					rw:			WRITE,
					rw_addr:	reg_wr_addr_dut,
					rw_data:	reg_wr_data_dut,
					sim_time:	$time,
					pc:			processor.pc_w
					//instr:		processor.instr_w
				})
			);
			if (REG_DEBUG) begin
				$display(
					"debug: DUT REG WRITE %h, to X%d at time=%t with pc=%h",
					reg_wr_data_dut, $unsigned(reg_wr_addr_dut), $time, (processor.pc_w)
				);
			end
		end
	endfunction


	task push_mem_ref_helper();
		mem_access_log_ref.push_back(
				mem_access_t'({
					rw:			mem_wr_en_ref ? WRITE : READ,
					rw_addr:	mem_access_addr_ref,
					rw_data:	mem_wr_en_ref ? mem_wr_data_in_ref : mem_rd_data_out_ref,
					sim_time:	$time,
					pc:			(proc_ref.core_ref.pc_q - 32'd4)
					//instr:		instr_t'(proc_ref.mem_i_inst_w)
				})
			);
			if (MEM_DEBUG) begin
				if (mem_wr_en_ref) begin
					$display(
						"debug: REF MEM WRITE %h, to   %h at time=%t with pc=%h",
						mem_wr_data_in_ref, mem_access_addr_ref, $time, proc_ref.core_ref.pc_q - 32'd4
					);
				end else begin // don't add " else if (mem_rd_en_ref)" here cuz rden is not aserted when ack is high
					$display(
						"debug: REF MEM READ  %h, from %h at time=%t with pc=%h",
						mem_rd_data_out_ref, mem_access_addr_ref, $time, proc_ref.core_ref.pc_q - 32'd4
					);
				end
			end
	endtask


	task push_mem_ref();
		if (mem_access_log_ref.size() == 0) begin
			if (mem_rd_en_ref) begin
				@(posedge mem_access_ack_ref);
				push_mem_ref_helper();
			end else begin
				push_mem_ref_helper();
			end
			
		end else if ( mem_access_log_ref[mem_access_log_ref.size()-1].pc == proc_ref.core_ref.pc_q - 32'd4) begin
			// do nothing, duplicative entry
		end else begin
			if (mem_rd_en_ref) begin
				@(posedge mem_access_ack_ref);
				push_mem_ref_helper();
			end else begin
				push_mem_ref_helper();
			end
		end
	endtask


	function void push_mem_dut();
		if (mem_access_log_dut.size() == 0) begin
			mem_access_log_dut.push_back(
				mem_access_t'({
					rw:			mem_wr_en_dut ? WRITE : READ,
					rw_addr:	mem_access_addr_dut,
					rw_data:	mem_wr_en_dut ? mem_wr_data_in_dut : mem_rd_data_out_dut,
					sim_time:	$time,
					pc:			processor.pc_m
					//instr:		instr_t'(processor.instr_m)
				})
			);
			if (MEM_DEBUG) begin
				if (mem_wr_en_dut) begin
					$display(
						"debug: DUT MEM WRITE %h, to   %h at time=%t with pc=%h",
						mem_wr_data_in_dut, mem_access_addr_dut, $time, (processor.pc_m)
					);
				end else begin
					$display(
						"debug: DUT MEM READ  %h, from %h at time=%t with pc=%h",
						mem_rd_data_out_dut, mem_access_addr_dut, $time, (processor.pc_m)
					);
				end
			end
		end else if ( mem_access_log_dut[mem_access_log_dut.size()-1].pc == (processor.pc_m)) begin 
			// do nothing, duplicative entry
		end else begin
			mem_access_log_dut.push_back(
				mem_access_t'({
					rw:			mem_wr_en_dut ? WRITE : READ,
					rw_addr:	mem_access_addr_dut,
					rw_data:	mem_wr_en_dut ? mem_wr_data_in_dut : mem_rd_data_out_dut,
					sim_time:	$time,
					pc:			processor.pc_m
					//instr:		instr_t'(processor.instr_m)
				})
			);
			if (MEM_DEBUG) begin
				if (mem_wr_en_dut) begin
					$display(
						"debug: DUT MEM WRITE %h, to   %h at time=%t with pc=%h",
						mem_wr_data_in_dut, mem_access_addr_dut, $time, (processor.pc_m)
					);
				end else begin
					$display(
						"debug: DUT MEM READ  %h, from %h at time=%t with pc=%h",
						mem_rd_data_out_dut, mem_access_addr_dut, $time, (processor.pc_m)
					);
				end
			end
		end
	endfunction


	always @(negedge clk) begin : ref_debug_log
		// reg log
		if (reg_wr_en_ref && reg_wr_addr_ref != X0) begin
			push_reg_ref();
		end

		// mem log
		// cant use done for ref cuz it use ack handshake instead of done
		if (mem_wr_en_ref || mem_rd_en_ref) begin
			push_mem_ref();
		end 
	end


	always @(negedge clk) begin : dut_debug_log
		// reg log
		if (reg_wr_en_dut && reg_wr_addr_dut != X0) begin
			push_reg_dut();
		end

		// mem log
		if ((mem_wr_en_dut || mem_rd_en_dut) && mem_access_done_dut) begin
			push_mem_dut();
		end 
	end


	task compare_reg_log();
		assert	(reg_access_log_ref[0].rw == reg_access_log_dut[0].rw) 
		else begin
			error = 1;
		end

		assert	(reg_access_log_ref[0].rw_addr == reg_access_log_dut[0].rw_addr) 
		else begin
			error = 1;
		end

		assert	(reg_access_log_ref[0].rw_data == reg_access_log_dut[0].rw_data) 
		else begin
			error = 1;
		end

		reg_access_log_ref.pop_front();
		reg_access_log_dut.pop_front();
	endtask


	task compare_mem_log();
		assert	(mem_access_log_ref[0].rw == mem_access_log_dut[0].rw) 
		else begin
			error = 1;
		end

		assert	(mem_access_log_ref[0].rw_addr == mem_access_log_dut[0].rw_addr) 
		else begin
			error = 1;
		end

		assert	(mem_access_log_ref[0].rw_data == mem_access_log_dut[0].rw_data) 
		else begin
			error = 1;
		end

		//$display("poped mem log at pc=%d", mem_access_log_ref[0].pc);
		mem_access_log_ref.pop_front();
		mem_access_log_dut.pop_front();
	endtask

	task write_csv ();
		integer wli, f;	// write log index, file number
		$display("sim finished, writing csv log file...");

		f = $fopen("reg_ref.csv","w");
		$fwrite(f, "\"field\", \"time\", \"pc\", \"rw\", \"data\", \"addr\" \n");
		for (wli = 0; wli < reg_access_log_ref.size(); wli++) begin
			$fwrite(f, "\"%s\", \"%t\", \"0x%h\", \"%s\", \"0x%h\", \"%d\" \n",
			"reg",
			reg_access_log_ref[wli].sim_time / 1000,
			reg_access_log_ref[wli].pc,
			reg_access_log_ref[wli].rw == READ ? "read" : "write",
			reg_access_log_ref[wli].rw_data,
			reg_access_log_ref[wli].rw_addr);
		end
		$fclose(f);

		f = $fopen("reg_dut.csv","w");
		$fwrite(f, "\"field\", \"time\", \"pc\", \"rw\", \"data\", \"addr\" \n");
		for (wli = 0; wli < reg_access_log_dut.size(); wli++) begin
			$fwrite(f, "\"%s\", \"%t\", \"0x%h\", \"%s\", \"0x%h\", \"%d\" \n",
			"reg",
			reg_access_log_dut[wli].sim_time / 1000,
			reg_access_log_dut[wli].pc,
			reg_access_log_dut[wli].rw == READ ? "read" : "write",
			reg_access_log_dut[wli].rw_data,
			reg_access_log_dut[wli].rw_addr);
		end
		$fclose(f);

		f = $fopen("mem_ref.csv","w");
		$fwrite(f, "\"field\", \"time\", \"pc\", \"rw\", \"data\", \"addr\" \n");
		for (wli = 0; wli < mem_access_log_ref.size(); wli++) begin
			$fwrite(f, "\"%s\", \"%t\", \"0x%h\", \"%s\", \"0x%h\", \"0x%h\" \n",
			"mem",
			mem_access_log_ref[wli].sim_time / 1000,
			mem_access_log_ref[wli].pc,
			mem_access_log_ref[wli].rw == READ ? "read" : "write",
			mem_access_log_ref[wli].rw_data,
			mem_access_log_ref[wli].rw_addr);
		end
		$fclose(f);

		f = $fopen("mem_dut.csv","w");
		$fwrite(f, "\"field\", \"time\", \"pc\", \"rw\", \"data\", \"addr\" \n");
		for (wli = 0; wli < mem_access_log_dut.size(); wli++) begin
			$fwrite(f, "\"%s\", \"%t\", \"0x%h\", \"%s\", \"0x%h\", \"0x%h\" \n",
			"mem",
			mem_access_log_dut[wli].sim_time / 1000,
			mem_access_log_dut[wli].pc,
			mem_access_log_dut[wli].rw == READ ? "read" : "write",
			mem_access_log_dut[wli].rw_data,
			mem_access_log_dut[wli].rw_addr);
		end
		$fclose(f);

		f = $fopen("pc_ref.csv","w");
		$fwrite(f, "\"field\", \"time\", \"pc\" \n");
		for (wli = 0; wli < pc_log_ref.size(); wli++) begin
			$fwrite(f, "\"%s\", \"%t\", \"%h\" \n",
			"pc",
			pc_log_ref[wli].sim_time / 1000,
			pc_log_ref[wli].pc);
		end
		$fclose(f);

		f = $fopen("pc_dut.csv","w");
		$fwrite(f, "\"field\", \"time\", \"pc\" \n");
		for (wli = 0; wli < pc_log_dut.size(); wli++) begin
			$fwrite(f, "\"%s\", \"%t\", \"%h\" \n",
			"pc",
			pc_log_dut[wli].sim_time / 1000,
			pc_log_dut[wli].pc);		
		end
		$fclose(f);
	endtask

	task write_log();
		integer wli, f;	// write log index, file number
		$display("sim finished, writing log file...");
		f = $fopen("reg_ref.log","w");
		for (wli = 0; wli < reg_access_log_ref.size(); wli++) begin
			if (reg_access_log_ref[wli].rw == READ) begin
					$fwrite(f, "sim time = %t, pc = %h, READ %h from X%d \n",
					reg_access_log_ref[wli].sim_time,
					reg_access_log_ref[wli].pc,
					reg_access_log_ref[wli].rw_data,
					reg_access_log_ref[wli].rw_addr);
			end else begin
					$fwrite(f, "sim time = %t, pc = %h, WRITE %h to X%d \n",
					reg_access_log_ref[wli].sim_time,
					reg_access_log_ref[wli].pc,
					reg_access_log_ref[wli].rw_data,
					reg_access_log_ref[wli].rw_addr);
			end
		end
		$fclose(f);

		f = $fopen("reg_dut.log","w");
		for (wli = 0; wli < reg_access_log_dut.size(); wli++) begin
			if (reg_access_log_dut[wli].rw == READ) begin
					$fwrite(f, "sim time = %t, pc = %h, READ %h from X%d \n",
					reg_access_log_dut[wli].sim_time,
					reg_access_log_dut[wli].pc,
					reg_access_log_dut[wli].rw_data,
					reg_access_log_dut[wli].rw_addr);
			end else begin
					$fwrite(f, "sim time = %t, pc = %h, WRITE %h to X%d \n",
					reg_access_log_dut[wli].sim_time,
					reg_access_log_dut[wli].pc,
					reg_access_log_dut[wli].rw_data,
					reg_access_log_dut[wli].rw_addr);
			end
		end
		$fclose(f);

		f = $fopen("mem_ref.log","w");
		for (wli = 0; wli < mem_access_log_ref.size(); wli++) begin
			if (mem_access_log_ref[wli].rw == READ) begin
					$fwrite(f, "sim time = %t, pc = %h, READ %h from mem[%h] \n",
					mem_access_log_ref[wli].sim_time,
					mem_access_log_ref[wli].pc,
					mem_access_log_ref[wli].rw_data,
					mem_access_log_ref[wli].rw_addr);
			end else begin
					$fwrite(f, "sim time = %t, pc = %h, WRITE %h to mem[%h] \n",
					mem_access_log_ref[wli].sim_time,
					mem_access_log_ref[wli].pc,
					mem_access_log_ref[wli].rw_data,
					mem_access_log_ref[wli].rw_addr);
			end
		end
		$fclose(f);

		f = $fopen("mem_dut.log","w");
		for (wli = 0; wli < mem_access_log_dut.size(); wli++) begin
			if (mem_access_log_dut[wli].rw == READ) begin
					$fwrite(f, "sim time = %t, pc = %h, READ %h from mem[%h] \n",
					mem_access_log_dut[wli].sim_time,
					mem_access_log_dut[wli].pc,
					mem_access_log_dut[wli].rw_data,
					mem_access_log_dut[wli].rw_addr);
			end else begin
					$fwrite(f, "sim time = %t, pc = %h, WRITE %h to mem[%h] \n",
					mem_access_log_dut[wli].sim_time,
					mem_access_log_dut[wli].pc,
					mem_access_log_dut[wli].rw_data,
					mem_access_log_dut[wli].rw_addr);
			end
		end
		$fclose(f);

		f = $fopen("pc_ref.log","w");
		for (wli = 0; wli < pc_log_ref.size(); wli++) begin
			$fwrite(f, "%h - %d @ t = %t\n", pc_log_ref[wli].pc, pc_log_ref[wli].pc, pc_log_ref[wli].sim_time);
		end
		$fclose(f);

		f = $fopen("pc_dut.log","w");
		for (wli = 0; wli < pc_log_dut.size(); wli++) begin
			$fwrite(f, "%h - %d @ t = %t\n", pc_log_dut[wli].pc, pc_log_dut[wli].pc, pc_log_dut[wli].sim_time);
		end
		$fclose(f);
	endtask


	initial begin
		fork
			begin
				wait(processor.sdram_init_done);
				$display("sdram init done");
			end

			begin
				@(posedge ref_halt);
				$display("ref module finished program");
			end

			begin
				wait(ebreak_start);
				$display("dut module finished program");
			end
		join	
	end


	initial begin
		integer time_reg, time_mem;
		integer iter;
		iter = 0;
		error = 0;

		fork
			// wait both REF and DUT finish
			begin
				wait(ref_halt && ebreak_start);
				repeat(10) @(posedge clk);
			end

			// wait for timeout
			begin
				repeat(TB_TIMEOUT) @(posedge clk);
				$display("TB timeout, stop logging");
				// $stop();
			end
		join_any
		disable fork;	// disable the fork wither both core finish running or timeout
		
		#100;

		$display("reg access count: ref: %d, dut: %d", reg_access_log_ref.size(), reg_access_log_dut.size());
		$display("mem access count: ref: %d, dut: %d", mem_access_log_ref.size(), mem_access_log_dut.size());
		
		// write log into log file
		write_csv();
		write_log();

		while (
			(reg_access_log_ref.size() > 0) ||
			(mem_access_log_ref.size() > 0)
		) begin
			
			if (reg_access_log_ref.size() == 0 && mem_access_log_ref.size() > 0) begin
				compare_mem_log();
			end else if (mem_access_log_ref.size() == 0 && reg_access_log_ref.size() > 0) begin
				compare_reg_log();
			end else if (reg_access_log_ref.size() == 0 && mem_access_log_ref.size() == 0) begin
				$display("test should be stopping soon...");
			end else if (reg_access_log_ref[0].sim_time <= mem_access_log_ref[0].sim_time)begin
				compare_reg_log();
			end else begin
				compare_mem_log();
			end

			iter++;
			if (iter > 100000) begin
				$display("log access overflow, stopping");
				$stop();
			end
		end
		
		fd = $fopen("./result.txt", "w");
		if (!fd) begin
			$display("file open failed");
			$stop();
		end

		compare_pc_log();

		if (error)begin
			$display("log mismatch, test failed");
			$display("run analysis_log.py to see details");
			$fwrite(fd, "fail");
		end

		else begin
			$display("all log match, test passed");
			$fwrite(fd, "success");
		end

		if (proc_ref.core_ref.reg_file[10] == 42) begin
			$display("golden module passed the test");
			if (processor.decode_inst.registers_inst.reg_bypass_inst.registers[10] == 42) begin
				$display("DUT dilivered correct answer, test passed?");
			end else begin
				$display("DUT failed the test");
			end
		end else begin
			$display("golden module failed the test! bad test?");
			if (processor.decode_inst.registers_inst.reg_bypass_inst.registers[10] == 42) begin
				$display("WTF this should not happed");
			end
		end

		$fclose(fd);
		$stop();
	end

endmodule : reference_test_axi


module clkrst #(
	FREQ = FREQ
) (
	output logic clk,
	output logic rst_n,
	output logic go
);

	localparam period = 1e9/FREQ;	// in ns
	localparam half_period = period/2;

	initial begin
		clk		= 1'b0;
		rst_n	= 1'b0;
		go		= 1'b0;
		repeat(5) @(negedge clk);
		#100;
		rst_n	= 1'b1;
		repeat(233) @(negedge clk);
		go		= 1'b1;
		@(negedge clk);
		go		= 1'b0;
	end

	always #half_period begin
      clk = ~clk;
    end
	
endmodule : clkrst
