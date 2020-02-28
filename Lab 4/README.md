# Lab 4 (13/02/20)

## Task 1
Translate the following low level code into a complete Sigma16 assembly language program.

```
x := a - b;
```
The variables have these initial values: `x` = 0, `a` = 20, `b` = 13.

The program that should
1. load `a` and `b` into registers,
2. do the arithmetic,
3. store the result into `x`,
4. terminate execution, and then
5. there should be data statements to define the variables and give them initial values.

## Task 2
Translate the following program into a complete Sigma16 assembly language program. The varaibles have these initial values: `a` = 0, `x` = 3, `y` = 20.

```
if x>y
    then { a:= x; }
    else { a:= y; }
a := 2 * a;
```

# Task 3
Translate the following program containing a while loop into a complete Sigma16 assembly language program. The initial value of n is 5; the other variables have initial value 0.

```
sum := 0;
i := 0;
while i < n do
    { sum := sum + i;
        i := i + 1;
    }
```