.686
.MODEL FLAT, C
.STACK

.CODE
cpy PROC to:dword, from:dword, len:dword
	mov eax, to
	ret
cpy ENDP
END
