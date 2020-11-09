	.text
	.file	"sum.c"
	.globl	sum_clang6_O            # -- Begin function sum_clang6_O
	.p2align	4, 0x90
	.type	sum_clang6_O,@function
sum_clang6_O:                           # @sum_clang6_O
	.cfi_startproc
# %bb.0:
	testq	%rdi, %rdi
	jle	.LBB0_1
# %bb.2:
	cmpq	$63, %rdi
	ja	.LBB0_6
# %bb.3:
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB0_4
.LBB0_1:
	xorl	%eax, %eax
                                        # kill: def %ax killed %ax killed %eax
	retq
.LBB0_6:
	movq	%rdi, %rcx
	andq	$-64, %rcx
	leaq	-64(%rcx), %rax
	movq	%rax, %rdx
	shrq	$6, %rdx
	leal	1(%rdx), %r8d
	andl	$1, %r8d
	testq	%rax, %rax
	je	.LBB0_7
# %bb.8:
	leaq	-1(%r8), %rax
	subq	%rdx, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edx, %edx
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB0_9:                                # =>This Inner Loop Header: Depth=1
	vpaddw	(%rsi,%rdx,2), %ymm0, %ymm0
	vpaddw	32(%rsi,%rdx,2), %ymm1, %ymm1
	vpaddw	64(%rsi,%rdx,2), %ymm2, %ymm2
	vpaddw	96(%rsi,%rdx,2), %ymm3, %ymm3
	vpaddw	128(%rsi,%rdx,2), %ymm0, %ymm0
	vpaddw	160(%rsi,%rdx,2), %ymm1, %ymm1
	vpaddw	192(%rsi,%rdx,2), %ymm2, %ymm2
	vpaddw	224(%rsi,%rdx,2), %ymm3, %ymm3
	subq	$-128, %rdx
	addq	$2, %rax
	jne	.LBB0_9
# %bb.10:
	testq	%r8, %r8
	je	.LBB0_12
.LBB0_11:
	vpaddw	96(%rsi,%rdx,2), %ymm3, %ymm3
	vpaddw	64(%rsi,%rdx,2), %ymm2, %ymm2
	vpaddw	32(%rsi,%rdx,2), %ymm1, %ymm1
	vpaddw	(%rsi,%rdx,2), %ymm0, %ymm0
.LBB0_12:
	vpaddw	%ymm3, %ymm1, %ymm1
	vpaddw	%ymm2, %ymm0, %ymm0
	vpaddw	%ymm1, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpaddw	%ymm1, %ymm0, %ymm0
	vpshufd	$78, %xmm0, %xmm1       # xmm1 = xmm0[2,3,0,1]
	vpaddw	%ymm1, %ymm0, %ymm0
	vpshufd	$229, %xmm0, %xmm1      # xmm1 = xmm0[1,1,2,3]
	vpaddw	%ymm1, %ymm0, %ymm0
	vphaddw	%ymm0, %ymm0, %ymm0
	vmovd	%xmm0, %eax
	cmpq	%rdi, %rcx
	je	.LBB0_13
.LBB0_4:
	leaq	(%rsi,%rcx,2), %rdx
	subq	%rcx, %rdi
	.p2align	4, 0x90
.LBB0_5:                                # =>This Inner Loop Header: Depth=1
	addw	(%rdx), %ax
	addq	$2, %rdx
	addq	$-1, %rdi
	jne	.LBB0_5
.LBB0_13:
                                        # kill: def %ax killed %ax killed %eax
	vzeroupper
	retq
.LBB0_7:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edx, %edx
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	testq	%r8, %r8
	jne	.LBB0_11
	jmp	.LBB0_12
.Lfunc_end0:
	.size	sum_clang6_O, .Lfunc_end0-sum_clang6_O
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 6.0.0 (tags/RELEASE_600/final)"
	.section	".note.GNU-stack","",@progbits
