YAS=./tools/yas
HCLRS=./tools/hclrs
UNAME_S=$(shell uname -s)
UNAME_M=$(shell uname -m)
HCLRS_TAR=./tools/hclrs-current-$(UNAME_S)-$(UNAME_M).tar.gz
HCLRS_DIST_ROOT=https://www.cs.virginia.edu/~cr4bd
DC=dmd
DFLAGS=-O
DOT=dot

all: hclrs
	(cd tools; make all)

$(HCLRS_TAR):
	@if [ ! -e "$(HCLRS_TAR)" ]; then \
	    echo "No prebuilt HCLRS binary available for this platform, sorry."; \
            echo "Use a Linux machine (a VM or lab machines via SSH) or "; \
            echo "see instructions on the HCLRS page on the course webpage."; \
            exit 1; \
	fi

$(HCLRS): $(HCLRS_TAR)
	cd tools && tar xf `basename $(HCLRS_TAR)`

hclrs: $(HCLRS)
	rm -f ./hclrs
	ln -s $(HCLRS) ./hclrs

.SUFFIXES: .ys .yo
.ys.yo:
	$(YAS) $*.ys

.SUFFIXES: .dot .png
.dot.png: 
	$(DOT) -Tpng $*.dot > $*.png

update-hclrs:
	cd tools && curl -O $(HCLRS_DIST_ROOT)/`basename $(HCLRS_TAR)`
	cd tools && tar xvf `basename $(HCLRS_TAR)`

compile-hclrs:
	mkdir -p hclrs-src
	@cargo --version || (echo "Install Rust first; see https://rustup.rs/"; false)
	cd hclrs-src && [ -e .git ] || git clone https://github.com/woggle/hclrs -b cs3330-current .
	cd hclrs-src && git pull
	cd hclrs-src && cargo build --release
	cp $(HCLRS) $(HCLRS).backup`date +%Y%m%d%H%M%S` || true
	cp hclrs-src/target/release/hclrs $(HCLRS)

clean:
	(cd tools; make clean)
	rm -f *.exe *.o *.obj *~ core.* *_hcl.d *_hcl.dot *_hcl.png

test-check:
	@python3 -m py_compile testing_tool.py || (\
            echo "Executing tests requires Python 3 to be installed on your system."; \
	    echo "If you are on a department machine, run module load python3,"; \
	    echo "then try again."; \
            false \
        )

test-pc: test-check
	@echo "Running pc.hcl tests" 
	python3 testing_tool.py test pc.hcl testdata/pc-tests.txt testdata/pc-reference

test-irrr: test-check
	@echo "Running irrr.hcl tests (nop/halt/irmovq/rrmovq/jmp)" 
	python3 testing_tool.py test --compare-trace irrr.hcl testdata/irrr-tests.txt testdata/seq-traces

test-seqlab: test-check
	@echo "Running seqlab.hcl tests (nop/halt/irmovq/rrmovq/jmp/OPq/cmovXX/rmmovq)" 
	python3 testing_tool.py test --compare-trace seqlab.hcl testdata/seqlab-tests.txt testdata/seq-traces

test-seqhw: test-seqhw-stack

test-seqhw-nostack: test-check
	@echo "Running seqhw.hcl tests (all instructions but push/pop/call/ret)"
	python3 testing_tool.py test --compare-trace seqhw.hcl testdata/seqhw-tests.txt testdata/seq-traces

test-seqhw-stack: test-check
	@echo "Running seqhw.hcl tests (all instructions including push/pop/call/ret)"
	python3 testing_tool.py test --compare-trace seqhw.hcl testdata/seqhw-stack-tests.txt testdata/seq-stack-traces

test-pipelab1: test-check
	@echo "Running pipelab1.hcl tests (two stages for nop/halt/irmovq/rrmovq)"
	python3 testing_tool.py test pipelab1.hcl testdata/pipelab1-tests.txt testdata/pipelab1-reference

test-pipelab2: test-check
	@echo "Running pipelab2.hcl tests (rmmovq/mrmovq/halt)"
	python3 testing_tool.py test pipelab2.hcl testdata/pipelab2-tests.txt testdata/pipe-reference

