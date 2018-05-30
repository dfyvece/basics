.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.bss

    .equ BUFFER_LEN, 4096
    .lcomm hexbuffer, BUFFER_LEN
    .lcomm bytebuffer, BUFFER_LEN/2
    .lcomm hexoutput, BUFFER_LEN
    .lcomm decoderbuffer, BUFFER_LEN

.text

.data

    hex_map: .byte  0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66
    .equ key, 0x55

                                                            # KEY #                       # SIZE #
    decoder_stub:   .byte 0xeb, 0x20, 0x48, 0x31, 0xdb, 0xb3, key, 0x48, 0x31, 0xd2, 0xb2, 0xFF
                    .byte 0x5f, 0x48, 0x89, 0xd1, 0x48, 0xff, 0xc1, 0x48, 0x31, 0xc0
                    .byte 0x8a, 0x44, 0x0f, 0xff, 0x30, 0xd0, 0x88, 0x44, 0x0f, 0xff, 0xe2, 0xf4
                    .byte 0xe8, 0xdb, 0xff, 0xff, 0xff
    .equ decoder_len, $ - decoder_stub

.text


# xor_crypt(rdi:inout, rsi:byte, rdx;count) {
# performs a single-byte XOR encryption
xor_crypt:

    push rbp
    mov rbp, rsp
    push rbx

    # mov rsi into rbx for instruction encoding purposes
    mov rbx, rsi

    # setup rcx for count
    mov rcx, rdx
    inc rcx
    xor rax, rax

    # rdi[rcx] ^= rsi
    for_xor_loop:
    mov al, BYTE PTR [rdi + rcx - 1]
    xor al, bl
    mov BYTE PTR [rdi + rcx - 1], al
    loop for_xor_loop

    pop rbx
    leave
    ret
# }


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


# rax:int char2byte(rdi:input) {
# takes a single char and returns the byte value as interpreted via hex
# e.g. (0=>0, 1=>1..e=>14, f=>15)
# returns -1 on failure
char2byte:

    push rbp
    mov rbp, rsp

    # rax = 0
    xor rax, rax

    # if (rdi > 0x30 && rdi <= 0x39) { // it's 0-9
    cmp rdi, 0x30
    jl if_rdi_30_39_else
    cmp rdi, 0x39
    jg if_rdi_30_39_else

        # rdi = rdi - 0x30
        sub rdi, 0x30

    # } else if (rdi > 0x40 && rdi <= 0x46 ) { // it's A-F
    jmp if_rdi_cmps_end
    if_rdi_30_39_else:
    cmp rdi, 0x40
    jl if_rdi_40_46_else
    cmp rdi, 0x46
    jg if_rdi_40_46_else

        # rdi = rdi - 0x40 + 0x9
        sub rdi, 0x37

    # } else if (rdi > 0x60 && rdi <= 0x66 ) { // it's a-f
    jmp if_rdi_cmps_end
    if_rdi_40_46_else:
    cmp rdi, 0x60
    jl if_rdi_60_66_else
    cmp rdi, 0x66
    jg if_rdi_60_66_else

        # rdi = rdi - 0x60 + 0x9
        sub rdi, 0x57

    # } else {
    jmp if_rdi_cmps_end
    if_rdi_60_66_else:

        # rdi = -1
        mov rdi, -1

    # }
    if_rdi_cmps_end:

    # return rdi
    mov rax, rdi
    leave
    ret

# }


# rax:int hex2byte(rdi:output, rsi:input) {
# returns the number of bytes in final output
hex2byte:

    push rbp
    mov rbp, rsp

    # for (rdx = 0; isdigit(rsi[2*rdx]) && isdigit(rsi[2*rdx+1]); ++rdx) {
    # initialize section
    xor rdx, rdx
    # test section
    for_is_digit_test:
    mov rcx, rdx
    shl rcx, 1
    xor r8, r8
    xor r9, r9
    mov r8b, [rsi + rcx]      # r8b = rsi[2*rdx]
    mov r9b, [rsi + rcx + 1]  # r9b = rsi[2*rdx + 1]
    # r8b = char2byte(r8b)
    push rsi
    push rdi
    push rdx
    push r8
    push r9
    mov rdi, r8
    call char2byte
    pop r9
    pop r8
    pop rdx
    pop rdi
    pop rsi
    mov r8b, al
    # r9b != -1
    cmp r8b, -1
    je for_is_digit_end
    # r9b = char2byte(r9b)
    push rsi
    push rdi
    push rdx
    push r8
    push r9
    mov rdi, r9
    call char2byte
    pop r9
    pop r8
    pop rdx
    pop rdi
    pop rsi
    mov r9b, al
    # r9b != -1
    cmp r9b, -1
    je for_is_digit_end

        # rax = (r8b-0x30) * 10 + (r9b-0x30)
        shl r8b, 4
        add r8b, r9b

        # rdi[rdx] = r8b
        mov BYTE PTR [rdi + rdx], r8b

    # }
    # increment section
    inc rdx
    jmp for_is_digit_test
    for_is_digit_end:

    # return rdx
    mov rax, rdx
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

    # decoder_stub[12] = count
    lea rdi, decoder_stub
    mov BYTE PTR [rdi], dl

    # byte2hex(hexoutput, bytebuffer, rdx)
    lea rsi, bytebuffer
    lea rdi, hexoutput
    call byte2hex

    # sys_write_STDOUT, decoder_stub, decoder_len)
    mov rdx, decoder_len
    lea rsi, decoder_stub
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

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
