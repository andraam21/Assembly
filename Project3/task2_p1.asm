section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b

cmmmc:
	; dam push lui edx, pentru ca vom lucra cu stiva
	push edx

	; salvez valoarea lui a
	xor eax, eax
	push dword [esp + 8]
    pop eax
    
    ; salvez valoarea lui  b
	xor edx, edx
    push dword [esp + 12]
    pop edx

    ; pentru a afla cmmmc comparam de fiecare data eax si ebx
    ; daca eax este mai mic adunam la acesta a
    ; in caz contrar adunam in edx b
    ; cand cei doi registrii vor fi egali inseamna ca am gasim rezultatul

continue:
    cmp eax, edx
    jl addina
    cmp eax, edx
    jg addinb

addina:
    add eax, dword [esp + 8]
    cmp eax, edx
    je stop
    jmp continue

addinb:
    add edx, dword [esp + 12]
    cmp eax, edx
    je stop
    jmp continue

stop:
	; in eax vom avea ce returneaza functia, adica cmmmc
	; reinitializam edx-ul
	pop edx

	ret

