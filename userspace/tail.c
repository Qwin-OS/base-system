// Simple grep.  Only supports ^ . * $ operators.

#include <stdio.h>

char buf[1024];

void
tail(char* filepath)
{
  int fd, n, m, count;
  char *p, *q;
  memset(buf, 0, sizeof(char)*1024);
  if((fd = open(filepath, 0)) < 0){
    fprintf(stdout, "tail: cannot open %s\n", filepath);
    exit(0);
  }
  m = 0;
  count = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      *q = 0;
      p = q+1;
      count++;
    }
    if(p == buf)
      m = 0;
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
  close(fd);

  if((fd = open(filepath, 0)) < 0){
    fprintf(stdout, "tail: cannot open %s\n", filepath);
    exit(0);
  }
  if(count <= 10)
  {
    while((n = read(fd, buf, sizeof(buf))) > 0)
      write(1, buf, n);
    if(n < 0){
      fprintf(stdout, "tail: read error\n");
    }
    return;
  }
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){     
      count--;
      if(count < 10)
      {
        *q = '\n';
        write(1, p, q+1 - p);
      }
      *q = 0; 
      p = q+1;
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
  if(argc < 2){
    fprintf(stderr, "usage: tail filename ...\n");
    exit(0);
  }
  
  tail(argv[1]);
}

