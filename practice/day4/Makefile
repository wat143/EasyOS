MAKE = make
IMG = haribote.img
IPL = ipl10.asm
OBJS = haribote.asm
ASM = nasm
GCC = i686-linux-gnu-gcc
QEMU = qemu-system-i386

default:
	make img
clean:
	rm *.bin
	rm *.o
	rm *.hrb
	rm *.sys
	rm *.img
ipl10.bin: ipl10.asm
	nasm ipl10.asm -o ipl10.bin
asmhead.bin: asmhead.asm
	nasm asmhead.asm -o asmhead.bin
nasmfunc.o: nasmfunc.asm
	nasm -g -f elf nasmfunc.asm -o nasmfunc.o
bootpack.hrb: bootpack.c nasmfunc.o
	$(GCC) -march=i386 -m32 -nostdlib -fno-pic -T har.ld bootpack.c nasmfunc.o -o bootpack.hrb
haribote.sys: asmhead.bin bootpack.hrb
	cat asmhead.bin bootpack.hrb > haribote.sys
haribote.img: ipl10.bin haribote.sys
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ::
img:
	$(MAKE) haribote.img
run:
	$(QEMU) -fda $(IMG)
