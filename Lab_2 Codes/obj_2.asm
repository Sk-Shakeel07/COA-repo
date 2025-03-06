     MOV SI,2000H 
     MOV CL,[SI]  ;DECLARE N IN THE MEMORY LOCATION 2000 
     MOV CH,00H 
     MOV BX,CX      
     MOV AX,0000H 
L2:  INC SI      ;16-bit data to be given from 2002 Memory location onwards     
     INC SI 
     ADD AX,[SI] 
     JNC L1 
     INC CH 
L1:  DEC CL 
     JNZ L2 
     INC SI  
     INC SI   
     MOV [SI],AX 
     INC SI  
     INC SI 
     MOV [SI],CH 
     DIV BX 
     INC SI  
     INC SI 
     MOV [SI],AX 
     INC SI  
     INC SI 
     MOV [SI],DX 
     HLT 