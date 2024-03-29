################################################################################
#               Copyright 2006-2019 Mentor Graphics Corporation
#                            All Rights Reserved.
#               THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY
#             INFORMATION WHICH IS THE PROPERTY OF MENTOR GRAPHICS 
#         CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
################################################################################
# V2019 Formal Quick Start Tutorial
################################################################################
run: clean compile formal debug

###### Define Variables ########################################################
VLIB = ${QHOME}/modeltech/plat/vlib
VMAP = ${QHOME}/modeltech/plat/vmap
VLOG = ${QHOME}/modeltech/plat/vlog

###### Compile Design ##########################################################
compile:
	$(VLIB) work
	$(VMAP) work work

	$(VLOG) -sv  ../rtl/defines.sv
	$(VLOG) -sv  ../rtl/mem/mem_defines.sv

	$(VLOG) -sv  ../rtl/tb/formal_tb.sv

	$(VLOG)  ../rtl/eda/other/altera_mf.v
	$(VLOG)  ../rtl/eda/other/altera_primitives.v
	$(VLOG)  ../rtl/eda/other/altera_primitives_quasar.v
	$(VLOG)  ../rtl/eda/lpm/dffep.v
	$(VLOG)  ../rtl/eda/lpm/addsub_block.v
	$(VLOG)  ../rtl/eda/lpm/pipeline_internal_fv.v
	$(VLOG)  ../rtl/eda/lpm/altpll.v
	$(VLOG)  ../rtl/eda/lpm/lpm_mult.v
	$(VLOG)  ../rtl/eda/lpm/mult_block.v
	$(VLOG)  ../rtl/eda/lpm/lpm_divide.v

	$(VLOG)  ../rtl/ip/altera/div.v
	$(VLOG)  ../rtl/ip/altera/mult.v
	$(VLOG)  ../rtl/ip/altera/pll_clk.v
	$(VLOG)  ../rtl/ip/altera/rom_32b_1024wd.v
	$(VLOG)  ../rtl/ip/altera/ram_48b_512wd.v
	$(VLOG)  ../rtl/ip/altera/ram_256b_512wd.v

	$(VLOG) -sv  ../rtl/proc_hier.sv
	$(VLOG) -sv  ../rtl/proc.sv
	$(VLOG) -sv  ../rtl/hazard_ctrl.sv

	$(VLOG) -sv  ../rtl/base/dffe_wrap.sv
	$(VLOG) -sv  ../rtl/base/rom.sv

	$(VLOG) -sv  ../rtl/fetch/branch_predict.sv
	$(VLOG) -sv  ../rtl/fetch/fetch.sv
	$(VLOG) -sv  ../rtl/fetch/instr_mem.sv
	$(VLOG) -sv  ../rtl/fetch/pc.sv

	$(VLOG) -sv  ../rtl/decode/decode.sv
	$(VLOG) -sv  ../rtl/decode/extend.sv
	$(VLOG) -sv  ../rtl/decode/pc_adder.sv
	$(VLOG) -sv  ../rtl/decode/reg_bypass.sv
	$(VLOG) -sv  ../rtl/decode/reg_ctrl.sv
	$(VLOG) -sv  ../rtl/decode/registers.sv

	$(VLOG) -sv  ../rtl/execute/alu_defines.sv
	$(VLOG) -sv  ../rtl/execute/alu.sv
	$(VLOG) -sv  ../rtl/execute/ex_mux.sv
	$(VLOG) -sv  ../rtl/execute/execute.sv
	$(VLOG) -sv  ../rtl/execute/divider.sv
	$(VLOG) -sv  ../rtl/execute/multiplier.sv

	$(VLOG) -sv  ../rtl/mem/memory.sv
	$(VLOG) -sv  ../rtl/mem/cache.sv
	$(VLOG) -sv  ../rtl/mem/mem_sys.sv
	$(VLOG) -sv  ../rtl/mem/exclusive_monitor.sv

	$(VLOG) -sv  ../rtl/mem/sdram/sdr.sv
	$(VLOG) -sv  ../rtl/mem/sdram/sdram.sv
	$(VLOG)  ../rtl/mem/sdram/rdfifo.v
	$(VLOG)  ../rtl/mem/sdram/wrfifo.v
	$(VLOG)  ../rtl/mem/sdram/sdram_cmd.v
	$(VLOG)  ../rtl/mem/sdram/sdram_controller.v
	$(VLOG)  ../rtl/mem/sdram/sdram_ctrl.v
	$(VLOG)  ../rtl/mem/sdram/sdram_data.v
	$(VLOG)  ../rtl/mem/sdram/sdram_fifo_ctrl.v
	$(VLOG)  ../rtl/mem/sdram/sdram_para.v
	$(VLOG)  ../rtl/mem/sdram/sdram_top.v

	$(VLOG) -sv  ../rtl/wb/wb.sv

	$(VLOG) -sv  ../rtl/reg/if_id_reg.sv
	$(VLOG) -sv  ../rtl/reg/id_ex_reg.sv
	$(VLOG) -sv  ../rtl/reg/ex_mem_reg.sv
	$(VLOG) -sv  ../rtl/reg/mem_wb_reg.sv

	$(VLOG)  ../formal/riscv-formal/checks/rvfi_macros.vh
	$(VLOG)  ../formal/riscv-formal/tests/coverage/riscv_rv32i_insn.v
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_causal_check.sv
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_pc_fwd_check.sv
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_pc_bwd_check.sv
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_unique_check.sv
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_reg_check.sv
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_dmem_check.sv
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_hang_check.sv
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_liveness_check.sv
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_imem_check.sv
	$(VLOG)  -sv ../formal/riscv-formal/checks/rvfi_ill_check.sv

	$(VLOG)  -sv ../formal/riscv-formal/monitor/riscy_monitor.sv

###### Run Formal Analysis #####################################################
formal:
	qverify -c -od Output_Results -do "\
		do qs_files/directives.tcl; \
		formal compile -d formal_tb; \
		formal verify -init qs_files/wb_arbiter.init \
		-timeout 5m; \
		exit"

###### Debug Results ###########################################################
debug: 
	qverify Output_Results/formal_compile.db &

###### Clean Data ##############################################################
clean:
	qverify_clean
	\rm -rf work modelsim.ini *.wlf *.log replay* transcript *.db
	\rm -rf Output_Results *.tcl 

################################################################################
# Regressions 
################################################################################
REGRESS_FILE_LIST = \
	Output_Results/formal_property.rpt \
	Output_Results/formal_verify.rpt

regression: clean compile formal
	@rm -f regress_file_list
	@echo "# This file was generated by make" > regress_file_list
	@/bin/ls -1 $(REGRESS_FILE_LIST) >> regress_file_list
	@chmod -w regress_file_list
