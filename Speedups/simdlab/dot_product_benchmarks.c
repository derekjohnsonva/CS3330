#include <stdlib.h>

#include <immintrin.h>

#include "dot_product.h"
/* reference implementation in C */
unsigned int dot_product_C(long size, unsigned short * a, unsigned short *b) {
    unsigned int sum = 0;
    for (int i = 0; i < size; ++i) {
        sum += a[i] * b[i];
    }
    return sum;
}

unsigned int dot_product_AVX(long size, unsigned short * a, unsigned short *b) {
    __m256i partial_product = _mm256_setzero_si256();
    for(int i = 0; i<size; i+=8){
        __m128i inter_vector_a = _mm_loadu_si128((__m128i*) &a[i]);
        __m256i a_part = _mm256_cvtepu16_epi32(inter_vector_a);

        __m128i inter_vector_b = _mm_loadu_si128((__m128i*) &b[i]);
        __m256i b_part = _mm256_cvtepu16_epi32(inter_vector_b);

        __m256i product = _mm256_mullo_epi32(a_part, b_part);
        partial_product = _mm256_add_epi32(partial_product, product);
    }

    unsigned int extracted_partial_product[8];
    _mm256_storeu_si256((__m256i*) &extracted_partial_product, partial_product); 
    unsigned int output = 0;
    for(int i = 0; i <8; i++){
        output += extracted_partial_product[i];
    }
    return output;
}
extern unsigned int dot_product_gcc7_O3(long size, unsigned short * a, unsigned short *b);

/* This is the list of functions to test */
function_info functions[] = {
    {dot_product_C, "C (local)"},
    {dot_product_gcc7_O3, "C (compiled with GCC7.2 -O3 -mavx2)"},
    {dot_product_AVX, "Using AVX commands"},
    {NULL, NULL},
};
