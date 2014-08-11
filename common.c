
#include "common.h"

int isspace(char c) {
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
}

char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(fd, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
		dest[i] = src[i];
	}
	return dest;
}

char* trim(char* orig) {
	char* head;
	char* tail;
	char* new;
	head = orig;
	tail = orig;
	while (isspace(*head)) { head++ ; }
	while (*tail) { tail++; }
	do { tail--; } while (isspace(*tail));
	new = malloc(tail-head+2);
	strncpy(new,head,tail-head+1);
	new[tail-head+1] = '\0';
	return new;
}

char *
itoa(int value)
{
  char tmp[33];
  char *string;
  char *tp;
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
  {
    i = v % 10;
    v = v / 10;
    if (i < 10)
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
    *sp++ = *--tp;
  *sp = 0;
  return string;
}
