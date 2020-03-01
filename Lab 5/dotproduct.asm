; Program DotProduct

;----------------------------------------------------
; High level algorithm

;   p := 0
;   for i := 0 to n-1 step 1
;       product := x[i] * y[i]
;       p := p + product

;----------------------------------------------------
; Low level algorithm

;     p := 0
;     i := 0
; forloop:
;     if i >= n then goto done
;     product := x[i] * y[i]
;     p := p + product
;     i := i + 1
;     goto forloop
; done:
;     terminate

;----------------------------------------------------
; Assembly language

; Register Usage
;   R1 = 1
;   R2 = n
;   R3 = i
;   R4 = product
;   R5 = p

; Initialise
       lea    R1,1[R0]         ; R1 = constant 1
       load   R2,n[R0]         ; R2 = n
; max := x[0]
       load   R4,product[R0]   ; R4 = product
       load   R5,p[R0]         ; R5 = p
; i := 0
       lea    R3,0[R0]         ; R3 = i = 0
; Top of loop, determine whether to remain in loop
forloop
; if i >= n then goto done
       cmp    R3,R2            ; compare i, n
       jumpge done[R0]         ; if i>=n then goto done
; product := x[i] * y[i]
       load  R6,x[R3]          ; R6 = x[i]
       load  R7,y[R3]          ; R7 = y[i]
       mul   R4,R6,R7          ; R5 = x[i] * y[i]
       add   R5,R5,R4          ; R5 = R5 + product
; i := i + 1
       add    R3,R3,R1         ; i = i + 1
; goto forloop
       jump   forloop[R0]      ; go to top of forloop

; Exit from forloop
done   store R5,p[R0]          ; p = R5
; terminate
       trap  R0,R0,R0          ; terminate

; Data area
; With the following data, the expected result is 34 (0022)

n        data   3
p        data   0
product  data   0
x        data   2
         data   5
         data   3
y        data   6
         data   2
         data   4