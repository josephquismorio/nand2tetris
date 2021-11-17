// File: lcd.asm
// Author: Joseph Quismorio
// Date: 09/27/2021
// Section: 504
// E-mail: jfquismorio@tamu.edu 
// Description: Program that calculates the largest common divisor (LCD) of two given non-negative integers

//Using Euclidean algorithm to find the larget common divisor of two positive integers
//Assuming RAM[R0] stores the first integer and RAM[R1] stores the second integer
//RAM[R2] stores the result
//See the lcd.cmp,lcd.tst file to understand the input and output structure

//Put your code here
//while R1 is not 0:
// remainder = R0/R1
// R0 = R1
// R1 = remainder

@0
D = M
@HOLD0 //placeholder for R0 to restore later
M = D 

@1
D = M
@HOLD1 //placeholder for R1 to restore later
M = D

(CASE1) //if R0 == 0
@0 
D = M
@CASE2 //go to case 2 if R0 is not 0
D;JNE
@1 //otherwise, hold R1 in R2...
D = M
@2 //... so that R2 is now determined by R1 value
M = D 
@END //go to end case
0;JMP

(CASE2) //if R1 == 0
@1
D = M
@LOOP //go to loop if neither R0 or R1 are 0
D;JNE 
@0 //otherwise, hold R0 in R2...
D = M
@2 //... so that R2 is now determined by R0 value
M = D
@END //go to end case
0;JMP

(LOOP)
@0 //if neither R0 or R1 are 0
D = M
@MODULO //hold R0 value in placeholder for mod
M = D
(NEST) //nested loop
@1
D = M
@MODULO //placeholder value for result
D = M - D//D = R0 - R1, subtraction component of division
@GCD 
D;JLT //if D < 0 go to gcd loop
@MODULO
M = D //if MODULO > 0 hold new mod value
@NEST 
0;JMP //go through nested loop again
(GCD)
@1 //hold R1 value in R0
D = M 
@0
M = D //R0 now holds denominator
@MODULO
D = M //R1 will now hold the remainder/modulo
@1
M = D
@CASE1 //restart process at case 1 with new values; check if R0 == 0, etc.
0;JMP 


(END) //replacing the modified R0 and R1 values with originals
@HOLD0 //placeholder declared earlier
D = M
@0 //replace R0 with former, original value
M = D
@HOLD1 //placeholder declared earlier
D = M
@1 //replace R1 with former, original value
M = D
@ENDLOOP
0;JMP //go to infinite loop

(ENDLOOP) //infinite loop
@ENDLOOP
0;JMP