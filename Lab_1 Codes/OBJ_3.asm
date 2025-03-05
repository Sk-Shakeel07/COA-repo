mov al, [1000h] 
mov bl,al 
shr al,01 
xor al,bl 
mov [1001h],al 
hlt    