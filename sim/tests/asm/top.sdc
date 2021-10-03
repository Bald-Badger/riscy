create_clock -period "50MHz" [get_ports osc_clk] 
derive_pll_clocks
derive_clock_uncertainty