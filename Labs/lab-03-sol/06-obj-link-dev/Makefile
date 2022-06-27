CFLAGS = -Wall -g

.DEFAULT_GOAL: all

.PHONY: all clean

all: main

main: main.o shop.o

main.o: main.c

shop.o: shop.c

clean:
	-rm -f main main.o shop.o
	-rm -f *~
