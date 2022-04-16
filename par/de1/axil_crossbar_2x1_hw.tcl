# TCL File Generated by Component Editor 19.1
# Sat Apr 16 03:33:34 EDT 2022
# DO NOT MODIFY


# 
# axil_crossbar_2x1 "axil_crossbar_2x1" v1.0
#  2022.04.16.03:33:34
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module axil_crossbar_2x1
# 
set_module_property DESCRIPTION ""
set_module_property NAME axil_crossbar_2x1
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME axil_crossbar_2x1
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL axil_crossbar_2x1
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file axil_crossbar_2x1.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axil_crossbar_2x1.sv TOP_LEVEL_FILE
add_fileset_file axil_crossbar.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_crossbar.v
add_fileset_file axil_crossbar_addr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_crossbar_addr.v
add_fileset_file axil_crossbar_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_crossbar_rd.v
add_fileset_file axil_crossbar_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_crossbar_wr.v
add_fileset_file axil_reg_if.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_reg_if.v
add_fileset_file axil_reg_if_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_reg_if_rd.v
add_fileset_file axil_reg_if_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_reg_if_wr.v
add_fileset_file axil_register.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_register.v
add_fileset_file axil_register_rd.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_register_rd.v
add_fileset_file axil_register_wr.v VERILOG PATH ../../rtl/verilog-axi/rtl/axil_register_wr.v
add_fileset_file priority_encoder.v VERILOG PATH ../../rtl/verilog-axi/rtl/priority_encoder.v
add_fileset_file arbiter.v VERILOG PATH ../../rtl/verilog-axi/rtl/arbiter.v


