#ifndef SUM_H_
#define SUM_H_

/* define function_type as another name for a
 * pointer to function rerturning unsigned unsigned short and taking a long and unsigned unsigned short* argument
 */
typedef short (*function_type)(long, short*);

typedef struct {
    function_type f;
    const char *name;
} function_info;

extern function_info functions[];

/* reference implementation for correctness testing */
extern short min_C(long size, short *a);

#endif
