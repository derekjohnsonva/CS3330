#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "timing.h"
#include "defs.h"
#include "run.h"

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s 'benchmark_name' dimension\n"
                "    Example: %s rotate_foo: 8\n"
                "  benchmark_name can be all or part of a benchmark description\n"
                "  every registered rotate function whose name containing the string\n"
                "  will be run\n"
                "  \n"
                "  dimension is the width and height of image to use\n",
                argv[0], argv[0]);
        return 1;
    }
    const char *target_benchmark_name = argv[1];
    int dimension = atoi(argv[2]);
    if (dimension == 0) {
        fprintf(stderr, "Invalid dimension %s\n", argv[2]);
        return 1;
    }
    register_rotate_functions();
    benchmark_t *b = &all_benchmarks[0];
    while (b->description) {
        if (strstr(b->description, target_benchmark_name)) {
            printf("Running %s at dimension %d:\n", b->description, dimension);
            test_correctness(b, dimension, 1, 1);
        }
        ++b;
    }
}
