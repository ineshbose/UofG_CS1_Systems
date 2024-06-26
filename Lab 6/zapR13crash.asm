; Sigma16 program zapR13crash
; John O'Donnell, 2019

; Demonstrate procedure call and return.  If the return address is not
; saved, a nested call will overwrite R13, making it impossible to
; return from the first call

; There are several functions.  They all take one argument x which is
; passed in R1, and return one result f(x) which is also passed back
; in R1.  Each function multiplies x by a constant.  Some of the
; functions (double, triple, quadruple) do the work by themselves, but
; one of them (mult6) calculates 6*x by evaluating triple (double
; (x)).  It gets the right answer, but watch what happens when it
; returns!

MainProgram

; These calls are ok because R13 never gets overwritten
    lea    R1,2[R0]           ; R1 = argument := 2
    jal    R13,double[R0]     ; R1 := double(R1) = 2*2 = 4
    jal    R13,triple[R0]     ; R1 := triple(R1) = 3*4 = 12
    jal    R13,quadruple[R0]  ; R1 := quadruple(R1) = 4*12 = 48
    store  R1,result1[R0]     ; result1 := 4*(3*((2*2)) = 48

; This won't work because a called function calls another function,
; which overwrites R13, so the final return goes to the wrong place
    lea    R1,2[R0]           ; R1 = x = 2
    jal    R13,mult6[R0]      ; R1 = triple(double(x)) = 3*(2*x)
; We should store the result but the program never reaches this point
    store  R1,result2[R0]     ; result2 := 6*2 = 12

    trap   R0,R0,R0           ; terminate main program

double
; receive argument x in R1
; return result in R1 = 2*x
    lea    R2,2[R0]
    mul    R1,R2,R1           ; R1 := 2*x
    jump   0[R13]             ; return R1 = 2*x

triple
; receive argument x in R1
; return result in R1 = 3*x
    lea    R2,3[R0]
    mul    R1,R2,R1           ; R1 := 3*x
    jump   0[R13]             ; return R1 = 3*x

quadruple
; receive argument x in R1
; return result in R1 = 4*x
    lea    R2,4[R0]
    mul    R1,R2,R1           ; R1 := 4*x
    jump   0[R13]             ; return R1 = 4*x

mult6
; receive argument x in R1
; return result in R1
; This is a common kind of function: it doesn't do much work, it
; just calls other functions to do all the real work
    jal    R13,double[R0]     ; R1 := double(x) = 2*x
    jal    R13,triple[R0]     ; R1 : triple(2*x) = 3*(2*x)
    jump   0[R13]             ; return R1 = 3*(2*x)

; Static variables

result1  data   0            ; result of first sequence of calls
result2  data   0            ; result of the mult6 call