#include "timing.h"
#include "add.h"
#include <stdlib.h>
#include <stdio.h>

#define MAX_SIZE (1024 * 1024)

static unsigned short A[MAX_SIZE];
static unsigned short B[MAX_SIZE];

void all_for_function(const char *name, function_type func) {
    // NB: There is no code to verify functions are correct here.
    printf("%-10s Cycles/Element for %s\n", "Size", name);
    for (int i = 16; i <= MAX_SIZE; i *= 2) {
        cycles_type t = measure_function(i, (generic_function_type) func, A, B);
        printf("%-10d %7.2f\n", i, (double) t / (double) i);
    }
    printf("\n");
}

int main(void) {
    srand(42);
    for (int i = 0; i < MAX_SIZE; ++i) {
        A[i] = rand() % 10000;
        B[i] = rand() % 10000;
    }
    for (int i = 0; functions[i].name != NULL; ++i) {
        all_for_function(functions[i].name, functions[i].f);
    }
}

