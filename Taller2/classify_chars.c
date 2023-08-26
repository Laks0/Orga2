#include "classify_chars.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

uint8_t es_vocal(char c){
    return c == 'a' || c =='e' || c == 'i' || c == 'o' || c == 'u'; 
}

void classify_chars_in_string(char* string, char** vowels_and_cons){
    int i = 0;
    char current = string[0];

    int ultimaVocal = 0;
    int ultimaCons = 0;

    while (current) {
        if (es_vocal(current)) {
            vowels_and_cons[0][ultimaVocal] = current;
            ultimaVocal++;
        } else {
            vowels_and_cons[1][ultimaCons] = current;
            ultimaCons++;
        }
        i++;
        current = string[i];
    }
}

void classify_chars(classifier_t* array, uint64_t size_of_array) {
    for (uint32_t i = 0; i < size_of_array; i++) {
        // Reservamos memoria para los 2 punteros a char (64 bytes).
        array[i].vowels_and_consonants = calloc(2, sizeof(char*));

        // Reservamos memoria para los punteros a vocales y consonantes.
        array[i].vowels_and_consonants[0] = calloc(64,sizeof(char));
        array[i].vowels_and_consonants[1] = calloc(64,sizeof(char));

        classify_chars_in_string(array[i].string, array[i].vowels_and_consonants);
    }
}
