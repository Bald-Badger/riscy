
./test:     file format elf32-littleriscv


Disassembly of section .text:

00010094 <exit>:
   10094:	ff010113          	addi	sp,sp,-16
   10098:	00000593          	li	a1,0
   1009c:	00812423          	sw	s0,8(sp)
   100a0:	00112623          	sw	ra,12(sp)
   100a4:	00050413          	mv	s0,a0
   100a8:	304000ef          	jal	ra,103ac <__call_exitprocs>
   100ac:	c2c1a503          	lw	a0,-980(gp) # 11a4c <_global_impure_ptr>
   100b0:	03c52783          	lw	a5,60(a0)
   100b4:	00078463          	beqz	a5,100bc <exit+0x28>
   100b8:	000780e7          	jalr	a5
   100bc:	00040513          	mv	a0,s0
   100c0:	514000ef          	jal	ra,105d4 <_exit>

000100c4 <register_fini>:
   100c4:	00000793          	li	a5,0
   100c8:	00078863          	beqz	a5,100d8 <register_fini+0x14>
   100cc:	00010537          	lui	a0,0x10
   100d0:	4cc50513          	addi	a0,a0,1228 # 104cc <__libc_fini_array>
   100d4:	4540006f          	j	10528 <atexit>
   100d8:	00008067          	ret

000100dc <_start>:
   100dc:	00002197          	auipc	gp,0x2
   100e0:	d4418193          	addi	gp,gp,-700 # 11e20 <__global_pointer$>
   100e4:	c3818513          	addi	a0,gp,-968 # 11a58 <completed.1>
   100e8:	c5418613          	addi	a2,gp,-940 # 11a74 <__BSS_END__>
   100ec:	40a60633          	sub	a2,a2,a0
   100f0:	00000593          	li	a1,0
   100f4:	1dc000ef          	jal	ra,102d0 <memset>
   100f8:	00000517          	auipc	a0,0x0
   100fc:	43050513          	addi	a0,a0,1072 # 10528 <atexit>
   10100:	00050863          	beqz	a0,10110 <_start+0x34>
   10104:	00000517          	auipc	a0,0x0
   10108:	3c850513          	addi	a0,a0,968 # 104cc <__libc_fini_array>
   1010c:	41c000ef          	jal	ra,10528 <atexit>
   10110:	124000ef          	jal	ra,10234 <__libc_init_array>
   10114:	00012503          	lw	a0,0(sp)
   10118:	00410593          	addi	a1,sp,4
   1011c:	00000613          	li	a2,0
   10120:	06c000ef          	jal	ra,1018c <main>
   10124:	f71ff06f          	j	10094 <exit>

00010128 <__do_global_dtors_aux>:
   10128:	ff010113          	addi	sp,sp,-16
   1012c:	00812423          	sw	s0,8(sp)
   10130:	c381c783          	lbu	a5,-968(gp) # 11a58 <completed.1>
   10134:	00112623          	sw	ra,12(sp)
   10138:	02079263          	bnez	a5,1015c <__do_global_dtors_aux+0x34>
   1013c:	00000793          	li	a5,0
   10140:	00078a63          	beqz	a5,10154 <__do_global_dtors_aux+0x2c>
   10144:	00011537          	lui	a0,0x11
   10148:	60c50513          	addi	a0,a0,1548 # 1160c <__FRAME_END__>
   1014c:	00000097          	auipc	ra,0x0
   10150:	000000e7          	jalr	zero # 0 <exit-0x10094>
   10154:	00100793          	li	a5,1
   10158:	c2f18c23          	sb	a5,-968(gp) # 11a58 <completed.1>
   1015c:	00c12083          	lw	ra,12(sp)
   10160:	00812403          	lw	s0,8(sp)
   10164:	01010113          	addi	sp,sp,16
   10168:	00008067          	ret

0001016c <frame_dummy>:
   1016c:	00000793          	li	a5,0
   10170:	00078c63          	beqz	a5,10188 <frame_dummy+0x1c>
   10174:	00011537          	lui	a0,0x11
   10178:	c3c18593          	addi	a1,gp,-964 # 11a5c <object.0>
   1017c:	60c50513          	addi	a0,a0,1548 # 1160c <__FRAME_END__>
   10180:	00000317          	auipc	t1,0x0
   10184:	00000067          	jr	zero # 0 <exit-0x10094>
   10188:	00008067          	ret

