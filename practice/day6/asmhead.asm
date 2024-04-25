;  haribote-os

	BOTPAK	EQU	0x00280000 ; Load location of bootpak
	DSKCAC	EQU	0x00100000 ; Location of disk cache
	DSKCAC0	EQU	0x00008000 ; Location of disk cache in real mode

	;; Boot info related
	CYLS	EQU	0x0ff0
	LEDS	EQU	0x0ff1
	VMODE	EQU	0x0ff2	; bit info for color
	SCRNX	EQU	0x0ff4	; horizontal resolution
	SCRNY	EQU	0x0ff6	; vertical resolution
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

	;; Mask interrupt so that PIC init successfully
	MOV	AL, 0xff
	OUT	0x21, AL
	NOP			; avoid issue of OUT
	OUT	0xa1, AL

	CLI			; Mask CPU level interrupt
	;; Configure A20GATE so that CPU can access larger than 1MB memory
	CALL	waitkbdout
	MOV	AL, 0xd1
	OUT	0x64, AL
	CALL	waitkbdout
	MOV	AL, 0xdf	; enable A20
	OUT	0x60, AL
	CALL	waitkbdout

	;; Move to protect mode
;;;[INSTRSET "i486p"]		;define to use order by 486
	LGDT	[GDTR0]		; Define temporal GDT
	MOV	EAX, CR0
	AND	EAX, 0x7fffffff	; set bit 31 as 0 to avoid paging
	OR	EAX, 0x00000001	; set bit 0 as 1 to move to protect mode
	MOV	CR0, EAX
	JMP	pipelineflash

pipelineflash:
	MOV	AX,1*8		; read/write segment is 32bit
	MOV	DS,AX
	MOV	ES,AX
	MOV	FS,AX
	MOV	GS,AX
	MOV	SS,AX

	;; transfer bootpack
	MOV	ESI,bootpack	; SRC
	MOV	EDI,BOTPAK	; DST
	MOV	ECX,512*1024/4
	CALL	memcpy

	;; Move disk data
	;; Boot sector

	MOV	ESI,0x7c00	; SRC
	MOV	EDI,DSKCAC	; DST
	MOV	ECX,512/4
	CALL	memcpy

	;; Reminings
	MOV	ESI,DSKCAC0+512	; SRC
	MOV	EDI,DSKCAC+512	; DST
	MOV	ECX,0
	MOV	CL,BYTE [CYLS]
	IMUL	ECX,512*18*2/4	; Convert number of cylinder to byte
	SUB	ECX,512/4	; Remove IPL size
	CALL	memcpy

	;; Complete asmhead task
	;; Start bootpack
	MOV	EBX,BOTPAK
	MOV	ECX,[EBX+16]
	ADD	ECX,3		; ECX += 3;
	SHR	ECX,2		; ECX /= 4;
	JZ	skip		; Nothing to be sent
	MOV	ESI,[EBX+20]	; SRC
	ADD	ESI,EBX
	MOV	EDI,[EBX+12] 	; DST
	CALL	memcpy
skip:
	MOV	ESP,[EBX+12]	; initialize stack
	JMP	DWORD 2*8:0x0000001b

waitkbdout:
	IN	AL,0x64
	AND	AL,0x02
	IN	AL,0x60 	; read for correct behavior
	JNZ	waitkbdout
	RET

memcpy:
	MOV	EAX,[ESI]
	ADD	ESI,4
	MOV	[EDI],EAX
	ADD	EDI,4
	SUB	ECX,1
	JNZ	memcpy		; retry memcpy till ECX=0
	RET

	ALIGNB	16
GDT0:
	RESB	8				; NULL selector
	DW	0xffff,0x0000,0x9200,0x00cf	; 32bit segment for read/write
	DW	0xffff,0x0000,0x9a28,0x0047	; 32bit segment for bootpack process

	DW	0
GDTR0:
	DW	8*3-1
	DD	GDT0

	ALIGNB	16
bootpack:
