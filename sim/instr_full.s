
./test:     file format elf32-littleriscv


Disassembly of section .text:

00010074 <register_fini>:
   10074:	00000793          	li	a5,0
   10078:	00078863          	beqz	a5,10088 <register_fini+0x14>
   1007c:	00010537          	lui	a0,0x10
   10080:	4e850513          	addi	a0,a0,1256 # 104e8 <__libc_fini_array>
   10084:	4500006f          	j	104d4 <atexit>
   10088:	00008067          	ret

0001008c <_start>:
   1008c:	00002197          	auipc	gp,0x2
   10090:	dac18193          	addi	gp,gp,-596 # 11e38 <__global_pointer$>
   10094:	c3418513          	addi	a0,gp,-972 # 11a6c <completed.1>
   10098:	c5018613          	addi	a2,gp,-944 # 11a88 <__BSS_END__>
   1009c:	40a60633          	sub	a2,a2,a0
   100a0:	00000593          	li	a1,0
   100a4:	234000ef          	jal	ra,102d8 <memset>
   100a8:	00000517          	auipc	a0,0x0
   100ac:	42c50513          	addi	a0,a0,1068 # 104d4 <atexit>
   100b0:	00050863          	beqz	a0,100c0 <_start+0x34>
   100b4:	00000517          	auipc	a0,0x0
   100b8:	43450513          	addi	a0,a0,1076 # 104e8 <__libc_fini_array>
   100bc:	418000ef          	jal	ra,104d4 <atexit>
   100c0:	17c000ef          	jal	ra,1023c <__libc_init_array>
   100c4:	00012503          	lw	a0,0(sp)
   100c8:	00410593          	addi	a1,sp,4
   100cc:	00000613          	li	a2,0
   100d0:	06c000ef          	jal	ra,1013c <main>
   100d4:	1380006f          	j	1020c <exit>

000100d8 <__do_global_dtors_aux>:
   100d8:	ff010113          	addi	sp,sp,-16
   100dc:	00812423          	sw	s0,8(sp)
   100e0:	c341c783          	lbu	a5,-972(gp) # 11a6c <completed.1>
   100e4:	00112623          	sw	ra,12(sp)
   100e8:	02079263          	bnez	a5,1010c <__do_global_dtors_aux+0x34>
   100ec:	00000793          	li	a5,0
   100f0:	00078a63          	beqz	a5,10104 <__do_global_dtors_aux+0x2c>
   100f4:	00011537          	lui	a0,0x11
   100f8:	62850513          	addi	a0,a0,1576 # 11628 <__FRAME_END__>
   100fc:	00000097          	auipc	ra,0x0
   10100:	000000e7          	jalr	zero # 0 <register_fini-0x10074>
   10104:	00100793          	li	a5,1
   10108:	c2f18a23          	sb	a5,-972(gp) # 11a6c <completed.1>
   1010c:	00c12083          	lw	ra,12(sp)
   10110:	00812403          	lw	s0,8(sp)
   10114:	01010113          	addi	sp,sp,16
   10118:	00008067          	ret

0001011c <frame_dummy>:
   1011c:	00000793          	li	a5,0
   10120:	00078c63          	beqz	a5,10138 <frame_dummy+0x1c>
   10124:	00011537          	lui	a0,0x11
   10128:	c3818593          	addi	a1,gp,-968 # 11a70 <object.0>
   1012c:	62850513          	addi	a0,a0,1576 # 11628 <__FRAME_END__>
   10130:	00000317          	auipc	t1,0x0
   10134:	00000067          	jr	zero # 0 <register_fini-0x10074>
   10138:	00008067          	ret

