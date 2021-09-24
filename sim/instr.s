Start:
addi x1, x0, 2 # x1 = 2
add x2, x1, x0 # x2 = 2
bne x1, x2, Start # branch not taken

Bilibili:
addi x3, x0, 1 # x3 = 1
slti x4, x0, 1 # x4 = 1
beq x3, x4, Bilibili # branch taken

exit: #FALL_THRU