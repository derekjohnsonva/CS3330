CC=gcc
CFLAGS=-Wall -O2
LCFLAGS=-O2
DC=dmd
DFLAGS=-O

# LEX = flex
# YACC=bison
# LEXLIB = -lfl

all: yis yas

clean:
	rm -f *.o *.yo *.exe yis yas hcl2d *~ core.* hclrs


yas-grammar.o: yas-grammar.c
	$(CC) $(LCFLAGS) -c yas-grammar.c

isa.o: isa.c isa.h
	$(CC) $(CFLAGS) -c isa.c

yas.o: yas.c yas.h isa.h
	$(CC) $(CFLAGS) -c yas.c

yas: yas.o yas-grammar.o isa.o
	$(CC) $(CFLAGS) yas-grammar.o yas.o isa.o ${LEXLIB} -o yas

yis.o: yis.c isa.h
	$(CC) $(CFLAGS) -c yis.c

yis: yis.o isa.o
	$(CC) $(CFLAGS) yis.o isa.o -o yis

#### if you want to re-lex you can...
yas-grammar.c: yas-grammar.lex
	$(LEX) yas-grammar.lex
	mv lex.yy.c yas-grammar.c

#### if you want to re-pegged you can...
grammar.d: hcl2d_grammar.d
	r$(DC) hcl2d_grammar.d



