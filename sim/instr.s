	.file	"test.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.word	1
	.word	3
	.word	2
	.word	4
	.word	5
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a1,0(a5)
	lw	a2,4(a5)
	lw	a3,8(a5)
	lw	a4,12(a5)
	lw	a5,16(a5)
	sw	a1,-48(s0)
	sw	a2,-44(s0)
	sw	a3,-40(s0)
	sw	a4,-36(s0)
	sw	a5,-32(s0)
	li	a5,15
	sw	a5,-28(s0)
	li	a5,15
	sw	a5,-20(s0)
	sw	zero,-24(s0)
	j	.L2
.L3:
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a5,a5,-16
	add	a5,a5,s0
	lw	a5,-32(a5)
	lw	a4,-20(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L2:
	lw	a4,-24(s0)
	li	a5,4
	ble	a4,a5,.L3
	lw	a4,-20(s0)
	lw	a5,-28(s0)
	beq	a4,a5,.L8
	nop
.L6:
 #APP
# 30 "./test.c" 1
	li a0, -1
# 0 "" 2
# 31 "./test.c" 1
	li a7, 93
# 0 "" 2
# 32 "./test.c" 1
	ecall
# 0 "" 2
 #NO_APP
	j	.L5
.L8:
	nop
.L5:
 #APP
# 39 "./test.c" 1
	li a0, 42
# 0 "" 2
# 40 "./test.c" 1
	li a7, 93
# 0 "" 2
# 41 "./test.c" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a5,0
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
