; Task 2

;----------------------------------------------------
; Low level algorithm

; while
;   if x>=y goto exit
;   S1
;   if x /= p goto else
;   i := x
; for
;   if i>y goto else
;   S3
;   S4
;   i := i+1
;   goto for
; else
;   S5
;   goto while
; exit
;   S6

;----------------------------------------------------
; Assembly language

; Register Usage
;   R1 = x
;   R2 = y
;   R3 = bool
;   R4 = p
;   R5 = bool
;   R6 = x to y
;   R7 = bool
;   R8 = 1

    load    R1,x[R0]            ; R1 := x
    load    R2,y[R0]            ; R2 := y

while
    cmplt   R3,R1,R2            ; R3 := x<y
    jumpf   R3,exitwhile[R0]    ; jump statement
;   S1
    load    R4,p[R0]            ; R4 := p
    cmpeq   R5,R1,R4            ; R5 := R1 == R4
    jumpf   R5,else[R0]         ; jump statement
;   S2

else
    load    R6,x[R0]            ; R6 := x
    lea     R8,1[R0]            ; R8 := 1

for
    cmpgt   R7,R6,R2            ; R7 := R6 > y
    jumpt   exit[R0]            ; jump statement
;   S3
;   S4
    add     R6,R6,R8            ; R6 := R6 + 1
    jump    for[R0]             ; jump statement

exit
;   S5
    jump    while[R0]           ; jump statement

exitwhile
;   S6
    trap    R0,R0,R0            ; terminate


; Static variables

x   data  1
y   data  5
p   data  3