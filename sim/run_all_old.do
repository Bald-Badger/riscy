# To run this example, bring up the simulator and type the following at the prompt:
#     do run_all.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -c -do run_all.do
# (omit the "-c" to see the GUI while running from the shell)
#

onerror {resume}
# Create the library.
if [file exists smoke] {
    vdel -all
}

project open riscy_altera.mpf

# compile `defines
vlog -work smoke -vopt -sv -stats=none  ../rtl/defines.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/mem_defines.sv

# compile EDA files
#vlog -work smoke -vopt -stats=none  ../rtl/eda/other/altera_mf.v
#vlog -work smoke -vopt -stats=none  ../rtl/eda/other/altera_primitives.v
#vlog -work smoke -vopt -stats=none  ../rtl/eda/other/altera_primitives_quasar.v
#vlog -work smoke -vopt -stats=none  ../rtl/eda/lpm/dffep.v
#vlog -work smoke -vopt -stats=none  ../rtl/eda/lpm/addsub_block.v
#vlog -work smoke -vopt -stats=none  ../rtl/eda/lpm/pipeline_internal_fv.v
#vlog -work smoke -vopt -stats=none  ../rtl/eda/lpm/lpm_mult.v
#vlog -work smoke -vopt -stats=none  ../rtl/eda/lpm/mult_block.v
#vlog -work smoke -vopt -stats=none  ../rtl/eda/lpm/lpm_divide.v


# compile top level tb
vlog -work smoke -vopt -sv -stats=none  ../rtl/tb/smoke_test_single.sv

# Compile the HDL source(s)

vlog -work smoke -vopt -sv -stats=none  ../rtl/proc_hier.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/proc.sv
# vlog -work smoke -vopt -sv -stats=none  ../rtl/clkrst.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/hazard_ctrl.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/base/dffe_wrap.sv

# compile ip files
vlog -work smoke -vopt -stats=none  ../rtl/ip/altera/div.v
vlog -work smoke -vopt -stats=none  ../rtl/ip/altera/mult.v
vlog -work smoke -vopt -stats=none  ../rtl/ip/altera/pll_clk.v
vlog -work smoke -vopt -stats=none  ../rtl/ip/altera/ram_32b_1024wd.v
vlog -work smoke -vopt -stats=none  ../rtl/ip/altera/ram_48b_512wd.v
vlog -work smoke -vopt -stats=none  ../rtl/ip/altera/ram_256b_512wd.v
vlog -work smoke -vopt -stats=none  ../rtl/ip/altera/ram_32b_1024wd.v
vlog -work smoke -vopt -stats=none  ../rtl/ip/altera/rom_32b_1024wd.v

vlog -work smoke -vopt -sv -stats=none  ../rtl/fetch/branch_predict.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/fetch/fetch.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/fetch/instr_mem.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/fetch/pc.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/decode/decode.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/decode/extend.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/decode/pc_adder.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/decode/reg_bypass.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/decode/reg_ctrl.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/decode/registers.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/execute/alu_defines.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/execute/alu.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/execute/ex_mux.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/execute/execute.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/execute/divider.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/execute/multiplier.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/memory.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/cache.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/mem_sys.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/exclusive_monitor.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/sdram/sdr.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/sdram/sdram.sv
vlog -work smoke -vopt -stats=none  ../rtl/mem/sdram/rdfifo.v
vlog -work smoke -vopt -stats=none  ../rtl/mem/sdram/wrfifo.v
vlog -work smoke -vopt -stats=none  ../rtl/mem/sdram/sdram_cmd.v
vlog -work smoke -vopt -stats=none  ../rtl/mem/sdram/sdram_controller.v
vlog -work smoke -vopt -stats=none  ../rtl/mem/sdram/sdram_ctrl.v
vlog -work smoke -vopt -stats=none  ../rtl/mem/sdram/sdram_data.v
vlog -work smoke -vopt -stats=none  ../rtl/mem/sdram/sdram_fifo_ctrl.v
vlog -work smoke -vopt -stats=none  ../rtl/mem/sdram/sdram_para.v
vlog -work smoke -vopt -stats=none  ../rtl/mem/sdram/sdram_top.v


vlog -work smoke -vopt -sv -stats=none  ../rtl/wb/wb.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/reg/if_id_reg.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/reg/id_ex_reg.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/reg/ex_mem_reg.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/reg/mem_wb_reg.sv

# compile formal ver files
vlog -work smoke -vopt -stats=none  ../formal/riscv-formal/tests/coverage/riscv_rv32i_insn.v


# Simulate the design
onerror {quit -sim}
# vsim -gui smoke.smoke_test_single -voptargs=+acc
vsim smoke.smoke_test_single {-voptargs=-L altera_mf_ver -L altera_ver -L lpm_ver}
run -all
quit -f