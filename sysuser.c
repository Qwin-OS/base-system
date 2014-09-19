/* User/UID syscalls */

#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "version.h"
#include "stddef.h"


int
sys_getuid(void)
{
return proc->uid;
}

int
sys_setuid(void)
{
int n;
argint(0,&n);
proc->uid = n;
return 0;
}
