; Task 1

    load    R1,a[R0]    ; R1 := a
    load    R2,b[R0]    ; R2 := b
    sub     R3,R1,R2    ; R3 := R1 - R2 = a - b
    store   R3,x[R0]    ; x := R3
    trap    R0,R0,R0    ; terminate


; Static variables

x   data  0
a   data  20
b   data  13