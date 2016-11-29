// init: The initial user-level program

#include <stdio.h>
#include <fcntl.h>
#include <fs.h>
#include <file.h>
#include <device.h>

char *argv[] = { "/bin/sh", 0 };

void hostnamed(char *hostname)
{
sethostname(hostname);
FILE* file = fopen("/etc/hostname", "w");
fprintf(file, "%s\n", hostname);
}

void setup_devices(void)
{
  if(open("/dev/tty", O_RDWR) < 0)
  {
    mknod("/dev/tty", DEV_TTY, 1);
    link("/dev/tty", "/dev/tty0");
    mknod("/dev/null", DEV_NULL, 1);
    mknod("/dev/zero", DEV_ZERO, 1);
    open("/dev/tty0", O_RDWR);
  }
}

int
main(void)
{
  int pid, wpid;
  char x;
if (getpid() != 1)
	return 1;
  chdir("/");
  setup_devices();
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    pid = fork();
    if(gethostname(x)<1)
    hostnamed("localhost");
    if(pid < 0){
      fprintf(stdout, "init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
      execv("/bin/sh", argv);
      fprintf(stdout, "init: exec sh failed\n");
      exit(1);
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      fprintf(stdout, "zombie!\n");
  }
}
