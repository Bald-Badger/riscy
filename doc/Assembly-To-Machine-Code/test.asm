# R type
add x0, x0, x0
sub x0, x0, x0
and x0, x0, x0
or x0, x0, x0
xor x0, x0, x0
slt x0, x0, x0
sltu x0, x0, x0
sll x0, x0, x0
srl x0, x0, x0
sra x0, x0, x0

# I type
addi x0, x0, 0
andi x0, x0, 0
ori x0, x0, 0
xori x0, x0, 0
slti x0, x0, 0
sltiu x0, x0, 0
slli x0, x0, 0
srli x0, x0, 0
srai x0, x0, 0

# B type, should output 0
beq x0, x0, 0

# LUI and AUIPC
lui x0, 0 # imm << 12
auipc x0, 0 # a+b signed

# J type
jal x0, 0 # a + 4
jalr x0, x0, 0 # a + 4

# LOAD 
lw x0, 0(x0) # a + b signed

# store
sb x0, 0(x0) # a + b signed





