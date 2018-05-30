.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.text

_start:

    # setup:
    # rdx must be size of data
    # rbx must be key
    # data is after this section

    jmp encoded_data
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
    xor al, dl
    mov BYTE PTR [rdi + rcx - 1], al
    loop for_xor_loop
    encoded_data:
    call decode_stub