0001018c <main>:
   1018c:	ff010113          	addi	sp,sp,-16
   10190:	00112623          	sw	ra,12(sp)
   10194:	00812423          	sw	s0,8(sp)
   10198:	01010413          	addi	s0,sp,16
   1019c:	00f00593          	li	a1,15
   101a0:	00100513          	li	a0,1
   101a4:	040000ef          	jal	ra,101e4 <set_seg_single>
   101a8:	01c000ef          	jal	ra,101c4 <halt_riscy>
   101ac:	00000793          	li	a5,0
   101b0:	00078513          	mv	a0,a5
   101b4:	00c12083          	lw	ra,12(sp)
   101b8:	00812403          	lw	s0,8(sp)
   101bc:	01010113          	addi	sp,sp,16
   101c0:	00008067          	ret

000101c4 <halt_riscy>:
   101c4:	ff010113          	addi	sp,sp,-16
   101c8:	00812623          	sw	s0,12(sp)
   101cc:	01010413          	addi	s0,sp,16
   101d0:	00000073          	ecall
   101d4:	00000013          	nop
   101d8:	00c12403          	lw	s0,12(sp)
   101dc:	01010113          	addi	sp,sp,16
   101e0:	00008067          	ret

000101e4 <set_seg_single>:
   101e4:	fd010113          	addi	sp,sp,-48
   101e8:	02812623          	sw	s0,44(sp)
   101ec:	03010413          	addi	s0,sp,48
   101f0:	fca42e23          	sw	a0,-36(s0)
   101f4:	fcb42c23          	sw	a1,-40(s0)
   101f8:	fdc42783          	lw	a5,-36(s0)
   101fc:	00279713          	slli	a4,a5,0x2
   10200:	040007b7          	lui	a5,0x4000
   10204:	00f707b3          	add	a5,a4,a5
   10208:	fef42623          	sw	a5,-20(s0)
   1020c:	fd842783          	lw	a5,-40(s0)
   10210:	00f7f793          	andi	a5,a5,15
   10214:	fef42423          	sw	a5,-24(s0)
   10218:	fec42783          	lw	a5,-20(s0)
   1021c:	fe842703          	lw	a4,-24(s0)
   10220:	00e7a023          	sw	a4,0(a5) # 4000000 <__global_pointer$+0x3fee1e0>
   10224:	00000013          	nop
   10228:	02c12403          	lw	s0,44(sp)
   1022c:	03010113          	addi	sp,sp,48
   10230:	00008067          	ret

00010234 <__libc_init_array>:
   10234:	ff010113          	addi	sp,sp,-16
   10238:	00812423          	sw	s0,8(sp)
   1023c:	01212023          	sw	s2,0(sp)
   10240:	00011437          	lui	s0,0x11
   10244:	00011937          	lui	s2,0x11
   10248:	61040793          	addi	a5,s0,1552 # 11610 <__init_array_start>
   1024c:	61090913          	addi	s2,s2,1552 # 11610 <__init_array_start>
   10250:	40f90933          	sub	s2,s2,a5
   10254:	00112623          	sw	ra,12(sp)
   10258:	00912223          	sw	s1,4(sp)
   1025c:	40295913          	srai	s2,s2,0x2
   10260:	02090063          	beqz	s2,10280 <__libc_init_array+0x4c>
   10264:	61040413          	addi	s0,s0,1552
   10268:	00000493          	li	s1,0
   1026c:	00042783          	lw	a5,0(s0)
   10270:	00148493          	addi	s1,s1,1
   10274:	00440413          	addi	s0,s0,4
   10278:	000780e7          	jalr	a5
   1027c:	fe9918e3          	bne	s2,s1,1026c <__libc_init_array+0x38>
   10280:	00011437          	lui	s0,0x11
   10284:	00011937          	lui	s2,0x11
   10288:	61040793          	addi	a5,s0,1552 # 11610 <__init_array_start>
   1028c:	61890913          	addi	s2,s2,1560 # 11618 <__do_global_dtors_aux_fini_array_entry>
   10290:	40f90933          	sub	s2,s2,a5
   10294:	40295913          	srai	s2,s2,0x2
   10298:	02090063          	beqz	s2,102b8 <__libc_init_array+0x84>
   1029c:	61040413          	addi	s0,s0,1552
   102a0:	00000493          	li	s1,0
   102a4:	00042783          	lw	a5,0(s0)
   102a8:	00148493          	addi	s1,s1,1
   102ac:	00440413          	addi	s0,s0,4
   102b0:	000780e7          	jalr	a5
   102b4:	fe9918e3          	bne	s2,s1,102a4 <__libc_init_array+0x70>
   102b8:	00c12083          	lw	ra,12(sp)
   102bc:	00812403          	lw	s0,8(sp)
   102c0:	00412483          	lw	s1,4(sp)
   102c4:	00012903          	lw	s2,0(sp)
   102c8:	01010113          	addi	sp,sp,16
   102cc:	00008067          	ret

