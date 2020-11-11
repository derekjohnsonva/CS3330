	.file	"dot_product_alone.c"
	.text
	.p2align 4,,15
	.globl	dot_product_gcc7_O3
	.type	dot_product_gcc7_O3, @function
dot_product_gcc7_O3:
.LFB0:
	.cfi_startproc
	testq	%rdi, %rdi
	jle	.L9
	movq	%rsi, %r9
	leaq	8(%rsp), %r10
	.cfi_def_cfa 10, 0
	leaq	-1(%rdi), %rcx
	shrq	%r9
	andq	$-32, %rsp
	movl	$17, %r8d
	negq	%r9
	pushq	-8(%r10)
	pushq	%rbp
	andl	$15, %r9d
	leaq	15(%r9), %rax
	.cfi_escape 0x10,0x6,0x2,0x76,0
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%r10
	.cfi_escape 0xf,0x3,0x76,0x68,0x6
	.cfi_escape 0x10,0xd,0x2,0x76,0x78
	.cfi_escape 0x10,0xc,0x2,0x76,0x70
	cmpq	$17, %rax
	pushq	%rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x60
	cmovb	%r8, %rax
	cmpq	%rax, %rcx
	jb	.L10
	testq	%r9, %r9
	je	.L11
	movzwl	(%rsi), %r13d
	movzwl	(%rdx), %eax
	imull	%eax, %r13d
	cmpq	$1, %r9
	je	.L12
	movzwl	2(%rsi), %eax
	movzwl	2(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$2, %r9
	je	.L13
	movzwl	4(%rsi), %eax
	movzwl	4(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$3, %r9
	je	.L14
	movzwl	6(%rsi), %eax
	movzwl	6(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$4, %r9
	je	.L15
	movzwl	8(%rsi), %eax
	movzwl	8(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$5, %r9
	je	.L16
	movzwl	10(%rsi), %eax
	movzwl	10(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$6, %r9
	je	.L17
	movzwl	12(%rsi), %eax
	movzwl	12(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$7, %r9
	je	.L18
	movzwl	14(%rsi), %eax
	movzwl	14(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$8, %r9
	je	.L19
	movzwl	16(%rsi), %eax
	movzwl	16(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$9, %r9
	je	.L20
	movzwl	18(%rsi), %eax
	movzwl	18(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$10, %r9
	je	.L21
	movzwl	20(%rsi), %eax
	movzwl	20(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$11, %r9
	je	.L22
	movzwl	22(%rsi), %eax
	movzwl	22(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$12, %r9
	je	.L23
	movzwl	24(%rsi), %eax
	movzwl	24(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$13, %r9
	je	.L24
	movzwl	26(%rsi), %eax
	movzwl	26(%rdx), %ecx
	imull	%ecx, %eax
	addl	%eax, %r13d
	cmpq	$15, %r9
	jne	.L25
	movzwl	28(%rsi), %ecx
	movzwl	28(%rdx), %eax
	imull	%ecx, %eax
	movl	$15, %ecx
	addl	%eax, %r13d
	.p2align 4,,10
	.p2align 3
.L4:
	movq	%rdi, %rbx
	vpxor	%xmm0, %xmm0, %xmm0
	subq	%r9, %rbx
	addq	%r9, %r9
	xorl	%r8d, %r8d
	movq	%rbx, %r12
	leaq	(%rsi,%r9), %r11
	xorl	%r10d, %r10d
	shrq	$4, %r12
	addq	%rdx, %r9
	.p2align 4,,10
	.p2align 3
.L6:
	vmovdqu	(%r9,%r8), %xmm3
	addq	$1, %r10
	vinserti128	$0x1, 16(%r9,%r8), %ymm3, %ymm3
	vmovdqa	(%r11,%r8), %ymm1
	addq	$32, %r8
	cmpq	%r10, %r12
	vpmullw	%ymm3, %ymm1, %ymm2
	vpmulhuw	%ymm3, %ymm1, %ymm3
	vpunpcklwd	%ymm3, %ymm2, %ymm1
	vpunpckhwd	%ymm3, %ymm2, %ymm2
	vperm2i128	$32, %ymm2, %ymm1, %ymm3
	vperm2i128	$49, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm3, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm0
	ja	.L6
	vpxor	%xmm1, %xmm1, %xmm1
	movq	%rbx, %r8
	andq	$-16, %r8
	addl	%r8d, %ecx
	vperm2i128	$33, %ymm1, %ymm0, %ymm2
	vpaddd	%ymm2, %ymm0, %ymm0
	vperm2i128	$33, %ymm1, %ymm0, %ymm2
	vpalignr	$8, %ymm0, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm0, %ymm0
	vperm2i128	$33, %ymm1, %ymm0, %ymm1
	vpalignr	$4, %ymm0, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm0
	vmovd	%xmm0, %eax
	addl	%r13d, %eax
	cmpq	%r8, %rbx
	je	.L35
	vzeroupper
.L3:
	movslq	%ecx, %rcx
	.p2align 4,,10
	.p2align 3
.L8:
	movzwl	(%rsi,%rcx,2), %r8d
	movzwl	(%rdx,%rcx,2), %r9d
	addq	$1, %rcx
	imull	%r9d, %r8d
	addl	%r8d, %eax
	cmpq	%rcx, %rdi
	jg	.L8
.L29:
	popq	%rbx
	popq	%r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	popq	%r12
	popq	%r13
	popq	%rbp
	leaq	-8(%r10), %rsp
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L14:
	.cfi_restore_state
	movl	$3, %ecx
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L9:
	.cfi_def_cfa 7, 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L12:
	.cfi_escape 0xf,0x3,0x76,0x68,0x6
	.cfi_escape 0x10,0x3,0x2,0x76,0x60
	.cfi_escape 0x10,0x6,0x2,0x76,0
	.cfi_escape 0x10,0xc,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x78
	movl	$1, %ecx
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L13:
	movl	$2, %ecx
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L10:
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L15:
	movl	$4, %ecx
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L16:
	movl	$5, %ecx
	jmp	.L4
.L19:
	movl	$8, %ecx
	jmp	.L4
.L35:
	vzeroupper
	jmp	.L29
.L11:
	xorl	%ecx, %ecx
	xorl	%r13d, %r13d
	jmp	.L4
.L17:
	movl	$6, %ecx
	jmp	.L4
.L18:
	movl	$7, %ecx
	jmp	.L4
.L20:
	movl	$9, %ecx
	jmp	.L4
.L21:
	movl	$10, %ecx
	jmp	.L4
.L22:
	movl	$11, %ecx
	jmp	.L4
.L23:
	movl	$12, %ecx
	jmp	.L4
.L24:
	movl	$13, %ecx
	jmp	.L4
.L25:
	movl	$14, %ecx
	jmp	.L4
	.cfi_endproc
.LFE0:
	.size	dot_product_gcc7_O3, .-dot_product_gcc7_O3
	.ident	"GCC: (GNU) 7.1.0"
	.section	.note.GNU-stack,"",@progbits