test-pipehw1: test-check
	@echo "Running pipehw1.hcl tests (nop/halt/irmovq/rrmovq/OPq/cmovXX)"
	python3 testing_tool.py test pipehw1.hcl testdata/pipehw1-tests.txt testdata/pipe-reference

test-pipehw2: test-pipehw2-stack

test-pipehw2-nostack: test-check
	@echo "Running pipehw2.hcl tests (all instructions but push/pop/call/ret)"
	python3 testing_tool.py test pipehw2.hcl testdata/pipehw2-nostack-tests.txt testdata/pipe-reference

test-pipehw2-stack: test-check
	@echo "Running pipehw2.hcl tests (all instructions including push/pop/call/ret)"
	python3 testing_tool.py test pipehw2.hcl testdata/pipehw2-stack-tests.txt testdata/pipe-stack-reference

references:
	python3 testing_tool.py create-reference sln8_pipehw2.hcl testdata/pipe-stack-reference
	python3 testing_tool.py create-reference sln8_pipehw2.hcl testdata/pipe-reference
	python3 testing_tool.py create-reference sln8_pipehw2_nostack.hcl testdata/pipe-nostack-reference
	python3 testing_tool.py create-reference --include-trace sln8_pipehw2.hcl testdata/pipe-stack-traces
	python3 testing_tool.py create-reference --include-trace sln8_pipehw2.hcl testdata/pipe-traces
	python3 testing_tool.py create-reference --include-trace sln8_pipehw2_nostack.hcl testdata/pipe-nostack-traces
	python3 testing_tool.py create-reference sln4_seqhw.hcl testdata/seq-stack-reference
	python3 testing_tool.py create-reference sln4_seqhw.hcl testdata/seq-reference
	python3 testing_tool.py create-reference sln4_seqhw_nostack.hcl testdata/seq-nostack-reference
	python3 testing_tool.py create-reference --include-trace sln4_seqhw.hcl testdata/seq-traces
	python3 testing_tool.py create-reference --include-trace sln4_seqhw.hcl testdata/seq-stack-traces
	python3 testing_tool.py create-reference --include-trace sln4_seqhw_nostack.hcl testdata/seq-nostack-traces
	python3 testing_tool.py create-reference sln5_pipelab1.hcl testdata/pipelab1-reference
	python3 testing_tool.py create-reference sln1_pc.hcl testdata/pc-reference

all-yos:
	for y in y86/*.ys; do \
	    $(MAKE) -q y86/`basename $$y .ys`.yo || $(MAKE) --no-print-directory y86/`basename $$y .ys`.yo; \
	done

archive:
	cd tools && wget $(HCLRS_DIST_ROOT)/hclrs-current-Darwin-i386.tar.gz
	cd tools && wget $(HCLRS_DIST_ROOT)/hclrs-current-Darwin-x86_64.tar.gz
	cd tools && wget $(HCLRS_DIST_ROOT)/hclrs-current-Linux-x86_64.tar.gz
	cd tools && wget $(HCLRS_DIST_ROOT)/hclrs-current-Linux-i686.tar.gz
	cd tools && wget $(HCLRS_DIST_ROOT)/hclrs-current-windows-x86_64.zip
	cd tools && wget $(HCLRS_DIST_ROOT)/hclrs-current-windows-i686.zip
	tar -cvf hclrs.tar --xform 's!^.!hclrs!' \
             --exclude=*.o --exclude=yis --exclude=yas --exclude-vcs --exclude=hclrs \
             --exclude=pc.hcl --exclude='ir*'.hcl --exclude=seqlab.hcl --exclude='pipelab*.hcl' --exclude='pipehw*.hcl' \
             --exclude=seqhw.hcl --exclude='sln*.hcl' --exclude='*_hcl.d' --exclude='*_hcl.dot' --exclude='*.exe' \
             --exclude=tests --exclude hcl.tar --exclude hclrs.tar .

.PHONY: all clean archive references \
    test-pc test-ir test-seqlab test-seqhw test-pipelab1 test-pipelab2 test-pipehw1 test-pipehw2 \
    all-yos test-check
