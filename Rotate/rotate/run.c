#define _XOPEN_SOURCE 500

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "run.h"
#include "timing.h"
#include "defs.h"

static int extra_test_dimensions[] = {96, 192};
static int dimensions[] = {32, 672, 2048, 2528, 3104, 3136};

#define ALIGNED __attribute__((aligned(4096)))
#define NOINLINE __attribute__((noinline))

benchmark_t all_benchmarks[MAX_BENCHMARKS];
static int num_benchmarks = 0;

ALIGNED static pixel input[MAX_DIM * MAX_DIM];
ALIGNED static pixel input_copy[MAX_DIM * MAX_DIM];
ALIGNED static pixel output[MAX_DIM * MAX_DIM];

benchmark_t *best_benchmark = NULL;
double best_ratio = 0;

#ifdef GRADER
FILE *grader_out;
#endif

// ROTATE specific part

#ifdef GRADER
static const char *benchmark_name = "rotate";
static double low_threshold = 1.6;
static double high_threshold = 2.7;
#endif

static pixel get_expected_output(int i, int j, int dimension) {
    return input_copy[j * dimension + (dimension - i - 1)];
}

#ifndef GRADER
static void explain_mismatch(benchmark_t *b, int i, int j, int dimension) {
    fprintf(stderr, "ERROR: WRONG ANSWER FOR %s on dimension=%d\n", b->description, dimension);
    fprintf(stderr, "Disagreement at i=%d, j=%d\n", i, j);
    pixel actual = output[i * dimension + j];
    pixel expected = get_expected_output(i, j, dimension);
    fprintf(stderr, "Actual value: {red=%d,green=%d,blue=%d,alpha=%d}\n",
        actual.red, actual.green, actual.blue, actual.alpha);
    fprintf(stderr, "Expected value: {red=%d,green=%d,blue=%d,alpha=%d}\n",
        expected.red, expected.green, expected.blue, expected.alpha);
}
#endif

NOINLINE
static void baseline_function(int dim, pixel *src, pixel *dst) {
    __asm__("");
    int i, j;

    for (i = 0; i < dim; i++)
        for (j = 0; j < dim; j++)
            dst[RIDX(dim-1-j, i, dim)] = src[RIDX(i, j, dim)];
}

// END ROTATE specific part

static benchmark_t baseline = {
    baseline_function,
    {0},
    "baseline",
    1
};

static int have_baseline = 0;

static pixel random_pixel() {
    pixel p;
    p.red = rand() % 256;
    p.green = rand() % 256;
    p.blue = rand() % 256;
    p.alpha = rand() % 256;
    return p;
}

static void create_inputs(int dimension) {
    srand(42);
    for (int i = 0; i < dimension * dimension; ++i) {
        input[i] = random_pixel();
    }
    memset(output, 0, dimension * dimension * sizeof(pixel));
    memcpy(input_copy, input, dimension * dimension * sizeof(pixel));
}

static void create_inputs_nonrandom(int dimension) {
    for (int i = 0; i < dimension * dimension; ++i) {
        input[i].red = i % 200 + 1;
        input[i].green = i % 200 + 2;
        input[i].blue = (i / dimension) % 200 + 1;
        input[i].alpha = (i / dimension) % 200 + 2;
    }
    memset(output, 0, dimension * dimension * sizeof(pixel));
    memcpy(input_copy, input, dimension * dimension * sizeof(pixel));
}

static int pixels_equal(pixel a, pixel b) {
    return a.red == b.red && a.green == b.green && a.blue == b.blue && a.alpha == b.alpha;
}