000102d0 <memset>:
   102d0:	00f00313          	li	t1,15
   102d4:	00050713          	mv	a4,a0
   102d8:	02c37e63          	bgeu	t1,a2,10314 <memset+0x44>
   102dc:	00f77793          	andi	a5,a4,15
   102e0:	0a079063          	bnez	a5,10380 <memset+0xb0>
   102e4:	08059263          	bnez	a1,10368 <memset+0x98>
   102e8:	ff067693          	andi	a3,a2,-16
   102ec:	00f67613          	andi	a2,a2,15
   102f0:	00e686b3          	add	a3,a3,a4
   102f4:	00b72023          	sw	a1,0(a4)
   102f8:	00b72223          	sw	a1,4(a4)
   102fc:	00b72423          	sw	a1,8(a4)
   10300:	00b72623          	sw	a1,12(a4)
   10304:	01070713          	addi	a4,a4,16
   10308:	fed766e3          	bltu	a4,a3,102f4 <memset+0x24>
   1030c:	00061463          	bnez	a2,10314 <memset+0x44>
   10310:	00008067          	ret
   10314:	40c306b3          	sub	a3,t1,a2
   10318:	00269693          	slli	a3,a3,0x2
   1031c:	00000297          	auipc	t0,0x0
   10320:	005686b3          	add	a3,a3,t0
   10324:	00c68067          	jr	12(a3)
   10328:	00b70723          	sb	a1,14(a4)
   1032c:	00b706a3          	sb	a1,13(a4)
   10330:	00b70623          	sb	a1,12(a4)
   10334:	00b705a3          	sb	a1,11(a4)
   10338:	00b70523          	sb	a1,10(a4)
   1033c:	00b704a3          	sb	a1,9(a4)
   10340:	00b70423          	sb	a1,8(a4)
   10344:	00b703a3          	sb	a1,7(a4)
   10348:	00b70323          	sb	a1,6(a4)
   1034c:	00b702a3          	sb	a1,5(a4)
   10350:	00b70223          	sb	a1,4(a4)
   10354:	00b701a3          	sb	a1,3(a4)
   10358:	00b70123          	sb	a1,2(a4)
   1035c:	00b700a3          	sb	a1,1(a4)
   10360:	00b70023          	sb	a1,0(a4)
   10364:	00008067          	ret
   10368:	0ff5f593          	zext.b	a1,a1
   1036c:	00859693          	slli	a3,a1,0x8
   10370:	00d5e5b3          	or	a1,a1,a3
   10374:	01059693          	slli	a3,a1,0x10
   10378:	00d5e5b3          	or	a1,a1,a3
   1037c:	f6dff06f          	j	102e8 <memset+0x18>
   10380:	00279693          	slli	a3,a5,0x2
   10384:	00000297          	auipc	t0,0x0
   10388:	005686b3          	add	a3,a3,t0
   1038c:	00008293          	mv	t0,ra
   10390:	fa0680e7          	jalr	-96(a3)
   10394:	00028093          	mv	ra,t0
   10398:	ff078793          	addi	a5,a5,-16
   1039c:	40f70733          	sub	a4,a4,a5
   103a0:	00f60633          	add	a2,a2,a5
   103a4:	f6c378e3          	bgeu	t1,a2,10314 <memset+0x44>
   103a8:	f3dff06f          	j	102e4 <memset+0x14>

