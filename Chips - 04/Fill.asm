// File: Fill.asm
// Author: Joseph Quismorio
// Date: 09/27/2021
// Section: 504
// E-mail: jfquismorio@tamu.edu 
// Description: Program runs an infinite loop that listens to the keyboard input, filling in the screen with black when a button on the keyboard is pressed and defilling when no input is detected

// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.
(LOOP)
@SCREEN //address for screen
D=A
@0 //hold screen address in R[0]
M=D

(CHECK)
@KBD
D=M //receive keyboard input
@BLACK
D;JNE //if input is not 0, go to black
@WHITE
D;JEQ //if input is 0, go to white 

(BLACK)
@1
M=-1 //set to fill all draw values with 1 (-1 = 1111111111111111), or black
@FILL
0;JMP //jump to draw function thing

(WHITE)
@1
M=0 //set to fill all draw values with 0, or white
@FILL
0;JMP //jump to draw function thing

(FILL)
@1 
D=M //check what input dictated - black or white

@0
A=M //address for screen pixels to be filled in next line
M=D
 
@0 //do this for every pixel
D=M+1 
@KBD //input should be address subtract screen value
D=A-D

@0
M=M+1 //do this for every pixel
A=M

@FILL
D;JGT //when a=0, de-fill 

@LOOP //loop back to keyboard input
0;JMP