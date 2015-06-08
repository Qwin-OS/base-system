#include <stdio.h>

char buf[512];

void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    write(1, buf, n);
  if(n < 0){
    fprintf(stdout, "cat: read error\n");
  }
}

int
main(int argc, char *argv[])
{
  int i;
  FILE* file;
  if(argc <= 1){
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((file = fopen(argv[i], "r")) < 0){
      fprintf(stdout, "cat: cannot open %s\n", argv[i]);
      exit(0);
    }
    cat(file->fd);
    fclose(file);
  }
  return 0;
}