000103ac <__call_exitprocs>:
   103ac:	fd010113          	addi	sp,sp,-48
   103b0:	01412c23          	sw	s4,24(sp)
   103b4:	c2c1aa03          	lw	s4,-980(gp) # 11a4c <_global_impure_ptr>
   103b8:	03212023          	sw	s2,32(sp)
   103bc:	02112623          	sw	ra,44(sp)
   103c0:	148a2903          	lw	s2,328(s4)
   103c4:	02812423          	sw	s0,40(sp)
   103c8:	02912223          	sw	s1,36(sp)
   103cc:	01312e23          	sw	s3,28(sp)
   103d0:	01512a23          	sw	s5,20(sp)
   103d4:	01612823          	sw	s6,16(sp)
   103d8:	01712623          	sw	s7,12(sp)
   103dc:	01812423          	sw	s8,8(sp)
   103e0:	04090063          	beqz	s2,10420 <__call_exitprocs+0x74>
   103e4:	00050b13          	mv	s6,a0
   103e8:	00058b93          	mv	s7,a1
   103ec:	00100a93          	li	s5,1
   103f0:	fff00993          	li	s3,-1
   103f4:	00492483          	lw	s1,4(s2)
   103f8:	fff48413          	addi	s0,s1,-1
   103fc:	02044263          	bltz	s0,10420 <__call_exitprocs+0x74>
   10400:	00249493          	slli	s1,s1,0x2
   10404:	009904b3          	add	s1,s2,s1
   10408:	040b8463          	beqz	s7,10450 <__call_exitprocs+0xa4>
   1040c:	1044a783          	lw	a5,260(s1)
   10410:	05778063          	beq	a5,s7,10450 <__call_exitprocs+0xa4>
   10414:	fff40413          	addi	s0,s0,-1
   10418:	ffc48493          	addi	s1,s1,-4
   1041c:	ff3416e3          	bne	s0,s3,10408 <__call_exitprocs+0x5c>
   10420:	02c12083          	lw	ra,44(sp)
   10424:	02812403          	lw	s0,40(sp)
   10428:	02412483          	lw	s1,36(sp)
   1042c:	02012903          	lw	s2,32(sp)
   10430:	01c12983          	lw	s3,28(sp)
   10434:	01812a03          	lw	s4,24(sp)
   10438:	01412a83          	lw	s5,20(sp)
   1043c:	01012b03          	lw	s6,16(sp)
   10440:	00c12b83          	lw	s7,12(sp)
   10444:	00812c03          	lw	s8,8(sp)
   10448:	03010113          	addi	sp,sp,48
   1044c:	00008067          	ret
   10450:	00492783          	lw	a5,4(s2)
   10454:	0044a683          	lw	a3,4(s1)
   10458:	fff78793          	addi	a5,a5,-1
   1045c:	04878e63          	beq	a5,s0,104b8 <__call_exitprocs+0x10c>
   10460:	0004a223          	sw	zero,4(s1)
   10464:	fa0688e3          	beqz	a3,10414 <__call_exitprocs+0x68>
   10468:	18892783          	lw	a5,392(s2)
   1046c:	008a9733          	sll	a4,s5,s0
   10470:	00492c03          	lw	s8,4(s2)
   10474:	00f777b3          	and	a5,a4,a5
   10478:	02079263          	bnez	a5,1049c <__call_exitprocs+0xf0>
   1047c:	000680e7          	jalr	a3
   10480:	00492703          	lw	a4,4(s2)
   10484:	148a2783          	lw	a5,328(s4)
   10488:	01871463          	bne	a4,s8,10490 <__call_exitprocs+0xe4>
   1048c:	f92784e3          	beq	a5,s2,10414 <__call_exitprocs+0x68>
   10490:	f80788e3          	beqz	a5,10420 <__call_exitprocs+0x74>
   10494:	00078913          	mv	s2,a5
   10498:	f5dff06f          	j	103f4 <__call_exitprocs+0x48>
   1049c:	18c92783          	lw	a5,396(s2)
   104a0:	0844a583          	lw	a1,132(s1)
   104a4:	00f77733          	and	a4,a4,a5
   104a8:	00071c63          	bnez	a4,104c0 <__call_exitprocs+0x114>
   104ac:	000b0513          	mv	a0,s6
   104b0:	000680e7          	jalr	a3
   104b4:	fcdff06f          	j	10480 <__call_exitprocs+0xd4>
   104b8:	00892223          	sw	s0,4(s2)
   104bc:	fa9ff06f          	j	10464 <__call_exitprocs+0xb8>
   104c0:	00058513          	mv	a0,a1
   104c4:	000680e7          	jalr	a3
   104c8:	fb9ff06f          	j	10480 <__call_exitprocs+0xd4>