0001013c <main>:
   1013c:	fd010113          	addi	sp,sp,-48
   10140:	02812623          	sw	s0,44(sp)
   10144:	03010413          	addi	s0,sp,48
   10148:	000107b7          	lui	a5,0x10
   1014c:	61478793          	addi	a5,a5,1556 # 10614 <__errno+0x8>
   10150:	0007a583          	lw	a1,0(a5)
   10154:	0047a603          	lw	a2,4(a5)
   10158:	0087a683          	lw	a3,8(a5)
   1015c:	00c7a703          	lw	a4,12(a5)
   10160:	0107a783          	lw	a5,16(a5)
   10164:	fcb42823          	sw	a1,-48(s0)
   10168:	fcc42a23          	sw	a2,-44(s0)
   1016c:	fcd42c23          	sw	a3,-40(s0)
   10170:	fce42e23          	sw	a4,-36(s0)
   10174:	fef42023          	sw	a5,-32(s0)
   10178:	00f00793          	li	a5,15
   1017c:	fef42223          	sw	a5,-28(s0)
   10180:	00f00793          	li	a5,15
   10184:	fef42623          	sw	a5,-20(s0)
   10188:	fe042423          	sw	zero,-24(s0)
   1018c:	0300006f          	j	101bc <main+0x80>
   10190:	fe842783          	lw	a5,-24(s0)
   10194:	00279793          	slli	a5,a5,0x2
   10198:	ff078793          	addi	a5,a5,-16
   1019c:	008787b3          	add	a5,a5,s0
   101a0:	fe07a783          	lw	a5,-32(a5)
   101a4:	fec42703          	lw	a4,-20(s0)
   101a8:	00f707b3          	add	a5,a4,a5
   101ac:	fef42623          	sw	a5,-20(s0)
   101b0:	fe842783          	lw	a5,-24(s0)
   101b4:	00178793          	addi	a5,a5,1
   101b8:	fef42423          	sw	a5,-24(s0)
   101bc:	fe842703          	lw	a4,-24(s0)
   101c0:	00400793          	li	a5,4
   101c4:	fce7d6e3          	bge	a5,a4,10190 <main+0x54>
   101c8:	fec42703          	lw	a4,-20(s0)
   101cc:	fe442783          	lw	a5,-28(s0)
   101d0:	00f70c63          	beq	a4,a5,101e8 <main+0xac>
   101d4:	00000013          	nop
   101d8:	fff00513          	li	a0,-1
   101dc:	05d00893          	li	a7,93
   101e0:	00000073          	ecall
   101e4:	0080006f          	j	101ec <main+0xb0>
   101e8:	00000013          	nop
   101ec:	02a00513          	li	a0,42
   101f0:	05d00893          	li	a7,93
   101f4:	00000073          	ecall
   101f8:	00000793          	li	a5,0
   101fc:	00078513          	mv	a0,a5
   10200:	02c12403          	lw	s0,44(sp)
   10204:	03010113          	addi	sp,sp,48
   10208:	00008067          	ret

0001020c <exit>:
   1020c:	ff010113          	addi	sp,sp,-16
   10210:	00000593          	li	a1,0
   10214:	00812423          	sw	s0,8(sp)
   10218:	00112623          	sw	ra,12(sp)
   1021c:	00050413          	mv	s0,a0
   10220:	194000ef          	jal	ra,103b4 <__call_exitprocs>
   10224:	c281a503          	lw	a0,-984(gp) # 11a60 <_global_impure_ptr>
   10228:	03c52783          	lw	a5,60(a0)
   1022c:	00078463          	beqz	a5,10234 <exit+0x28>
   10230:	000780e7          	jalr	a5
   10234:	00040513          	mv	a0,s0
   10238:	3a4000ef          	jal	ra,105dc <_exit>

0001023c <__libc_init_array>:
   1023c:	ff010113          	addi	sp,sp,-16
   10240:	00812423          	sw	s0,8(sp)
   10244:	01212023          	sw	s2,0(sp)
   10248:	00011437          	lui	s0,0x11
   1024c:	00011937          	lui	s2,0x11
   10250:	62c40793          	addi	a5,s0,1580 # 1162c <__init_array_start>
   10254:	62c90913          	addi	s2,s2,1580 # 1162c <__init_array_start>
   10258:	40f90933          	sub	s2,s2,a5
   1025c:	00112623          	sw	ra,12(sp)
   10260:	00912223          	sw	s1,4(sp)
   10264:	40295913          	srai	s2,s2,0x2
   10268:	02090063          	beqz	s2,10288 <__libc_init_array+0x4c>
   1026c:	62c40413          	addi	s0,s0,1580
   10270:	00000493          	li	s1,0
   10274:	00042783          	lw	a5,0(s0)
   10278:	00148493          	addi	s1,s1,1
   1027c:	00440413          	addi	s0,s0,4
   10280:	000780e7          	jalr	a5
   10284:	fe9918e3          	bne	s2,s1,10274 <__libc_init_array+0x38>
   10288:	00011437          	lui	s0,0x11
   1028c:	00011937          	lui	s2,0x11
   10290:	62c40793          	addi	a5,s0,1580 # 1162c <__init_array_start>
   10294:	63490913          	addi	s2,s2,1588 # 11634 <__do_global_dtors_aux_fini_array_entry>
   10298:	40f90933          	sub	s2,s2,a5
   1029c:	40295913          	srai	s2,s2,0x2
   102a0:	02090063          	beqz	s2,102c0 <__libc_init_array+0x84>
   102a4:	62c40413          	addi	s0,s0,1580
   102a8:	00000493          	li	s1,0
   102ac:	00042783          	lw	a5,0(s0)
   102b0:	00148493          	addi	s1,s1,1
   102b4:	00440413          	addi	s0,s0,4
   102b8:	000780e7          	jalr	a5
   102bc:	fe9918e3          	bne	s2,s1,102ac <__libc_init_array+0x70>
   102c0:	00c12083          	lw	ra,12(sp)
   102c4:	00812403          	lw	s0,8(sp)
   102c8:	00412483          	lw	s1,4(sp)
   102cc:	00012903          	lw	s2,0(sp)
   102d0:	01010113          	addi	sp,sp,16
   102d4:	00008067          	ret

