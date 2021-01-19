`ifndef _opceode_vh_
`define _opceode_vh_

    `define XLEN    32

// Funt3 define
    // R type funt3
    `define ADD     3'b000
    `define SUB     3'b000
    `define AND     3'b111
    `define OR      3'b110
    `define XOR     3'b100
    `define SLT     3'b010      // set less than, rd <= 1 if rs1 < rs2
    `define SLTU    3'b011      // set less than unsigned, rd <= 1 if rs1 < rs2
    `define SLL     3'b001      // logical shift left
    `define SRL     3'b101      // logical shift right
    `define SRA     3'b101      // arithmetic shift right

    // I type funt3
    `define ADDI    3'b000
    `define ANDI    3'b111
    `define ORI     3'b110
    `define XORI    3'b100
    `define SLTI    3'b010      // Set less than immediate, rd <= 1 if rs1 < imm
    `define SLTIU   3'b011      // Set less than immediate unsigned, rd <= 1 if rs1 < imm
    `define SLLI    3'b001      // logical shift left imm
    `define SRLI    3'b101      // logical shift right imm
    `define SRAI    3'b101      // arithmetic shift right imm

    // B type funt3
    `define BEQ     3'b000      // branch if rs1 == rs2
    `define BNE     3'b001      // branch if rs1 != rs2
    `define BLT     3'b100      // branch if rs1 < rs2 signed
    `define BLTU    3'b110      // branch if rs1 < rs2 unsigned
    `define BGE     3'b101      // branch if rs1 >= rs2 signed
    `define BGEU    3'b111      // branch if rs1 >= rs2 unsigned

    // U type have no funt3 
    //`define LUI     3'b000    // rd <= {imm, 12'b0}
    //`define AUIPC   3'b000    // pc, rd <= (pc_of_auipc + {imm, 12'b0})

    // J type have no funt3
    //`define JAL     3'b000    // jump and link, rd <= pc_of_jal + 4, pc <= (pc_of_jal + imm)
    //`define JALR    3'b000    // jump and link registor, rd <= (pc_of_jalr + 4),  pc <= (rs1 + imm) && 0xfffE (set the last bit is always 0)

    // S type funt3 - Load
    `define LB      3'b000
    `define LH      3'b001
    `define LW      3'b010
    `define LBU     3'b100
    `define LHU     3'b101

    // S type funt3 - Store
    `define SB      3'b000
    `define SH      3'b001
    `define SW      3'b010
    //`define SBU     3'b100 not used
    //`define SHU     3'b101 not used

    // Fence (Memory ordering) funt3
    `define FENCE   3'b000

    // System enviornment call and breakpoint
    `define ECALL   3'b000
    `define EBREAK  3'b000


// Opcode define
    `define R       7'b0110011
    `define I       7'b0010011
    `define B       7'b1100011
    `define LUI     7'b0110111
    `define AUIPC   7'b0010111
    `define JAL     7'b1101111
    `define JALR    7'b1100111
    `define LOAD    7'b0000011
    `define STORE   7'b0100011
    `define MEM     7'b0001111 // for fence instruction
    `define SYS     7'b1110011 // for ECALL and  EBREAK
`endif
