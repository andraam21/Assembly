global get_words
global compare_func
global sort

section .text
    extern strlen
    extern strcmp
    extern qsort
    extern strtok
    
section .data
    len1 dd 0
    len2 dd 0
    delim db ",. ", 10, 0

compare_func:
    ; dam push la registrii pe care o sa-i folosim
    push ebx
    push ecx

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx

    ; adresa de inceput a primului cuvant
    mov ebx, dword [esp + 12] 
    ; apelam strlen
    push dword [ebx]
    call strlen
    ; salvez raspunsul functiei strlen din eax in len1
    mov dword [len1], eax 
    ; reinitializam esp
    add esp, 4 

    ; adresa de inceput de la al doilea cuvant
    mov ecx, dword [esp + 16]
    ; apelam strlen
    push dword [ecx]
    call strlen
    ; salevez a doua lungime in len2
    mov dword [len2], eax 
    ; reinitializam esp
    add esp, 4

    xor ebx, ebx 
    mov ebx, dword [len1] 
    ; compar cele doua lungimi ale cuvintelor
    cmp ebx, dword [len2] 
    jg swap ; daca len1 > len2
    cmp ebx, dword [len2] 
    jl noswap ; daca len1 < len2
    cmp ebx, dword [len2] 
    je lexicalsort ; daca len1 = len2

swap:
   push 1
   pop eax
   jmp endcompare

noswap:
    push -1
    pop eax
    jmp endcompare

lexicalsort:
    xor ebx, ebx
    xor ecx, ecx
    mov ebx, dword [esp + 12] ; primul cuvant
    mov ecx, dword [esp + 16] ; al doilea cuvant

    ; apelam strcmp
    ; dam push mai intai la al doilea cuvant
    ; (functia va lua ultimul parametru la care dam push ca fiind primul)
    push dword [ecx]
    push dword [ebx]
    call strcmp ; in eax ne va returna 1/-1 (sortarea lexicografica)
    ; reinitializam esp
    add esp, 8
    jmp endcompare

endcompare:
    ; dam pop la registrii folositi si iesim din functie
    pop ecx
    pop ebx
    
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix

sort:
    enter 0, 0

    ; dam push la registrii folositi 
    push eax
    push ebx
    push ecx

    mov eax, dword [ebp + 8] ; matricea de cuvinte
    mov ebx, dword [ebp + 12] ; numarul cuvintelor
    mov ecx, dword [ebp + 16] ; dimensiunea

    ; apelam qsort si dam push parametrilor in ordine inversa
    push compare_func
    push ecx
    push ebx
    push eax 
    call qsort
    add esp, 16 ; reinitializam esp dupa functie

    ; dam pop inainte sa iesim din functie
    pop ecx
    pop ebx
    pop eax

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte

get_words:
    enter 0, 0

    xor edx, edx
    ; adresa de inceput a stringului
    mov edx, dword [ebp + 8] 
    ; apelam strtok
    push delim
    push edx
    call strtok ; in eax vom avea tokenul
    add esp, 8

    xor edi, edi
    mov edi, dword [ebp + 12] ; adresa la care sa punem cuvintele sortate

addloop:
    mov dword [edi], eax ; incep sa mut cuvintele sortate
    add edi, 4 ; ne mutam la urmatoarea locatie

    ; cautam urmatorul cuvant folosind din nou strtok
    push delim
    push 0
    call strtok ; in eax vom avea noul token
    add esp, 8

    ; daca token-ul nu este NULL, atunci adaugam in continuare cuvintele
    cmp eax, 0
    jne addloop

    leave
    ret
