	.file	"dot_product_benchmarks.c"
	.text
	.globl	dot_product_C
	.type	dot_product_C, @function
dot_product_C:
.LFB5278:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L4
	movl	$0, %eax
	movl	$0, %r9d
.L3:
	movslq	%eax, %r8
	movzwl	(%rsi,%r8,2), %ecx
	movzwl	(%rdx,%r8,2), %r8d
	imull	%r8d, %ecx
	addl	%ecx, %r9d
	incl	%eax
	movslq	%eax, %rcx
	cmpq	%rdi, %rcx
	jl	.L3
.L1:
	movl	%r9d, %eax
	ret
.L4:
	movl	$0, %r9d
	jmp	.L1
	.cfi_endproc
.LFE5278:
	.size	dot_product_C, .-dot_product_C
	.globl	dot_product_AVX
	.type	dot_product_AVX, @function
dot_product_AVX:
.LFB5279:
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
	jle	.L11
	vpxor	%xmm1, %xmm1, %xmm1
.L8:
	movslq	%eax, %rcx
	vpmovzxwd	(%rsi,%rcx,2), %ymm2
	vpmovzxwd	(%rdx,%rcx,2), %ymm0
	vpmulld	%ymm2, %ymm0, %ymm0
	vpaddd	%ymm1, %ymm0, %ymm1
	addl	$8, %eax
	movslq	%eax, %rcx
	cmpq	%rdi, %rcx
	jl	.L8
.L7:
	vmovdqu	%ymm1, 16(%rsp)
	leaq	16(%rsp), %rax
	leaq	48(%rsp), %rcx
	movl	$0, %edx
.L9:
	addl	(%rax), %edx
	addq	$4, %rax
	cmpq	%rcx, %rax
	jne	.L9
	movq	56(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L15
	movl	%edx, %eax
	leave
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L11:
	.cfi_restore_state
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.L7
.L15:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE5279:
	.size	dot_product_AVX, .-dot_product_AVX
	.globl	functions
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"C (local)"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"C (compiled with GCC7.2 -O3 -mavx2)"
	.section	.rodata.str1.1
.LC2:
	.string	"Using AVX commands"
	.section	.data.rel,"aw"
	.align 32
	.type	functions, @object
	.size	functions, 64
functions:
	.quad	dot_product_C
	.quad	.LC0
	.quad	dot_product_gcc7_O3
	.quad	.LC1
	.quad	dot_product_AVX
	.quad	.LC2
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
