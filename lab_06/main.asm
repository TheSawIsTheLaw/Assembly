.model TINY

Code SEGMENT
    assume CS: Code, DS: Code
    org 100h ; PSP?
    
start:
    jmp initialization
    tempH        DD ?
    installation DW 666
    tempReg      DB ?
    tempBReg     DW ?
    
resident proc near
    push AX
    push BX
    push DX
    push CX
    push ES
    push DS
    pushf
    
    call CS:tempH
    
    mov AX, 0B800h
    mov ES, AX
    mov DI, 300
    
    mov ah, 1
    int 16h
    
    cmp al, 'z'
    je printData
    
    cmp al, 'x'
    je printYear
    
    jmp return
    
printData:
    mov AH, 2Ah
    int 21h
    
    mov AX, 0
    mov AL, DL
    mov DL, 10
    div DL
    add AL, '0'
    mov tempReg, AH
    mov AH, 31
    stosw
    mov AH, tempReg
    
    mov AL, AH
    add AL, '0'
    mov AH, 31
    stosw
    
    mov AL, '.'
    stosw
    
    mov AX, 0
    mov AL, DH
    mov DL, 10
    div DL
    add AL, '0'
    mov tempReg, AH
    mov AH, 31
    stosw
    mov AH, tempReg
    
    mov AL, AH
    add AL, '0'
    mov AH, 31
    stosw
    
    jmp return
    
printYear:
    mov AH, 2Ah
    int 21h

    mov DX, 0
    mov AX, CX
    mov CX, 10
    div CX
    mov tempBReg, AX
    mov AL, DL
    add AL, '0'
    mov AH, 81h
    add DI, 6
    stosw
    mov AL, ' '
    stosw
    sub DI, 6
    
    mov AX, tempBReg
    div CX
    mov tempBReg, AX
    mov AL, DL
    add AL, '0'
    mov AH, 81h
    stosw
    sub DI, 4
    
    mov AX, tempBReg
    div CL
    mov tempReg, AL
    mov AL, AH
    add AL, '0'
    mov AH, 81h
    stosw
    sub DI, 4
    
    mov AL, tempReg
    add AL, '0'
    mov AH, 81h
    stosw
    
return:
    pop DS
    pop ES
    pop CX
    pop DX
    pop BX
    pop AX
    
    iret
resident endp
    
initialization:
    mov AL, 09h
    mov AH, 35h
    int 21h
    
    cmp ES:installation, 666
    jz uninstallation
    
    mov word ptr tempH, BX
    mov word ptr tempH + 2, ES
    
    mov AL, 09h
    mov DX, offset resident
    mov AH, 25h
    int 21h
    
    mov DX, offset installation_message
    mov AH, 09h
    int 21h
    
    mov dx, offset initialization
    int 27h
    
uninstallation:
    push ES
    push DS
    
    mov dx, word ptr ES:tempH
    mov DS, word ptr ES: tempH + 2
    mov AL, 09h
    mov AH, 25h
    int 21h
    
    pop DS
    pop ES
    
    mov AH, 49h
    int 21h
    
    mov AH, 09h
    mov dx, offset uninstallation_message
    int 21h
    
    mov AX, 4C00h
    int 21h
    
    
installation_message   DB 'Voila! We are ready.', '$'
uninstallation_message DB 'Voila! Thanks for usage!', '$'
    
Code ENDS
end start