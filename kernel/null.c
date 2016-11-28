#include <types.h>
#include <fs.h>
#include <file.h>
#include <device.h>

int nullread(struct inode *ip, char *dst, int n)
{
  // make /dev/null returned zero
  return 0;
}

int nullwrite(struct inode *ip, char *buf, int n)
{
  return n;
}

void dev_null_init(void)
{
    device_init(DEV_NULL, nullread, nullwrite);
}
