PUBLIC toUnsignedHex
PUBLIC toSignedDec

PUBLIC numCopy

EXTRN currentNumber: near

DataS SEGMENT WORD PUBLIC 'DATA'
    numCopy  DB 17 DUP ('$')
    numSize  DW 1
    copySize DB 1
    degree   DW 1

    hexNum DB 5 DUP ('$')
    decimalNum DB '+' 
         DB 5 DUP ('$')
    startEnd DW 0
    mem  DW 1
    bmem DB 1
    cur  DW 1
DataS ENDS

Code SEGMENT WORD PUBLIC 'CODE'
    ASSUME CS:Code, DS:DataS
makeTetradeCopy proc near
    mov CX, 0
forHex:
    mov BX, CX
    mov DX, 0
    mov DX, currentNumber[BX]
    inc CX
    cmp DH, '$'
    je endHex
    cmp CX, 16
    jnz forHex
endHex:    
    mov numSize, CX
    
    mov BX, 4
    mov mem, CX
    mov AX, mem
    
    div BL
    
    cmp AH, 0
    mov mem, 0
    jz endFor
    mov bmem, AH
    mov BL, 4
    sub BL, bmem
    
    mov copySize, 0
    add copySize, BL
    mov BX, 0
    mov BL, copySize
    mov mem, BX
forZero:
    dec copySize
    mov BL, copySize
    mov numCopy[BX], '0'
    cmp copySize, 0
    jnz forZero
endFor:

    mov CX, 0
    mov DX, 0
forIn:
    mov BX, CX
    mov DX, currentNumber[BX]
    cmp currentNumber[BX], '$'
    je endForIn
    mov cur, DX
    mov BX, mem
    mov numCopy[BX], DL
    inc mem
    inc CX
    jmp forIn
endForIn:
    ret
makeTetradeCopy endp
    
toUnsignedHex proc near
    call makeTetradeCopy
    mov CX, 0
forTrans:
    mov AX, CX
    mov bmem, 4
    mul bmem
    mov bmem, AL
    mov BX, 0
    mov BL, bmem
    cmp numCopy[BX], '$'
    je endForTrans
    mov DL, 0
    mov AL, numCopy[BX]
    sub AL, '0'
    mov bmem, 8
    mul bmem
    mov bmem, AL
    add DL, bmem
    inc BX
    mov AL, numCopy[BX]
    sub AL, '0'
    mov bmem, 4
    mul bmem
    mov bmem, AL
    add DL, bmem
    inc BX
    mov AL, numCopy[BX]
    sub AL, '0'
    mov bmem, 2
    mul bmem
    mov bmem, AL
    add DL, bmem
    inc BX
    mov AL, numCopy[BX]
    sub AL, '0'
    mov bmem, 1
    mul bmem
    mov bmem, AL
    add DL, bmem
    add DL, '0'
    cmp DL, '9'
    jg toLetter
back:
    mov BX, CX
    mov hexNum[BX], DL
    
    inc CX
    JMP forTrans
endForTrans:
    mov DX, offset hexNum
    mov AH, 09h
    int 21h
    ret
    
toLetter:
    add DL, 7
    jmp back
    
toUnsignedHex endp

toSignedDec proc near
    mov CX, 0
forDec:
    mov BX, CX
    mov DX, 0
    mov DX, currentNumber[BX]
    inc CX
    cmp DH, '$'
    je endForDec
    cmp CX, 16
    jnz forDec
endForDec:    
    mov numSize, CX
    cmp CX, 16
    je setSign
backSet:
    mov BX, numSize
    mov degree, 1
    mov mem, 0
    
    dec BX
    
forToSum:
    mov AX, degree
    mov DX, currentNumber[BX]
    sub DX, '0'
    mul DX
    mov AH, 0
    add mem, AX
    mov AX, 2
    mul degree
    mov degree, AX
    dec BX
    cmp BX, startEnd
    jge forToSum
    
    mov AH, 02h
    add mem, 48
    mov DX, mem
    int 21h
    
    ret
    
setSign:
    mov DX, currentNumber
    cmp DX, '1'
    mov startEnd, 1
    je setMinus
    jmp backSet
    
setMinus:
    mov decimalNum[0], '-'
    jmp backSet
    
toSignedDec endp

Code ENDS
END
























