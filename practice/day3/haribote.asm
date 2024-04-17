;  haribote-os
	;; Boot info related
	CYLS	EQU	0x0ff0
	LEDS	EQU	0x0ff1
	VMODE	EQU	0x0ff2	; bit info for color
	SCRNX	EQU	0x0ff4	; horizontal resolution
	SCRNY	EQU	0x00f6	; vertical resolution
	VRAM	EQU	0x0ff8	; start address of the graphics buffer
	
	ORG	0xc200		; Program load location
	MOV	AL, 0x13	; VGA graphics 320x200x8bit color setting for BIOS
	MOV	AH, 0x00
	INT	0x10		; Call BIOS
	MOV	BYTE [VMODE], 8	; remember display mode
	MOV	WORD [SCRNX], 320
	MOV	WORD [SCRNY], 200
	MOV	DWORD [VRAM], 0x000a0000

	;; Get keyboard LED information from BIOS
	MOV	AH, 0x02
	INT	0x16		; keyboard BIOS
	MOV	[LEDS], AL

fin:
	HLT
	JMP	fin
