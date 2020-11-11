#include <stdio.h>
#include <stdlib.h>
#include "defs.h"

/* 
 * Please fill in the following struct with your name and the name you'd like to appear on the scoreboard
 */
who_t who = {
    "TheWalrus",           /* Scoreboard name */

    "Derek",   /* Full name */
    "dej3tc@virginia.edu",  /* Email address */
};

/***************
 * ROTATE KERNEL
 ***************/

/******************************************************
 * Your different versions of the rotate kernel go here
 ******************************************************/

/* 
 * naive_rotate - The naive baseline version of rotate 
 */
char naive_rotate_descr[] = "naive_rotate: Naive baseline implementation";
void naive_rotate(int dim, pixel *src, pixel *dst) 
{
    for (int i = 0; i < dim; i++)
	for (int j = 0; j < dim; j++)
	    dst[RIDX(dim-1-j, i, dim)] = src[RIDX(i, j, dim)];
}
/* 
 * rotate - Your current working version of rotate
 *          Our supplied version simply calls naive_rotate
 */
char rotate_16_unroll_descr[] = "unrolling 16: Unrolling with 16 values computed each time";
void rotate_16_unroll(int dim, pixel *src, pixel *dst) 
{
    for (int i = 0; i < dim; i++)
	for (int j = 0; j < dim; j += 16){
	    dst[RIDX(dim-1-j, i, dim)] = src[RIDX(i, j, dim)];
        dst[RIDX(dim-2-j, i, dim)] = src[RIDX(i, j+1, dim)];
        dst[RIDX(dim-3-j, i, dim)] = src[RIDX(i, j+2, dim)];
        dst[RIDX(dim-4-j, i, dim)] = src[RIDX(i, j+3, dim)];
        dst[RIDX(dim-5-j, i, dim)] = src[RIDX(i, j+4, dim)];
        dst[RIDX(dim-6-j, i, dim)] = src[RIDX(i, j+5, dim)];
        dst[RIDX(dim-7-j, i, dim)] = src[RIDX(i, j+6, dim)];
        dst[RIDX(dim-8-j, i, dim)] = src[RIDX(i, j+7, dim)];
        dst[RIDX(dim-9-j, i, dim)] = src[RIDX(i, j+8, dim)];
        dst[RIDX(dim-10-j, i, dim)] = src[RIDX(i, j+9, dim)];
        dst[RIDX(dim-11-j, i, dim)] = src[RIDX(i, j+10, dim)];
        dst[RIDX(dim-12-j, i, dim)] = src[RIDX(i, j+11, dim)];
        dst[RIDX(dim-13-j, i, dim)] = src[RIDX(i, j+12, dim)];
        dst[RIDX(dim-14-j, i, dim)] = src[RIDX(i, j+13, dim)];
        dst[RIDX(dim-15-j, i, dim)] = src[RIDX(i, j+14, dim)];
        dst[RIDX(dim-16-j, i, dim)] = src[RIDX(i, j+15, dim)];
    }
}

char rotate_8_unroll_descr[] = "unrolling 8: Unrolling with 8 values computed each time";
void rotate_8_unroll(int dim, pixel *src, pixel *dst) 
{
    for (int i = 0; i < dim; i++)
	for (int j = 0; j < dim; j += 8){
	    dst[RIDX(dim-1-j, i, dim)] = src[RIDX(i, j, dim)];
        dst[RIDX(dim-2-j, i, dim)] = src[RIDX(i, j+1, dim)];
        dst[RIDX(dim-3-j, i, dim)] = src[RIDX(i, j+2, dim)];
        dst[RIDX(dim-4-j, i, dim)] = src[RIDX(i, j+3, dim)];
        dst[RIDX(dim-5-j, i, dim)] = src[RIDX(i, j+4, dim)];
        dst[RIDX(dim-6-j, i, dim)] = src[RIDX(i, j+5, dim)];
        dst[RIDX(dim-7-j, i, dim)] = src[RIDX(i, j+6, dim)];
        dst[RIDX(dim-8-j, i, dim)] = src[RIDX(i, j+7, dim)];
    }
}

char rotate_4_unroll_descr[] = "unrolling 4: Unrolling with 4 values computed each time";
void rotate_4_unroll(int dim, pixel *src, pixel *dst) 
{
    for (int i = 0; i < dim; i++)
	for (int j = 0; j < dim; j += 4){
	    dst[RIDX(dim-1-j, i, dim)] = src[RIDX(i, j, dim)];
        dst[RIDX(dim-2-j, i, dim)] = src[RIDX(i, j+1, dim)];
        dst[RIDX(dim-3-j, i, dim)] = src[RIDX(i, j+2, dim)];
        dst[RIDX(dim-4-j, i, dim)] = src[RIDX(i, j+3, dim)];
    }
}

char rotate_calculate_inter_descr[] = "calc inter value: Unrolling with intermediate value";
void rotate_calculate_inter(int dim, pixel *src, pixel *dst) 
{
    int src_val, dst_val, sub_val;
    for (int i = 0; i < dim; i++) {
        src_val = i*dim;
        for (int j = 0; j < dim; j += 4){
            dst_val = (dim-1-j) * dim + i;
            sub_val = dim;
            dst[dst_val] = src[src_val + j];
            dst[dst_val - sub_val] = src[src_val + j + 1];
            sub_val+=dim;
            dst[dst_val - sub_val] = src[src_val + j + 2];
            sub_val+=dim;
            dst[dst_val -sub_val] = src[src_val + j + 3];
        }
    }
}

