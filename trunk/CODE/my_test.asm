
my_test.elf:     file format elf32-littlemips

Disassembly of section .text:

00000000 <entrypoint>:
   0:	3c1d0008 	lui	sp,0x8
   4:	37bd7f80 	ori	sp,sp,0x7f80
   8:	3c1c0008 	lui	gp,0x8
   c:	0c000038 	jal	e0 <mc_main>
  10:	279c0000 	addiu	gp,gp,0

00000014 <swap>:
  14:	00052880 	sll	a1,a1,0x2
  18:	24830004 	addiu	v1,a0,4
  1c:	00651821 	addu	v1,v1,a1
  20:	00852021 	addu	a0,a0,a1
  24:	8c850000 	lw	a1,0(a0)
  28:	8c620000 	lw	v0,0(v1)
  2c:	00000000 	nop
  30:	ac820000 	sw	v0,0(a0)
  34:	03e00008 	jr	ra
  38:	ac650000 	sw	a1,0(v1)

0000003c <sort>:
  3c:	27bdffd0 	addiu	sp,sp,-48
  40:	afb50024 	sw	s5,36(sp)
  44:	afb40020 	sw	s4,32(sp)
  48:	afb3001c 	sw	s3,28(sp)
  4c:	afb20018 	sw	s2,24(sp)
  50:	0080a021 	move	s4,a0
  54:	00a0a821 	move	s5,a1
  58:	00809021 	move	s2,a0
  5c:	00009821 	move	s3,zero
  60:	afbf0028 	sw	ra,40(sp)
  64:	afb10014 	sw	s1,20(sp)
  68:	0800002c 	j	b0 <sort+0x74>
  6c:	afb00010 	sw	s0,16(sp)
  70:	08000020 	j	80 <sort+0x44>
  74:	02408021 	move	s0,s2
  78:	0c000005 	jal	14 <swap>
  7c:	00000000 	nop
  80:	2402ffff 	li	v0,-1
  84:	02202821 	move	a1,s1
  88:	12220007 	beq	s1,v0,a8 <sort+0x6c>
  8c:	02802021 	move	a0,s4
  90:	8e02fffc 	lw	v0,-4(s0)
  94:	8e030000 	lw	v1,0(s0)
  98:	2631ffff 	addiu	s1,s1,-1
  9c:	0062102a 	slt	v0,v1,v0
  a0:	1440fff5 	bnez	v0,78 <sort+0x3c>
  a4:	2610fffc 	addiu	s0,s0,-4
  a8:	26730001 	addiu	s3,s3,1
  ac:	26520004 	addiu	s2,s2,4
  b0:	0275102a 	slt	v0,s3,s5
  b4:	1440ffee 	bnez	v0,70 <sort+0x34>
  b8:	2671ffff 	addiu	s1,s3,-1
  bc:	8fbf0028 	lw	ra,40(sp)
  c0:	8fb50024 	lw	s5,36(sp)
  c4:	8fb40020 	lw	s4,32(sp)
  c8:	8fb3001c 	lw	s3,28(sp)
  cc:	8fb20018 	lw	s2,24(sp)
  d0:	8fb10014 	lw	s1,20(sp)
  d4:	8fb00010 	lw	s0,16(sp)
  d8:	03e00008 	jr	ra
  dc:	27bd0030 	addiu	sp,sp,48

000000e0 <mc_main>:
  e0:	3c030008 	lui	v1,0x8
  e4:	24620000 	addiu	v0,v1,0
  e8:	27bdffd0 	addiu	sp,sp,-48
  ec:	8c490014 	lw	t1,20(v0)
  f0:	8c460004 	lw	a2,4(v0)
  f4:	8c470008 	lw	a3,8(v0)
  f8:	8c48000c 	lw	t0,12(v0)
  fc:	8c630000 	lw	v1,0(v1)
 100:	8c420010 	lw	v0,16(v0)
 104:	27a40010 	addiu	a0,sp,16
 108:	24050006 	li	a1,6
 10c:	afa20020 	sw	v0,32(sp)
 110:	afbf0028 	sw	ra,40(sp)
 114:	afa30010 	sw	v1,16(sp)
 118:	afa60014 	sw	a2,20(sp)
 11c:	afa70018 	sw	a3,24(sp)
 120:	afa8001c 	sw	t0,28(sp)
 124:	0c00000f 	jal	3c <sort>
 128:	afa90024 	sw	t1,36(sp)
 12c:	8fa20010 	lw	v0,16(sp)
 130:	00000000 	nop
 134:	ac024545 	sw	v0,17733(zero)
 138:	8fa20014 	lw	v0,20(sp)
 13c:	00000000 	nop
 140:	ac024545 	sw	v0,17733(zero)
 144:	8fa20018 	lw	v0,24(sp)
 148:	00000000 	nop
 14c:	ac024545 	sw	v0,17733(zero)
 150:	8fa2001c 	lw	v0,28(sp)
 154:	00000000 	nop
 158:	ac024545 	sw	v0,17733(zero)
 15c:	8fa20020 	lw	v0,32(sp)
 160:	00000000 	nop
 164:	ac024545 	sw	v0,17733(zero)
 168:	8fa20024 	lw	v0,36(sp)
 16c:	00000000 	nop
 170:	ac024545 	sw	v0,17733(zero)
 174:	0800005d 	j	174 <mc_main+0x94>
 178:	00000000 	nop