# 
# parameters
# 
add_parameter DATA_WIDTH INTEGER 32 ""
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH WIDTH ""
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATA_WIDTH DESCRIPTION ""
set_parameter_property DATA_WIDTH HDL_PARAMETER true
add_parameter ADDR_WIDTH INTEGER 32
set_parameter_property ADDR_WIDTH DEFAULT_VALUE 32
set_parameter_property ADDR_WIDTH DISPLAY_NAME ADDR_WIDTH
set_parameter_property ADDR_WIDTH TYPE INTEGER
set_parameter_property ADDR_WIDTH UNITS None
set_parameter_property ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADDR_WIDTH HDL_PARAMETER true
add_parameter S00_ACCEPT INTEGER 16
set_parameter_property S00_ACCEPT DEFAULT_VALUE 16
set_parameter_property S00_ACCEPT DISPLAY_NAME S00_ACCEPT
set_parameter_property S00_ACCEPT TYPE INTEGER
set_parameter_property S00_ACCEPT UNITS None
set_parameter_property S00_ACCEPT ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S00_ACCEPT HDL_PARAMETER true
add_parameter S01_ACCEPT INTEGER 16
set_parameter_property S01_ACCEPT DEFAULT_VALUE 16
set_parameter_property S01_ACCEPT DISPLAY_NAME S01_ACCEPT
set_parameter_property S01_ACCEPT TYPE INTEGER
set_parameter_property S01_ACCEPT UNITS None
set_parameter_property S01_ACCEPT ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S01_ACCEPT HDL_PARAMETER true
add_parameter M_REGIONS INTEGER 1
set_parameter_property M_REGIONS DEFAULT_VALUE 1
set_parameter_property M_REGIONS DISPLAY_NAME M_REGIONS
set_parameter_property M_REGIONS TYPE INTEGER
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
add_parameter M00_ADDR_WIDTH STD_LOGIC_VECTOR 32
set_parameter_property M00_ADDR_WIDTH DEFAULT_VALUE 32
set_parameter_property M00_ADDR_WIDTH DISPLAY_NAME M00_ADDR_WIDTH
set_parameter_property M00_ADDR_WIDTH TYPE STD_LOGIC_VECTOR
set_parameter_property M00_ADDR_WIDTH UNITS None
set_parameter_property M00_ADDR_WIDTH ALLOWED_RANGES 0:17179869183
set_parameter_property M00_ADDR_WIDTH HDL_PARAMETER true
add_parameter M00_CONNECT_READ STD_LOGIC_VECTOR 3
set_parameter_property M00_CONNECT_READ DEFAULT_VALUE 3
set_parameter_property M00_CONNECT_READ DISPLAY_NAME M00_CONNECT_READ
set_parameter_property M00_CONNECT_READ WIDTH 3
set_parameter_property M00_CONNECT_READ TYPE STD_LOGIC_VECTOR
set_parameter_property M00_CONNECT_READ UNITS None
set_parameter_property M00_CONNECT_READ ALLOWED_RANGES 0:7
set_parameter_property M00_CONNECT_READ HDL_PARAMETER true
add_parameter M00_CONNECT_WRITE STD_LOGIC_VECTOR 3
set_parameter_property M00_CONNECT_WRITE DEFAULT_VALUE 3
set_parameter_property M00_CONNECT_WRITE DISPLAY_NAME M00_CONNECT_WRITE
set_parameter_property M00_CONNECT_WRITE WIDTH 3
set_parameter_property M00_CONNECT_WRITE TYPE STD_LOGIC_VECTOR
set_parameter_property M00_CONNECT_WRITE UNITS None
set_parameter_property M00_CONNECT_WRITE ALLOWED_RANGES 0:7
set_parameter_property M00_CONNECT_WRITE HDL_PARAMETER true
add_parameter M00_ISSUE INTEGER 16
set_parameter_property M00_ISSUE DEFAULT_VALUE 16
set_parameter_property M00_ISSUE DISPLAY_NAME M00_ISSUE
set_parameter_property M00_ISSUE TYPE INTEGER
set_parameter_property M00_ISSUE UNITS None
set_parameter_property M00_ISSUE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M00_ISSUE HDL_PARAMETER true
add_parameter M00_SECURE INTEGER 0
set_parameter_property M00_SECURE DEFAULT_VALUE 0
set_parameter_property M00_SECURE DISPLAY_NAME M00_SECURE
set_parameter_property M00_SECURE TYPE INTEGER
set_parameter_property M00_SECURE UNITS None
set_parameter_property M00_SECURE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M00_SECURE HDL_PARAMETER true
add_parameter S00_AW_REG_TYPE INTEGER 0
set_parameter_property S00_AW_REG_TYPE DEFAULT_VALUE 0
set_parameter_property S00_AW_REG_TYPE DISPLAY_NAME S00_AW_REG_TYPE
set_parameter_property S00_AW_REG_TYPE TYPE INTEGER
set_parameter_property S00_AW_REG_TYPE UNITS None
set_parameter_property S00_AW_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S00_AW_REG_TYPE HDL_PARAMETER true
add_parameter S00_W_REG_TYPE INTEGER 0
set_parameter_property S00_W_REG_TYPE DEFAULT_VALUE 0
set_parameter_property S00_W_REG_TYPE DISPLAY_NAME S00_W_REG_TYPE
set_parameter_property S00_W_REG_TYPE TYPE INTEGER
set_parameter_property S00_W_REG_TYPE UNITS None
set_parameter_property S00_W_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S00_W_REG_TYPE HDL_PARAMETER true
add_parameter S00_B_REG_TYPE INTEGER 1
set_parameter_property S00_B_REG_TYPE DEFAULT_VALUE 1
set_parameter_property S00_B_REG_TYPE DISPLAY_NAME S00_B_REG_TYPE
set_parameter_property S00_B_REG_TYPE TYPE INTEGER
set_parameter_property S00_B_REG_TYPE UNITS None
set_parameter_property S00_B_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S00_B_REG_TYPE HDL_PARAMETER true
add_parameter S00_AR_REG_TYPE INTEGER 0
set_parameter_property S00_AR_REG_TYPE DEFAULT_VALUE 0
set_parameter_property S00_AR_REG_TYPE DISPLAY_NAME S00_AR_REG_TYPE
set_parameter_property S00_AR_REG_TYPE TYPE INTEGER
set_parameter_property S00_AR_REG_TYPE UNITS None
set_parameter_property S00_AR_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S00_AR_REG_TYPE HDL_PARAMETER true
add_parameter S00_R_REG_TYPE INTEGER 2
set_parameter_property S00_R_REG_TYPE DEFAULT_VALUE 2
set_parameter_property S00_R_REG_TYPE DISPLAY_NAME S00_R_REG_TYPE
set_parameter_property S00_R_REG_TYPE TYPE INTEGER
set_parameter_property S00_R_REG_TYPE UNITS None
set_parameter_property S00_R_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S00_R_REG_TYPE HDL_PARAMETER true
add_parameter S01_AW_REG_TYPE INTEGER 0
set_parameter_property S01_AW_REG_TYPE DEFAULT_VALUE 0
set_parameter_property S01_AW_REG_TYPE DISPLAY_NAME S01_AW_REG_TYPE
set_parameter_property S01_AW_REG_TYPE TYPE INTEGER
set_parameter_property S01_AW_REG_TYPE UNITS None
set_parameter_property S01_AW_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S01_AW_REG_TYPE HDL_PARAMETER true
add_parameter S01_W_REG_TYPE INTEGER 0
set_parameter_property S01_W_REG_TYPE DEFAULT_VALUE 0
set_parameter_property S01_W_REG_TYPE DISPLAY_NAME S01_W_REG_TYPE
set_parameter_property S01_W_REG_TYPE TYPE INTEGER
set_parameter_property S01_W_REG_TYPE UNITS None
set_parameter_property S01_W_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S01_W_REG_TYPE HDL_PARAMETER true
add_parameter S01_B_REG_TYPE INTEGER 1
set_parameter_property S01_B_REG_TYPE DEFAULT_VALUE 1
set_parameter_property S01_B_REG_TYPE DISPLAY_NAME S01_B_REG_TYPE
set_parameter_property S01_B_REG_TYPE TYPE INTEGER
set_parameter_property S01_B_REG_TYPE UNITS None
set_parameter_property S01_B_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S01_B_REG_TYPE HDL_PARAMETER true
add_parameter S01_AR_REG_TYPE INTEGER 0
set_parameter_property S01_AR_REG_TYPE DEFAULT_VALUE 0
set_parameter_property S01_AR_REG_TYPE DISPLAY_NAME S01_AR_REG_TYPE
set_parameter_property S01_AR_REG_TYPE TYPE INTEGER
set_parameter_property S01_AR_REG_TYPE UNITS None
set_parameter_property S01_AR_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S01_AR_REG_TYPE HDL_PARAMETER true
add_parameter S01_R_REG_TYPE INTEGER 2
set_parameter_property S01_R_REG_TYPE DEFAULT_VALUE 2
set_parameter_property S01_R_REG_TYPE DISPLAY_NAME S01_R_REG_TYPE
set_parameter_property S01_R_REG_TYPE TYPE INTEGER
set_parameter_property S01_R_REG_TYPE UNITS None
set_parameter_property S01_R_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property S01_R_REG_TYPE HDL_PARAMETER true
add_parameter M00_AW_REG_TYPE INTEGER 1
set_parameter_property M00_AW_REG_TYPE DEFAULT_VALUE 1
set_parameter_property M00_AW_REG_TYPE DISPLAY_NAME M00_AW_REG_TYPE
set_parameter_property M00_AW_REG_TYPE TYPE INTEGER
set_parameter_property M00_AW_REG_TYPE UNITS None
set_parameter_property M00_AW_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M00_AW_REG_TYPE HDL_PARAMETER true
add_parameter M00_W_REG_TYPE INTEGER 2
set_parameter_property M00_W_REG_TYPE DEFAULT_VALUE 2
set_parameter_property M00_W_REG_TYPE DISPLAY_NAME M00_W_REG_TYPE
set_parameter_property M00_W_REG_TYPE TYPE INTEGER
set_parameter_property M00_W_REG_TYPE UNITS None
set_parameter_property M00_W_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M00_W_REG_TYPE HDL_PARAMETER true
add_parameter M00_B_REG_TYPE INTEGER 0
set_parameter_property M00_B_REG_TYPE DEFAULT_VALUE 0
set_parameter_property M00_B_REG_TYPE DISPLAY_NAME M00_B_REG_TYPE
set_parameter_property M00_B_REG_TYPE TYPE INTEGER
set_parameter_property M00_B_REG_TYPE UNITS None
set_parameter_property M00_B_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M00_B_REG_TYPE HDL_PARAMETER true
add_parameter M00_AR_REG_TYPE INTEGER 1
set_parameter_property M00_AR_REG_TYPE DEFAULT_VALUE 1
set_parameter_property M00_AR_REG_TYPE DISPLAY_NAME M00_AR_REG_TYPE
set_parameter_property M00_AR_REG_TYPE TYPE INTEGER
set_parameter_property M00_AR_REG_TYPE UNITS None
set_parameter_property M00_AR_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M00_AR_REG_TYPE HDL_PARAMETER true
add_parameter M00_R_REG_TYPE INTEGER 0
set_parameter_property M00_R_REG_TYPE DEFAULT_VALUE 0
set_parameter_property M00_R_REG_TYPE DISPLAY_NAME M00_R_REG_TYPE
set_parameter_property M00_R_REG_TYPE TYPE INTEGER
set_parameter_property M00_R_REG_TYPE UNITS None
set_parameter_property M00_R_REG_TYPE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property M00_R_REG_TYPE HDL_PARAMETER true


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
# connection point altera_axi4lite_slave_0
# 
add_interface altera_axi4lite_slave_0 axi4lite end
set_interface_property altera_axi4lite_slave_0 associatedClock clock
set_interface_property altera_axi4lite_slave_0 associatedReset reset_sink
set_interface_property altera_axi4lite_slave_0 readAcceptanceCapability 1
set_interface_property altera_axi4lite_slave_0 writeAcceptanceCapability 1
set_interface_property altera_axi4lite_slave_0 combinedAcceptanceCapability 1
set_interface_property altera_axi4lite_slave_0 readDataReorderingDepth 1
set_interface_property altera_axi4lite_slave_0 bridgesToMaster ""
set_interface_property altera_axi4lite_slave_0 ENABLED true
set_interface_property altera_axi4lite_slave_0 EXPORT_OF ""
set_interface_property altera_axi4lite_slave_0 PORT_NAME_MAP ""
set_interface_property altera_axi4lite_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property altera_axi4lite_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port altera_axi4lite_slave_0 s00_axil_araddr araddr Input ADDR_WIDTH
add_interface_port altera_axi4lite_slave_0 s00_axil_arprot arprot Input 3
add_interface_port altera_axi4lite_slave_0 s00_axil_arready arready Output 1
add_interface_port altera_axi4lite_slave_0 s00_axil_arvalid arvalid Input 1
add_interface_port altera_axi4lite_slave_0 s00_axil_awaddr awaddr Input ADDR_WIDTH
add_interface_port altera_axi4lite_slave_0 s00_axil_awprot awprot Input 3
add_interface_port altera_axi4lite_slave_0 s00_axil_awready awready Output 1
add_interface_port altera_axi4lite_slave_0 s00_axil_awvalid awvalid Input 1
add_interface_port altera_axi4lite_slave_0 s00_axil_bready bready Input 1
add_interface_port altera_axi4lite_slave_0 s00_axil_bresp bresp Output 2
add_interface_port altera_axi4lite_slave_0 s00_axil_bvalid bvalid Output 1
add_interface_port altera_axi4lite_slave_0 s00_axil_rdata rdata Output DATA_WIDTH
add_interface_port altera_axi4lite_slave_0 s00_axil_rready rready Input 1
add_interface_port altera_axi4lite_slave_0 s00_axil_rresp rresp Output 2
add_interface_port altera_axi4lite_slave_0 s00_axil_rvalid rvalid Output 1
add_interface_port altera_axi4lite_slave_0 s00_axil_wdata wdata Input DATA_WIDTH
add_interface_port altera_axi4lite_slave_0 s00_axil_wready wready Output 1
add_interface_port altera_axi4lite_slave_0 s00_axil_wstrb wstrb Input 4
add_interface_port altera_axi4lite_slave_0 s00_axil_wvalid wvalid Input 1


