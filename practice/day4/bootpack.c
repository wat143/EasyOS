extern void io_hlt(void);

void HariMain(void)
{
 fin:
  io_hlt(); // Call io_hlt defined in naskfunc.asm
  goto fin;
}
