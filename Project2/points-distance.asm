%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global points_distance
    extern printf

points_distance:
    ;; DO NOT MODIFY
    
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; points
    mov eax, [ebp + 12]     ; distance
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    xor ecx, ecx
    xor edx, edx
    xor esi, esi
    xor edi, edi

    mov cx, word [ebx + point.x] 
    mov dx, word [ebx + point.y]

    mov di, word [ebx + point_size + point.x] 
    mov si, word [ebx + point_size + point.y]

    cmp cx, di
    je coordy

    cmp cx, di
    jle mic ;; ne asiguram ca rezultatul o sa fie pozitiv
    sub cx, di
    mov word[eax], cx
    jmp final

mic:
    sub di, cx
    mov word[eax], di
    jmp final

coordy:
    cmp dx, si
    jle micy
    sub dx, si
    mov dword[eax], edx
    jmp final

micy:
    sub si, dx
    mov dword[eax], esi
    jmp final
    
final:

    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret

    ;; DO NOT MODIFY