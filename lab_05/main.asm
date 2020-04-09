EXTRN println: near
EXTRN getNumber: near

StkSeg SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg ENDS

DataS SEGMENT PARA 'DATA'
    menuMessage    DB 'Choose the paragraph of menu:', 0Ah, 0Dh
                   DB '1. Put the number', 0Ah, 0Dh
                   DB '2. Make the number to unsigned in hex and print', 0Ah, 0Dh
                   DB '3. Make the number to signed in decimal and print', 0Ah, 0Dh
                   DB '4. Print current number', 0Ah, 0Dh
                   DB '5. Exit', 0Ah, 0Dh
                   DB 'Your choice: '
                   DB '$'
                   
    currentNumber  DB 16 DUP (30h)
                
    functionsArray DW getNumber, die
DataS ENDS

Code SEGMENT WORD PUBLIC 'CODE'
    ASSUME CS:Code, DS:DataS
    
main:
    mov AX, DataS
	mov DS, AX
menu:
    mov DX, OFFSET menuMessage
    mov AH, 09h
    int 21h
    
    mov AH, 01h
    int 21h
    
    mov AH, 0
    sub AL, '1'
    mov DL, 2
    mul DL
    mov BX, AX
    
    call println
    call println
    call functionsArray[BX]
    call println
    call println
    call println
    jmp menu

die proc near
    mov AH, 4Ch
    int 21h
die endp

Code ENDS
END main