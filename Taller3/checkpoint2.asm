extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_simplified
global alternate_sum_8
global product_2_f
global product_9_f
global alternate_sum_4_using_c

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]
alternate_sum_4:
	;prologo
	push rbp
	mov rbp, rsp
	sub rsp, 8 

	xor rax, rax ;ponemos rax en 0

	mov rax, rdi
	sub rax, rsi
	add rax, rdx
	sub rax, rcx

	;epilogo
	add rsp, 8
	pop rbp
	ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4_using_c:
	;prologo
	push rbp ; alineado a 16
	mov rbp,rsp
	sub rsp, 8 

	call restar_c
	mov rdi, rax
	mov rsi, rdx
	call sumar_c
	mov rdi, rax
	mov rsi, rcx
	call restar_c

	;epilogo
	add rsp, 8
	pop rbp
	ret



; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]
alternate_sum_4_simplified:
xor rax, rax ;ponemos rax en 0

	mov rax, rdi
	sub rax, rsi
	add rax, rdx
	sub rax, rcx

	ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[?], x2[?], x3[?], x4[?], x5[?], x6[?], x7[?], x8[?]
alternate_sum_8:
	push rbp
	mov rbp, rsp
	sub rsp, 8 
	

	mov rax, rdi
	sub rax, rsi
	add rax, rdx
	sub rax, rcx
	add rax, r8
	sub rax, r9

	add rax, [rbp + 16]
	sub rax, [rbp + 24]
	
	add rsp, 8
	pop rbp
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
product_2_f:

	cvtsi2ss xmm1, rsi 	;convertimos rsi a float
	mulss xmm1, xmm0	;multiplicamos
	cvtss2si eax, xmm1	;convertimos a int
	mov [rdi], eax

	ret


;extern void product_9_f(uint32_t * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[rcx], f3[xmm2], x4[r8], f4[xmm3]
;	, x5[r9], f5[xmm4], x6[rbp + 16], f6[xmm5], x7[rbp + 24], f7[xmm6], x8[rbp + 32], f8[xmm7],
;	, x9[rbp + 40], f9[rbp + 48]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp
	sub rsp, 8

	;convertimos los flotantes de cada registro xmm en doubles
	cvtss2sd xmm0, xmm0
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm2, xmm2
	cvtss2sd xmm3, xmm3
	cvtss2sd xmm4, xmm4
	cvtss2sd xmm5, xmm5
	cvtss2sd xmm6, xmm6
	cvtss2sd xmm7, xmm7

	cvtss2sd xmm8, [rbp + 48]

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7
	mulsd xmm0, xmm8

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	cvtsi2sd xmm1, rsi
	cvtsi2sd xmm2, rdx
	cvtsi2sd xmm3, rcx
	cvtsi2sd xmm4, r8
	cvtsi2sd xmm5, r9
	cvtsi2sd xmm6, [rbp + 40]
	cvtsi2sd xmm7, [rbp + 32]
	cvtsi2sd xmm8, [rbp + 24]
	cvtsi2sd xmm9, [rbp + 16]

	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7
	mulsd xmm0, xmm8
	mulsd xmm0, xmm9


	movq [rdi], xmm0

	; epilogo
	add rsp, 8
	pop rbp
	ret


