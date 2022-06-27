%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global road
    extern printf
    extern points_distance

road:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]      ; points
    mov ecx, [ebp + 12]     ; len
    mov ebx, [ebp + 16]     ; distances
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    xor esi, esi
    xor edi, edi
    xor edx, edx

loop1:
    mov si, word [eax + point.x + edx] 
    mov di, word [eax + point_size + point.x + edx] 
    
    cmp si, di ;; verificam daca x-urile sunt egale
    je coordy

compar:
    cmp si, di
    jle mic  ;; vedem ce coordonata e mai mare pentru a avea un rezultat pozitiv
    sub si, di
    mov dword [ebx + edx], esi ;; salvam rezultatul
    jmp final

mic:
    sub di, si
    mov dword [ebx + edx], edi
    jmp final

coordy:
    mov si, word [eax + point.y + edx] 
    mov di, word [eax + point_size + point.y + edx] 
    jmp compar  
       
final:
    add edx, point_size
    sub ecx, 1
    cmp ecx, 1
    jne loop1
    
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY