#ifndef SUM_H_
#define SUM_H_

/* define function_type as another name for a
 * pointer to function rerturning unsigned short and taking a long and unsigned short* argument
 */
typedef unsigned short (*function_type)(long, unsigned short*);

typedef struct {
    function_type f;
    const char *name;
} function_info;

extern function_info functions[];

/* reference implementation for correctness testing */
extern unsigned short sum_C(long size, unsigned short *a);

#endif
