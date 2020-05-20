.686
.MODEL FLAT, C
.STACK

.CODE
cpy PROC to:dword, from:dword, len:dword
	mov ECX, len

	lea EAX, [to]
	add EAX, len
	cmp EAX, [from]
	jae overlay; Перейти, если больше или равно
	ret

overlay:
	ret

cpy ENDP
END
