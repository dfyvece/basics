.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.text

# xor_crypt(rdi:inout, rsi:byte, rdx;count) {
# performs a single-byte XOR encryption
xor_crypt:

    push rbp
    mov rbp, rsp
    push rbx

    # mov rsi into rdx for instruction encoding purposes
    mov rdx, rsi

    # setup rcx for count
    mov rcx, rdx
    inc rcx
    xor rax, rax

    # rdi[rcx] ^= rsi
    for_xor_loop:
    mov al, BYTE PTR [rdi + rcx - 1]
    xor al, dl
    mov BYTE PTR [rdi + rcx - 1], al
    loop for_xor_loop

    pop rbx
    leave
    ret
# }

_start:

    # sys_read(STDIN, hexbuffer, BUFFER_LEN)
    mov rdx, BUFFER_LEN
    lea rsi, hexbuffer
    mov rdi, STDIN
    mov rax, SYS_READ
    syscall

    # rax = hex2byte(bytebuffer, hexbuffer)
    lea rsi, hexbuffer
    lea rdi, bytebuffer
    call hex2byte

    # xor_crypt(bytebuffer, byte, rax)
    push rax
    mov rdx, rax
    mov rsi, key
    lea rdi, bytebuffer
    call xor_crypt
    pop rdx

    # byte2hex(hexoutput, bytebuffer, rdx)
    lea rsi, bytebuffer
    lea rdi, hexoutput
    call byte2hex

    # sys_write(STDOUT, hexoutput, rax)
    mov rdx, rax
    lea rsi, hexoutput
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

    # sys_exit(0)
    xor rdi, rdi
    mov rax, SYS_EXIT
    syscall

