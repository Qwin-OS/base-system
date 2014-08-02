#include "fs.h"

static struct filesystem_type procfs_type = {
  .name = "procfs",
  .flags = 0,
};

static void init(void)
{
  register_point(&procfs_type);
}
