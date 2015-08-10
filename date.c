#include <stdio.h>
#include <time.h>

int
main(int argc,char *argv[])
{
   int i = 1;
   char **month;
   if (!strcmp("-u", argv[i]) || !strcmp("--unix", argv[i]))
    {
      printf("timestamp: %d\n",time());
      exit(0);
    }
   struct tm *time;
   calcDate(time);
   month = (char**)malloc(12*sizeof(char*));
   monthinit(month);

   printf("%s %d %d:%d:%d %d\n",month[time->tm_mon],time->tm_mday,time->tm_hour,time->tm_min,time->tm_sec,time->tm_year);
}
