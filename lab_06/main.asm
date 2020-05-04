.model TINY

Code SEGMENT
    assume CS: Code, DS: Code
    org 100h ; PSP?
    
start:
    jmp initialization
    tempH DD ?
    installation DW 666
    curState DB '1'
    
resident proc near
    push AX
    push BX
    push DX
    push CX
    push ES
    push DS
    pushf
    
    call CS:tempH ; black magic?
    
    mov AX, 0B800h
    mov ES, AX
    mov DI, 300
    
    mov AH, 2Ah
    int 21h
    
    cmp curState, '1'
    jnz printDayWeek
    inc curState
    
    mov AX, 0
    mov AL, DL
    mov DL, 10
    div DL
    mov DL, AL
    add DL, '0'
    mov AH, 02h
    int 21h
    
    mov DL, AH
    add DL, '0'
    stosw
    
    jmp return
    
printDayWeek:
    dec curState
    
    mov DL, 10
    div DL
    add AL, '0'
    stosw
    mov DL, AH
    mov AL, DL
    add AL, '0'
    stosw
    
return:
    pop DX
    pop ES
    pop CX
    pop DX
    pop BX
    pop AX
    
    iret
resident endp
    
initialization:
    mov AL, 5Eh
    mov AH, 35h
    int 21h
    
    cmp ES:installation, 666
    jz uninstallation
    
    mov word ptr tempH, BX
    mov word ptr tempH + 2, ES
    
    mov AL, 5Eh ; Мб убрать или безопасность?
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
    mov AL, 5Eh
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
    
    
installation_message DB 'Voila! We are ready.', '$'
uninstallation_message DB 'Voila! Thanks for usage!', '$'
    
Code ENDS
end start