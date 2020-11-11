	.file	"sum_benchmarks.c"
	.text
	.globl	sum_C
	.type	sum_C, @function
sum_C:
.LFB5278:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L4
	movl	$0, %eax
	movl	$0, %edx
.L3:
	movslq	%eax, %rcx
	addw	(%rsi,%rcx,2), %dx
	incl	%eax
	movslq	%eax, %rcx
	cmpq	%rdi, %rcx
	jl	.L3
.L1:
	movl	%edx, %eax
	ret
.L4:
	movl	$0, %edx
	jmp	.L1
	.cfi_endproc
.LFE5278:
	.size	sum_C, .-sum_C
	.globl	sum_with_sixteen_accumulators
	.type	sum_with_sixteen_accumulators, @function
sum_with_sixteen_accumulators:
.LFB5279:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, -8(%rsp)
	testq	%rdi, %rdi
	jle	.L9
	movl	$0, %edx
	movl	$0, %ecx
	movl	$0, %edi
	movl	$0, %r8d
	movl	$0, %r9d
	movl	$0, %r10d
	movl	$0, %r11d
	movl	$0, %ebx
	movl	$0, %ebp
	movl	$0, %r12d
	movl	$0, %r13d
	movl	$0, %r14d
	movl	$0, %r15d
	movw	$0, -12(%rsp)
	movw	$0, -14(%rsp)
	movw	$0, -16(%rsp)
	movw	$0, -18(%rsp)
	movw	%cx, -10(%rsp)
.L8:
	movslq	%edx, %rax
	movzwl	(%rsi,%rax,2), %ecx
	addw	%cx, -18(%rsp)
	movzwl	2(%rsi,%rax,2), %ecx
	addw	%cx, -16(%rsp)
	movzwl	4(%rsi,%rax,2), %ecx
	addw	%cx, -14(%rsp)
	movzwl	6(%rsi,%rax,2), %ecx
	addw	%cx, -12(%rsp)
	addw	8(%rsi,%rax,2), %r15w
	addw	10(%rsi,%rax,2), %r14w
	addw	12(%rsi,%rax,2), %r13w
	addw	14(%rsi,%rax,2), %r12w
	addw	16(%rsi,%rax,2), %bp
	addw	18(%rsi,%rax,2), %bx
	addw	20(%rsi,%rax,2), %r11w
	addw	22(%rsi,%rax,2), %r10w
	addw	24(%rsi,%rax,2), %r9w
	addw	26(%rsi,%rax,2), %r8w
	addw	28(%rsi,%rax,2), %di
	movzwl	30(%rsi,%rax,2), %eax
	addw	%ax, -10(%rsp)
	addl	$16, %edx
	movslq	%edx, %rax
	cmpq	-8(%rsp), %rax
	jl	.L8
	movzwl	-10(%rsp), %ecx
.L7:
	movzwl	-14(%rsp), %eax
	addw	-12(%rsp), %ax
	addl	%r15d, %eax
	addl	%r14d, %eax
	addl	%r13d, %eax
	addl	%r12d, %eax
	addl	%ebp, %eax
	addl	%ebx, %eax
	addl	%r11d, %eax
	addl	%r10d, %eax
	addl	%r9d, %eax
	addl	%r8d, %eax
	addl	%edi, %eax
	addl	%eax, %ecx
	movzwl	-18(%rsp), %eax
	addw	-16(%rsp), %ax
	addl	%ecx, %eax
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L9:
	.cfi_restore_state
	movl	$0, %ecx
	movl	$0, %edi
	movl	$0, %r8d
	movl	$0, %r9d
	movl	$0, %r10d
	movl	$0, %r11d
	movl	$0, %ebx
	movl	$0, %ebp
	movl	$0, %r12d
	movl	$0, %r13d
	movl	$0, %r14d
	movl	$0, %r15d
	movw	$0, -12(%rsp)
	movw	$0, -14(%rsp)
	movw	$0, -16(%rsp)
	movw	$0, -18(%rsp)
	jmp	.L7
	.cfi_endproc
