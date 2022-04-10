	.file	"test.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a5,305418240
	addi	a1,a5,1656
	li	a0,1
	call	set_seg_single
	call	halt_riscy
	li	a5,0
	mv	a0,a5
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.globl	seg_base
	.section	.srodata,"a"
	.align	2
	.type	seg_base, @object
	.size	seg_base, 4
seg_base:
	.word	67108864
	.text
	.align	2
	.globl	halt_riscy
	.type	halt_riscy, @function
halt_riscy:
	addi	sp,sp,-16
	sw	s0,12(sp)
	addi	s0,sp,16
 #APP
# 15 "./test.c" 1
	ecall
# 0 "" 2
 #NO_APP
	nop
	lw	s0,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	halt_riscy, .-halt_riscy
	.align	2
	.globl	set_seg_single
	.type	set_seg_single, @function
set_seg_single:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-36(s0)
	slli	a4,a5,2
	li	a5,67108864
	add	a5,a4,a5
	sw	a5,-20(s0)
	lw	a5,-40(s0)
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	lw	a4,-24(s0)
	sw	a4,0(a5)
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	set_seg_single, .-set_seg_single
	.ident	"GCC: (g5964b5cd727) 11.1.0"
