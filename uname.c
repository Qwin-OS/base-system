#include "types.h"
#include "stat.h"
#include "unistd.h"
#include "version.h"

void print_kernel_name()
{
  printf(1, UNAME" ");
}

void print_node_name()
{
  printf(1, "localhost ");
}

void print_kernel_release()
{
  printf(1, KVERSION" ");
}

void print_kernel_version()
{
  printf(1, DATE" "TIME" ");
}

void print_machine()
{
  printf(1, "i686 ");
}

void print_processor()
{
  printf(1, "Unknown ");
}

void print_hardware_platform()
{
  printf(1, "Unknown ");
}

void print_operating_system()
{
  printf(1, "Qwin-OS ");
}

void print_help()
{
  printf(1, "Usage: uname [OPTIONS] [--help]\n");
  printf(1, "\n");
  printf(1, "-a, --all ");
  printf(1, "print all information, except -p and -i.\n");
  printf(1, "-s, --kernel-name ");
  printf(1, "print the kernel name\n");
  printf(1, "-n, --node-name ");
  printf(1, "print the network node name\n");
  printf(1, "-r, --kernel-release ");
  printf(1, "print the kernel release\n");
  printf(1, "-v, --kernel-version ");
  printf(1, "print the kernel version\n");
  printf(1, "-m, --machine ");
  printf(1, "print the machine hardware name\n");
  printf(1, "-p, --processor ");
  printf(1, "print the processor type or \"unknown\"\n");
  printf(1, "-i, --hardware-platform ");
  printf(1, "print the hardware platform or \"unknown\"\n");
  printf(1, "-o, --operating-system ");
  printf(1, "print the operating system\n");
  printf(1, " --help ");
  printf(1, "display this help and exit\n");
  exit();
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
    exit();
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

  printf(1, "\n");

  exit();
  return 0;
}


