%include "../include/io.mac"

section .data
    lenplain dd 0
    lenkey dd 0

section .text
    global beaufort
    extern printf
    
; void beaufort(int len_plain, char *plain, int len_key, char *key, char tabula_recta[26][26], char *enc) ;
beaufort:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; len_plain
    mov ebx, [ebp + 12] ; plain (address of first element in string)
    mov ecx, [ebp + 16] ; len_key
    mov edx, [ebp + 20] ; key (address of first element in matrix)
    mov edi, [ebp + 24] ; tabula_recta
    mov esi, [ebp + 28] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement spiral encryption
    ;; FREESTYLE STARTS HERE

    ;; salvam lungimea cheii si pe cea a textului
    mov [lenplain], eax
    mov [lenkey], ecx
    
    xor eax, eax
    xor ecx, ecx
    xor edi, edi

criptare:    
    mov ah, byte [ebx + ecx] ;; text
    mov al, byte [edx + edi] ;; cheia
    cmp al, ah ;; le comparam pentru a sti ce formula sa aplicam
    jge mare
    cmp al, ah
    jl mic

mare:
    sub al, ah
    add al, 65
    jmp mutare
    
mic:
    add al, 26
    sub al, ah
    add al, 65
    jmp mutare
    
mutare:
    mov byte [esi + ecx], al
    add edi, 1
    cmp edi, [lenkey] ;; daca depaseste lungimea cheii resetam contorul ei
    jne nudepasestecheie
    mov edi, 0

nudepasestecheie:
    add ecx, 1
    cmp ecx, [lenplain]
    jne criptare

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
