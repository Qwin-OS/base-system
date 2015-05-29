#include <types.h>
#include <fs.h>
#include <file.h>

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
  devsw[DEV_NULL].write = dev_null_write;
  devsw[DEV_NULL].read = dev_null_read;
}
