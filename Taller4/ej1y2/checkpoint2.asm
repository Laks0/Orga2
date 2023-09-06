section .text

	%define offset_terna 16
global checksum_asm

; uint8_t checksum_asm(void* array, uint32_t n)
;						      rdi      rsi
checksum_asm:
	push rbp
	mov rbp, rsp
	sub rsp, 8

	mov rcx, rsi		;ponemos n en rcx para loopear
	pcmpeqd xmm8, xmm8
	mov r8, rdi

	.ciclo:
		movdqu xmm6, [r8]                ; xmm6 = A
		movdqu xmm7, [r8+offset_terna]   ; xmm7 = B
		movdqu xmm2, [r8+offset_terna*2] ; xmm2 = C[1...4]
		movdqu xmm3, [r8+offset_terna*3] ; xmm3 = C[5...8]

		pmovsxwd xmm0, xmm6 ;guardamos los primeros 4 a en xmm0
		pmovsxwd xmm1, xmm7 ;guardamos los primeros 4 b en xmm1
		paddd xmm0, xmm1
		pslld xmm0, 3       ;multiplicamos xmm0 por 8
		pcmpeqd xmm0, xmm2
		pand xmm8, xmm0

		; Invertimos el contenido de A y B para desempaquetar los segundos
		pshufd xmm6, xmm6, 01001110b
		pshufd xmm7, xmm7, 01001110b

		pmovsxwd xmm0, xmm6 ;guardamos los segundos 4 a en xmm0
		pmovsxwd xmm1, xmm7 ;guardamos los segundos 4 b en xmm1
		paddd xmm0, xmm1
		pslld xmm0, 3       ;multiplicamos xmm0 por 8
		pcmpeqd xmm0, xmm3
		pand xmm8, xmm0

		add r8, 64
	loop .ciclo

	packusdw xmm8, xmm8
	movq r9, xmm8
	inc r9
	cmp r9, 0
	je .verdadero

	.falso:
	xor rax, rax
	jmp .fin

	.verdadero:
	mov rax, 1

	.fin:
	add rsp, 8
	pop rbp
	ret

