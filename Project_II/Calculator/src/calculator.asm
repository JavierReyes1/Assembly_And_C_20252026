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
