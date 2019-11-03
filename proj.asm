EXTRN MULTIP:FAR	;the multiplication procedure
EXTRN DIVID:FAR		;the division procedure

STCK	SEGMENT PARA STACK 'stack'
	DB		64 DUP (0)
STCK	ENDS


DATA1	SEGMENT PARA PUBLIC 'DATA'

xl	dq	1		;the lower part (least significant bits) of the number we will obtain (as we work with multiplication, it has to be one)
xm	dq 	0		;middle part ("middle" significant bits)
xh  dq  0		;higher part (most significant bits)
y	dw	0		;the varaible which holds the number foe which we must compute the factorial
msg2 db "Its factorial is: $"
msg1 db "Enter a natural number up to 40: $"
msg3 db 0ah,"Would you like to try again? <y/n>$"
msg4 db 0ah,"Invalid input","$"
msg5 db "You have not introduced anything$"
msg6 db 0ah,"Have a nice day!$"
DATA1	ENDS

IF1
	INCLUDE MACR.MAC	;we include the macro library which contains the MAKEZERO macro
ENDIF

COD1	SEGMENT PARA PUBLIC 'CODE'

MAIN	PROC	FAR

ASSUME	CS:COD1,DS:DATA1,SS:STCK

			PUSH	DS
			XOR	AX, AX
			PUSH	AX
			MOV		AX,DATA1
			MOV		DS,AX			;pseudo instructions
			

start:
	lea DX,MSG1
	mov AH,9
	int 21H		;print the first message
	
read:
	mov ah, 01h
	int 21h		;take care if the first character the user inputs
	cmp al,0dh
	je havenot	;check if the user inputs directly Enter -> if yes, go and print the corresponding message
	cmp al,'0'
	jb badinput
	cmp al,'9'
	ja badinput	;check if it's the ASCII code of a number; if not go and print the corresponding message
	sub al,'0'	;transform from ASCII to usable numbers
	add byte ptr [y],al		;store in y
	int 21h		;take care of the next character
	cmp al,0dh	
	je exitwoenter		;if it's Enter, there is no need of printing another new line
	cmp al,'0'
	jb badinput
	cmp al,'9'
	ja badinput	;check if it's the ASCII code of a number; if not go and print the corresponding message
	sub al,'0'	;transform from ASCII to usable numbers
	mov bl,al
	mov bh,0
	mov ax,y
	mov cx,10
	mul cx
	add ax,bx	;multiply y by 10 and add the number we last read
	cmp ax,40	;compare it with 40 (the program computes the factorial of numbers up until 40)
	jbe goodinput1	;if it's less, proceed; else go automatically to bad input
badinput:
	lea DX,MSG4	;print the vad input message
	mov AH,9
	int 21H
	jmp tryagain	;go to try again label
havenot:
	lea DX,MSG5		;print the message telling the user they have not introduced anything
	mov AH,9
	int 21H
	jmp tryagain	;go to try again label
goodinput1:
	mov y,ax	;if the input is good, we can move it to y
	
exitwenter:

mov dx,0ah	;prints a new line
mov ah, 2h
int 21h
			
exitwoenter:

		
lea bx, xl	;moves the address of the number's lower part to bx
CALL MULTIP	;call the multiplication procedure to compute xl,xm and xh
CALL DIVID	;call the division procedure to print the number in decimal
 
 
 tryagain:
 
 lea DX,MSG3	;print the message asking the user if they will like to try again
	mov AH,9
	int 21H
	
	mov ah, 01h
	int 21h
	cmp al,'y'	;if the answer is not 'y' jump to corresponding label
	jne exitall
	mov dx,0ah	;else print a new line
	mov ah, 2h
	int 21h
	MAKEZERO y, xl, xm, xh	;initialize x and y
	jmp start	;and go to the beginning
	exitall:
	
	cmp al,'n'	;if the answer is not 'y' nor 'n' ask again until the user inputs what it is asked
	jne tryagain
	
	lea dx,msg6	;if the answer is 'n' print a goodbye message than exit
	mov ah,9
	int 21h
			RET

MAIN	ENDP

COD1	ENDS
			END	MAIN