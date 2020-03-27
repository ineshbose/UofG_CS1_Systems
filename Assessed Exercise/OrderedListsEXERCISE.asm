;--------------------------------------------------------------------

; Program OrderedListsEXERCISE

; John O'Donnell, 2019

; Exercise completed by INESH BOSE

; Tutor: Jack Parkinson

;--------------------------------------------------------------------



; This file is a partial solution for an assessed exercise which is

; described in a separate typeset document.  This file is extracted

; from the complete program, but it's missing a few sections of code.

; The exercise is to fill in the missing parts.  These are all marked

; with a comment of the form



; *** EXERCISE Insert <description of what to insert> here ***



;--------------------------------------------------------------------

; General description of the program



; The program performs a sequence of operations on ordered lists; the

; operations include insertion, deletion, and search.  The input is an

; array of records, where each record contains a code indicating which

; operation to perform, and arguments for the operation.  The input

; array is defined statically using data statements.



;--------------------------------------------------------------------

; Components of the program



; Main program: initialises the heap, traverses the array of commands,

;   and performs the commands



; Commands:

;    0 : CmdTerminate

;    1 : CmdInsert

;    2 : CmdDelete

;    3 : CmdSearch

;    4 : CmdPrint



; NewNode: returns a pointer to a new node; indicates error if

;   the heap is empty



; ReleaseNode: given a pointer to a node, inserts it into the heap

;   so the node can be reused



; ShowInt: converts an integer to a string, placing it in a buffer

;   of a specified size in memory.  The integer may be signed.

;   Leading spaces are inserted if the buffer size is larger than

;   required, and the buffer is filled with ### if the buffer size

;   isn't large enough



; BuildHeap: creates a list of available nodes and sets avail

;   to point to it



; WriteValChar: given a character in R1, prints it.  This isn't used

;   in the program, but it can be used for testing.



; WriteValIntFixedWidth: given an integer in R1, converts

;    it to a string of 6 characters and prints it



; WriteNewLine: prints a newline character, so next output

;    will go onto a new line in the output buffer



; WriteSpace: prints a space



; TestShowInt: a procedure that tests ShowInt by calling it on

;    various test data and prints the result.  It is good practice

;    to include testing software in a program.  Normally this

;    procedure is not called, but there is a commented-out call to it

;    near the beginning.



; Static data

;   Variables for the heap, the CallStack, and the InputData,

;   which is an array of records where each record contains a command



;********************************************************************

; High  level algorithm

;********************************************************************



; program OrderedLists



; The heap is a list constructed in the allocation area

;    *heap  : Word     ; address of the heap

;    *avail : Word     ; pointer to the list of available nodes

;    HeapSize : Int    ; number of nodes in the heap

;    heaplimit : Int   ; address of end of the heap



; Variables used to traverse the input data and the lists

;    *p, *q : word



; The input data is an array of records, each specifying an operation

;    Command : record

;       code : Int     ; specify which operation to perform

;       i    : Int     ; index into array of lists

;       x    : Int     ; value of list element



; The meaning of a command depends on the code:

;    0  terminate the program

;    1  insert x into list[i]

;    2  delete x from list[i]

;    3  return 1 if list[i] contains x, otherwise 0

;    4  print the elements of list[i]



; Each element of the array list is a linked list of Nodes

;    Node : record

;       value  : Int

;       *next  : Node



; Iterate over the commands in the input data.  Each command is a

; record containing three words: the code indicates what operation to

; perform, i is the index into the array of lists, and x is a data

; value.  The pointer to the current location in the array is

; InputPtr.  The iteration terminates when a Terminate command is

; encountered.



; Initialize

;    BuildHeap ()



; Execute the commands in the input data

;    finished := 0

;    while InputPtr <= InputEnd && not finished do

;       CurrentCode := (*InputPtr).code

;       p := list[*InputPtr]     ; linked list

;       x := (*InputPtr).x      ; value to insert, delete, search



;       case CurrentCode of

;          0 : <CmdTerminate>

;          1 : <CmdInsert>

;          2 : <CmdDelete>

;          3 : <CmdSearch>

;          4 : <CmdPrint>

;          else : <>

;       InputPtr := InputPtr + sizeof(Command)



; Terminate the program

;    halt



; <CmdTerminate>

;    finished := 1



; <CmdInsert>

; Insert x into list that p points to, maintaining sort ordering

;    while p /= nil

;       q := (*p).next

;       if q = nil || x <= (*q).value

;          then r := NewNode ()

;               (*r).value := x

;               (*r).next := q

;               (*p).next := r

;               p := nil

;          else p := q



; <CmdDelete>

; Delete first node whose value is x; p is header

;    q := (*p).next

;    while q /= nil

;       if (*q).value = x

;          then *p.next := *q.next

;               ReleaseNode(q)

;               q := nil

;          else p := q

;               q := (*q).next



; <CmdSearch>

; Determine whether x occurs in list p

;    found := False

;    p := *p.next    ; point to first element of list

;    while p /= nil && not found do

;       if (*p).value = x

;         then found := 1

;       p := (*p).next

;    if found

;      then write "yes"

;      else write "no"



; <CmdPrint>

; Print value field of each node in list p

;    p := *p.next    ; point to first element of list

;    while p /= nil do

;       WriteValIntFixedWidth ((*p).value)

;       p := (*p).next



;--------------------------------------------------------------------

; Operations on the heap

;--------------------------------------------------------------------



; Construct list of available nodes

; procedure BuildHeap ()

;    p := &heap 

;    heaplimit := p + HeapSize - sizeof(Node)

;    avail := p

;    while p < heaplimit

;       (*p).value := 0

;       q := p + sizeof(Node)

;       (*p).next := q

;       p := q

;    (*p).value := 0

;    (*p).next := 0



; function *NewNode () : Word

;    if avail = nil

;      then error "Out of heap"

;      else r := avail

;      avail := (*avail).next

;      return r



; procedure ReleaseNode (*q : Word)

;    *q.next := avail

;    avail := q



;--------------------------------------------------------------------

; Number conversion

;--------------------------------------------------------------------



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



; procedure ShowInt (x:Int, *bufstart:Char, bufsize:Int) : Int 

;   negative : Bool

;   *bufend : Char

;   q, r, i : Int

;   negative := False

;   bufend := bufstart + bufsize - 1  ; ptr to last char in buf

;   if x < 0

;     then x := -x

;          negative := True

;   p := bufend

;   repeat

;     r := x mod 10

;     x := x div 10

;     *p := digits[r]

;     p := p - 1

;     until x = 0 || p < bufstart

;   if x > 0 || (negative && p < bufstart)

;     then p := bufstart

;          while p <= bufend

;             *p := HashChar

;             p := p + 1

;          k := 0

;     else if negative

;            then *p := MinusSign

;                 p := p - 1

;          k := p + 1 - bufstart

;          while p >= bufstart

;            *p := Space

;            p := p - 1

;   return k 



;********************************************************************

; Low level algorithm

;********************************************************************



; Initialize

;    BuildHeap ()



; Execute the commands in the input data

;    finished := 0

; CommandLoop

;    if InputPtr > InputEnd then goto CommandLoopDone

;    if finished then goto CommandsDone

;    CurrentCode := (*InputPtr).code

;    p := list[*InputPtr]     ; linked list

;    x := (*InputPtr).x      ; value to insert, delete, search

;    if CurrentCode < = then goto CommandCodeElse

;    if CurrentCode > 4 then goto CommandCodeElse

;    goto +CurrentCode

;    goto CmdTerminate  ; 0

;    goto CmdInsert     ; 1

;    goto CmdDelete     ; 2

;    goto CmdSearch     ; 3

;    goto CmdPrint      ; 4

; CommandCodeElse :   ; skip invalid command, nothing to do

; AfterCmdCase :

;    InputPtr := InputPtr + sizeof(Command)

;    goto CommandLoop

; CommandLoopDone



; CmdTerminate:

;    finished := 1

;    goto CmdCaseDone



; CmdInsert:

; InsertListLoop:

;    if p = nil then goto InsertListLoopDone

;    q := (*p).next

;    if q = nil || x <= (*q).value then goto ILthen

; InsertListElse

;    p := q

;    goto InsertListAfterIf

; InsertListThen

;    r := NewNode ()

;    (*r).value := x

;    (*r).next := q

;    (*p).next := r

;    p := nil

; InsertListAfterIf

;    goto InsertListLoop

; InsertListLoopDone

;    goto CmdCaseDone



; CmdDelete:

; *** EXERCISE Insert low level algorithm for delete here ***

;    q := (*p).next

; DeleteListLoop:

;    if p = nil then goto DeleteListLoopDone

;    if (*q).value = x then goto DeleteListThen

; DeleteListElse:

;    p := q

;    q := (*q).next

;    goto DeleteListAfterIf

; DeleteListThen:

;    *p.next := *q.next

;    ReleaseNode(q)

;    q := nil

; DeleteListAfterIf

;    goto DeleteListLoop

; DeleteListLoopDone

;    goto CmdCaseDone



; CmdSearch:

; *** EXERCISE Insert low level algorithm for CmdSearch here ***

;    found := 0

;    p := *p.next

; SearchListLoop:

;    if p = nil && found /= 0 then goto SearchListLoopDone

;    if (*p).value /= x then goto SearchListLoopAfterIf

;    found := 1

; SearchListLoopAfterIf:

;    p := (*p).next

;    goto SearchListLoop

; SearchListLoopDone:

;    if found = 1 then goto SearchListThen:

; SearchListElse:

;    write "no"

; SearchListThen:

;    write "yes"

;    goto CmdCaseDone



; CmdPrint:

; *** EXERCISE Insert low level algorithm for CmdPrint here ***

;    p := *p.next

; PrintListLoop:

;    if p = nil then goto PrintListLoopDone

;    WriteValIntFixedWidth((*p).value)

;    p := (*p).next

;    goto PrintListLoop

; PrintListLoopDone:

;    goto CmdCaseDone



;--------------------------------------------------------------------

; procedure BuildHeap ()

;    p := &heap = &AllocationArea + StackSize

;    heaplimit := p + HeapSize - sizeof(Node)

;    avail := p

; BuildHeapLoop

;    if p >= heaplimit then goto HeapLoopDone

;    (*p).value := 0

;    q := p + sizeof(Node)

;    (*p).next := q

;    p := q

;    goto BuildHeapLoop

; HeapLoopDone

;    (*p).value := 0

;    (*p).next := 0

;    return



;--------------------------------------------------------------------

; function *NewNode () : Word

;    if avail /= nil then goto NewNodeElse

;    write "Out of heap"

;    halt

; NewNodeElse

;    r := avail

;    avail := (*avail).next

;    return r



;--------------------------------------------------------------------

; procedure ReleaseNode (*q : Word)

;    (*q).next := avail

;    avail := q

;    return



;--------------------------------------------------------------------

; procedure ShowInt (x:Int, *bufstart:Char, bufsize:Int) : Int 

;   negative := False

;   bufend := bufstart + bufsize - 1  ; ptr to last char in buf

;   if x >= 0 then goto NotNeg

;   x := -x

;   negative := True

; NotNeg

;   p := bufend



; DigitLoop

;     r := x mod 10

;     x := x div 10

;     *p := digits[r]

;     p := p - 1

;     if x = 0 then goto DigitLoopDone

;     if p < bufstart then goto DigitLoopDone

;     goto DigitLoop

; DigitLoopDone



;   if x > 0 then goto ShowIntTooBig

;   if negative /= 0 then goto ShowIntFinish

;   if not p >= bufstart then goto ShowIntFinish

;   goto ShowIntTooBig



; ShowIntTooBig

;   p := bufstart

; ShowIntHashLoop

;   if p < bufend then goto ShowIntHashLoopDone

;   *p := HashChar

;   p := p + 1

;   goto ShowIntHashLoop

; ShowIntHashLoopDone

;   k := 0

;   goto ShowIntDone



; ShowIntFinish

;   if not negative then goto ShowIntNotNeg

;   *p := MinusSign

;   p := p - 1

; ShowIntNotNeg

;   k := p + 1 - bufstart

; ShowIntSpaceLoop

;   if p < bufstart then goto ShowIntSpaceLoopDone

;   *p := Space

;   p := p - 1

;   goto ShowIntSpaceLoop

; ShowIntSpaceLoopDone

; ShowIntDone

;   return k 



;********************************************************************

; Assembly language implementation

;********************************************************************



;--------------------------------------------------------------------

; Global register usage

;--------------------------------------------------------------------



; R1, R2, R3 are used for parameters and return values

; R4 - R10 are available for local use



; The following registers are reserved for specific purposes:

; R0  = constant 0

; R11 = stack limit

; R12 = stack top

; R13 = return address

; R14 = stack pointer

; R15 = transient condition code



;--------------------------------------------------------------------

; Main program execution starts here

;--------------------------------------------------------------------



; Initialize the stack

; Structure of stack frame for main program, frame size = 1

