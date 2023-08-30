#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

int main (void){
	/* Acá pueden realizar sus propias pruebas */
	assert(alternate_sum_4_using_c(8,2,5,1) == 10);
	assert(alternate_sum_8(8,2,5,1,2,3,4,5) == 8);

	uint32_t* res = malloc(8);
	product_2_f(res, 5, 5.0);
	assert(*res == 25);
	free(res);
	
	assert(alternate_sum_4(8,2,5,1) == 10);	

	double* res2 = malloc(sizeof(double));
	product_9_f(res2, 1, 2, 3, 3, 2, 1, 2, 3, 3, 2, 3, 2, 1, 2, 3, 3, 3, 2);
	assert(*res2 == 839808);
	free(res2);
	return 0;    
}


