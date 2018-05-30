.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.extern printf
.extern exit

.data

    hello_str: .asciz "Hello world\n"

.text

_start:

    # printf(hello_str)
    xor rax, rax
    lea rdi, hello_str
    call printf

    # exit(0)
    xor rdi, rdi
    call exit