;    0[R14]   dynamic link, the pointer to previous stack frame = nil



    lea    R14,CallStack[R0]   ; initialise stack pointer

    store  R0,0[R14]           ; main program dynamic link := nil

    lea    R12,1[R14]          ; initialise stack top

    load   R1,StackSize[R0]    ; R1 := stack size

    add    R11,R14,R1          ; StackLimit := &CallStack + StackSize



; Unit testing.  Comment this out for normal execution!  This

; instruction bypasses the normal program and performs the unit tests.



;    jump   TestShowInt[R0]    ; normally should be commented out



; Build the heap

    jal    R13,BuildHeap[R0]   ; build heap, set avail

  

; Initialize the command loop

    lea    R5,InputData[R0]    ; R5 := &InputData

    store  R5,InputPtr[R0]     ; InputPtr := &InputData



CommandLoop

    load   R5,InputPtr[R0]     ; R1 := InputPtr

    load   R4,0[R5]            ; R4 := *InputPtr.code

; Check for invalid code and ignore bad command

    cmp    R4,R0               ; compare (*InputPtr).code, 0

    jumplt CmdDone[R0]         ; skip invalid code (negative)

    lea    R6,4[R0]            ; maximum valid code

    cmp    R4,R6               ; compare code with max valid code

    jumpgt CmdDone[R0]         ; skip invalid code (too large)



; Load command arguments

; R1 = p : *Node   address of list header

; R2 = x : Int     value to insert into p

    load   R1,1[R5]            ; R1 := i = cmd argument

    store  R1,CmdArgI[R0]      ; CmdArgI := argument i

    add    R3,R1,R0            ; R3 := i

    add    R1,R1,R1            ; R1 := 2*i (element size is 2)

    lea    R1,list[R1]          ; R1 := &list[i] = pointer to the list

    store  R1,CmdArgP[R0]      ; CmdArgP := pointer to list argument

    load   R2,2[R5]            ; R2 := (*InputPtr).value to insert

    store  R2,CmdArgX[R0]      ; CmdArgX := argument x

; Jump to operation specified by code

    add    R4,R4,R4            ; code := 2*code

    lea    R5,CmdJumpTable[R0] ; R5 := pointer to jump table

    add    R4,R5,R4            ; address of jump to operation

    jump   0[R4]               ; jump to jump to operation

CmdJumpTable

    jump   CmdTerminate[R0]    ; code 0: terminate the program

    jump   CmdInsert[R0]       ; code 1: insert

    jump   CmdDelete[R0]       ; code 2: delete

    jump   CmdSearch[R0]       ; code 3: search

    jump   CmdPrint[R0]        ; code 4: print



CmdDone

    load   R5,InputPtr[R0]

    lea    R6,3[R0]

    add    R5,R5,R6

    store  R5,InputPtr[R0]

    jump   CommandLoop[R0]



CmdTerminate

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgTerminate[R0] ; R9 := &"Terminate\n"

    lea    R10,10[R0]          ; R10 := string length

    trap   R8,R9,R10           ; write "Terminate\n"

    trap   R0,R0,R0            ; terminate execution



;--------------------------------------------------------------------

; CmdInsert

;--------------------------------------------------------------------



CmdInsert

; Print out the command record

; print "Insert "

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgInsert[R0]    ; R9 := &"Insert\n"

    lea    R10,7[R0]           ; R10 := string length

    trap   R8,R9,R10           ; write "Insert\n"

; print x

;    add   R1,R5,R0            ; R1 = argument = x

    load   R1,CmdArgX[R0]      ; R1 = argument = x

    jal    R13,WriteValIntFixedWidth[R0]  ; write integer

; print " into list "     

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgInto[R0]      ; R9 := &" into list "

    lea    R10,11[R0]          ; R10 := string length

    trap   R8,R9,R10           ; write " into "

; print i

    add    R1,R3,R0            ; R1 = i = index of list to be inserted into

    jal    R13,WriteValIntFixedWidth[R0]  ; write integer

    jal    R13,WriteNewLine[R0]



; Register usage

; R5 = x    - value to insert into the list

; R6 = p    - current node in the list

; R7 = q    - next node in the list

; R8 = r    - newly allocated node

; R9 = temp



; Initialise registers for insertion algorithm

    load   R5,CmdArgX[R0]      ; R5 := x (value to insert)

    load   R6,CmdArgP[R0]      ; R6 := p (pointer to current node in list)



ILloop

; if p = nil then goto ILloopDone

    cmp    R6,R0               ; compare p, nil

    jumpeq ILloopDone[R0]      ; if p = nil then goto ILloopDone

    load   R7,1[R6]            ; q := (*p).next

; if q = nil || x <= (*q).value then goto ILthen

    cmp    R7,R0               ; compare q, nil

    jumpeq ILthen[R0]          ; if p = nil then goto ILthen

    load   R9,0[R7]            ; temp := (*q).value

    cmp    R5,R9               ; compare x, (*q).value

    jumple ILthen[R0]          ; if x <= (*q).value then goto ILthen

ILelse

    add    R6,R7,R0            ; p := q

    jump   ILafterIf[R0]       ; goto ILafterIf

ILthen

    jal    R13,NewNode[R0]     ; R1 := NewNode () 

    add    R8,R1,R0            ; r := NewNode ()

    store  R5,0[R8]            ; (*r).value := x

    store  R7,1[R8]            ; (*r).next := q

    store  R8,1[R6]            ; (*p).next := r

    add    R6,R0,R0            ; p := nil

ILafterIf

    jump   ILloop[R0]          ; goto ILloop

ILloopDone

    jump   CmdDone[R0]         ; go to finish command



;--------------------------------------------------------------------

; CmdDelete

;--------------------------------------------------------------------



; Delete the first node whose value is x.  If none is found,

; do nothing.



CmdDelete

; Print out the command record

; print "Delete "

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgDelete[R0]    ; R9 := &"Delete "

    lea    R10,7[R0]           ; R10 := string length

    trap   R8,R9,R10           ; write "Insert\n"

; print x

    load   R1,CmdArgX[R0]      ; R1 := x

    jal    R13,WriteValIntFixedWidth[R0]  ; write integer

; print " into list "     

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgFrom[R0]      ; R9 := &" from list "

    lea    R10,11[R0]          ; R10 := string length

    trap   R8,R9,R10           ; write " into "

; print i

    add    R1,R3,R0            ; R1 = i = index of list to be inserted into

    jal    R13,WriteValIntFixedWidth[R0]  ; write integer

    jal    R13,WriteNewLine[R0]



