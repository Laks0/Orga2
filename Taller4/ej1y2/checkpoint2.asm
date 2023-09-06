section .rodata
	uno: times 16 db 0x01
	

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
		pmovsxwd xmm0, [r8]					;guardamos los primeros 4 a en xmm0
		pmovsxwd xmm1, [r8 + offset_terna]	;guardamos los primeros 4 b en xmm1
		movdqu xmm2, [r8 + offset_terna*2]	;guardamos los primeros 4 c en xmm2
		paddd xmm0, xmm1
		pslld xmm0, 3						; multiplicamos xmm0 por 8
		pcmpeqd xmm0, xmm2					
		pand xmm8, xmm0

		add r8, 8
		pmovsxwd xmm0, [r8]					;guardamos los segundos 4 a en xmm0
		pmovsxwd xmm1, [r8 + offset_terna]	;guardamos los segundos 4 b en xmm1
		movdqu xmm2, [r8 + offset_terna*2]	;guardamos los segundos 4 c en xmm2
		paddd xmm0, xmm1
		pslld xmm0, 3						; multiplicamos xmm0 por 8
		pcmpeqd xmm0, xmm2					
		pand xmm8, xmm0

		add r8, 56
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

