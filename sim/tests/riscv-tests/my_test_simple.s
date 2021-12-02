	.file	"loop.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	li	a5,3
	sw	a5,-20(s0)
	li	a5,5
	sw	a5,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	add	a5,a4,a5
	sw	a5,-28(s0)
	lw	a4,-28(s0)
	li	a5,8
	bne	a4,a5,.L6
	nop
.L3:
 #APP
# 12 "./loop.c" 1
	li a0, 42
# 0 "" 2
# 13 "./loop.c" 1
	li a7, 93
# 0 "" 2
# 14 "./loop.c" 1
	ecall
# 0 "" 2
 #NO_APP
	j	.L4
.L6:
	nop
.L4:
 #APP
# 16 "./loop.c" 1
	li a0, 0
# 0 "" 2
# 17 "./loop.c" 1
	li a7, 93
# 0 "" 2
# 18 "./loop.c" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a5,0
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
