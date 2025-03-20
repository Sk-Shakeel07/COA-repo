.DATA 
count DB 06 
value DB 09H,0FH,14H,45H,24H,3FH 
.CODE 
MAIN PROC
        MOV AX,DATA       
        MOV DS,AX 
        LEA DI, count 
        MOV CH,[DI] 
        DEC CH 
UP2:    MOV CL,CH 
        LEA SI, value 
UP1:    MOV AL,[SI] 
        CMP AL, [si+1] 
        JC DOWN   ; JNC for descending 
        MOV DL,[SI+1] 
        XCHG [SI],DL  ; swapping of MEMORY location DATA 
        MOV [SI+1],DL 
DOWN:   INC SI 
        DEC CL 
        JNZ UP1 
        DEC CH 
        JNZ UP2 
END MAIN