000102d8 <memset>:
   102d8:	00f00313          	li	t1,15
   102dc:	00050713          	mv	a4,a0
   102e0:	02c37e63          	bgeu	t1,a2,1031c <memset+0x44>
   102e4:	00f77793          	andi	a5,a4,15
   102e8:	0a079063          	bnez	a5,10388 <memset+0xb0>
   102ec:	08059263          	bnez	a1,10370 <memset+0x98>
   102f0:	ff067693          	andi	a3,a2,-16
   102f4:	00f67613          	andi	a2,a2,15
   102f8:	00e686b3          	add	a3,a3,a4
   102fc:	00b72023          	sw	a1,0(a4)
   10300:	00b72223          	sw	a1,4(a4)
   10304:	00b72423          	sw	a1,8(a4)
   10308:	00b72623          	sw	a1,12(a4)
   1030c:	01070713          	addi	a4,a4,16
   10310:	fed766e3          	bltu	a4,a3,102fc <memset+0x24>
   10314:	00061463          	bnez	a2,1031c <memset+0x44>
   10318:	00008067          	ret
   1031c:	40c306b3          	sub	a3,t1,a2
   10320:	00269693          	slli	a3,a3,0x2
   10324:	00000297          	auipc	t0,0x0
   10328:	005686b3          	add	a3,a3,t0
   1032c:	00c68067          	jr	12(a3)
   10330:	00b70723          	sb	a1,14(a4)
   10334:	00b706a3          	sb	a1,13(a4)
   10338:	00b70623          	sb	a1,12(a4)
   1033c:	00b705a3          	sb	a1,11(a4)
   10340:	00b70523          	sb	a1,10(a4)
   10344:	00b704a3          	sb	a1,9(a4)
   10348:	00b70423          	sb	a1,8(a4)
   1034c:	00b703a3          	sb	a1,7(a4)
   10350:	00b70323          	sb	a1,6(a4)
   10354:	00b702a3          	sb	a1,5(a4)
   10358:	00b70223          	sb	a1,4(a4)
   1035c:	00b701a3          	sb	a1,3(a4)
   10360:	00b70123          	sb	a1,2(a4)
   10364:	00b700a3          	sb	a1,1(a4)
   10368:	00b70023          	sb	a1,0(a4)
   1036c:	00008067          	ret
   10370:	0ff5f593          	zext.b	a1,a1
   10374:	00859693          	slli	a3,a1,0x8
   10378:	00d5e5b3          	or	a1,a1,a3
   1037c:	01059693          	slli	a3,a1,0x10
   10380:	00d5e5b3          	or	a1,a1,a3
   10384:	f6dff06f          	j	102f0 <memset+0x18>
   10388:	00279693          	slli	a3,a5,0x2
   1038c:	00000297          	auipc	t0,0x0
   10390:	005686b3          	add	a3,a3,t0
   10394:	00008293          	mv	t0,ra
   10398:	fa0680e7          	jalr	-96(a3)
   1039c:	00028093          	mv	ra,t0
   103a0:	ff078793          	addi	a5,a5,-16
   103a4:	40f70733          	sub	a4,a4,a5
   103a8:	00f60633          	add	a2,a2,a5
   103ac:	f6c378e3          	bgeu	t1,a2,1031c <memset+0x44>
   103b0:	f3dff06f          	j	102ec <memset+0x14>

