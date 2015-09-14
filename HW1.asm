;CSIT 499 - Reverse Engineering - Homework #1
;Dr. Matt Miller - September 10th
;96740976 - Igor Felipe Ferreira Ceridorio

%include "asm_io.inc"
segment .data
	outA db "A= ", 0
	outB db "B= ", 0
	outC db "C= ", 0
	outD db "D= ", 0
	outAmodC db "A mod C is ", 0
	outCmodB db "C mod B is ", 0
	outResult db "The result is ", 0

segment .bss 
	a resd 1
	b resd 1
	c resd 1
	d resd 1
	aModC resd 1
	cModB resd 1
segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
	;***************CODE STARTS HERE***************************
	;reading the input from the user	
	call read_int
	mov [a], eax

	call read_int
	mov [b], eax

	call read_int
	mov [c], eax

	call read_int
	mov [d], eax

	;print variables values
	mov eax, outA
	call print_string
	mov eax, [a]
	call print_int
	call print_nl
	
	mov eax, outB
	call print_string
	mov eax, [b]
	call print_int
	call print_nl
	
	mov eax, outC
	call print_string
	mov eax, [c]
	call print_int
	call print_nl

	mov eax, outD
	call print_string
	mov eax, [d]
	call print_int
	call print_nl

	;printing the phrase of first mod operation
	mov eax, outAmodC
	call print_string
	
	;A mod C
	mov ebp, [c]
	mov eax, [a]
	mov edx, 0
	div ebp
	mov eax, edx
	mov [aModC], eax
	call print_int
	call print_nl

	;printing the phrase of second mod operation
	mov eax, outCmodB
	call print_string

	;C mod B
	mov ebp, [b]
	mov eax, [c]
	mov edx, 0
	div ebp
	mov eax, edx
	mov [cModB], eax
	call print_int
	call print_nl

	;printing the phrase of the result
	mov eax, outResult
	call print_string

	;computing the expression
	mov eax, [b]
	mov edx, [b]
	mul edx
	mov edx, eax
	mov eax, [b]
	mul edx
	mov edx, eax
	mov eax, [aModC]
	mul edx
	mov ebp, [cModB]
	mov edx, 0
	div ebp
	add eax, [d]
	call print_int
	call print_nl

	;***************CODE ENDS HERE*****************************
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret
