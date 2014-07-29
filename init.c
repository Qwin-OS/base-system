// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"
#include "file.h"

char *argv[] = { "sh", 0 };

// FUCKING DEVICES
void setup_devices(void)
{
  if(open("/dev/console", O_RDWR) < 0)
  {
    mknod("/dev/console", DEV_CONSOLE, 1);
    mknod("/dev/null", DEV_NULL, 1);
    mknod("/dev/zero", DEV_ZERO, 1);
    open("/dev/console", O_RDWR);
  }

  //if(open("/dev/null", O_RDWR) < 0)
  //{
    //mknod("/dev/null", DEV_NULL, 1);
  //}
  //if(open("/dev/zero", O_RDWR) < 0) 
  //{
   // mknod("/dev/zero", DEV_ZERO, 1);
  //}
}

int
main(void)
{
  int pid, wpid;

  setup_devices();
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    //printf(1,  "Qwin\n);
    printf(1, "init: starting sh\n\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
