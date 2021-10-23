## Generated SDC file "proc_hier.sdc"

## Copyright (C) 2020  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

## DATE    "Sat Oct 23 01:47:47 2021"

##
## DEVICE  "EP4CE10F17C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {osc_clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {osc_clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -master_clock {osc_clk} [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 2 -master_clock {osc_clk} [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 2 -phase -75.000 -master_clock {osc_clk} [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}] -rise_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}] -fall_to [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path  -from  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  -to  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]
set_false_path  -from  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  -to  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]
set_false_path  -from  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[0]}]  -to  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]
set_false_path  -from  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]  -to  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]
set_false_path  -from  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[1]}]  -to  [get_clocks {pll_clk:pll_inst|altpll:altpll_component|pll_clk_altpll:auto_generated|wire_pll1_clk[2]}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

