#include <stdio.h>
#include <utsname.h>
#include <version.h>
#define FLAG_SYSNAME  0x01
#define FLAG_NODENAME 0x02
#define FLAG_RELEASE  0x04
#define FLAG_VERSION  0x08
#define FLAG_MACHINE  0x10

#define FLAG_ALL (FLAG_SYSNAME|FLAG_NODENAME|FLAG_RELEASE|FLAG_VERSION|FLAG_MACHINE)


struct utsname u;

void print_help()
{
  fprintf(stderr, "Usage: uname [OPTIONS] [--help]\n");
  fprintf(stderr, "\n");
  fprintf(stderr, "-a, --all ");
  fprintf(stderr, "print all information, except -p and -i.\n");
  fprintf(stderr, "-s, --kernel-name ");
  fprintf(stderr, "print the kernel name\n");
  fprintf(stderr, "-n, --node-name ");
  fprintf(stderr, "print the network node name\n");
  fprintf(stderr, "-r, --kernel-release ");
  fprintf(stderr, "print the kernel release\n");
  fprintf(stderr, "-v, --kernel-version ");
  fprintf(stderr, "print the kernel version\n");
  fprintf(stderr, "-m, --machine ");
  fprintf(stderr, "print the machine hardware name\n");
  fprintf(stderr, " --help ");
  fprintf(stderr, "display this help and exit\n");
  exit(1);
}

int main(int argc, char** argv)
{
  uname(&u);
  int i = 1;
  int args;
  for (; i<argc; ++i)
  {
    if (!strcmp("-a", argv[i]) || !strcmp("--all", argv[i]))
    {
      args |= FLAG_ALL;
      break;
    }
    if (!strcmp("-s", argv[i]) || !strcmp("--kernel-name", argv[i]))
    {
      args |= FLAG_SYSNAME;
      break;
    }
    if (!strcmp("-n", argv[i]) || !strcmp("--node-name", argv[i]))
    {
      args |= FLAG_NODENAME;
      break;
    }
    if (!strcmp("-r", argv[i]) || !strcmp("--kernel-release", argv[i]))
    {
      args |= FLAG_RELEASE;
      break;
    }
    if (!strcmp("-v", argv[i]) || !strcmp("--kernel-version", argv[i]))
    {
      args |= FLAG_VERSION;
      break;
    }
    if (!strcmp("-m", argv[i]) || !strcmp("--machine", argv[i]))
    {
      args |= FLAG_MACHINE;
      break;
    }
    if (!strcmp("--help", argv[i]))
    {
      print_help();
      break;
    }

    exit(0);
  }

  if (!args)
   args = FLAG_SYSNAME;
  if (args & FLAG_SYSNAME)
    printf("%s ", u.sysname);
  if (args & FLAG_NODENAME)
    printf("%s ", u.nodename);
  if (args & FLAG_RELEASE)
    printf("%s ", u.release);
  if (args & FLAG_VERSION)
    printf("%s ", u.version);

  if (args & FLAG_MACHINE)
    printf("%s ", u.machine);

  fprintf(stdout, "\n");

  return 0;
}
