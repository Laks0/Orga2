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

	// Checkpoint 3

	lista_t* lista = malloc(sizeof(lista_t));
	nodo_t* nodo1 = malloc(sizeof(nodo_t));
	nodo1->categoria = 0;
	nodo1->arreglo = NULL;
	nodo1->longitud = 8;

	nodo_t* nodo2 = malloc(sizeof(nodo_t));
	nodo2->categoria = 0;
	nodo2->arreglo = NULL;
	nodo2->longitud = 5;

	nodo1->next = nodo2;
	nodo2->next = NULL;

	lista->head = nodo1;

	uint32_t cant = cantidad_total_de_elementos(lista);

	assert(cant == 13);

	free(nodo1);
	free(nodo2);
	free(lista);

	packed_lista_t* plista = malloc(sizeof(packed_lista_t));
	packed_nodo_t* pnodo1 = malloc(sizeof(packed_nodo_t));
	pnodo1->categoria = 0;
	pnodo1->arreglo = NULL;
	pnodo1->longitud = 8;

	packed_nodo_t* pnodo2 = malloc(sizeof(packed_nodo_t));
	pnodo2->categoria = 0;
	pnodo2->arreglo = NULL;
	pnodo2->longitud = 5;

	packed_nodo_t* pnodo3 = malloc(sizeof(packed_nodo_t));
	pnodo3->categoria = 0;
	pnodo3->arreglo = NULL;
	pnodo3->longitud = 2;

	pnodo1->next = pnodo2;
	pnodo2->next = pnodo3;
	pnodo3->next = NULL;

	plista->head = pnodo1;

	cant = cantidad_total_de_elementos_packed(plista);

	assert(cant == 15);

	free(pnodo1);
	free(pnodo2);
	free(pnodo3);
	free(plista);

	return 0;
}


