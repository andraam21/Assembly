section .text
	global sort
	
section .data
	nodesnr dd 0
	counter dd 0
	adressof1 dd 0
	adressoflast dd 0
	small dd 0
	nextsmall dd 0
	adressofsmall dd 0
	adressofnextsmall dd 0

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list

sort:
	enter 0, 0
	
	; retin numarul elementelor
	xor eax, eax
	mov eax, [ebp + 8]
	mov dword [nodesnr], eax
	mov dword [counter], eax
	sub dword [counter], 1
		
	; incep sa caut numarul 1 si n incepand cu primul element
	xor eax, eax
	mov eax, [ebp + 12]
	xor ecx, ecx
	xor edi, edi
	mov edi, dword [nodesnr]
		
find1andn:
	cmp dword[eax], 1
	je found1
	cmp dword[eax], edi
	je foundn

continue:

	add eax, 8
	add ecx, 1
	cmp dword [nodesnr], ecx
	jne find1andn
	cmp dword [nodesnr], ecx
	je found

found1:
	mov dword [adressof1], eax
	jmp continue

foundn:
	mov dword [adressoflast], eax
	jmp continue

found:
	xor ecx, ecx
	; prima pereche e formata din 1 si 2
	mov dword [small], 1
	mov dword [nextsmall], 2
	
	xor eax, eax
	mov eax, dword [ebp + 12]
	
	; counterul pentru loopul in care gasesc perechile de elemente
	; si le retin adresele
	xor esi, esi 

findelem:
	xor edi, edi
	mov edi, dword [small]
	cmp dword [eax], edi
	je smallfound

	xor edi, edi
	mov edi, dword [nextsmall]
	cmp dword [eax], edi
	je nextsmallfound

loop1:
	; caut elementele parcurgand tot vectorul
	add eax, 8
	add ecx, 1
	cmp ecx, dword [nodesnr]
	jne findelem
	cmp ecx, dword [nodesnr]
	je next

smallfound:
	xor edi, edi
	mov edi, eax
	mov dword [adressofsmall], 0
	mov dword [adressofsmall], edi
	jmp loop1

nextsmallfound:
	xor edi, edi
	mov edi, eax
	mov dword [adressofnextsmall], 0
	mov dword [adressofnextsmall], edi
	jmp loop1

next:
	; reinitializez counterul si eax pentru a 
	; reparcurge vectorul de elemente
	xor ecx, ecx
	xor eax, eax
	mov eax, [ebp + 12]

	; setez pointerul de la adresa elementului mai mic
	; catre urmatorul
	xor edi, edi
	mov edi, dword [adressofsmall]
	xor edx, edx
	mov edx, dword [adressofnextsmall]
	mov dword [edi + 4], edx 

	; trec la urmatoarea pereche 
	add dword [small], 1
	add dword [nextsmall], 1

	add esi, 1
	cmp esi, dword [counter]
	jne findelem

lastelem:
	; setez pointerul ultimului element pe 0
	xor edi, edi
	mov edi, dword [adressoflast]
	mov dword [edi + 4], 0

	; punem in eax adresa primului element
	; eax va fi returnat de catre functie
	xor eax, eax
	mov eax, dword [adressof1]

	leave
	ret