.LFE5279:
	.size	sum_with_sixteen_accumulators, .-sum_with_sixteen_accumulators
	.globl	sum_AVX
	.type	sum_AVX, @function
sum_AVX:
.LFB5280:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	andq	$-32, %rsp
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	jle	.L17
	vpxor	%xmm0, %xmm0, %xmm0
.L14:
	movslq	%eax, %rdx
	vpaddw	(%rsi,%rdx,2), %ymm0, %ymm0
	addl	$16, %eax
	movslq	%eax, %rdx
	cmpq	%rdi, %rdx
	jl	.L14
.L13:
	vmovdqu	%ymm0, 16(%rsp)
	leaq	16(%rsp), %rdx
	leaq	48(%rsp), %rsi
	movl	$0, %eax
.L15:
	movzwl	(%rdx), %ecx
	addl	%ecx, %eax
	addq	$2, %rdx
	cmpq	%rsi, %rdx
	jne	.L15
	movq	56(%rsp), %rdi
	xorq	%fs:40, %rdi
	jne	.L21
	leave
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L17:
	.cfi_restore_state
	vpxor	%xmm0, %xmm0, %xmm0
	jmp	.L13
.L21:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE5280:
	.size	sum_AVX, .-sum_AVX
	.globl	sum_with_eight_accumulators
	.type	sum_with_eight_accumulators, @function
sum_with_eight_accumulators:
.LFB5281:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	testq	%rdi, %rdi
	jle	.L25
	movl	$0, %edx
	movl	$0, %r10d
	movl	$0, %r11d
	movl	$0, %ebx
	movl	$0, %ebp
	movl	$0, %r12d
	movl	$0, %ecx
	movl	$0, %r9d
	movl	$0, %r8d
.L24:
	movslq	%edx, %rax
	addw	(%rsi,%rax,2), %r8w
	addw	2(%rsi,%rax,2), %r9w
	addw	4(%rsi,%rax,2), %cx
	addw	6(%rsi,%rax,2), %r12w
	addw	8(%rsi,%rax,2), %bp
	addw	10(%rsi,%rax,2), %bx
	addw	12(%rsi,%rax,2), %r11w
	addw	14(%rsi,%rax,2), %r10w
	addl	$8, %edx
	movslq	%edx, %rax
	cmpq	%rdi, %rax
	jl	.L24
.L23:
	addl	%r12d, %ecx
	leal	(%rcx,%rbp), %eax
	addl	%ebx, %eax
	addl	%r11d, %eax
	addl	%r10d, %eax
	addl	%r9d, %r8d
	addl	%r8d, %eax
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L25:
	.cfi_restore_state
	movl	$0, %r10d
	movl	$0, %r11d
	movl	$0, %ebx
	movl	$0, %ebp
	movl	$0, %r12d
	movl	$0, %ecx
	movl	$0, %r9d
	movl	$0, %r8d
	jmp	.L23
	.cfi_endproc
.LFE5281:
	.size	sum_with_eight_accumulators, .-sum_with_eight_accumulators
	.globl	functions
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"C (local)"
.LC1:
	.string	"C (clang6 -O)"
.LC2:
	.string	"sixteen accumulators (C)"
.LC3:
	.string	"eight accumulators (C)"
.LC4:
	.string	"using AVX commands (C)"
	.section	.data.rel,"aw"
	.align 32
	.type	functions, @object
	.size	functions, 96
functions:
	.quad	sum_C
	.quad	.LC0
	.quad	sum_clang6_O
	.quad	.LC1
	.quad	sum_with_sixteen_accumulators
	.quad	.LC2
	.quad	sum_with_eight_accumulators
	.quad	.LC3
	.quad	sum_AVX
	.quad	.LC4
	.quad	0
	.quad	0
	.ident	"GCC: (Ubuntu 9.3.0-10ubuntu2) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
