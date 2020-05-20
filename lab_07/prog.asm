.686
.MODEL FLAT, C
.STACK

.CODE
cpy PROC to:dword, from:dword, len:dword
	pushf
	mov ECX, len

	mov ESI, from
	mov EDI, to

	cmp ESI, EDI
	je quit

	mov EAX, ESI
	add EAX, len

	cmp EAX, EDI
	jg overlay

	rep movsb

	jmp quit

overlay:
	add ESI, len
	dec ESI
	add EDI, len
	dec EDI

	std

	rep movsb

	jmp quit

quit:
	popf
	ret

cpy ENDP
END
