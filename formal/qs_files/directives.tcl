# Define clocks
netlist clock clk -period 20

# Constrain rst
netlist constraint rst_n -value 1'b1 -after_init
