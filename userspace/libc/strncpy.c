#include <types.h>

char*
strncpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}

size_t
strcspn(s1, s2)
	const char *s1;
	register const char *s2;
{
	register const char *p, *spanp;
	register char c, sc;

	for (p = s1;;) {
		c = *p++;
		spanp = s2;
		do {
			if ((sc = *spanp++) == c)
				return (p - 1 - s1);
		} while (sc != 0);
	}
}

int isdigit (int c)
{
        return((c>='0') && (c<='9'));
}

int isspace(int c)
{
        return ((c>=0x09 && c<=0x0D) || (c==0x20));
}
