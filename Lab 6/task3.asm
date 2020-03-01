; Task 3

    load    R1,x[R0]    ; R1 := x
    load    R2,y[R0]    ; R2 := y
    cmplt   R3,R1,R2    ; R3 := x < y
    jumpt   R3,L[R0]    ; jump statement
    load    R3,p[R0]    ; R3 := p
    load    R4,q[R0]    ; R4 := q
    cmplt   R5,R3,R4    ; R5 := p < q
    jumpt   R5,L[R0]    ; jump statement
    jump    exit[R0]    ; jump statement

L
;   statements

exit
    trap    R0,R0,R0    ; terminate


; Static variables

x   data  0
y   data  0
p   data  0
q   data  0