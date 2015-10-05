;CSIT 499 - Reverse Engineering - Homework #2
;Dr. Matthew Miller - September 20th
;96740976 - Igor Felipe Ferreira Ceridorio

%include "asm_io.inc"
segment .data 
        outPhrase1 db "Enter the unit for file size:", 0
        outPhrase2 db "Enter the unit for throughput:", 0
        outPhrase3 db "Enter the file size:", 0
        outPhrase4 db "Enter the throughput:", 0
        outPhrase5 db "The time would be ", 0
        outPhrase6 db " seconds.", 0
        errorPhrase db "Error: Case sensitive. Units must be B, K or M.", 0
segment .bss 

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
    ;***************CODE STARTS HERE***************************
        ;receiving the first parameter
        mov eax, outPhrase1
        call print_string
        call read_char
        push eax
        call read_char ;flushing the enter key
        
        ;receiving the second parameter
        mov eax, outPhrase2
        call print_string
        call read_char
        push eax
        call read_char ;flushing the enter key
        
        ;receiving the third parameter
        mov eax, outPhrase3
        call print_string
        call read_int
        push eax
        call read_char ;flushing the enter key
        
        ;receiving the fourth paramter
        mov eax, outPhrase4
        call print_string
        call read_int
        push eax
        call read_char ;flushing the enter key

        ;calling the subprogram     
        call calculate
        
        ;print the result
        cmp eax, -1
        jz exit
        call print_int
        mov eax, outPhrase6
        call print_string

        exit:
        call print_nl
        
        ;alocates the stack space
        add esp, 010h

    ;***************CODE ENDS HERE*****************************
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret

    ;subprogram
    calculate:
        ;prologue
        push ebp
        mov ebp, esp
        
        ;allocating space for local variables
        sub esp, 010h
        
        ;storing ecx and edx values
        mov [ebp - 4], ecx
        mov [ebp - 8], edx
        
        ;subporgram code 
        
        ;converting the file size to bits
        mov eax, [ebp + 014h]
        
        cmp eax, 042h ;bytes case
        jz bFile
        cmp eax, 04Bh ;kbytes case
        jz kFile
        cmp eax, 04Dh ;megabytes case
        jz mFile
        jmp errorFile
    bFile:
        mov eax, [ebp + 0Ch]
        shl eax, 3
        mov [ebp - 0Ch], eax ;storing the value in a local variable
        jmp fileConverted
    kFile:
        mov eax, [ebp + 0Ch]
        shl eax, 0Dh
        mov [ebp - 0Ch], eax ;storing the value in a local variable
        jmp fileConverted
    mFile:
        mov eax, [ebp + 0Ch]
        shl eax, 017h
        mov [ebp - 0Ch], eax ;storing the value in a local variable
        jmp fileConverted
    errorFile:
        mov eax, errorPhrase
        call print_string
        mov eax, -1
        jmp endFunction
    
    fileConverted:
        ;converting the throughput size to bits
        mov eax, [ebp + 010h]
        
        cmp eax, 042h ;bits case
        jz bThroughput
        cmp eax, 04Bh ;kbits case
        jz kThroughput
        cmp eax, 04Dh ;megabits case
        jz mThroughput
        jmp errorFile
    bThroughput:
        mov eax, [ebp + 8]
        mov [ebp - 010h], eax  ;storing the value in a local variable
        jmp throughputConverted
    kThroughput:
        mov eax, [ebp + 8]
        shl eax, 0Ah
        mov [ebp - 010h], eax ;storing the value in a local variable
        jmp throughputConverted
    mThroughput:
        mov eax, [ebp + 8]
        shl eax, 014h
        mov [ebp - 010h], eax  ;storing the value in a local variable
    
    throughputConverted:
        mov eax, outPhrase5
        call print_string
        ;calculating the division
        mov eax, [ebp - 0Ch]
        mov ecx, [ebp - 010h]
        mov edx, 0
        div ecx
    
    endFunction:
        ;restoring ecx and edx values
        mov ecx, [ebp - 4]
        mov edx, [ebp - 8]
        
        ;remove local variables from stack
        add esp, 010h
        
       ;epilogue:
        mov esp, ebp
        pop ebp
        ret 