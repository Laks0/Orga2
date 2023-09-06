section .rodata:
	%define offset_pixel 4

cuatroBlancos: times 16 db 0xFF
cuatroNegros:  times 4  dd 0x000000FF

global Pintar_asm

;void Pintar_asm(unsigned char *src, (rdi)
;              unsigned char *dst,   (rsi)
;              int width, 			 (rdx)
;              int height,           (rcx)
;              int src_row_size,     (r8)
;              int dst_row_size)     (r9);


section .text:
Pintar_asm:
	push rbp
	mov rbp, rsp
	push r12

	mov r12, rsi ; guardamos rsi para poder modificarlo

	mov r10, rdx ; r10 = width
	mov r11, rcx ; r11 = height

	shr r10, 2 ; width /= 4 porque ciclamos de a 4 píxeles
	
	movdqu xmm0, [cuatroBlancos]

	.cicloVertical:
		.cicloHorizontal:
		
			movdqu [rsi], xmm0
			add rsi, offset_pixel*4

		dec r10
		cmp r10, 0
		jne .cicloHorizontal

	dec r11
	cmp r11, 0
	jne .cicloVertical

	mov r10, rdx ; r10 = width
	mov r11, rcx ; r11 = height

	shr r10, 1 ; width /= 2 porque ciclamos de a 4 píxeles 2 veces

	mov rsi, r12 ; restauramos rsi
	movdqu xmm0, [cuatroNegros]

	.bordeHorizontal:
		movdqu [rsi], xmm0
		add rsi, offset_pixel*4
	dec r10
	jnz .bordeHorizontal

	mov rsi, r12 ; restauramos rsi

	pop r12
	pop rbp
	ret
	


