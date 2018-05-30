.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.data

    program_str: .asciz "/bin/sh"
    .equ program_str_len, $ - program_str

.text

_start:

    # sys_execve(STDOUT, buffer, rbx)
    lea rdi, program_str
    # setup argv[]
    xor rdx, rdx
    push rdx
    push rdi
    mov rsi, rsp
    mov rax, SYS_EXECVE
    syscall

    # sys_exit(0)
    xor rdi, rdi
    mov rax, SYS_EXIT
    syscall
