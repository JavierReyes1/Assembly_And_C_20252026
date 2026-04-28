default rel

section .text
global register_adder

register_adder:
 mov		eax, edi
 add 		eax, esi
 ret
