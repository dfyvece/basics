.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.extern printf
.extern scanf
.extern fflush
.extern exit

.data

    welcome_str: .asciz "Pythagorean Theorem Calculator\n========================================\n\n"
    enter_a_str: .asciz "Enter A: "
    enter_b_str: .asciz "Enter B: "
    result_str : .asciz "C = %0.03f\n"
    scan_str   : .asciz "%f"

.text

# void pythagorean(rdi:&result, rsi:&a_var, rdx:&b_var) {
pythagorean:

    push rbp
    mov rbp, rsp
    sub rsp, 24
    .equ PACKED_ARRAY, 24
    .equ A_VAR, 24
    .equ B_VAR, 20

    # make double packed array of numbers
    mov r8d, DWORD PTR [rsi]
    mov r9d, DWORD PTR [rdx]
    mov DWORD PTR [rsp-A_VAR], r8d
    mov DWORD PTR [rsp-B_VAR], r9d

    # load two packed floats into register
    movlps xmm0, [rsp-PACKED_ARRAY]

    # square packed values in xmm0
    mulps xmm0, xmm0

    # move values back to array
    movlps [rsp-PACKED_ARRAY], xmm0

    # add values together
    movss xmm0, DWORD PTR [rsp-A_VAR]
    movss xmm1, DWORD PTR [rsp-B_VAR]
    addss xmm0, xmm1

    # square root values
    sqrtss xmm0, xmm0

    # store result
    movss DWORD PTR [rdi], xmm0

    leave
    ret
# }

_start:

    push rbp
    mov rbp, rsp
    sub rsp, 24         # 16 byte aligned
    .equ A_VAR,     4
    .equ B_VAR,     8
    .equ RESULT,    12

    # printf(welcome_str)
    xor rax, rax
    lea rdi, welcome_str
    call printf

    # printf(enter_a_str)
    xor rax, rax
    lea rdi, enter_a_str
    call printf

    # fflush(0)
    xor rdi, rdi
    call fflush

    # scanf(scan_str, A_VAR)
    lea rsi, [rbp-A_VAR]
    lea rdi, scan_str
    call scanf

    # printf(enter_b_str)
    xor rax, rax
    lea rdi, enter_b_str
    call printf

    # fflush(0)
    xor rdi, rdi
    call fflush

    # scanf(scan_str, B_VAR)
    lea rsi, [rbp-B_VAR]
    lea rdi, scan_str
    call scanf

    # pythagorean(&result, &A_VAR, &B_VAR)
    lea rdx, [rbp-B_VAR]
    lea rsi, [rbp-A_VAR]
    lea rdi, [rbp-RESULT]
    call pythagorean

    # printf(result_str, result)
    mov rax, 1
    movss xmm0, DWORD PTR [rbp-RESULT]
    cvtps2pd xmm0, xmm0
    lea rdi, result_str
    call printf

    # exit(0)
    xor rdi, rdi
    call exit
