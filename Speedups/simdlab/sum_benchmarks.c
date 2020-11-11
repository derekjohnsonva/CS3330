#include <stdlib.h>

#include <immintrin.h>

#include "sum.h"
/* reference implementation in C */
unsigned short sum_C(long size, unsigned short * a) {
    unsigned short sum = 0;
    for (int i = 0; i < size; ++i) {
        sum += a[i];
    }
    return sum;
}

unsigned short sum_with_sixteen_accumulators(long size, unsigned short *a) {
    unsigned short partial_sum0 = 0, partial_sum1 = 0, partial_sum2 = 0, partial_sum3 = 0,
                   partial_sum4 = 0, partial_sum5 = 0, partial_sum6 = 0, partial_sum7 = 0,
                   partial_sum8 = 0, partial_sum9 = 0, partial_sum10= 0, partial_sum11= 0,
                   partial_sum12= 0, partial_sum13= 0, partial_sum14= 0, partial_sum15= 0;
    for (int i = 0; i < size; i += 16) {
        partial_sum0 = partial_sum0 + a[i+0];
        partial_sum1 = partial_sum1 + a[i+1];
        partial_sum2 = partial_sum2 + a[i+2];
        partial_sum3 = partial_sum3 + a[i+3];
        partial_sum4 = partial_sum4 + a[i+4];
        partial_sum5 = partial_sum5 + a[i+5];
        partial_sum6 = partial_sum6 + a[i+6];
        partial_sum7 = partial_sum7 + a[i+7];
        partial_sum8 = partial_sum8 + a[i+8];
        partial_sum9 = partial_sum9 + a[i+9];
        partial_sum10 = partial_sum10 + a[i+10];
        partial_sum11 = partial_sum11 + a[i+11];
        partial_sum12 = partial_sum12 + a[i+12];
        partial_sum13 = partial_sum13 + a[i+13];
        partial_sum14 = partial_sum14 + a[i+14];
        partial_sum15 = partial_sum15 + a[i+15];
    }
    return partial_sum0 + partial_sum1 + partial_sum2 + partial_sum3 +
           partial_sum4 + partial_sum5 + partial_sum6 + partial_sum7 +
           partial_sum8 + partial_sum9 + partial_sum10+ partial_sum11+
           partial_sum12+ partial_sum13+ partial_sum14+ partial_sum15;
}

unsigned short sum_AVX(long size, unsigned short *a) {
    __m256i partial_sums = _mm256_setzero_si256();
    for (int i = 0; i < size; i += 16) {
        __m256i a_part = _mm256_loadu_si256((__m256i*) &a[i]);
        partial_sums = _mm256_add_epi16(partial_sums, a_part);
    }

    unsigned short extracted_partial_sums[16];
    _mm256_storeu_si256((__m256i*) &extracted_partial_sums, partial_sums); 
    int output = 0;
    for(int i = 0; i <16; i++){
        output += extracted_partial_sums[i];
    }
    return output;

}

unsigned short sum_with_eight_accumulators(long size, unsigned short *a) {
    unsigned short partial_sum0 = 0, partial_sum1 = 0, partial_sum2 = 0, partial_sum3 = 0,
                   partial_sum4 = 0, partial_sum5 = 0, partial_sum6 = 0, partial_sum7 = 0;
    for (int i = 0; i < size; i += 8) {
        partial_sum0 = partial_sum0 + a[i+0];
        partial_sum1 = partial_sum1 + a[i+1];
        partial_sum2 = partial_sum2 + a[i+2];
        partial_sum3 = partial_sum3 + a[i+3];
        partial_sum4 = partial_sum4 + a[i+4];
        partial_sum5 = partial_sum5 + a[i+5];
        partial_sum6 = partial_sum6 + a[i+6];
        partial_sum7 = partial_sum7 + a[i+7];
    }
    return partial_sum0 + partial_sum1 + partial_sum2 + partial_sum3 +
           partial_sum4 + partial_sum5 + partial_sum6 + partial_sum7;
}

/* implementations in assembly */
extern unsigned short sum_clang6_O(long, unsigned short *);
// add prototypes here!

/* This is the list of functions to test */
function_info functions[] = {
    {sum_C, "C (local)"},
    {sum_clang6_O, "C (clang6 -O)"},
    {sum_with_sixteen_accumulators, "sixteen accumulators (C)"},
    {sum_with_eight_accumulators, "eight accumulators (C)"},
    {sum_AVX, "using AVX commands (C)"},
    {NULL, NULL},
};
