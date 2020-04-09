PUBLIC getNumber

DataS SEGMENT WORD 'DATA'
    currentNum DB 16 DUP(30)
DataS ENDS

Code SEGMENT WORD PUBLIC 'CODE'
    ASSUME CS:Code, DS:DataS
    
getNumber proc near
    mov CX, 0
forLoop:
    mov AH, 1
    int 21h
    cmp AL, 0Dh
    jz endFor
    mov AH, 0
    mov BX, CX
    mov currentNum[BX], AL
    inc CX
    cmp CX, 16
    jnz forLoop
endFor:
    ret
getNumber endp
Code ENDS
END