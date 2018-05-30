.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.data

    hello_str: .asciz "Hello world\n"
    .equ hello_str_len, $-hello_str

.text

_start:

    # sys_write(STDOUT, hello_str, hello_str_len)
    mov edx, hello_str_len
    lea ecx, hello_str
    mov ebx, STDOUT
    mov eax, SYS_WRITE
    int 0x80

    # sys_exit(0)
    mov ebx, 0
    mov eax, SYS_EXIT
    int 0x80
