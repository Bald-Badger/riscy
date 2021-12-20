// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

module reference_test_single ();
	localparam REG_DEBUG = ENABLE;
	localparam MEM_DEBUG = ENABLE;
	
	integer error;
	int fd;

	logic clk, rst_n, ebreak_start;

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

	clkrst #(.FREQ(FREQ)) clkrst_inst(
		.clk	(clk),
		.rst_n	(rst_n)
	);


	proc_hier proc_dut (
		.osc_clk		(clk),
		.but_rst_n		(rst_n),
		.ebreak_start	(ebreak_start),

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

	logic pll_clk, lock_rst;
	logic ref_halt, ref_halt_wait;
	logic kill_ref;
	initial begin
		ref_halt = 1'b0;
		wait(ref_halt_wait);
		ref_halt = 1'b1;
	end
	ref_hier proc_ref (
		.clk				(pll_clk),
		.rst				(lock_rst),
		.kill				(kill_ref)
	);
	always_comb begin
		pll_clk = proc_dut.clk;
		lock_rst = ~proc_dut.rst_n || ~proc_dut.locked;
		ref_halt_wait = (data_t'(proc_ref.mem_i_inst_w) == ECALL);
		kill_ref = ref_halt;
	end

	// reg dut wire
	logic 	reg_wr_en_dut;
	r_t 	reg_wr_addr_dut;
	data_t	reg_wr_data_dut;
	always_comb begin : reg_dut_wire_assign
		reg_wr_en_dut	= proc_dut.processor_inst.rd_wren_w;
		reg_wr_addr_dut	= proc_dut.processor_inst.rd_addr;
		reg_wr_data_dut	= proc_dut.processor_inst.wb_data;
	end

	// mem dut wire
	logic	mem_wr_en_dut, mem_rd_en_dut, mem_access_done_dut;
	data_t	mem_wr_data_in_dut, mem_rd_data_out_dut;
	data_t	mem_access_addr_dut;
	always_comb begin : mem_dut_wire_assign
		mem_wr_en_dut		= proc_dut.processor_inst.memory_inst.wren;
		mem_rd_en_dut		= proc_dut.processor_inst.memory_inst.rden;
		mem_access_done_dut	= proc_dut.processor_inst.mem_access_done;
		mem_wr_data_in_dut	= (ENDIANESS == BIG_ENDIAN) ? proc_dut.processor_inst.memory_inst.data_in_final :
								swap_endian(proc_dut.processor_inst.memory_inst.data_in_final);
		mem_rd_data_out_dut	= proc_dut.processor_inst.mem_data_out_m;
		mem_access_addr_dut	= proc_dut.processor_inst.memory_inst.addr;
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

	reg_access_t reg_access_log_ref[$] = {};
	reg_access_t reg_access_log_dut[$] = {};
	mem_access_t mem_access_log_ref[$] = {};
	mem_access_t mem_access_log_dut[$] = {};

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
		end else if ( reg_access_log_ref[reg_access_log_ref.size()-1].pc == (proc_ref.core_ref.pc_q - 32'd4)
			/*
			reg_access_log_ref[reg_access_log_ref.size()-1].rw == WRITE &&
			reg_access_log_ref[reg_access_log_ref.size()-1].rw_addr == reg_wr_addr_ref &&
			reg_access_log_ref[reg_access_log_ref.size()-1].rw_data == reg_wr_data_ref
			*/
		) begin 
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
					pc:			(proc_dut.processor_inst.pcp4_w - 32'd4)
					//instr:		proc_dut.processor_inst.instr_w
				})
			);
			if (REG_DEBUG) begin
				$display(
					"debug: DUT REG WRITE %h, to X%d at time=%t with pc=%h",
					reg_wr_data_dut, $unsigned(reg_wr_addr_dut), $time, (proc_dut.processor_inst.pcp4_w - 32'd4)
				);
			end
		end else if (reg_access_log_dut[reg_access_log_dut.size()-1].pc == (proc_dut.processor_inst.pcp4_w - 32'd4)
			/*
			reg_access_log_dut[reg_access_log_dut.size()-1].rw == WRITE &&
			reg_access_log_dut[reg_access_log_dut.size()-1].rw_addr == reg_wr_addr_dut &&
			reg_access_log_dut[reg_access_log_dut.size()-1].rw_data == reg_wr_data_dut
			*/
		) begin 
			// do nothing, duplicative entry
		end else begin
			reg_access_log_dut.push_back(
				reg_access_t'({
					rw:			WRITE,
					rw_addr:	reg_wr_addr_dut,
					rw_data:	reg_wr_data_dut,
					sim_time:	$time,
					pc:			proc_dut.processor_inst.pcp4_w - 32'd4
					//instr:		proc_dut.processor_inst.instr_w
				})
			);
			if (REG_DEBUG) begin
				$display(
					"debug: DUT REG WRITE %h, to X%d at time=%t with pc=%h",
					reg_wr_data_dut, $unsigned(reg_wr_addr_dut), $time, (proc_dut.processor_inst.pcp4_w - 32'd4)
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
			
		end else if ( mem_access_log_ref[mem_access_log_ref.size()-1].pc == proc_ref.core_ref.pc_q - 32'd4
		/*
			(	
				mem_wr_en_ref &&
				mem_access_log_ref[mem_access_log_ref.size()-1].rw		== WRITE &&
				mem_access_log_ref[mem_access_log_ref.size()-1].rw_addr	== mem_access_addr_ref &&
				mem_access_log_ref[mem_access_log_ref.size()-1].rw_data	== mem_wr_data_in_ref
			)	||
			(
				mem_rd_en_ref &&
				mem_access_log_ref[mem_access_log_ref.size()-1].rw		== READ &&
				mem_access_log_ref[mem_access_log_ref.size()-1].rw_addr	== mem_access_addr_ref &&
				mem_access_log_ref[mem_access_log_ref.size()-1].rw_data	== mem_rd_data_out_ref
			)
		*/
		) begin
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
					pc:			proc_dut.processor_inst.pcp4_m - 4
					//instr:		instr_t'(proc_dut.processor_inst.instr_m)
				})
			);
			if (MEM_DEBUG) begin
				if (mem_wr_en_dut) begin
					$display(
						"debug: DUT MEM WRITE %h, to   %h at time=%t with pc=%h",
						mem_wr_data_in_dut, mem_access_addr_dut, $time, (proc_dut.processor_inst.pcp4_m - 4)
					);
				end else begin
					$display(
						"debug: DUT MEM READ  %h, from %h at time=%t with pc=%h",
						mem_rd_data_out_dut, mem_access_addr_dut, $time, (proc_dut.processor_inst.pcp4_m - 4)
					);
				end
			end
		end else if ( mem_access_log_dut[mem_access_log_dut.size()-1].pc == (proc_dut.processor_inst.pcp4_m - 4)
		/*
			(
				mem_wr_en_dut &&
				mem_access_log_dut[mem_access_log_dut.size()-1].rw		== WRITE &&
				mem_access_log_dut[mem_access_log_dut.size()-1].rw_addr	== mem_access_addr_dut &&
				mem_access_log_dut[mem_access_log_dut.size()-1].rw_data	== mem_wr_data_in_dut
			) ||
			(
				mem_rd_en_dut &&
				mem_access_log_dut[mem_access_log_dut.size()-1].rw		== READ &&
				mem_access_log_dut[mem_access_log_dut.size()-1].rw_addr	== mem_access_addr_dut &&
				mem_access_log_dut[mem_access_log_dut.size()-1].rw_data	== mem_rd_data_out_dut
			)
		*/
		) begin 
			// $display("duplicate mem entry, last log: %h, new log: %h", mem_access_log_dut[mem_access_log_dut.size()-1].pc, (proc_dut.processor_inst.pcp4_m - 4));
			// do nothing, duplicative entry
		end else begin
			mem_access_log_dut.push_back(
				mem_access_t'({
					rw:			mem_wr_en_dut ? WRITE : READ,
					rw_addr:	mem_access_addr_dut,
					rw_data:	mem_wr_en_dut ? mem_wr_data_in_dut : mem_rd_data_out_dut,
					sim_time:	$time,
					pc:			proc_dut.processor_inst.pcp4_m - 4
					//instr:		instr_t'(proc_dut.processor_inst.instr_m)
				})
			);
			if (MEM_DEBUG) begin
				if (mem_wr_en_dut) begin
					$display(
						"debug: DUT MEM WRITE %h, to   %h at time=%t with pc=%h",
						mem_wr_data_in_dut, mem_access_addr_dut, $time, (proc_dut.processor_inst.pcp4_m - 4)
					);
				end else begin
					$display(
						"debug: DUT MEM READ  %h, from %h at time=%t with pc=%h",
						mem_rd_data_out_dut, mem_access_addr_dut, $time, (proc_dut.processor_inst.pcp4_m - 4)
					);
				end
			end
		end
	endfunction

	always @(negedge pll_clk) begin : ref_debug_log
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

	always @(negedge pll_clk) begin : dut_debug_log
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
			$error("REG RW mismatch at dut time = %t, ref pc = %h, expecting rw mode is %b, dut rw mode is %b", 
			reg_access_log_ref[0].sim_time, reg_access_log_ref[0].pc, reg_access_log_ref[0].rw, reg_access_log_dut[0].rw);
		end

		assert	(reg_access_log_ref[0].rw_addr == reg_access_log_dut[0].rw_addr) 
		else begin
			error = 1;
			$error("REG RW_ADDR mismatch at dut time = %t, ref pc = %h, expecting addr is %d, dut addr is %d", 
			reg_access_log_ref[0].sim_time, reg_access_log_ref[0].pc, reg_access_log_ref[0].rw_addr, reg_access_log_dut[0].rw_addr);
		end

		assert	(reg_access_log_ref[0].rw_data == reg_access_log_dut[0].rw_data) 
		else begin
			error = 1;
			$error("REG RW_DATA mismatch at dut time = %t, ref pc = %h, expecting data is %h, dut data is %h", 
			reg_access_log_ref[0].sim_time, reg_access_log_ref[0].pc, reg_access_log_ref[0].rw_data, reg_access_log_dut[0].rw_data);
		end

		//$display("poped reg log at pc=%d", reg_access_log_ref[0].pc);
		reg_access_log_ref.pop_front();
		reg_access_log_dut.pop_front();
	endtask

	task compare_mem_log();
		assert	(mem_access_log_ref[0].rw == mem_access_log_dut[0].rw) 
		else begin
			error = 1;
			$error("MEM RW mismatch at dut time = %t, ref pc = %h, expecting rw mode is %b, dut rw mode is %b", 
			mem_access_log_ref[0].sim_time, mem_access_log_ref[0].pc, mem_access_log_ref[0].rw, mem_access_log_dut[0].rw);
		end

		assert	(mem_access_log_ref[0].rw_addr == mem_access_log_dut[0].rw_addr) 
		else begin
			error = 1;
			$error("MEM RW_ADDR mismatch at dut time = %t, ref pc = %h, expecting addr is %h, dut addr is %h", 
			mem_access_log_ref[0].sim_time, mem_access_log_ref[0].pc, mem_access_log_ref[0].rw_addr, mem_access_log_dut[0].rw_addr);
		end

		assert	(mem_access_log_ref[0].rw_data == mem_access_log_dut[0].rw_data) 
		else begin
			error = 1;
			$error("MEM RW_DATA mismatch at dut time = %t, ref pc = %h, expecting addr is %h, dut addr is %h", 
			mem_access_log_ref[0].sim_time, mem_access_log_ref[0].pc, mem_access_log_ref[0].rw_data, mem_access_log_dut[0].rw_data);
		end

		//$display("poped mem log at pc=%d", mem_access_log_ref[0].pc);
		mem_access_log_ref.pop_front();
		mem_access_log_dut.pop_front();
	endtask


	initial begin
		fork
			begin
				wait(proc_dut.processor_inst.sdram_init_done);
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
				$display("TB timeout!");
				$stop();
			end
		join_any
		disable fork;	// disable the fork wither both core finish running or timeout
		

		$display("reg access count: ref: %d, dut: %d", reg_access_log_ref.size(), reg_access_log_dut.size());
		$display("mem access count: ref: %d, dut: %d", mem_access_log_ref.size(), mem_access_log_dut.size());
		
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

			if (error) begin
				$display("test failed, stopping...");
				$stop();
			end

			iter++;
			if (iter > 1000000) begin
				$display("log access overflow, stopping");
				$stop();
			end
		end
		
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

endmodule : reference_test_single


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
		rst_n = 1'b0;
		repeat(5) @(negedge clk);
		#100;
		rst_n = 1'b1;
	end

	always #half_period begin
      clk = ~clk;
    end
	
endmodule : clkrst
