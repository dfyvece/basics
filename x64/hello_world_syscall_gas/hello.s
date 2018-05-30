.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.data

    hello_str: .asciz "Hello world\n"
    .equ hello_str_len, $-hello_str

.text

_start:

    # sys_write(STDOUT, hello_str, hello_str_len)
    mov rdx, hello_str_len
    lea rsi, hello_str
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

    # sys_exit(0)
    xor rdi, rdi
    mov rax, SYS_EXIT
    syscall
