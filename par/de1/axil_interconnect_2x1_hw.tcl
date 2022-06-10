# TCL File Generated by Component Editor 21.1
# Thu May 05 21:35:16 EDT 2022
# DO NOT MODIFY


# 
# axil_interconnect_2x1 "axil_interconnect_2x1" v1.0
#  2022.05.05.21:35:16
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module axil_interconnect_2x1
# 
set_module_property DESCRIPTION ""
set_module_property NAME axil_interconnect_2x1
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME axil_interconnect_2x1
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL axil_interconnect_2x1
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file axil_interconnect_2x1.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axil_interconnect_2x1.sv TOP_LEVEL_FILE
add_fileset_file arbiter.v VERILOG PATH ../../rtl/verilog-axi/rtl/arbiter.v
add_fileset_file axil_interconnect.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_interconnect.v


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
add_parameter STRB_WIDTH INTEGER 4
set_parameter_property STRB_WIDTH DEFAULT_VALUE 4
set_parameter_property STRB_WIDTH DISPLAY_NAME STRB_WIDTH
set_parameter_property STRB_WIDTH TYPE INTEGER
set_parameter_property STRB_WIDTH ENABLED false
set_parameter_property STRB_WIDTH UNITS None
set_parameter_property STRB_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property STRB_WIDTH HDL_PARAMETER true
add_parameter M_REGIONS INTEGER 1
set_parameter_property M_REGIONS DEFAULT_VALUE 1
set_parameter_property M_REGIONS DISPLAY_NAME M_REGIONS
set_parameter_property M_REGIONS TYPE INTEGER
set_parameter_property M_REGIONS ENABLED false
set_parameter_property M_REGIONS UNITS None
set_parameter_property M_REGIONS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M_REGIONS HDL_PARAMETER true
add_parameter M00_BASE_ADDR INTEGER 0
set_parameter_property M00_BASE_ADDR DEFAULT_VALUE 0
set_parameter_property M00_BASE_ADDR DISPLAY_NAME M00_BASE_ADDR
set_parameter_property M00_BASE_ADDR TYPE INTEGER
set_parameter_property M00_BASE_ADDR UNITS None
set_parameter_property M00_BASE_ADDR ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M00_BASE_ADDR HDL_PARAMETER true
add_parameter M00_CONNECT_READ STD_LOGIC_VECTOR 3
set_parameter_property M00_CONNECT_READ DEFAULT_VALUE 3
set_parameter_property M00_CONNECT_READ DISPLAY_NAME M00_CONNECT_READ
set_parameter_property M00_CONNECT_READ WIDTH 3
set_parameter_property M00_CONNECT_READ TYPE STD_LOGIC_VECTOR
set_parameter_property M00_CONNECT_READ ENABLED false
set_parameter_property M00_CONNECT_READ UNITS None
set_parameter_property M00_CONNECT_READ ALLOWED_RANGES 0:7
set_parameter_property M00_CONNECT_READ HDL_PARAMETER true
add_parameter M00_CONNECT_WRITE STD_LOGIC_VECTOR 3 ""
set_parameter_property M00_CONNECT_WRITE DEFAULT_VALUE 3
set_parameter_property M00_CONNECT_WRITE DISPLAY_NAME M00_CONNECT_WRITE
set_parameter_property M00_CONNECT_WRITE WIDTH 32
set_parameter_property M00_CONNECT_WRITE TYPE STD_LOGIC_VECTOR
set_parameter_property M00_CONNECT_WRITE ENABLED false
set_parameter_property M00_CONNECT_WRITE UNITS None
set_parameter_property M00_CONNECT_WRITE DESCRIPTION ""
set_parameter_property M00_CONNECT_WRITE HDL_PARAMETER true
add_parameter M00_SECURE STD_LOGIC_VECTOR 0
set_parameter_property M00_SECURE DEFAULT_VALUE 0
set_parameter_property M00_SECURE DISPLAY_NAME M00_SECURE
set_parameter_property M00_SECURE WIDTH 2
set_parameter_property M00_SECURE TYPE STD_LOGIC_VECTOR
set_parameter_property M00_SECURE ENABLED false
set_parameter_property M00_SECURE UNITS None
set_parameter_property M00_SECURE ALLOWED_RANGES 0:3
set_parameter_property M00_SECURE HDL_PARAMETER true


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
# connection point m00
# 
add_interface m00 axi4lite start
set_interface_property m00 associatedClock clock
set_interface_property m00 associatedReset reset_sink
set_interface_property m00 readIssuingCapability 1
set_interface_property m00 writeIssuingCapability 1
set_interface_property m00 combinedIssuingCapability 1
set_interface_property m00 ENABLED true
set_interface_property m00 EXPORT_OF ""
set_interface_property m00 PORT_NAME_MAP ""
set_interface_property m00 CMSIS_SVD_VARIABLES ""
set_interface_property m00 SVD_ADDRESS_GROUP ""

