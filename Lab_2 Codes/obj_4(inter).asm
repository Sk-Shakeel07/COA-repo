; Move a block of 16-bit data from one location to another (Inter Segment Transfer).   
     MOV SI, 3000H 
     MOV DI, 5000H 
     MOV CL,05H  
L1:  MOV AX,2000H 
     MOV DS,AX 
     MOV BX,[SI] 
     INC SI 
     INC SI 
     MOV AX,4000H 
     MOV DS,AX  
     MOV [DI],BX 
     INC DI 
     INC DI 
     DEC CL 
     JNZ L1 
     HLT 
