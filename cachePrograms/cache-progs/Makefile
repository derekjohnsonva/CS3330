CFLAGS = -O2 -ggdb -std=c99
CACHEGRIND=valgrind --tool=cachegrind
CHECK_MISS_RATE=@python3 check_miss_rate.py

all: prog1 prog2 prog3 prog4 prog5

test-prep:
	@python3 -V >/dev/null || echo "Python 3 not found: run `module load python3`?"

run-prog1: prog1
	@echo "---"
	@echo "prog1: with 32KB, 2-way, 64B"
	$(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog1
	@echo "---"
	@echo "prog1: with 16KB, 2-way, 64B"
	$(CACHEGRIND) --D1=16384,2,64 --cachegrind-out-file=/dev/null ./prog1

run-prog2: prog2
	@echo "---"
	@echo "prog2: with 32KB, 4-way, 64B"
	$(CACHEGRIND) --D1=32768,4,64 --cachegrind-out-file=/dev/null ./prog2
	@echo "---"
	@echo "prog2: with 32KB, 2-way, 64B"
	$(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog2

run-prog3: prog3
	@echo "---"
	@echo "prog3: with 32KB, 2-way, 128B"
	$(CACHEGRIND) --D1=32768,2,128 --cachegrind-out-file=/dev/null ./prog3
	@echo "---"
	@echo "prog3: with 32KB, 2-way, 64B"
	$(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog3

run-prog4: prog4
	@echo "---"
	@echo "prog3: with 32KB, 2-way, 64B"
	$(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog4
	@echo "---"
	@echo "prog3: with 32KB, 2-way, 128B"
	$(CACHEGRIND) --D1=32768,2,128 --cachegrind-out-file=/dev/null ./prog4

run-prog5: prog5
	@echo "---"
	@echo "prog5: with 32KB, 2-way, 128B"
	$(CACHEGRIND) --D1=32768,2,128 --cachegrind-out-file=/dev/null ./prog5
	@echo "---"
	@echo "prog5: with 32KB, 2-way, 64B"
	$(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog5

test-prog1: prog1
	$(CHECK_MISS_RATE) \
            --label="prog1 w/ 32K+2-way+64B" \
            --maximum-rate=10 -- \
            $(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog1
	$(CHECK_MISS_RATE) \
            --label="prog1 w/ 16K+2-way+64B" \
            --minimum-rate=90 -- \
            $(CACHEGRIND) --D1=16384,2,64 --cachegrind-out-file=/dev/null ./prog1

test-prog2: prog2
	$(CHECK_MISS_RATE) \
            --label="prog2 w/ 32K+4-way+64B" \
            --maximum-rate=10 -- \
            $(CACHEGRIND) --D1=32768,4,64 --cachegrind-out-file=/dev/null ./prog2
	$(CHECK_MISS_RATE) \
            --label="prog2 w/ 32K+2-way+64B" \
            --minimum-rate=90 -- \
            $(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog2

test-prog3: prog3
	$(CHECK_MISS_RATE) \
            --label="prog3 w/ 32K+2-way+128B" \
            --maximum-rate=60 -- \
            $(CACHEGRIND) --D1=32768,2,128 --cachegrind-out-file=/dev/null ./prog3
	$(CHECK_MISS_RATE) \
            --label="prog3 w/ 32K+2-way+64B" \
            --minimum-rate=90 -- \
            $(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog3

test-prog4: prog4
	$(CHECK_MISS_RATE) \
            --label="prog4 w/ 32K+2-way+64B" \
            --maximum-rate=10 -- \
            $(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog4 || true
	$(CHECK_MISS_RATE) \
            --label="prog4 w/ 32K+2-way+128B" \
            --minimum-rate=90 -- \
            $(CACHEGRIND) --D1=32768,2,128 --cachegrind-out-file=/dev/null ./prog4 || true

test-prog5: prog5
	$(CHECK_MISS_RATE) \
            --label="prog5 w/ 32K+2-way+128B" \
            --maximum-rate=40 -- \
            $(CACHEGRIND) --D1=32768,2,128 --cachegrind-out-file=/dev/null ./prog5 || true
	$(CHECK_MISS_RATE) \
            --label="prog5 w/ 32K+2-way+64B" \
            --minimum-rate=50 -- \
            $(CACHEGRIND) --D1=32768,2,64 --cachegrind-out-file=/dev/null ./prog5 || true

test-all: test-prep test-prog1 test-prog2 test-prog3 test-prog4 test-prog5

skeleton-archive:
	mkdir cache-progs
	cp prog-template.c cache-progs/prog1.c
	cp prog-template.c cache-progs/prog2.c
	cp prog-template.c cache-progs/prog3.c
	cp prog-template.c cache-progs/prog4.c
	cp prog-template.c cache-progs/prog5.c
	cp Makefile cache-progs/Makefile
	cp check_miss_rate.py cache-progs
	tar cf cache-progs.tar cache-progs
	rm -r cache-progs
	mkdir -p ../../website/files/cache-progs
	mv cache-progs.tar ../../website/files/cache-progs/cache-progs.tar
	git add ../../website/files/cache-progs/cache-progs.tar

SUBMIT_FILENAME=cache-progs-submit-$(shell date +%Y%m%d%H%M%S).tar

submit:
	tar cf $(SUBMIT_FILENAME) prog1.c prog2.c prog3.c prog4.c prog5.c
	@echo "Created $(SUBMIT_FILENAME); upload this file to kytos to submit."

.PHONY: all test-all test-prep \
        run-prog1 run-prog2 run-prog3 run-prog4 run-prog5 \
        test-prog1 test-prog2 test-prog3 test-prog4 test-prog5 \
        submit skeleton-archive
