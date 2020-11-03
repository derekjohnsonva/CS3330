#include <stdio.h>

/*
This template code works by accessing elements of an array in a particular order in a loop.

By default, it accesses element 0, 4, 8, 12, ..., 1048564, 0, 4, 8, 12, ...
until it has performed 64 million accesses.

As a result, this initial program will result in a very high data cache miss rate
(assuming it's compiled with optimizations so `i` and `j` are stored in registers
and the compiler doesn't cleverly optimize out the array accesses).

You can edit this code:
*  to adjust the maximum index used by changing MAX;
*  to adjust the interval between indexes by changing SKIP;
*  to adjust the number of accesses by changing ITERS;

The code works by setting up each element array to contain the index of the next one
to access (so, with index 0 will contain 4, 4 will contain 8, 1048564 will contain 0, etc.),
and then accessing the array in a loop to find the next array element to access.
This prevents some clever techniques where the compiler or processor might skip some
array accesses or perform multiple array accesses in parallel.
*/

/* array of about 1M ints, configured to be placed at an address that's a multiple of 128 */
int global_array[1048568] __attribute__((aligned(128)));

/*
This tells GCC or Clang to assume that the array is being modified,
so it doesn't try optimize based on assuming it knows what values it contains.

(It works by saying "here's some inline assembly (which happens to be blank),
and, by the way, compiler, it might modify values in memory.)
*/
void prevent_optimizations_based_on_knowing_array_values() {
    __asm__ volatile ("":::"memory");
}

int main() {
    const int MAX = 1048568;
    const int SKIP = 4;
    const int ITERS = 64000000;
    for (int i = 0; i < MAX; ++i) {
        global_array[i] = (i+SKIP) % (MAX);
    }
    prevent_optimizations_based_on_knowing_array_values();
    int j = 0;
    for (int i = 0; i < ITERS; ++i) {
        j = global_array[j];
    }
    /* print out j to ensure that the compiler doesn't optimize the array accesses above away */
    printf("%d\n", j);
}

