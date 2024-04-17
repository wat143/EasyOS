;  haribote-os
	ORG	0xc200
	MOV	SI, msg
putloop:
	MOV	AL,[SI]
	ADD	SI,1		; Increment
	CMP	AL,0
	JE	fin
	MOV	AH, 0x0e	; Function to show 1 character
	MOV	BX,15		; Color code
	INT	0x10		; Call video BIOS
	JMP	putloop

fin:
	HLT			; Stop CPU till interrupt
	JMP	fin		; Infinite loop

msg:
	DB	0x0a, 0x0a	; 2 new lines
	DB	"load haribote OS"
	DB	0x0a		; 1 new line
	DB	0

	RESB	0x1fe-($-$$)

	DB	0x55, 0xaa
