# TCL File Generated by Component Editor 21.1
# Thu May 05 23:31:18 EDT 2022
# DO NOT MODIFY


# 
# uart_axil "uart_axil" v1.0
#  2022.05.05.23:31:18
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module uart_axil
# 
set_module_property DESCRIPTION ""
set_module_property NAME uart_axil
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME uart_axil
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL uart_axil
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file uart.sv SYSTEM_VERILOG PATH ../../rtl/perf/uart_axil/uart.sv
add_fileset_file uart_axil.sv SYSTEM_VERILOG PATH ../../rtl/perf/uart_axil/uart_axil.sv TOP_LEVEL_FILE
add_fileset_file uart_rx.sv SYSTEM_VERILOG PATH ../../rtl/perf/uart_axil/uart_rx.sv
add_fileset_file uart_tx.sv SYSTEM_VERILOG PATH ../../rtl/perf/uart_axil/uart_tx.sv
add_fileset_file pref_defines.sv SYSTEM_VERILOG PATH ../../rtl/perf/pref_defines.sv
add_fileset_file defines.sv SYSTEM_VERILOG PATH ../../rtl/defines.sv
add_fileset_file axi_defines.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axi_defines.sv
add_fileset_file mem_defines.sv SYSTEM_VERILOG PATH ../../rtl/mem/mem_defines.sv
add_fileset_file axil2simp.sv SYSTEM_VERILOG PATH ../../rtl/mem/axil2simp.sv
add_fileset_file uart_axil_wrapper.sv SYSTEM_VERILOG PATH ../../rtl/perf/uart_axil/uart_axil_wrapper.sv
add_fileset_file uart_monitor.sv SYSTEM_VERILOG PATH ../../rtl/perf/uart_axil/uart_monitor.sv
add_fileset_file axil_interface.sv SYSTEM_VERILOG PATH ../../rtl/interconnect/axil_interface.sv


# 
# parameters
# 
add_parameter CLK_FREQ INTEGER 50000000
set_parameter_property CLK_FREQ DEFAULT_VALUE 50000000
set_parameter_property CLK_FREQ DISPLAY_NAME CLK_FREQ
set_parameter_property CLK_FREQ TYPE INTEGER
set_parameter_property CLK_FREQ UNITS None
set_parameter_property CLK_FREQ ALLOWED_RANGES -2147483648:2147483647
set_parameter_property CLK_FREQ HDL_PARAMETER true
add_parameter UART_BPS INTEGER 9600
set_parameter_property UART_BPS DEFAULT_VALUE 9600
set_parameter_property UART_BPS DISPLAY_NAME UART_BPS
set_parameter_property UART_BPS TYPE INTEGER
set_parameter_property UART_BPS UNITS None
set_parameter_property UART_BPS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property UART_BPS HDL_PARAMETER true
add_parameter FIFO_WIDTH_TX INTEGER 10
set_parameter_property FIFO_WIDTH_TX DEFAULT_VALUE 10
set_parameter_property FIFO_WIDTH_TX DISPLAY_NAME FIFO_WIDTH_TX
set_parameter_property FIFO_WIDTH_TX TYPE INTEGER
set_parameter_property FIFO_WIDTH_TX UNITS None
set_parameter_property FIFO_WIDTH_TX ALLOWED_RANGES -2147483648:2147483647
set_parameter_property FIFO_WIDTH_TX HDL_PARAMETER true
add_parameter FIFO_WIDTH_RX INTEGER 5
set_parameter_property FIFO_WIDTH_RX DEFAULT_VALUE 5
set_parameter_property FIFO_WIDTH_RX DISPLAY_NAME FIFO_WIDTH_RX
set_parameter_property FIFO_WIDTH_RX TYPE INTEGER
set_parameter_property FIFO_WIDTH_RX UNITS None
set_parameter_property FIFO_WIDTH_RX ALLOWED_RANGES -2147483648:2147483647
set_parameter_property FIFO_WIDTH_RX HDL_PARAMETER true
add_parameter ADDR_WIDTH INTEGER 4
set_parameter_property ADDR_WIDTH DEFAULT_VALUE 4
set_parameter_property ADDR_WIDTH DISPLAY_NAME ADDR_WIDTH
set_parameter_property ADDR_WIDTH TYPE INTEGER
set_parameter_property ADDR_WIDTH UNITS None
set_parameter_property ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADDR_WIDTH HDL_PARAMETER true


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
# connection point axil_uart_interface
# 
add_interface axil_uart_interface axi4lite end
set_interface_property axil_uart_interface associatedClock clock
set_interface_property axil_uart_interface associatedReset reset_sink
set_interface_property axil_uart_interface readAcceptanceCapability 1
set_interface_property axil_uart_interface writeAcceptanceCapability 1
set_interface_property axil_uart_interface combinedAcceptanceCapability 1
set_interface_property axil_uart_interface readDataReorderingDepth 1
set_interface_property axil_uart_interface bridgesToMaster ""
set_interface_property axil_uart_interface ENABLED true
set_interface_property axil_uart_interface EXPORT_OF ""
set_interface_property axil_uart_interface PORT_NAME_MAP ""
set_interface_property axil_uart_interface CMSIS_SVD_VARIABLES ""
set_interface_property axil_uart_interface SVD_ADDRESS_GROUP ""

add_interface_port axil_uart_interface araddr_i araddr Input "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port axil_uart_interface arprot_i arprot Input 3
add_interface_port axil_uart_interface arready_o arready Output 1
add_interface_port axil_uart_interface arvalid_i arvalid Input 1
add_interface_port axil_uart_interface awaddr_i awaddr Input "((ADDR_WIDTH-1)) - (0) + 1"
add_interface_port axil_uart_interface awprot_i awprot Input 3
add_interface_port axil_uart_interface awready_o awready Output 1
add_interface_port axil_uart_interface awvalid_i awvalid Input 1
add_interface_port axil_uart_interface bready_i bready Input 1
add_interface_port axil_uart_interface bresp_o bresp Output 2
add_interface_port axil_uart_interface bvalid_o bvalid Output 1
add_interface_port axil_uart_interface rdata_o rdata Output 32
add_interface_port axil_uart_interface rready_i rready Input 1
add_interface_port axil_uart_interface rresp_o rresp Output 2
add_interface_port axil_uart_interface rvalid_o rvalid Output 1
add_interface_port axil_uart_interface wdata_i wdata Input 32
add_interface_port axil_uart_interface wready_o wready Output 1
add_interface_port axil_uart_interface wstrb_i wstrb Input 4
add_interface_port axil_uart_interface wvalid_i wvalid Input 1


# 
# connection point uart
# 
add_interface uart conduit end
set_interface_property uart associatedClock clock
set_interface_property uart associatedReset ""
set_interface_property uart ENABLED true
set_interface_property uart EXPORT_OF ""
set_interface_property uart PORT_NAME_MAP ""
set_interface_property uart CMSIS_SVD_VARIABLES ""
set_interface_property uart SVD_ADDRESS_GROUP ""

add_interface_port uart uart_cts cts Input 1
add_interface_port uart uart_rts rts Output 1
add_interface_port uart uart_rx rx Input 1
add_interface_port uart uart_tx tx Output 1

