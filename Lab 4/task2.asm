; Task 2

; Register Usage
; R1 = x
; R2 = y
; R3 = a
; R4 = bool

    load    R1,x[R0]    ; R1 := x
    load    R2,y[R0]    ; R2 := y
    cmpgt   R4,R1,R2    ; R4 := x > y
    jumpf   R4,else[R0] ; jump statement
    load    R3,x[R0]    ; R3 := x
    store   R3,a[R0]    ; a := R3
    jump    exit[R0]    ; jump statement

else
    load    R3,y[R0]    ; R3 := y
    store   R3,a[R0]    ; a := R3

exit
    lea     R4,2[R0]    ; R4 := 2
    mul     R4,R4,R3    ; R4 := R4 x R3
    store   R4,a[R0]    ; a := R4
    trap    R0,R0,R0    ; terminate


; Static variables

x   data  3
y   data  20
a   data  0