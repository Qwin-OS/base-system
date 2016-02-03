#include <types.h>
#include <defs.h>
#include <x86.h>
#include <traps.h>
#include <module.h>
#include <device.h>

MODULE("DEV");

struct device_t *device = 0;

