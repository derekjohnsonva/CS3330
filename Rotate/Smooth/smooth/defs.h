/*
 * defs.h - Various definitions for smooth HW.
 * 
 * DO NOT MODIFY ANYTHING IN THIS FILE
 */
#ifndef _DEFS_H_
#define _DEFS_H_

#include <stdlib.h>

#define RIDX(i,j,n) ((i)*(n)+(j))

typedef struct {
  char *scoreboard_name;
  char *name1, *email1;
} who_t;

extern who_t who;

typedef struct {
   unsigned char red;
   unsigned char green;
   unsigned char blue;
   unsigned char alpha;
} pixel;

typedef void (*test_func) (int, pixel*, pixel*);

void register_smooth_functions(void);
void add_smooth_function(test_func, const char*);

#endif /* _DEFS_H_ */

