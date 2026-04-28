ASM = nasm
CC = gcc
ASMFLAGS = -f elf64 -g -F dwarf
CFLAGS = -no-pie -g

all: armada

armada: src/armada.o
	$(CC) $(CFLAGS) -o armada src/armada.o

src/armada.o: src/armada.asm
	$(ASM) $(ASMFLAGS) -o src/armada.o src/armada.asm

test: tests/test_armada.c src/armada.o
	$(CC) $(CFLAGS) -o test_armada tests/test_armada.c src/armada.o

clean: 
	rm -f src/*.o armada test_armada

.PHONY: all clean test