add_interface_port m00 m00_axil_araddr araddr Output "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port m00 m00_axil_arprot arprot Output 3
add_interface_port m00 m00_axil_arready arready Input 1
add_interface_port m00 m00_axil_arvalid arvalid Output 1
add_interface_port m00 m00_axil_awaddr awaddr Output "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port m00 m00_axil_awprot awprot Output 3
add_interface_port m00 m00_axil_awready awready Input 1
add_interface_port m00 m00_axil_awvalid awvalid Output 1
add_interface_port m00 m00_axil_bready bready Output 1
add_interface_port m00 m00_axil_bresp bresp Input 2
add_interface_port m00 m00_axil_bvalid bvalid Input 1
add_interface_port m00 m00_axil_rdata rdata Input "((DATA_WIDTH-1)) - (0) + 1"
add_interface_port m00 m00_axil_rready rready Output 1
add_interface_port m00 m00_axil_rresp rresp Input 2
add_interface_port m00 m00_axil_rvalid rvalid Input 1
add_interface_port m00 m00_axil_wdata wdata Output "((DATA_WIDTH-1)) - (0) + 1"
add_interface_port m00 m00_axil_wready wready Input 1
add_interface_port m00 m00_axil_wstrb wstrb Output "((STRB_WIDTH-1)) - (0) + 1"
add_interface_port m00 m00_axil_wvalid wvalid Output 1


# 
# connection point s00
# 
add_interface s00 axi4lite end
set_interface_property s00 associatedClock clock
set_interface_property s00 associatedReset reset_sink
set_interface_property s00 readAcceptanceCapability 1
set_interface_property s00 writeAcceptanceCapability 1
set_interface_property s00 combinedAcceptanceCapability 1
set_interface_property s00 readDataReorderingDepth 1
set_interface_property s00 bridgesToMaster ""
set_interface_property s00 ENABLED true
set_interface_property s00 EXPORT_OF ""
set_interface_property s00 PORT_NAME_MAP ""
set_interface_property s00 CMSIS_SVD_VARIABLES ""
set_interface_property s00 SVD_ADDRESS_GROUP ""

add_interface_port s00 s00_axil_araddr araddr Input "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port s00 s00_axil_arprot arprot Input 3
add_interface_port s00 s00_axil_arready arready Output 1
add_interface_port s00 s00_axil_arvalid arvalid Input 1
add_interface_port s00 s00_axil_awaddr awaddr Input "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port s00 s00_axil_awprot awprot Input 3
add_interface_port s00 s00_axil_awready awready Output 1
add_interface_port s00 s00_axil_awvalid awvalid Input 1
add_interface_port s00 s00_axil_bready bready Input 1
add_interface_port s00 s00_axil_bresp bresp Output 2
add_interface_port s00 s00_axil_bvalid bvalid Output 1
add_interface_port s00 s00_axil_rdata rdata Output "((DATA_WIDTH-1)) - (0) + 1"
add_interface_port s00 s00_axil_rready rready Input 1
add_interface_port s00 s00_axil_rresp rresp Output 2
add_interface_port s00 s00_axil_rvalid rvalid Output 1
add_interface_port s00 s00_axil_wdata wdata Input "((DATA_WIDTH-1)) - (0) + 1"
add_interface_port s00 s00_axil_wready wready Output 1
add_interface_port s00 s00_axil_wstrb wstrb Input "((STRB_WIDTH-1)) - (0) + 1"
add_interface_port s00 s00_axil_wvalid wvalid Input 1


# 
# connection point s01
# 
add_interface s01 axi4lite end
set_interface_property s01 associatedClock clock
set_interface_property s01 associatedReset reset_sink
set_interface_property s01 readAcceptanceCapability 1
set_interface_property s01 writeAcceptanceCapability 1
set_interface_property s01 combinedAcceptanceCapability 1
set_interface_property s01 readDataReorderingDepth 1
set_interface_property s01 bridgesToMaster ""
set_interface_property s01 ENABLED true
set_interface_property s01 EXPORT_OF ""
set_interface_property s01 PORT_NAME_MAP ""
set_interface_property s01 CMSIS_SVD_VARIABLES ""
set_interface_property s01 SVD_ADDRESS_GROUP ""

add_interface_port s01 s01_axil_araddr araddr Input "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port s01 s01_axil_arprot arprot Input 3
add_interface_port s01 s01_axil_arready arready Output 1
add_interface_port s01 s01_axil_arvalid arvalid Input 1
add_interface_port s01 s01_axil_awaddr awaddr Input "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port s01 s01_axil_awprot awprot Input 3
add_interface_port s01 s01_axil_awready awready Output 1
add_interface_port s01 s01_axil_awvalid awvalid Input 1
add_interface_port s01 s01_axil_bready bready Input 1
add_interface_port s01 s01_axil_bresp bresp Output 2
add_interface_port s01 s01_axil_bvalid bvalid Output 1
add_interface_port s01 s01_axil_rdata rdata Output "((DATA_WIDTH-1)) - (0) + 1"
add_interface_port s01 s01_axil_rready rready Input 1
add_interface_port s01 s01_axil_rresp rresp Output 2
add_interface_port s01 s01_axil_rvalid rvalid Output 1
add_interface_port s01 s01_axil_wdata wdata Input "((DATA_WIDTH-1)) - (0) + 1"
add_interface_port s01 s01_axil_wready wready Output 1
add_interface_port s01 s01_axil_wstrb wstrb Input "((STRB_WIDTH-1)) - (0) + 1"
add_interface_port s01 s01_axil_wvalid wvalid Input 1


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
