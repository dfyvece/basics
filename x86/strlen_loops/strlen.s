%include "../include/define.s"

global _start

extern printf
extern fgets
extern exit

section .bss

    BUFFER_LEN equ 4096
    str_buffer resb BUFFER_LEN

section .data

    str_enter db "Enter a string: ", 0
    str_format db "%s", NEW_LINE, 0
    str_strlen db "Strlen: %d", NEW_LINE, 0

section .text

_start:

    ; printf(str_enter);
    xor eax, eax
    push str_enter
    call printf
    add esp, 4

    ; fgets(str_buffer, BUFFER_LEN, STDIN)
    push DWORD STDIN
    push DWORD BUFFER_LEN
    push str_buffer
    call fgets
    add esp, 12

    ; printf(str_format, str_buffer)
    xor eax, eax
    push str_buffer
    push str_format
    call printf
    add esp, 8

    ; exit(0)
    push DWORD 0
    call exit
