PUBLIC println
PUBLIC printGotNum
PUBLIC printHexNum
PUBLIC printDecNum

EXTRN currentNumber: near
EXTRN numCopy: near

EXTRN hexNum: near
EXTRN decimalNum: near

DataS SEGMENT WORD PUBLIC 'DATA'
DataS ENDS

Code SEGMENT WORD PUBLIC 'CODE'
    ASSUME CS:Code, DS:DataS
    
println proc near
    mov AH, 2
    mov DL, 0Ah
    int 21h
    mov DL, 0Dh
    int 21h
    ret
println endp

printGotNum proc near
    call println
    mov AH, 09
    mov DX, OFFSET currentNumber
    int 21h
    ret
printGotNum endp

printHexNum proc near
    mov DX, offset hexNum
    mov AH, 09h
    int 21h
    ret
printHexNum endp

printDecNum proc near
    mov DX, offset decimalNum
    mov AH, 09h
    int 21h
    ret
printDecNum endp

Code ENDS
END