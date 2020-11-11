CC=gcc

CFLAGS = -Wall -Werror -O2 -mavx2 -mtune=skylake -std=gnu99 -g -fno-tree-vectorize
CFLAGS_GRADING = -Wall -O2 -mavx2 -mtune=skylake -std=gnu99 -g -fno-tree-vectorize
LIBS = -lm

OBJS = run.o timing.o rotate.o

all: benchmark test

$(OBJS): run.h defs.h timing.h

benchmark: $(OBJS) benchmark_main.o
	$(CC) $(CFLAGS) $^ $(LIBS) -o benchmark

test: run.o timing.o rotate.o test_main.o
	$(CC) $(CFLAGS) $^ $(LIBS) -o test

grader: run_grader.o timing_grader.o rotate_grader.o benchmark_main_grader.o
	$(CC) $(CFLAGS_GRADING) $^ $(LIBS) -o grader

%_grader.o: %.c
	$(CC) -DGRADER $(CFLAGS_GRADING) $^ -c -o $@

clean:
	rm -f *.o

archive:
	rm -f rotate.tar
	tar \
	    --xform=s,^,rotate/, \
	    --xform='s/rotate-empty\.c/rotate.c/' \
	    --show-transformed \
	    -cvf rotate.tar \
	    Makefile \
	    rotate-empty.c benchmark_main.c test_main.c \
	    run.c timing.c run.h defs.h timing.h

.PHONY: clean archive
