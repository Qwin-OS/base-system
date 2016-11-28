#include <stdio.h>

int
main(int argc, char *argv[])
{
  if(argc != 3){
    fprintf(stderr, "mv: usage: mv source dest\n");
    exit(0);
  }
  if(link(argv[1], argv[2]) < 0)
    fprintf(stderr, "mv: can't move %s\n", argv[1]);
  unlink(argv[1]);
  return 0;
}
