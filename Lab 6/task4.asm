; Task 4

    lea     R14,CallStack[R0]   ; R14 := &CallStack
    store   R0,0[R14]           ; (not actually necessary)
    lea     R1,2[R0]            ; R1 := 2
    lea     R14,1[R14]          ; advance the stack pointer
    jal     R13,double[R0]      ; R1 := double(R1) = 2*2 = 4
    lea     R14,1[R14]          ; advance the stack pointer
    jal     R13,triple[R0]      ; R1 := triple(R1) = 3*4 = 12
    lea     R14,1[R14]          ; advance the stack pointer
    jal     R13,quadruple[R0]   ; R1 := quadruple(R1) = 4*12 = 48
    store   R1,result1[R0]      ; result1 := 4*(3*((2*2)) = 48
    lea     R1,2[R0]            ; R1 = x = 2
    lea     R14,1[R14]          ; advance the stack pointer
    jal     R13,mult6[R0]       ; R1 = triple(double(x)) = 3*(2*x)
    store   R1,result2[R0]      ; result2 := R1
    trap    R0,R0,R0            ; terminate

double
    store   R13,0[R14]          ; save return address on top of stack
    lea     R2,2[R0]            ; R2 := 2
    mul     R1,R2,R1            ; R1 := 2*x
    load    R13,0[R14]          ; restore return address from top of stack
    lea     R2,1[R0]            ; R2 := size of stack frame
    sub     R14,R14,R2          ; remove top frame from stack
    jump    0[R13]              ; return R1 = 2*x

triple
    store   R13,0[R14]          ; save return address on top of stack
    lea     R2,3[R0]            ; R2 := 3
    mul     R1,R2,R1            ; R1 := 3*x
    load    R13,0[R14]          ; restore return address from top of stack
    lea     R2,1[R0]            ; R2 := size of stack frame
    sub     R14,R14,R2          ; remove top frame from stack
    jump    0[R13]              ; return R1 = 3*x

quadruple
    store   R13,0[R14]          ; save return address on top of stack
    lea     R2,4[R0]            ; R2 := 4
    mul     R1,R2,R1            ; R1 := 4*x
    load    R13,0[R14]          ; restore return address from top of stack
    lea     R2,1[R0]            ; R2 := size of stack frame
    sub     R14,R14,R2          ; remove top frame from stack
    jump    0[R13]              ; return R1 = 4*x

mult6
    store   R13,0[R14]          ; save return address on top of stack
    lea     R14,1[R14]          ; advance the stack pointer
    jal     R13,double[R0]      ; R1 := double(x) = 2*x
    lea     R14,1[R14]          ; advance the stack pointer
    jal     R13,triple[R0]      ; R1 : triple(2*x) = 3*(2*x)
    load    R13,0[R14]          ; restore return address from top of stack
    lea     R2,1[R0]            ; R2 := size of stack frame
    sub     R14,R14,R2          ; remove top frame from stack
    jump    0[R13]              ; return R1 = 3*(2*x)


; Static variables

result1     data  0
result2     data  0
CallStack   data  0