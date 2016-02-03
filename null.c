#include <types.h>
#include <fs.h>
#include <file.h>
#include <device.h>

int dev_null_read(struct inode *ip, char *dst, int n)
{
  // make /dev/null returned zero
  return 0;
}

int dev_null_write(struct inode *ip, char *buf, int n)
{
  return n;
}

void dev_null_init(void)
{
  device_t[DEV_NULL].write = dev_null_write;
  device_t[DEV_NULL].read = dev_null_read;
}
