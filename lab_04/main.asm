StkSeg SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg ENDS

DataS SEGMENT WORD 'DATA'
rows    DB 0
cols    DB 0
deleted DB 0
mem     DW 0
i       DW 0
j       DW 0
delcols DB 0
deli    DW 0
delj    DW 0
shiftj  DW 0
curEl   DW 0
matrix  DB 90 DUP(?)
elems   DW 0

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
    sub delcols, 1
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

	mov BX, 0
	mov BL, rows
	mov elems, BX
	mov AL, 0
	mov AL, cols
	mul elems
	mov elems, AX
	sub cols, 1
	mov BX, j
	mov delj, BX
	cmp delj, 0
	jz zero
	forhifti:
		mov BX, delj
		mov shiftj, BX
		forshiftj:
			mov BX, shiftj
			mov DL, matrix[BX + 1]
			mov matrix[BX], DL
			inc shiftj
			mov BX, elems
			cmp shiftj, BX
			jl forshiftj
	zero:
		sub elems, 1
		mov BX, 0
		mov BL, cols
		add delj, BX
		mov BX, elems
		cmp delj, BX
		jl forhifti
    
	sub j, 1

    ret

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



delRowSharpLabel:
    call delRowSharp
    jmp returnDelRowSharp
    
MatrixDelCols:
    mov AX, DataS
    mov DS, AX
	
	mov AH, 01h
	int 21h
    
    cmp AL, 30h
    jle Die
    cmp AL, 40h
    jge Die
	
    sub AL, '0'
	mov rows, AL
    
	int 21h
	cmp AL, 20h
	jnz Die
	
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
	mov AH, 01h
fori:
    int 21h
    cmp AL, ' '
    jz fori
    cmp AL, 0Dh
    jz fori
    mov BX, i
    mov matrix[BX], AL
    inc i
    mov AX, mem
    mov AH, 0
    cmp i, AX
    mov AH, 01h
    jnz fori
    
    call printMatrix
    
    mov i, 0

    mov DL, 0Ah
    int 21h
    mov DL, 0Dh
    int 21h
    
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
        inc j
    returnDelRowSharp:
        mov BX, 0
        mov BL, cols
        cmp BX, j
        jg forjDEL
    inc i
    mov BX, 0
    mov BL, rows
    cmp BX, i
    jg foriDEL
    
    call printMatrix
   

Die:
    mov AH, 4Ch
    int 21h
Code ENDS
    END MatrixDelCols