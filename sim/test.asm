add x0, x1, x2 # R type
sub x0, x1, x2
and x0, x1, x2
or x0, x1, x2
xor x0, x1, x2
slt x0, x1, x2
sltu x0, x1, x2
sll x0, x1, x2
srl x0, x1, x2
sra x0, x1, x2
addi x0, x1, 0 # I type
andi x0, x1, 0
ori x0, x1, 0
xori x0, x1, 0
slti x0, x1, 0
sltiu x0, x1, 0
slli x0, x1, 0
srli x0, x1, 0
srai x0, x1, 0
beq x0, x1, 0 # B type, should output 0
lui x0, 0 # LUI and AUIPC # imm << 12
auipc x0, 0 # a+b signed
jal x0, 0 # J type # a + 4
jalr x0, x1, 0 # a + 4
lw x0, 0(x1) # a + b signed
sb x0, 0(x1) # a + b signed