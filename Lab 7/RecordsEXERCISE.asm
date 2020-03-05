; Records --- Exercise
; Sigma16 program showing how to access record fields
; John O'Donnell, 2019

;--------------------------------------------------------------------
; High level algorithm in Sigma 

; program Records
;  { x, y :
;      record
;        { fieldA : int;
;          fieldB : int;
;          fieldC : int;
;        };
;
;    x.fieldA := x.fieldB + x.fieldC;
;    y.fieldA := y.fieldB + y.fieldC;
;  }

;--------------------------------------------------------------------
; Simplistic approach, with every field of every record named
; explicitly.

; In record x,  fieldA := fieldB + fieldC
; x.fieldA := x.fieldB + x.fieldC
    load   R1,x_fieldB[R0]
    load   R2,x_fieldC[R0]
    add    R1,R1,R2
    store  R1,x_fieldA[R0]

; In record y,  fieldA := fieldB + fieldC
; y.fieldA := y.fieldB + y.fieldC
    load   R1,y_fieldB[R0]
    load   R2,y_fieldC[R0]
    add    R1,R1,R2
    store  R1,y_fieldA[R0]

;--------------------------------------------------------------------
; A much better approach: Access the record fields through a pointer
; to the record.  This way, we can make the same code work for any
; record with the same fields

; Set x as the current record by making R3 point to it
; R3 := &x;

; INSERT SOLUTION HERE
    lea    R3,x[R0]

; Perform the calculation on the record that R3 points to
; *R3.fieldA := *R3.fieldB + *R3.fieldC
; This will be equivalent to x.fieldA := x.fieldB + x.fieldC

; INSERT SOLUTION HERE
    load   R4,1[R3]
    load   R5,2[R3]
    add    R4,R4,R5
    store  R4,0[R3]
 
; Set y as the current record by making R3 point to it
; R3 := &y;

; INSERT SOLUTION HERE
    lea    R3,x[R0]

; Perform the calculation on the record that R3 points to
; *R3.fieldA := (*R3).fieldB + (*R3).fieldC
; This will be equivalent to y.fieldA := y.fieldB + y.fieldC

; INSERT SOLUTION HERE
    load   R4,1[R3]
    load   R5,2[R3]
    add    R4,R4,R5
    store  R4,0[R3]

; The conclusion is that we could have a program do this computation
; (fieldA := fieldB + fieldC) on *any* record.  We don't even need to
; have the records defined with data statements giving them individual
; names.

;--------------------------------------------------------------------
; So let's do that, with a loop that iterates over an array of
; records, performs the fieldA := fieldB + fieldC computation on each
; of them, and also computes the sum of all the fieldA results.  An
; array of nrecords is defined below, with initial values of the
; records.

; We could use array indexing, like this (note that we would need to
; multiply the index i by the array element size to get the address of
; an element).

;  sum := 0
;  for i := 0 to nrecords do
;    { RecordArray[i].fieldA :=
;         RecordArray[i].fieldB + RecordArray[i].fieldC;
;      sum := RecordArray[i].fieldA; }

; But let's use pointers to access the array elements instead. A
; variable p points to the current element of the array, and on each
; iteration we need to add the size of the record (which is 3) to p.

; Here's the high level algorithm:
;    sum := 0;
;    p := &RecordArray;
;    q := &RecordArrayEnd;
;    while p < q do
;      { *p.fieldA := *p.fieldB + *p.fieldC;
;        sum := sum + *p.fieldA;
;        p := p + RecordSize; }

; Notice that we have two different approaches.  It's interesting to
; compare them:
;    (1)  access element of array by index
;         Need to do arithmetic on index (multiply it by 3)
;         Need to have a variable giving number of elements in array
;         Don't need to know the address of the end of the array
;         Use a for loop for the iteration
;    (2)  access element of array by pointer
;         Need to do arithmetic on pointer (add 3 to it)
;         Don't need a variable giving number of elements in array
;         Do need to know the address of the end of the array
;         Use a while loop for the iteration

; Which of these approaches is better?  That depends entirely on the
; situation; sometimes the index version is better, sometimes the
; pointer version is better.  And what does "better" mean?  There are
; many things to consider, including simplicity, readability of the
; code, runtime efficiency, flexibility in providing the input, and
; more.

; Translate the high level algorithm to low level (pointer/while version)

; INSERT SOLUTION HERE
;   sum := 0
;   p := &RecordArray
;   q := &RecordArrayEnd
; while
;   if p >= q goto exit
;   *p.fieldA := *p.fieldB + *p.fieldC
;   sum := sum + *p.fieldA
;   p := p + RecordSize
;   goto while
; exit

; Translate it to assembly language

; INSERT SOLUTION HERE
    add   R6,R0,R0
    lea   R7,RecordArray[R0]
    lea   R8,RecordArrayEnd[R0]
    load  R9,RecordSize[R0]
while
    cmplt R10,R7,R8
    jumpf R10,exit[R0]
    load  R11,1[R7]
    load  R12,2[R7]
    add   R11,R11,R12
    store R11,0[R7]
    add   R6,R6,R11
    add   R7,R7,R9
    jump  while[R0]
exit

; Terminate
    trap   R0,R0,R0    ; halt

;-----------------------------------------------------------------------
; Data definitions

nrecords   data   5    ; an array with nrecords elements is definedbelow
RecordSize data   3    ; there are 3 words in the record
RecordArray            ; this is the address of the array

; The record x, record[0]
x
x_fieldA   data   3    ; offset 0 from x  &x_fieldA = &x
x_fieldB   data   4    ; offset 1 from x  &x_fieldB = &x + 1
x_fieldC   data   5    ; offset 2 from x  &x_fieldC = &x + 2

; The record y, record[1]
y
y_fieldA   data  20    ; offset 0 from y  &y_fieldA = &y
y_fieldB   data  21    ; offset 1 from y  &y_fieldB = &y + 1
y_fieldC   data  22    ; offset 2 from y  &y_fieldC = &y + 2

; More records, we haven't even given them individual names
; record[2]
           data  30    ; fieldA
           data  31    ; fieldB
           data  32    ; fieldC
; record[3]
           data  30    ; fieldA
           data  31    ; fieldB
           data  32    ; fieldC
; record[4]
           data  40    ; fieldA
           data  41    ; fieldB
           data  42    ; fieldC
RecordArrayEnd         ; this is the address of the end of the array