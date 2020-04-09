PUBLIC println
PUBLIC printGotNum

EXTRN currentNumber: near

DataS SEGMENT WORD PUBLIC 'DATA'
DataS ENDS

Code SEGMENT WORD PUBLIC 'CODE'
    ASSUME CS:Code, DS:DataS
    
println proc near
    mov AH, 2
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h
    ret
println endp

printGotNum proc near
    call println
    mov DX, OFFSET currentNumber
    mov AH, 09
    int 21h
    ret
printGotNum endp
Code ENDS
END