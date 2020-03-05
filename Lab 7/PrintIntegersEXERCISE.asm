
; Global register usage
;   R0 = constant 0
;   R1, R2, R3 are used for parameters and return values
;   R4 - R10 are available for local use in a procedure
;   R11 = stack limit
;   R12 = stack top
;   R13 = return address
;   R14 = stack pointer
;   R15 is transient condition code

;--------------------------------------------------------------------
; Main program execution starts here
;--------------------------------------------------------------------

; High level algorithm
; Program PrintIntegers
;   { print "37\n";     // demonstrate trap for writing
;     print "Cat\n";    // demonstrate trap for writing
;     PrintInt (23,6)   // ok, leading spaces
;     ... }

; Low level algorithm similar
; Assembly language

PrintIntegers

; Structure of stack frame for main program, frame size=1
;    0[R14]  dynamic link is nil

; Initialize the stack
    lea    R14,CallStack[R0]  ; initialise stack pointer
    store  R0,0[R14]          ; main program dynamic link = nil
    lea    R12,1[R14]         ; initialise stack top
    load   R1,StackSize[R0]   ; R1 := stack size
    add    R11,R14,R1         ; StackLimit := &CallStack + StackSize
    
    store  R0,0[R14]          ; previous frame pointer := nil

; Print  "37\n" directly using trap
    lea    R1,2[R0]              ; R1 := trap write code
    lea    R3,1[R0]              ; R3 := size of buffer to print
    lea    R4,Digits[R0]         ; R4 := &Digits
    lea    R2,3[R4]              ; R2 := &Digits[3] = &'3'
    trap   R1,R2,R3              ; print '3'
    lea    R2,7[R4]              ; R2 := &Digits[7] = &'7'
    trap   R1,R2,R3              ; print '7'
    lea    R2,NewLine[R0]        ; R2 := &'\n'
    trap   R1,R2,R3              ; print '\n'

; Print  "Cat\n" directly using trap
    lea    R1,2[R0]              ; R1 := trap write code
    lea    R3,1[R0]              ; R3 := size of buffer to print
    lea    R4,letters[R0]        ; R4 := &letters
    lea    R5,LETTERS[R0]        ; R5 := &LETTERS
    lea    R2,2[R5]              ; R2 := &LETTERS[2] = &'C'
    trap   R1,R2,R3              ; print 'C'
    lea    R2,0[R4]              ; R2 := &letters[0] = &'a'
    trap   R1,R2,R3              ; print 'a'
    lea    R2,19[R4]             ; R2 := &letters[19] = &'t'
    trap   R1,R2,R3              ; print 't'
    lea    R2,NewLine[R0]        ; R2 := &'\n'
    trap   R1,R2,R3              ; print '\n'

