#include "vector.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


vector_t* nuevo_vector(void) {
    vector_t* vector = malloc(24);
    vector->array = NULL;
    vector->size = 0;
    vector->capacity = 0;

}

uint64_t get_size(vector_t* vector) {
    return vector->size;
}

void push_back(vector_t* vector, uint32_t elemento) {
    if(vector->capacity == 0){
        vector->array = malloc(4);
        vector->array[0] = elemento;
        vector->size = 1;
        vector->capacity = 1;
    }
    else{
        if(vector->size == vector->capacity){
            vector->array = realloc(vector->array, vector->capacity * 2);
            vector->capacity *= 2;
        } else{
        }
        vector->array[vector->size] = elemento;
        vector->size += 1;
    }
}

int son_iguales(vector_t* v1, vector_t* v2) {
    return (v1->size == v2->size) && (v1->capacity == v2->capacity) && (v1->array == v2->array);
}

uint32_t iesimo(vector_t* vector, size_t index) {
    return vector->array[index];
}

void copiar_iesimo(vector_t* vector, size_t index, uint32_t* out){
    uint32_t i = 0;
    while(i < index){
        i++;
    }
    out = &i;
}


// Dado un array de vectores, devuelve un puntero a aquel con mayor longitud.
vector_t* vector_mas_grande(vector_t** array_de_vectores, size_t longitud_del_array) {
}
