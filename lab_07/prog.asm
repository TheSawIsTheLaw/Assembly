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
	mov ESI, from
	mov EDI, to
	REP movsb
	ret

overlay:
; тут просто меняем флаг DF и старт прохода на + len
	ret

cpy ENDP
END
