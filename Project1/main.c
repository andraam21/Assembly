#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include "structs.h"
#define LINIE 256
#define ZECE 10

void printare(void *arr, int len)
{
	int i = 0;
	int dim;
	while (i < len)
	{
		if (*(char *)(arr + i) == '1')
		{
			printf("Tipul %c\n", *(char *)(arr + i));
			dim = *(int *)(arr + 1 + i);
			printf("%s pentru ", (char *)(arr + sizeof(head) + i));
			printf("%s\n", (char *)(arr + sizeof(head) + strlen(arr + sizeof(head) + i) + 2 * sizeof(int8_t) + 1 + i));
			printf("%" PRId8 "\n", *(int8_t *)(arr + sizeof(head) + strlen(arr + sizeof(head) + i) + 1 + i));
			printf("%" PRId8 "\n", *(int8_t *)(arr + sizeof(head) + strlen(arr + sizeof(head) + i) + sizeof(int8_t) + 1 + i));
			printf("\n");
		}
		if (*(char *)(arr + i) == '2')
		{
			printf("Tipul %c\n", *(char *)(arr + i));
			dim = *(int *)(arr + 1 + i);
			printf("%s pentru ", (char *)(arr + sizeof(head) + i));
			printf("%s\n", (char *)(arr + sizeof(head) + strlen(arr + sizeof(head) + i) + sizeof(int16_t) + sizeof(int32_t) + 1 + i));
			printf("%" PRId16 "\n", *(int16_t *)(arr + sizeof(head) + strlen(arr + sizeof(head) + i) + 1 + i));
			printf("%" PRId32 "\n", *(int32_t *)(arr + sizeof(head) + strlen(arr + sizeof(head) + i) + sizeof(int16_t) + 1 + i));
			printf("\n");
		}
		if (*(char *)(arr + i) == '3')
		{
			printf("Tipul %c\n", *(char *)(arr + i));
			dim = *(int *)(arr + 1 + i);
			printf("%s pentru ", (char *)(arr + sizeof(head) + i));
			printf("%s\n", (char *)(arr + sizeof(head) + strlen(arr + sizeof(head) + i) + 2 * sizeof(int32_t) + 1 + i));
			printf("%" PRId32 "\n", *(int32_t *)(arr + sizeof(head) + strlen(arr + sizeof(head) + i) + 1 + i));
			printf("%" PRId32 "\n", *(int32_t *)(arr + sizeof(head) + strlen(arr + sizeof(head) + i) + sizeof(int32_t) + 1 + i));
			printf("\n");
		}
		i = i + sizeof(head) + dim;
	}
}

int add_last(void **arr, int *len, data_structure *data)
{
	//  realocam memoria pentru vector cu lungimea lui, adaugand si lungimea structurii
	*arr = realloc(*arr, *len + sizeof(head) + data->header->len);
	//  mutam pe rand elementele din header si din data
	memmove((char *)(*arr) + *len, &data->header->type, sizeof(char));
	memmove((char *)(*arr) + *len + sizeof(char), &data->header->len, sizeof(int));
	memmove((char *)(*arr) + *len + sizeof(head), data->data, data->header->len);
	*len = *len + data->header->len + sizeof(head);
	return 0;
}

int add_at(void **arr, int *len, data_structure *data, int index)
{
	//  daca indexul este prea mare se adauga elementul la final
	if (index > *len)
	{
		add_last(&(*arr), &(*len), data);
		return 0;
	}
	int counter = 0;
	int dimtotala;
	//  calculam dimensiunea elementului ce trebuie adaugat
	//  counter va fi indexul la care adaugam (in bytes)
	for (int i = 0; i < index; i++)
	{
		dimtotala = sizeof(head) + *(int *)(*arr + counter + 1);
		counter = counter + dimtotala;
	}
	//  alocam un vector auxiliar in care mutam tot ce se afla dupa counter
	//  realocam arr cu valoarea lui counter, astfel incat sa ramanem cu prima parte din vector
	int dimaux = *len - counter;
	void *aux = malloc(dimaux);
	memmove((char *)aux, (*arr + counter), dimaux);
	*arr = realloc(*arr, counter);
	*len = counter; //  noului vector arr ii adaugam la final elementul
	add_last(&(*arr), &(*len), data);
	//  realocam din nou arr pentru a muta inapoi elementele retinute in aux
	*arr = realloc(*arr, *len + dimaux);
	memmove((char *)(*arr + *len), aux, dimaux);
	*len = *len + dimaux;
	free(aux);
	return 0;
}

void find(void *data_block, int len, int index)
{
	//  gasim inceputul si finalul secventei care trebuie printate (counter si finalcounter)
	int counter = 0;
	int dimtotala;
	for (int i = 0; i < index; i++)
	{
		dimtotala = sizeof(head) + *(int *)(data_block + counter + 1);
		counter = counter + dimtotala;
	}
	int dim = *(int *)(data_block + counter + 1);
	int finalcounter = counter + sizeof(head) + dim;
	//  folosim functia print pe acea secventa din arr
	printare((char *)(data_block + counter), finalcounter - counter);
}

int delete_at(void **arr, int *len, int index)
{
	//  gasim inceputul si finalul secventei ce trebuie sterse (counter si finalcounter)
	int counter = 0;
	int dimtotala;
	for (int i = 0; i < index; i++)
	{
		dimtotala = sizeof(head) + *(int *)(*arr + counter + 1);
		counter = counter + dimtotala;
	}
	int dim = *(int *)(*arr + counter + 1);
	int finalcounter = counter + sizeof(head) + dim;
	//  daca secventa e la final realocam vectorul cu o marime mai mica
	//  in acest mod se va sterge ultima parte din arr
	if (finalcounter == *len)
	{
		*arr = realloc(*arr, counter);
		*len = counter;
	}
	else
	{
		//  daca secventa este in interiorul vectorului mutam elementele de dupa structura in locul in
		//  care aceasta incepe, dupa care realocam arr pentru a elibera memoria ce va ramane nefolosita (de la finalul vectorului)
		memmove((char *)(*arr + counter), (char *)(*arr + finalcounter), *len - finalcounter);
		*len = *len - (finalcounter - counter);
		*arr = realloc(*arr, *len);
	}
	return 0;
}

