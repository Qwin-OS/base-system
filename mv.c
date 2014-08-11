#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  if(argc != 3){
    printf(2, "mv: usage: mv source dest\n");
    exit();
  }
  if(link(argv[1], argv[2]) < 0)
    printf(2, "mv: can't move %s\n", argv[1]);
  unlink(argv[1]);
  exit();
}
