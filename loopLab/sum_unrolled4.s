// This is assembly is roughly equivalent to the following C code:
// unsigned short sum_C(long size, unsigned short * a) {
//    unsigned short sum = 0;
//    for (int i = 0; i < size; ++i) {
//        sum += a[i];
//    }
//    return sum;
//}

// This implementation follows the Linux x86-64 calling convention:
//    %rdi contains the size
//    %rsi contains the pointer a
// and
//    %ax needs to contain the result when the function returns
// in addition, this code uses
//    %rcx to store i

// the '.global' directive indicates to the assembler to make this symbol 
// available to other files.
.global sum_unrolled4
sum_unrolled4:
    // set sum (%ax) to 0
    xor %eax, %eax
    // return immediately; special case if size (%rdi) == 0
    test %rdi, %rdi
    je .L_done
    // store i = 0 in rcx
    movq $0, %rcx
// labels starting with '.L' are local to this file
.L_loop:
    // sum (%ax) += a[i]
    addw (%rsi,%rcx,2), %ax
    // sum (%ax) += a[i+1]
    addw 2(%rsi,%rcx,2), %ax
    // sum (%ax) += a[i+2]
    addw 4(%rsi,%rcx,2), %ax
    // sum (%ax) += a[i+3]
    addw 6(%rsi,%rcx,2), %ax

    // i += 4
    addq $4, %rcx
    // i < end?
    cmpq %rdi, %rcx
    jl .L_loop
.L_done:
    retq
