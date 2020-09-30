/* Instruction set simulator for Y86-64 Architecture */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "isa.h"

/* YIS never runs in GUI mode */
int gui_mode = 0;

void usage(char *pname)
{
    printf("Usage: %s [-t | --test] code_file [max_steps]\n", pname);
    exit(0);
}

int main(int argc, char *argv[])
{
    FILE *code_file;
    int max_steps = 10000;
    int test_mode = 0;

    state_ptr s = new_state(MEM_SIZE);
    mem_t saver = copy_reg(s->r);
    mem_t savem;
    int step = 0;

    stat_t e = STAT_AOK;

    int i = 1;
    if (!strcmp(argv[i], "-t") || !strcmp(argv[i], "--test")) {
        ++i;
        test_mode = 1;
    }

    if (argc - i < 1 || argc - i > 2)
	usage(argv[0]);
    code_file = fopen(argv[i], "r");
    i++;
    if (!code_file) {
	fprintf(stderr, "Can't open code file '%s'\n", argv[1]);
	exit(1);
    }

    if (!load_mem(s->m, code_file, 1)) {
	printf("Exiting\n");
	return 1;
    }

    savem = copy_mem(s->m);
  
    if (argc > i)
	max_steps = atoi(argv[i]);

    for (step = 0; step < max_steps && e == STAT_AOK; step++)
	e = step_state(s, stdout);

    if (test_mode) {
        int reg, addr;
        printf("cycles:%d\n", step);
        if (e == STAT_HLT) {
            printf("Stat:HALT\n");
        } else if (e == STAT_AOK) {
            printf("Stat:TIMEOUT\n");
        } else {
            printf("Stat:%d\n", e);
        }
        for (reg = 0; reg < REG_NONE; ++reg) {
            word_t value;
            get_word_val(s->r, reg * 8, &value);
            printf("%s:0x%016lx\n", reg_name(reg), (unsigned long) value);
        }
        for (addr = 0; addr < s->m->len; ++addr) {
            if (s->m->contents[addr]) {
                printf("M[0x%016x]:0x%02x\n", addr, (unsigned) s->m->contents[addr]);
            }
        }
    } else {
        printf("Stopped in %d steps at PC = 0x%llx.  Status '%s', CC %s\n",
               step, s->pc, stat_name(e), cc_name(s->cc));

        printf("Changes to registers:\n");
        diff_reg(saver, s->r, stdout);

        printf("\nChanges to memory:\n");
        diff_mem(savem, s->m, stdout);
    }

    free_state(s);
    free_reg(saver);
    free_mem(savem);

    return 0;
}
