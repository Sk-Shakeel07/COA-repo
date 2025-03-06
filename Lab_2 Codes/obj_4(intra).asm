; Move a block of 16-bit data from one location to another (Intra Segment Transfer).   
    MOV AX,2000H 
    MOV SI, 3000H 
    MOV DI, 5000H 
    MOV CL,05H 
    MOV DS,AX 
L1: MOV BX,[SI] 
    MOV [DI],BX 
    INC SI 
    INC SI 
    INC DI 
    INC DI 
    DEC CL 
    JNZ L1 
    HLT