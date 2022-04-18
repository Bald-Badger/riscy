# TCL File Generated by Component Editor 21.1
# Sun Apr 17 20:35:47 EDT 2022
# DO NOT MODIFY


# 
# riscy_core "riscy_core" v1.0
#  2022.04.17.20:35:47
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module riscy_core
# 
set_module_property DESCRIPTION ""
set_module_property NAME riscy_core
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME riscy_core
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL riscy_core_axil_qsys
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file riscy_core_axil_qsys.sv SYSTEM_VERILOG PATH ../../rtl/riscy_core_axil_qsys.sv TOP_LEVEL_FILE
add_fileset_file defines.sv SYSTEM_VERILOG PATH ../../rtl/defines.sv
add_fileset_file hazard_ctrl.sv SYSTEM_VERILOG PATH ../../rtl/hazard_ctrl.sv
add_fileset_file proc.sv SYSTEM_VERILOG PATH ../../rtl/proc.sv
add_fileset_file proc_axil.sv SYSTEM_VERILOG PATH ../../rtl/proc_axil.sv
add_fileset_file debouncer.sv SYSTEM_VERILOG PATH ../../rtl/base/debouncer.sv
add_fileset_file dff_wrap.sv SYSTEM_VERILOG PATH ../../rtl/base/dff_wrap.sv
add_fileset_file dffe_wrap.sv SYSTEM_VERILOG PATH ../../rtl/base/dffe_wrap.sv
add_fileset_file dffe_wrap_unsyn.sv SYSTEM_VERILOG PATH ../../rtl/base/dffe_wrap_unsyn.sv
add_fileset_file fifo.sv SYSTEM_VERILOG PATH ../../rtl/base/fifo.sv
add_fileset_file iobuf.v VERILOG PATH ../../rtl/base/iobuf.v
add_fileset_file rom.sv SYSTEM_VERILOG PATH ../../rtl/base/rom.sv
add_fileset_file decode.sv SYSTEM_VERILOG PATH ../../rtl/decode/decode.sv
add_fileset_file extend.sv SYSTEM_VERILOG PATH ../../rtl/decode/extend.sv
add_fileset_file pc_adder.sv SYSTEM_VERILOG PATH ../../rtl/decode/pc_adder.sv
add_fileset_file reg_bypass.sv SYSTEM_VERILOG PATH ../../rtl/decode/reg_bypass.sv
add_fileset_file reg_ctrl.sv SYSTEM_VERILOG PATH ../../rtl/decode/reg_ctrl.sv
add_fileset_file registers.sv SYSTEM_VERILOG PATH ../../rtl/decode/registers.sv
add_fileset_file alu.sv SYSTEM_VERILOG PATH ../../rtl/execute/alu.sv
add_fileset_file alu_defines.sv SYSTEM_VERILOG PATH ../../rtl/execute/alu_defines.sv
add_fileset_file ex_mux.sv SYSTEM_VERILOG PATH ../../rtl/execute/ex_mux.sv
add_fileset_file execute.sv SYSTEM_VERILOG PATH ../../rtl/execute/execute.sv
add_fileset_file branch_predict.sv SYSTEM_VERILOG PATH ../../rtl/fetch/branch_predict.sv
add_fileset_file fetch.sv SYSTEM_VERILOG PATH ../../rtl/fetch/fetch.sv
add_fileset_file fetch_axil.sv SYSTEM_VERILOG PATH ../../rtl/fetch/fetch_axil.sv
add_fileset_file fetch_axil_tb.sv SYSTEM_VERILOG PATH ../../rtl/fetch/fetch_axil_tb.sv
add_fileset_file pc.sv SYSTEM_VERILOG PATH ../../rtl/fetch/pc.sv
add_fileset_file axi_crossbar_2x1.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_crossbar_2x1.sv
add_fileset_file axi_crossbar_2x1_wrapper.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_crossbar_2x1_wrapper.sv
add_fileset_file axi_defines.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_defines.sv
add_fileset_file axi_interconnect_2x1.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_interconnect_2x1.sv
add_fileset_file axi_interconnect_2x1_wrapper.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_interconnect_2x1_wrapper.sv
add_fileset_file axi_interface.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_interface.sv
add_fileset_file axi_lite_interface.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_lite_interface.sv
add_fileset_file axi_ram_sv_wrapper.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_ram_sv_wrapper.sv
add_fileset_file axil_axi_adapter.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axil_axi_adapter.sv
add_fileset_file axil_crossbar_2x1.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axil_crossbar_2x1.sv
add_fileset_file axil_crossbar_2x1_wrapper.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axil_crossbar_2x1_wrapper.sv
add_fileset_file axil_ram_sv_wrapper.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axil_ram_sv_wrapper.sv
add_fileset_file sdram_interface.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/sdram_interface.sv
add_fileset_file sdr.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdr.sv
add_fileset_file sdr_parameters.svh OTHER PATH ../../rtl/mem/sdram/sdr_parameters.svh
add_fileset_file sdram_axi.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdram_axi.sv
add_fileset_file sdram_axi_core.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdram_axi_core.sv
add_fileset_file sdram_axi_pmem.v VERILOG PATH ../../rtl/mem/sdram/sdram_axi_pmem.v
add_fileset_file sdram_axi_qsys.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdram_axi_qsys.sv
add_fileset_file sdram_axi_wrapper.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdram_axi_wrapper.sv
add_fileset_file sdram_axil_qsys.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdram_axil_qsys.sv
add_fileset_file cache.sv SYSTEM_VERILOG PATH ../../rtl/mem/cache.sv
add_fileset_file exclusive_monitor.sv SYSTEM_VERILOG PATH ../../rtl/mem/exclusive_monitor.sv
add_fileset_file mem_defines.sv SYSTEM_VERILOG PATH ../../rtl/mem/mem_defines.sv
add_fileset_file mem_sys_axil.sv SYSTEM_VERILOG PATH ../../rtl/mem/mem_sys_axil.sv
add_fileset_file mem_sys_axil_wrapper.sv SYSTEM_VERILOG PATH ../../rtl/mem/mem_sys_axil_wrapper.sv
add_fileset_file memory.sv SYSTEM_VERILOG PATH ../../rtl/mem/memory.sv
add_fileset_file axil_interconnect_2x1.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axil_interconnect_2x1.sv
add_fileset_file axil2simp.sv SYSTEM_VERILOG PATH ../../rtl/mem/axil2simp.sv
add_fileset_file hex7seg.sv SYSTEM_VERILOG PATH ../../rtl/perf/hex7seg.sv
add_fileset_file pref.sv SYSTEM_VERILOG PATH ../../rtl/perf/pref.sv
add_fileset_file pref_defines.sv SYSTEM_VERILOG PATH ../../rtl/perf/pref_defines.sv
add_fileset_file seg_axil.sv SYSTEM_VERILOG PATH ../../rtl/perf/seg_axil.sv
add_fileset_file ex_mem_reg.sv SYSTEM_VERILOG PATH ../../rtl/reg/ex_mem_reg.sv
add_fileset_file id_ex_reg.sv SYSTEM_VERILOG PATH ../../rtl/reg/id_ex_reg.sv
add_fileset_file if_id_reg.sv SYSTEM_VERILOG PATH ../../rtl/reg/if_id_reg.sv
add_fileset_file mem_wb_reg.sv SYSTEM_VERILOG PATH ../../rtl/reg/mem_wb_reg.sv
add_fileset_file arbiter.v VERILOG PATH ../../rtl/verilog-axi/rtl/arbiter.v
add_fileset_file axi_adapter.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_adapter.v
add_fileset_file axi_adapter_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_adapter_rd.v
add_fileset_file axi_adapter_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_adapter_wr.v
add_fileset_file axi_axil_adapter.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_axil_adapter.v
add_fileset_file axi_axil_adapter_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_axil_adapter_rd.v
add_fileset_file axi_axil_adapter_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_axil_adapter_wr.v
add_fileset_file axi_cdma.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_cdma.v
add_fileset_file axi_cdma_desc_mux.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_cdma_desc_mux.v
add_fileset_file axi_crossbar.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_crossbar.v
add_fileset_file axi_crossbar_addr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_crossbar_addr.v
add_fileset_file axi_crossbar_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_crossbar_rd.v
add_fileset_file axi_crossbar_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_crossbar_wr.v
add_fileset_file axi_crossbar_wrap.py OTHER PATH ../../rtl/verilog-axi/rtl/axi_crossbar_wrap.py
add_fileset_file axi_dma.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_dma.v
add_fileset_file axi_dma_desc_mux.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_dma_desc_mux.v
add_fileset_file axi_dma_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_dma_rd.v
add_fileset_file axi_dma_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_dma_wr.v
add_fileset_file axi_dp_ram.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_dp_ram.v
add_fileset_file axi_fifo.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_fifo.v
add_fileset_file axi_fifo_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_fifo_rd.v
add_fileset_file axi_fifo_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_fifo_wr.v
add_fileset_file axi_interconnect.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_interconnect.v
add_fileset_file axi_interconnect_wrap.py OTHER PATH ../../rtl/verilog-axi/rtl/axi_interconnect_wrap.py
add_fileset_file axi_ram.sv SYSTEM_VERILOG PATH ../../rtl/verilog-axi/rtl/axi_ram.sv
add_fileset_file axi_ram_rd_if.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_ram_rd_if.v
add_fileset_file axi_ram_wr_if.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_ram_wr_if.v
add_fileset_file axi_ram_wr_rd_if.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_ram_wr_rd_if.v
add_fileset_file axi_register.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_register.v
add_fileset_file axi_register_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_register_rd.v
add_fileset_file axi_register_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axi_register_wr.v
add_fileset_file axil_adapter.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_adapter.v
add_fileset_file axil_adapter_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_adapter_rd.v
add_fileset_file axil_adapter_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_adapter_wr.v
add_fileset_file axil_cdc.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_cdc.v
add_fileset_file axil_cdc_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_cdc_rd.v
add_fileset_file axil_cdc_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_cdc_wr.v
add_fileset_file axil_crossbar.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_crossbar.v
add_fileset_file axil_crossbar_addr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_crossbar_addr.v
add_fileset_file axil_crossbar_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_crossbar_rd.v
add_fileset_file axil_crossbar_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_crossbar_wr.v
add_fileset_file axil_crossbar_wrap.py OTHER PATH ../../rtl/verilog-axi/rtl/axil_crossbar_wrap.py
add_fileset_file axil_dp_ram.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_dp_ram.v
add_fileset_file axil_interconnect.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_interconnect.v
add_fileset_file axil_interconnect_wrap.py OTHER PATH ../../rtl/verilog-axi/rtl/axil_interconnect_wrap.py
add_fileset_file axil_ram.sv SYSTEM_VERILOG PATH ../../rtl/verilog-axi/rtl/axil_ram.sv
add_fileset_file axil_ram_og.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_ram_og.v
add_fileset_file axil_reg_if.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_reg_if.v
add_fileset_file axil_reg_if_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_reg_if_rd.v
add_fileset_file axil_reg_if_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_reg_if_wr.v
add_fileset_file axil_register.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_register.v
add_fileset_file axil_register_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_register_rd.v
add_fileset_file axil_register_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_register_wr.v
add_fileset_file priority_encoder.v VERILOG PATH ../../rtl/verilog-axi/rtl/priority_encoder.v
add_fileset_file wb.sv SYSTEM_VERILOG PATH ../../rtl/wb/wb.sv
add_fileset_file proc_axi.sv SYSTEM_VERILOG PATH ../../rtl/proc_axi.sv


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point altera_axi4lite_master
# 
add_interface altera_axi4lite_master axi4lite start
set_interface_property altera_axi4lite_master associatedClock clock
set_interface_property altera_axi4lite_master associatedReset reset_sink
set_interface_property altera_axi4lite_master readIssuingCapability 1
set_interface_property altera_axi4lite_master writeIssuingCapability 1
set_interface_property altera_axi4lite_master combinedIssuingCapability 1
set_interface_property altera_axi4lite_master ENABLED true
set_interface_property altera_axi4lite_master EXPORT_OF ""
set_interface_property altera_axi4lite_master PORT_NAME_MAP ""
set_interface_property altera_axi4lite_master CMSIS_SVD_VARIABLES ""
set_interface_property altera_axi4lite_master SVD_ADDRESS_GROUP ""

