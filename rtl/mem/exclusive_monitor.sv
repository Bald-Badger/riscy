import defines::*;

module exclusive_monitor (
    input   instr_t instr
);

    logic set_valid, clear_valid
    data_t store_addr;
    
endmodule : exclusive_monitor

// TODO: constraint: ld must followed by a st at same addr, ld must not followed by another ld
