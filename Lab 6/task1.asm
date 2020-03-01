; Task 1

    lea     R1,2[R0]    ; R1 := 2 (f100 0002)
    load    R2,y[R0]    ; R2 := y (f201 00f8)
    add     R3,R1,R2    ; R3 := R1+R2 (0312)
    store   R3,x[R0]    ; x := R3 (f302 00c3)
    trap    R0,R0,R0    ; terminate


; Static variables

x   data  0
y   data  0