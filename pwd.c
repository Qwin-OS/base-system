#include "types.h"
#include "unistd.h"

#define MAX_PATH 512

int
main(int argc, char *argv[])
{
  char path[MAX_PATH];
  getcwd(path, MAX_PATH);
  printf(0, "%s\n", path);
  exit();
}
