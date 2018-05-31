.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.text

_start:

    # setup:
    # rdx must be size of data
    # rbx must be key
    # data is after this section

    jmp jump_block
    decode_stub:
    xor rbx, rbx
    mov bl, 55
    xor rdx, rdx
    mov dl, 66
    pop rdi
    mov rcx, rdx
    inc rcx
    xor rax, rax

    # rdi[rcx] ^= rsi
    for_xor_loop:
    mov al, BYTE PTR [rdi + rcx - 1]
    xor al, bl
    mov BYTE PTR [rdi + rcx - 1], al
    loop for_xor_loop
    jmp encoded_data
    jump_block:
    call decode_stub
    encoded_data:


