#include <stdarg.h>

static int _itos(int val, char *buff) {
  int len = 0, div = 1;
  while ((val % div) != val)
    div *= 10;
  div /= 10;
  while (div > 0) {
    *(buff) = '0' + (val / div);
    buff++;
    val = val % div;
    div /= 10;
    len++;
  }
  return len;
}

int sprintf(char *buff, char *fmt, ...) {
  va_list arg;
  int len = 0, tmp_len = 0, i;

  va_start(arg, fmt);
  while (fmt && buff) {
    if (*fmt == '%') {
      fmt++;
      switch (*fmt) {
      case 'd':
	tmp_len = _itos(va_arg(arg, int), buff);
	break;
      default:
	*(buff++) = '%';
	*(buff++) = *(fmt++);
	len += 2;
	continue;
      }
      buff += tmp_len;
      fmt++;
      len += tmp_len;
    }
    else if (*fmt == '\n')
      break;
    else {
      *(buff++) = *(fmt++);
      len++;
    }
  }
  va_end(arg);
  *buff = '\0';
  return len;
}
