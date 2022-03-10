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
vlog -work smoke -vopt -sv -stats=none	../rtl/interconnect/axi_defines.sv


# compile top level tb
vlog -work smoke -vopt -sv -stats=none  ../rtl/tb/axil_test.sv

# Compile the HDL source(s)

vlog -work smoke -vopt -sv -stats=none  ../rtl/proc_axil.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/hazard_ctrl.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/base/dffe_wrap.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/base/dffe_wrap_unsyn.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/base/dff_wrap.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/base/fifo.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/fetch/branch_predict.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/fetch/fetch_axil.sv


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
vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/mem_sys_axil.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/mem_sys_axil_wrapper.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/mem/exclusive_monitor.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/wb/wb.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/reg/if_id_reg.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/reg/id_ex_reg.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/reg/ex_mem_reg.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/reg/mem_wb_reg.sv

vlog -work smoke -vopt -sv -stats=none  ../rtl/interconnect/axi_lite_interface.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/interconnect/axil_crossbar_2x1.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/interconnect/axil_crossbar_2x1_wrapper.sv
vlog -work smoke -vopt -sv -stats=none  ../rtl/interconnect/axil_ram_sv_wrapper.sv

vlog -work smoke -vopt -stats=none  ../rtl/verilog-axi/rtl/*.v

# Simulate the design
onerror {quit -sim}

vsim smoke.axil_test
run -all
quit -f