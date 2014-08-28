#include <stdio.h>

#define MAX_PATH 512

int
main(int argc, char *argv[])
{
  char path[MAX_PATH];
  getcwd(path, MAX_PATH);
  fprintf(stderr, "%s\n", path);
  return 0;
}
