#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "version.h"
#include "stddef.h"

static char   hostname[256];
static size_t hostname_len = 0;

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  int status;
  exit(status);
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  if(argint(0, &n) < 0)
    return -1;
    n = n * 100;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_shutdown(void)
{
outw( 0xB004, 0x0 | 0x2000 );
return 0;
}

int
sys_reboot(void)
{
lidt(0,0);
return 0;
}

time_t
sys_time(void)
{
uint time = get_date_time();
return time;
}

int
sys_sethostname(void)
{
		char *new_hostname;
		argstr(0, &new_hostname);
                if(proc->uid != 0) {
			return 2;
                }
		size_t len = strlen(new_hostname) + 1;
		if (len > 256) {
			return 1;
                }
		hostname_len = len;
		memcpy(hostname, new_hostname, hostname_len);
		return 0;
}

int
sys_gethostname(void)
{
	char *buf;
	argstr(0, &buf);
	memcpy(buf, hostname, hostname_len);
	return hostname_len;
}
