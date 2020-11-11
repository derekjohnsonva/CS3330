#ifndef ADD_H_
#define ADD_H_

/* define function_type as another name for a
 * pointer to function returning unsigned short (unsigned short)
 *   and taking a long and unsigned short* and const unsigned short* arguments:
 */
typedef void (*function_type)(long, unsigned short*, const unsigned short*);

typedef struct {
    function_type f;
    const char *name;
} function_info;

extern function_info functions[];

#endif
