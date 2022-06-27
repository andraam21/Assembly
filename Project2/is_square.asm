%include "../include/io.mac"

section .text
    global is_square
    extern printf

is_square:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; dist
    mov eax, [ebp + 12]     ; nr
    mov ecx, [ebp + 16]     ; sq
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    xor edx, edx
    xor edi, edi
    xor esi, esi
    mov esi, eax
    
loop1:
    push ecx
    mov edx, [ebx + edi]
    cmp edx, 0 ;; consideram ca numarul nu e pp
    je pperf
   
    xor eax, eax
    mov eax, edx
    xor ecx, ecx
    mov ecx, edx
    mov edx, 1
    
loop2:
    xor eax, eax
    mov eax, ecx
    div dl
    cmp al, dl
    jl nuepperf ;; in cazul in care contorul depaseste rezultatul nu e pp
    mul al ;; verificam daca contor*contor=nr_initial
    cmp eax, ecx
    je pperf
    add dl, 1 
    jmp loop2

pperf:
    pop ecx
    mov dword [ecx + edi], 1
    jmp final

nuepperf:
    pop ecx
    mov dword [ecx + edi], 0
    jmp final
    
final:
    add edi, 4
    sub esi, 1
    cmp esi, 0
    jne loop1
    
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY