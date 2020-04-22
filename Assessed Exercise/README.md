# Assessed Exercise

## Specification
There is an array named `list` containing `nlists` elements, where `nlists` is given the initial value of 5. Each element of the array is a header node pointing to a list of numbers in increasing order. Initially every element of the array is an empty list. <br />
There is also an array of records, where each record describes a command to perform. The record has three fields: `code`, `i`, `x`. The meanings are as follows:

* code = 0: **terminate** the program.
* code = 1: **insert** x into list[i] so that the list remains ordered.
* code = 2: **delete** the first occurrence of x in list[i], if any. If x doesn't occur in the list, do nothing.
* code = 3: **search** list[i] for x; if found print "Found", otherwise print "Not found".
* code = 4: **print** the elements of list[i].

The task is to write a program that takes the array of commands and executes them. The EXERCISE program implements the building of the heap, the loop that traverses the array of commands, and two of the commands (terminate and insert). The program runs as it is, but three of the commands do nothing (print, search, delete). Implement those three commands.

## Grading
This exercise counts for 10% of the final grade. The program will be marked out of 100:

* Identifying information (comments) = 5
* Status Report clearly whether the program works = 5
* The Print Command = 20
* The Search Command = 20
* The Delete Command = 20
* ReleaseNode = 10
* The program assembles and executes correctly = 20

<br />

**Grade:** 96/100 <br />
**Feedback:** `Excellent work! A mismatch in the CmdPrint HL to LL and therefore to assembly is causing the program to print out 0 at the start of every list, which is not supposed to happen. Otherwise, very good work.`