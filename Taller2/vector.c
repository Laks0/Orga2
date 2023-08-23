#include "vector.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


vector_t* nuevo_vector(void) {
    vector_t* vector = malloc(sizeof(vector_t));
    vector->array = NULL;
    vector->size = 0;
    vector->capacity = 0;

}

uint64_t get_size(vector_t* vector) {
    return vector->size;
}

void push_back(vector_t* vector, uint32_t elemento) {
    if(vector->capacity == 0){
        vector->array = malloc(8);
        vector->array[0] = elemento;
        vector->size = 1;
        vector->capacity = 1;
    }
    else{
        if(vector->size == vector->capacity){
            vector->array = realloc(vector->array, vector->capacity * 2 * 4);
            vector->capacity *= 2;
        }
        vector->array[vector->size] = elemento;
        vector->size += 1;
    }
}

int son_iguales(vector_t* v1, vector_t* v2) {
    if((v1->size != v2->size) && (v1->capacity != v2->capacity)){
        return 0;
    }
    for(int i = 0; i < v1->size; i++){
        if(v1->array[i] != v2->array[i])
            return 0;
    }
    return 1;
}

uint32_t iesimo(vector_t* vector, size_t index) {
    return vector->array[index];
}

void copiar_iesimo(vector_t* vector, size_t index, uint32_t* out){
    *out = vector->array[index];
}


// Dado un array de vectores, devuelve un puntero a aquel con mayor longitud.
vector_t* vector_mas_grande(vector_t** array_de_vectores, size_t longitud_del_array) {
    uint64_t maxSize = array_de_vectores[0] -> size;
    vector_t* mayor = array_de_vectores[0];

    for (int i = 1; i < longitud_del_array; i++) {
        if (array_de_vectores[i]->size > maxSize) {
            maxSize = array_de_vectores[i]->size;
            mayor = array_de_vectores[i];
        }
    }

    return mayor;
}
