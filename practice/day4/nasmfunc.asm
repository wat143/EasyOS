;;; naskfunc
section .text
	GLOBAL io_hlt
	GLOBAL write_mem8
io_hlt:
	HLT
	RET
write_mem8:	; void write_mem8(int addr, int data);
	MOV	ECX, [ESP+4]	; Mov 1st arg to ECX
	MOV	AL, [ESP+8]	; Mov second arg to AL
	MOV	[ECX], AL
	RET
