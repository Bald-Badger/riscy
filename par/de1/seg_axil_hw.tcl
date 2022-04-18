# TCL File Generated by Component Editor 21.1
# Sun Apr 17 20:35:25 EDT 2022
# DO NOT MODIFY


# 
# seg_axil "seg_axil" v1.0
#  2022.04.17.20:35:25
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module seg_axil
# 
set_module_property DESCRIPTION ""
set_module_property NAME seg_axil
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME seg_axil
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL seg_axil
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file hex7seg.sv SYSTEM_VERILOG PATH ../../rtl/perf/hex7seg.sv
add_fileset_file pref_defines.sv SYSTEM_VERILOG PATH ../../rtl/perf/pref_defines.sv
add_fileset_file seg_axil.sv SYSTEM_VERILOG PATH ../../rtl/perf/seg_axil.sv TOP_LEVEL_FILE
add_fileset_file defines.sv SYSTEM_VERILOG PATH ../../rtl/defines.sv
add_fileset_file mem_defines.sv SYSTEM_VERILOG PATH ../../rtl/mem/mem_defines.sv
add_fileset_file axi_defines.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_defines.sv


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
# connection point hex
# 
add_interface hex conduit end
set_interface_property hex associatedClock clock
set_interface_property hex associatedReset ""
set_interface_property hex ENABLED true
set_interface_property hex EXPORT_OF ""
set_interface_property hex PORT_NAME_MAP ""
set_interface_property hex CMSIS_SVD_VARIABLES ""
set_interface_property hex SVD_ADDRESS_GROUP ""

add_interface_port hex hex0 hex0 Output 7
add_interface_port hex hex1 hex1 Output 7
add_interface_port hex hex2 hex2 Output 7
add_interface_port hex hex3 hex3 Output 7
add_interface_port hex hex4 hex4 Output 7
add_interface_port hex hex5 hex5 Output 7


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

add_interface_port altera_axi4lite_slave cfg_araddr_i araddr Input 5
add_interface_port altera_axi4lite_slave cfg_arready_o arready Output 1
add_interface_port altera_axi4lite_slave cfg_arvalid_i arvalid Input 1
add_interface_port altera_axi4lite_slave cfg_awaddr_i awaddr Input 5
add_interface_port altera_axi4lite_slave cfg_awready_o awready Output 1
add_interface_port altera_axi4lite_slave cfg_awvalid_i awvalid Input 1
add_interface_port altera_axi4lite_slave cfg_bready_i bready Input 1
add_interface_port altera_axi4lite_slave cfg_bresp_o bresp Output 2
add_interface_port altera_axi4lite_slave cfg_bvalid_o bvalid Output 1
add_interface_port altera_axi4lite_slave cfg_rdata_o rdata Output 32
add_interface_port altera_axi4lite_slave cfg_rready_i rready Input 1
add_interface_port altera_axi4lite_slave cfg_rresp_o rresp Output 2
add_interface_port altera_axi4lite_slave cfg_rvalid_o rvalid Output 1
add_interface_port altera_axi4lite_slave cfg_wdata_i wdata Input 32
add_interface_port altera_axi4lite_slave cfg_wready_o wready Output 1
add_interface_port altera_axi4lite_slave cfg_wstrb_i wstrb Input 4
add_interface_port altera_axi4lite_slave cfg_wvalid_i wvalid Input 1
add_interface_port altera_axi4lite_slave cfg_arprot_i arprot Input 3
add_interface_port altera_axi4lite_slave cfg_awprot_i awprot Input 3

