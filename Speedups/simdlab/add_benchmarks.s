	.file	"add_benchmarks.c"
	.text
	.globl	add
	.type	add, @function
add:
.LFB5278:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L1
	movl	$0, %eax
.L3:
	movslq	%eax, %rcx
	movzwl	(%rdx,%rcx,2), %r8d
	addw	%r8w, (%rsi,%rcx,2)
	incl	%eax
	movslq	%eax, %rcx
	cmpq	%rdi, %rcx
	jl	.L3
.L1:
	ret
	.cfi_endproc
.LFE5278:
	.size	add, .-add
	.globl	add_AVX
	.type	add_AVX, @function
add_AVX:
.LFB5279:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L5
	movl	$0, %eax
.L7:
	movslq	%eax, %r8
	leaq	(%rsi,%r8,2), %rcx
	vmovdqu	(%rdx,%r8,2), %ymm1
	vpaddw	(%rcx), %ymm1, %ymm0
	vmovdqu	%ymm0, (%rcx)
	addl	$16, %eax
	movslq	%eax, %rcx
	cmpq	%rdi, %rcx
	jl	.L7
.L5:
	ret
	.cfi_endproc
.LFE5279:
	.size	add_AVX, .-add_AVX
	.globl	add_SSE
	.type	add_SSE, @function
add_SSE:
.LFB5280:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L9
	movl	$0, %eax
.L11:
	movslq	%eax, %r8
	leaq	(%rsi,%r8,2), %rcx
	vmovdqu	(%rdx,%r8,2), %xmm1
	vpaddw	(%rcx), %xmm1, %xmm0
	vmovups	%xmm0, (%rcx)
	addl	$8, %eax
	movslq	%eax, %rcx
	cmpq	%rdi, %rcx
	jl	.L11
.L9:
	ret
	.cfi_endproc
.LFE5280:
	.size	add_SSE, .-add_SSE
	.globl	functions
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"add (plain C)"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"add_AVX (vectorized, 256-bit registers)"
	.align 8
.LC2:
	.string	"add_SSE (vectorized, 128-bit registers)"
	.section	.data.rel.local,"aw"
	.align 32
	.type	functions, @object
	.size	functions, 64
functions:
	.quad	add
	.quad	.LC0
	.quad	add_AVX
	.quad	.LC1
	.quad	add_SSE
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