; PrintInt (23,6)  -- ok, leading spaces
    lea    R1,23[R0]             ; R1 := 23 = number to print
    lea    R2,6[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (0,1)  -- ok, leading spaces
    lea    R1,0[R0]             ; R1 := 23 = number to print
    lea    R2,1[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt ($7fff,5)  -- ok, fills the field, largest int
    lea    R1,$7fff[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt ($7fff,4)  -- too big for field, produces #, largest int
    lea    R1,$7fff[R0]             ; R1 := 23 = number to print
    lea    R2,4[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt ($ffff,2)  -- ok, fills the field, -1
    lea    R1,$ffff[R0]             ; R1 := 23 = number to print
    lea    R2,2[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt ($ffff,1)  -- too big for field, produces #, -1
    lea    R1,$ffff[R0]             ; R1 := 23 = number to print
    lea    R2,1[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (32,5)  -- ok, leading spaces
    lea    R1,32[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (17,5)  -- ok, leading spaces
    lea    R1,17[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (456,5)  -- ok, leading spaces
    lea    R1,456[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (1066,6)  -- ok, leading spaces
    lea    R1,1066[R0]             ; R1 := 23 = number to print
    lea    R2,6[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (-30978,6)  -- ok, fills the field
    lea    R1,-30978[R0]             ; R1 := 23 = number to print
    lea    R2,6[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (2001,4)  -- ok, fills the field
    lea    R1,2001[R0]             ; R1 := 23 = number to print
    lea    R2,4[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (3,1)  -- ok, fills the field
    lea    R1,3[R0]             ; R1 := 23 = number to print
    lea    R2,1[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (47,5)  -- ok, leading spaces
    lea    R1,47[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (13,5)  -- ok, leading spaces
    lea    R1,13[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (19,2)  -- ok, fills the field
    lea    R1,19[R0]             ; R1 := 23 = number to print
    lea    R2,2[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (103,5)  -- ok, leading spaces
    lea    R1,103[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (104,3)  -- ok, fills the field
    lea    R1,103[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (105,2)  -- too big for field, produces ##
    lea    R1,105[R0]             ; R1 := 23 = number to print
    lea    R2,2[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (47,5)  -- ok, will get leading spaces
    lea    R1,47[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (48,6)  -- ok, will get leading spaces
    lea    R1,48[R0]             ; R1 := 23 = number to print
    lea    R2,6[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (49,5)  -- ok, will get leading spaces
    lea    R1,49[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (29371,5)  -- ok, fills the field
    lea    R1,29371[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (6285,4)  -- ok, fills the field
    lea    R1,6285[R0]             ; R1 := 23 = number to print
    lea    R2,4[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (264,6)  -- ok, will get leading spaces
    lea    R1,264[R0]             ; R1 := 23 = number to print
    lea    R2,6[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (264,2)  -- too big for the field, will produce ##
    lea    R1,264[R0]             ; R1 := 23 = number to print
    lea    R2,2[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (-92,5)  -- ok, will get leading spaces
    lea    R1,-92[R0]             ; R1 := 23 = number to print
    lea    R2,5[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (-1,2)  -- ok, fills the field
    lea    R1,-1[R0]             ; R1 := 23 = number to print
    lea    R2,2[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (6285,3)  -- too big for the field, produces ###
    lea    R1,6285[R0]             ; R1 := 23 = number to print
    lea    R2,3[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; PrintInt (42,2)
    lea    R1,42[R0]             ; R1 := 23 = number to print
    lea    R2,2[R0]              ; R2 := 5 = field size
    jal    R13,PrintInt[R0]       ; put string for R1 into buffer

; Finish
    trap   R0,R0,R0              ; main program halts after unit testing

; Static data for main program
TSIbuf                           ; static buffer running ShowInt test cases
    data  0                      ; there is room for field size of 10
    data  0
    data  0
    data  0
    data  0
    data  0
    data  0
    data  0
    data  0
    data  0

;--------------------------------------------------------------------
; procedure PrintInt (x:int, fieldsize:int)
;--------------------------------------------------------------------

; High level algorithm
; PrintInt (x:int, fieldsize:int)
;   { print '(';
;     ShowInt (x, &TSIbuf, fieldsize);
;     print ')'; }

; Assembly language

; Arguments
;   R1 = x         = two's complement number to print
;   R2 = FieldSize = number of characters for print field
;        require FieldSize < FieldSizeLimit

; Structure of stack frame, frame size = 6
;    5[R14]  save R4
;    4[R14]  save R3
;    3[R14]  save R2 = argument fieldsize
;    2[R14]  save R1 = argument x
;    1[R14]  return address
;    0[R14]  dynamic link points to previous stack frame

PrintInt
; Create stack frame
    store  R14,0[R12]          ; save dynamic link
    add    R14,R12,R0          ; stack pointer := stack top
    lea    R12,6[R14]          ; stack top := stack ptr + frame size
    cmp    R12,R11             ; stack top ~ stack limit
    jumpgt StackOverflow[R0]   ; if top>limit then goto stack overflow
    store  R13,1[R14]          ; save return address
    store  R1,2[R14]           ; save R1
    store  R2,3[R14]           ; save R2
    store  R3,4[R14]           ; save R3
    store  R4,5[R14]           ; save R4
; print '('
    lea    R1,2[R0]             ; trap code for write
    lea    R2,LParen[R0]        ; &'('
    lea    R3,1[R0]             ; print 1 character
    trap   R1,R2,R3             ; print '('
; convert x to decimal and place in buffer
    load   R1,2[R14]            ; R1 := x = number to print
    lea    R2,TSIbuf[R0]        ; address of buffer
    load   R3,3[R14]            ; R3 := fieldsize
    jal    R13,ShowInt[R0]      ; convert x to string
; print the buffer    
    lea    R1,2[R0]             ; R1 := trap write code
    lea    R2,TSIbuf[R0]        ; R2 := &TSIbuf
    load   R3,3[R14]            ; R3 := fieldsize
    trap   R1,R2,R3
; print ')'
    lea    R1,2[R0]             ; trap code for write
    lea    R2,RParen[R0]        ; &')'
    lea    R3,1[R0]             ; string size is 1 character
    trap   R1,R2,R3             ; print ')'
; terminate the line
    jal    R13,WriteNewLine[R0]
; return
    load   R1,2[R14]        ; restore R1
    load   R2,3[R14]        ; restore R2
    load   R3,4[R14]        ; restore R3
    load   R13,1[R14]       ; restore return address
    load   R14,0[R14]       ; pop stack frame
    jump   0[R13]           ; return

;--------------------------------------------------------------------
; procedure WriteValChar
;--------------------------------------------------------------------

; WriteValChar (c:char);
; Write a character the character c in the output window
; If c isn't a valid character the result may be gibberish

; High level algorithm: WriteValChar would just be a system primitive

; WriteValChar(c): low level
;   writecode := 2;
;   stringlength := 2;
;   trap (writecode, c, stringlength);

;------------------------------------------------------------------
; WriteValChar: assembly language

; Arguments
;    R1 = c = the character to print
; Structure of stack frame, frame size = 6
;    5[R14]  local variable c
;    4[R14]  save R3
;    3[R14]  save R2
;    2[R14]  save R1
;    1[R14]  return address
;    0[R14]  pointer to previous stack frame

WriteValChar
; Create stack frame
    store  R14,0[R12]          ; save dynamic link
    add    R14,R12,R0          ; stack pointer := stack top
    lea    R12,6[R14]          ; stack top := stack ptr + frame size
    cmp    R12,R11             ; stack top ~ stack limit
    jumpgt StackOverflow[R0]   ; if top>limit then goto stack overflow
    store  R13,1[R14]          ; save return address
    store  R1,2[R14]           ; save R1
    store  R2,3[R14]           ; save R2
    store  R3,4[R14]           ; save R3

    store  R1,5[R14]        ; local c := R1 = char to write
    lea    R1,2[R0]         ; trap write code
    lea    R2,5[R14]        ; address of character to write
    lea    R3,1[R0]         ; one char
    trap   R1,R2,R3         ; trap write

    load   R1,2[R14]        ; restore R1
    load   R2,3[R14]        ; restore R2
    load   R3,4[R14]        ; restore R3
    load   R13,1[R14]       ; restore return address
    load   R14,0[R14]       ; pop stack frame
    jump   0[R13]           ; return

;--------------------------------------------------------------------
; procedure ShowInt: convert integer to decimal string
;--------------------------------------------------------------------

; Convert a two's complement integer x to a string
; Put the string in memory at *bufstart
; Do not exceed bufsize characters

; procedure ShowInt converts an integer x to a decimal string, to be
; stored in an array of characters at address bufstart, with the
; string size limited to bufsize.  If x is negative, a minus sign is
; inserted.  If the buffer is larger than needed, leading spaces are
; inserted.  If the buffer is too small to hold the number, it is
; filled with # characters.  The procedure returns the number of
; leading spaces; this enables the caller to find the non-space part
; of the string by adding that number to the buffer address.  Every 16
; bit two's complement number can be shown using 6 characters,
; e.g. -30000.

;------------------------------------------------------------------
; ShowInt: high level algorithm

; procedure ShowInt (x:Int, *bufstart:Char, bufsize:Int) : Int
;  { negative : Bool;
;    *bufend : Char;
;    q, r : Int;
;    negative := False;
;    bufend := bufstart + bufsize - 1  ; ptr to last char in buf
;    if x < 0
;      then { x := -x;
;             negative := True; }
;    p := bufend;
;    repeat
;      { (x,r) := x divmod 10
;        *p := digits[r];
;        p := p - 1; }
;        until x = 0 || p < bufstart;
;    if x > 0 || (negative && p < bufstart)
;      then { p := bufstart;
;             while p <= bufend do
;               { *p := HashChar
;                  p := p + 1; }
;             k := 0; }
;      else { if negative
;               then { *p := MinusSign
;                      p := p - 1; }
;             k := p + 1 - bufstart;
;             while p >= bufstart do
;               { *p := Space;
;                  p := p - 1;} }
;    return k; }

;------------------------------------------------------------------
; ShowInt: low level algorithm

; INSERT SOLUTION HERE
;   negative := 0
;   bufend := bufstart + bufsize - 1
;   if x >= 0 goto firstexit
;       x := 0 - x
;       negative := 1
; firstexit
;   p := bufend
; repeat
;   if x == 0 goto secondexit
;   if p < bufstart goto secondexit
;       (x,r) := x divmod 10
;       *p := digits[r]
;       p := p - 1
;       goto repeat
; secondexit
;   if x > 0 goto then
;   if negative == 0 goto else
;   if p >= bufstart goto else
; then
;       p := bufstart
; while
;       if p > bufend goto thirdexit
;           *p := HashChar
;            p := p + 1
;       goto while
; thirdexit
;       k := 0
; else
;       if negative == 0 goto fourthexit
;           *p := MinusSign
;            p := p + 1
; fourthexit
;    k := p + 1 - bufstart
; secondwhile
;       if p < bufstart goto fifthexit
;           *p := Space
;            p := p - 1
;       goto secondwhile
; fifthexit
;    return k

;--------------------------------------------------------------------
; ShowInt: assembly language

; Arguments (x:Int, *bufstart:Char, bufsize:Int)
;   R1 = x = integer to convert
;   R2 = bufstart = address of string
;   R3 = bufsize = number of characters in string
;   R12 = return address
; Result
;   R1 = k = number of leading spaces; -1 if overflow

; Local register usage
;   R4  = constant 1
;   R5  = negative
;   R6  = bufend
;   R7  = p
;   R8  = temp
;   R9  = r
;   R10 = constant 10

; Structure of stack frame, frame size = 12
;  11[R14]  save R10
;  10[R14]  save R9
;   9[R14]  save R8
;   8[R14]  save R7
;   7[R14]  save R6
;   6[R14]  save R5
;   5[R14]  save R4
;   4[R14]  save R3
;   3[R14]  save R2
;   2[R14]  save R1
;   1[R14]  return address
;   0[R14]  dynamic link points to previous stack frame

ShowInt
; Create stack frame
    store  R14,0[R12]          ; save dynamic link
    add    R14,R12,R0          ; stack pointer := stack top
    lea    R12,12[R14]          ; stack top := stack ptr + frame size
    cmp    R12,R11             ; stack top ~ stack limit
    jumpgt StackOverflow[R0]   ; if top>limit then goto stack overflow
    store  R13,1[R14]          ; save return address
    store  R1,2[R14]           ; save R1
    store  R2,3[R14]           ; save R2
    store  R3,4[R14]           ; save R3
    store  R4,5[R14]           ; save R4
    store  R5,6[R14]           ; save R5
    store  R6,7[R14]           ; save R6
    store  R7,8[R14]           ; save R7
    store  R8,9[R14]           ; save R8
    store  R9,10[R14]          ; save R9
    store  R10,11[R14]         ; save R10

; INSERT SOLUTION HERE
    add    R5,R0,R0
    add    R6,R2.R3
    sub    R6,R6,R4
    cmplt  R8,R1,R0
    jumpf  R8,firstexit[R0]
    sub    R1,R0,R1
    lea    R5,1[R0]
firstexit
    add    R7,R0,R6
repeat
    cmpeq  R8,R1,R0
    jumpt  R8,secondexit[R0]
    cmplt  R8,R7,R2
    jumpt  R8,secondexit[R0]
    div    R1,R1,R10
    add    R9,R0,R15
    lea    R7,digits[R9] ; ????!!!
    sub    R7,R7,R4
    jump   repeat[R0]
secondexit
    cmpgt  R8,R1,R0
    jumpt  R8,then[R0]
    cmpeq  R8,R5,R0
    jumpt  R8,else[R0]
    cmplt  R8,R7,R2
    jumpf  R8,else[R0]
then
    add    R7,R0,R2
while
    cmpgt  R8,R7,R6
    jumpt  R8,thirdexit[R0]
    lea    R7,Hash[R0] ; ????!!!
    add    R7,R7,R4
    jump   while[R0]
thirdexit
    add    R1,R0,R0
else
    cmpeq  R8,R5,R0
    jumpt  R8,fourthexit[R0]
    lea    R7,MinusSign[R0] ; ???!!!
    add    R7,R7,R4
fourthexit
    add    R1,R7,R4
    sub    R1,R1,R2
secondwhile
    cmplt  R8,R7,R2
    jumpt  R8,fifthexit[R0]
    lea    R7,Space[R0]  ; ???!!!
    sub    R7,R7,R4
    jump   secondwhile[R0]
fifthexit
    


SIend
; return
    load   R1,2[R14]         ; save R1
    load   R2,3[R14]         ; save R2
    load   R3,4[R14]         ; save R3
    load   R4,5[R14]         ; save R4
    load   R5,6[R14]         ; save R5
    load   R6,7[R14]         ; save R6
    load   R7,8[R14]         ; save R7
    load   R8,9[R14]         ; save R8
    load   R9,10[R14]        ; save R9
    load   R10,11[R14]       ; save R10
    load   R13,1[R14]        ; save return address
    load   R14,0[R14]       ; pop stack frame    
    jump   0[R13]           ; return

;--------------------------------------------------------------------
; procedure WriteNewLine
;--------------------------------------------------------------------

; write a newline character

; Structure of stack frame, frame size = 5
;  4[R14]  save R3
;  3[R14]  save R2
;  2[R14]  save R1
;  1[R14]  return address
;  0[R14]  pointer to previous stack frame

WriteNewLine

; Create stack frame
    store  R14,0[R12]          ; save dynamic link
    add    R14,R12,R0          ; stack pointer := stack top
    lea    R12,6[R14]          ; stack top := stack ptr + frame size
    cmp    R12,R11             ; stack top ~ stack limit
    jumpgt StackOverflow[R0]   ; if top>limit then goto stack overflow
    store  R13,1[R14]          ; save return address
    store  R1,2[R14]           ; save R1
    store  R2,3[R14]           ; save R2
    store  R3,4[R14]           ; save R3

    lea    R1,2[R0]         ; trap write code
    lea    R2,NewLine[R0]   ; address of character to write
    lea    R3,1[R0]         ; write 1 character
    trap   R1,R2,R3         ; write
    load   R1,2[R14]        ; restore R1
    load   R2,3[R14]        ; restore R2
    load   R3,4[R14]        ; restore R3
    load   R13,1[R14]       ; restore return address
    load   R14,0[R14]       ; pop stack frame
    jump   0[R13]           ; return

;----------------------------------------------------------------------
StackOverflow
    lea    R1,2[R0]
    lea    R2,StackOverflowMessage[R0]
    lea    R3,15[R0]   ; string length
    trap   R1,R2,R3    ; print "Stack overflow\n"
    trap   R0,R0,R0    ; halt

StackOverflowMessage
    data    83   ; 'S'
    data   116   ; 't'
    data    97   ; 'a'
    data    99   ; 'c'
    data   107   ; 'k'
    data    32   ; ' '
    data   111   ; 'o'
    data   118   ; 'v'
    data   101   ; 'e'
    data   114   ; 'r'
    data   102   ; 'f'
    data   108   ; 'l'
    data   111   ; 'o'
    data   119   ; 'w'
    data    10   ; '\n'

;----------------------------------------------------------------------
; Character codes
;   http://www.asciitable.com/
;   https://en.wikipedia.org/wiki/List_of_Unicode_characters
;   https://unicode-table.com/en/

;   digit characters 0..9 have codes (in decimal) 48..57
;   lower case a..z have codes (in decimal) 97..122
;   upper case A..Z have codes (in decimal) 65..90

NewLine data   10   ; '\n'
Space   data   32   ; ' '
Hash    data   35   ; '#'
LParen  data   40   '('
RParen  data   41   '('
Minus   data   45   ; '-'

Digits
    data   48   ; '0'
    data   49   ; '1'
    data   50   ; '2'
    data   51   ; '3'
    data   52   ; '4'
    data   53   ; '5'
    data   54   ; '6'
    data   55   ; '7'
    data   56   ; '8'
    data   57   ; '9'

letters
    data   97   ; 'a'
    data   98   ; 'b'
    data   99   ; 'c'
    data  100   ; 'd'
    data  101   ; 'e'
    data  102   ; 'f'
    data  103   ; 'g'
    data  104   ; 'h'
    data  105   ; 'i'
    data  106   ; 'j'
    data  107   ; 'k'
    data  108   ; 'l'
    data  109   ; 'm'
    data  110   ; 'n'
    data  111   ; 'o'
    data  112   ; 'p'
    data  113   ; 'q'
    data  114   ; 'r'
    data  115   ; 's'
    data  116   ; 't'
    data  117   ; 'u'
    data  118   ; 'v'
    data  119   ; 'w'
    data  120   ; 'x'
    data  121   ; 'y'
    data  122   ; 'z'

LETTERS
    data   65   ; 'A'
    data   66   ; 'B'
    data   67   ; 'C'
    data   68   ; 'D'
    data   69   ; 'E'
    data   70   ; 'F'
    data   71   ; 'G'
    data   72   ; 'H'
    data   73   ; 'I'
    data   74   ; 'J'
    data   75   ; 'K'
    data   76   ; 'L'
    data   77   ; 'M'
    data   78   ; 'N'
    data   79   ; 'O'
    data   80   ; 'P'
    data   81   ; 'Q'
    data   82   ; 'R'
    data   83   ; 'S'
    data   84   ; 'T'
    data   85   ; 'U'
    data   86   ; 'V'
    data   87   ; 'W'
    data   88   ; 'X'
    data   89   ; 'Y'
    data   90   ; 'Z'

;----------------------------------------------------------------------
StackSize  data   4000
CallStack  data      0
; The call stack grows from this point onwards
; Don't define anything after this
;----------------------------------------------------------------------