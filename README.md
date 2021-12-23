# riscy
 a wild risc-v core appeared

## project structure:
 ./doc: all project specs and references  
 ./ref: the golen reference RISCV model forked from https://github.com/ultraembedded/core_uriscv  
 ./rtl: all verilog source file  
    ./rtl/eda: altera eda file for simulation  
    ./rtl/proc_hier.sv: top level module under TB  
    ./rtl/defines.sv: project parameters and macros  
 ./sim: simulation scripts and supporting submodules  
 ./formal: formal verification scripts and files  
