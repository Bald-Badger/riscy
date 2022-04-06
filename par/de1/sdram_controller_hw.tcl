# TCL File Generated by Component Editor 21.1
# Tue Apr 05 22:28:01 EDT 2022
# DO NOT MODIFY


# 
# sdram_controller "sdram_controller" v1.0
#  2022.04.05.22:28:01
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module sdram_controller
# 
set_module_property DESCRIPTION ""
set_module_property NAME sdram_controller
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME sdram_controller
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sdram_axi_qsys
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sdr.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdr.sv
add_fileset_file sdr_parameters.svh SYSTEM_VERILOG_INCLUDE PATH ../../rtl/mem/sdram/sdr_parameters.svh
add_fileset_file sdram_axi.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdram_axi.sv
add_fileset_file sdram_axi_core.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdram_axi_core.sv
add_fileset_file sdram_axi_pmem.v VERILOG PATH ../../rtl/mem/sdram/sdram_axi_pmem.v
add_fileset_file sdram_axi_qsys.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdram_axi_qsys.sv TOP_LEVEL_FILE
add_fileset_file sdram_axi_wrapper.sv SYSTEM_VERILOG PATH ../../rtl/mem/sdram/sdram_axi_wrapper.sv
add_fileset_file mem_defines.sv SYSTEM_VERILOG PATH ../../rtl/mem/mem_defines.sv
add_fileset_file defines.sv SYSTEM_VERILOG PATH ../../rtl/defines.sv
add_fileset_file axi_defines.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_defines.sv
add_fileset_file axi_interface.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_interface.sv
add_fileset_file axi_lite_interface.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_lite_interface.sv
add_fileset_file sdram_interface.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/sdram_interface.sv
add_fileset_file iobuf.v VERILOG PATH ../../rtl/base/iobuf.v


# 
# parameters
# 
add_parameter SDRAM_MHZ INTEGER 50
set_parameter_property SDRAM_MHZ DEFAULT_VALUE 50
set_parameter_property SDRAM_MHZ DISPLAY_NAME SDRAM_MHZ
set_parameter_property SDRAM_MHZ TYPE INTEGER
set_parameter_property SDRAM_MHZ UNITS None
set_parameter_property SDRAM_MHZ ALLOWED_RANGES -2147483648:2147483647
set_parameter_property SDRAM_MHZ HDL_PARAMETER true
add_parameter SDRAM_ADDR_W INTEGER 25
set_parameter_property SDRAM_ADDR_W DEFAULT_VALUE 25
set_parameter_property SDRAM_ADDR_W DISPLAY_NAME SDRAM_ADDR_W
set_parameter_property SDRAM_ADDR_W TYPE INTEGER
set_parameter_property SDRAM_ADDR_W ENABLED false
set_parameter_property SDRAM_ADDR_W UNITS None
set_parameter_property SDRAM_ADDR_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property SDRAM_ADDR_W HDL_PARAMETER true
add_parameter SDRAM_COL_W INTEGER 10
set_parameter_property SDRAM_COL_W DEFAULT_VALUE 10
set_parameter_property SDRAM_COL_W DISPLAY_NAME SDRAM_COL_W
set_parameter_property SDRAM_COL_W TYPE INTEGER
set_parameter_property SDRAM_COL_W ENABLED false
set_parameter_property SDRAM_COL_W UNITS None
set_parameter_property SDRAM_COL_W ALLOWED_RANGES -2147483648:2147483647
set_parameter_property SDRAM_COL_W HDL_PARAMETER true
add_parameter SDRAM_READ_LATENCY INTEGER 2
set_parameter_property SDRAM_READ_LATENCY DEFAULT_VALUE 2
set_parameter_property SDRAM_READ_LATENCY DISPLAY_NAME SDRAM_READ_LATENCY
set_parameter_property SDRAM_READ_LATENCY TYPE INTEGER
set_parameter_property SDRAM_READ_LATENCY UNITS None
set_parameter_property SDRAM_READ_LATENCY ALLOWED_RANGES -2147483648:2147483647
set_parameter_property SDRAM_READ_LATENCY HDL_PARAMETER true


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
# connection point altera_axi4_slave
# 
add_interface altera_axi4_slave axi4 end
set_interface_property altera_axi4_slave associatedClock clock
set_interface_property altera_axi4_slave associatedReset reset_sink
set_interface_property altera_axi4_slave readAcceptanceCapability 1
set_interface_property altera_axi4_slave writeAcceptanceCapability 1
set_interface_property altera_axi4_slave combinedAcceptanceCapability 1
set_interface_property altera_axi4_slave readDataReorderingDepth 1
set_interface_property altera_axi4_slave bridgesToMaster ""
set_interface_property altera_axi4_slave ENABLED true
set_interface_property altera_axi4_slave EXPORT_OF ""
set_interface_property altera_axi4_slave PORT_NAME_MAP ""
set_interface_property altera_axi4_slave CMSIS_SVD_VARIABLES ""
set_interface_property altera_axi4_slave SVD_ADDRESS_GROUP ""

