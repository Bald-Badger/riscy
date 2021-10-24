# To run this example, bring up the simulator and type the following at the prompt:
#     do run_all.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -c -do run_all.do
# (omit the "-c" to see the GUI while running from the shell)
#

onerror {resume}
# Create the library.
if [file exists work] {
    vdel -all
}
project open riscy.mpf
# project compileall

# compile `defines
vlog -work work -vopt -sv -stats=none  ../rtl/defines.sv
vlog -work work -vopt -sv -stats=none  ../rtl/mem/mem_defines.sv

# compile EDA files
#vlog -work work -vopt -stats=none  ../rtl/eda/other/altera_mf.v
#vlog -work work -vopt -stats=none  ../rtl/eda/other/altera_primitives.v
#vlog -work work -vopt -stats=none  ../rtl/eda/other/altera_primitives_quasar.v
#vlog -work work -vopt -stats=none  ../rtl/eda/lpm/altpll.v
#vlog -work work -vopt -stats=none  ../rtl/eda/lpm/lpm_mult.v
#vlog -work work -vopt -stats=none  ../rtl/eda/lpm/mult_block.v
#vlog -work work -vopt -stats=none  ../rtl/eda/lpm/lpm_divide.v

# compile top level tb
vlog -work work -vopt -sv -stats=none  ../rtl/tb/smoke_test_single.sv

# Compile the HDL source(s)

vlog -work work -vopt -sv -stats=none  ../rtl/proc_hier.sv
vlog -work work -vopt -sv -stats=none  ../rtl/proc.sv
vlog -work work -vopt -sv -stats=none  ../rtl/clkrst.sv
vlog -work work -vopt -sv -stats=none  ../rtl/hazard_ctrl.sv

vlog -work work -vopt -sv -stats=none  ../rtl/base/dffe_wrap.sv

vlog -work work -vopt -stats=none  ../rtl/ip/divide/div.v
vlog -work work -vopt -stats=none  ../rtl/ip/mult/mult.v
vlog -work work -vopt -stats=none  ../rtl/ip/pll/pll_clk.v
vlog -work work -vopt -stats=none  ../rtl/ip/ram/rom_32b_1024wd.v
vlog -work work -vopt -stats=none  ../rtl/ip/ram/ram_48b_512wd.v
vlog -work work -vopt -stats=none  ../rtl/ip/ram/ram_256b_512wd.v

vlog -work work -vopt -sv -stats=none  ../rtl/fetch/branch_predict.sv
vlog -work work -vopt -sv -stats=none  ../rtl/fetch/fetch.sv
vlog -work work -vopt -sv -stats=none  ../rtl/fetch/instr_mem.sv
vlog -work work -vopt -sv -stats=none  ../rtl/fetch/pc.sv

vlog -work work -vopt -sv -stats=none  ../rtl/decode/decode.sv
vlog -work work -vopt -sv -stats=none  ../rtl/decode/extend.sv
vlog -work work -vopt -sv -stats=none  ../rtl/decode/pc_adder.sv
vlog -work work -vopt -sv -stats=none  ../rtl/decode/reg_bypass.sv
vlog -work work -vopt -sv -stats=none  ../rtl/decode/reg_ctrl.sv
vlog -work work -vopt -sv -stats=none  ../rtl/decode/registers.sv

vlog -work work -vopt -sv -stats=none  ../rtl/execute/alu_defines.sv
vlog -work work -vopt -sv -stats=none  ../rtl/execute/alu.sv
vlog -work work -vopt -sv -stats=none  ../rtl/execute/ex_mux.sv
vlog -work work -vopt -sv -stats=none  ../rtl/execute/execute.sv
vlog -work work -vopt -sv -stats=none  ../rtl/execute/mult_div.sv

vlog -work work -vopt -sv -stats=none  ../rtl/mem/memory.sv
vlog -work work -vopt -sv -stats=none  ../rtl/mem/cache.sv
vlog -work work -vopt -sv -stats=none  ../rtl/mem/mem_ctrl.sv
vlog -work work -vopt -sv -stats=none  ../rtl/mem/mem_sys.sv

vlog -work work -vopt -sv -stats=none  ../rtl/mem/sdram/sdr.sv
vlog -work work -vopt -sv -stats=none  ../rtl/mem/sdram/sdram.sv
vlog -work work -vopt -stats=none  ../rtl/mem/sdram/rdfifo.v
vlog -work work -vopt -stats=none  ../rtl/mem/sdram/wrfifo.v
vlog -work work -vopt -stats=none  ../rtl/mem/sdram/sdram_cmd.v
vlog -work work -vopt -stats=none  ../rtl/mem/sdram/sdram_controller.v
vlog -work work -vopt -stats=none  ../rtl/mem/sdram/sdram_ctrl.v
vlog -work work -vopt -stats=none  ../rtl/mem/sdram/sdram_data.v
vlog -work work -vopt -stats=none  ../rtl/mem/sdram/sdram_fifo_ctrl.v
vlog -work work -vopt -stats=none  ../rtl/mem/sdram/sdram_para.v
vlog -work work -vopt -stats=none  ../rtl/mem/sdram/sdram_top.v


vlog -work work -vopt -sv -stats=none  ../rtl/wb/wb.sv

vlog -work work -vopt -sv -stats=none  ../rtl/reg/if_id_reg.sv
vlog -work work -vopt -sv -stats=none  ../rtl/reg/id_ex_reg.sv
vlog -work work -vopt -sv -stats=none  ../rtl/reg/ex_mem_reg.sv
vlog -work work -vopt -sv -stats=none  ../rtl/reg/mem_wb_reg.sv


# Simulate the design
onerror {quit -sim}
# vsim -gui work.smoke_test_single -voptargs=+acc
vsim work.smoke_test_single {-voptargs=-L altera_mf_ver -L altera_ver -L lpm_ver}
run -all
quit -f