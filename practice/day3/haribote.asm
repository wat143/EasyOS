;  haribote-os
	ORG	0xc200		; Program load location
	MOV	AL, 0x13	; VGA graphics 320x200x8bit color setting for BIOS
	MOV	AH, 0x00
	INT	0x10		; Call BIOS
fin:
	HLT
	JMP	fin