# 
# connection point altera_axi4lite_slave_1
# 
add_interface altera_axi4lite_slave_1 axi4lite end
set_interface_property altera_axi4lite_slave_1 associatedClock clock
set_interface_property altera_axi4lite_slave_1 associatedReset reset_sink
set_interface_property altera_axi4lite_slave_1 readAcceptanceCapability 1
set_interface_property altera_axi4lite_slave_1 writeAcceptanceCapability 1
set_interface_property altera_axi4lite_slave_1 combinedAcceptanceCapability 1
set_interface_property altera_axi4lite_slave_1 readDataReorderingDepth 1
set_interface_property altera_axi4lite_slave_1 bridgesToMaster ""
set_interface_property altera_axi4lite_slave_1 ENABLED true
set_interface_property altera_axi4lite_slave_1 EXPORT_OF ""
set_interface_property altera_axi4lite_slave_1 PORT_NAME_MAP ""
set_interface_property altera_axi4lite_slave_1 CMSIS_SVD_VARIABLES ""
set_interface_property altera_axi4lite_slave_1 SVD_ADDRESS_GROUP ""

add_interface_port altera_axi4lite_slave_1 s01_axil_araddr araddr Input ADDR_WIDTH
add_interface_port altera_axi4lite_slave_1 s01_axil_arprot arprot Input 3
add_interface_port altera_axi4lite_slave_1 s01_axil_arready arready Output 1
add_interface_port altera_axi4lite_slave_1 s01_axil_arvalid arvalid Input 1
add_interface_port altera_axi4lite_slave_1 s01_axil_awaddr awaddr Input ADDR_WIDTH
add_interface_port altera_axi4lite_slave_1 s01_axil_awprot awprot Input 3
add_interface_port altera_axi4lite_slave_1 s01_axil_awready awready Output 1
add_interface_port altera_axi4lite_slave_1 s01_axil_awvalid awvalid Input 1
add_interface_port altera_axi4lite_slave_1 s01_axil_bready bready Input 1
add_interface_port altera_axi4lite_slave_1 s01_axil_bresp bresp Output 2
add_interface_port altera_axi4lite_slave_1 s01_axil_bvalid bvalid Output 1
add_interface_port altera_axi4lite_slave_1 s01_axil_rdata rdata Output DATA_WIDTH
add_interface_port altera_axi4lite_slave_1 s01_axil_rready rready Input 1
add_interface_port altera_axi4lite_slave_1 s01_axil_rresp rresp Output 2
add_interface_port altera_axi4lite_slave_1 s01_axil_rvalid rvalid Output 1
add_interface_port altera_axi4lite_slave_1 s01_axil_wdata wdata Input DATA_WIDTH
add_interface_port altera_axi4lite_slave_1 s01_axil_wready wready Output 1
add_interface_port altera_axi4lite_slave_1 s01_axil_wstrb wstrb Input 4
add_interface_port altera_axi4lite_slave_1 s01_axil_wvalid wvalid Input 1


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

