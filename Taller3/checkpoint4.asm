extern malloc
extern free
extern fprintf

section .data
msg db 'NULL',10

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
;a[rdi], b[rsi]
strCmp:
    push rbp      ;alineado a 8
	mov rbp, rsp

	mov rax, 0

    .ciclo:
    mov r8b, BYTE [rdi]
    mov r9b, BYTE [rsi]
    cmp r8b, 0x00
    jz .aTermino
    cmp r9b, 0x00
    jz .bTermino
    cmp r8b, r9b
    jl .aMenor
    jg .aMayor
    inc rdi
    inc rsi
    jmp .ciclo

    .aTermino:
    cmp r9b, 0x00
    jz .fin
    jmp .aMenor

	.bTermino:
    cmp r8b, 0x00
    jz .fin
    jmp .aMayor

    .aMenor:
    mov rax,1
    jmp .fin

    .aMayor:
    mov rax,-1
    jmp .fin

	.fin:
	pop rbp
	ret

; char* strClone(char* a)
;a[rdi]
strClone:
    push rbp      ;alineado a 8
	mov rbp, rsp
	push rdi      ; alineado a 16, rdi = a
    call strLen   ; rax = a.size()

	push rax      ; alineacion a 8, rax = a.size()
	sub rsp, 8    ; alineado a 16
	mov rdi, rax  ; rdi = a.size()
    inc rdi;      ; para agregar el ult. caracter '\0'
	call malloc   ; rax ya es el puntero

	add rsp, 8
	pop r9        ; r9 = a.size()
	pop r8        ; r8 = a

	mov rcx, 0    ; Creo el contador

	.ciclo:
	cmp r9, rcx
	jz .fin
    mov dl, BYTE [r8 + rcx]
	mov [rax + rcx], dl ;Copio el caracter en la posicion actual
	inc rcx
	jmp .ciclo

	.fin:
	mov [rax + rcx], BYTE 0x00
	pop rbp
	ret

; void strDelete(char* a)
; a[rdi]
strDelete:
    push rbp
    mov rbp, rsp

    ;en rdi ya esta la direccion del string que tengo q liberar.
    call free

    pop rbp
	ret

; void strPrint(char* a, FILE* pFile)
; a[rdi], pfile[rsi]
strPrint:
    push rbp
    mov rbp, rsp

    ; Preservamos los registros no volátiles.
    push rbx;

    mov rbx, rsi        ; rbx = pfile
    mov r8b, BYTE [rdi] ;agarro el primer char de a
    cmp r8b, 0x00
    jz .esNull
    mov rsi, rdi       ;rsi = a
    jmp .print

    .esNull:
    mov rsi, msg     ; rsi = 'NULL'

    .print:
    mov rdi, rbx    ; rdi = pfile
    call fprintf

    pop rbx

    pop rbp
	ret

; uint32_t strLen(char* a)
; a[rdi]
strLen:
	push rbp
	mov rbp, rsp

	xor rax, rax    ;Limpio lo que hay en el registro de retorno

	.ciclo:
	mov dl, BYTE [rdi]   ;Cargo el char de la direccion apuntada por rdi a un registro de 1 byte
    cmp dl, 0x00    ;Veo si es un caracter nulo
    jz .fin
	inc rax         ;Incremento la longitud
	inc rdi         ; Voy al proximo char
	jmp .ciclo

	.fin:
	pop rbp
	ret
