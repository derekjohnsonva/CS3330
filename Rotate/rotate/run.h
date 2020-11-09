/* run.h --- based on CS:APP performance lab by Bryant and O'Hallaron */ 

#ifndef RUN_H_
#define RUN_H_
#include "defs.h"

#define MAX_DIM (3200)
#define DIMENSION_COUNT (6)
#define MAX_BENCHMARKS (300)

/* This struct characterizes the results for one benchmark test */
typedef struct {
	test_func test_function; 
	double cpes[DIMENSION_COUNT];  // cycles per element
	const char *description;    
        int valid;
} benchmark_t;

void create_baseline();
void test_all_benchmarks();
void test_benchmarks_containing(const char *substring);
void test_benchmark(benchmark_t *b);
void test_correctness(benchmark_t *b, int dimension, int verbose, int fixed_pattern);

extern benchmark_t all_benchmarks[MAX_BENCHMARKS];

#ifdef GRADER
void setup_grader_output();
#endif

#endif
