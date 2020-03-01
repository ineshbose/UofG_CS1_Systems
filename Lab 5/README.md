# Lab 5 (20/02/20)

## Task
A _vector_ is just an ordinary array. We are given two vectors of size _n_,
_X_ = <a href="https://www.codecogs.com/eqnedit.php?latex=\bg_white&space;\large&space;x_{0},&space;x_{1},.&space;.&space;.&space;,&space;x_{n−1}" target="_blank"><img src="https://latex.codecogs.com/png.latex?\bg_white&space;\large&space;x_{0},&space;x_{1},.&space;.&space;.&space;,&space;x_{n−1}" title="\large x_{0}, x_{1},. . . , x_{n−1}" /></a> and _Y_ = <a href="https://www.codecogs.com/eqnedit.php?latex=\bg_white&space;\large&space;y_{0},&space;y_{1},.&space;.&space;.&space;,&space;y_{n−1}" target="_blank"><img src="https://latex.codecogs.com/png.latex?\bg_white&space;\large&space;y_{0},&space;y_{1},.&space;.&space;.&space;,&space;y_{n−1}" title="\large y_{0}, y_{1},. . . , y_{n−1}" /></a>. The _dot product_ (also called _inner product_) of _X_ and _Y_ is the sum

<a href="https://www.codecogs.com/eqnedit.php?latex=\bg_white&space;\LARGE&space;\sum_{i=0}^{n-1}x_{i}\cdot&space;y_{i}&space;=&space;x_{0}\cdot&space;y_{0}&space;&plus;&space;x_{1}\cdot&space;y_{1}&space;&plus;&space;...&space;&plus;&space;x_{n-1}\cdot&space;y_{n-1}" target="_blank"><img src="https://latex.codecogs.com/png.latex?\bg_white&space;\LARGE&space;\sum_{i=0}^{n-1}x_{i}\cdot&space;y_{i}&space;=&space;x_{0}\cdot&space;y_{0}&space;&plus;&space;x_{1}\cdot&space;y_{1}&space;&plus;&space;...&space;&plus;&space;x_{n-1}\cdot&space;y_{n-1}" title="\LARGE \sum_{i=0}^{n-1}x_{i}\cdot y_{i} = x_{0}\cdot y_{0} + x_{1}\cdot y_{1} + ... + x_{n-1}\cdot y_{n-1}" /></a>

The following are the data values: _n_ = 3, the elements of _X_ are 2,5,3 and the elements of _Y_ are 6,2,4. Write a program that sets a variable _p_ to the dot product of _X_ and _Y_. For the given inputs, the result should be _p_ = 2·6 + 5·2 + 3·4 = 34.
Develop the program using the following steps:
1. Write initial full line comments giving the name of the program (`DotProduct`). This goes at the beginning of the program.
2. Write the algorithm using high level language notation. Make the algorithm clear and readable. This should be included in the program, as full line comments.
3. Translate the algorithm into low level language notation. This means that the program consists of assignment statements, go statements and conditional goto statements. This too should be included in the program as full line comments.
4. Translate the low level language program into assembly language. Make a copy of each statement in the low level language program, and insert the assembly language instructions right after it. This means that each statement in the low level program will apear twice; once in the complete listing of the program, and again as a header before the instructions.
5. Define the variables using `data` statements. Use the initial values specified in the problem description.
6. Assemble the program.
7. Run the program.