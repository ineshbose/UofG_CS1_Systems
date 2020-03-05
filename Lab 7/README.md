# Lab 7 (05/03/20)

## Task 1
Complete the program in `RecordsEXERCISE.asm` by filling in the necessary instructions at the points labelled `; INSERT SOLUTION HERE`. The comments in the program tell you what to do.

## Task 2
`PrintIntegers` is a program that defines a procedure that takes an integer, converts it to a character string and prints it. The core of the program is a procedure `ShowInt`.

```
procedure ShowInt (x: Int, *bufstart:Char, bufsize:Int) : Int
```

This procedure takes three parameters: an integer `x`, a pointer to a buffer in memory where the character string will be stored and an integer `bufsize` which gives the maximum size of the string. If the number fits within bufsize characters, the procedure stores the string and inserts leading spaces if needed. If the number simply doesn't fit, the procedure fills the buffer with hash characters. The high level algorithm is given. The problem has two parts:

1. Translate the high level algorithm into low level. Use th0e translation patterns, don't just write random code.
2. Translate the low level algorithm into assembly language.

Complete the program by filling in the necessary instructions at the points labelled `; INSERT SOLUTION HERE`.