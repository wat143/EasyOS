/* https://vanya.jp.net/os/haribote.html#hrb */
OUTPUT_FORMAT("binary");
OUTPUT_ARCH("i386");

SECTIONS
{
    .head 0x0 : {
        LONG(64 * 1024)       /*  0 : stack+.data+heap size (4K aligned) */
        LONG(0x69726148)      /*  4 : signature "Hari" */
        LONG(0)               /*  8 : mmarea size (4K aligned) */
        LONG(0x310000)        /* 12 : stack initial value and data destination */
        LONG(SIZEOF(.data))   /* 16 : .data size */
        LONG(LOADADDR(.data)) /* 20 : file location of .data */
        LONG(0xE9000000)      /* 24 : 0xE9000000 */
        LONG(HariMain - 0x20) /* 28 : entry address - 0x20 */
        LONG(0)               /* 32 : heap start address */
    }

    .text : { *(.text) }

    .data 0x310000 : AT ( ADDR(.text) + SIZEOF(.text) ) {
        *(.data)
        *(.rodata*)
        *(.bss)
    }

    /DISCARD/ : { *(.eh_frame) }

}
