// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

import defines::*;

module reference_test_single ();
	localparam REG_DEBUG = DISABLE;
	localparam MEM_DEBUG = DISABLE;
	
	int error = 0;
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
	logic ref_halt;
	ref_hier proc_ref (
		.clk				(pll_clk && ~ref_halt),
		.rst				(lock_rst)
	);
	assign pll_clk = proc_dut.clk;
	assign lock_rst = ~proc_dut.rst_n;
	assign ref_halt = (data_t'(proc_ref.mem_i_inst_w) == ECALL);

	// reg dut wire
	logic 	reg_wr_en_dut;
	r_t 	reg_wr_addr_dut;
	data_t	reg_wr_data_dut;
	assign 	reg_wr_en_dut	= proc_dut.processor_inst.rd_wren_w;
	assign 	reg_wr_addr_dut	= proc_dut.processor_inst.rd_addr;
	assign 	reg_wr_data_dut	= proc_dut.processor_inst.wb_data;

	// mem dut wire
	logic	mem_wr_en_dut, mem_rd_en_dut, mem_access_done_dut;
	data_t	mem_wr_data_in_dut, mem_rd_data_out_dut;
	data_t	mem_access_addr_dut;
	assign	mem_wr_en_dut		= proc_dut.processor_inst.memory_inst.wren;
	assign	mem_rd_en_dut		= proc_dut.processor_inst.memory_inst.rden;
	assign	mem_access_done_dut	= proc_dut.processor_inst.mem_access_done;
	assign	mem_wr_data_in_dut	= (ENDIANESS == BIG_ENDIAN) ? proc_dut.processor_inst.memory_inst.data_in_final :
								swap_endian(proc_dut.processor_inst.memory_inst.data_in_final);
	assign	mem_rd_data_out_dut	= proc_dut.processor_inst.mem_data_m;
	assign	mem_access_addr_dut	= proc_dut.processor_inst.memory_inst.addr;

	// reg ref wire
	logic 	reg_wr_en_ref;
	r_t 	reg_wr_addr_ref;
	data_t	reg_wr_data_ref;
	assign	reg_wr_en_ref		= proc_ref.core_ref.rd_writeen_w;
	assign	reg_wr_addr_ref		= r_t'(proc_ref.core_ref.rd_q);
	assign	reg_wr_data_ref		= data_t'(proc_ref.core_ref.rd_val_w);

	// mem ref wire
	logic	mem_wr_en_ref, mem_rd_en_ref, mem_access_ack_ref;
	data_t	mem_wr_data_in_ref, mem_rd_data_out_ref;
	data_t	mem_access_addr_ref;
	assign	mem_wr_en_ref		= (proc_ref.mem_d_wr_w != 4'b0);	// byte enable all 0s
	assign	mem_rd_en_ref		= proc_ref.mem_d_rd_w;
	assign	mem_access_ack_ref	= proc_ref.mem_d_ack_w;
	assign	mem_wr_data_in_ref	= proc_ref.mem_d_data_wr_w;
	assign	mem_rd_data_out_ref	= proc_ref.mem_d_data_rd_w;
	assign	mem_access_addr_ref	= proc_ref.mem_d_addr_w;

	typedef enum logic {
		READ, WRITE
	} rw_t;

	typedef struct packed {
		rw_t	rw;
		r_t		rw_addr;
		data_t	rw_data;
		integer	sim_time;
		data_t	pc;
		instr_t	instr;
	} reg_access_t;

	typedef struct packed {
		rw_t	rw;
		data_t	rw_addr;
		data_t	rw_data;
		integer	sim_time;
		data_t	pc;
		instr_t	instr;
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
					pc:			(proc_ref.core_ref.pc_q - 32'd4),
					instr:		instr_t'(proc_ref.core_ref.mem_i_inst_i)
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
					pc:			(proc_ref.core_ref.pc_q - 4),
					instr:		instr_t'(proc_ref.core_ref.mem_i_inst_i)
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
					pc:			(proc_dut.processor_inst.pcp4_w - 32'd4),
					instr:		proc_dut.processor_inst.instr_w
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
					pc:			proc_dut.processor_inst.pcp4_w - 32'd4,
					instr:		proc_dut.processor_inst.instr_w
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
					pc:			(proc_ref.core_ref.pc_q - 32'd4),
					instr:		instr_t'(proc_ref.mem_i_inst_w)
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
					pc:			proc_dut.processor_inst.pcp4_m - 4,
					instr:		instr_t'(proc_dut.processor_inst.instr_m)
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
					pc:			proc_dut.processor_inst.pcp4_m - 4,
					instr:		instr_t'(proc_dut.processor_inst.instr_m)
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

	initial begin
		@(posedge ebreak_start);
		// TODO:
		error = 0;

		$display("reg access count: ref: %d, dut: %d", reg_access_log_ref.size(), reg_access_log_dut.size());
		$display("mem access count: ref: %d, dut: %d", mem_access_log_ref.size(), mem_access_log_dut.size());
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

	initial begin
		wait(proc_dut.processor_inst.sdram_init_done);
		$display("sdram init done");
		@(negedge proc_dut.clk);
		$stop();
		repeat(15000) @(negedge clk);
		$display("timeout");
		$stop();
	end

	always #half_period begin
      clk = ~clk;
    end
	
endmodule : clkrst
