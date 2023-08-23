#include "classify_chars.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int es_vocal(char ch){
    return ch == 'a' || ch =='e' || ch == 'i' || ch == 'o' || ch == 'u'; 
}

void classify_chars_in_string(char* string, char** vowels_and_cons){
    int i = 0;
    char current = string[0];

    int ultimaVocal = 0;
    int ultimaCons = 0;

    while (current != "\0") {
        if (es_vocal(current)) {
            vowels_and_cons[0][ultimaVocal] = current;
            ultimaVocal++;
        } else {
            vowels_and_cons[1][ultimaVocal] = current;
            ultimaVocal++;
        }
        i++;
        current = string[i];
    }
}

void classify_chars(classifier_t* array, uint64_t size_of_array) {
    for (int i = 0; i < size_of_array; i++) {
        array[i].vowels_and_consonants = calloc(2, 64);

        classify_chars_in_string(array[i].string, array[i].vowels_and_consonants);
    }
}