000104cc <__libc_fini_array>:
   104cc:	ff010113          	addi	sp,sp,-16
   104d0:	00812423          	sw	s0,8(sp)
   104d4:	000117b7          	lui	a5,0x11
   104d8:	00011437          	lui	s0,0x11
   104dc:	61878793          	addi	a5,a5,1560 # 11618 <__do_global_dtors_aux_fini_array_entry>
   104e0:	61c40413          	addi	s0,s0,1564 # 1161c <__fini_array_end>
   104e4:	40f40433          	sub	s0,s0,a5
   104e8:	00912223          	sw	s1,4(sp)
   104ec:	00112623          	sw	ra,12(sp)
   104f0:	40245493          	srai	s1,s0,0x2
   104f4:	02048063          	beqz	s1,10514 <__libc_fini_array+0x48>
   104f8:	ffc40413          	addi	s0,s0,-4
   104fc:	00f40433          	add	s0,s0,a5
   10500:	00042783          	lw	a5,0(s0)
   10504:	fff48493          	addi	s1,s1,-1
   10508:	ffc40413          	addi	s0,s0,-4
   1050c:	000780e7          	jalr	a5
   10510:	fe0498e3          	bnez	s1,10500 <__libc_fini_array+0x34>
   10514:	00c12083          	lw	ra,12(sp)
   10518:	00812403          	lw	s0,8(sp)
   1051c:	00412483          	lw	s1,4(sp)
   10520:	01010113          	addi	sp,sp,16
   10524:	00008067          	ret

00010528 <atexit>:
   10528:	00050593          	mv	a1,a0
   1052c:	00000693          	li	a3,0
   10530:	00000613          	li	a2,0
   10534:	00000513          	li	a0,0
   10538:	0040006f          	j	1053c <__register_exitproc>

0001053c <__register_exitproc>:
   1053c:	c2c1a703          	lw	a4,-980(gp) # 11a4c <_global_impure_ptr>
   10540:	14872783          	lw	a5,328(a4)
   10544:	04078c63          	beqz	a5,1059c <__register_exitproc+0x60>
   10548:	0047a703          	lw	a4,4(a5)
   1054c:	01f00813          	li	a6,31
   10550:	06e84e63          	blt	a6,a4,105cc <__register_exitproc+0x90>
   10554:	00271813          	slli	a6,a4,0x2
   10558:	02050663          	beqz	a0,10584 <__register_exitproc+0x48>
   1055c:	01078333          	add	t1,a5,a6
   10560:	08c32423          	sw	a2,136(t1) # 10208 <set_seg_single+0x24>
   10564:	1887a883          	lw	a7,392(a5)
   10568:	00100613          	li	a2,1
   1056c:	00e61633          	sll	a2,a2,a4
   10570:	00c8e8b3          	or	a7,a7,a2
   10574:	1917a423          	sw	a7,392(a5)
   10578:	10d32423          	sw	a3,264(t1)
   1057c:	00200693          	li	a3,2
   10580:	02d50463          	beq	a0,a3,105a8 <__register_exitproc+0x6c>
   10584:	00170713          	addi	a4,a4,1
   10588:	00e7a223          	sw	a4,4(a5)
   1058c:	010787b3          	add	a5,a5,a6
   10590:	00b7a423          	sw	a1,8(a5)
   10594:	00000513          	li	a0,0
   10598:	00008067          	ret
   1059c:	14c70793          	addi	a5,a4,332
   105a0:	14f72423          	sw	a5,328(a4)
   105a4:	fa5ff06f          	j	10548 <__register_exitproc+0xc>
   105a8:	18c7a683          	lw	a3,396(a5)
   105ac:	00170713          	addi	a4,a4,1
   105b0:	00e7a223          	sw	a4,4(a5)
   105b4:	00c6e6b3          	or	a3,a3,a2
   105b8:	18d7a623          	sw	a3,396(a5)
   105bc:	010787b3          	add	a5,a5,a6
   105c0:	00b7a423          	sw	a1,8(a5)
   105c4:	00000513          	li	a0,0
   105c8:	00008067          	ret
   105cc:	fff00513          	li	a0,-1
   105d0:	00008067          	ret

000105d4 <_exit>:
   105d4:	05d00893          	li	a7,93
   105d8:	00000073          	ecall
   105dc:	00054463          	bltz	a0,105e4 <_exit+0x10>
   105e0:	0000006f          	j	105e0 <_exit+0xc>
   105e4:	ff010113          	addi	sp,sp,-16
   105e8:	00812423          	sw	s0,8(sp)
   105ec:	00050413          	mv	s0,a0
   105f0:	00112623          	sw	ra,12(sp)
   105f4:	40800433          	neg	s0,s0
   105f8:	00c000ef          	jal	ra,10604 <__errno>
   105fc:	00852023          	sw	s0,0(a0)
   10600:	0000006f          	j	10600 <_exit+0x2c>

