#include "hankaku.h"
#include "utils.h"
#include "bootpack.h"

void HariMain(void)
{
  char *vram;
  int mx, my;
  struct BOOTINFO *binfo = (struct BOOTINFO*)0x0ff0;
  char s[40] = {'\0'}, mcursor[256] = {'\0'};

  init_gdtidt();
  init_palette();
  init_screen8(binfo->vram, binfo->scrnx, binfo->scrny);
  mx = (binfo->scrnx - 16) / 2;
  my = (binfo->scrny - 28 - 16) / 2;
  init_mouse_cursor8(mcursor, COL8_008484);
  putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);
  sprintf(s, "(%d, %d)\n", mx, my);
  putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);

  for (;;) {
    io_hlt(); // Call io_hlt defined in naskfunc.asm
  }
}
