; Program Swap

    load    R1,x[R0]    ; R1 := x
    load    R2,y[R0]    ; R2 := y
    store   R1,y[R0]    ; y := R1
    store   R2,x[R0]    ; x := R2
    trap    R0,R0,R0    ; terminate


; Static variables

x   data  3
y   data  19