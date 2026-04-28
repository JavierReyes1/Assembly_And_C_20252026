init:
	lea rdi, [BOARD]
	xor al, al		;since both inputs are the same, the result will be 0
	mov rcx, 25		;25 cells to clear
	rep stosb 		;fill [RDI] with AL, 25 times. stosb mean "store byte". It takes the value in al and writes it to the memory address pointed to by rdi
								;Then automatically increments rdi by 1. rep means repeat, so it will repeat the instruction that follows it rxc times
	;Place ship 1
	lea rdi, [BOARD]
	movzx eax, byte [SHIP1_ROW]   ;movzx (move with zero-extend) 
	imul eax, 5										;ROW * 5
	movzx ecx, byte [SHIP1_COL]
	add eax, ecx
	mov byte [rdi + rax], 1 ; BOARD[offset] = 1 (SHIP)

	;Place ship 2
	lea rdi, [BOARD]
	movzx eax, byte [SHIP2_ROW]
	imul eax, 5
	movzx ecx, byte [SHIP2_COL]
	add eax, ecx
	mov byte [rdi+rax], 1
	
	;Place ship 3
	lea rdi, [BOARD]
	movzx eax, byte [SHIP3_ROW]
	imul eax, 5
	movzx ecx, byte [SHIP3_COL]
	add eax, ecx
	mov byte [rdi+rax], 1

	ret

;Draw the board: print the 5x5 grid
draw_board:
	push rbx
	push r12
	push r13
	push r14

	;print column header "1 2 3 4 5"
	lea rdi, [GRID_HEADER]
	call print_string
	call print_newline

	lea r12, [BORAD]			;r12 = pointer to board
	mov r13b, 0						;r12 = row counter (0-4)

.row_loop:
	;print row number (1-5)
	movzx edi, r13b
	add 	edi, 1 		;convert 0-4 to 1-5
	call print_number

	mov r14b, 0 		;r14 = col counter 0-4

.col_loop:
	movzx eax, r13b
	imul  eax, 5
	movzx ecx, r14b
	add   eax, ecx

.print_ocean:
	lea		rdi, [CELL_OCEAN]
	call print_string
	jmp		.next_col
	
.print_hit:
	lea  rdi, [CELL_HIT]
	call 	print_string
	jmp   .next_col

.print_miss:
	lea  rdi, [CELL_MISS]
	call print_string

.next_col:
	inc		r14b 		;col++
	cmp   r14b, 5
	jl 		.col_loop		;repeat for 5 colums

	call 	print_newline 	;end of row
	inc 	r13b		;row++
	cmp 	r13b, 5
	jl 		.row_loop

	pop 	r14			;restore callee-saved registers
	pop   r13
	pop   r12
	pop   rbx
	ret

;----------------------------------
;----------COLLISION----------------
;----------------------------------

collision:
	push 	rbx

	lea		rbx, [BOARD] ;RBX = board pointer

	;calculate offset = (row*5) + col
	movzx	eax, byte [SHOT_ROW]
	imul  eax, 5

	movzx ecx, byte [SHOT_COL]
	add 	eax, ecx 		;eax = offset

	movzx edx, byte[rbx + rax] ;edx = cell valua at that position

	mov  byte [SHOT_VALID], 1  ;assume valid shot

	cmp  dl, 2 							;already a hit?
	je	.already_shot 		
	cmp dl, 3							;already a miss?
	je 	.already_shot

	cmp dl, 1 		;is it a ship?
	je	.real_hit
	jmp .real_miss ;otherwise it's ocean

.already_shot:
	mov		byte[SHOT_VALID], 0 ;mark as invalid
	lea		rdi, [ALREADY_MSG]
	call 	print_string
	add 	byte [SHOT_LEFT],1 ;give the shot back
	jmp		.collision_done

.real_hit:
	mov 	byte [rbx + rax], 2  ;mark cell as HIT 
	sub 	byte [SHIPS_LEFT], 1 ; one less ship
	lea   rdi, [HIT_MSG]
	call print_string
	jmp		.collision_done
	
.real_miss:
	mov 	byte[rbx + rax], 3 ;mark cell as miss
	lea 	rdi, [MISS_MSG]
	call 	print_string

.collision_done:
	pop		rbx
	ret


