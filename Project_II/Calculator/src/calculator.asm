default rel

section .data
    PROMPT:         db 'Enter number: ', 0
    RESULT:         db 'The sum is: ', 0
    FINAL_RESULT:   db 'Final sum is: ', 0
    CRLF:           db 0x0D, 0x0A, 0
    fmt_int:        db '%d', 0
    fmt_scan:       db '%d', 0

section .bss
    INPUT_BUF:      resb 16

extern printf
extern scanf
extern exit

section .text
global main

;-------------------------------------------------------
; HELPER: print null-terminated string in RDI
;-------------------------------------------------------
print_string:
    sub     rsp, 8
    xor     rax, rax
    call    printf
    add     rsp, 8
    ret

;-------------------------------------------------------
; HELPER: print integer in EDI
;-------------------------------------------------------
print_number:
    sub     rsp, 8
    mov     esi, edi
    lea     rdi, [fmt_int]
    xor     rax, rax
    call    printf
    add     rsp, 8
    ret

;-------------------------------------------------------
; HELPER: print newline
;-------------------------------------------------------
print_newline:
    sub     rsp, 8
    lea     rdi, [CRLF]
    xor     rax, rax
    call    printf
    add     rsp, 8
    ret

;-------------------------------------------------------
; HELPER: read integer, returns result in EAX
;-------------------------------------------------------
read_number:
    sub     rsp, 8
    lea     rdi, [fmt_scan]
    lea     rsi, [INPUT_BUF]
    xor     rax, rax
    call    scanf
    mov     eax, [INPUT_BUF]
    add     rsp, 8
    ret
