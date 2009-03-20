
quicksort.elf:     file format elf32-littlemips

Disassembly of section .text:

00000000 <entrypoint>:
   0:	3c1d0008 	lui	sp,0x8
   4:	37bd7f80 	ori	sp,sp,0x7f80
   8:	3c1c0008 	lui	gp,0x8
   c:	0c00005c 	jal	170 <mc_main>
  10:	279c0000 	addiu	gp,gp,0

00000014 <quicksort>:
  14:	27bdffa0 	addiu	sp,sp,-96
  18:	3c020008 	lui	v0,0x8
  1c:	afb50054 	sw	s5,84(sp)
  20:	afb40050 	sw	s4,80(sp)
  24:	afb3004c 	sw	s3,76(sp)
  28:	afb20048 	sw	s2,72(sp)
  2c:	afb10044 	sw	s1,68(sp)
  30:	afbf0058 	sw	ra,88(sp)
  34:	afb00040 	sw	s0,64(sp)
  38:	00a09821 	move	s3,a1
  3c:	24510004 	addiu	s1,v0,4
  40:	27b20010 	addiu	s2,sp,16
  44:	27b50028 	addiu	s5,sp,40
  48:	24b40001 	addiu	s4,a1,1
  4c:	00041080 	sll	v0,a0,0x2
  50:	00511021 	addu	v0,v0,s1
  54:	1093003d 	beq	a0,s3,14c <quicksort+0x138>
  58:	8c4a0000 	lw	t2,0(v0)
  5c:	24820001 	addiu	v0,a0,1
  60:	00021080 	sll	v0,v0,0x2
  64:	00513021 	addu	a2,v0,s1
  68:	00802821 	move	a1,a0
  6c:	00008021 	move	s0,zero
  70:	08000028 	j	a0 <quicksort+0x8c>
  74:	00004821 	move	t1,zero
  78:	8cc30000 	lw	v1,0(a2)
  7c:	006a102a 	slt	v0,v1,t2
  80:	10400004 	beqz	v0,94 <quicksort+0x80>
  84:	24a50001 	addiu	a1,a1,1
  88:	25290001 	addiu	t1,t1,1
  8c:	08000027 	j	9c <quicksort+0x88>
  90:	ace30000 	sw	v1,0(a3)
  94:	ad030018 	sw	v1,24(t0)
  98:	26100001 	addiu	s0,s0,1
  9c:	24c60004 	addiu	a2,a2,4
  a0:	00101080 	sll	v0,s0,0x2
  a4:	00524021 	addu	t0,v0,s2
  a8:	00091080 	sll	v0,t1,0x2
  ac:	00523821 	addu	a3,v0,s2
  b0:	00b3102a 	slt	v0,a1,s3
  b4:	1440fff0 	bnez	v0,78 <quicksort+0x64>
  b8:	00041080 	sll	v0,a0,0x2
  bc:	00513821 	addu	a3,v0,s1
  c0:	02403021 	move	a2,s2
  c4:	00802821 	move	a1,a0
  c8:	08000037 	j	dc <quicksort+0xc8>
  cc:	00004021 	move	t0,zero
  d0:	8cc2fffc 	lw	v0,-4(a2)
  d4:	00602821 	move	a1,v1
  d8:	ace2fffc 	sw	v0,-4(a3)
  dc:	0109102a 	slt	v0,t0,t1
  e0:	24c60004 	addiu	a2,a2,4
  e4:	25080001 	addiu	t0,t0,1
  e8:	24e70004 	addiu	a3,a3,4
  ec:	1440fff8 	bnez	v0,d0 <quicksort+0xbc>
  f0:	24a30001 	addiu	v1,a1,1
  f4:	00051080 	sll	v0,a1,0x2
  f8:	00031880 	sll	v1,v1,0x2
  fc:	00511021 	addu	v0,v0,s1
 100:	00711821 	addu	v1,v1,s1
 104:	02a02821 	move	a1,s5
 108:	00003021 	move	a2,zero
 10c:	08000047 	j	11c <quicksort+0x108>
 110:	ac4a0000 	sw	t2,0(v0)
 114:	8ca2fffc 	lw	v0,-4(a1)
 118:	ac62fffc 	sw	v0,-4(v1)
 11c:	00d0102a 	slt	v0,a2,s0
 120:	24a50004 	addiu	a1,a1,4
 124:	24c60001 	addiu	a2,a2,1
 128:	1440fffa 	bnez	v0,114 <quicksort+0x100>
 12c:	24630004 	addiu	v1,v1,4
 130:	19200004 	blez	t1,144 <quicksort+0x130>
 134:	00000000 	nop
 138:	2485ffff 	addiu	a1,a0,-1
 13c:	0c000005 	jal	14 <quicksort>
 140:	00a92821 	addu	a1,a1,t1
 144:	1e00ffc1 	bgtz	s0,4c <quicksort+0x38>
 148:	02902023 	subu	a0,s4,s0
 14c:	8fbf0058 	lw	ra,88(sp)
 150:	8fb50054 	lw	s5,84(sp)
 154:	8fb40050 	lw	s4,80(sp)
 158:	8fb3004c 	lw	s3,76(sp)
 15c:	8fb20048 	lw	s2,72(sp)
 160:	8fb10044 	lw	s1,68(sp)
 164:	8fb00040 	lw	s0,64(sp)
 168:	03e00008 	jr	ra
 16c:	27bd0060 	addiu	sp,sp,96

00000170 <mc_main>:
 170:	27bdffe0 	addiu	sp,sp,-32
 174:	afb10014 	sw	s1,20(sp)
 178:	24020022 	li	v0,34
 17c:	3c110008 	lui	s1,0x8
 180:	afb00010 	sw	s0,16(sp)
 184:	ae220004 	sw	v0,4(s1)
 188:	26300004 	addiu	s0,s1,4
 18c:	2402002d 	li	v0,45
 190:	ae020004 	sw	v0,4(s0)
 194:	24020003 	li	v0,3
 198:	ae020008 	sw	v0,8(s0)
 19c:	24020017 	li	v0,23
 1a0:	ae02000c 	sw	v0,12(s0)
 1a4:	2402004d 	li	v0,77
 1a8:	00002021 	move	a0,zero
 1ac:	ae020010 	sw	v0,16(s0)
 1b0:	2402000c 	li	v0,12
 1b4:	ae020014 	sw	v0,20(s0)
 1b8:	afbf0018 	sw	ra,24(sp)
 1bc:	0c000005 	jal	14 <quicksort>
 1c0:	24050005 	li	a1,5
 1c4:	8e070014 	lw	a3,20(s0)
 1c8:	8e020004 	lw	v0,4(s0)
 1cc:	8e030008 	lw	v1,8(s0)
 1d0:	8e04000c 	lw	a0,12(s0)
 1d4:	8e050010 	lw	a1,16(s0)
 1d8:	8e260004 	lw	a2,4(s1)
 1dc:	ac064545 	sw	a2,17733(zero)
 1e0:	ac024545 	sw	v0,17733(zero)
 1e4:	ac034545 	sw	v1,17733(zero)
 1e8:	ac044545 	sw	a0,17733(zero)
 1ec:	ac054545 	sw	a1,17733(zero)
 1f0:	ac074545 	sw	a3,17733(zero)
 1f4:	0800007d 	j	1f4 <mc_main+0x84>
 1f8:	00000000 	nop
