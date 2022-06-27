%include "../include/io.mac"

section .data
    N dd 0
    counter dd 0
    counter1 dd 0
    counter2 dd 0
    counter3 dd 0
    pencol dd 0
    adouac dd 0
    penlin dd 0
    adoualin dd 0
    atreial dd 0
    col3final dd 0
    lin3f dd 0
    col3 dd 0
    lin4 dd 0
    col4f dd 0
    lin4f dd 0
    col4 dd 0
    
section .text
    global spiral
    extern printf

; void spiral(int N, char *plain, int key[N][N], char *enc_string);
spiral:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; N (size of key line)
    mov ebx, [ebp + 12] ; plain (address of first element in string)
    mov ecx, [ebp + 16] ; key (address of first element in matrix)
    mov edx, [ebp + 20] ; enc_string (address of first element in string)
    ;; DO NOT MODIFY
    ;; TODO: Implement spiral encryption
    ;; FREESTYLE STARTS HERE

    mov [N], eax
    mov [counter], eax
    mov [counter1], eax
    mov [counter2], eax
    mov [counter3], eax
    mov [pencol], eax
    mov [adoualin], eax
    mov [adouac], eax
    mov [col3final], eax
    mov [penlin], eax
    mov [atreial], eax
    add [atreial], eax
    add [atreial], eax
    mov [lin3f], eax
    mov [col3], eax
    mov [lin4], eax
    mov [col4f], eax
    mov [lin4f], eax
    mov [col4], eax
    sub dword [col4], 7
    sub dword [lin4f], 6
    sub dword [col4f], 6
    sub dword [lin4], 5
    sub dword [col3], 4
    sub dword [lin3f], 4
    sub dword[col3final], 4
    sub dword[adouac], 3
    sub dword [atreial], 2
    sub dword [penlin], 2
    add dword [adoualin], eax
    sub dword [adoualin], 1
    sub dword [pencol], 2
    xor eax, eax
    xor edi, edi

;; pentru a parcurge textul folosin edi pe care il incrementam dupa fiecare pas
;; pentru a ne plimba in matrice folosim 4*esi, deoarece e de tip int (4 octeti)

primalinie:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * edi]
    mov byte [edx + edi], al
    add edi, 1
    cmp edi, dword [N]
    jne primalinie
    cmp dword [N], 1
    je final

    mov esi, edi
    add esi, [N]
    sub esi, 1
      
ultimacol:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    add esi, [N]
    sub dword [counter], 1
    cmp dword [counter], 1 
    jne ultimacol
    
    sub esi, [N]
    sub esi, 1

ultimalin:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    sub esi, 1
    sub dword [counter1], 1
    cmp dword [counter1], 1 
    jne ultimalin
    cmp dword [N], 2
    jle final
    
    sub esi, dword [N]
    add esi, 1
    
primacol:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    sub esi, dword [N]
    sub dword [counter2], 1
    cmp dword [counter2], 2 
    jne primacol

    cmp dword [N], 3
    je mijloc

    add esi, dword [N]
    add esi, 1
    
adoualinie:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    add esi, 1
    cmp esi, dword [adoualin]
    jne adoualinie

    add esi, dword [N]
    sub esi, 1

penultimacol:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    add esi, [N]
    sub dword [pencol], 1
    cmp dword [pencol], 1
    jne penultimacol

    sub esi, [N]
    sub esi, 1

penultimalin:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    sub esi, 1
    sub dword [penlin], 1
    cmp dword [penlin], 1
    jne penultimalin
    
    cmp dword [N], 4
    je final

    add esi, 1
    sub esi, [N]

adouacol:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    sub esi, [N]
    sub dword [adouac], 1
    cmp dword [adouac], 1
    jne adouacol

    cmp dword [N], 5
    je mijloc


    add esi, dword [N]
    add esi, 1
 
atreialin:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    add esi, 1
    cmp esi, dword [atreial]
    jne atreialin
 
    add esi, dword [N]
    sub esi, 1
   
col3fin:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    add esi, [N]
    sub dword [col3final], 1
    cmp dword [col3final], 1
    jne col3fin

    sub esi, [N]
    sub esi, 1

linie3fin:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    sub esi, 1
    sub dword [lin3f], 1
    cmp dword [lin3f], 1
    jne linie3fin

    cmp dword [N], 6
    je final

    sub esi, [N]
    add esi, 1

coloana3:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    sub esi, [N]
    sub dword [col3], 1
    cmp dword [col3], 2
    jne coloana3

    cmp dword [N], 7
    je mijloc

    add esi, [N]
    add esi,1

linia4:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    add esi, 1
    sub dword [lin4], 1
    cmp dword [lin4], 1
    jne linia4

    add esi, [N]
    sub esi, 1

col4fin:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    add esi, [N]
    sub dword [col4f], 1
    cmp dword [col4f], 1
    jne col4fin

    sub esi, [N]
    sub esi, 1
   

linia4final:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    sub esi, 1
    sub dword [lin4f], 1
    cmp dword [lin4f], 1
    jne linia4final

    cmp dword[N], 8
    je final

    sub esi, [N]
    add esi, 1

coloana4:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    sub esi, [N]
    sub dword [col4], 1
    cmp dword [col4], 1
    jne coloana4

    cmp dword [N], 9
    je mijloc

    add esi, [N]
    add esi, 1

linia5:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    add esi, 1
    sub dword [counter2], 1
    cmp dword [counter2], 0
    jne linia5

    add esi, [N]
    sub esi, 1

linia5final:
    mov al, byte [ebx + edi]
    add al, byte [ecx + 4 * esi]
    mov byte [edx + edi], al
    add edi, 1
    sub esi, 1
    sub dword [col3], 1
    cmp dword [col3], 0
    jne linia5final

    jmp final

;; cautam milocul matricei dupa formula (N-1)*(N-1)
mijloc:
    push edx
    xor edx, edx
    xor eax, eax
    mov eax, [N]
    push ecx
    mov ecx, 2
    div ecx
    pop ecx
    mov esi, eax
loop1:
    add esi, eax
    sub dword [counter3], 1
    cmp dword [counter3], 0
    jne loop1
    pop edx
    mov al, byte [ebx + edi]
    add al, byte [ecx +  4 * esi]
    mov byte [edx + edi], al
    jmp final

final:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