000103b4 <__call_exitprocs>:
   103b4:	fd010113          	addi	sp,sp,-48
   103b8:	01412c23          	sw	s4,24(sp)
   103bc:	c281aa03          	lw	s4,-984(gp) # 11a60 <_global_impure_ptr>
   103c0:	03212023          	sw	s2,32(sp)
   103c4:	02112623          	sw	ra,44(sp)
   103c8:	148a2903          	lw	s2,328(s4)
   103cc:	02812423          	sw	s0,40(sp)
   103d0:	02912223          	sw	s1,36(sp)
   103d4:	01312e23          	sw	s3,28(sp)
   103d8:	01512a23          	sw	s5,20(sp)
   103dc:	01612823          	sw	s6,16(sp)
   103e0:	01712623          	sw	s7,12(sp)
   103e4:	01812423          	sw	s8,8(sp)
   103e8:	04090063          	beqz	s2,10428 <__call_exitprocs+0x74>
   103ec:	00050b13          	mv	s6,a0
   103f0:	00058b93          	mv	s7,a1
   103f4:	00100a93          	li	s5,1
   103f8:	fff00993          	li	s3,-1
   103fc:	00492483          	lw	s1,4(s2)
   10400:	fff48413          	addi	s0,s1,-1
   10404:	02044263          	bltz	s0,10428 <__call_exitprocs+0x74>
   10408:	00249493          	slli	s1,s1,0x2
   1040c:	009904b3          	add	s1,s2,s1
   10410:	040b8463          	beqz	s7,10458 <__call_exitprocs+0xa4>
   10414:	1044a783          	lw	a5,260(s1)
   10418:	05778063          	beq	a5,s7,10458 <__call_exitprocs+0xa4>
   1041c:	fff40413          	addi	s0,s0,-1
   10420:	ffc48493          	addi	s1,s1,-4
   10424:	ff3416e3          	bne	s0,s3,10410 <__call_exitprocs+0x5c>
   10428:	02c12083          	lw	ra,44(sp)
   1042c:	02812403          	lw	s0,40(sp)
   10430:	02412483          	lw	s1,36(sp)
   10434:	02012903          	lw	s2,32(sp)
   10438:	01c12983          	lw	s3,28(sp)
   1043c:	01812a03          	lw	s4,24(sp)
   10440:	01412a83          	lw	s5,20(sp)
   10444:	01012b03          	lw	s6,16(sp)
   10448:	00c12b83          	lw	s7,12(sp)
   1044c:	00812c03          	lw	s8,8(sp)
   10450:	03010113          	addi	sp,sp,48
   10454:	00008067          	ret
   10458:	00492783          	lw	a5,4(s2)
   1045c:	0044a683          	lw	a3,4(s1)
   10460:	fff78793          	addi	a5,a5,-1
   10464:	04878e63          	beq	a5,s0,104c0 <__call_exitprocs+0x10c>
   10468:	0004a223          	sw	zero,4(s1)
   1046c:	fa0688e3          	beqz	a3,1041c <__call_exitprocs+0x68>
   10470:	18892783          	lw	a5,392(s2)
   10474:	008a9733          	sll	a4,s5,s0
   10478:	00492c03          	lw	s8,4(s2)
   1047c:	00f777b3          	and	a5,a4,a5
   10480:	02079263          	bnez	a5,104a4 <__call_exitprocs+0xf0>
   10484:	000680e7          	jalr	a3
   10488:	00492703          	lw	a4,4(s2)
   1048c:	148a2783          	lw	a5,328(s4)
   10490:	01871463          	bne	a4,s8,10498 <__call_exitprocs+0xe4>
   10494:	f92784e3          	beq	a5,s2,1041c <__call_exitprocs+0x68>
   10498:	f80788e3          	beqz	a5,10428 <__call_exitprocs+0x74>
   1049c:	00078913          	mv	s2,a5
   104a0:	f5dff06f          	j	103fc <__call_exitprocs+0x48>
   104a4:	18c92783          	lw	a5,396(s2)
   104a8:	0844a583          	lw	a1,132(s1)
   104ac:	00f77733          	and	a4,a4,a5
   104b0:	00071c63          	bnez	a4,104c8 <__call_exitprocs+0x114>
   104b4:	000b0513          	mv	a0,s6
   104b8:	000680e7          	jalr	a3
   104bc:	fcdff06f          	j	10488 <__call_exitprocs+0xd4>
   104c0:	00892223          	sw	s0,4(s2)
   104c4:	fa9ff06f          	j	1046c <__call_exitprocs+0xb8>
   104c8:	00058513          	mv	a0,a1
   104cc:	000680e7          	jalr	a3
   104d0:	fb9ff06f          	j	10488 <__call_exitprocs+0xd4>

