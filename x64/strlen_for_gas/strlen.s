.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.extern printf
.extern fflush
.extern read
.extern exit

.bss

    .equ BUFFER_LEN, 4096
    .lcomm buffer, BUFFER_LEN

.data

    enter_str: .asciz "Enter a string: "
    format_str: .asciz "%s\n"
    strlen_str: .asciz "That string is %d characters long\n"
    strlen_one_str: .asciz "That string is 1 character long\n"

.text

# rax:int my_strlen(rdi:str) {
my_strlen:


    # for (rcx = 0; rdi[rcx] != '\0'; ++rcx) {
    # initialize section
    xor rcx, rcx
    # test section
    for_rdx_rcx_not_null_test:
    mov al, BYTE PTR [rdi + rcx]
    test al, al
    jz for_rdx_rcx_not_null_end

        # do nothing

    # }
    # increment section
    inc rcx
    jmp for_rdx_rcx_not_null_test
    for_rdx_rcx_not_null_end:

    # return rcx
    mov rax, rcx
    ret

# }

_start:

    # printf(hello_str)
    xor rax, rax
    lea rdi, enter_str
    call printf

    # fflush(0)
    xor rax, rax
    call fflush

    # read(STDIN, buffer, BUFFER_LEN)
    mov rdx, BUFFER_LEN
    lea rsi, buffer
    mov rdi, STDIN
    call read

    # rax = my_strlen(buffer)
    lea rdi, buffer
    call my_strlen

    # if (rax == 1) {
    cmp rax, 1
    jne if_rax_1_else

        # printf(strlen_one_str)
        xor rax, rax
        lea rdi, strlen_one_str
        call printf

    # } else {
    jmp if_rax_1_end
    if_rax_1_else:

        # printf(strlen_str, rax)
        mov rsi, rax
        lea rdi, strlen_str
        xor rax, rax
        call printf

    # }
    if_rax_1_end:

    # exit(0)
    xor rdi, rdi
    call exit
