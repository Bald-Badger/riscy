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
///////////////////////








////////////////////////////////////////////////////////////////////////////////



endmodule : formal_tb
