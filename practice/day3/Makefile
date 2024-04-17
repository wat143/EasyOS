MAKE = make
IMG = haribote.img
IPL = ipl.asm
OBJS = haribote.asm
ASM = nasm
QEMU = qemu-system-i386

clean:
	rm $(IMG)
ipl.bin:ipl.asm
	nasm ipl.asm -o ipl.bin
sys: haribote.asm
	nasm haribote.asm -o haribote.sys
img:
	mformat -f 1440 -C -B ipl.bin -i $(IMG) ::
	mcopy -i $(IMG) haribote.sys ::
run:
	$(MAKE) img
	$(QEMU) -fda $(IMG)
