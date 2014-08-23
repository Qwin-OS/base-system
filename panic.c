#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "panic.h"

panicked = 0;

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cprintf("Kernel panic - ", cpu->id);
  cprintf(s);
  cprintf("\nCaller:\n");
  getcallerpcs(&s, pcs);
  if (proc && proc->tf) {
  cprintf("eax: 0x%x\n", proc->tf->eax);
  cprintf("esp: 0x%x\n", proc->tf->esp);
  cprintf("eip: 0x%x\n", proc->tf->eip);
  }
  for(i=0; i<10; i++)
    cprintf("%p ", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

