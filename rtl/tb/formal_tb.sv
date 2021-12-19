`timescale 1 ps / 1 ps

import defines::*;
`include "../../formal/riscv-formal/checks/rvfi_macros.vh"

module formal_tb (
	input logic clk,
	input logic rst_n
);

	logic			ebreak_start;
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


	proc_hier proc_dut (
		.osc_clk		(clk),
		.but_rst_n		(rst_n),
		.ebreak_start	(ebreak_start),

		// SDRAM hardware pins
		.sdram_clk		(sdram_clk), 
		.sdram_cke		(sdram_cke),
		.sdram_cs_n		(sdram_cs_n),
		.sdram_ras_n	(sdram_ras_n),
		.sdram_cas_n	(sdram_cas_n),
		.sdram_we_n		(sdram_we_n),
		.sdram_ba		(sdram_ba),
		.sdram_addr		(sdram_addr),
		.sdram_data		(sdram_data),
		.sdram_dqm		(sdram_dqm)
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


////////////////////// formal verification part //////////////////////
logic check;
assign check = proc_dut.processor_inst.init_done;



//// RVFI interface ////
logic [`RISCV_FORMAL_NRET                        - 1 : 0] rvfi_valid;		// valid instruction
logic [`RISCV_FORMAL_NRET *                 64   - 1 : 0] rvfi_order;		// programmer's instruction order
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_ILEN   - 1 : 0] rvfi_insn;		// retired instruction word
logic [`RISCV_FORMAL_NRET                        - 1 : 0] rvfi_trap;		// instruction cannot be decoded
logic [`RISCV_FORMAL_NRET                        - 1 : 0] rvfi_halt;		// last instruction
logic [`RISCV_FORMAL_NRET                        - 1 : 0] rvfi_intr;		// must be set for the first instruction that is part of a trap handler
logic [`RISCV_FORMAL_NRET *                  2   - 1 : 0] rvfi_mode;		// 0=U-Mode, 1=S-Mode, 2=Reserved, 3=M-Mode
logic [`RISCV_FORMAL_NRET *                  2   - 1 : 0] rvfi_ixl;			// 1=32, 2=64
logic [`RISCV_FORMAL_NRET *                  5   - 1 : 0] rvfi_rs1_addr;	// rs1 addr for retired instr
logic [`RISCV_FORMAL_NRET *                  5   - 1 : 0] rvfi_rs2_addr;	// rs2 addr for retired instr
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN   - 1 : 0] rvfi_rs1_rdata;	// value of rs1 right before retired instr
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN   - 1 : 0] rvfi_rs2_rdata;	// value of rs2 right before retired instr
logic [`RISCV_FORMAL_NRET *                  5   - 1 : 0] rvfi_rd_addr;		// rd addr for retired instr
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN   - 1 : 0] rvfi_rd_wdata;	// value of rd right after retired instr
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN   - 1 : 0] rvfi_pc_rdata;	// address of the retired instruction
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN   - 1 : 0] rvfi_pc_wdata;	// address of the next instruction
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN   - 1 : 0] rvfi_mem_addr;	// mem access addr
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN/8 - 1 : 0] rvfi_mem_rmask;	// which bytes in rvfi_mem_rdata contain valid read data from rvfi_mem_addr
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN/8 - 1 : 0] rvfi_mem_wmask;	// which bytes in rvfi_mem_wdata contain valid data that is written to rvfi_mem_addr
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN   - 1 : 0] rvfi_mem_rdata;	// data being read by retired instruction
logic [`RISCV_FORMAL_NRET * `RISCV_FORMAL_XLEN   - 1 : 0] rvfi_mem_wdata;	// data being written by retired instruction


always_comb begin : RVFI_interface_assign
	rvfi_valid		=	proc_dut.processor_inst.rvfi_valid;
	rvfi_order		=	proc_dut.processor_inst.rvfi_order;
	rvfi_insn		=	proc_dut.processor_inst.rvfi_insn;
	rvfi_trap		=	proc_dut.processor_inst.rvfi_trap;
	rvfi_halt		=	proc_dut.processor_inst.rvfi_halt;
	rvfi_intr		=	proc_dut.processor_inst.rvfi_intr;
	rvfi_mode		=	proc_dut.processor_inst.rvfi_mode;
	rvfi_ixl		=	proc_dut.processor_inst.rvfi_ixl;
	rvfi_rs1_addr	=	proc_dut.processor_inst.rvfi_rs1_addr;
	rvfi_rs2_addr	=	proc_dut.processor_inst.rvfi_rs2_addr;
	rvfi_rs1_rdata	=	proc_dut.processor_inst.rvfi_rs1_rdata;
	rvfi_rs2_rdata	=	proc_dut.processor_inst.rvfi_rs2_rdata;
	rvfi_rd_addr	=	proc_dut.processor_inst.rvfi_rd_addr;
	rvfi_rd_wdata	=	proc_dut.processor_inst.rvfi_rd_wdata;
	rvfi_pc_rdata	=	proc_dut.processor_inst.rvfi_pc_rdata;
	rvfi_pc_wdata	=	proc_dut.processor_inst.rvfi_pc_wdata;
	rvfi_mem_addr	=	proc_dut.processor_inst.rvfi_mem_addr;
	rvfi_mem_rmask	=	proc_dut.processor_inst.rvfi_mem_rmask;
	rvfi_mem_wmask	=	proc_dut.processor_inst.rvfi_mem_wmask;
	rvfi_mem_rdata	=	proc_dut.processor_inst.rvfi_mem_rdata;
	rvfi_mem_wdata	=	proc_dut.processor_inst.rvfi_mem_wdata;
end
//// RVFI interface ////


//// casual check ////
rvfi_causal_check rvfi_causal_check_inst (
	.clock			(clk),
	.reset			(~rst_n),
	.check			(check),

	.rvfi_valid		(rvfi_valid),
	.rvfi_order		(rvfi_order),
	.rvfi_insn		(rvfi_insn),
	.rvfi_trap		(rvfi_trap),
	.rvfi_halt		(rvfi_halt),
	.rvfi_intr		(rvfi_intr),
	.rvfi_mode		(rvfi_mode),
	.rvfi_ixl		(rvfi_ixl),
	.rvfi_rs1_addr	(rvfi_rs1_addr),
	.rvfi_rs2_addr	(rvfi_rs2_addr),
	.rvfi_rs1_rdata	(rvfi_rs1_rdata),
	.rvfi_rs2_rdata	(rvfi_rs2_rdata),
	.rvfi_rd_addr	(rvfi_rd_addr),
	.rvfi_rd_wdata	(rvfi_rd_wdata),
	.rvfi_pc_rdata	(rvfi_pc_rdata),
	.rvfi_pc_wdata	(rvfi_pc_wdata),
	.rvfi_mem_addr	(rvfi_mem_addr),
	.rvfi_mem_rmask	(rvfi_mem_rmask),
	.rvfi_mem_wmask	(rvfi_mem_wmask),
	.rvfi_mem_rdata	(rvfi_mem_rdata),
	.rvfi_mem_wdata	(rvfi_mem_wdata)
);
//// casual check ////




////////////////////////////////////////////////////////////////////////////////



endmodule : formal_tb
