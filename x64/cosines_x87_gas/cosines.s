.intel_syntax noprefix
.include "../include/gas.s"

.global _start

.extern printf
.extern scanf
.extern fflush
.extern exit

.data

    welcome_str: .asciz "Law of Cosines Calculator\n========================================\n\n"
    enter_a_str: .asciz "Enter A: "
    enter_b_str: .asciz "Enter B: "
    enter_theta: .asciz "Enter theta: "
    result_str : .asciz "C = %0.03f\n"
    scan_str   : .asciz "%f"

.text

# void law_of_cosines(rdi:&result, rsi:&a_var, rdx:&b_var, rcx:&theta) {
law_of_cosines:

    push rbp
    mov rbp, rsp

    # st(0) = a_var^2
    fld DWORD PTR [rsi]
    fmul st(0), st(0)

    # st(0) = b_var^2
    fld DWORD PTR [rdx]
    fmul st(0), st(0)

    # st(0) = a_var^2 + b_var^2
    fadd st(0), st(1)

    # st(0) = cos(theta)
    fld DWORD PTR [rcx]
    fcos

    # st(0) = 2*a_var*b_var*cos(theta)
    fmul DWORD PTR [rsi]
    fmul DWORD PTR [rdx]
    fadd st(0), st(0)

    # st(0) = a_var^2 + b_var^2 + 2*a_var*b_var*cos(theta)
    fsubp st(1), st(0)

    # sqrt(st(0))
    fsqrt

    # store result
    fstp DWORD PTR [rdi]

    leave
    ret
# }

_start:

    push rbp
    mov rbp, rsp
    sub rsp, 24         # 16 byte aligned
    .equ A_VAR,     4
    .equ B_VAR,     8
    .equ THETA,     12
    .equ RESULT,    16

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

    # printf(enter_theta)
    xor rax, rax
    lea rdi, enter_theta
    call printf

    # fflush(0)
    xor rdi, rdi
    call fflush

    # scanf(scan_str, THETA)
    lea rsi, [rbp-THETA]
    lea rdi, scan_str
    call scanf

    # law_of_cosines(&result, &A_VAR, &B_VAR, &THETA)
    lea rcx, [rbp-THETA]
    lea rdx, [rbp-B_VAR]
    lea rsi, [rbp-A_VAR]
    lea rdi, [rbp-RESULT]
    call law_of_cosines

    # printf(result_str, result)
    mov rax, 1
    movss xmm0, DWORD PTR [rbp-RESULT]
    cvtps2pd xmm0, xmm0
    lea rdi, result_str
    call printf

    # exit(0)
    xor rdi, rdi
    call exit
