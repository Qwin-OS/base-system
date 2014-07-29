
initcode.o:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <start>:


# exec(init, argv)
.globl start
start:
  pushl $argv
   0:	68 2c 00 00 00       	push   $0x2c
  pushl $init
   5:	68 22 00 00 00       	push   $0x22
  pushl $0  // where caller pc would be
   a:	6a 00                	push   $0x0
  movl $SYS_exec, %eax
   c:	b8 07 00 00 00       	mov    $0x7,%eax
  int $T_SYSCALL
  11:	cd 40                	int    $0x40

movw $03,%ax;
  13:	66 b8 03 00          	mov    $0x3,%ax
int $0x10
  17:	cd 10                	int    $0x10

00000019 <exit>:

# for(;;) exit();
exit:
  movl $SYS_exit, %eax
  19:	b8 02 00 00 00       	mov    $0x2,%eax
  int $T_SYSCALL
  1e:	cd 40                	int    $0x40
  jmp exit
  20:	eb f7                	jmp    19 <exit>

00000022 <init>:
  22:	2f                   	das    
  23:	69 6e 69 74 00 00 8d 	imul   $0x8d000074,0x69(%esi),%ebp
  2a:	76 00                	jbe    2c <argv>

0000002c <argv>:
  2c:	22 00                	and    (%eax),%al
  2e:	00 00                	add    %al,(%eax)
  30:	00 00                	add    %al,(%eax)
	...
