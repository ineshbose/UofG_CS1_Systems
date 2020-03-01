; Task 3

; Register Usage
; R1 = sum
; R2 = i
; R3 = n
; R4 = 1

    add     R1,R0,R0    ; R1 := 0
    add     R2,R0,R0    ; R2 := 0
    load    R3,n[R0]    ; R3 := n
    lea     R4,1[R0]    ; R4 := 1

while
    cmplt   R4,R2,R3    ; R4 := R2 < R3
    jumpf   R4,exit[R0] ; jump statement
    add     R1,R1,R2    ; R1 := R1 + R2 := sum + i
    add     R2,R2,R4    ; R2 := R2 + R4 := i + 1
    jump    while[R0]   ; jump statement

exit
    store   R1,sum[R0]  ; sum := R1
    trap    R0,R0,R0    ; terminate


; Static variables

sum     data  0
n       data  5