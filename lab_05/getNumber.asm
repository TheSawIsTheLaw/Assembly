PUBLIC getNumber

PUBLIC currentNumber
PUBLIC curSign

DataS SEGMENT PARA  PUBLIC 'DATA'
    curSign DB '+'
            DB '$'
    currentNumber  DB 17 DUP ('$')
DataS ENDS

Code SEGMENT WORD PUBLIC 'CODE'
    ASSUME CS:Code, DS:DataS
    
getNumber proc near
    mov AH, 1
    int 21h
    mov curSign, AL
    mov CX, 0
forLoop:
    mov AH, 1
    int 21h
    cmp AL, 0Dh
    jz endFor
    mov AH, 0
    mov BX, CX
    mov currentNumber[BX], AL
    inc CX
    cmp CX, 16
    jnz forLoop
endFor:
    mov AL, '$'
    mov BX, CX
    mov currentNumber[BX], AL
    ret
getNumber endp
Code ENDS
END