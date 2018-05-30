.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.bss

    .equ BUFFER_LEN, 4096
    .lcomm hexoutput, BUFFER_LEN
    .lcomm bytebuffer, BUFFER_LEN/2

.data

    hex_map: .byte  0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66

.text

# byte2hex(rdi:output, rsi:input, rdx;count) {
byte2hex:

    push rbp
    mov rbp, rsp
    push rbx

    # for (rcx = 0; rcx < rdx:count; ++rcx) {
    # initialize section
    xor rcx, rcx
    # test section
    for_rcx_test:
    cmp rcx, rdx
    jge for_rcx_end

        # r8 = r9 = 0
        xor r8, r8
        xor r9, r9

        # r8b = rsi[rcx]
        mov r8b, BYTE PTR [rsi + rcx]

        # r9b = r8b
        mov r9b, r8b

        # get 11110000 of number in r8b and 00001111 of number in r9b
        shr r8b, 4
        and r9b, 0x0f

        # ax = hex_map[r8b] . hex_map[r9b]
        xor ax, ax
        lea rbx, hex_map
        mov al, [rbx + r8]
        mov bl, [rbx + r9]
        mov ah, bl

        # rdi[rcx*2] = ax
        mov rbx, rcx
        shl rbx, 1
        mov WORD PTR [rdi + rbx], ax

    # }
    # increment section
    inc rcx
    jmp for_rcx_test
    for_rcx_end:

    # return
    pop rbx
    leave
    ret

# }

_start:

    # rax = sys_read(STDIN, hexoutput, BUFFER_LEN)
    mov rdx, BUFFER_LEN
    lea rsi, hexoutput
    mov rdi, STDIN
    mov rax, SYS_READ
    syscall

    # rax = byte2hex(bytebuffer, hexoutput, rax)
    mov rdx, rax
    lea rsi, hexoutput
    lea rdi, bytebuffer
    call byte2hex

    # sys_write(STDOUT, bytebuffer, rax)
    mov rdx, rax
    lea rsi, bytebuffer
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

    # sys_exit(0)
    xor rdi, rdi
    mov rax, SYS_EXIT
    syscall
