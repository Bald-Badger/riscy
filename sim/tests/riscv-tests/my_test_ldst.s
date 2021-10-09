.text
main:

li a1, 0x10040004 # base mem address
li a2, 0x12345678 # base data
sw a2, 4(a1) # 0x12345678
sh a2, 8(a1) # 0x5678
sb a2, 12(a1) # 0x78
li a3, 0x1234
li a4, 0x12

test_1:
li gp, 1
lw x29, 4(a1)
li x30, 0x12345678

bne x30, x29, fail


test_2:
lw x29, 4(a1)
li x30, 0x12345678

li gp, 2
bne x30, x29, fail


test_3:
lh x29, 8(a1)
li x30, 0x5678

li gp, 3
bne x30, x29, fail


test_4:
lb x29, 12(a1)
li x30, 0x78

li gp, 4
bne x30, x29, fail


test_5: # mem2mem fwd test

sh a3, 16(a1)
lh x29, 16(a1)
li x30, 0x1234

li gp, 5
bne x30, x29, fail


test_6:

sh a3, 20(a1)
li x30, 0x1234
lh x29, 20(a1)

li gp, 6
bne x30, x29, fail


test_7:

sh a4, 24(a1)
li x30, 0x12
lh x29, 24(a1)

li gp, 7
bne x30, x29, fail
beq x30, x29, pass

pass:
	li a0, 42
	li a7, 93
	ecall
fail:
	li a0, 0
	li a7, 93
	ecall
