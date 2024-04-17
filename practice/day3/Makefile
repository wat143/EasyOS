MAKE = make
OBJS = ipl.asm
IMG = ipl.img
ASM = nasm
QEMU = qemu-system-i386

clean:
	rm $(IMG)
img:
	$(ASM) $(OBJS) -o $(IMG)
run:
	$(MAKE) img
	$(QEMU) -fda $(IMG)