; *** EXERCISE Insert assembly language for CmdDelete here ***

; Register usage

; R5 = x    - value to delete from the list

; R6 = p    - current node in the list

; R7 = q    - next node in the list

; R8 = temp


; Initialise registers for deletion algorithm

    load   R5,CmdArgX[R0]      ; R5 := x (value to delete)

    load   R6,CmdArgP[R0]      ; R6 := p (pointer to current node in list)

    load   R7,1[R6]            ; q := (*p).next

DLloop

; if p = nil then goto DLloopDone

    cmp    R6,R0               ; compare p, nil

    jumpeq DLloopDone[R0]      ; if p = nil then goto DLloopDone

; if (*q).value = x then goto DLthen

    load   R8,0[R7]            ; temp := (*q).value

    cmp    R8,R5               ; compare (*q).value, x

    jumpeq DLthen[R0]          ; if (*q).value = x then goto DLthen

DLelse

    add    R6,R7,R0            ; p := q

    load   R7,1[R7]            ; q := (*q).next

    jump   DLafterIf[R0]       ; goto DLafterIf

DLthen

    load   R8,1[R7]            ; temp := *q.next

    store  R8,1[R6]            ; *p.next = temp

    add    R1,R7,R0            ; R1 := q

    jal    R13,ReleaseNode[R0] ; R1 := ReleaseNode(q)

    add    R7,R0,R0            ; q := nil

DLafterIf

    jump   DLloop[R0]          ; goto DLloop

DLloopDone

    jump   CmdDone[R0]         ; go to finish command



;--------------------------------------------------------------------

; CmdSearch

;--------------------------------------------------------------------



CmdSearch

; Print out the command record

; print "Search list "

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgSearch[R0]    ; R9 := &"Insert\n"

    lea    R10,12[R0]          ; R10 := string length

    trap   R8,R9,R10           ; write "Insert\n"

; print i

    add    R1,R3,R0            ; R1 = i = index of list to be inserted into

    jal    R13,WriteValIntFixedWidth[R0]  ; write integer

; print " for "

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgFor[R0]       ; R9 := &"Insert\n"

    lea    R10,5[R0]           ; R10 := string length

    trap   R8,R9,R10           ; write "Insert\n"

; print x

;     add    R1,R5,R0       ; R1 = argument = x

    load   R1,CmdArgX[R0]      ; R1 = argument = x

    jal    R13,WriteValIntFixedWidth[R0]  ; write integer

    jal    R13,WriteNewLine[R0]



; *** EXERCISE Insert assembly language for CmdSearch here ***

; Register usage

; R5 = x      - value to search from the list

; R6 = p      - current node in the list

; R7 = found  - boolean value

; R8 = temp


; Initialise registers for search algorithm

    load   R5,CmdArgX[R0]      ; R5 := x (value to search)

    load   R6,CmdArgP[R0]      ; R6 := p (pointer to current node in list)

    lea    R7,0[R0]            ; R7 := 0 (false)


SLloop

; if p = nil && found /= 0 then goto SLloopDone

    cmp    R6,R0               ; compare p, nil

    jumpeq SLloopDone[R0]      ; if p = nil then goto SLloopDone

    cmp    R7,R0               ; compare found, 0

    jumpne SLloopDone[R0]      ; if found /= 0 then goto SLloopDone

    load   R8,0[R6]            ; temp := *p.value

    cmp    R8,R5               ; compare *p.value, x

    jumpne SLloopAfterIf[R0]   ; if *p.value /= x then goto SLloopAfterIf

    lea    R7,1[R0]            ; R7 := 1 (true)

SLloopAfterIf

    load   R6,1[R6]            ; p := *p.next

    jump   SLloop[R0]          ; goto SLloop

SLloopDone

    lea    R8,1[R0]            ; temp := 1

    cmp    R7,R8               ; compare found, temp

    jumpeq SLthen[R0]          ; if found = temp then goto SLthen

SLelse

; print "No"

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgNo[R0]        ; R9 := &"No"

    lea    R10,2[R0]           ; R10 := string length

    trap   R8,R9,R10           ; write "No"

    jump   SLafterIf[R0]       ; goto SLafterIf

SLthen

; print "Yes"

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgYes[R0]       ; R9 := &"Yes"

    lea    R10,3[R0]           ; R10 := string length

    trap   R8,R9,R10           ; write "Yes"

SLafterIf

    jal    R13,WriteNewLine[R0]

    jump   CmdDone[R0]         ; go to finish command



;--------------------------------------------------------------------

; CmdPrint

;--------------------------------------------------------------------



CmdPrint

; Print out the command record

; print "Print list "

    lea    R8,2[R0]            ; R8 := trap code for write

    lea    R9,MsgPrint[R0]     ; R9 := &"Print list "

    lea    R10,11[R0]          ; R10 := string length

    trap   R8,R9,R10           ; write "Insert\n"

; print i

    add    R1,R3,R0            ; R1 = i = index of list argument

    jal    R13,WriteValIntFixedWidth[R0]  ; write integer

    jal    R13,WriteNewLine[R0]



; *** EXERCISE Insert assembly language for CmdPrint here ***

; Register usage

; R5 = p      - current node in the list

; R6 = temp


; Initialise registers for printing algorithm

    load   R5,CmdArgP[R0]      ; R5 := p (pointer to current node in list)


PLloop

    cmp    R5,R0               ; compare p, nil

    jumpeq PLloopDone[R0]      ; if p = nil then goto PLloopDone

    load   R1,0[R5]            ; R1 := *p.value

    jal    R13,WriteValIntFixedWidth[R0] ; write integer

    load   R5,1[R5]            ; p := *p.next

    jump   PLloop[R0]          ; goto PLloop

PLloopDone

    jal    R13,WriteNewLine[R0]

    jump   CmdDone[R0]         ; go to finish command



;--------------------------------------------------

; BuildHeap

;--------------------------------------------------



; R4 = p

; R5 = heaplimit

; R6 = q

; R7 = sizeof(Node) = 2

; R8 = avail

; R13 = return address



; As BuildHeap is used only for initialization, it doesn't build a

; stack frame or save and restore registers



BuildHeap



; Calculate the start and end addresses and set avail

    lea    R4,AllocationArea[R0] ; p := address of allocation area

    load   R5,StackSize[R0]    ; R5 := size of data before heap

    add    R4,R4,R5            ; p := &heap

    store  R4,HeapStart[R0]    ; HeapStart := address of heap

    lea    R7,2[R0]            ; R7 := sizeof(Node) = 2

    load   R5,HeapSize[R0]     ; R5 := HeapSize

    add    R5,R4,R5            ; HeapLimit := p + HeapSize

    sub    R5,R5,R7            ; HeapLimit := p + HeapSize - sizeof(Node)

    add    R8,R4,R0            ; avail := p

    store  R8,avail[R0]        ; save static variable avail