static int check_result(benchmark_t *b, int dimension) {
    for (int i = 0; i < dimension; ++i) {
        for (int j = 0; j < dimension; ++j) {
            pixel original = input[i * dimension + j];
            pixel original_copy = input_copy[i * dimension + j];
            if (!pixels_equal(original, original_copy)) {
#ifndef GRADER
                fprintf(stderr, "INPUT CHANGED for dimension=%d for %s\n", dimension, b->description);
                fprintf(stderr, "First change at i=%d, j=%d\n", i, j);
#else
                fprintf(grader_out, "%s_error:%s,%d\n", benchmark_name, b->description, dimension);
#endif
                return 0;
            }
        }
    }
    for (int i = 0; i < dimension; ++i) {
        for (int j = 0; j < dimension; ++j) {
            pixel actual = output[i * dimension + j];
            pixel expected = get_expected_output(i, j, dimension);
            if (!pixels_equal(actual, expected)) {
#ifndef GRADER
                explain_mismatch(b, i, j, dimension);
#else
                fprintf(grader_out, "%s_error:%s,%d\n", benchmark_name, b->description, dimension);
#endif
                return 0;
            }
        }
    }
    return 1;
}

static void test_benchmark_on_dimension(benchmark_t *b, int dim_index, int skip_valid) {
    int dimension = dimensions[dim_index];
    create_inputs(dimension);
    b->test_function(dimension, input, output);
    if (!skip_valid) {
        if (!check_result(b, dimension)) {
            b->valid = 0;
            return;
        }
    }
    uint64_t cycles = measure_function(dimension, (generic_function_type) b->test_function, input, output);
    b->cpes[dim_index] = (double) cycles / ((double) dimension * dimension);
}

static int min(int x, int y) {
    return x < y ? x : y;
}

static void show_matrix(const char *name, pixel *array, int dimension) {
    printf("%s values: (red/green/blue/alpha), in hexadecimal\n", name);
    const int per_row = 16;
    for (int jj = 0; jj < dimension; jj += per_row) {
        for (int i = 0; i < dimension; ++i) {
            printf("row i=%d,col j=%d to %d:",
                    i, jj, min(jj + per_row - 1, dimension - 1));
            for (int j = jj; j < dimension && j < jj + per_row; ++j) {
                pixel p = array[i * dimension + j];
                printf(" %02x/%02x/%02x/%02x",
                        p.red, p.green, p.blue, p.alpha);
            }
            printf("\n");
        }
    }
}

void test_correctness(benchmark_t *b, int dimension, int verbose, int non_random) {
    if (non_random)
        create_inputs_nonrandom(dimension);
    else
        create_inputs(dimension);
    b->test_function(dimension, input, output);
    if (verbose) {
        show_matrix("input", input, dimension);
        show_matrix("output", output, dimension);
    }
    if (!check_result(b, dimension)) {
        b->valid = 0;
    }
}

static void test_benchmark_no_output(benchmark_t *b) {
    b->valid = 1;
    for (int i = 0; b->valid && i < sizeof(extra_test_dimensions) / sizeof(extra_test_dimensions[0]); ++i) {
        test_correctness(b, extra_test_dimensions[i], 0, 0);
    }
    for (int i = 0; b->valid && i < DIMENSION_COUNT; ++i) {
        test_benchmark_on_dimension(b, i, 0);
    }
}

void test_benchmark(benchmark_t* b) {
    if (!have_baseline)
        create_baseline();
    test_benchmark_no_output(b);
    if (!b->valid) {
        return;
    }
    double geo_mean = 1.0;
    for (int i = 0; i < DIMENSION_COUNT; ++i) {
        geo_mean *= baseline.cpes[i] / b->cpes[i];
    }
    geo_mean = pow(geo_mean, 1.0 / DIMENSION_COUNT);
#ifndef GRADER
    printf("Rotate: Version = %s:\n", b->description);
    printf("Dim\t");
    for (int i = 0; i < DIMENSION_COUNT; ++i) {
        printf("\t%d", dimensions[i]);
    }
    printf("\nYour CPEs");
    for (int i = 0; i < DIMENSION_COUNT; ++i) {
        printf("\t%.2f", b->cpes[i]);
    }
    printf("\nBaseline CPEs");
    for (int i = 0; i < DIMENSION_COUNT; ++i) {
        printf("\t%.2f", baseline.cpes[i]);
    }
    printf("\n");
    printf("Speedup\t");
    for (int i = 0; i < DIMENSION_COUNT; ++i) {
        printf("\t%.2f", baseline.cpes[i] / b->cpes[i]);
    }
    printf("\t%.2f\n\n", geo_mean);
#else
    fprintf(grader_out, "%s_result:%s,", benchmark_name, b->description);
    for (int i = 0; i < DIMENSION_COUNT; ++i) {
        fprintf(grader_out, "%d,%.2f,%.2f,", dimensions[i], b->cpes[i], baseline.cpes[i] / b->cpes[i]);
    }
    fprintf(grader_out, "%.2f\n", geo_mean);
#endif
    if (geo_mean > best_ratio) {
        best_benchmark = b;
        best_ratio = geo_mean;
    }
}