add_interface_port altera_axi4lite_master araddr araddr Output 32
add_interface_port altera_axi4lite_master arprot arprot Output 3
add_interface_port altera_axi4lite_master arready arready Input 1
add_interface_port altera_axi4lite_master arvalid arvalid Output 1
add_interface_port altera_axi4lite_master awaddr awaddr Output 32
add_interface_port altera_axi4lite_master awprot awprot Output 3
add_interface_port altera_axi4lite_master awready awready Input 1
add_interface_port altera_axi4lite_master awvalid awvalid Output 1
add_interface_port altera_axi4lite_master bready bready Output 1
add_interface_port altera_axi4lite_master bresp bresp Input 2
add_interface_port altera_axi4lite_master bvalid bvalid Input 1
add_interface_port altera_axi4lite_master rdata rdata Input 32
add_interface_port altera_axi4lite_master rready rready Output 1
add_interface_port altera_axi4lite_master rresp rresp Input 2
add_interface_port altera_axi4lite_master rvalid rvalid Input 1
add_interface_port altera_axi4lite_master wdata wdata Output 32
add_interface_port altera_axi4lite_master wready wready Input 1
add_interface_port altera_axi4lite_master wstrb wstrb Output 4
add_interface_port altera_axi4lite_master wvalid wvalid Output 1


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink rst reset Input 1


# 
# connection point go
# 
add_interface go conduit end
set_interface_property go associatedClock clock
set_interface_property go associatedReset ""
set_interface_property go ENABLED true
set_interface_property go EXPORT_OF ""
set_interface_property go PORT_NAME_MAP ""
set_interface_property go CMSIS_SVD_VARIABLES ""
set_interface_property go SVD_ADDRESS_GROUP ""

add_interface_port go go go Input 1


# 
# connection point boot_pc
# 
add_interface boot_pc conduit end
set_interface_property boot_pc associatedClock clock
set_interface_property boot_pc associatedReset ""
set_interface_property boot_pc ENABLED true
set_interface_property boot_pc EXPORT_OF ""
set_interface_property boot_pc PORT_NAME_MAP ""
set_interface_property boot_pc CMSIS_SVD_VARIABLES ""
set_interface_property boot_pc SVD_ADDRESS_GROUP ""

add_interface_port boot_pc boot_pc boot_pc Input 10

