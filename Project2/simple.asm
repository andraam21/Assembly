%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here

    xor ebx, ebx
    xor eax, eax

parcurg:
    mov al, byte [esi + ebx]
    add eax, edx
      
    cmp eax, 90
    jle mutare ;; daca nu depaseste 'Z' in codul ASCII mutam litera criptata

    sub eax, 26 ;; in caz contrar "resetam" alfabetul
    
mutare:
    mov dword [edi + ebx], dword eax
   
    add ebx, 1
    sub ecx, 1
    cmp ecx, 0
    jne parcurg

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
