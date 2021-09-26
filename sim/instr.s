    li x1, 0
    li x2, 5
loop_head:
    bge x1, x2, loop_end
    addi x1, x1, 1
    j loop_head
loop_end:
    li x3, 7
