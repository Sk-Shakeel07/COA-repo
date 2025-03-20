.data   
count db 04h ;  count = array size 
value db 09h, 10h,05h,03h ; array elements 
res db ?            ; store the result in res 
.code 
MAIN PROC 
     mov ax, data 
     mov ds, ax 
     mov cl, count 
     dec cl 
     LEA SI, value 
     mov al, [SI] 
up:  inc si 
     cmp al, [si] 
     jnl nxt           ; jump to “nxt” if not less than 
     mov al, [si] 
nxt: dec cl 
     jnz up  
     LEA DI, res 
     mov [DI], al   
END MAIN 