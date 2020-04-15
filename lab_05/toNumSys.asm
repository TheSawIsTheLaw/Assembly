PUBLIC toUnsignedHex
PUBLIC toSignedDec

PUBLIC numCopy
PUBLIC hexNum
PUBLIC decimalNum

EXTRN currentNumber: near
EXTRN curSign: near
EXTRN printDecNum: near
EXTRN printHexNum: near

DataS SEGMENT WORD PUBLIC 'DATA'
    numCopy  DB 17 DUP ('$')
    numSize  DW 1
    copySize DB 1
    degree   DW 1

    hexNum DB 5 DUP ('$')
    decimalNum DB '+' 
         DB 6 DUP ('$')
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
    
    mov mem, 0
    mov bmem, AH
    mov BL, 4
    sub BL, bmem
    mov copySize, 0
    add copySize, BL
    
    
    mov BL, 12
    mov bmem, 4
    mul bmem
    sub BL, AL
    add copySize, BL
    
    cmp copySize, 0
    je endFor
    
noMainZeroes:
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

complementeAdd proc near
    mov BX, 0
    mov AX, CurSign[BX]
    mov AH, 0
    cmp AX, '-'
    jnz compEnd
    
    mov CX, 0
forCompleted:
    mov BX, CX
    mov DH, numCopy[BX]
    inc CX
    cmp DH, '$'
    je endForComp
    cmp DH, '1'
    jz decDec
    jnz incDec
backDecInc:
    mov numCopy[BX], DH
    jmp forCompleted
    
endForComp:
    mov CX, 16
forSum:
    dec CX
    mov BX, CX
    mov DH, numCopy[BX]
    cmp DH, '1'
    jz decDecC
    jnz incDecC
backdecincDecC:
    mov numCopy[BX], DH
    cmp CX, 0
    jz endForSum
    cmp DH, '0'
    jz forSum
endForSum:
compEnd:
    ret
    
decDec:
    dec DH
    jmp backDecInc
 
incDec:
    inc DH
    jmp backDecInc
    
decDecC:
    dec DH
    jmp backdecincDecC
 
incDecC:
    inc DH
    jmp backdecincDecC
complementeAdd endp
    
toUnsignedHex proc near
    call makeTetradeCopy
    call complementeAdd
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
    call printHexNum
    ret
    
toLetter:
    add DL, 7
    jmp back
    
toUnsignedHex endp

getHexSum proc near
    mov CX, 0
forDec:
    mov BX, CX
    mov DX, currentNumber[BX]
    inc CX
    cmp DH, '$'
    je endForDec
    cmp CX, 16
    jnz forDec
endForDec:    
    mov numSize, CX
    mov BX, numSize
    mov degree, 1
    mov mem, 0
    
    dec BX
    
forToSum:
    mov AX, degree
    mov DX, currentNumber[BX]
    sub DL, '0'
    mov DH, 0
    mul DX
    add mem, AX
    mov AX, 2
    mul degree
    mov degree, AX
    dec BX
    cmp BX, startEnd
    jge forToSum
    
    ret
getHexSum endp

toSignedDec proc near
    call getHexSum
    
    mov CX, 1
    mov BX, 10
    mov AX, mem
    cmp AX, 65535
    je forDecTrans
    cmp AX, 9
    jle endDecTrans
forDecTrans:
    mov AX, mem
    mov DX, 0
    div BX
    push DX
    mov mem, AX
    inc CX
    cmp AX, 10
    jge forDecTrans
endDecTrans:
    push AX
    
    mov mem, CX
    mov CX, 1
forStack:
    pop DX
    mov BX, CX
    add DL, '0'
    mov decimalNum[BX], DL
    inc CX
    cmp CX, mem
    jle forStack
    
    mov AX, 0
    mov AL, '+'
    mov BX, 0
    mov BX, curSign[BX]
    mov BH, 0
    cmp BX, AX
    jne changeSignDec
changeBack:
    
    call printDecNum
    mov BX, 0
    mov decimalNum[BX], '+'
    
    ret
    
changeSignDec:
    mov BX, 0
    mov decimalNum[BX], '-'
    jmp changeBack
toSignedDec endp

Code ENDS
END
























