#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdarg.h>

int fclose(FILE* f)
{
  close(f->fd);
  free(f->buffer);
  free(f);

  return 0;
}

FILE* fopen(const char* file, const char* mod)
{
  int fmod = 0;
  struct FILE* f = NULL;
  int fd;

  switch (*mod)
  {
    case 'r':
      fmod |= O_RDONLY;
      break;
    case 'w':
      fmod |= O_WRONLY;
      fmod |= O_CREAT;
      fmod |= O_TRUNC;
      break;
    case 'a':
      fmod |= O_WRONLY;
      fmod |= O_CREAT;
      fmod |= O_APPEND;
      break;
    default:
      goto end;
  }

  switch (*++mod)
  {
    case '+':
      fmod |= O_RDWR;
      break;
    case 0:
      break;
    default:
      goto end;
  }

  if (!(fd=open(file, fmod)))
    goto end;

  f = (struct FILE*)malloc(sizeof(struct FILE));
  memset(f, 0, sizeof(struct FILE));
  f->fd = fd;
  f->buffer = (char*)malloc(BUFSIZ);
  f->mode = fmod;
  f->flags = 0;

end:
  return f;
}

size_t fwrite(const void* ptr, size_t size, size_t nmemb, FILE* f)
{
  write(f->fd, ptr, size*nmemb);

  return nmemb;
}

size_t fread(void* ptr, size_t size, size_t nmemb, FILE* f)
{
  read(f->fd, ptr, size*nmemb);

  return nmemb;
}

int fgetc(FILE * f)
{
    unsigned char ch;

    return (fread(&ch, 1, 1, f) == 1) ? (int)ch : EOF;
}

char *fgets(char *s, int n, FILE * f)
{
    int ch;
    char *p = s;

    while (n > 1) {
	ch = fgetc(f);
	if (ch == EOF) {
	    *p = '\0';
	    return (p == s) ? NULL : s;
	}
	*p++ = ch;
	if (ch == '\n')
	    break;
	n--;
    }
    if (n)
	*p = '\0';

    return s;
}

