# This Makefile requires GNU make

CC = gcc
CFLAGS = -g -O2 -std=c99 -mavx2 -Wall -Werror
ASFLAGS = -g

ASSEMBLY_O_FILES = $(patsubst %.s,%.o,$(wildcard sum_*.s))

DIST_FILES = \
    sum.h sum_benchmarks.c sum_main.c timing.c timing.h Makefile \
    sum_simple.s \
    sum_clang6_O.s \
    sum_gcc7_O3.s

all: sum sum_benchmarks.s

sum_benchmarks.s: sum_benchmarks.c
	$(CC) $(CFLAGS) -g0 -S -o $@ $^

sum: timing.o sum_main.o sum_benchmarks.o $(ASSEMBLY_O_FILES)
	$(CC) $(CFLAGS) -o $@ $^

looplab-submit.tar:
	rm -f looplab-submit.tar
	tar cvf looplab-submit.tar *.s *.c *.txt

clean:
	rm -f *.o sum_benchmarks.s

.PHONY: clean looplab-submit.tar

# make targets for internal use only
looplab.tar: $(DIST_FILES)
	rm -f looplab.tar
	tar cvf looplab.tar $(DIST_FILES)

sum_solution: timing.o sum_main.o sum_benchmarks_solution.o $(ASSEMBLY_O_FILES)
	$(CC) $(CFLAGS) -o $@ $^
