#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

int main (void){
	uint64_t* arreglo = malloc(16);
	arreglo[0] = 15;
	arreglo[1] = 14;
	invertirQW_asm(arreglo);
	assert(arreglo[0] == 14 && arreglo[1] == 15);
	free(arreglo);
	return 0;
}


