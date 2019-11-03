COD2 SEGMENT PARA 'CODE' 
PUBLIC MULTIP ;procedure MULTIP declaration as public
PUBLIC DIVID ;procedure DIVID declaration as public
ASSUME CS: COD2
MULTIP PROC FAR ;procedure MULTIP definition -> multiplication procedure

multipl:

 push bx		;save bx (the address) on the stack
 mov bx, word ptr [bx+24]           ;BX = multiplier
 cmp bx,1	;compare y with 1 -> if it's 1 we don't have to multiply anymore -> y will keep track of the numbers we have to multiply
 pop bx		;put the address back in bx
 jg begin
 jmp nmultipl


begin:
 mov ax, word ptr [bx]	;put the first word in ax
 push bx	;save the address
 mov bx, word ptr [bx+24]	;move y in bx
 mul bx                	;dx:ax = ax*bx
 pop bx		;get the address back
 mov word ptr[bx], ax	;save result
 mov cx, dx           ;save carried part in cx

 mov ax, word ptr [bx+2]	;put the second word in ax
 push bx
 mov bx, word ptr [bx+24]		
 mul bx          
 pop bx
 add ax, cx           ;add carried part from previous multiplication
 mov word ptr [bx+2], ax
 mov cx, dx
	
 mov ax, word ptr [bx+4]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+4], ax
 mov cx, dx
 
 mov ax, word ptr [bx+6]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+6], ax
 mov cx, dx
 
 mov ax, word ptr [bx+8]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+8], ax
 mov cx, dx

 mov ax, word ptr [bx+10]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+10], ax
 mov cx, dx
 
 mov ax, word ptr [bx+12]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+12], ax
 mov cx, dx
 
 mov ax, word ptr [bx+14]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+14], ax
 mov cx, dx
 
 mov ax, word ptr [bx+16]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+16], ax
 mov cx, dx

 mov ax, word ptr [bx+18]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+18], ax
 mov cx, dx
 
 mov ax, word ptr [bx+20]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+20], ax
 mov cx, dx
 
 mov ax, word ptr [bx+20]
 push bx
 mov bx, word ptr [bx+24]
 mul bx          
 pop bx
 add ax, cx           
 mov word ptr [bx+20], ax
 mov cx, dx
 
 push bx
 mov bx, word ptr [bx+24]
 mov cx,bx
 dec cx
 pop bx
 mov word ptr [bx+24],cx		;the algorithm is repeated for 12 times as we will use 12 words (24 bytes)
 cmp cx,1						;this last part also decrements y and checks if it's 1
 jng nmultipl					;if y is 1, the algorithm will not be repeated
 jmp multipl					;if not, jump back at the beginning
 
 nmultipl:
	
RETF ;back to the procedure which made the call
MULTIP ENDP ;end procedure

DIVID PROC FAR ;procedure DIVID definition -> division procedure

divide:

 mov dx, 0
 mov ax, word ptr [bx+22]   ;dx:ax is the number to divide
 push bx		;save address on stack
 mov bx,10		;put 10 in bx as divisor
 div bx			;divide by 10
 pop bx			;get back address
 mov word ptr [bx+22], ax	;put the quotient back in memory 
 ;dx from this division (remainder) will be used as the high part of the next number

 mov ax, word ptr [bx+20]	;repeat the algorithm with dx from previous division
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+20], ax

 mov ax, word ptr [bx+18]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+18], ax
 
 mov ax, word ptr [bx+16]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+16], ax

 mov ax, word ptr [bx+14]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+14], ax

 mov ax, word ptr [bx+12]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+12], ax
 
 mov ax, word ptr [bx+10]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+10], ax
 
 mov ax, word ptr [bx+8]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+8], ax

 mov ax, word ptr [bx+6]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+6], ax
 
 mov ax, word ptr [bx+4]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+4], ax
 
 mov ax, word ptr [bx+2]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx+2], ax

 mov ax, word ptr [bx]
 push bx
 mov bx,10
 div bx
 pop bx
 mov word ptr [bx], ax		;repeat for 12 times as we have 12 word -> the last remainder will be one of the numbers we have to show
 
 ;dx holds remainder from division
 
 add dx,30h		;convert to ASCII
 push dx		;push to stack as we will have to print the remainders in reverse order
 
 mov ax, word ptr [bx+22]	;this will check if x, after the division, became 0
 cmp ax,0					;it checks every one of the 12 words and jumps back to divide again if it finds
 je label1					;something different from 0
 jmp divide
 label1:
 
  mov ax, word ptr [bx+20]
 cmp ax,0
 je label2
 jmp divide
 label2:
 
  mov ax, word ptr [bx+18]
 cmp ax,0
 je label3
 jmp divide
 label3:
 
 mov ax, word ptr [bx+16]
 cmp ax,0
 je label4
 jmp divide
 label4:
 
 
  mov ax, word ptr [bx+14]
 cmp ax,0
 je label5
 jmp divide
 label5:
 
  mov ax, word ptr [bx+12]
 cmp ax,0
 je label6
 jmp divide
 label6:
 
  mov ax, word ptr [bx+10]
 cmp ax,0
 je label7
 jmp divide
 label7:
 
  mov ax, word ptr [bx+8]
 cmp ax,0
 je label8
 jmp divide
 label8:
 
  mov ax, word ptr [bx+6]
 cmp ax,0
 je label9
 jmp divide
 label9:
 
  mov ax, word ptr [bx+4]
 cmp ax,0
 je label10
 jmp divide
 label10:
 
  mov ax, word ptr [bx+2]
 cmp ax,0
 je label11
 jmp divide
 label11:
 
 mov ax, word ptr [bx]
 cmp ax,0
 je label12
 jmp divide
 label12:			;it reaches this point only if all the words which make up x are 0
 
 
 lea dx,[bx+26]		;print the corresponding message "Its factorial is: "
 mov ah, 9h
 int 21h
 
 show:				;and print the remainders reversed
 pop dx
 mov ah, 2h
 int 21h
 cmp sp,38h			;check if the stack has any more reminders in it (I found this value, 38h, through tests -> CS and IP are also on the stack)
 jl show
 
 RETF ;back to the procedure which made the call
DIVID ENDP ;end procedure

COD2 ENDS ;end segment
 END ;end of second module 