; Iterate over heap area to construct avail list

BuildHeapLoop

    cmp    R4,R5               ; compare p, heaplimit

    jumpge FinishHeap[R0]      ; if p >= heaplimit then goto FinishHeap

    store  R0,0[R4]            ; (*p).value := 0

    add    R6,R4,R7            ; q := p + 2 

    store  R6,1[R4]            ; (*p).next := q

    add    R4,R6,R0            ; p := q

    jump   BuildHeapLoop[R0]   ; goto BuildHeapLoop

FinishHeap

    store  R0,0[R4]            ; (*p).value := 0

    store  R0,1[R4]            ; (*p).next := 0

    jump   0[R13]              ; return



;--------------------------------------------------------------------

; NewNode: allocate a new node from the heap

;--------------------------------------------------------------------



; R1 = return result = pointer to new node

; Uses avail, a static global variable

; R13 = return address

; R2 = avail



; Structure of stack frame for NewNode, frame size = 4

;   3[R14]  save R2

;   2[R14]  save R1

;   1[R14]  return address

;   0[R14]  pointer to previous stack frame



NewNode

; Create stack frame

    store  R14,0[R12]          ; save dynamic link

    add    R14,R12,R0          ; stack pointer := stack top

    lea    R12,4[R14]          ; stack top := stack ptr + frame size

    cmp    R12,R11             ; stack top ~ stack limit

    jumpgt StackOverflow[R0]   ; if top>limit then goto stack overflow

    store  R13,1[R14]          ; save return address

    store  R1,2[R14]           ; save R1

    store  R2,3[R14]           ; save R2



; Allocate new node

    load   R2,avail[R0]        ; R2 := avail

    cmp    R2,R0               ; compare avail, nil

    jumpeq OutOfHeap[R0]       ; if avail = nil then goto OutOfHeap

    add    R1,R2,R0            ; result = avail

    load   R2,1[R2]            ; avail := avail.next

    store  R2,avail[R0]        ; save avail

; Return

;                              ; R1 = return result

    load   R2,3[R14]           ; restore R2

    load   R13,1[R14]          ; restore return address

    add    R12,R14,R0          ; R12 := R14, restore stack top

    load   R14,0[R14]          ; pop stack frame

    jump   0[R13]              ; return

  

OutOfHeap

    lea    R1,2[R0]            ; trap code for write

    lea    R5,HeapMsg[R0]      ; R5 := address of error message

    lea    R6,12[R0]           ; R6 := length of message

    trap   R1,R5,R6            ; write error message

    trap   R0,R0,R0            ; terminate

HeapMsg

; for character codes, see https://www.ascii.cl/htmlcodes.htm

    data    79  ; 'O'

    data   117  ; 'u'

    data   116  ; 't'

    data    32  ; ' '

    data   111  ; 'o'

    data   102  ; 'f'

    data    32  ; ' '

    data   104  ; 'h'

    data   101  ; 'e'

    data    97  ; 'a'

    data   112  ; 'p'

    data    10  ; '\n'



;--------------------------------------------------------------------

; ReleaseNode: deallocate a node and add it to the avail list

;--------------------------------------------------------------------



ReleaseNode



; *** EXERCISE Insert assembly language for ReleaseNode here ***

    store  R14,0[R12]          ; save dynamic link

    add    R14,R12,R0          ; stack pointer := stack top

    lea    R12,12[R14]         ; stack top := stack ptr + frame size

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


    load   R2,avail[R0]        ; temp := avail

    store  R2,1[R1]            ; *q.next := temp

    store  R1,avail[R0]        ; avail := q

    jump   0[R13]              ; return



; search (key)

;   p := &database

;   found := 0

;   while p /= nil && not found

;     q := (*p).next

;     if (*q).value = key 



WriteValChar

; Write a character in R1

; Structure of stack frame, frame size = 6

;    5[R14]  local variable c

;    4[R14]  save R3

;    3[R14]  save R2

;    2[R14]  save R1

;    1[R14]  return address

;    0[R14]  pointer to previous stack frame



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



    store   R1,5[R14]          ; local c := R1 = char to write

    lea     R1,2[R0]           ; trap write code

    lea     R2,5[R14]          ; address of character to write

    lea     R3,1[R0]           ; one char

    trap    R1,R2,R3           ; trap write



    load    R1,2[R14]          ; restore R1

    load    R2,3[R14]          ; restore R2

    load    R3,4[R14]          ; restore R3

    load    R13,1[R14]         ; restore return address

    add    R12,R14,R0          ; R12 := R14, restore stack top

    load    R14,0[R14]         ; pop stack frame

    jump    0[R13]             ; return





WriteValIntFixedWidth

; Write an integer in R1, using a 6 character field

; Structure of stack frame, frame size = 11

;   10[R14]  string buffer [5]

;    9[R14]  string buffer [4]

;    8[R14]  string buffer [3]

;    7[R14]  string buffer [2]

;    6[R14]  string buffer [1]

;    5[R14]  string buffer [0]

;    4[R14]  save R3

;    3[R14]  save R2

;    2[R14]  save R1

;    1[R14]  return address

;    0[R14]  pointer to previous stack frame



; Create stack frame

    store  R14,0[R12]          ; save dynamic link

    add    R14,R12,R0          ; stack pointer := stack top

    lea    R12,11[R14]         ; stack top := stack ptr + frame size

    cmp    R12,R11             ; stack top ~ stack limit

    jumpgt StackOverflow[R0]   ; if top>limit then goto stack overflow

    store  R13,1[R14]          ; save return address

    store  R1,2[R14]           ; save R1

    store  R2,3[R14]           ; save R2

    store  R3,4[R14]           ; save R3



; Call ShowInt to convert integer in R1 to a string

    lea     R2,5[R14]          ; address of string buffer

    lea     R3,6[R0]           ; size of string

    jal     R13,ShowInt[R0]    ; call ShowInt

    

; Print the string

    lea     R1,2[R0]           ; trap write code

    lea     R2,5[R14]          ; address of string buffer

    lea     R3,6[R0]           ; 6 characters

    trap    R1,R2,R3           ; trap write



