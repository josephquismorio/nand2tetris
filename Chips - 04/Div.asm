// File: Div.asm
// Author: Joseph Quismorio
// Date: 09/27/2021
// Section: 504
// E-mail: jfquismorio@tamu.edu 
// Description: Program to calculate the quotient from a division operation

// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Div.asm

// Divides R0 by R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
// R0=2, R1=2, Div.asm file should store R2=1


// Put your code here.

// Put your code here.

@2 //set up dividend constant value 
M = 0 //initialize at 0

@0 //set up r0 constant value
D = M //initialize with D = R0

(LOOP)
@1 
D = D - M //D = R0 - R1, subtraction component of division
@ADDBACK 
D;JLT //if D < 0 go to remainder
@2
M = M + 1 // R2++ for every uninterrupted loop
@END
D;JEQ //if D = 0 enter infinite loop
@LOOP 
0;JMP //go to loop again

(ADDBACK)
@1
D = D + M //D = R0 + R1; if it got to this point R0 was below 0

(END)
@END
0;JMP