char rotate_blocks_16_descr[] = "rotate_blocks_16: Rotate blocks by 16";
void rotate_blocks_16(int dim, pixel *src, pixel *dst) {
    int i, j;
    int ii, jj;

    for(ii=0; ii < dim; ii+=16)
    {
		for(jj=0; jj < dim; jj+=16)
		{
			for(i=ii; i < ii+16; i+=4) 
			{
				for(j=jj; j < jj+16; j+=4) 
				{
					dst[RIDX(dim-1-j,i,dim)] = src[RIDX(i,j,dim)];
                    dst[RIDX(dim-2-j,i,dim)] = src[RIDX(i,j+1,dim)];
                    dst[RIDX(dim-3-j,i,dim)] = src[RIDX(i,j+2,dim)];
                    dst[RIDX(dim-4-j,i,dim)] = src[RIDX(i,j+3,dim)];

                    dst[RIDX(dim-1-j,i+1,dim)] = src[RIDX(i+1,j,dim)];
                    dst[RIDX(dim-2-j,i+1,dim)] = src[RIDX(i+1,j+1,dim)];
                    dst[RIDX(dim-3-j,i+1,dim)] = src[RIDX(i+1,j+2,dim)];
                    dst[RIDX(dim-4-j,i+1,dim)] = src[RIDX(i+1,j+3,dim)];

                    dst[RIDX(dim-1-j,i+2,dim)] = src[RIDX(i+2,j,dim)];
                    dst[RIDX(dim-2-j,i+2,dim)] = src[RIDX(i+2,j+1,dim)];
                    dst[RIDX(dim-3-j,i+2,dim)] = src[RIDX(i+2,j+2,dim)];
                    dst[RIDX(dim-4-j,i+2,dim)] = src[RIDX(i+2,j+3,dim)];

                    dst[RIDX(dim-1-j,i+3,dim)] = src[RIDX(i+3,j,dim)];
                    dst[RIDX(dim-2-j,i+3,dim)] = src[RIDX(i+3,j+1,dim)];
                    dst[RIDX(dim-3-j,i+3,dim)] = src[RIDX(i+3,j+2,dim)];
                    dst[RIDX(dim-4-j,i+3,dim)] = src[RIDX(i+3,j+3,dim)];
				}
			}
		}
	}
}

char rotate_blocks_32_descr[] = "rotate_blocks_32: Block by 32 and unroll";
void rotate_blocks_32(int dim, pixel *src, pixel *dst)
{
    int i, j;
    int ii, jj;
    // int src_val, dst_val, sub_val;

    for(ii=0; ii < dim; ii+=32)
    {
		for(jj=0; jj < dim; jj+=32)
		{
			for(i=ii; i < ii+32; i++) 
			{
				for(j=jj; j < jj+32; j+=4) 
				{
					dst[RIDX(dim-1-j,i,dim)] = src[RIDX(i,j,dim)];
                    dst[RIDX(dim-2-j,i,dim)] = src[RIDX(i,j+1,dim)];
                    dst[RIDX(dim-3-j,i,dim)] = src[RIDX(i,j+2,dim)];
                    dst[RIDX(dim-4-j,i,dim)] = src[RIDX(i,j+3,dim)];
				}
			}
		}
	}
}

char rotate_blocks_unrolled_descr[] = "rotate_blocks_unrolled: Rotate using blocking and unrolling";
void rotate_blocks_unrolled(int dim, pixel *src, pixel *dst) {
    int i, j;
    int ii, jj;
    int src_val, dst_val, sub_val;
    for(ii=0; ii < dim; ii+=16)
    {
		for(jj=0; jj < dim; jj+=16)
		{
			for(i=ii; i < ii+16; i++) 
			{
                src_val = i*dim;
				for(j=jj; j < jj+16; j+=4) 
				{
					dst_val = (dim-1-j) * dim + i;
                    sub_val = dim;
                    dst[dst_val] = src[src_val + j];
                    dst[dst_val - sub_val] = src[src_val + j + 1];
                    sub_val+=dim;
                    dst[dst_val - sub_val] = src[src_val + j + 2];
                    sub_val+=dim;
                    dst[dst_val -sub_val] = src[src_val + j + 3];
				}
			}
		}
	}
}

/*********************************************************************
 * register_rotate_functions - Register all of your different versions
 *     of the rotate function by calling the add_rotate_function() for
 *     each test function. When you run the benchmark program, it will
 *     test and report the performance of each registered test
 *     function.  
 *********************************************************************/

void register_rotate_functions() {
    add_rotate_function(&naive_rotate, naive_rotate_descr);
    // add_rotate_function(&rotate_16_unroll, rotate_16_unroll_descr);
    // add_rotate_function(&rotate_8_unroll, rotate_8_unroll_descr);
    // add_rotate_function(&rotate_4_unroll, rotate_4_unroll_descr);
    add_rotate_function(&rotate_calculate_inter, rotate_calculate_inter_descr);
    add_rotate_function(&rotate_blocks_16, rotate_blocks_16_descr);
    add_rotate_function(&rotate_blocks_32, rotate_blocks_32_descr);
    add_rotate_function(&rotate_blocks_unrolled, rotate_blocks_unrolled_descr);
}
