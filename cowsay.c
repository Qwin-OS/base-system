#include "types.h"
#include "unistd.h"

int main(int argc, char *argv[])
{
  int i;

  if (argc == 1)
    printf(1,"< qwin >\n");
  for (i = 1; i < argc; i++)
    if (i == 1)
      printf(1,"/ %s \\\n", argv[i]);
    else if (i == argc - 1)
      printf(1,"\\ %s /\n", argv[i]);
    else
      printf(1,"| %s |\n", argv[i]);
  printf(1,"  \\ ^__^\n");
  printf(1,"    (oo)\\_______\n");
  printf(1,"    (__)\\       )\\/\\\n");
  printf(1,"        ||----w |\n");
  printf(1,"        ||     ||\n");
  exit();
  return (0);
}
