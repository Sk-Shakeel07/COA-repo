; You may customize this and other start-up templates;
; The location of this template is c:\emu8086\inc\0_com_template.txt

include 'emu8086.inc'
org 100h

; add your code here    

; define variables:
;jmp start
;
;txt_a db "_______________________________________________________________________________               ",0Dh,0Ah
;     db "                               CALCULATOR",0Dh,0Ah
;     db "_______________________________________________________________________________               ",0Dh,0Ah,'$'
;
;txt_b db "enter second number: $"
;txt_c db  0dh,0ah , 'RESULT ::   $'
;txt_d db  0dh,0ah ,'thank you for using the calculator! press any key... ', 0Dh,0Ah, '$'
;txt_e db  "wrong operator!", 0Dh,0Ah , '$'
;smth db  " and something.... $"  
;opr db '?'
;FACT DB 1H
;; first and second number:
;operand1 dw ?
;operand2 dw ?
;
;BASE    DB      ?             ;declare variables
;POW     DB      ?
;
start:  


printn
call print_string

mov dx, offset txt_a
mov ah, 9
int 21h

first:
printn
call print_string
printn
print 'ENTER YOUR CHOICE: '
printn
printn
print '        1.Addition '
printn
print '        2.Subtraction '
printn
print '        3.Multiplication '
printn
print '        4.Division '
printn
print '        5.Factorial'    
printn  
print '        6.Exponential'    
printn  
print '        7.Square root'    
;printn
;print '        8.Logical Operations'    
printn
print '        9.Quit'    
printn

re_opr:                      
mov ah, 1              
int 21h
mov opr, al
cmp opr,39h          
je exit
cmp opr, 30h
jb incorrect_option
cmp opr, 39h
ja incorrect_option

printn
printn
               
cmp opr,31h          
je add_operation

cmp opr,32h
je sub_operation

cmp opr,33h
je mul_operation

cmp opr,34h
je div_operation

cmp opr,35h
je fact_operation

cmp opr,36h
je exp_operation

cmp opr,37h
je sqrt_operation

;cmp opr,38h
;je do_logical


incorrect_option:
 
printn
printn
print 'Wrong operator!...Enter again..'
putc 0Dh              
putc 0Ah          

jmp re_opr


exit:

lea dx, txt_d
mov ah, 09h
int 21h  



mov ah, 0
int 16h


ret  

add_operation:

print 'Enter first number: '
call scan_num          ;read input
mov operand1, cx           ; store first number:

printn
printn

print 'Enter second number: '
call scan_num
mov operand2, cx           ; store second number:

printn
printn
print 'RESULT :: '

mov ax, operand1
add ax, operand2
call print_num    ; print ax value.

printn
printn
print 'Press 1 to continue'
mov ah, 1              ; single char input to AL.
int 21h
mov opr, al
cmp al,031h
je first
jmp exit



sub_operation:

print 'Enter first number: '
call scan_num          ;read input
mov operand1, cx           ; store first number:

printn
printn

print 'Enter second number: '
call scan_num
mov operand2, cx           ; store second number:

printn
printn
print 'RESULT :: '

mov ax, operand1
sub ax, operand2
call print_num    ; print ax value.

printn
printn
print 'Press 1 to continue'
mov ah, 1              ; single char input to AL.
int 21h
mov opr, al
cmp al,031h
je first
jmp exit

mul_operation:

print 'Enter first number: '
call scan_num          ;read input
mov operand1, cx           ; store first number:

printn
printn

print 'Enter second number: '
call scan_num
mov operand2, cx           ; store second number:

printn
printn
print 'RESULT :: '

mov ax, operand1
imul operand2         ; (ax) = ax * operand2.
call print_num    ; print ax value.
                  ; dx is ignored (calc works with tiny numbers only).
printn
printn
print 'Press 1 to continue'
mov ah, 1              ; single char input to AL.
int 21h
mov opr, al
cmp al,031h
je first
jmp exit






div_operation:
; dx is ignored (calc works with tiny integer numbers only).
print 'Enter first number: '
call scan_num          ;read input
mov operand1, cx           ; store first number:

printn
printn

print 'Enter second number: '
call scan_num
mov operand2, cx           ; store second number:

printn
printn
print 'RESULT :: '

mov dx, 0
mov ax, operand1
idiv operand2  ; ax = (ax) / operand2.
cmp dx, 0
jnz approx
call print_num    ; print ax value.
jmp first

approx:
call print_num    ; print ax value.
lea dx, smth
mov ah, 09h    ; output string at ds:dx
int 21h  

printn
printn
print 'Press 1 to continue'
mov ah, 1              ; single char input to AL.
int 21h
mov opr, al
cmp al,031h
je first
jmp exit



fact_operation:

print 'Enter the number: '
call scan_num          ;read input
mov operand1, cx           ; store first number:

printn
printn



printn
printn
print 'RESULT :: '

mov cx,operand1
mov ax,0001
mov dx,0000
a:
mul cx
loop a
call print_num

printn
printn
print 'Press 1 to continue'
mov ah, 1              ; single char input to AL.
int 21h
mov opr, al
cmp al,031h
je first
jmp exit



exp_operation:

xor ax,ax
xor bx,bx
xor cx,cx  ;;to clear the contents of register
xor dx,dx

printn
print 'Enter the base :'

        MOV AH,01H
        INT 21H
        SUB AL,30H
        MOV BL,AL

        MOV BASE,AL
