#include "contar_espacios.h"
#include <stdio.h>

uint32_t longitud_de_string(char* string) {
    uint32_t i = 0;

    while(string != NULL  && *(string + i) != '\0') {
        i++;
    }
    return i;
}

uint32_t contar_espacios(char* string) {
    int n = longitud_de_string(string);
    uint32_t contador = 0;
    for(int i = 0; i < n; i++){
        if(*(string + i) == ' '){
            contador++;
        }
    }
    return contador;
}

// Pueden probar acá su código (recuerden comentarlo antes de ejecutar los tests!)

/* int main() {

    printf("1. %d\n", contar_espacios("hola como andas?"));

    printf("2. %d\n", contar_espacios("holaaaa orga2"));
} */
