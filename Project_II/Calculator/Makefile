ASM = nasm
CC = gcc
ASMFLAGS = -f elf64 -g -F dwarf
CFLAGS = -no-pie -g

all: calculator

calculator: src/calculator.o
	$(CC) $(CFLAGS) -o calculator src/calculator.o

src/calculator.o: src/calculator.asm
	$(ASM) $(ASMFLAGS) -o src/calculator.o src/calculator.asm

test: tests/test_calculator.c src/register_adder.asm
	$(ASM) $(ASMFLAGS) -o src/register_adder.o src/register_adder.asm
	$(CC) $(CFLAGS) -o test_calculator tests/test_calculator.c src/register_adder.o
	./test_calculator

clean:
	rm -f src/*.o calculator test_calculator

.PHONY: all clean test
