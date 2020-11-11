#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "timing.h"
#include "defs.h"
#include "run.h"

int main(int argc, char **argv) {
    if (!strcmp(who.scoreboard_name, "Your Scoreboard Identifier Here") ||
        !strcmp(who.name1, "Your Name Here") ||
        !strcmp(who.email1, "your@email.here")) {
        fprintf(stderr, "Please insert your scoreborad identifier, name, "
                        "and email into the who_t struct in rotate.c\n");
        return 1;
    }
#ifdef GRADER
    setup_grader_output();
#endif
    register_rotate_functions();
    if (argc > 1) {
        printf("Only running benchmarks whose description contains [%s]\n", argv[1]);
        test_benchmarks_containing(argv[1]);
    } else {
        test_all_benchmarks();
    }
}
