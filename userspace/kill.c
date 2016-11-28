#include <stdio.h>

int
main(int argc, char **argv)
{
  int i;

  if(argc < 1){
    fprintf(stderr, "usage: kill pid...\n");
    exit(0);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  return 0;
}
