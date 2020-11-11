CC = gcc

# These optimization options are chosen to deliberately prevent vectorization.
CFLAGS = -Werror -Wall -O2 -mavx2 -std=gnu99 -g -mtune=skylake -fno-strict-aliasing -fno-tree-vectorize
CFLAGS_GRADING = -Wall -O2 -mavx2 -std=gnu99 -g -mtune=skylake -fno-strict-aliasing -fno-tree-vectorize 
LIBS = -lm

OBJS = run.o timing.o smooth.o

all: benchmark test

$(OBJS): run.h defs.h timing.h

benchmark: $(OBJS) benchmark_main.o
	$(CC) $(CFLAGS) $^ $(LIBS) -o benchmark

test: run.o timing.o smooth.o test_main.o
	$(CC) $(CFLAGS) $^ $(LIBS) -o test

grader: run_grader.o timing_grader.o smooth_grader.o benchmark_main_grader.o
	$(CC) $(CFLAGS_GRADING) $^ $(LIBS) -o grader

%_grader.o: %.c
	$(CC) -DGRADER $(CFLAGS_GRADING) $^ -c -o $@

clean:
	rm -f *.o

archive:
	rm -f smooth.tar
	tar \
	    --xform=s,^,smooth/, \
	    --xform='s/smooth-empty\.c/smooth.c/' \
	    --show-transformed \
	    -cvf smooth.tar \
	    Makefile \
	    smooth-empty.c benchmark_main.c test_main.c \
	    run.c timing.c run.h defs.h timing.h

.PHONY: clean archive
