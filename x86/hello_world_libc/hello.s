%include "../include/define.s"

global _start

extern printf
extern exit

section .data

    hello_str db "Hello world", NEW_LINE, 0

section .text

_start:

    ; printf(hello_str);
    xor eax, eax
    push hello_str
    call printf

    ; exit(0)
    push DWORD 0
    call exit
