# This Makefile requires GNU make

CC = gcc
# Add -mavx2 to enable AVX instrusctions up to AVX2 as well as all SSE instructions.
# We use optimization level 1 to avoid automatic vectorization with both GCC
# and Clang. GCC will do automatic vectorization only at
# optimization level 3. Clang apparently will do it at level 2 or 3.

# -mtune=skylake encourages GCC to generate 256-bit vector instructions rather
# than sequences of two 128-bit vector instructions (which may be faster on
# some older processors)
CFLAGS = -g -O1 -std=c99 -mavx2 -mtune=skylake -Wall -Werror -fwrapv -fno-strict-aliasing
ASFLAGS = -g

SUM_ASSEMBLY_O_FILES = sum_clang6_O.o

DIST_FILES =  \
    timing.h timing.c \
    sum_benchmarks.c sum.h sum_main.c \
    add_benchmarks.c add.h add_main.c \
    min_benchmarks.c min.h min_main.c \
    sum_clang6_O.s \
    dot_product_benchmarks.c dot_product.h dot_product_main.c \
    dot_product_gcc7_O3.s \
    Makefile

all: sum min add dot_product \
     sum_benchmarks.s add_benchmarks.s min_benchmarks.s dot_product_benchmarks.s

sum_benchmarks.s: sum_benchmarks.c
	$(CC) $(CFLAGS) -g0 -S -o $@ $^

add_benchmarks.s: add_benchmarks.c
	$(CC) $(CFLAGS) -g0 -S -o $@ $^

min_benchmarks.s: min_benchmarks.c
	$(CC) $(CFLAGS) -g0 -S -o $@ $^

dot_product_benchmarks.s: dot_product_benchmarks.c
	$(CC) $(CFLAGS) -g0 -S -o $@ $^

sum: timing.o sum_main.o sum_benchmarks.o $(SUM_ASSEMBLY_O_FILES)
	$(CC) $(CFLAGS) -o $@ $^

add: timing.o add_main.o add_benchmarks.o 
	$(CC) $(CFLAGS) -o $@ $^

min: timing.o min_main.o min_benchmarks.o 
	$(CC) $(CFLAGS) -o $@ $^

dot_product: timing.o dot_product_main.o dot_product_benchmarks.o dot_product_gcc7_O3.o
	$(CC) $(CFLAGS) -o $@ $^

simdlab-submit.tar:
	rm -f simdlab-submit.tar
	tar cvf simdlab-submit.tar *.s *.c

clean:
	rm -f *.o

.PHONY: clean simdlab-submit.tar

# make targets not for student use:
simdlab.tar: $(DIST_FILES)
	rm -f simdlab.tar
	tar --transform 's!^!simdlab/!' -cvf simdlab.tar $(DIST_FILES)

sum_solution: timing.o sum_main.o sum_benchmarks_solution.o $(SUM_ASSEMBLY_O_FILES)
	$(CC) $(CFLAGS) -o $@ $^

min_solution: timing.o min_main.o min_benchmarks_solution.o
	$(CC) $(CFLAGS) -o $@ $^

dot_product_solution: timing.o dot_product_main.o dot_product_benchmarks_solution.o dot_product_gcc7_O3.o
	$(CC) $(CFLAGS) -o $@ $^
