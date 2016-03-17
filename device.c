#include <types.h>
#include <defs.h>
#include <x86.h>
#include <traps.h>
#include <module.h>
#include <device.h>

MODULE("DEV");

struct device_t *device = 0;

int device_init(int id, int (*read)(struct inode*, char*, int), int (*write)(struct inode*, char*, int))
{
device_t[id].write = write;
device_t[id].read = read;
device_t[id].enabled = 1;
return 0;
}

struct device_t device_get(int id)
{
if(!device_t[id].enabled)
exit(0);

return device_t[id];
}