; return

    load   R1,2[R14]           ; save R1

    load   R2,3[R14]           ; save R2

    load   R3,4[R14]           ; save R3

    load   R13,1[R14]          ; restore return address

    add    R12,R14,R0          ; R12 := R14, restore stack top

    load   R14,0[R14]          ; pop stack frame

    jump   0[R13]              ; return



; buffer for the procedure

WVIFWbuf    data   0

            data   0

            data   0

            data   0

            data   0

            data   0

            data   0



;--------------------------------------------------------------------

; ShowInt: convert an integer to a string of 6 characters

;--------------------------------------------------------------------



; Arguments (x:Int, *bufstart:Char, bufsize:Int)

;   R1 = x = integer to convert

;   R2 = bufstart = address of string

;   R3 = bufsize = number of characters in string

;   R12 = return address

; Result

;   R1 = k = number of leading spaces; -1 if overflow



; Structure of stack frame for ShowInt, frame size = 12

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

;   0[R14]  dynamic link, pointer to previous stack frame



; Local register usage

;   R4  = constant 1

;   R5  = negative

;   R6  = bufend

;   R7  = p

;   R8  = temp

;   R9  = r

;   R10 = constant 10



ShowInt

; Create stack frame

    store  R14,0[R12]          ; save dynamic link

    add    R14,R12,R0          ; stack pointer := stack top

    lea    R12,12[R14]         ; stack top := stack ptr + frame size

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



    lea    R4,1[R0]            ; R4 := constant 1

    lea    R10,10[R0]          ; R10 := constant 10

    add    R5,R0,R0            ; negative := False

    add    R6,R2,R3            ; bufend := bufstart + bufsize

    sub    R6,R6,R4            ; bufend := bufstart + bufsize - 1



    cmp    R1,R0               ; compare x, 0

    jumpge SInotNeg[R0]        ; if nonnegative then goto SInotNeg

    sub    R1,R0,R1            ; x := -x

    add    R5,R1,R0            ; negative := True

SInotNeg

    add    R7,R6,R0            ; p := bufend



SIdigLp

    div    R1,R1,R10           ; x := x div 10

    add    R9,R15,R0           ; r := x mod 10

    load   R8,Digits[R9]       ; temp := Digits[r]

    store  R8,0[R7]            ; *p := digits[r]

    sub    R7,R7,R4            ; p := p - 1

    cmp    R1,R0

    jumpeq SIdigLpEnd[R0]      ; if x = 0 then goto SIdigLpEnd

    cmp    R7,R2               ; compare p, bufstart

    jumplt SIdigLpEnd[R0]      ; if p < bufstart then goto SIdigLpEnd

    jump   SIdigLp[R0]         ; goto SIdigLp

SIdigLpEnd



    cmp    R1,R0               ; compare x, 0

    jumpgt SItooBig[R0]        ; if x > 0 then goto SItooBig

    cmp    R5,R0               ; is x negative?

    jumpeq SIfinish[R0]        ; if nonnegative then goto SIfinish

    cmp    R7,R2               ; compare p, bufstart

    jumpge SIfinish[R0]        ; if p >= bufstart then goto SIfinish

    jump   SItooBig[R0]        ; goto SItooBig



SItooBig

    add    R7,R2,R0            ; p := bufstart

SIhashLp

    cmp    R7,R6               ; compare p, bufend

    jumpgt SIhashLpEnd[R0]     ; if p > bufend then goto SIhashLpEnd

    load   R8,Hash[R0]         ; R8 := '#'

    store  R8,0[R7]            ; *p := '#'

    add    R7,R7,R4            ; p := p + 1

    jump   SIhashLp[R0]        ; goto SIhashLp

SIhashLpEnd

    add    R1,R0,R0            ; k := 0

    jump   SIend[R0]           ; goto SIend



SIfinish

    cmp    R5,R0               ; compare R5, False

    jumpeq SInoMinus[R0]       ; if not negative then goto SInoMinus

    load   R8,Minus[R0]        ; R8 := '-'

    store  R8,0[R7]            ; *p := '-'

    sub    R7,R7,R4            ; p := p - 1

SInoMinus

    add    R1,R7,R4            ; k := p + 1

    sub    R1,R1,R2            ; k := p + 1 - bufstart

SIspaceLp

    cmp    R7,R2               ; compare p, bufstart

    jumplt SIspaceLpEnd[R0]    ; if p < bufstart then goto SIspaceLpEnd

    load   R8,Space[R0]        ; temp := ' '

    store  R8,0[R7]            ; *p := ' '

    sub    R7,R7,R4            ; p := p - 1

    jump SIspaceLp[R0]         ; goto SIspaceLp

SIspaceLpEnd



SIend

; return

    load   R1,2[R14]           ; save R1

    load   R2,3[R14]           ; save R2

    load   R3,4[R14]           ; save R3

    load   R4,5[R14]           ; save R4

    load   R5,6[R14]           ; save R5

    load   R6,7[R14]           ; save R6

    load   R7,8[R14]           ; save R7

    load   R8,9[R14]           ; save R8

    load   R9,10[R14]          ; save R9

    load   R10,11[R14]         ; save R10

    load   R13,1[R14]          ; save return address

    add    R12,R14,R0          ; R12 := R14, restore stack top

    load   R14,0[R14]          ; pop stack frame    

    jump   0[R13]              ; return



; Write a space

WriteSpace

; Structure of stack frame for WriteSpace, frame size = 5

;  4[R14]  save R3

;  3[R14]  save R2

;  2[R14]  save R1

;  1[R14]  return address

;  0[R14]  pointer to previous stack frame



    store  R14,0[R12]          ; save dynamic link

    add    R14,R12,R0          ; stack pointer := stack top

    lea    R12,5[R14]          ; stack top := stack ptr + frame size

    cmp    R12,R11             ; stack top ~ stack limit

    jumpgt StackOverflow[R0]   ; if top>limit then goto stack overflow

    store  R13,1[R14]          ; save return address

    store  R1,2[R14]           ; save R1

    store  R2,3[R14]           ; save R2

    store  R3,4[R14]           ; save R3



    lea    R1,2[R0]            ; trap write code

    lea    R2,Space[R0]        ; address of character to write

    lea    R3,1[R0]            ; write 1 character

    trap   R1,R2,R3            ; write

    load   R1,2[R14]           ; restore R1

    load   R2,3[R14]           ; restore R2

    load   R3,4[R14]           ; restore R3

    load   R13,1[R14]          ; restore return address

    add    R12,R14,R0          ; R12 := R14, restore stack top

    load   R14,0[R14]          ; pop stack frame

    jump   0[R13]              ; return



; Write a newline

WriteNewLine



