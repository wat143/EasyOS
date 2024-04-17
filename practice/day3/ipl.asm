; hello-os
	ORG	0x7c00		; Address where this program is loaded

	JMP	entry
	DB	0x90
	DB	"HELLOIPL" 	; Boot sector name
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
	DB	"HELLO-OS   "	; Disk name(11 Byte)
	DB	"FAT12   "	; Format name(8 Byte)
	TIMES	18 DB 0

	;; Here program starts
entry:
	MOV	AX, 0		; Initialize registers
	MOV	SS, AX
	MOV	SP, 0x7c00
	MOV	DS, AX
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
	DB	"hello, world"
	DB	0x0a		; 1 new line
	DB	0

	RESB	0x1fe-($-$$)

	DB	0x55, 0xaa