printn
print 'Enter the power :'
        printn
        printn


        MOV AH,01H
        INT 21H
        SUB AL,30H

        MOV CL,AL
        DEC CL
        MOV AX,00h
        MOV AL,BASE
LBL1:

        MUL BL
        LOOP LBL1

        MOV CL,10  
        DIV CL    
        ADD AX,3030H
        MOV DX,AX
     
        MOV AH,02H
        INT 21H
        MOV DL,DH
        INT 21H
       
printn
printn
print 'Press 1 to continue'
mov ah, 1              ; single char input to AL.
int 21h
mov opr, al
cmp al,031h
je first
jmp exit  
       
       



sqrt_operation:  

print 'Enter the perfect square number: '
call scan_num          ;read input
mov operand1, cx           ; store first number:

printn
printn



printn
printn
print 'RESULT :: '
   
    mov ax,operand1
    mov cx,0000h
    mov bx,0ffffh
    sr:
    add bx,02h
    inc cx                 ;cx will give the perfect square
    sub ax,bx
    jnz sr
    mov ax,cx
    call print_num
   
printn
printn
print 'Press 1 to continue'
mov ah, 1              ; single char input to AL.
int 21h
mov opr, al
cmp al,031h
je first
jmp exit
SCAN_NUM   PROC    NEAR      ; gets the multi-digit SIGNED number from the keyboard,
                             ; and stores the result in CX register:
        PUSH    DX
        PUSH    AX
        PUSH    SI
       
        MOV     CX, 0

       
        MOV     CS:make_minus, 0


;validation


next_digit:

       
                                ; get char from keyboard
                                 ; into AL:
                                 
        MOV     AH, 00h
        INT     16h
       
        MOV     AH, 0Eh           ;displays char on screen advancing the cursor and scrolling the screen as necessary
        INT     10h

   
        CMP     AL, '-'           ;check fotr minus
        JE      set_minus

       
        CMP     AL, 0Dh  
        JNE     not_cr            ;check for enter key
        JMP     stop_input
not_cr:


        CMP     AL, 8                  
        JNE     backspace_checked
        MOV     DX, 0                  
        MOV     AX, CX                  
        DIV     CS:ten                
        MOV     CX, AX
        PUTC    ' '                    
        PUTC    8                      
        JMP     next_digit
backspace_checked:


       
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit


remove_not_digit:      
        PUTC    8                ;removes the char and backspaces it
        PUTC    ' '    
        PUTC    8        
        JMP     next_digit      


ok_digit:
       
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                
        MOV     CX, AX
        POP     AX

       
        CMP     DX, 0
        JNE     too_big

        SUB     AL, 30h

     
        MOV     AH, 0
        MOV     DX, CX    
        ADD     CX, AX
        JC      too_big2  

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX    
        MOV     DX, 0      
too_big:
        MOV     AX, CX
        DIV     CS:ten  
        MOV     CX, AX
        PUTC    8      
        PUTC    ' '    
        PUTC    8            
        JMP     next_digit
       
       
stop_input:
       
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?      
SCAN_NUM        ENDP


PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
       
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP


PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

       
        MOV     CX, 1

        .
        MOV     BX, 10000      

       
        CMP     AX, 0
        JZ      print_zero

begin_print:                   ;div validation

       
        CMP     BX,0
        JZ      end_print

   
        CMP     CX, 0
        JE      calc
     
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0  

        MOV     DX, 0
        DIV     BX    

     
        ADD     AL, 30h  
        PUTC    AL


        MOV     AX, DX  

skip:
       
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  
        MOV     BX, AX
        POP     AX

        JMP     begin_print
       
print_zero:
        PUTC    '0'
       
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP



ten             DW      10    


GET_STRING      PROC    NEAR
    PUSH    AX
    PUSH    CX
    PUSH    DI
    PUSH    DX

    MOV     CX, 0                  

    CMP     DX, 1                  
    JBE     empty_buffer            

    DEC     DX                    

wait_for_key:

    MOV     AH, 0                  
    INT     16h

    CMP     AL, 0Dh                
    JZ      exit_GET_STRING


    CMP     AL, 8                  
    JNE     add_to_buffer
    JCXZ    wait_for_key          
    DEC     CX
    DEC     DI
    PUTC    8                      
    PUTC    ' '                    
    PUTC    8                      
    JMP     wait_for_key

add_to_buffer:

        CMP     CX, DX          
        JAE     wait_for_key    

        MOV     [DI], AL
        INC     DI
        INC     CX
       
       
        MOV     AH, 0Eh
        INT     10h

JMP     wait_for_key


exit_GET_STRING:

    MOV     [DI], 0

empty_buffer:

    POP     DX
    POP     DI
    POP     CX
    POP     AX
RET
GET_STRING      ENDP

define_print_string
ret

txt_a db "_______________________________________________________________________________               ",0Dh,0Ah
     db "                               SCIENTIFIC CALCULATOR",0Dh,0Ah
     db "_______________________________________________________________________________               ",0Dh,0Ah,'$'

txt_b db "enter second number: $"
txt_c db  0dh,0ah , 'RESULT ::   $'
txt_d db  0dh,0ah ,'Thank You!!Project By: 19PD09-DHIKSHITHA A,19PD38-SWATHI PRATHAA P', 0Dh,0Ah, '$'
txt_e db  "wrong operator!", 0Dh,0Ah , '$'
smth db  " and something.... $"  
opr db '?'
FACT DB 1H
; first and second number:
operand1 dw ?
operand2 dw ?

BASE    DB      ?             ;declare variables
POW     DB      ?