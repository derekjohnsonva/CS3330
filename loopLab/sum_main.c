#include "sum.h"
#include "timing.h"
#include <stdio.h>
#include <stdlib.h>

#define MAX_SIZE (1024 * 1024)

static unsigned short A[MAX_SIZE];

void all_for_function(const char *name, function_type func) {
    short reference = sum_C(1024, A);
    short actual = func(1024, A);
    if (reference != actual) {
        printf("%s: incorrect answer\n", name);
    }
    printf("%-10s Cycles/Element for %s\n", "Size", name);
    for (int i = 16; i <= MAX_SIZE; i *= 2) {
        short reference = sum_C(i, A);
        short actual = func(i, A);
        if (reference != actual) {
            printf("%10d -- INCORRECT ANSWER --\n", i);
            continue;
        }
        cycles_type t = measure_function(i, (generic_function_type) func, A, NULL);
        printf("%-10d %7.2f\n", i, (double) t / (double) i);
    }
    printf("\n");
}

int main(void) {
    srand(42);
    for (int i = 0; i < MAX_SIZE; ++i) {
        A[i] = rand() % 10000;
    }
    for (int i = 0; functions[i].name != NULL; ++i) {
        all_for_function(functions[i].name, functions[i].f);
    }
}
