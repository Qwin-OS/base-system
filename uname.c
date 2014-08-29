#include <stdio.h> 
#include "version.h"

void print_kernel_name()
{
  fprintf(stdout, "%s ",UNAME);
}

void print_node_name()
{
  fprintf(stdout, "localhost ");
}

void print_kernel_release()
{
  fprintf(stdout, "%s ",KVERSION);
}

void print_kernel_version()
{
  fprintf(stdout, "%s %s ",DATE,TIME);
}

void print_machine()
{
  fprintf(stdout, "i686 ");
}

void print_processor()
{
  fprintf(stdout, "Unknown ");
}

void print_hardware_platform()
{
  fprintf(stdout, "Unknown ");
}

void print_operating_system()
{
  fprintf(stdout, "Qwin-OS ");
}

void print_help()
{
  fprintf(stdout, "Usage: uname [OPTIONS] [--help]\n");
  fprintf(stdout, "\n");
  fprintf(stdout, "-a, --all ");
  fprintf(stdout, "print all information, except -p and -i.\n");
  fprintf(stdout, "-s, --kernel-name ");
  fprintf(stdout, "print the kernel name\n");
  fprintf(stdout, "-n, --node-name ");
  fprintf(stdout, "print the network node name\n");
  fprintf(stdout, "-r, --kernel-release ");
  fprintf(stdout, "print the kernel release\n");
  fprintf(stdout, "-v, --kernel-version ");
  fprintf(stdout, "print the kernel version\n");
  fprintf(stdout, "-m, --machine ");
  fprintf(stdout, "print the machine hardware name\n");
  fprintf(stdout, "-p, --processor ");
  fprintf(stdout, "print the processor type or \"unknown\"\n");
  fprintf(stdout, "-i, --hardware-platform ");
  fprintf(stdout, "print the hardware platform or \"unknown\"\n");
  fprintf(stdout, "-o, --operating-system ");
  fprintf(stdout, "print the operating system\n");
  fprintf(stdout, " --help ");
  fprintf(stdout, "display this help and exit\n");
  exit(0);
}

enum {
  KERNEL_NAME = 0x001,
  NODE_NAME = 0x002,
  KERNEL_RELEASE = 0x004,
  KERNEL_VERSION = 0x008,
  MACHINE = 0x010,
  PROCESSOR = 0x020,
  HARDWARE_PLATFORM = 0x040,
  OPERATING_SYSTEM = 0x080,
  HELP = 0x100,
  ALL = 0x08F,
} args;

int main(int argc, char** argv)
{
  args = KERNEL_NAME;
  int i = 1;
  for (; i<argc; ++i)
  {
    if (!strcmp("-a", argv[i]) || !strcmp("--all", argv[i]))
    {
      args |= ALL;
      continue;
    }
    if (!strcmp("-s", argv[i]) || !strcmp("--kernel-name", argv[i]))
    {
      args |= KERNEL_NAME;
      continue;
    }
    if (!strcmp("-n", argv[i]) || !strcmp("--node-name", argv[i]))
    {
      args |= NODE_NAME;
      continue;
    }
    if (!strcmp("-r", argv[i]) || !strcmp("--kernel-release", argv[i]))
    {
      args |= KERNEL_RELEASE;
      continue;
    }
    if (!strcmp("-v", argv[i]) || !strcmp("--kernel-version", argv[i]))
    {
      args |= KERNEL_VERSION;
      continue;
    }
    if (!strcmp("-m", argv[i]) || !strcmp("--machine", argv[i]))
    {
      args |= MACHINE;
      continue;
    }
    if (!strcmp("-p", argv[i]) || !strcmp("--processor", argv[i]))
    {
      args |= PROCESSOR;
      continue;
    }
    if (!strcmp("-i", argv[i]) || !strcmp("--hardware-platform", argv[i]))
    {
      args |= HARDWARE_PLATFORM;
      continue;
    }
    if (!strcmp("-o", argv[i]) || !strcmp("--operating-system", argv[i]))
    {
      args |= OPERATING_SYSTEM;
      continue;
    }
    if (!strcmp("--help", argv[i]))
    {
      args |= HELP;
      continue;
    }

    print_help();
    exit(0);
  }

  if (args & HELP)
    print_help();
  if (args & KERNEL_NAME)
    print_kernel_name();
  if (args & NODE_NAME)
    print_node_name();
  if (args & KERNEL_RELEASE)
    print_kernel_release();
  if (args & KERNEL_VERSION)
    print_kernel_version();
  if (args & MACHINE)
    print_machine();
  if (args & PROCESSOR)
    print_processor();
  if (args & HARDWARE_PLATFORM)
    print_hardware_platform();
  if (args & OPERATING_SYSTEM)
    print_operating_system();

  fprintf(stdout, "\n");

  return 0;
}


