#include "fs.h"

static struct filesystem_type __qwin_points[MAX_FS];
static unsigned int __qwin_points_count = 0;

void register_point(struct filesystem_type* fst)
{
  if (__qwin_points_count > MAX_FS)
    return;
  __qwin_points[__qwin_points_count++];
}
