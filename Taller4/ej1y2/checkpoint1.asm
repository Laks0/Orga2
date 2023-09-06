
section .text
global invertirQW_asm

; void invertirQW_asm(uint8_t* p)


invertirQW_asm:
	push rbp
	mov rbp, rsp
	sub rsp, 8

	movdqu xmm0, [rdi]
	pshufd xmm0, xmm0, 01001110b
	;pxor xmm0, xmm0

	movdqu [rdi], xmm0

	add rsp, 8
	pop rbp
	ret
