#include "min.h"
#include "timing.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define MAX_SIZE (1024 * 1024)

static short A[MAX_SIZE];
static short A_copy[MAX_SIZE];

void all_for_function(const char *name, function_type func) {
    int found_incorrect = 0;
    short reference = min_C(1024, A);
    short actual = func(1024, A);
    printf("%-10s Cycles/Element for %s\n", "Size", name);
    if (reference != actual) {
        printf("%s: INCORRECT ANSWER (with size 1024)\n", name);
        found_incorrect = 1;
    }
    /* also test that supplied code works when min is in a different position in the array passed */
    for (int i = 0; i < 32; ++i) {
        memcpy(A_copy, A, 1024 * sizeof(short));
        A_copy[i] = actual - 1;
        short new_reference = min_C(1024, A_copy);
        short new_actual = func(1024, A_copy);
        if (new_reference != new_actual) {
            printf("%s: INCORRECT ANSWER (with size 1024 and min at offset %d)\n", name, i);
            found_incorrect = 1;
        }
    }
    for (int i = 16; i <= MAX_SIZE; i *= 2) {
        short reference = min_C(i, A);
        short actual = func(i, A);
        if (reference != actual) {
            printf("%-10d -- INCORRECT ANSWER --\n", i);
            found_incorrect = 1;
            continue;
        }
        cycles_type t = measure_function(i, (generic_function_type) func, A, NULL);
        printf("%-10d %7.2f\n", i, (double) t / (double) i);
    }
    if (found_incorrect) {
        printf("*** at least one INCORRECT ANSWER for %s ***\n", name);
    }
    printf("\n");
}

int main(void) {
    srand(42);
    int real_min = (rand() % 5000);
    for (int i = 0; i < MAX_SIZE; ++i) {
        A[i] = rand() % 10000 + real_min;
    }
    for (int i = 0; functions[i].name != NULL; ++i) {
        all_for_function(functions[i].name, functions[i].f);
    }
}
