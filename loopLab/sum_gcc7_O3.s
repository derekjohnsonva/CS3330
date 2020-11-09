	.file	"sum.c"
	.text
	.p2align 4,,15
	.globl	sum_gcc7_O3
	.type	sum_gcc7_O3, @function
sum_gcc7_O3:
.LFB0:
	.cfi_startproc
	testq	%rdi, %rdi
	jle	.L10
	movq	%rsi, %rcx
	leaq	-1(%rdi), %rdx
	movl	$20, %r8d
	shrq	%rcx
	negq	%rcx
	andl	$15, %ecx
	leaq	15(%rcx), %rax
	cmpq	$20, %rax
	cmovb	%r8, %rax
	cmpq	%rax, %rdx
	jb	.L11
	testq	%rcx, %rcx
	je	.L12
	cmpq	$1, %rcx
	movzwl	(%rsi), %r9d
	je	.L13
	addw	2(%rsi), %r9w
	cmpq	$2, %rcx
	je	.L14
	addw	4(%rsi), %r9w
	cmpq	$3, %rcx
	je	.L15
	addw	6(%rsi), %r9w
	cmpq	$4, %rcx
	je	.L16
	addw	8(%rsi), %r9w
	cmpq	$5, %rcx
	je	.L17
	addw	10(%rsi), %r9w
	cmpq	$6, %rcx
	je	.L18
	movzwl	12(%rsi), %eax
	addl	%r9d, %eax
	cmpq	$7, %rcx
	movl	%eax, %r9d
	je	.L19
	addw	14(%rsi), %ax
	cmpq	$8, %rcx
	movl	%eax, %r9d
	je	.L20
	addw	16(%rsi), %r9w
	cmpq	$9, %rcx
	je	.L21
	addw	18(%rsi), %r9w
	cmpq	$10, %rcx
	je	.L22
	addw	20(%rsi), %r9w
	cmpq	$11, %rcx
	je	.L23
	addw	22(%rsi), %r9w
	cmpq	$12, %rcx
	je	.L24
	addw	24(%rsi), %r9w
	cmpq	$13, %rcx
	je	.L25
	addw	26(%rsi), %r9w
	cmpq	$15, %rcx
	jne	.L26
	addw	28(%rsi), %r9w
	movl	$15, %edx
	.p2align 4,,10
	.p2align 3
.L4:
	movq	%rdi, %r10
	vpxor	%xmm0, %xmm0, %xmm0
	subq	%rcx, %r10
	leaq	(%rsi,%rcx,2), %r8
	xorl	%ecx, %ecx
	movq	%r10, %rax
	shrq	$4, %rax
	.p2align 4,,10
	.p2align 3
.L6:
	addq	$1, %rcx
	vpaddw	(%r8), %ymm0, %ymm0
	addq	$32, %r8
	cmpq	%rcx, %rax
	ja	.L6
	vpxor	%xmm1, %xmm1, %xmm1
	movq	%r10, %rcx
	andq	$-16, %rcx
	addl	%ecx, %edx
	vperm2i128	$33, %ymm1, %ymm0, %ymm2
	vpaddw	%ymm2, %ymm0, %ymm0
	vperm2i128	$33, %ymm1, %ymm0, %ymm2
	vpalignr	$8, %ymm0, %ymm2, %ymm2
	vpaddw	%ymm2, %ymm0, %ymm0
	vperm2i128	$33, %ymm1, %ymm0, %ymm2
	vpalignr	$4, %ymm0, %ymm2, %ymm2
	vpaddw	%ymm2, %ymm0, %ymm0
	vperm2i128	$33, %ymm1, %ymm0, %ymm1
	vpalignr	$2, %ymm0, %ymm1, %ymm1
	vpaddw	%ymm1, %ymm0, %ymm0
	vpextrw	$0, %xmm0, %eax
	addl	%r9d, %eax
	cmpq	%rcx, %r10
	je	.L32
	vzeroupper
.L3:
	movslq	%edx, %rdx
	.p2align 4,,10
	.p2align 3
.L9:
	addw	(%rsi,%rdx,2), %ax
	addq	$1, %rdx
	cmpq	%rdx, %rdi
	jg	.L9
	rep ret
	.p2align 4,,10
	.p2align 3
.L15:
	movl	$3, %edx
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L10:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	movl	$1, %edx
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L14:
	movl	$2, %edx
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L11:
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L16:
	movl	$4, %edx
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L17:
	movl	$5, %edx
	jmp	.L4
.L20:
	movl	$8, %edx
	jmp	.L4
.L32:
	vzeroupper
	ret
.L12:
	xorl	%edx, %edx
	xorl	%r9d, %r9d
	jmp	.L4
.L18:
	movl	$6, %edx
	jmp	.L4
.L19:
	movl	$7, %edx
	jmp	.L4
.L21:
	movl	$9, %edx
	jmp	.L4
.L22:
	movl	$10, %edx
	jmp	.L4
.L23:
	movl	$11, %edx
	jmp	.L4
.L24:
	movl	$12, %edx
	jmp	.L4
.L25:
	movl	$13, %edx
	jmp	.L4
.L26:
	movl	$14, %edx
	jmp	.L4
	.cfi_endproc
.LFE0:
	.size	sum_gcc7_O3, .-sum_gcc7_O3
	.ident	"GCC: (GNU) 7.1.0"
	.section	.note.GNU-stack,"",@progbits
