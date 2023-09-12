section .rodata:
	%define offset_pixel 4

cuatroBlancos: times 16 db 0xFF
cuatroNegros:  times 4  dd 0xFF000000

section .text
global Pintar_asm

extern Pintar_c

;void Pintar_asm(unsigned char *src, (rdi)
;              unsigned char *dst,   (rsi)
;              int width, 			 (rdx)
;              int height,           (rcx)
;              int src_row_size,     (r8)
;              int dst_row_size)     (r9);


Pintar_asm:
	push rbp
	mov rbp, rsp

	push r12

	mov r12, rsi ; guardamos rsi para poder modificarlo

	mov r11, rcx ; r11 = height
	
	movdqu xmm0, [cuatroBlancos]

	.cicloVertical:
		mov r10, rdx ; r10 = width
		shr r10, 2 ; width /= 4 porque ciclamos de a 4 píxeles

		.cicloHorizontal:
			movdqu [rsi], xmm0
			add rsi, offset_pixel*4

		dec r10
		jnz .cicloHorizontal
	dec r11
	jnz .cicloVertical

	mov r10, rdx ; r10 = width

	shr r10, 1 ; width /= 2 porque ciclamos de a 4 píxeles 2 veces

	mov rsi, r12 ; restauramos rsi
	movdqu xmm0, [cuatroNegros]

	.bordeHorizontalArriba:
		movdqu [rsi], xmm0
		add rsi, offset_pixel*4
	dec r10
	jnz .bordeHorizontalArriba

	mov rsi, r12 ; restauramos rsi

	add rsi, r9
	sub rsi, 8 ; rsi queda en el antepenúltimo píxel de la primer fila

	mov r11, rcx ; r11 = height
	dec r11

	.bordesVerticales:
		movdqu [rsi], xmm0
		add rsi, r9
	dec r11
	jnz .bordesVerticales

	mov rsi, r12
	mov r11, rcx ; r11 = height
	sub r11, 2

	.sumarRsi:
		add rsi, r9
	dec r11
	jnz .sumarRsi

	mov r10, rdx ; r10 = width
	shr r10, 1 ; width /= 2 porque ciclamos de a 4 píxeles 2 veces

	.bordeHorizontalAbajo:
		movdqu [rsi], xmm0
		add rsi, offset_pixel*4
	dec r10
	jnz .bordeHorizontalAbajo

	mov rsi, r12 ; restauramos rsi

	pop r12
	pop rbp
	ret


