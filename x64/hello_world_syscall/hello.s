%include "../include/define.s"

global _start

section .data

    hello_str db "Hello world", NEW_LINE, 0
    hello_str_len equ $-hello_str

section .text

_start:

    ; sys_write(STDOUT, hello_str, hello_str_len)
    mov rdx, hello_str_len
    mov rsi, hello_str
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

    ; sys_exit(0)
    mov rdi, 0
    mov rax, SYS_EXIT
    syscall
