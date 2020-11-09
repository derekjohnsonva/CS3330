#include "timing.h"

#include <stdlib.h>
#include <string.h>

/* Timing code follows */

#define K 10 /* need top-K runs to be within a small range to terminate, unless other limit is reached
                then the median run is reported. */
#define MAX_RUNS 200 /* maximum number of runs before giving up */
#define MIN_TEST_CYCLES (50L * 1000L * 1000L) /* minimum number of cycles before giving up */
        /* tolerance of top K runs, e.g. 1005, 1000 means .5% */
#define TOLERANCE_NUMERATOR 1005 
#define TOLERANCE_DENOMINATOR 1000

/*
 * See https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/ia-32-ia-64-benchmark-code-execution-paper.pdf
 */

static cycles_type
measure_once(unsigned long size, void *a, void *b, generic_function_type f) {
    uint32_t start_cycles_high, start_cycles_low;
    uint32_t end_cycles_high, end_cycles_low;
    __asm__ volatile(
        "cpuid\n\t"
        "rdtsc\n\t"
        :
        "=d" (start_cycles_high), "=a" (start_cycles_low)
        :: "%rbx", "%rcx"
    );
    f(size, a, b);
    __asm__ volatile(
        "rdtscp\n\t"
        "mov %%edx, %0\n\t"
        "mov %%eax, %1\n\t"
        "cpuid\n\t"
        :
        "=r" (end_cycles_high), "=r" (end_cycles_low)
        :: "%rax", "%rbx", "%rcx", "%rdx"
    );
    uint64_t start_cycles = ((uint64_t) start_cycles_high) << 32 | start_cycles_low;
    uint64_t end_cycles = ((uint64_t) end_cycles_high) << 32 | end_cycles_low;
    return end_cycles - start_cycles;
}

cycles_type
measure_function(long size, generic_function_type f, void *a, void *b) {
    const uint64_t huge_measure = UINT64_MAX / (TOLERANCE_DENOMINATOR * TOLERANCE_NUMERATOR);
    uint64_t measures[K];
    for (int i = 0; i < K; ++i) {
        measures[i] = huge_measure;
    }
    int num_runs = 0;
    uint64_t total_cycles = 0;
    while (measures[K - 1] >= huge_measure || measures[0] * TOLERANCE_NUMERATOR / TOLERANCE_DENOMINATOR < measures[K - 1]) {
        uint64_t cur_measure = measure_once(size, a, b, f);
        total_cycles += cur_measure;
        int insertion_point = K;
        for (int i = 0; i < K; ++i) {
            if (cur_measure < measures[i]) {
                insertion_point = i;
                break;
            }
        }
        if (insertion_point < K) {
            memmove(&measures[insertion_point + 1], &measures[insertion_point],
                    (K - insertion_point - 1) * sizeof(*measures));
            measures[insertion_point] = cur_measure;
        }
#ifdef DEBUG
        printf("DEBUG: %d: measurements after inserting at %d\n", num_runs, insertion_point);
        printf("DEBUG: %d: %7.4g // %7.4g\n",
            num_runs,
            (double) measures[K - 1] * TOLERANCE_NUMERATOR / TOLERANCE_DENOMINATOR,
            (double) measures[0]);
        for (int i = 0; i < K; ++i) {
            printf("DEBUG: measures[%d] = %7.4g\n", i, (double) measures[i]);
        }
#endif
        if (num_runs++ > MAX_RUNS && total_cycles > MIN_TEST_CYCLES) {
            break;
        }
    }
    return measures[K/2 - 1];
}