add_interface_port altera_axi4_slave axi_awvalid awvalid Input 1
add_interface_port altera_axi4_slave axi_awaddr awaddr Input 26
add_interface_port altera_axi4_slave axi_awid awid Input 18
add_interface_port altera_axi4_slave axi_awlen awlen Input 8
add_interface_port altera_axi4_slave axi_awburst awburst Input 2
add_interface_port altera_axi4_slave axi_wvalid wvalid Input 1
add_interface_port altera_axi4_slave axi_wdata wdata Input 32
add_interface_port altera_axi4_slave axi_wstrb wstrb Input 4
add_interface_port altera_axi4_slave axi_wlast wlast Input 1
add_interface_port altera_axi4_slave axi_bready bready Input 1
add_interface_port altera_axi4_slave axi_arvalid arvalid Input 1
add_interface_port altera_axi4_slave axi_araddr araddr Input 26
add_interface_port altera_axi4_slave axi_arid arid Input 18
add_interface_port altera_axi4_slave axi_arlen arlen Input 8
add_interface_port altera_axi4_slave axi_arburst arburst Input 2
add_interface_port altera_axi4_slave axi_rready rready Input 1
add_interface_port altera_axi4_slave axi_awready awready Output 1
add_interface_port altera_axi4_slave axi_wready wready Output 1
add_interface_port altera_axi4_slave axi_bvalid bvalid Output 1
add_interface_port altera_axi4_slave axi_bresp bresp Output 2
add_interface_port altera_axi4_slave axi_bid bid Output 18
add_interface_port altera_axi4_slave axi_arready arready Output 1
add_interface_port altera_axi4_slave axi_rvalid rvalid Output 1
add_interface_port altera_axi4_slave axi_rdata rdata Output 32
add_interface_port altera_axi4_slave axi_rresp rresp Output 2
add_interface_port altera_axi4_slave axi_rid rid Output 18
add_interface_port altera_axi4_slave axi_rlast rlast Output 1
add_interface_port altera_axi4_slave axi_awsize awsize Input 3
add_interface_port altera_axi4_slave axi_arsize arsize Input 3


# 
# connection point sdram
# 
add_interface sdram conduit end
set_interface_property sdram associatedClock clock
set_interface_property sdram associatedReset ""
set_interface_property sdram ENABLED true
set_interface_property sdram EXPORT_OF ""
set_interface_property sdram PORT_NAME_MAP ""
set_interface_property sdram CMSIS_SVD_VARIABLES ""
set_interface_property sdram SVD_ADDRESS_GROUP ""

add_interface_port sdram sdram_clk clk Output 1
add_interface_port sdram sdram_cs_n cs_n Output 1
add_interface_port sdram sdram_dq dq Bidir 16
add_interface_port sdram sdram_dqm dqm Output 2
add_interface_port sdram sdram_ras_n ras_n Output 1
add_interface_port sdram sdram_we_n we_n Output 1
add_interface_port sdram sdram_addr addr Output 13
add_interface_port sdram sdram_ba ba Output 2
add_interface_port sdram sdram_cas_n cas_n Output 1
add_interface_port sdram sdram_cke cke Output 1


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

