	.file	"min_benchmarks.c"
	.text
	.globl	min_C
	.type	min_C, @function
min_C:
.LFB5278:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L4
	movl	$0, %eax
	movl	$32767, %edx
.L3:
	movslq	%eax, %rcx
	movzwl	(%rsi,%rcx,2), %ecx
	cmpw	%cx, %dx
	cmovg	%ecx, %edx
	incl	%eax
	movslq	%eax, %rcx
	cmpq	%rdi, %rcx
	jl	.L3
.L1:
	movl	%edx, %eax
	ret
.L4:
	movl	$32767, %edx
	jmp	.L1
	.cfi_endproc
.LFE5278:
	.size	min_C, .-min_C
	.globl	min_AVX
	.type	min_AVX, @function
min_AVX:
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
	vmovdqu	(%rsi), %ymm0
	cmpq	$16, %rdi
	jle	.L7
	movl	$16, %eax
.L8:
	movslq	%eax, %rdx
	vpminsw	(%rsi,%rdx,2), %ymm0, %ymm0
	addl	$16, %eax
	movslq	%eax, %rdx
	cmpq	%rdi, %rdx
	jl	.L8
.L7:
	vmovdqu	%ymm0, 16(%rsp)
	vpextrw	$0, %xmm0, %eax
	leaq	18(%rsp), %rdx
	leaq	48(%rsp), %rsi
.L9:
	movzwl	(%rdx), %ecx
	cmpl	%ecx, %eax
	cmovg	%ecx, %eax
	addq	$2, %rdx
	cmpq	%rsi, %rdx
	jne	.L9
	movq	56(%rsp), %rdi
	xorq	%fs:40, %rdi
	jne	.L14
	leave
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L14:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE5279:
	.size	min_AVX, .-min_AVX
	.globl	functions
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"C (local)"
.LC1:
	.string	"min with AVX commands"
	.section	.data.rel.local,"aw"
	.align 32
	.type	functions, @object
	.size	functions, 48
functions:
	.quad	min_C
	.quad	.LC0
	.quad	min_AVX
	.quad	.LC1
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
