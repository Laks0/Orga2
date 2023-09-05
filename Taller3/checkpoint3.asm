

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar:
NODO_LENGTH	EQU	8+1+7+8+4+4
LONGITUD_OFFSET	EQU	8+1+7+8

PACKED_NODO_LENGTH	EQU	8+1+8+4
PACKED_LONGITUD_OFFSET	EQU	8+1+8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[rdi]
cantidad_total_de_elementos:
	push rbp
	mov rbp, rsp
	sub rsp, 8

	xor rax, rax

	mov rbx, [rdi]
	xor r12, r12 ; r12 = 0

	.ciclo:
	cmp rbx, r12
	je .fin
	add eax, [rbx + LONGITUD_OFFSET]
	mov rbx, [rbx]
	jmp .ciclo

	.fin:
	add rsp, 8
	pop rbp
	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
    push rbp
	mov rbp, rsp
	sub rsp, 8

	xor rax, rax

	mov rbx, [rdi]
	xor r12, r12 ; r12 = 0

	.ciclo:
	cmp rbx, r12
	je .fin
	add eax, [rbx + PACKED_LONGITUD_OFFSET]
	mov rbx, [rbx]
	jmp .ciclo

	.fin:
	add rsp, 8
	pop rbp
	ret

