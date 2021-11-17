// File: mod.asm
// Author: Joseph Quismorio
// Date: 09/27/2021
// Section: 504
// E-mail: jfquismorio@tamu.edu 
// Description: Program that calculates the modulo of two given numbers, a and b, a%b in math

//This asm computes the modular of two numbers
//Assuming R0 stores the number a and R1 stores the number n
//so in normal programming language, the goal is to compute RAM[R0]%RAM[R1]
//The result will be put to R2
//Assuming RAM[R1] is positive integer and RAM[R0] is non-negative integer

//See the mod.cmp,mod.tst file to understand the input and output structure

//Put your code here

//basically just a modified version of div.asm but reports remainder rather than dividend

@2 //set up modulo constant value
M = 0 //initialize at 0

@0 //set up r0 constant value
D = M //initialize with D = R0

(LOOP)
@1 
D = D - M //D = R0 - R1, subtraction component of division
@MODULO 
D;JLT //if D < 0 go to modulo value
@END
D;JEQ //if D = 0 enter infinite loop 
@LOOP 
0;JMP //go to loop again

(MODULO)
@1
D = D + M //D = R0 + R1; if it got to this point R0 was below 0
@2
M = D //make r2 hold new mod data

(END)
@END //infinite loop
0;JMP
