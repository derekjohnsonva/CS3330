#include "add.h"

/* header file for Intel intrinsics */
#include <immintrin.h>
#include <smmintrin.h>

/* reference implementation in C */
void add(long size, unsigned short * a, const unsigned short *b) {
    for (int i = 0; i < size; ++i) {
        a[i] += b[i];
    }
}

/* vectorized version */
void add_AVX(long size, unsigned short * a, const unsigned short *b) {
    for (int i = 0; i < size; i += 16) {
        /* load 128 bits from a */
        /* a_part = {a[i], a[i+1], a[i+2], ..., a[i+15]} */
        __m256i a_part = _mm256_loadu_si256((__m256i*) &a[i]);
        /* load 128 bits from b */
        /* b_part = {b[i], b[i+1], b[i+2], ..., b[i+15]} */
        __m256i b_part = _mm256_loadu_si256((__m256i*) &b[i]);
        /* a_part = {a[i] + b[i], a[i+1] + b[i+1], ...,
                     a[i+15] + b[i+15]}
         */
        a_part = _mm256_add_epi16(a_part, b_part);
        _mm256_storeu_si256((__m256i*) &a[i], a_part);
    }
}

/* vectorized version --- 128-bit regiters */
void add_SSE(long size, unsigned short * a, const unsigned short *b) {
    for (int i = 0; i < size; i += 8) {
        /* load 128 bits from a */
        /* a_part = {a[i], a[i+1], a[i+2], ..., a[i+7]} */
        __m128i a_part = _mm_loadu_si128((__m128i*) &a[i]);
        /* load 128 bits from b */
        /* b_part = {b[i], b[i+1], b[i+2], ..., b[i+7]} */
        __m128i b_part = _mm_loadu_si128((__m128i*) &b[i]);
        /* a_part = {a[i] + b[i], a[i+1] + b[i+1], ...,
                     a[i+7] + b[i+7]}
         */
        a_part = _mm_add_epi16(a_part, b_part);
        _mm_storeu_si128((__m128i*) &a[i], a_part);
    }
}

function_info functions[] = {
    {add, "add (plain C)"},
    {add_AVX, "add_AVX (vectorized, 256-bit registers)"},
    {add_SSE, "add_SSE (vectorized, 128-bit registers)"},
    // add entries here!
    {NULL, NULL},
};
