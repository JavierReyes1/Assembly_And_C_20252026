init:
	lea rdi, [BOARD]
	xor al, al		;since both inputs are the same, the result will be 0
	mov rxc, 25		;25 cells to clear
	rep stosb 		;fill [RDI] with AL, 25 times. stosb mean "store byte". It takes the value in al and writes it to the memory address pointed to by rdi
								;Then automatically increments rdi by 1. rep means repeat, so it will repeat the instruction that follows it rxc times
	;Place ship 1
	lea rdi, [BOARD]
	movzx eax, byte [SHIP1_ROW]   ;movzx (move with zero-extend) 
	imul eax, 5										;ROW * 5
	movzx ecx, byte [SHIP1_COL]
	add eax, exc
	mov byte [rdi + rax], 1 ; BOARD[offset] = 1 (SHIP)

	;Place ship 2
	lea rdi, [BOARD]
	movzx eax, byte [SHIP2_ROW]
	imul eax, 5
	movzx ecx, byte [SHIP2_COL]
	add eax, ecx
	mov byte [rdi+rax], 1

section .data
	CRLF:						db 0x0D, 0x0A, 0
	WELCOME_MSG:		db '************************************************************', 0x0D, 0x0A
									db '		SPAIN vs ENGLAND - NAVAL BATTLE 1588', 0x0D, 0x0A
									db '	The Spanish Armada faces the English Fleet', 0x0D, 0x0A
									db '************************************************************', 0x0D, 0x0A, 0

	SHIP1_ROW:			db 0
	SHIP1_COL:			db 0
	
	SHIP2_ROW:			db 2
	SHIP2_COL:			db 3
	
	SHIP3_ROW:			db 4
	SHIP3_COL:			db 1

	SHIPS_LEFT:			db 3
	SHOTS_LEFT:			db 10
	SHOT_VALID:			db 1

	fmt_int: db '%d', 0
	fmt_scan: db '%d', 0

section .bss
	BOARD:					resb 25
	SHOT_ROW: 			resb 1
	SHOT_COL:				resb 1
	INPUT_BUF:			resb 16 	; buffer for reading user input
	
extern printf
extern scanf
extern putchar

section .text
global main									; entry point when linking with gcc

; print_string: print null-terminated string pointed to by rdi
print_string:
	xor	rax, rax							; 0 float args for printf
	call printf
	ret

; print_number: print integer in edi
print_number:
	lea rdi, [fmt_int]
	mov esi, edi
	xor rax, rax
	call printf
	ret

; read_number: reads integer, returns in eax
read_number:
	lea rdi, [fmt_scan]
	lea rsi, [INPUT_BUF]
	xor rax, rax
	call scanf
	movzx eax, byte [INPUT_BUF]
	ret


