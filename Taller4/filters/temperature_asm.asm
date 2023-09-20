section .rodata
    %define offset_pixel 4
    

alfa: times 8 dw 255
tres: times 2 dq 3

menorA32: times 4 db 255, 0, 0, 255
treintaydos: times 4 dd 32
dosveinticuatro: times 4 dd 224
menorA96: times 4 dd 255, 0, 0, 255
noventayseis: times 4 dd 96
cientosesenta: times 4 dd 160

casoBase: times 4 db 0, 0, 255, 255

global temperature_asm

section .data

section .text
;void temperature_asm(unsigned char *src,   rdi
;              unsigned char *dst,          rsi
;              int width,                   rdx
;              int height,                  rcx
;              int src_row_size,            r8  
;              int dst_row_size);           r9

temperature_asm:
    push rbp
    mov rbp, rsp
    push r10

    shr rdx, 1          ;dividimos el ancho por dos ya q vamos a loopear de a 2 pixeles

    movdqu xmm1, [alfa] ;guardamos en xmm1 la constante 255
    movdqu xmm2, [tres]
    cvtdq2ps xmm2, xmm2
    pxor xmm7, xmm7     ; xmm7 = 0

    .cicloVertical:
        mov r10, rdx
        .cicloHorizontal:
            movdqu xmm0, [rdi]
            pshufd xmm0, xmm0, 01001110b        ;lo giramos para agarrar los dos pixels mas significativos 
            pmovzxdq xmm0, xmm0                 ;extendemos los pixels de dw a qw

            pshufd xmm0, xmm0, 11011000b        ;pone los dos píxeles en la parte baja
            pmovzxbw xmm0, xmm0                 ; 0r0g0b0a... Cada componente  de cada pixel está empaquetada como word
            
            phaddw xmm0, xmm0                   ;sumamos de a dos componentes en cada pixel. queda en la parte baja
            phaddw xmm0, xmm0                   ;terminamos de sumar las componentes

            psubw  xmm0, xmm1                   ;le restamos 255 ya que el alfa esta siempre en 255 
            ;las dos words más bajas son la suma de los píxeles

            pmovzxwd xmm0, xmm0                 ;desempaquetamos las w a dw
            
            cvtdq2ps xmm0, xmm0
            divps xmm0, xmm2                    ;dividimos por 3

            cvttps2dq xmm0, xmm0                ;truncamos los floats a dw enteros

            ;ahora tenemos las Ts de cada píxel en las dos dw más bajas

            pxor xmm6, xmm6 ; xmm6 guarda el resultado del filtro

            ; Caso base
            movdqu xmm4, xmm0                   ;guardamos las temperaturas en xmm4
            movdqu xmm8, [dosveinticuatro]
            psubw xmm4, xmm8                    ;t -= 224
            psllw xmm4, 8                       ;ponemos el t en el componente del r
            psllw xmm4, 2                       ;t = t*4

            movdqu xmm5, [casoBase]             ;xmm5 tiene la parte que no depende de t
            psubb xmm5, xmm4                    ;xmm5 guarda el resultado si pasan la guarda

            pand xmm5, xmm3                     ;0 si no corresponde, el píxel si corresponde
            movdqu xmm6, xmm5                    ;agregamos a xmm6

            ; < 160
            movdqu xmm3, [noventayseis]         ;xmm3 guarda cuatro 96 como dw
            pcmpgtd xmm3, xmm0                  ;xmm3 es máscara de cada t si son < 32 (0 si no y F si sí)

            movdqu xmm4, xmm0                   ;guardamos las temperaturas en xmm4
            movdqu xmm8, [treintaydos]
            psubw xmm4, xmm8                    ;t -= 32
            psllw xmm4, 8                       ;ponemos el t en el componente del r para que clipee el shift
            psllw xmm4, 2                       ;t = t * 4
            pslld xmm4, 8                       ;ponemos t en el lugar de g

            movdqu xmm5, [menorA96]             ;xmm5 tiene la parte que no depende de t
            paddb xmm5, xmm4                    ;xmm5 guarda el resultado si pasan la guarda

            pand xmm5, xmm3                     ;0 si no corresponde, el píxel si corresponde
            movdqu xmm6, xmm5                    ;agregamos a xmm6

            ; < 96
            movdqu xmm3, [noventayseis]         ;xmm3 guarda cuatro 96 como dw
            pcmpgtd xmm3, xmm0                  ;xmm3 es máscara de cada t si son < 32 (0 si no y F si sí)

            movdqu xmm4, xmm0                   ;guardamos las temperaturas en xmm4
            movdqu xmm8, [treintaydos]
            psubw xmm4, xmm8                    ;t -= 32
            psllw xmm4, 8                       ;ponemos el t en el componente del r para que clipee el shift
            psllw xmm4, 2                       ;t = t * 4
            pslld xmm4, 8                       ;ponemos t en el lugar de g

            movdqu xmm5, [menorA96]             ;xmm5 tiene la parte que no depende de t
            paddb xmm5, xmm4                    ;xmm5 guarda el resultado si pasan la guarda

            pand xmm5, xmm3                     ;0 si no corresponde, el píxel si corresponde
            movdqu xmm6, xmm5                    ;agregamos a xmm6
            
            ; < 32
            movdqu xmm3, [treintaydos]          ;xmm3 guarda cuatro 32 como dw
            pcmpgtd xmm3, xmm0                  ;xmm3 es máscara de cada t si son < 32 (0 si no y F si sí)

            movdqu xmm4, xmm0                   ;guardamos las temperaturas en xmm4
            pslld xmm4, 24                      ;ponemos el t en el componente del b
            psllw xmm4, 2                       ;multiplica t*4 (y el overflow desaparece porque está al borde de la word)
            
            movdqu xmm5, [menorA32]             ;xmm5 tiene la parte que no depende de t
            paddb xmm5, xmm4                    ;xmm5 guarda el resultado si pasan la guarda

            pand xmm5, xmm3                     ;0 si no corresponde, el píxel si corresponde
            movdqu xmm6, xmm5                   ;agregamos a xmm6

            ; el resto de las guardas

            add rdi, offset_pixel * 2
            movq [rsi], xmm6
            add rsi, offset_pixel * 2

        dec r10
        jnz .cicloHorizontal

    dec rcx
    jnz .cicloVertical



    pop r10
    pop rbp
    ret