00010604 <__errno>:
   10604:	c341a503          	lw	a0,-972(gp) # 11a54 <_impure_ptr>
   10608:	00008067          	ret

Disassembly of section .eh_frame:

0001160c <__FRAME_END__>:
   1160c:	0000                	.2byte	0x0
	...

Disassembly of section .init_array:

00011610 <__init_array_start>:
   11610:	00c4                	.2byte	0xc4
   11612:	0001                	.2byte	0x1

00011614 <__frame_dummy_init_array_entry>:
   11614:	016c                	.2byte	0x16c
   11616:	0001                	.2byte	0x1

Disassembly of section .fini_array:

00011618 <__do_global_dtors_aux_fini_array_entry>:
   11618:	0128                	.2byte	0x128
   1161a:	0001                	.2byte	0x1

Disassembly of section .data:

00011620 <impure_data>:
   11620:	0000                	.2byte	0x0
   11622:	0000                	.2byte	0x0
   11624:	190c                	.2byte	0x190c
   11626:	0001                	.2byte	0x1
   11628:	1974                	.2byte	0x1974
   1162a:	0001                	.2byte	0x1
   1162c:	19dc                	.2byte	0x19dc
   1162e:	0001                	.2byte	0x1
	...
   116c8:	0001                	.2byte	0x1
   116ca:	0000                	.2byte	0x0
   116cc:	0000                	.2byte	0x0
   116ce:	0000                	.2byte	0x0
   116d0:	330e                	.2byte	0x330e
   116d2:	abcd                	.2byte	0xabcd
   116d4:	1234                	.2byte	0x1234
   116d6:	e66d                	.2byte	0xe66d
   116d8:	deec                	.2byte	0xdeec
   116da:	0005                	.2byte	0x5
   116dc:	0000000b          	.4byte	0xb
	...

Disassembly of section .sdata:

00011a48 <seg_base>:
   11a48:	0000                	.2byte	0x0
   11a4a:	0400                	.2byte	0x400

00011a4c <_global_impure_ptr>:
   11a4c:	1620                	.2byte	0x1620
   11a4e:	0001                	.2byte	0x1

00011a50 <__dso_handle>:
   11a50:	0000                	.2byte	0x0
	...

00011a54 <_impure_ptr>:
   11a54:	1620                	.2byte	0x1620
   11a56:	0001                	.2byte	0x1

Disassembly of section .bss:

00011a58 <completed.1>:
   11a58:	0000                	.2byte	0x0
	...

00011a5c <object.0>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.4byte	0x3a434347
   4:	2820                	.2byte	0x2820
   6:	36393567          	.4byte	0x36393567
   a:	6234                	.2byte	0x6234
   c:	6335                	.2byte	0x6335
   e:	3764                	.2byte	0x3764
  10:	3732                	.2byte	0x3732
  12:	2029                	.2byte	0x2029
  14:	3131                	.2byte	0x3131
  16:	312e                	.2byte	0x312e
  18:	302e                	.2byte	0x302e
  1a:	4700                	.2byte	0x4700
  1c:	203a4343          	.4byte	0x203a4343
  20:	4728                	.2byte	0x4728
  22:	554e                	.2byte	0x554e
  24:	2029                	.2byte	0x2029
  26:	3131                	.2byte	0x3131
  28:	312e                	.2byte	0x312e
  2a:	302e                	.2byte	0x302e
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	3041                	.2byte	0x3041
   2:	0000                	.2byte	0x0
   4:	7200                	.2byte	0x7200
   6:	7369                	.2byte	0x7369
   8:	01007663          	bgeu	zero,a6,14 <exit-0x10080>
   c:	0026                	.2byte	0x26
   e:	0000                	.2byte	0x0
  10:	1004                	.2byte	0x1004
  12:	7205                	.2byte	0x7205
  14:	3376                	.2byte	0x3376
  16:	6932                	.2byte	0x6932
  18:	7032                	.2byte	0x7032
  1a:	5f31                	.2byte	0x5f31
  1c:	697a                	.2byte	0x697a
  1e:	32727363          	bgeu	tp,t2,344 <exit-0xfd50>
  22:	3070                	.2byte	0x3070
  24:	7a5f 6669 6e65      	.byte	0x5f, 0x7a, 0x69, 0x66, 0x65, 0x6e
  2a:	32696563          	bltu	s2,t1,354 <exit-0xfd40>
  2e:	3070                	.2byte	0x3070
	...