; Structure of stack frame for WriteNewLine, frame size = 5

;  4[R14]  save R3

;  3[R14]  save R2

;  2[R14]  save R1

;  1[R14]  return address

;  0[R14]  pointer to previous stack frame



    store  R14,0[R12]          ; save dynamic link

    add    R14,R12,R0          ; stack pointer := stack top

    lea    R12,5[R14]          ; stack top := stack ptr + frame size

    cmp    R12,R11             ; stack top ~ stack limit

    jumpgt StackOverflow[R0]   ; if top>limit then goto stack overflow

    store  R13,1[R14]          ; save return address

    store  R1,2[R14]           ; save R1

    store  R2,3[R14]           ; save R2

    store  R3,4[R14]           ; save R3



    lea    R1,2[R0]            ; trap write code

    lea    R2,NewLine[R0]      ; address of character to write

    lea    R3,1[R0]            ; write 1 character

    trap   R1,R2,R3            ; write

    load   R1,2[R14]           ; restore R1

    load   R2,3[R14]           ; restore R2

    load   R3,4[R14]           ; restore R3

    load   R13,1[R14]          ; restore return address

    add    R12,R14,R0          ; R12 := R14, restore stack top

    load   R14,0[R14]          ; pop stack frame

    jump   0[R13]              ; return



;--------------------------------------------------------------------

; Test code

;--------------------------------------------------------------------



; The following can be used to test various procedures.  You can cut

; and paste them into the start of the program.  It's a good idea to

; develop testing code, and to keep it in the program (disabled).



    jump   OutOfHeap[R0]       ; test printing error message



TestShowInt



; 264 in 2 characters

    lea    R1,264[R0]       ; number to print

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,2[R0]         ; size of buffer to use

    jal    R13,ShowInt[R0]  ; put string for R1 into buffer

    add    R4,R1,R0         ; R4 = number of leading spaces

    lea    R1,2[R0]         ; trap write code

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,2[R0]         ; size of buffer to use

    trap   R1,R2,R3

    jal    R13,WriteNewLine[R0]



; -1 in 2 characters

    lea    R1,-1[R0]        ; number to print

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,2[R0]         ; size of buffer to use

    jal    R13,ShowInt[R0]  ; put string for R1 into buffer

    add    R4,R1,R0         ; R4 = number of leading spaces

    lea    R1,2[R0]         ; trap write code

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,2[R0]         ; size of buffer to use

    trap   R1,R2,R3

    jal    R13,WriteNewLine[R0]



; 47 in 5 characters

    lea    R1,47[R0]        ; number to print

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,5[R0]         ; size of buffer to use

    jal    R13,ShowInt[R0]  ; put string for R1 into buffer

    add    R4,R1,R0         ; R4 = number of leading spaces

    lea    R1,2[R0]         ; trap write code

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,5[R0]         ; size of buffer to use

    trap   R1,R2,R3

    jal    R13,WriteNewLine[R0]



; 264 in 5 characters

    lea    R1,264[R0]       ; number to print

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,5[R0]         ; size of buffer to use

    jal    R13,ShowInt[R0]  ; put string for R1 into buffer

    add    R4,R1,R0         ; R4 = number of leading spaces

    lea    R1,2[R0]         ; trap write code

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,5[R0]         ; size of buffer to use

    trap   R1,R2,R3

    jal    R13,WriteNewLine[R0]



; 29371 in 5 characters

    lea    R1,29371[R0]     ; number to print

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,5[R0]         ; size of buffer to use

    jal    R13,ShowInt[R0]  ; put string for R1 into buffer

    add    R4,R1,R0         ; R4 = number of leading spaces

    lea    R1,2[R0]         ; trap write code

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,5[R0]         ; size of buffer to use

    trap   R1,R2,R3

    jal    R13,WriteNewLine[R0]



; -92 in 4 characters

    lea    R1,-92[R0]       ; number to print

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,3[R0]         ; size of buffer to use

    jal    R13,ShowInt[R0]  ; put string for R1 into buffer

    add    R4,R1,R0         ; R4 = number of leading spaces

    lea    R1,2[R0]         ; trap write code

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,3[R0]         ; size of buffer to use

    trap   R1,R2,R3

    jal    R13,WriteNewLine[R0]



; 6285 in 4 characters

    lea    R1,6285[R0]      ; number to print

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,4[R0]         ; size of buffer to use

    jal    R13,ShowInt[R0]  ; put string for R1 into buffer

    add    R4,R1,R0         ; R4 = number of leading spaces

    lea    R1,2[R0]         ; trap write code

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,4[R0]         ; size of buffer to use

    trap   R1,R2,R3

    jal    R13,WriteNewLine[R0]



; 6285 in 3 characters

    lea    R1,6285[R0]      ; number to print

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,3[R0]         ; size of buffer to use

    jal    R13,ShowInt[R0]  ; put string for R1 into buffer

    add    R4,R1,R0         ; R4 = number of leading spaces

    lea    R1,2[R0]         ; trap write code

    lea    R2,TSIbuf[R0]    ; address of buffer

    lea    R3,3[R0]         ; size of buffer to use

    trap   R1,R2,R3

    jal    R13,WriteNewLine[R0]



    trap   R0,R0,R0         ; halt after unit testing



TSIbuf

    data  0

    data  0

    data  0

    data  0

    data  0

    data  0

    data  0



;--------------------------------------------------------------------

; Data area

;--------------------------------------------------------------------



; AllocationArea is the address of all the memory space after the

; program and the static data.  Large objects such as arrays, the call

; stack, and the heap, are placed in the AllocationArea, and their

; addresses must be calculated by the program.  This should be the

; very last definition in the program.  Don't define anything after

; after it: no data statements, no instructions.



;--------------------------------------------------------------------

; String constants for the user program

;--------------------------------------------------------------------



MsgInsert

    data   73   ; 'I'

    data  110   ; 'n'

    data  115   ; 's'

    data  101   ; 'e'

    data  114   ; 'r'

    data  116   ; 't'

    data   32   ; ' '



MsgDelete

    data   68   ; 'D'

    data  101   ; 'e'

    data  108   ; 'l'

    data  101   ; 'e'

    data  116   ; 't'

    data  101   ; 'e'

    data   32   ; ' '



MsgPrint

    data   80   ; 'P'

    data  114   ; 'r'

    data  105   ; 'i'

    data  110   ; 'n'

    data  116   ; 't'

    data   32   ; ' '

    data  108   ; 'l'

    data  105   ; 'i'

    data  115   ; 's'

    data  116   ; 't'

    data   32   ; ' '



