%include "../include/nasm.s"

global _start

section .data

    hello_str db "Hello world", NEW_LINE, 0
    hello_str_len equ $-hello_str

section .text

_start:

    ; sys_write(STDOUT, hello_str, hello_str_len)
    mov edx, hello_str_len
    mov ecx, hello_str
    mov ebx, STDOUT
    mov eax, SYS_WRITE
    int 0x80

    ; sys_exit(0)
    mov ebx, 0
    mov eax, SYS_EXIT
    int 0x80
