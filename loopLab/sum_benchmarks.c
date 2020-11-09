#include <stdlib.h>
#include <immintrin.h>  // for future use of SSE

#include "sum.h"
/* sum.h defines function_type. */

/* reference implementation in C */
unsigned short sum_C(long size, unsigned short * a) {
    unsigned short sum = 0;
    for (int i = 0; i < size; ++i) {
        sum += a[i];
    }
    return sum;
}
unsigned short sum_multiple_accum_C(long size, unsigned short * a) {
    unsigned short sum1 = 0;
    unsigned short sum2 = 0;
    for (int i = 0; i < size; i += 2) {
        sum1 += a[i];
	sum2 += a[i+1];
    }
    return sum1 + sum2;
}


/* implementations in assembly */
extern unsigned short sum_clang6_O(long, unsigned short *);
extern unsigned short sum_gcc7_O3(long, unsigned short *);
extern unsigned short sum_simple(long, unsigned short *);
extern unsigned short sum_unrolled2(long, unsigned short *);
extern unsigned short sum_unrolled4(long, unsigned short *);
extern unsigned short sum_multiple_accum(long, unsigned short *);


// ADD PROTOTYPES HERE

/* This is the list of functions to test */
function_info functions[] = {
    /* compiled versions from various compilers, each in their own .s file: */ 
    {sum_clang6_O, "sum_clang6_O: simple C compiled with clang 6 -O -mavx2"},
    {sum_gcc7_O3, "sum_gcc7_O3: simple C compiled with GCC7 -O3 -mavx2"}, 

    /* source code for this version is above */
    {sum_C, "sum_C: simple C compiled on this machine with settings in Makefile"},

    /* source code for this version is in sum_simple.s */
    {sum_simple, "sum_simple: simple ASM implementation"},

    // ADD ENTRIES HERE!
    /* source code for this version is in sum_unrolled2.s */
    {sum_unrolled2, "sum_unrolled2: unrolled implementation"},   
    {sum_unrolled4, "sum_unrolled4: unrolled implementation"},   
    {sum_multiple_accum, "sum_multiple_accum: unrolled implementation"},   
    {sum_multiple_accum_C, "sum_multiple_accum_C: simple C compiled on this machine with settings in Makefile"},


    {NULL, NULL},
};
