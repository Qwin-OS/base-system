#include <stdio.h>

int
main(int argc, char *argv[])
{
uid_t uid;
uid = atoi(argv[1]);
if(argc<2)
 setuid(0);
else
 if(uid>32)
  printf("error\n");
 else
  setuid(uid);
return uid;
}