000104d4 <atexit>:
   104d4:	00050593          	mv	a1,a0
   104d8:	00000693          	li	a3,0
   104dc:	00000613          	li	a2,0
   104e0:	00000513          	li	a0,0
   104e4:	0600006f          	j	10544 <__register_exitproc>

000104e8 <__libc_fini_array>:
   104e8:	ff010113          	addi	sp,sp,-16
   104ec:	00812423          	sw	s0,8(sp)
   104f0:	000117b7          	lui	a5,0x11
   104f4:	00011437          	lui	s0,0x11
   104f8:	63478793          	addi	a5,a5,1588 # 11634 <__do_global_dtors_aux_fini_array_entry>
   104fc:	63840413          	addi	s0,s0,1592 # 11638 <impure_data>
   10500:	40f40433          	sub	s0,s0,a5
   10504:	00912223          	sw	s1,4(sp)
   10508:	00112623          	sw	ra,12(sp)
   1050c:	40245493          	srai	s1,s0,0x2
   10510:	02048063          	beqz	s1,10530 <__libc_fini_array+0x48>
   10514:	ffc40413          	addi	s0,s0,-4
   10518:	00f40433          	add	s0,s0,a5
   1051c:	00042783          	lw	a5,0(s0)
   10520:	fff48493          	addi	s1,s1,-1
   10524:	ffc40413          	addi	s0,s0,-4
   10528:	000780e7          	jalr	a5
   1052c:	fe0498e3          	bnez	s1,1051c <__libc_fini_array+0x34>
   10530:	00c12083          	lw	ra,12(sp)
   10534:	00812403          	lw	s0,8(sp)
   10538:	00412483          	lw	s1,4(sp)
   1053c:	01010113          	addi	sp,sp,16
   10540:	00008067          	ret

00010544 <__register_exitproc>:
   10544:	c281a703          	lw	a4,-984(gp) # 11a60 <_global_impure_ptr>
   10548:	14872783          	lw	a5,328(a4)
   1054c:	04078c63          	beqz	a5,105a4 <__register_exitproc+0x60>
   10550:	0047a703          	lw	a4,4(a5)
   10554:	01f00813          	li	a6,31
   10558:	06e84e63          	blt	a6,a4,105d4 <__register_exitproc+0x90>
   1055c:	00271813          	slli	a6,a4,0x2
   10560:	02050663          	beqz	a0,1058c <__register_exitproc+0x48>
   10564:	01078333          	add	t1,a5,a6
   10568:	08c32423          	sw	a2,136(t1) # 101b8 <main+0x7c>
   1056c:	1887a883          	lw	a7,392(a5)
   10570:	00100613          	li	a2,1
   10574:	00e61633          	sll	a2,a2,a4
   10578:	00c8e8b3          	or	a7,a7,a2
   1057c:	1917a423          	sw	a7,392(a5)
   10580:	10d32423          	sw	a3,264(t1)
   10584:	00200693          	li	a3,2
   10588:	02d50463          	beq	a0,a3,105b0 <__register_exitproc+0x6c>
   1058c:	00170713          	addi	a4,a4,1
   10590:	00e7a223          	sw	a4,4(a5)
   10594:	010787b3          	add	a5,a5,a6
   10598:	00b7a423          	sw	a1,8(a5)
   1059c:	00000513          	li	a0,0
   105a0:	00008067          	ret
   105a4:	14c70793          	addi	a5,a4,332
   105a8:	14f72423          	sw	a5,328(a4)
   105ac:	fa5ff06f          	j	10550 <__register_exitproc+0xc>
   105b0:	18c7a683          	lw	a3,396(a5)
   105b4:	00170713          	addi	a4,a4,1
   105b8:	00e7a223          	sw	a4,4(a5)
   105bc:	00c6e6b3          	or	a3,a3,a2
   105c0:	18d7a623          	sw	a3,396(a5)
   105c4:	010787b3          	add	a5,a5,a6
   105c8:	00b7a423          	sw	a1,8(a5)
   105cc:	00000513          	li	a0,0
   105d0:	00008067          	ret
   105d4:	fff00513          	li	a0,-1
   105d8:	00008067          	ret

