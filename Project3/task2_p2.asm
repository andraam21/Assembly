section .text
	global par

section .data
	len dd 0

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression

par:
	; dam push registrilor ebx, ecx, edx, pentru ca vom lucra cu stiva
	push ebx
	push ecx
	push edx

	xor edx, edx

    ; salvez lungimea stringului
	; deoarece am dat push la 3 registrii vom incrementa esp cu 3*4=12
	; (initial lugimea era la esp + 4)
	xor ecx, ecx
	push dword [esp + 16]
    pop dword [len]
  
    ; inceputul stringului
	xor eax, eax
    push dword [esp + 20]
    pop eax

string:
	; parcurgem sirul de la inceput la final, incrementand ecx
	push dword [eax + ecx]
	xor ebx, ebx
	pop ebx
	; in codul ASCII 40 = ( si 41 = )
	cmp bl, 41
	je right
	cmp bl, 40
	je left

; daca e paranteza ) incrementam contorul edx
right:
	add edx, 1
	add ecx, 1
	cmp ecx, dword [len]
	jne string
	jmp final

; daca e paranteza ( decrementam contorul edx
left:
	sub edx, 1
	add ecx, 1
	cmp ecx, dword [len]
	jne string
	jmp final

; daca in final cotorul este 0 inseamna ca sirul e balansat
final:
	cmp edx, 0
	je good
	jmp bad

good:
	push 1
	xor eax, eax
	pop eax
	jmp end

bad:
	push 0
	xor eax, eax
	pop eax
	jmp end

end:
	; punem inapoi registrii folositi
	pop edx
	pop ecx
	pop ebx

	ret