void create_baseline() {
    // repeat to avoid startup costs
#ifndef GRADER
    printf("Running baseline...");
    fflush(stdout);
#endif
    test_benchmark_no_output(&baseline);
#ifndef GRADER
    printf("...");
    fflush(stdout);
#endif
    test_benchmark_no_output(&baseline);
#ifndef GRADER
    printf("done\n");
    fflush(stdout);
#endif
    have_baseline = 1;
}

#ifdef GRADER
char *dup_and_cleanup_name(const char *original_name) {
    char *name = strdup(original_name ? original_name : "");
    for (int i = 0; name[i]; ++i) {
        if (i > 64) {
            name[i] = '\0';
            continue;
        }
        if (name[i] == ' ' || name[i] == '-' ||
            name[i] == '.' || name[i] == '@' ||
            name[i] == ':' || name[i] == '[' ||
            name[i] == ']' || name[i] == '_') continue;
        if (name[i] == '(' || name[i] == ')') continue;
        if (name[i] >= '0' && name[i] <= '9') continue;
        if (name[i] >= 'a' && name[i] <= 'z') continue;
        if (name[i] >= 'A' && name[i] <= 'Z') continue;
        name[i] = ' ';
    }
    return name;
}
#endif

#ifdef GRADER
static void output_team_info() {
    who_t clean_who;
    clean_who.scoreboard_name = dup_and_cleanup_name(who.scoreboard_name);
    clean_who.name1 = dup_and_cleanup_name(who.name1);
    clean_who.email1 = dup_and_cleanup_name(who.email1);
    fprintf(grader_out, "names:%s,%s,%s,%s,%s\n",
            clean_who.scoreboard_name,
            clean_who.name1, clean_who.email1,
            "", "");
    free(clean_who.scoreboard_name);
    free(clean_who.name1);
    free(clean_who.email1);
}
#endif

void test_benchmarks_containing(const char *substring) {
#ifdef GRADER
    output_team_info();
#endif
    if (!have_baseline)
        create_baseline();
    benchmark_t *b = all_benchmarks;
    while (b->description) {
        if (!substring || strstr(b->description, substring)) {
            test_benchmark(b);
        }
        ++b;
    }
#ifdef GRADER
    double score = 0.0;
    if (best_ratio < 1.0) {
        score = 0.0;
    } else if (best_ratio < low_threshold) {
        score = 0.75 * (best_ratio - 1.0) / (low_threshold - 1.0);
    } else if (best_ratio < high_threshold) {
        score = 0.75 + 0.25 * (best_ratio - low_threshold) / (high_threshold - low_threshold);
    } else {
        score = 1.0;
    }
    fprintf(grader_out, "overall_result:%3.2f,%.2f\n", best_ratio, score);
#else
    if (best_benchmark) {
        printf("\n\nBest speedup: %.2f from %s\n", best_ratio, best_benchmark->description);
        printf("\nNOTE: You may have different performance on our reference machine,\n"
                "which we will use to determine your grade.\n\n");
    }
#endif
}

void test_all_benchmarks() {
    test_benchmarks_containing(0);
}

void add_rotate_function(test_func f, const char *description) {
    benchmark_t *b = &all_benchmarks[num_benchmarks++];
#ifdef GRADER
    b->description = dup_and_cleanup_name(description);
#else
    b->description = description;
#endif
    b->test_function = f;
    b->valid = 0;
    memset(b->cpes, 0, sizeof(b->cpes));
}

#ifdef GRADER
void setup_grader_output() {
   int new_stdout = dup(1);
   grader_out = fdopen(new_stdout, "w");
   setvbuf(grader_out, NULL, _IOLBF, 0);
   fflush(stdout);
   dup2(2, 1);
}
#endif