int main()
{
	//  buffer pentru a retine comanda si parametrii acesteia
	char comanda[LINIE];
	char **parametrii = (char **)malloc(ZECE * sizeof(char *));
	for (int i = 0; i < 10; i++)
	{
		*(parametrii + i) = (char *)malloc(LINIE * sizeof(char));
	}
	int m = 0;
	char *exit = "exit\n";
	char *insert = "insert";
	char *print = "print\n";
	char *find1 = "find";
	char *insertat = "insert_at";
	char *delete = "delete_at";
	void *arr = NULL;
	int len = 0;

	while (fgets(comanda, sizeof(comanda), stdin) && strcmp(comanda, exit) != 0)
	{
		m = 0;
		char *token = strtok(comanda, " ");
		while (token != NULL)
		{
			strcpy(*(parametrii + m), token);
			m++;
			token = strtok(NULL, " \n");
		}
		if (strcmp(*parametrii, insert) == 0)
		{
			//  retinem din buffer elementele ce trebuie adaugate in data
			unsigned char tip = *(*(parametrii + 1) + 0);
			char *nume1 = *(parametrii + 2);
			int suma1prim = atoi(*(parametrii + 3));
			int suma2prim = atoi(*(parametrii + 4));
			char *nume2 = *(parametrii + 5);
			data_structure *element;
			//  in funtie de tipul structurii adaugam pe rand elementele in functie de size-ul acestora
			if (tip == '1')
			{
				int8_t suma1 = (int8_t)suma1prim;
				int8_t suma2 = (int8_t)suma2prim;
				element = malloc(sizeof(data_structure));
				element->header = malloc(sizeof(head));
				element->header->type = tip;
				element->header->len = 2 + strlen(nume1) + sizeof(suma1) + sizeof(suma2) + strlen(nume2);
				element->data = (char *)malloc(element->header->len);
				strncpy((char *)element->data, nume1, strlen(nume1));
				memmove((char *)element->data + strlen(nume1) + 1, &suma1, sizeof(int8_t));
				memmove((char *)element->data + strlen(nume1) + sizeof(int8_t) + 1, &suma2, sizeof(int8_t));
				strncpy((char *)element->data + strlen(nume1) + 2 * sizeof(int8_t) + 1, nume2, strlen(nume2));
			}

			if (tip == '2')
			{
				int16_t suma1 = (int16_t)suma1prim;
				int32_t suma2 = (int32_t)suma2prim;
				element = malloc(sizeof(data_structure));
				element->header = malloc(sizeof(head));
				element->header->type = tip;
				element->header->len = 2 + strlen(nume1) + sizeof(suma1) + sizeof(suma2) + strlen(nume2);
				element->data = (char *)malloc(element->header->len);
				strncpy((char *)element->data, nume1, strlen(nume1));
				memmove((char *)element->data + strlen(nume1) + 1, &suma1, sizeof(int16_t));
				memmove((char *)element->data + strlen(nume1) + sizeof(int16_t) + 1, &suma2, sizeof(int32_t));
				strncpy((char *)element->data + strlen(nume1) + sizeof(int16_t) + sizeof(int32_t) + 1, nume2, strlen(nume2));
			}
			if (tip == '3')
			{
				int32_t suma1 = (int32_t)suma1prim;
				int32_t suma2 = (int32_t)suma2prim;
				element = malloc(sizeof(data_structure));
				element->header = malloc(sizeof(head));
				element->header->type = tip;
				element->header->len = 2 + strlen(nume1) + sizeof(suma1) + sizeof(suma2) + strlen(nume2);
				element->data = (char *)malloc(element->header->len);
				strncpy((char *)element->data, nume1, strlen(nume1));
				memmove((char *)element->data + strlen(nume1) + 1, &suma1, sizeof(int32_t));
				memmove((char *)element->data + strlen(nume1) + sizeof(int32_t) + 1, &suma2, sizeof(int32_t));
				strncpy((char *)element->data + strlen(nume1) + 2 * sizeof(int32_t) + 1, nume2, strlen(nume2));
			}
			add_last(&arr, &len, element);
			free(element->header);
			free(element->data);
			free(element);
		}
		if (strcmp(*parametrii, insertat) == 0)
		{
			int index = atoi(*(parametrii + 1));
			unsigned char tip = *(*(parametrii + 2) + 0);
			char *nume1 = *(parametrii + 3);
			int suma1prim = atoi(*(parametrii + 4));
			int suma2prim = atoi(*(parametrii + 5));
			char *nume2 = *(parametrii + 6);
			data_structure *element;

			if (tip == '1')
			{
				int8_t suma1 = (int8_t)suma1prim;
				int8_t suma2 = (int8_t)suma2prim;
				element = malloc(sizeof(data_structure));
				element->header = malloc(sizeof(head));
				element->header->type = tip;
				element->header->len = 2 + strlen(nume1) + sizeof(suma1) + sizeof(suma2) + strlen(nume2);
				element->data = (char *)malloc(element->header->len);
				strncpy((char *)element->data, nume1, strlen(nume1));
				memmove((char *)element->data + strlen(nume1) + 1, &suma1, sizeof(int8_t));
				memmove((char *)element->data + strlen(nume1) + sizeof(int8_t) + 1, &suma2, sizeof(int8_t));
				strncpy((char *)element->data + strlen(nume1) + 2 * sizeof(int8_t) + 1, nume2, strlen(nume2));
			}

			if (tip == '2')
			{
				int16_t suma1 = (int16_t)suma1prim;
				int32_t suma2 = (int32_t)suma2prim;
				element = malloc(sizeof(data_structure));
				element->header = malloc(sizeof(head));
				element->header->type = tip;
				element->header->len = 2 + strlen(nume1) + sizeof(suma1) + sizeof(suma2) + strlen(nume2);
				element->data = (char *)malloc(element->header->len);
				strncpy((char *)element->data, nume1, strlen(nume1));
				memmove((char *)element->data + strlen(nume1) + 1, &suma1, sizeof(int16_t));
				memmove((char *)element->data + strlen(nume1) + sizeof(int16_t) + 1, &suma2, sizeof(int32_t));
				strncpy((char *)element->data + strlen(nume1) + sizeof(int16_t) + sizeof(int32_t) + 1, nume2, strlen(nume2));
			}
			if (tip == '3')
			{
				int32_t suma1 = (int32_t)suma1prim;
				int32_t suma2 = (int32_t)suma2prim;
				element = malloc(sizeof(data_structure));
				element->header = malloc(sizeof(head));
				element->header->type = tip;
				element->header->len = 2 + strlen(nume1) + sizeof(suma1) + sizeof(suma2) + strlen(nume2);
				element->data = (char *)malloc(element->header->len);
				strncpy((char *)element->data, nume1, strlen(nume1));
				memmove((char *)element->data + strlen(nume1) + 1, &suma1, sizeof(int32_t));
				memmove((char *)element->data + strlen(nume1) + sizeof(int32_t) + 1, &suma2, sizeof(int32_t));
				strncpy((char *)element->data + strlen(nume1) + 2 * sizeof(int32_t) + 1, nume2, strlen(nume2));
			}

			add_at(&arr, &len, element, index);
			free(element->data);
			free(element->header);
			free(element);
		}
		if (strcmp(*parametrii, find1) == 0)
		{
			int index = atoi(*(parametrii + 1));
			find(arr, len, index);
		}
		if (strcmp(*parametrii, print) == 0)
		{
			printare(arr, len);
		}
		if (strcmp(*parametrii, delete) == 0)
		{
			int index = atoi(*(parametrii + 1));
			delete_at(&arr, &len, index);
		}
	}
	free(arr);
	for (int i = 0; i < 10; i++)
	{
		free(*(parametrii + i));
	}
	free(parametrii);
	return 0;
}
