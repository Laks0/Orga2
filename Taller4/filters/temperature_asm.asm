section .rodata
    %define offset_pixel 4
    

alfa: times 8 dw 255
tres: times 2 dq 3
treintaydos:     times 4 dd 32
dosveinticuatro: times 4 dd 224
noventayseis:    times 4 dd 96
cientosesenta:   times 4 dd 160


menorA32:  times 4 db 255, 0, 0, 255
menorA96:  times 4 db 255, 0, 0, 255
menorA160: times 4 db 255, 255, 0, 255
menorA224: times 4 db 0, 255, 255, 255
casoBase:  times 4 db 0, 0, 255, 255

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

    .cicloVertical:
        mov r10, rdx
        .cicloHorizontal:
            ;movdqu xmm0, [rdi]
	    ; Por la endianness, los primeros dos píxeles quedan en la parte baja de xmm0
            pmovzxdq xmm0, [rdi]                 ;extendemos los pixels de dw a qw

            pshufd xmm0, xmm0, 11011000b        ;pone los dos píxeles en la parte baja
            pmovzxbw xmm0, xmm0                 ; 0r0g0b0a... Cada componente  de cada pixel está empaquetada como word
            
            phaddw xmm0, xmm0                   ;sumamos de a dos componentes en cada pixel. queda en la parte baja
            phaddw xmm0, xmm0                   ;terminamos de sumar las componentes

            psubw  xmm0, xmm1                   ;le restamos 255 ya que el alfa esta siempre en 255 
            ;las dos words más bajas son la suma de los píxeles

            pmovzxwd xmm0, xmm0                 ;desempaquetamos las w a dw
            
            cvtdq2ps xmm0, xmm0                 ;convertimos a floats
            divps xmm0, xmm2                    ;dividimos por 3

            cvttps2dq xmm0, xmm0                ;truncamos los floats a dw enteros

            pshufd xmm0, xmm0, 11011000b

            ;ahora tenemos las Ts de cada píxel en las dos dw más bajas

            pxor xmm6, xmm6 ; xmm6 guarda el resultado del filtro

	    ; Por razones de fuerza mayor, se interpretan las componentes de una dobleword de xmm6 como ARGB

            ;caso base (mayor a 224)
            movdqu xmm3, [casoBase]

            movdqu xmm4, xmm0      ;movemos las Ts para podes manejarlas a gusto ;) (en xmm4 va a estar la parte q depende de t)
            movdqu xmm8, [dosveinticuatro]
            psubd xmm4, xmm8        ;T -= 224
            pslld xmm4, 2           ;multiplicamos por 4

            pslldq xmm4, 2           ;movemos los T para poder restareslos a Red
            psubd xmm3, xmm4

            movdqu xmm6, xmm3

            ;menor a 224

            movdqu xmm3, [menorA224]

            movdqu xmm4, xmm0
            movdqu xmm8, [cientosesenta]
            psubd xmm4, xmm8
            pslld xmm4, 2           ;multiplicamos por 4

            pslldq xmm4, 1          ;movemos los T para poder restarselos a Green
            psubd xmm3, xmm4

            movdqu xmm5, [dosveinticuatro]
            pcmpgtd xmm5, xmm0       ; nos fijamos si T < 224
	    ; | xxxx | xxxx | FFFF | 0000 |

            pand xmm5, xmm3
	    ; | xxxx | xxxx | PPPP | 0000 |
            pxor xmm7, xmm7
            pcmpeqd xmm7, xmm5      ;comparamos xmm5 con 0 (en xmm7 tenemos 0 si no entro a la guarda y 1 si sí)
	    ; | xxxx | xxxx | 0000 | FFFF |
            pand xmm6, xmm7
	    ; | xxxx | xxxx | 0000 | PPPP |
            paddd xmm6, xmm5
	    ; | xxxx | xxxx | PPPP | PPPP |

            ; menor a 160
            movdqu xmm3, [menorA160]

            movdqu xmm4, xmm0
            movdqu xmm8, [noventayseis]
            psubd xmm4, xmm8        ;restmos 96 a los T
            pslld xmm4, 2           ;multiplicamos x 4

            psubd xmm3, xmm4        ;le restmaos al azul
            pslldq xmm4, 2          ;movemos dos bytes y ahora está en el rojo
            paddd xmm3, xmm4        ;le sumamos al rojo

            movdqu xmm5, [cientosesenta]
            pcmpgtd xmm5, xmm0       ; nos fijamos si T < 160

            pand xmm5, xmm3
            pxor xmm7, xmm7
            pcmpeqd xmm7, xmm5      ;comparamos xmm5 con 0 (en xmm7 tenemos 0 si no entro a la guarda y 1 si sí)
            pand xmm6, xmm7
            paddd xmm6, xmm5

            ;menor a 96
            movdqu xmm3, [menorA96]

            movdqu xmm4, xmm0
            movdqu xmm8, [treintaydos]
            psubd xmm4, xmm8
            pslld xmm4, 2

            pslldq xmm4, 1 ; Movemos un byte y ahora está en el rojo
            paddd xmm3, xmm4

            movdqu xmm5, [noventayseis]
            pcmpgtd xmm5, xmm0       ; nos fijamos si T < 96

            pand xmm5, xmm3
            pxor xmm7, xmm7
            pcmpeqd xmm7, xmm5      ;comparamos xmm5 con 0 (en xmm7 tenemos 0 si no entro a la guarda y 1 si sí)
            pand xmm6, xmm7
            paddd xmm6, xmm5
            
            ;menor a 32
            movdqu xmm3, [menorA32]

            movdqu xmm4, xmm0
            pslld xmm4, 2

            paddd xmm3, xmm4 ; Restamos al azul

            movdqu xmm5, [treintaydos]
            pcmpgtd xmm5, xmm0       ; nos fijamos si T < 32

            pand xmm5, xmm3
            pxor xmm7, xmm7
            pcmpeqd xmm7, xmm5      ;comparamos xmm5 con 0 (en xmm7 tenemos 0 si no entro a la guarda y 1 si sí)
            pand xmm6, xmm7
            paddd xmm6, xmm5


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