MsgSearch

    data   83   ; 'S'

    data  101   ; 'e'

    data   97   ; 'a'

    data  114   ; 'r'

    data   99   ; 'c'

    data  104   ; 'h'

    data   32   ; ' '

    data  108   ; 'l'

    data  105   ; 'i'

    data  115   ; 's'

    data  116   ; 't'

    data   32   ; ' '



MsgFor

    data   32   ; ' '

    data  102   ; 'f'

    data  111   ; 'o'

    data  114   ; 'r'

    data   32   ; ' '



MsgInto

    data   32   ; ' '

    data  105   ; 'i'

    data  110   ; 'n'

    data  116   ; 't'

    data  111   ; 'o'

    data   32   ; ' '

    data  108   ; 'l'

    data  105   ; 'i'

    data  115   ; 's'

    data  116   ; 't'

    data   32   ; ' '



MsgFrom

    data   32   ; ' '

    data  102   ; 'f'

    data  114   ; 'r'

    data  111   ; 'o'

    data  109   ; 'm'

    data   32   ; ' '

    data  108   ; 'l'

    data  105   ; 'i'

    data  115   ; 's'

    data  116   ; 't'

    data   32   ; ' '



MsgList

    data  108   ; 'l'

    data  105   ; 'i'

    data  115   ; 's'

    data  116   ; 't'



MsgTerminate

    data   84   ; 'T'

    data  101   ; 'e'

    data  114   ; 'r'

    data  109   ; 'm'

    data  105   ; 'i'

    data  110   ; 'n'

    data   97   ; 'a'

    data  116   ; 't'

    data  101   ; 'e'

    data   10   ; '\n'



MsgNo

    data  78    ; 'N'

    data  111   ; 'o'



MsgYes

    data  89    ; 'Y'

    data  101   ; 'e'

    data  115   ; 's'



;--------------------------------------------------------------------

; Variables for the user program

;--------------------------------------------------------------------



;----------------------------------------------------------------------

StackOverflow

    lea    R1,2[R0]            ; trap code for write

    lea    R2,StackOverflowMessage[R0]

    lea    R3,15[R0]           ; string length

    trap   R1,R2,R3            ; print "Stack overflow\n"

    trap   R0,R0,R0            ; halt



StackOverflowMessage

    data   83   ; 'S'

    data  116   ; 't'

    data   97   ; 'a'

    data   99   ; 'c'

    data  107   ; 'k'

    data   32   ; ' '

    data  111   ; 'o'

    data  118   ; 'v'

    data  101   ; 'e'

    data  114   ; 'r'

    data  102   ; 'f'

    data  108   ; 'l'

    data  111   ; 'o'

    data  119   ; 'w'

    data   10   ; '\n'



;----------------------------------------------------------------------

; Character codes

;----------------------------------------------------------------------



; The codes for common characters are defined here, for convenience



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



ShowNumBuf data  35  '#'

           data  35

           data  35

           data  35

           data  35

           data  35

           data  35



;--------------------------------------------------------------------

; Lists

;--------------------------------------------------------------------



; Array of lists, indexed from 0 to nlists-1.  Each list is represented

; by a header record with a dummy value and a next field, which is

; initialized to nil.


InputPtr  data   0   ; points to next record of input data

nlists    data   5   ; size of array of lists



list       data   0   ; list[0].dummyvalue

          data   0   ; list[0].next

          data   0   ; list[1].dummyvalue

          data   0   ; list[1].next

          data   0   ; list[2].dummyvalue

          data   0   ; list[2].next

          data   0   ; list[3].dummyvalue

          data   0   ; list[3].next

          data   0   ; list[4].dummyvalue

          data   0   ; list[4].next



;--------------------------------------------------------------------

; Input data --- array of commands

;--------------------------------------------------------------------



; Rather than reading input using I/O, we will define it as an array.

; This makes it easier to run programs repeatedly with the same input

; data, and to change the input by cutting it and pasting new input

; data.



; The input data to the program is an array of records: code, x, y



;    code = 0:  terminate

;    code = 1:  insert y into list[x]

;    code = 2:  delete y from list[x]

;    code = 3:  search for y in list[x]

;    code = 4   print list x

;    any other code is ignored



InputData

          data   1   ; insert 99 into list[2]

          data   2

          data  99



          data   4   ; print list[2]

          data   2

          data   0



          data   1   ; insert 100 into list[4]

          data   4

          data 100 



          data   1   ; insert 's' into list[2]

          data   2

          data 115



          data   4   ; print list[2]

          data   2

          data   0



          data   1   ; insert 'k' into list[3]

          data   3

          data 107



          data   1   ; insert 'p' into list[2]

          data   2

          data 112



          data   1   ; insert 'w' into list[2]

          data   2

          data   1



          data   4   ; print list[2]

          data   2

          data   0



          data   1   ; insert 'x' into list[3]

          data   3

          data 120



          data   1   ; insert 'b' into list[2]

          data   2

          data  98



          data   1   ; insert 'm' into list[0]

          data   0

          data 109



          data   4   ; print list[2]

          data   2

          data   0



          data   3   ; search for 'p' in list[2]

          data   2

          data 112



          data   2   ; delete 'p' from list[2]

          data   2

          data 112



          data   4   ; print list[2]

          data   2

          data   0



          data   1   ; insert 's' into list[0]

          data   0

          data 115



          data   3   ; search for 'p' in list[2]

          data   2

          data 112



          data   4   ; print list[0]

          data   0

          data   0



          data   4   ; print list[1]

          data   1

          data   0



          data   4   ; print list[2]

          data   2

          data   0



          data   4   ; print list[3]

          data   3

          data   0



          data   4   ; print list[4]

          data   4

          data   0



          data   0   ; terminate

          data   0

          data   0



          data  -3   ; negative code is invalid

          data   0

          data   0



          data   9   ; high code is invalid

          data   0

          data   0



;--------------------------------------------------------------------

; System variables, constant parameters and allocation area

;--------------------------------------------------------------------



CmdArgP        data      0     ; pointer to list argument of command

CmdArgI        data      0     ; index of list argument of command

CmdArgX        data      0     ; value argument of command



StackSize      data   1000     ; number of words allocated for call stack

HeapSize       data   1000     ; number of words allocated for heap

HeapStart      data      0     ; address of start of heap

avail          data      0     ; list of available heapnodes



AllocationArea data      0     ; contains call stack followed by heap

CallStack      data      0



;--------------------------------------------------------------------

; The call stack grows from this point onwards, followed by heap

; Don't define anything after this

;--------------------------------------------------------------------