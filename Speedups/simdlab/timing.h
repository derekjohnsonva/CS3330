#include <stdint.h>

typedef uint64_t cycles_type;
typedef void (*generic_function_type)(long, void *, void *);

extern cycles_type measure_function(long size, generic_function_type f, void *a, void *b);

