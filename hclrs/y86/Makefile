YAS=../tools/yas

all:
	(cd ../tools; make all)

.SUFFIXES: .ys .yo
.ys.yo:
	$(YAS) $*.ys

clean:
	rm -f *.exe *.o *.obj *~ core.* *_hcl.d *.yo
