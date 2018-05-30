.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.extern printf
.extern fgets
.extern exit

.bss

    .equ BUFFER_LEN, 4096
    .lcomm str_buffer, BUFFER_LEN

.data

    str_enter: .asciz "Enter a string: "
    str_format: .asciz "%s\n"
    str_strlen: .asciz "Strlen: %d\n"

.text

_start:

    # printf(str_enter);
    xor eax, eax
    push str_enter
    call printf
    add esp, 4

    # fgets(str_buffer, BUFFER_LEN, STDIN)
    xor eax, eax
    push eax
    mov eax, BUFFER_LEN
    push eax
    push str_buffer
    call fgets
    add esp, 12

    # printf(str_format, str_buffer)
    xor eax, eax
    push str_buffer
    push str_format
    call printf
    add esp, 8

    # exit(0)
    xor eax, eax
    push eax
    call exit
