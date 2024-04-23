void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);

void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);

void HariMain(void)
{
  int i;
  char *p;

  init_palette();

  p = (char *)0xa0000;
  for (i = 0; i <= 0xaffff; i++) {
    p[i] = i & 0x0f;    /* write_mem8(i, i & 0x0f);  */
  }

  for (;;) {
    io_hlt(); // Call io_hlt defined in naskfunc.asm
  }
}

void init_palette(void)
{
  static unsigned char table_rgb[16 * 3] = {
    0x00, 0x00, 0x00,	/*  0: Black */
    0xff, 0x00, 0x00,	/*  1: Light red */
    0x00, 0xff, 0x00,	/*  2: Light green */
    0xff, 0xff, 0x00,	/*  3: Light yellow */
    0x00, 0x00, 0xff,	/*  4: Light blue1 */
    0xff, 0x00, 0xff,	/*  5: Light purpule */
    0x00, 0xff, 0xff,	/*  6: Light blue2 */
    0xff, 0xff, 0xff,	/*  7: White */
    0xc6, 0xc6, 0xc6,	/*  8: Light gray */
    0x84, 0x00, 0x00,	/*  9: Dark red */
    0x00, 0x84, 0x00,	/* 10: Dark green */
    0x84, 0x84, 0x00,	/* 11: Dark yellow */
    0x00, 0x00, 0x84,	/* 12: Dark blue1 */
    0x84, 0x00, 0x84,	/* 13: Dark purpule */
    0x00, 0x84, 0x84,	/* 14: Dark blue2 */
    0x84, 0x84, 0x84	/* 15: Dark gray*/
  };
  set_palette(0, 15, table_rgb);
  return;
}

void set_palette(int start, int end, unsigned char *rgb)
{
  int i, eflags;
  eflags = io_load_eflags();	/* store IRQ flag */
  io_cli(); 			/* disable IRQ */
  io_out8(0x03c8, start);
  for (i = start; i <= end; i++) {
    io_out8(0x03c9, rgb[0] / 4);
    io_out8(0x03c9, rgb[1] / 4);
    io_out8(0x03c9, rgb[2] / 4);
    rgb += 3;
  }
  io_store_eflags(eflags);	/* restore IRQ flag */
  return;
}
