default rel
section .data
    PROMPT:         db 'Enter number: ', 0
    RESULT:         db 'The sum is: ', 0
    FINAL_RESULT:   db 'Final sum is: ', 0
    CRLF:           db 0x0D, 0x0A, 0
    fmt_int:        db '%d', 0
    fmt_scan:       db '%ld', 0
    fmt_clear:      db '%*s', 0
    OVERFLOW_MSG:   db 'ERROR: Number too large! Enter between -999999 and 999999: ', 0
    SCAN_ERR_MSG:   db 'ERROR: Invalid input! Please enter a number: ', 0
    MIN_VAL:        equ -999999
    MAX_VAL:        equ  999999

section .bss
    INPUT_BUF:      resb 16

extern printf
extern scanf
extern exit

section .text
global main

print_string:
    push    rbx                 ; align stack (1 push + ret = 2 = even)
    xor     rax, rax
    call    printf
    pop     rbx
    ret

print_number:
    push    rbx
    mov     esi, edi
    lea     rdi, [fmt_int]
    xor     rax, rax
    call    printf
    pop     rbx
    ret

print_newline:
    push    rbx
    lea     rdi, [CRLF]
    xor     rax, rax
    call    printf
    pop     rbx
    ret

read_number:
    push    rbx

.read_again:
    lea     rdi, [fmt_scan]
    lea     rsi, [INPUT_BUF]
    xor     rax, rax
    call    scanf

    cmp     eax, 1
    jne     .scan_error

    mov     rax, [INPUT_BUF]        ; read full 64-bit value

    cmp     rax, MIN_VAL
    jl      .overflow_error
    cmp     rax, MAX_VAL
    jg      .overflow_error

    mov     eax, eax                ; truncate to 32-bit (safe now, it's in range)
    pop     rbx
    ret

.overflow_error:
    lea     rdi, [OVERFLOW_MSG]
    xor     rax, rax
    call    printf
    jmp     .read_again

.scan_error:
    lea     rdi, [fmt_clear]
    lea     rsi, [INPUT_BUF]
    xor     rax, rax
    call    scanf

    lea     rdi, [SCAN_ERR_MSG]
    xor     rax, rax
    call    printf
    jmp     .read_again

register_adder:
    mov     eax, edi
    add     eax, esi
    ret

main:
    push    rbp
    mov     rbp, rsp
    and     rsp, -16            ; FORCE 16-byte alignment
    sub     rsp, 32             ; reserve space for local use

    push    rbx
    push    r12
    push    r13
    push    r14

    xor     ebx, ebx
    mov     r12d, 3

.game_loop:
    lea     rdi, [PROMPT]
    call    print_string
    call    read_number
    mov     r13d, eax

    lea     rdi, [PROMPT]
    call    print_string
    call    read_number
    mov     esi, eax
    mov     edi, r13d

    call    register_adder
    mov     r14d, eax

    add     ebx, r14d

    lea     rdi, [RESULT]
    call    print_string
    mov     edi, r14d
    call    print_number
    call    print_newline

    dec     r12d
    jnz     .game_loop

    lea     rdi, [FINAL_RESULT]
    call    print_string
    mov     edi, ebx
    call    print_number
    call    print_newline

    pop     r14
    pop     r13
    pop     r12
    pop     rbx

    mov     rsp, rbp            ; restore original rsp
    pop     rbp
    xor     eax, eax
    ret
