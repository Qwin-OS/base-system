// Fake IDE disk; stores blocks in memory.
// Useful for running kernel without scratch disk.

#include <types.h>
#include <defs.h>
#include <param.h>
#include <mmu.h>
#include <proc.h>
#include <x86.h>
#include <traps.h>
#include <spinlock.h>
#include <buf.h>
#include <module.h>

MODULE("MEMDISK");

extern uchar _binary_system_img_start[], _binary_system_img_size[];

static int disksize;
static uchar *memdisk;

void
memideinit(void)
{
  memdisk = _binary_system_img_start;
  disksize = (uint)_binary_system_img_size/512;
}

// Interrupt handler.
void
memideintr(void)
{
  // no-op
}

// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
memiderw(struct buf *b)
{
  uchar *p;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 1)
    panic("iderw: request not for disk 1");
  if(b->sector >= disksize)
    panic("iderw: sector out of range");

  p = memdisk + b->sector*512;

  if(b->flags & B_DIRTY){
    b->flags &= ~B_DIRTY;
    memmove(p, b->data, 512);
  } else
    memmove(b->data, p, 512);
  b->flags |= B_VALID;
}
