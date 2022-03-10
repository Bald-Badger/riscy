// synopsys translate_off
`timescale 1 ns / 1 ps
// synopsys translate_on

import defines::*;

module axil_test ();
	
	int error = 0;
	int fd;

	logic clk, rst_n, ebreak_start;

	clkrst #(.FREQ(FREQ)) clkrst_inst (
		.clk	(clk),
		.rst_n	(rst_n)
	);

	axi_lite_interface data_bus (
		.clk	(clk),
		.rst	(~rst_n)
	);

	axi_lite_interface instr_bus (
		.clk	(clk),
		.rst	(~rst_n)
	);

	proc_hier proc_dut (
		.osc_clk		(clk),
		.but_rst_n		(rst_n),
		.ebreak_start	(ebreak_start),
		.data_bus		(data_bus),
		.instr_bus		(instr_bus)
	);


	initial begin
		@(posedge ebreak_start);
		assert (proc_dut.processor_inst.decode_inst.registers_inst.reg_bypass_inst.registers[10] == 42)
				else error = 1;
		assert (proc_dut.processor_inst.decode_inst.registers_inst.reg_bypass_inst.registers[17] == 93)
				else error = 1;
		
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

	// reg debug wire
	logic 	reg_wr_en_dut;
	r_t 	reg_wr_addr_dut;
	data_t	reg_wr_data_dut;
	assign 	reg_wr_en_dut	= proc_dut.processor_inst.rd_wren_w && 
							  !proc_dut.processor_inst.stall_id_ex;
	assign 	reg_wr_addr_dut	= proc_dut.processor_inst.rd_addr;
	assign 	reg_wr_data_dut	= proc_dut.processor_inst.wb_data;

	// mem debug wire
	logic mem_wr_en_dut, mem_rd_en_dut, mem_access_done_dut;
	data_t mem_wr_data_in_dut, mem_rd_data_out_dut;
	data_t mem_access_addr_dut;
	assign mem_wr_en_dut = proc_dut.processor_inst.memory_inst.wren;
	assign mem_rd_en_dut = proc_dut.processor_inst.memory_inst.rden;
	assign mem_access_done_dut = proc_dut.processor_inst.mem_access_done;
	assign mem_wr_data_in_dut = (ENDIANESS == BIG_ENDIAN) ? proc_dut.processor_inst.memory_inst.data_in_final :
								swap_endian(proc_dut.processor_inst.memory_inst.data_in_final);
	assign mem_rd_data_out_dut = (ENDIANESS == BIG_ENDIAN) ? proc_dut.processor_inst.mem_data_m :
								swap_endian(proc_dut.processor_inst.mem_data_m);
	assign mem_access_addr_dut = proc_dut.processor_inst.memory_inst.addr;

	always_ff @(negedge proc_dut.processor_inst.clk) begin : dut_debug_log
		if (TOP_DEBUG == ENABLE) begin
			// reg access debug
			if (reg_wr_en_dut && reg_wr_addr_dut != X0) begin
				$display("Write reg: %d, value: %h", reg_wr_addr_dut, reg_wr_data_dut);
			end

			// mem access debug
			if (mem_wr_en_dut && mem_access_done_dut) begin
				$display("Write mem: %d, value: %H", mem_access_addr_dut, mem_wr_data_in_dut);
			end else if (mem_rd_en_dut && mem_access_done_dut) begin
				$display("Read mem: %H, value: %H", mem_access_addr_dut, mem_rd_data_out_dut);
			end
		end
	end

endmodule : smoke_test_single


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
		repeat(15000) @(negedge clk);
		$display("timeout");
		$stop();
	end

	always #half_period begin
      clk = ~clk;
    end
	
endmodule : axil_test