add_interface_port altera_axi4lite_master m00_axil_araddr araddr Output ADDR_WIDTH
add_interface_port altera_axi4lite_master m00_axil_arprot arprot Output 3
add_interface_port altera_axi4lite_master m00_axil_arready arready Input 1
add_interface_port altera_axi4lite_master m00_axil_arvalid arvalid Output 1
add_interface_port altera_axi4lite_master m00_axil_awaddr awaddr Output ADDR_WIDTH
add_interface_port altera_axi4lite_master m00_axil_awprot awprot Output 3
add_interface_port altera_axi4lite_master m00_axil_awready awready Input 1
add_interface_port altera_axi4lite_master m00_axil_awvalid awvalid Output 1
add_interface_port altera_axi4lite_master m00_axil_bready bready Output 1
add_interface_port altera_axi4lite_master m00_axil_bresp bresp Input 2
add_interface_port altera_axi4lite_master m00_axil_bvalid bvalid Input 1
add_interface_port altera_axi4lite_master m00_axil_rdata rdata Input DATA_WIDTH
add_interface_port altera_axi4lite_master m00_axil_rready rready Output 1
add_interface_port altera_axi4lite_master m00_axil_rresp rresp Input 2
add_interface_port altera_axi4lite_master m00_axil_rvalid rvalid Input 1
add_interface_port altera_axi4lite_master m00_axil_wdata wdata Output DATA_WIDTH
add_interface_port altera_axi4lite_master m00_axil_wready wready Input 1
add_interface_port altera_axi4lite_master m00_axil_wstrb wstrb Output 4
add_interface_port altera_axi4lite_master m00_axil_wvalid wvalid Output 1


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

