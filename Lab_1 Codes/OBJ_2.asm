;swapping of nibble 
mov si, 1000h 
mov al,[si] ;1st data stores in al 
mov cl,al 
inc si 
mov bl,[si] ;2nd data stores in bl 
mov dl,al 
shr al,04 
shl dl,04 
or al,dl  
inc si 
mov [si],al 
;Computation of Y 
mov al,cl 
and al,bl 
mov dl,al 
xor cl,bl 
or al,cl 
inc si 
mov [si],al 
hlt 