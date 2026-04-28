# 68000 to x86_64 Assembly Conversion

## what is this project

i converted a 68000 assembly program (made for EASy68k) into x86_64 assembly that runs on linux. the original program was written by philip bourke and it takes two numbers, adds them together, and keeps a running total. it does this 3 times in a loop.

the original 68k code had security vulnerabilities marked in the comments (no input validation, no bounds checking etc) so i fixed those in my x86_64 version.

## how to build and run

you need linux (or WSL) with nasm and gcc installed.

```bash
cd Calculator

# build it
make

# run it
./calculator

# run the tests
make test

# clean up
make clean
```

## how it works

the program does this:
1. loops 3 times
2. each loop asks for 2 numbers
3. adds them using the register_adder function
4. prints the sum
5. adds the sum to a running total
6. after 3 loops, prints the final total

## what i changed from the 68k version

### no more TRAP #15
the 68k version used TRAP #15 for everything (printing, reading input). x86_64 doesnt have that so i used the C library functions printf and scanf instead. i declared them as extern and linked with gcc.

### register differences
68k has data registers (D0-D7) and address registers (A0-A6). x86_64 just has general purpose registers (rax, rbx, rcx etc). so i had to figure out which registers to use for what.

for calling C functions theres a specific order:
- 1st argument goes in RDI
- 2nd argument goes in RSI
- return value comes back in RAX

### stack alignment
this was the biggest headache. x86_64 requires the stack to be 16-byte aligned before calling any C function. if its not aligned, the program crashes with a segfault. the 68k didnt care about this at all.

i used `and rsp, -16` to force alignment and `push rbx` in helper functions to keep things lined up.

### callee-saved registers
in x86_64, if you use rbx, r12, r13, r14, or r15 in your function, you HAVE to save them (push) at the start and restore them (pop) at the end. the calling function expects them to be unchanged. i used these registers to store the running sum, loop counter, and temporary values that need to survive across function calls.

### SIMHALT vs ret
the 68k used SIMHALT to stop the program. in x86_64 i just return from main with `xor eax, eax` and `ret` which gives exit code 0.

## security fixes

the original 68k code had comments saying "Vulnerable!" in several places. here's what i fixed:

### input validation (the big one)
the 68k code just reads numbers with no checking at all. if someone types 99999999999999999 it overflows and gives garbage results. my version:

- uses %ld (64-bit) to read the number so it doesnt overflow during reading
- checks the number is between -999999 and 999999
- if its out of range, prints an error and asks again
- if someone types letters instead of numbers, catches that too and asks again

### no hardcoded memory addresses
the 68k code uses ORG $1000 to put code at a specific memory address. in x86_64 i use proper sections (.data, .bss, .text) and let the OS handle memory layout. this is safer because of ASLR (address space layout randomisation) which randomises where things are loaded in memory.

### buffer overflow protection
i allocated 16 bytes for the input buffer but scanf with %ld only writes 8 bytes max. so theres no risk of overflowing the buffer into the stack.

## testing

i wrote a C test file that tests the register_adder function. it checks:
- basic addition (2+3=5, 0+0=0)
- negative numbers (-1+-1=-2, -5+5=0)
- commutative property (a+b should equal b+a)
- adding zero doesnt change the number
- boundary values at the edges of our range

run them with `make test`.

## files

```
Calculator/
├── src/
│   ├── calculator.asm        # main program
│   └── register_adder.asm    # just the adder function (for testing)
├── tests/
│   └── test_calculator.c     # C test file
├── Makefile
└── README.md
```

## tools used

- NASM (assembler)
- GCC (linker)
- GDB (debugger - used this a LOT for finding segfaults)
- linux terminal
