/* ** por compatibilidad se omiten tildes **
================================================================================
 TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Definicion de funciones de impresion por pantalla.
*/

#include "screen.h"

void printCheto(const char* text, uint32_t x, uint32_t y, uint16_t attr){
  ca(*p)[VIDEO_COLS] = (ca(*)[VIDEO_COLS])VIDEO; 
  int32_t i = 0;
  while(text[i] != '\0'){
    if(y >= VIDEO_COLS){
      x++;
      y = 0;
      if(x >= VIDEO_FILS) break;
    }
    if(text[i] == '\n'){
      i++;
      x++;
      y = 0;
      continue;
    }
    p[x][y].c = text[i];
    p[x][y].a = attr;
    y++;
    i++;
  }
} 

void print(const char* text, uint32_t x, uint32_t y, uint16_t attr) {
  ca(*p)[VIDEO_COLS] = (ca(*)[VIDEO_COLS])VIDEO; 
  int32_t i;
  for (i = 0; text[i] != 0; i++) {
    p[y][x].c = (uint8_t)text[i];
    p[y][x].a = (uint8_t)attr;
    x++;
    if (x == VIDEO_COLS) {
      x = 0;
      y++;
    }
  }
}

void print_dec(uint32_t numero, uint32_t size, uint32_t x, uint32_t y,
               uint16_t attr) {
  ca(*p)[VIDEO_COLS] = (ca(*)[VIDEO_COLS])VIDEO; 
  uint32_t i;
  uint8_t letras[16] = "0123456789";

  for (i = 0; i < size; i++) {
    uint32_t resto = numero % 10;
    numero = numero / 10;
    p[y][x + size - i - 1].c = letras[resto];
    p[y][x + size - i - 1].a = attr;
  }
}

void print_hex(uint32_t numero, int32_t size, uint32_t x, uint32_t y,
               uint16_t attr) {
  ca(*p)[VIDEO_COLS] = (ca(*)[VIDEO_COLS])VIDEO; 
  int32_t i;
  uint8_t hexa[8];
  uint8_t letras[16] = "0123456789ABCDEF";
  hexa[0] = letras[(numero & 0x0000000F) >> 0];
  hexa[1] = letras[(numero & 0x000000F0) >> 4];
  hexa[2] = letras[(numero & 0x00000F00) >> 8];
  hexa[3] = letras[(numero & 0x0000F000) >> 12];
  hexa[4] = letras[(numero & 0x000F0000) >> 16];
  hexa[5] = letras[(numero & 0x00F00000) >> 20];
  hexa[6] = letras[(numero & 0x0F000000) >> 24];
  hexa[7] = letras[(numero & 0xF0000000) >> 28];
  for (i = 0; i < size; i++) {
    p[y][x + size - i - 1].c = hexa[i];
    p[y][x + size - i - 1].a = attr;
  }
}

void screen_draw_box(uint32_t fInit, uint32_t cInit, uint32_t fSize,
                     uint32_t cSize, uint8_t character, uint8_t attr) {
  ca(*p)[VIDEO_COLS] = (ca(*)[VIDEO_COLS])VIDEO;
  uint32_t f;
  uint32_t c;
  for (f = fInit; f < fInit + fSize; f++) {
    for (c = cInit; c < cInit + cSize; c++) {
      p[f][c].c = character;
      p[f][c].a = attr;
    }
  }
}


const char* Nerv  = "\n    Bienvenidos al Kernel del grupo 1 \n"
  "\n"
    "                 __ _._.,._.__\n"
    "              .o8888888888888888P'\n"
    "            .d88888888888888888K\n"
    "  ,8        888888888888888888888boo._\n"
    " :88b       888888888888888888888888888b.\n"
    "  `Y8b      88888888888888888888888888888b.\n"
    "    `Yb.   d8888888888888888888888888888888b\n"
    "      `Yb.___.88888888888888888888888888888888b\n"
    "        `Y888888888888888888888888888CG88888P\"'\n"
    "          `88888888888888888888888888888MM88P\"'\n"
    "     \"Y888K    \"Y8P\"\"Y888888888888888oo._\"\"\"\"'\n"
    "       88888b    8    8888`Y888888888888888888oo.\n"
    "       8\"Y8888b  8    8888  ,8888888888888888888888o,\n"
    "       8  \"Y8888b8    8888\"\"Y8`Y8888888888888888888888b.\n"
    "       8    \"Y8888    8888   Y  `Y8888888888888888888888\n"
    "       8      \"Y88    8888     .d `Y88888888888888888888b\n"
    "     .d8b.      \"8  .d8888b..d88P   `Y88888888888888888888\n"
    "                                  `Y88888888888888888b.\n"
    "                   \"Y888P\"\"Y8b. \"Y888888888888888888888\n"
    "                     888    888   Y888`Y888888888888888\n"
    "                     888   d88P    Y88b `Y8888888888888\n"
    "                     888\"Y88K\"      Y88b dPY8888888888P\n"
    "                     888  Y88b       Y88dP  `Y88888888b\n"
    "                     888   Y88b       Y8P     `Y8888888\n"
    "                   .d888b.  Y88b.      Y        `Y88888\n"
    "                                                  `Y88K\n"
    "                                                    `Y8\n"
    "                                                      '"
    "\n"
    "Tobi, Lakso y Abi"
    ;



void screen_draw_layout(void){
    screen_draw_box(0,400,VIDEO_FILS,VIDEO_COLS,0,0);
    printCheto(Nerv, 1, 1, 4);
}
