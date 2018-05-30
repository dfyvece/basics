.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.bss

    .equ BUFFER_LEN, 4096
    .lcomm hexbuffer, BUFFER_LEN
    .lcomm byteoutput, BUFFER_LEN/2

.text

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

    # rax = hex2byte(byteoutput, hexbuffer)
    lea rsi, hexbuffer
    lea rdi, byteoutput
    call hex2byte

    # sys_write(STDOUT, byteoutput, rax)
    mov rdx, rax
    lea rsi, byteoutput
    mov rdi, STDOUT
    mov rax, SYS_WRITE
    syscall

    # sys_exit(0)
    xor rdi, rdi
    mov rax, SYS_EXIT
    syscall