000105dc <_exit>:
   105dc:	05d00893          	li	a7,93
   105e0:	00000073          	ecall
   105e4:	00054463          	bltz	a0,105ec <_exit+0x10>
   105e8:	0000006f          	j	105e8 <_exit+0xc>
   105ec:	ff010113          	addi	sp,sp,-16
   105f0:	00812423          	sw	s0,8(sp)
   105f4:	00050413          	mv	s0,a0
   105f8:	00112623          	sw	ra,12(sp)
   105fc:	40800433          	neg	s0,s0
   10600:	00c000ef          	jal	ra,1060c <__errno>
   10604:	00852023          	sw	s0,0(a0)
   10608:	0000006f          	j	10608 <_exit+0x2c>

0001060c <__errno>:
   1060c:	c301a503          	lw	a0,-976(gp) # 11a68 <_impure_ptr>
   10610:	00008067          	ret

Disassembly of section .rodata:

00010614 <.rodata>:
   10614:	0001                	nop
   10616:	0000                	unimp
   10618:	00000003          	lb	zero,0(zero) # 0 <register_fini-0x10074>
   1061c:	0002                	c.slli64	zero
   1061e:	0000                	unimp
   10620:	0004                	0x4
   10622:	0000                	unimp
   10624:	0005                	c.nop	1
	...

Disassembly of section .eh_frame:

00011628 <__FRAME_END__>:
   11628:	0000                	unimp
	...

Disassembly of section .init_array:

0001162c <__init_array_start>:
   1162c:	0074                	addi	a3,sp,12
   1162e:	0001                	nop

00011630 <__frame_dummy_init_array_entry>:
   11630:	011c                	addi	a5,sp,128
   11632:	0001                	nop

Disassembly of section .fini_array:

00011634 <__do_global_dtors_aux_fini_array_entry>:
   11634:	00d8                	addi	a4,sp,68
   11636:	0001                	nop

Disassembly of section .data:

00011638 <impure_data>:
   11638:	0000                	unimp
   1163a:	0000                	unimp
   1163c:	1924                	addi	s1,sp,184
   1163e:	0001                	nop
   11640:	198c                	addi	a1,sp,240
   11642:	0001                	nop
   11644:	19f4                	addi	a3,sp,252
   11646:	0001                	nop
	...
   116e0:	0001                	nop
   116e2:	0000                	unimp
   116e4:	0000                	unimp
   116e6:	0000                	unimp
   116e8:	330e                	fld	ft6,224(sp)
   116ea:	abcd                	j	11cdc <__BSS_END__+0x254>
   116ec:	1234                	addi	a3,sp,296
   116ee:	e66d                	bnez	a2,117d8 <impure_data+0x1a0>
   116f0:	deec                	sw	a1,124(a3)
   116f2:	0005                	c.nop	1
   116f4:	0000000b          	0xb
	...

Disassembly of section .sdata:

00011a60 <_global_impure_ptr>:
   11a60:	1638                	addi	a4,sp,808
   11a62:	0001                	nop

00011a64 <__dso_handle>:
   11a64:	0000                	unimp
	...

00011a68 <_impure_ptr>:
   11a68:	1638                	addi	a4,sp,808
   11a6a:	0001                	nop

Disassembly of section .bss:

00011a6c <completed.1>:
   11a6c:	0000                	unimp
	...

00011a70 <object.0>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	fmsub.d	ft6,ft6,ft4,ft7,rmm
   4:	2820                	fld	fs0,80(s0)
   6:	29554e47          	fmsub.s	ft8,fa0,fs5,ft5,rmm
   a:	3120                	fld	fs0,96(a0)
   c:	2e31                	jal	328 <register_fini-0xfd4c>
   e:	2e31                	jal	32a <register_fini-0xfd4a>
  10:	0030                	addi	a2,sp,8

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	1b41                	addi	s6,s6,-16
   2:	0000                	unimp
   4:	7200                	flw	fs0,32(a2)
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <register_fini-0x10060>
   c:	0011                	c.nop	4
   e:	0000                	unimp
  10:	1004                	addi	s1,sp,32
  12:	7205                	lui	tp,0xfffe1
  14:	3376                	fld	ft6,376(sp)
  16:	6932                	flw	fs2,12(sp)
  18:	7032                	flw	ft0,44(sp)
  1a:	0030                	addi	a2,sp,8