;----------------------------------
;----------POTIONS-----------------
;----------------------------------

potions:
	call print_newline
	lea 	rdi, [POTIONS_MSG]
	call print_string
	call read_number 	;result in eax

	cmp 	eax, 1 		;is it < 1?
	jl 		.row_invalid
	cmp 	eax, 5 		;is it > 5?
	jg 		.row_invalid

	sub 	eax, 1 		;convert 1-5 to 0-4 for array index 
	mov 	byte[SHOT_ROW], al ; save it 
	sub 	byte[SHOTS_LEFT], 1
	ret 

.row_invalid:
	lea 	rdi, [INVALID_MSG]
	call print_string
	jmp potions 		;ask again (loop back)



;----------------------------------
;----------WEAPONS-----------------
; ask player for col 1-5, validates input
;----------------------------------

weapons:
	call print_newline
	lea 	rdi, [WEAPONS_MSG]
	call print_string
	call read_number 		;result in eax

	cmp 	eax, 1
	jl 		.col_invalid
	cmp 	eax, 5
	jg 		.col_invalid

	sub 	eax, 1 		;conver 1-5 to 0-4
	mov 	byte [SHOT_COL], al
	ret

.col_invalid:
	lea 	rdi, [INVALID_MSG]
	call print_string
	jmp 	weapons 		;ask again



;----------------------------------
;- INPUT: calls both potions and weapons
;----------------------------------

input: 
	call print_newline
	lea 	rdi, [GAMEPLAY_MSG]
	call 	print_string
	call potions
	call print_newline
	call weapons
	ret

;----------------------------------
;CHECK_WIN did the player sink all ships?
;----------------------------------

check_win:
	cmp 	byte[SHIPS_LEFT], 0
	je 		.player_wins
	ret

.player_wins:
	call 		print_newline
	call 		decorate
	lea			rdi, [WIN_MSG]
	call 		print_string
	call 		decorate
	call 		print_newline
	jmp 		end_game


;----------------------------------
; CHECK_LOSE did the player run out of shots?
;----------------------------------



;----------------------------------
;----------------------------------
;----------------------------------

section .data
	CRLF:						db 0x0D, 0x0A, 0
	WELCOME_MSG:		db '************************************************************', 0x0D, 0x0A
									db '		SPAIN vs ENGLAND - NAVAL BATTLE 1588', 0x0D, 0x0A
									db '	The Spanish Armada faces the English Fleet', 0x0D, 0x0A
									db '************************************************************', 0x0D, 0x0A, 0
	ALREADY_MSG:    db 'You already fired there! Shot returned.', 0
	HIT_MSG:        db '*** DIRECT HIT! A ship has been struck! ***', 0
	MISS_MSG:       db '... Cannonball splashes into the sea. MISS!', 0

	POTIONS_MSG:    db 'Enter ROW to fire (1-5): ', 0
	WEAPONS_MSG:    db 'Enter COL to fire (1-5): ', 0
	GAMEPLAY_MSG:   db 'Enter coordinates to fire cannons!', 0
	INVALID_MSG:    db 'INVALID! Enter a number between 1 and 5: ', 0

	SHIP1_ROW:			db 0
	SHIP1_COL:			db 0
	
	SHIP2_ROW:			db 2
	SHIP2_COL:			db 3
	
	SHIP3_ROW:			db 4
	SHIP3_COL:			db 1

	SHIPS_LEFT:			db 3
	SHOTS_LEFT:			db 10
	SHOT_VALID:			db 1
	
	GRID_HEADER:		db ' 1  2  3  4  5 ',0
	ROW_NUMS: 			db '1','2','3','4','5'
	CELL_OCEAN:			db '[~]',0
	CELL_HIT:				db '[X]',0
	CELL_MISS:			db '[0]',0


	fmt_int: db '%d', 0
	fmt_scan: db '%d', 0

;----------------------------------
;----------------------------------
;----------------------------------
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

;print new line
print_newline:
	lea rdi, [CRLF]
	call print_string
	ret

; read_number: reads integer, returns in eax
read_number:
	lea rdi, [fmt_scan]
	lea rsi, [INPUT_BUF]
	xor rax, rax
	call scanf
	mov eax, byte [INPUT_BUF]
	ret


