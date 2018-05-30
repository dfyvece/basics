.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.bss

    .equ BUFFER_LEN, 4096
    .lcomm buffer, BUFFER_LEN

.data

    enter_str: .asciz "Enter a string: "
    .equ enter_str_len, $ - enter_str
    response_str: .asciz "You entered :\n"
    .equ response_str_len, $ - response_str

.text

_start:

    # sys_write(STDOUT, enter_str, enter_str_len)
    mov rdx, enter_str_len
    lea rsi, enter_str
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

    # rbx = sys_read(STDIN, buffer, BUFFER_LEN)
    mov rdx, BUFFER_LEN
    lea rsi, buffer
    mov rdi, STDIN
    mov rax, SYS_READ
    syscall
    mov rbx, rax

    # sys_write(STDOUT, response_str, response_str_len)
    mov rdx, response_str_len
    lea rsi, response_str
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

    # sys_write(STDOUT, buffer, rbx)
    mov rdx, rbx
    lea rsi, buffer
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

    # sys_exit(0)
    xor rdi, rdi
    mov rax, SYS_EXIT
    syscall
