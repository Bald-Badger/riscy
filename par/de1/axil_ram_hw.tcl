# TCL File Generated by Component Editor 21.1
# Fri Apr 01 01:52:59 EDT 2022
# DO NOT MODIFY


# 
# vga_ball "VGA Ball" v1.0
#  2022.04.01.01:52:59
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module vga_ball
# 
set_module_property DESCRIPTION ""
set_module_property NAME vga_ball
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "VGA Ball"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false

set_module_assignment embeddedsw.dts.vendor "csee4840"
set_module_assignment embeddedsw.dts.name "vga_ball"
set_module_assignment embeddedsw.dts.group "vga"

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL axil_ram
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
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
add_fileset_file axil_ram.sv SYSTEM_VERILOG PATH ../../rtl/verilog-axi/rtl/axil_ram.sv TOP_LEVEL_FILE
add_fileset_file axil_reg_if.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_reg_if.v
add_fileset_file axil_reg_if_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_reg_if_rd.v
add_fileset_file axil_reg_if_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_reg_if_wr.v
add_fileset_file axil_register.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_register.v
add_fileset_file axil_register_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_register_rd.v
add_fileset_file axil_register_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_register_wr.v
add_fileset_file priority_encoder.v VERILOG PATH ../../rtl/verilog-axi/rtl/priority_encoder.v
add_fileset_file defines.sv SYSTEM_VERILOG PATH ../../rtl/defines.sv
add_fileset_file mem_defines.sv SYSTEM_VERILOG PATH ../../rtl/mem/mem_defines.sv


# 
# parameters
# 
add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATA_WIDTH HDL_PARAMETER true
add_parameter ADDR_WIDTH INTEGER 16
set_parameter_property ADDR_WIDTH DEFAULT_VALUE 16
set_parameter_property ADDR_WIDTH DISPLAY_NAME ADDR_WIDTH
set_parameter_property ADDR_WIDTH TYPE INTEGER
set_parameter_property ADDR_WIDTH UNITS None
set_parameter_property ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADDR_WIDTH HDL_PARAMETER true
add_parameter PIPELINE_OUTPUT INTEGER 0
set_parameter_property PIPELINE_OUTPUT DEFAULT_VALUE 0
set_parameter_property PIPELINE_OUTPUT DISPLAY_NAME PIPELINE_OUTPUT
set_parameter_property PIPELINE_OUTPUT TYPE INTEGER
set_parameter_property PIPELINE_OUTPUT UNITS None
set_parameter_property PIPELINE_OUTPUT ALLOWED_RANGES -2147483648:2147483647
set_parameter_property PIPELINE_OUTPUT HDL_PARAMETER true


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
# connection point altera_axi4lite_slave
# 
add_interface altera_axi4lite_slave axi4lite end
set_interface_property altera_axi4lite_slave associatedClock clock
set_interface_property altera_axi4lite_slave associatedReset reset_sink
set_interface_property altera_axi4lite_slave readAcceptanceCapability 1
set_interface_property altera_axi4lite_slave writeAcceptanceCapability 1
set_interface_property altera_axi4lite_slave combinedAcceptanceCapability 1
set_interface_property altera_axi4lite_slave readDataReorderingDepth 1
set_interface_property altera_axi4lite_slave bridgesToMaster ""
set_interface_property altera_axi4lite_slave ENABLED true
set_interface_property altera_axi4lite_slave EXPORT_OF ""
set_interface_property altera_axi4lite_slave PORT_NAME_MAP ""
set_interface_property altera_axi4lite_slave CMSIS_SVD_VARIABLES ""
set_interface_property altera_axi4lite_slave SVD_ADDRESS_GROUP ""

add_interface_port altera_axi4lite_slave s_axil_awaddr awaddr Input "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port altera_axi4lite_slave s_axil_awprot awprot Input 3
add_interface_port altera_axi4lite_slave s_axil_awvalid awvalid Input 1
add_interface_port altera_axi4lite_slave s_axil_awready awready Output 1
add_interface_port altera_axi4lite_slave s_axil_wdata wdata Input "((DATA_WIDTH-1)) - (0) + 1"
add_interface_port altera_axi4lite_slave s_axil_wstrb wstrb Input 4
add_interface_port altera_axi4lite_slave s_axil_wvalid wvalid Input 1
add_interface_port altera_axi4lite_slave s_axil_wready wready Output 1
add_interface_port altera_axi4lite_slave s_axil_bresp bresp Output 2
add_interface_port altera_axi4lite_slave s_axil_bvalid bvalid Output 1
add_interface_port altera_axi4lite_slave s_axil_bready bready Input 1
add_interface_port altera_axi4lite_slave s_axil_araddr araddr Input "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port altera_axi4lite_slave s_axil_arprot arprot Input 3
add_interface_port altera_axi4lite_slave s_axil_arvalid arvalid Input 1
add_interface_port altera_axi4lite_slave s_axil_arready arready Output 1
add_interface_port altera_axi4lite_slave s_axil_rdata rdata Output "((DATA_WIDTH-1)) - (0) + 1"
add_interface_port altera_axi4lite_slave s_axil_rresp rresp Output 2
add_interface_port altera_axi4lite_slave s_axil_rvalid rvalid Output 1
add_interface_port altera_axi4lite_slave s_axil_rready rready Input 1


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

