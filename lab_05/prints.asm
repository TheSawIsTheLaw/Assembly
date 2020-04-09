PUBLIC println

DataS SEGMENT WORD 'DATA'
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
Code ENDS
END