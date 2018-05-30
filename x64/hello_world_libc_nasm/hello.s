%include "../include/nasm.s"

global _start

extern printf
extern exit

section .data

    hello_str db "Hello world", NEW_LINE, 0

section .text

_start:

    ; printf(hello_str);
    xor rax, rax
    mov rdi, hello_str
    call printf

    ; exit(0)
    xor rdi, rdi
    call exit
