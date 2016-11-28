#include <stdio.h>

int main(int argc, char *argv[])
{
  int i;

  if (argc == 1)
    fprintf(stdout,"< qwin >\n");
  for (i = 1; i < argc; i++)
    if (i == 1)
      fprintf(stdout,"/ %s \\\n", argv[i]);
    else if (i == argc - 1)
      fprintf(stdout,"\\ %s /\n", argv[i]);
    else
      fprintf(stdout,"| %s |\n", argv[i]);
  fprintf(stdout,"  \\ ^__^\n");
  fprintf(stdout,"    (oo)\\_______\n");
  fprintf(stdout,"    (__)\\       )\\/\\\n");
  fprintf(stdout,"        ||----w |\n");
  fprintf(stdout,"        ||     ||\n");
  return (0);
}
