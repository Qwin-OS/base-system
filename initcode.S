# Initial process execs /init.

#include "syscall.h"
#include "traps.h"


# exec(init, argv)
.globl start
start:
  pushl $argv
  pushl $init
  pushl $0  // where caller pc would be
  movl $SYS_execv, %eax
  int $T_SYSCALL

movw $03,%ax;
int $0x10

# for(;;) exit();
exit:
  movl $SYS_exit, %eax
  int $T_SYSCALL
  jmp exit

# char init[] = "/sbin/init\0";
init:
  .string "/sbin/init\0"

# char *argv[] = { init, 0 };
.p2align 2
argv:
  .long init
  .long 0

