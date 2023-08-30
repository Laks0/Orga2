#include "lista_enlazada.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


lista_t* nueva_lista(void) {
    lista_t* lista = malloc(8);
    lista->head = NULL;
    return lista;
}

uint32_t longitud(lista_t* lista) {
    nodo_t* current = lista->head;
    uint32_t cont = 0;
    while(current != NULL){
        cont++;
        current = current->next;
    }
    return cont;
}

void agregar_al_final(lista_t* lista, uint32_t* arreglo, uint64_t longitud) {
    nodo_t* current = lista->head;
    nodo_t* anterior;
    while(current != NULL){
        anterior = current;
        current = current->next;
    }
    nodo_t* nuevo = malloc(sizeof(nodo_t));
    nuevo->arreglo = malloc(sizeof(uint32_t)*longitud);
    // Falta copiar el contenido del arreglo.
    nuevo->longitud = longitud; nuevo->next = NULL;
    anterior->next = nuevo;
}

nodo_t* iesimo(lista_t* lista, uint32_t i) {
    nodo_t* current = lista->head;
    for(int j = 0; j < i; j++){
        current = current->next;
    }
    return current;
}

uint64_t cantidad_total_de_elementos(lista_t* lista) {
    uint64_t cont = 0;
    nodo_t* current = lista->head;
    while(current != NULL){
        cont += current->longitud;

        current = current->next;
    }
    return cont;
}

void imprimir_lista(lista_t* lista) {
    nodo_t* current = lista->head;
    for(int i = 0; i < longitud(lista); i ++){
        printf("| %d | -> ", current->longitud);
        current = current->next;
    }
    printf("null");
}

// Función auxiliar para lista_contiene_elemento
int array_contiene_elemento(uint32_t* array, uint64_t size_of_array, uint32_t elemento_a_buscar) {
    for(int i = 0; i < size_of_array; i++){
        if(array[i] == elemento_a_buscar)
            return 1;
    }
    return 0;
}

int lista_contiene_elemento(lista_t* lista, uint32_t elemento_a_buscar) {
    nodo_t* current = lista->head;
    for(int i = 0; i < longitud(lista); i ++){
        if (array_contiene_elemento(current->arreglo, current->longitud, elemento_a_buscar)) {
            return 1;
        }
        current = current->next;
    }
    return 0;
}


// Devuelve la memoria otorgada para construir la lista indicada por el primer argumento.
// Tener en cuenta que ademas, se debe liberar la memoria correspondiente a cada array de cada elemento de la lista.
void destruir_lista(lista_t* lista) {
    nodo_t* current = lista->head;
    while(current != NULL){
        nodo_t* temporal = current;
        current = current->next;
        free(temporal);
    }
    free(lista);
}
