section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string

cpu_manufact_id:
	enter 	0, 0

	; Folosim instructiunea cpuid cu eax avand valoarea 0
	; Rezultatul se va salva in ebx, edx, ecx
	mov eax, 0
	cpuid

	; Punem in eax adresa in care va trebui sa punem rezultatul
	xor eax, eax
	mov eax, [ebp + 8]
	
	; Scriem rezultatul
	mov dword [eax], ebx;
	add eax, 4
	mov dword [eax], edx;
	add eax, 4
	mov dword [eax], ecx;

	leave
	ret

;; void features(int *apic, int *rdrand, int *mpx, int *svm)
;
;  checks whether apic, rdrand and mpx / svm are supported by the CPU
;  MPX should be checked only for Intel CPUs; otherwise, the mpx variable
;  should have the value -1
;  SVM should be checked only for AMD CPUs; otherwise, the svm variable
;  should have the value -1

features:
	enter 	0, 0
	
	; Folosim tot instructiunea cpuid, insa de data aceasta pentru
	; eax avand valoarea 1
	mov eax, 1
	cpuid

APIC:
	; In ecx pe pozitia 21 se afla APIC

	; Il transform pe ebx astfel incat sa aiba 1 pe pozitia 21
	xor ebx, ebx
	mov ebx, 1
	shl ebx, 21

	;Verificam daca APIC exista
	and ebx, ecx
	cmp ebx, 0
	je APICnotfound

APICfound:
	; Daca avem initializam cu 1
	xor esi, esi
	mov esi, dword [ebp + 8]
	mov dword [esi], 1
	jmp APICfinal

APICnotfound:
	; Daca nu avem initializam cu 0
	xor esi, esi
	mov esi, dword [ebp + 8]
	mov dword [esi], 0

APICfinal:


rdrand:
	; In ecx pe pozitia 30 se afla rdrand

	; Il transform pe ebx astfel incat sa aiba 1 pe pozitia 30
	xor ebx, ebx
	mov ebx, 1
	shl ebx, 30

	; Verificam daca rdrand exista
	and ebx, ecx
	cmp ebx, 0
	jne rdrandfound

rdrandnotnotfound:
	; Daca nu avem initializam cu 0
	xor esi, esi
	mov esi, dword [ebp + 12]
	mov dword [esi], 0
	jmp finalrdrand

rdrandfound:
	; Daca avem initializam cu 1
	xor esi, esi
	mov esi, dword [ebp + 12]
	mov dword [esi], 1

finalrdrand:

MPX:
	; In ecx pe pozitia 14 se afla rdrand

	; Il transform pe ebx astfel incat sa aiba 1 pe pozitia 14
	xor ebx, ebx
	mov ebx, 1
	shl ebx, 14

	; Verificam daca MPX exista
	and ebx, ecx
	cmp ebx, 0
	je MPXnotfound

MPXfound:
	; Daca avem initializam cu 1
	xor esi, esi
	mov esi, dword [ebp + 16]
	mov dword [esi], 1
	jmp finalMPX

MPXnotfound:
	; Daca nu avem initializam cu 0
	xor esi, esi
	mov esi, dword [ebp + 16]
	mov dword [esi], 0

finalMPX:
		
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters

l2_cache_info:
	enter 	0, 0
	
	; Pentru a obtine informatiile despre cache punem in 
	; eax valoarea 4, iar pentru ca avem nevoie explicit de
	; ceea ce se afla pe nivelul 2 punem aceasta valoare in ecx
	mov eax, 4
	mov ecx, 2
	cpuid

	; Ultimii 12 biti din ebx vor reprezenta dimensiunea liniei
	; de care avem nevoie asa ca mutam aceasta adresa in esi
	xor esi, esi
	mov esi, 0x00000fff
	and esi, ebx
	add esi, 1

	; Returnam rezultatul obtinut
	xor eax, eax
	mov eax, dword [ebp + 8]
	mov dword [eax], esi

	leave
	ret
