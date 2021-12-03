	.file	"test.c"
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
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,34
	sw	a5,-20(s0)
	li	a0,9
	call	fib
	sw	a0,-24(s0)
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	bne	a4,a5,.L6
	nop
.L3:
 #APP
# 19 "test.c" 1
	li a0, 42
# 0 "" 2
# 20 "test.c" 1
	li a7, 93
# 0 "" 2
# 21 "test.c" 1
	ecall
# 0 "" 2
 #NO_APP
	j	.L4
.L6:
	nop
.L4:
 #APP
# 23 "test.c" 1
	li a0, 0
# 0 "" 2
# 24 "test.c" 1
	li a7, 93
# 0 "" 2
# 25 "test.c" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.align	2
	.globl	fib
	.type	fib, @function
fib:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s1,20(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a4,-20(s0)
	li	a5,1
	bgt	a4,a5,.L8
	lw	a5,-20(s0)
	j	.L9
.L8:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	mv	a0,a5
	call	fib
	mv	s1,a0
	lw	a5,-20(s0)
	addi	a5,a5,-2
	mv	a0,a5
	call	fib
	mv	a5,a0
	add	a5,s1,a5
.L9:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
	.size	fib, .-fib
	.ident	"GCC: (GNU) 11.1.0"
