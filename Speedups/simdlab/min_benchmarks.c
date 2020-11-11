#include <stdlib.h>
#include <limits.h>  /* for USHRT_MAX */

#include <immintrin.h>

#include "min.h"
/* reference implementation in C */
short min_C(long size, short * a) {
    short result = SHRT_MAX;
    for (int i = 0; i < size; ++i) {
        if (a[i] < result)
            result = a[i];
    }
    return result;
}

short min_AVX(long size, short * a) {
    __m256i partial_mins = _mm256_loadu_si256((__m256i*) &a[0]);
    for (int i = 16; i < size; i+=16){
        __m256i a_part = _mm256_loadu_si256((__m256i*) &a[i]);
        partial_mins = _mm256_min_epi16(partial_mins, a_part);
    }
    unsigned short extracted_partial_mins[16];
    _mm256_storeu_si256((__m256i*) &extracted_partial_mins, partial_mins); 
    int output = extracted_partial_mins[0];
    for(int i = 1; i <16; i++){
        unsigned short localMin = extracted_partial_mins[i];
        if(output > localMin) {
            output = localMin;
        }
    }
    return output;
}

/* This is the list of functions to test */
function_info functions[] = {
    {min_C, "C (local)"},
    {min_AVX, "min with AVX commands"},
    {NULL, NULL},
};
