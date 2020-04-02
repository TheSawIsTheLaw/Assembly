StkSeg SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg ENDS

DataS SEGMENT WORD 'DATA'
rows    		DB 0 ; Количество строк
cols    		DB 0 ; Количество стобцов
mem     		DW 0 ; Произведение строк и столбцов
i       		DW 0 ; Индекс строки при проходе в матрице
j       		DW 0 ; Индекс столбца при проходе в матрице
delcols 		DB 0 ; Количество строк после удаления
deli    		DW 0 ; Индекс строки при удалении
delj    	   	DW 0 ; Индекс столбца при удалении
curEl   	   	DW 0 ; Текущий элемент при удалении
matrix  	   	DB 81 DUP(?)
nonSharpMatrix 	DB 81 DUP(?)

getMessage DB 0Ah
           DB 0Ah
           DB 0Dh
           DB 'Matrix:'
           DB 0Ah
           DB 0Dh
           DB '$'

DataS ENDS

Code SEGMENT WORD 'CODE'
    ASSUME CS:Code, DS:DataS
delRowSharp proc near
    mov deli, 0
    mov BL, cols
    mov delcols, BL
    sub delcols, BL
    fordeli:
        mov BX, j
        mov delj, BX
        fordelj:
            mov AX, deli
            mul cols
            mov curEl, AX
            mov BX, delj
            add curEl, BX
            mov BX, curEl
            mov DL, matrix[BX + 1]
            mov matrix[BX], DL
            inc delj
            mov BX, 0
            mov BL, delcols
            cmp BX, delj
            jg fordelj
        inc deli
        mov BX, 0
        mov BL, rows
        cmp BX, deli
        jg fordeli
		
	
	cmp j, 0
	jnz decr
	jmp withoutinc
back:
	
	ret
	
decr:
mov BX, 0
	mov BL, rows
	cmp j, BX
	jnz truly
	jmp back

truly:
	sub j, 1
	jmp back

delRowSharp ENDP

printMatrix proc near
    mov AH, 09h
    mov DX, OFFSET getMessage
    int 21h

    mov i, 0
foriprint:
    mov j, 0
    forjprint:
        mov AX, i
        mul cols
        mov curEl, AX
        mov BX, j
        add curEl, BX
        mov BX, curEl
        mov DL, matrix[BX]
        mov AH, 02h
        int 21h
        mov DL, ' '
        int 21h
        inc j
        mov BX, 0
        mov BL, cols
        cmp BX, j
        jg forjprint
    inc i
    mov BX, 0
    mov BL, rows
    cmp BX, i
    mov DL, 0Ah
    int 21h
    mov DL, 0Dh
    int 21h
    jg foriprint
    
    ret

printMatrix ENDP

printDelMatrix proc near
    mov AH, 09h
    mov DX, OFFSET getMessage
    int 21h

    mov i, 0
fordeliprint:
    mov j, 0
    fordeljprint:
        mov AX, i
        mul delcols
        mov curEl, AX
        mov BX, j
        add curEl, BX
        mov BX, curEl
        mov DL, nonSharpMatrix[BX]
        mov AH, 02h
        int 21h
        mov DL, ' '
        int 21h
        inc j
        mov BX, 0
        mov BL, delcols
        cmp BX, j
        jg fordeljprint
    inc i
    mov BX, 0
    mov BL, rows
    cmp BX, i
    mov DL, 0Ah
    int 21h
    mov DL, 0Dh
    int 21h
    jg fordeliprint
    
    ret

printDelMatrix ENDP


delRowSharpLabel:
    call delRowSharp
    jmp returnDelRowSharp
    
MatrixDelCols:     ; main
    mov AX, DataS
    mov DS, AX
	
	mov AH, 01h
	int 21h
    
	; Если первое введённое значение <= 0 или >= 10, то завершаем программу
    cmp AL, 30h
    jle Die        
    cmp AL, 40h
    jge Die        
	
    sub AL, '0' ; Вычисляем введённое значение по коду элементов
	mov rows, AL
    
	; Если второе введённое значение != пробелу, то заврешаем программу
	int 21h
	cmp AL, 20h
	jnz Die
	
	; Аналогия по первоему элементу
	int 21h
    cmp AL, 30h
    jle Die
    cmp AL, 40h
    jge Die
    sub AL, '0'
	mov cols, AL
	
    mov AH, 02h
	mov DL, 10
	int 21h
	

;   DEBUG
;	mov DL, rows
;	int 21h
;	mov DL, 20h
;	int 21h
;	mov DL, cols
;	int 21h
;   DEBUG

    mov AX, 0
	mov AL, rows
    mul cols
    mov mem, AX
; Ввод линейно расположенной матрицы
fori:
    mov AH, 01h
    int 21h
    cmp AL, ' '  ; Пропускаем все переданные пробелы
    jz fori
    cmp AL, 0Dh  ; Пропускаем все переданные перезоды на новую строку
    jz fori
	cmp AL, 0Ah
    jz fori
    mov BX, i
    mov matrix[BX], AL
    inc i
    mov AX, mem
    mov AH, 0
    cmp i, AX
    jnz fori
    
    call printMatrix
    
    mov i, 0

    mov DL, 0Ah
    int 21h
    mov DL, 0Dh
    int 21h

; Нахождение символов '#' и их удаление
foriDEL:
    mov j, 0
    forjDEL:
        mov AX, i
        mul cols
        mov curEl, AX
        mov BX, j
        add curEl, BX
        mov BX, curEl
        cmp matrix[BX], '#'
        je delRowSharpLabel
    returnDelRowSharp:
		inc j
	withoutinc:
        mov BX, 0
        mov BL, cols
        cmp BX, j
        jg forjDEL
    inc i
    mov BX, 0
    mov BL, rows
    cmp BX, i
    jg foriDEL
	
	mov i, 0
	mov deli, 0
fornewmati:
	mov j, 0
	fornewmatj:
		mov AX, i
		mul cols
		mov curEl, AX
		mov BX, j
		add curEl, BX
		mov BX, curEl
		mov CH, matrix[BX]
		mov BX, deli
		mov nonSharpMatrix[BX], CH
		inc j
		inc deli
		mov BX, 0
        mov BL, delcols
        cmp BX, j
		jg fornewmatj
	inc i
	mov BX, 0
    mov BL, rows
    cmp BX, i
    jg fornewmati
	
	call printDelMatrix
Die:
    mov AH, 4Ch
    int 21h
Code ENDS
    END MatrixDelCols
	
