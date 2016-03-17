#include <types.h>
#include <fs.h>
#include <file.h>
#include <device.h>

int zeroread(struct inode *ip, char *dst, int n)
{
  int i = 0;
  for (; i<n; ++i)
    dst[i] = 0;
  return n;
}

int zerowrite(struct inode *ip, char *buf, int n)
{
  // ro
  return n;
}

void dev_zero_init(void)
{
  device_init(DEV_ZERO, zeroread, zerowrite);
}
