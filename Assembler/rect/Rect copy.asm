(LOOP)
@KBD
D = M
@FILL
D;JGT
@CLEAR
0;JMP

(FILL)
@fx
M = 0
(B_ITER)
@fx
D = M
@SCREEN
D = D+A
A = D
M = -1
@fx
M = M+1
D = M
@8192
D = A-D
@B_ITER
D;JGT

@LOOP
0;JMP

(CLEAR)
@cx
M = 0
(W_ITER)
@cx
D = M
@SCREEN
D = D+A
A = D
M = 0
@cx
M = M+1
D = M
@8192
D = A-D
@W_ITER
D;JGT

@LOOP
0; JMP