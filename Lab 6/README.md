# Lab 6 (27/02/20)

## Task 1
The following assembly language code fragment is supposed to be equivalent to `x := 2+y` but it is poorly written. Find as many things wrong with it and indicate whether each fault is poor style or would cause error messages or runtime errors. Rewrite the code fragment as it should be.

```
        load R1,x[R0]
    load R2,2[R0]
        load R3,y
add R4,R2,R3 ; R4 := R2+R3
      store x[R0],R4
```

## Task 2
Translate the following high level code into low level form (and then assembly language - _optional_).

```
while x<y do
    {   S1
        if x = p
            then { S2 }
            else for i := x to y
                { S3 }
                { S4 }
        { S5 }
    }
{ S6 }
```

## Task 3
Translate the following low level code to assembly language.

```
if x<y || p<q then goto L
```

## Task 4
Write a program, _saveR13stack_, that uses a stack to save and restore the return addresses. Take the given `zapR13crash.asm` as a starter and make the following modifications to the program:

* Allocate the stack in the data area at the very end of the program:

```
result1     data  0             ; result of first sequence of calls
result2     data  0             ; result of the mult6 call
CallStack   data  0             ; The stack grows beyond this point
```

* The main program initializes the stack as follows:

```
    lea     R14,CallStack[R0]   ; R14 := &stack, R14 is the stack pointer
    store   R0,0[R14]           ; (not actually necessary)
```

* A function is called as follows:

```
    (put the argument into R1)
    lea     R14,1[R14]          ; advance the stack pointer to new frame
    jal     R13,function[R0]    ; goto function, R13 := return address
```

* Every function begins as follows:

```
    store   R13,0[R14]          ; save return address on top of stack
```

* Every function finishes and returns as follows:

```
    (put the result into R1)
    load    R13,0[R14]          ; restore return address from top of stack
    lea     R2,1[R0]            ; R2 := size of stack frame
    sub     R14,R14,R2          ; remove top frame from stack
    jump    0[R13]              ; return to caller
```