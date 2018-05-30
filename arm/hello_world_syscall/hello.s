
.global _start

.data

    hello_str: .asciz "Hello world\n"
    .equ hello_str_len, (. - hello_str)

.text

_start:

    # sys_write(STDOUT, hello_str, hello_str_len)
    MOV R2, #hello_str_len
    LDR R1, =hello_str
    MOV R0, #1
    MOV R7, #4
    SWI $0

    # sys_exit(0)
    MOV R0, #0
    MOV R7, #1
    SWI $0
