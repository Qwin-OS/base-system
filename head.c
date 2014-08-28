#include <stdio.h>

char buf[1024];

void
head(int fd)
{
  int n, m, count;
  char *p, *q;
  
  m = 0;
  count = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      *q = '\n';
      write(1, p, q+1 - p);
      *q = 0;
      p = q+1;
      count++;
      if(count == 10)
        return;
    }
    if(p == buf)
      m = 0;
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}

int
main(int argc, char *argv[])
{
  int fd;
    
  if(argc < 2){
    printf(2, "usage: head filename ...\n");
    exit(0);
  }
  if((fd = open(argv[1], 0)) < 0){
    printf(1, "head: cannot open %s\n", argv[1]);
    exit(0);
  }
  head(fd);
  close(fd);
}
