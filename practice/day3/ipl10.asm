; hello-os
CYLS	EQU	10		; Define cylinder number to be read

	ORG	0x7c00		; Address where this program is loaded

	JMP	entry
	DB	0x90
	DB	"HARIBOTE" 	; Boot sector name
	DW	512	   	; Sector size. This shall be 512.
	DB	1		; Cluster size. This shall be 1 sector.
	DW	1		; The location FAT starts.
	DB	2		; The number of FAT. This shall be 2.
	DW	224		; The size of root directory.
	DW	2880		; This drive size. 2880 sectors.
	DB	0xf0		; Media type.
	DW	9		; Length of the FAT.
	DW	18		; The number of sectors contained in the track.
	DW	2		; The number of heads.
	DD	0		; Magic number.(0 if no partition)
	DD	2880		; Write drive size again.
	DB	0, 0, 0x29	; Magic number
	DD	0xffffffff	; Magic number
	DB	"HARIBOTEOS "	; Disk name(11 Byte)
	DB	"FAT12   "	; Format name(8 Byte)
	TIMES	18 DB 0

	;; Here program starts
entry:
	MOV	AX, 0		; Initialize registers
	MOV	SS, AX
	MOV	SP, 0x7c00
	MOV	DS, AX

	;; Read disk
	MOV	AX, 0x0820	; Start address to store disk data
	MOV	ES, AX
	MOV	CH, 0		; Cylinder 0
	MOV	DH, 0		; Head 0
	MOV	CL, 2		; Sector 2
readloop:
	MOV	SI, 0		; for error counter
retry:
	MOV	AH, 0x02	; AH=0x02 : Disk read operation for BIOS
	MOV	AL, 1		; 1 sector
	MOV	BX, 0
	MOV	DL, 0x00	; A drive
	INT	0x13		; Call disk BIOS
	JNC	next		; jump to fin if no erro
	ADD	SI, 1		; Increment retry counter
	CMP	SI, 5		; Check retry count
	JAE	error		; Jump if SI >= 5
	MOV	AH, 0x00
	MOV	DL, 0x00	; Reset A drive
	INT	0x13		; Reset interrupt
	JMP 	retry
next:
	MOV	AX, ES
	ADD	AX, 0x0020	; Add 0x0020 to current load address
	MOV	ES, AX		; Move Addr+0x0020 (0x0020 = 516/16, i.e. size of 1 sector)
	ADD	CL, 1
	CMP	CL, 18		
	JBE	readloop	; move forward till sector 18
	MOV	CL, 1		; Set sector 1
	ADD	DH, 1		; Add 1 to head
	CMP	DH, 2
	JB	readloop	; Jump if DH < 2
	MOV	DH, 0
	ADD	CH, 1		; Add 1 to cylinder
	CMP	CH, CYLS
	JB	readloop	; Jump if CH < 10

	MOV	[0x0ff0], CH	; store CH number
	JMP	0xc200

error:
	MOV	AX, 0
	MOV	ES, AX
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
	DB	"load error"
	DB	0x0a		; 1 new line
	DB	0

	RESB	0x1fe-($-$$)
	DB	0x55, 0xaa
