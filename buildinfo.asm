
_buildinfo:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    buildinfo();
  11:	e8 0a 03 00 00       	call   320 <buildinfo>
  exit();
  16:	e8 55 02 00 00       	call   270 <exit>

0000001b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  1b:	55                   	push   %ebp
  1c:	89 e5                	mov    %esp,%ebp
  1e:	57                   	push   %edi
  1f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  23:	8b 55 10             	mov    0x10(%ebp),%edx
  26:	8b 45 0c             	mov    0xc(%ebp),%eax
  29:	89 cb                	mov    %ecx,%ebx
  2b:	89 df                	mov    %ebx,%edi
  2d:	89 d1                	mov    %edx,%ecx
  2f:	fc                   	cld    
  30:	f3 aa                	rep stos %al,%es:(%edi)
  32:	89 ca                	mov    %ecx,%edx
  34:	89 fb                	mov    %edi,%ebx
  36:	89 5d 08             	mov    %ebx,0x8(%ebp)
  39:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  3c:	5b                   	pop    %ebx
  3d:	5f                   	pop    %edi
  3e:	5d                   	pop    %ebp
  3f:	c3                   	ret    

00000040 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  46:	8b 45 08             	mov    0x8(%ebp),%eax
  49:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  4c:	90                   	nop
  4d:	8b 45 08             	mov    0x8(%ebp),%eax
  50:	8d 50 01             	lea    0x1(%eax),%edx
  53:	89 55 08             	mov    %edx,0x8(%ebp)
  56:	8b 55 0c             	mov    0xc(%ebp),%edx
  59:	8d 4a 01             	lea    0x1(%edx),%ecx
  5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  5f:	0f b6 12             	movzbl (%edx),%edx
  62:	88 10                	mov    %dl,(%eax)
  64:	0f b6 00             	movzbl (%eax),%eax
  67:	84 c0                	test   %al,%al
  69:	75 e2                	jne    4d <strcpy+0xd>
    ;
  return os;
  6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  6e:	c9                   	leave  
  6f:	c3                   	ret    

00000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  73:	eb 08                	jmp    7d <strcmp+0xd>
    p++, q++;
  75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  79:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  7d:	8b 45 08             	mov    0x8(%ebp),%eax
  80:	0f b6 00             	movzbl (%eax),%eax
  83:	84 c0                	test   %al,%al
  85:	74 10                	je     97 <strcmp+0x27>
  87:	8b 45 08             	mov    0x8(%ebp),%eax
  8a:	0f b6 10             	movzbl (%eax),%edx
  8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  90:	0f b6 00             	movzbl (%eax),%eax
  93:	38 c2                	cmp    %al,%dl
  95:	74 de                	je     75 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	0f b6 00             	movzbl (%eax),%eax
  9d:	0f b6 d0             	movzbl %al,%edx
  a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  a3:	0f b6 00             	movzbl (%eax),%eax
  a6:	0f b6 c0             	movzbl %al,%eax
  a9:	29 c2                	sub    %eax,%edx
  ab:	89 d0                	mov    %edx,%eax
}
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    

000000af <strlen>:

uint
strlen(char *s)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  bc:	eb 04                	jmp    c2 <strlen+0x13>
  be:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c5:	8b 45 08             	mov    0x8(%ebp),%eax
  c8:	01 d0                	add    %edx,%eax
  ca:	0f b6 00             	movzbl (%eax),%eax
  cd:	84 c0                	test   %al,%al
  cf:	75 ed                	jne    be <strlen+0xf>
    ;
  return n;
  d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d4:	c9                   	leave  
  d5:	c3                   	ret    

000000d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  d9:	8b 45 10             	mov    0x10(%ebp),%eax
  dc:	50                   	push   %eax
  dd:	ff 75 0c             	pushl  0xc(%ebp)
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	e8 33 ff ff ff       	call   1b <stosb>
  e8:	83 c4 0c             	add    $0xc,%esp
  return dst;
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ee:	c9                   	leave  
  ef:	c3                   	ret    

000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	83 ec 04             	sub    $0x4,%esp
  f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  f9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  fc:	eb 14                	jmp    112 <strchr+0x22>
    if(*s == c)
  fe:	8b 45 08             	mov    0x8(%ebp),%eax
 101:	0f b6 00             	movzbl (%eax),%eax
 104:	3a 45 fc             	cmp    -0x4(%ebp),%al
 107:	75 05                	jne    10e <strchr+0x1e>
      return (char*)s;
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	eb 13                	jmp    121 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 10e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 e2                	jne    fe <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 11c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 121:	c9                   	leave  
 122:	c3                   	ret    

00000123 <gets>:

char*
gets(char *buf, int max)
{
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 129:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 130:	eb 44                	jmp    176 <gets+0x53>
    cc = read(0, &c, 1);
 132:	83 ec 04             	sub    $0x4,%esp
 135:	6a 01                	push   $0x1
 137:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13a:	50                   	push   %eax
 13b:	6a 00                	push   $0x0
 13d:	e8 46 01 00 00       	call   288 <read>
 142:	83 c4 10             	add    $0x10,%esp
 145:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 148:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 14c:	7f 02                	jg     150 <gets+0x2d>
      break;
 14e:	eb 31                	jmp    181 <gets+0x5e>
    buf[i++] = c;
 150:	8b 45 f4             	mov    -0xc(%ebp),%eax
 153:	8d 50 01             	lea    0x1(%eax),%edx
 156:	89 55 f4             	mov    %edx,-0xc(%ebp)
 159:	89 c2                	mov    %eax,%edx
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	01 c2                	add    %eax,%edx
 160:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 164:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 166:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16a:	3c 0a                	cmp    $0xa,%al
 16c:	74 13                	je     181 <gets+0x5e>
 16e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 172:	3c 0d                	cmp    $0xd,%al
 174:	74 0b                	je     181 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	8b 45 f4             	mov    -0xc(%ebp),%eax
 179:	83 c0 01             	add    $0x1,%eax
 17c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 17f:	7c b1                	jl     132 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 181:	8b 55 f4             	mov    -0xc(%ebp),%edx
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	01 d0                	add    %edx,%eax
 189:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <stat>:

int
stat(char *n, struct stat *st)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 197:	83 ec 08             	sub    $0x8,%esp
 19a:	6a 00                	push   $0x0
 19c:	ff 75 08             	pushl  0x8(%ebp)
 19f:	e8 0c 01 00 00       	call   2b0 <open>
 1a4:	83 c4 10             	add    $0x10,%esp
 1a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ae:	79 07                	jns    1b7 <stat+0x26>
    return -1;
 1b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1b5:	eb 25                	jmp    1dc <stat+0x4b>
  r = fstat(fd, st);
 1b7:	83 ec 08             	sub    $0x8,%esp
 1ba:	ff 75 0c             	pushl  0xc(%ebp)
 1bd:	ff 75 f4             	pushl  -0xc(%ebp)
 1c0:	e8 03 01 00 00       	call   2c8 <fstat>
 1c5:	83 c4 10             	add    $0x10,%esp
 1c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1cb:	83 ec 0c             	sub    $0xc,%esp
 1ce:	ff 75 f4             	pushl  -0xc(%ebp)
 1d1:	e8 c2 00 00 00       	call   298 <close>
 1d6:	83 c4 10             	add    $0x10,%esp
  return r;
 1d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1dc:	c9                   	leave  
 1dd:	c3                   	ret    

000001de <atoi>:

int
atoi(const char *s)
{
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1eb:	eb 25                	jmp    212 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f0:	89 d0                	mov    %edx,%eax
 1f2:	c1 e0 02             	shl    $0x2,%eax
 1f5:	01 d0                	add    %edx,%eax
 1f7:	01 c0                	add    %eax,%eax
 1f9:	89 c1                	mov    %eax,%ecx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	8d 50 01             	lea    0x1(%eax),%edx
 201:	89 55 08             	mov    %edx,0x8(%ebp)
 204:	0f b6 00             	movzbl (%eax),%eax
 207:	0f be c0             	movsbl %al,%eax
 20a:	01 c8                	add    %ecx,%eax
 20c:	83 e8 30             	sub    $0x30,%eax
 20f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	0f b6 00             	movzbl (%eax),%eax
 218:	3c 2f                	cmp    $0x2f,%al
 21a:	7e 0a                	jle    226 <atoi+0x48>
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	3c 39                	cmp    $0x39,%al
 224:	7e c7                	jle    1ed <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 226:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 229:	c9                   	leave  
 22a:	c3                   	ret    

0000022b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 237:	8b 45 0c             	mov    0xc(%ebp),%eax
 23a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 23d:	eb 17                	jmp    256 <memmove+0x2b>
    *dst++ = *src++;
 23f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 242:	8d 50 01             	lea    0x1(%eax),%edx
 245:	89 55 fc             	mov    %edx,-0x4(%ebp)
 248:	8b 55 f8             	mov    -0x8(%ebp),%edx
 24b:	8d 4a 01             	lea    0x1(%edx),%ecx
 24e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 251:	0f b6 12             	movzbl (%edx),%edx
 254:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 256:	8b 45 10             	mov    0x10(%ebp),%eax
 259:	8d 50 ff             	lea    -0x1(%eax),%edx
 25c:	89 55 10             	mov    %edx,0x10(%ebp)
 25f:	85 c0                	test   %eax,%eax
 261:	7f dc                	jg     23f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 263:	8b 45 08             	mov    0x8(%ebp),%eax
}
 266:	c9                   	leave  
 267:	c3                   	ret    

00000268 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 268:	b8 01 00 00 00       	mov    $0x1,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <exit>:
SYSCALL(exit)
 270:	b8 02 00 00 00       	mov    $0x2,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <wait>:
SYSCALL(wait)
 278:	b8 03 00 00 00       	mov    $0x3,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <pipe>:
SYSCALL(pipe)
 280:	b8 04 00 00 00       	mov    $0x4,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <read>:
SYSCALL(read)
 288:	b8 05 00 00 00       	mov    $0x5,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <write>:
SYSCALL(write)
 290:	b8 10 00 00 00       	mov    $0x10,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <close>:
SYSCALL(close)
 298:	b8 15 00 00 00       	mov    $0x15,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <kill>:
SYSCALL(kill)
 2a0:	b8 06 00 00 00       	mov    $0x6,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <exec>:
SYSCALL(exec)
 2a8:	b8 07 00 00 00       	mov    $0x7,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <open>:
SYSCALL(open)
 2b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <mknod>:
SYSCALL(mknod)
 2b8:	b8 11 00 00 00       	mov    $0x11,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <unlink>:
SYSCALL(unlink)
 2c0:	b8 12 00 00 00       	mov    $0x12,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <fstat>:
SYSCALL(fstat)
 2c8:	b8 08 00 00 00       	mov    $0x8,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <link>:
SYSCALL(link)
 2d0:	b8 13 00 00 00       	mov    $0x13,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <mkdir>:
SYSCALL(mkdir)
 2d8:	b8 14 00 00 00       	mov    $0x14,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <chdir>:
SYSCALL(chdir)
 2e0:	b8 09 00 00 00       	mov    $0x9,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <dup>:
SYSCALL(dup)
 2e8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <getpid>:
SYSCALL(getpid)
 2f0:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <sbrk>:
SYSCALL(sbrk)
 2f8:	b8 0c 00 00 00       	mov    $0xc,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <sleep>:
SYSCALL(sleep)
 300:	b8 0d 00 00 00       	mov    $0xd,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <uptime>:
SYSCALL(uptime)
 308:	b8 0e 00 00 00       	mov    $0xe,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <getcwd>:
SYSCALL(getcwd)
 310:	b8 16 00 00 00       	mov    $0x16,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <shutdown>:
SYSCALL(shutdown)
 318:	b8 17 00 00 00       	mov    $0x17,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <buildinfo>:
SYSCALL(buildinfo)
 320:	b8 18 00 00 00       	mov    $0x18,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <lseek>:
SYSCALL(lseek)
 328:	b8 19 00 00 00       	mov    $0x19,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	83 ec 18             	sub    $0x18,%esp
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 33c:	83 ec 04             	sub    $0x4,%esp
 33f:	6a 01                	push   $0x1
 341:	8d 45 f4             	lea    -0xc(%ebp),%eax
 344:	50                   	push   %eax
 345:	ff 75 08             	pushl  0x8(%ebp)
 348:	e8 43 ff ff ff       	call   290 <write>
 34d:	83 c4 10             	add    $0x10,%esp
}
 350:	c9                   	leave  
 351:	c3                   	ret    

00000352 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	53                   	push   %ebx
 356:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 359:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 360:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 364:	74 17                	je     37d <printint+0x2b>
 366:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 36a:	79 11                	jns    37d <printint+0x2b>
    neg = 1;
 36c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 373:	8b 45 0c             	mov    0xc(%ebp),%eax
 376:	f7 d8                	neg    %eax
 378:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37b:	eb 06                	jmp    383 <printint+0x31>
  } else {
    x = xx;
 37d:	8b 45 0c             	mov    0xc(%ebp),%eax
 380:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 38a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 38d:	8d 41 01             	lea    0x1(%ecx),%eax
 390:	89 45 f4             	mov    %eax,-0xc(%ebp)
 393:	8b 5d 10             	mov    0x10(%ebp),%ebx
 396:	8b 45 ec             	mov    -0x14(%ebp),%eax
 399:	ba 00 00 00 00       	mov    $0x0,%edx
 39e:	f7 f3                	div    %ebx
 3a0:	89 d0                	mov    %edx,%eax
 3a2:	0f b6 80 34 13 00 00 	movzbl 0x1334(%eax),%eax
 3a9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b3:	ba 00 00 00 00       	mov    $0x0,%edx
 3b8:	f7 f3                	div    %ebx
 3ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c1:	75 c7                	jne    38a <printint+0x38>
  if(neg)
 3c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3c7:	74 0e                	je     3d7 <printint+0x85>
    buf[i++] = '-';
 3c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cc:	8d 50 01             	lea    0x1(%eax),%edx
 3cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3d2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3d7:	eb 1d                	jmp    3f6 <printint+0xa4>
    putc(fd, buf[i]);
 3d9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3df:	01 d0                	add    %edx,%eax
 3e1:	0f b6 00             	movzbl (%eax),%eax
 3e4:	0f be c0             	movsbl %al,%eax
 3e7:	83 ec 08             	sub    $0x8,%esp
 3ea:	50                   	push   %eax
 3eb:	ff 75 08             	pushl  0x8(%ebp)
 3ee:	e8 3d ff ff ff       	call   330 <putc>
 3f3:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3f6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3fe:	79 d9                	jns    3d9 <printint+0x87>
    putc(fd, buf[i]);
}
 400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 403:	c9                   	leave  
 404:	c3                   	ret    

00000405 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 40b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 412:	8d 45 0c             	lea    0xc(%ebp),%eax
 415:	83 c0 04             	add    $0x4,%eax
 418:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 41b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 422:	e9 59 01 00 00       	jmp    580 <printf+0x17b>
    c = fmt[i] & 0xff;
 427:	8b 55 0c             	mov    0xc(%ebp),%edx
 42a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 42d:	01 d0                	add    %edx,%eax
 42f:	0f b6 00             	movzbl (%eax),%eax
 432:	0f be c0             	movsbl %al,%eax
 435:	25 ff 00 00 00       	and    $0xff,%eax
 43a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 43d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 441:	75 2c                	jne    46f <printf+0x6a>
      if(c == '%'){
 443:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 447:	75 0c                	jne    455 <printf+0x50>
        state = '%';
 449:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 450:	e9 27 01 00 00       	jmp    57c <printf+0x177>
      } else {
        putc(fd, c);
 455:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 458:	0f be c0             	movsbl %al,%eax
 45b:	83 ec 08             	sub    $0x8,%esp
 45e:	50                   	push   %eax
 45f:	ff 75 08             	pushl  0x8(%ebp)
 462:	e8 c9 fe ff ff       	call   330 <putc>
 467:	83 c4 10             	add    $0x10,%esp
 46a:	e9 0d 01 00 00       	jmp    57c <printf+0x177>
      }
    } else if(state == '%'){
 46f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 473:	0f 85 03 01 00 00    	jne    57c <printf+0x177>
      if(c == 'd'){
 479:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 47d:	75 1e                	jne    49d <printf+0x98>
        printint(fd, *ap, 10, 1);
 47f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 482:	8b 00                	mov    (%eax),%eax
 484:	6a 01                	push   $0x1
 486:	6a 0a                	push   $0xa
 488:	50                   	push   %eax
 489:	ff 75 08             	pushl  0x8(%ebp)
 48c:	e8 c1 fe ff ff       	call   352 <printint>
 491:	83 c4 10             	add    $0x10,%esp
        ap++;
 494:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 498:	e9 d8 00 00 00       	jmp    575 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 49d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4a1:	74 06                	je     4a9 <printf+0xa4>
 4a3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4a7:	75 1e                	jne    4c7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ac:	8b 00                	mov    (%eax),%eax
 4ae:	6a 00                	push   $0x0
 4b0:	6a 10                	push   $0x10
 4b2:	50                   	push   %eax
 4b3:	ff 75 08             	pushl  0x8(%ebp)
 4b6:	e8 97 fe ff ff       	call   352 <printint>
 4bb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c2:	e9 ae 00 00 00       	jmp    575 <printf+0x170>
      } else if(c == 's'){
 4c7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4cb:	75 43                	jne    510 <printf+0x10b>
        s = (char*)*ap;
 4cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d0:	8b 00                	mov    (%eax),%eax
 4d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4dd:	75 07                	jne    4e6 <printf+0xe1>
          s = "(null)";
 4df:	c7 45 f4 25 0f 00 00 	movl   $0xf25,-0xc(%ebp)
        while(*s != 0){
 4e6:	eb 1c                	jmp    504 <printf+0xff>
          putc(fd, *s);
 4e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4eb:	0f b6 00             	movzbl (%eax),%eax
 4ee:	0f be c0             	movsbl %al,%eax
 4f1:	83 ec 08             	sub    $0x8,%esp
 4f4:	50                   	push   %eax
 4f5:	ff 75 08             	pushl  0x8(%ebp)
 4f8:	e8 33 fe ff ff       	call   330 <putc>
 4fd:	83 c4 10             	add    $0x10,%esp
          s++;
 500:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 504:	8b 45 f4             	mov    -0xc(%ebp),%eax
 507:	0f b6 00             	movzbl (%eax),%eax
 50a:	84 c0                	test   %al,%al
 50c:	75 da                	jne    4e8 <printf+0xe3>
 50e:	eb 65                	jmp    575 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 510:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 514:	75 1d                	jne    533 <printf+0x12e>
        putc(fd, *ap);
 516:	8b 45 e8             	mov    -0x18(%ebp),%eax
 519:	8b 00                	mov    (%eax),%eax
 51b:	0f be c0             	movsbl %al,%eax
 51e:	83 ec 08             	sub    $0x8,%esp
 521:	50                   	push   %eax
 522:	ff 75 08             	pushl  0x8(%ebp)
 525:	e8 06 fe ff ff       	call   330 <putc>
 52a:	83 c4 10             	add    $0x10,%esp
        ap++;
 52d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 531:	eb 42                	jmp    575 <printf+0x170>
      } else if(c == '%'){
 533:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 537:	75 17                	jne    550 <printf+0x14b>
        putc(fd, c);
 539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	83 ec 08             	sub    $0x8,%esp
 542:	50                   	push   %eax
 543:	ff 75 08             	pushl  0x8(%ebp)
 546:	e8 e5 fd ff ff       	call   330 <putc>
 54b:	83 c4 10             	add    $0x10,%esp
 54e:	eb 25                	jmp    575 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 550:	83 ec 08             	sub    $0x8,%esp
 553:	6a 25                	push   $0x25
 555:	ff 75 08             	pushl  0x8(%ebp)
 558:	e8 d3 fd ff ff       	call   330 <putc>
 55d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 563:	0f be c0             	movsbl %al,%eax
 566:	83 ec 08             	sub    $0x8,%esp
 569:	50                   	push   %eax
 56a:	ff 75 08             	pushl  0x8(%ebp)
 56d:	e8 be fd ff ff       	call   330 <putc>
 572:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 575:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 57c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 580:	8b 55 0c             	mov    0xc(%ebp),%edx
 583:	8b 45 f0             	mov    -0x10(%ebp),%eax
 586:	01 d0                	add    %edx,%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	84 c0                	test   %al,%al
 58d:	0f 85 94 fe ff ff    	jne    427 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 593:	c9                   	leave  
 594:	c3                   	ret    

00000595 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	83 e8 08             	sub    $0x8,%eax
 5a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a4:	a1 50 13 00 00       	mov    0x1350,%eax
 5a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ac:	eb 24                	jmp    5d2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b1:	8b 00                	mov    (%eax),%eax
 5b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5b6:	77 12                	ja     5ca <free+0x35>
 5b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5be:	77 24                	ja     5e4 <free+0x4f>
 5c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5c8:	77 1a                	ja     5e4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5cd:	8b 00                	mov    (%eax),%eax
 5cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d8:	76 d4                	jbe    5ae <free+0x19>
 5da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5dd:	8b 00                	mov    (%eax),%eax
 5df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e2:	76 ca                	jbe    5ae <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e7:	8b 40 04             	mov    0x4(%eax),%eax
 5ea:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f4:	01 c2                	add    %eax,%edx
 5f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	39 c2                	cmp    %eax,%edx
 5fd:	75 24                	jne    623 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 5ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 602:	8b 50 04             	mov    0x4(%eax),%edx
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	8b 40 04             	mov    0x4(%eax),%eax
 60d:	01 c2                	add    %eax,%edx
 60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 612:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	8b 10                	mov    (%eax),%edx
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	89 10                	mov    %edx,(%eax)
 621:	eb 0a                	jmp    62d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 10                	mov    (%eax),%edx
 628:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 40 04             	mov    0x4(%eax),%eax
 633:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	01 d0                	add    %edx,%eax
 63f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 642:	75 20                	jne    664 <free+0xcf>
    p->s.size += bp->s.size;
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 50 04             	mov    0x4(%eax),%edx
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	8b 40 04             	mov    0x4(%eax),%eax
 650:	01 c2                	add    %eax,%edx
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 658:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65b:	8b 10                	mov    (%eax),%edx
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	89 10                	mov    %edx,(%eax)
 662:	eb 08                	jmp    66c <free+0xd7>
  } else
    p->s.ptr = bp;
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 55 f8             	mov    -0x8(%ebp),%edx
 66a:	89 10                	mov    %edx,(%eax)
  freep = p;
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	a3 50 13 00 00       	mov    %eax,0x1350
}
 674:	c9                   	leave  
 675:	c3                   	ret    

00000676 <morecore>:

static Header*
morecore(uint nu)
{
 676:	55                   	push   %ebp
 677:	89 e5                	mov    %esp,%ebp
 679:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 67c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 683:	77 07                	ja     68c <morecore+0x16>
    nu = 4096;
 685:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 68c:	8b 45 08             	mov    0x8(%ebp),%eax
 68f:	c1 e0 03             	shl    $0x3,%eax
 692:	83 ec 0c             	sub    $0xc,%esp
 695:	50                   	push   %eax
 696:	e8 5d fc ff ff       	call   2f8 <sbrk>
 69b:	83 c4 10             	add    $0x10,%esp
 69e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6a1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6a5:	75 07                	jne    6ae <morecore+0x38>
    return 0;
 6a7:	b8 00 00 00 00       	mov    $0x0,%eax
 6ac:	eb 26                	jmp    6d4 <morecore+0x5e>
  hp = (Header*)p;
 6ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b7:	8b 55 08             	mov    0x8(%ebp),%edx
 6ba:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c0:	83 c0 08             	add    $0x8,%eax
 6c3:	83 ec 0c             	sub    $0xc,%esp
 6c6:	50                   	push   %eax
 6c7:	e8 c9 fe ff ff       	call   595 <free>
 6cc:	83 c4 10             	add    $0x10,%esp
  return freep;
 6cf:	a1 50 13 00 00       	mov    0x1350,%eax
}
 6d4:	c9                   	leave  
 6d5:	c3                   	ret    

000006d6 <malloc>:

void*
malloc(uint nbytes)
{
 6d6:	55                   	push   %ebp
 6d7:	89 e5                	mov    %esp,%ebp
 6d9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	83 c0 07             	add    $0x7,%eax
 6e2:	c1 e8 03             	shr    $0x3,%eax
 6e5:	83 c0 01             	add    $0x1,%eax
 6e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6eb:	a1 50 13 00 00       	mov    0x1350,%eax
 6f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f7:	75 23                	jne    71c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 6f9:	c7 45 f0 48 13 00 00 	movl   $0x1348,-0x10(%ebp)
 700:	8b 45 f0             	mov    -0x10(%ebp),%eax
 703:	a3 50 13 00 00       	mov    %eax,0x1350
 708:	a1 50 13 00 00       	mov    0x1350,%eax
 70d:	a3 48 13 00 00       	mov    %eax,0x1348
    base.s.size = 0;
 712:	c7 05 4c 13 00 00 00 	movl   $0x0,0x134c
 719:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71f:	8b 00                	mov    (%eax),%eax
 721:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 724:	8b 45 f4             	mov    -0xc(%ebp),%eax
 727:	8b 40 04             	mov    0x4(%eax),%eax
 72a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 72d:	72 4d                	jb     77c <malloc+0xa6>
      if(p->s.size == nunits)
 72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 732:	8b 40 04             	mov    0x4(%eax),%eax
 735:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 738:	75 0c                	jne    746 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 73a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73d:	8b 10                	mov    (%eax),%edx
 73f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 742:	89 10                	mov    %edx,(%eax)
 744:	eb 26                	jmp    76c <malloc+0x96>
      else {
        p->s.size -= nunits;
 746:	8b 45 f4             	mov    -0xc(%ebp),%eax
 749:	8b 40 04             	mov    0x4(%eax),%eax
 74c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 74f:	89 c2                	mov    %eax,%edx
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	8b 40 04             	mov    0x4(%eax),%eax
 75d:	c1 e0 03             	shl    $0x3,%eax
 760:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	8b 55 ec             	mov    -0x14(%ebp),%edx
 769:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	a3 50 13 00 00       	mov    %eax,0x1350
      return (void*)(p + 1);
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	83 c0 08             	add    $0x8,%eax
 77a:	eb 3b                	jmp    7b7 <malloc+0xe1>
    }
    if(p == freep)
 77c:	a1 50 13 00 00       	mov    0x1350,%eax
 781:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 784:	75 1e                	jne    7a4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 786:	83 ec 0c             	sub    $0xc,%esp
 789:	ff 75 ec             	pushl  -0x14(%ebp)
 78c:	e8 e5 fe ff ff       	call   676 <morecore>
 791:	83 c4 10             	add    $0x10,%esp
 794:	89 45 f4             	mov    %eax,-0xc(%ebp)
 797:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 79b:	75 07                	jne    7a4 <malloc+0xce>
        return 0;
 79d:	b8 00 00 00 00       	mov    $0x0,%eax
 7a2:	eb 13                	jmp    7b7 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7b2:	e9 6d ff ff ff       	jmp    724 <malloc+0x4e>
}
 7b7:	c9                   	leave  
 7b8:	c3                   	ret    

000007b9 <isspace>:

#include "common.h"

int isspace(char c) {
 7b9:	55                   	push   %ebp
 7ba:	89 e5                	mov    %esp,%ebp
 7bc:	83 ec 04             	sub    $0x4,%esp
 7bf:	8b 45 08             	mov    0x8(%ebp),%eax
 7c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 7c5:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 7c9:	74 12                	je     7dd <isspace+0x24>
 7cb:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 7cf:	74 0c                	je     7dd <isspace+0x24>
 7d1:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 7d5:	74 06                	je     7dd <isspace+0x24>
 7d7:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 7db:	75 07                	jne    7e4 <isspace+0x2b>
 7dd:	b8 01 00 00 00       	mov    $0x1,%eax
 7e2:	eb 05                	jmp    7e9 <isspace+0x30>
 7e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 7e9:	c9                   	leave  
 7ea:	c3                   	ret    

000007eb <readln>:

char* readln(char *buf, int max, int fd)
{
 7eb:	55                   	push   %ebp
 7ec:	89 e5                	mov    %esp,%ebp
 7ee:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 7f8:	eb 45                	jmp    83f <readln+0x54>
    cc = read(fd, &c, 1);
 7fa:	83 ec 04             	sub    $0x4,%esp
 7fd:	6a 01                	push   $0x1
 7ff:	8d 45 ef             	lea    -0x11(%ebp),%eax
 802:	50                   	push   %eax
 803:	ff 75 10             	pushl  0x10(%ebp)
 806:	e8 7d fa ff ff       	call   288 <read>
 80b:	83 c4 10             	add    $0x10,%esp
 80e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 815:	7f 02                	jg     819 <readln+0x2e>
      break;
 817:	eb 31                	jmp    84a <readln+0x5f>
    buf[i++] = c;
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	8d 50 01             	lea    0x1(%eax),%edx
 81f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 822:	89 c2                	mov    %eax,%edx
 824:	8b 45 08             	mov    0x8(%ebp),%eax
 827:	01 c2                	add    %eax,%edx
 829:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 82d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 82f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 833:	3c 0a                	cmp    $0xa,%al
 835:	74 13                	je     84a <readln+0x5f>
 837:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 83b:	3c 0d                	cmp    $0xd,%al
 83d:	74 0b                	je     84a <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	83 c0 01             	add    $0x1,%eax
 845:	3b 45 0c             	cmp    0xc(%ebp),%eax
 848:	7c b0                	jl     7fa <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 84a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
 850:	01 d0                	add    %edx,%eax
 852:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 855:	8b 45 08             	mov    0x8(%ebp),%eax
}
 858:	c9                   	leave  
 859:	c3                   	ret    

0000085a <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 85a:	55                   	push   %ebp
 85b:	89 e5                	mov    %esp,%ebp
 85d:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 860:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 867:	eb 19                	jmp    882 <strncpy+0x28>
		dest[i] = src[i];
 869:	8b 55 fc             	mov    -0x4(%ebp),%edx
 86c:	8b 45 08             	mov    0x8(%ebp),%eax
 86f:	01 c2                	add    %eax,%edx
 871:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 874:	8b 45 0c             	mov    0xc(%ebp),%eax
 877:	01 c8                	add    %ecx,%eax
 879:	0f b6 00             	movzbl (%eax),%eax
 87c:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 87e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 882:	8b 45 fc             	mov    -0x4(%ebp),%eax
 885:	3b 45 10             	cmp    0x10(%ebp),%eax
 888:	7d 0f                	jge    899 <strncpy+0x3f>
 88a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 88d:	8b 45 0c             	mov    0xc(%ebp),%eax
 890:	01 d0                	add    %edx,%eax
 892:	0f b6 00             	movzbl (%eax),%eax
 895:	84 c0                	test   %al,%al
 897:	75 d0                	jne    869 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 899:	8b 45 08             	mov    0x8(%ebp),%eax
}
 89c:	c9                   	leave  
 89d:	c3                   	ret    

0000089e <trim>:

char* trim(char* orig) {
 89e:	55                   	push   %ebp
 89f:	89 e5                	mov    %esp,%ebp
 8a1:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 8a4:	8b 45 08             	mov    0x8(%ebp),%eax
 8a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 8aa:	8b 45 08             	mov    0x8(%ebp),%eax
 8ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 8b0:	eb 04                	jmp    8b6 <trim+0x18>
 8b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	0f b6 00             	movzbl (%eax),%eax
 8bc:	0f be c0             	movsbl %al,%eax
 8bf:	50                   	push   %eax
 8c0:	e8 f4 fe ff ff       	call   7b9 <isspace>
 8c5:	83 c4 04             	add    $0x4,%esp
 8c8:	85 c0                	test   %eax,%eax
 8ca:	75 e6                	jne    8b2 <trim+0x14>
	while (*tail) { tail++; }
 8cc:	eb 04                	jmp    8d2 <trim+0x34>
 8ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d5:	0f b6 00             	movzbl (%eax),%eax
 8d8:	84 c0                	test   %al,%al
 8da:	75 f2                	jne    8ce <trim+0x30>
	do { tail--; } while (isspace(*tail));
 8dc:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 8e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e3:	0f b6 00             	movzbl (%eax),%eax
 8e6:	0f be c0             	movsbl %al,%eax
 8e9:	50                   	push   %eax
 8ea:	e8 ca fe ff ff       	call   7b9 <isspace>
 8ef:	83 c4 04             	add    $0x4,%esp
 8f2:	85 c0                	test   %eax,%eax
 8f4:	75 e6                	jne    8dc <trim+0x3e>
	new = malloc(tail-head+2);
 8f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fc:	29 c2                	sub    %eax,%edx
 8fe:	89 d0                	mov    %edx,%eax
 900:	83 c0 02             	add    $0x2,%eax
 903:	83 ec 0c             	sub    $0xc,%esp
 906:	50                   	push   %eax
 907:	e8 ca fd ff ff       	call   6d6 <malloc>
 90c:	83 c4 10             	add    $0x10,%esp
 90f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 912:	8b 55 f0             	mov    -0x10(%ebp),%edx
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	29 c2                	sub    %eax,%edx
 91a:	89 d0                	mov    %edx,%eax
 91c:	83 c0 01             	add    $0x1,%eax
 91f:	83 ec 04             	sub    $0x4,%esp
 922:	50                   	push   %eax
 923:	ff 75 f4             	pushl  -0xc(%ebp)
 926:	ff 75 ec             	pushl  -0x14(%ebp)
 929:	e8 2c ff ff ff       	call   85a <strncpy>
 92e:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 931:	8b 55 f0             	mov    -0x10(%ebp),%edx
 934:	8b 45 f4             	mov    -0xc(%ebp),%eax
 937:	29 c2                	sub    %eax,%edx
 939:	89 d0                	mov    %edx,%eax
 93b:	8d 50 01             	lea    0x1(%eax),%edx
 93e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 941:	01 d0                	add    %edx,%eax
 943:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 946:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 949:	c9                   	leave  
 94a:	c3                   	ret    

0000094b <itoa>:

char *
itoa(int value)
{
 94b:	55                   	push   %ebp
 94c:	89 e5                	mov    %esp,%ebp
 94e:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 951:	8d 45 bf             	lea    -0x41(%ebp),%eax
 954:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 957:	8b 45 08             	mov    0x8(%ebp),%eax
 95a:	c1 e8 1f             	shr    $0x1f,%eax
 95d:	0f b6 c0             	movzbl %al,%eax
 960:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 963:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 967:	74 0a                	je     973 <itoa+0x28>
    v = -value;
 969:	8b 45 08             	mov    0x8(%ebp),%eax
 96c:	f7 d8                	neg    %eax
 96e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 971:	eb 06                	jmp    979 <itoa+0x2e>
  else
    v = (uint)value;
 973:	8b 45 08             	mov    0x8(%ebp),%eax
 976:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 979:	eb 5b                	jmp    9d6 <itoa+0x8b>
  {
    i = v % 10;
 97b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 97e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 983:	89 c8                	mov    %ecx,%eax
 985:	f7 e2                	mul    %edx
 987:	c1 ea 03             	shr    $0x3,%edx
 98a:	89 d0                	mov    %edx,%eax
 98c:	c1 e0 02             	shl    $0x2,%eax
 98f:	01 d0                	add    %edx,%eax
 991:	01 c0                	add    %eax,%eax
 993:	29 c1                	sub    %eax,%ecx
 995:	89 ca                	mov    %ecx,%edx
 997:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 99a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99d:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9a2:	f7 e2                	mul    %edx
 9a4:	89 d0                	mov    %edx,%eax
 9a6:	c1 e8 03             	shr    $0x3,%eax
 9a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 9ac:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 9b0:	7f 13                	jg     9c5 <itoa+0x7a>
      *tp++ = i+'0';
 9b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b5:	8d 50 01             	lea    0x1(%eax),%edx
 9b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9be:	83 c2 30             	add    $0x30,%edx
 9c1:	88 10                	mov    %dl,(%eax)
 9c3:	eb 11                	jmp    9d6 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	8d 50 01             	lea    0x1(%eax),%edx
 9cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9d1:	83 c2 57             	add    $0x57,%edx
 9d4:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 9d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9da:	75 9f                	jne    97b <itoa+0x30>
 9dc:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9df:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9e2:	74 97                	je     97b <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 9e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9e7:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9ea:	29 c2                	sub    %eax,%edx
 9ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9ef:	01 d0                	add    %edx,%eax
 9f1:	83 c0 01             	add    $0x1,%eax
 9f4:	83 ec 0c             	sub    $0xc,%esp
 9f7:	50                   	push   %eax
 9f8:	e8 d9 fc ff ff       	call   6d6 <malloc>
 9fd:	83 c4 10             	add    $0x10,%esp
 a00:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a03:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a06:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a09:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a0d:	74 0c                	je     a1b <itoa+0xd0>
    *sp++ = '-';
 a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a12:	8d 50 01             	lea    0x1(%eax),%edx
 a15:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a18:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a1b:	eb 15                	jmp    a32 <itoa+0xe7>
    *sp++ = *--tp;
 a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a20:	8d 50 01             	lea    0x1(%eax),%edx
 a23:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a26:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a2d:	0f b6 12             	movzbl (%edx),%edx
 a30:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 a32:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a35:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a38:	77 e3                	ja     a1d <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a3d:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 a40:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 a43:	c9                   	leave  
 a44:	c3                   	ret    

00000a45 <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 a45:	55                   	push   %ebp
 a46:	89 e5                	mov    %esp,%ebp
 a48:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 a4e:	83 ec 08             	sub    $0x8,%esp
 a51:	6a 00                	push   $0x0
 a53:	ff 75 08             	pushl  0x8(%ebp)
 a56:	e8 55 f8 ff ff       	call   2b0 <open>
 a5b:	83 c4 10             	add    $0x10,%esp
 a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 a61:	e9 22 01 00 00       	jmp    b88 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 a66:	83 ec 08             	sub    $0x8,%esp
 a69:	6a 3d                	push   $0x3d
 a6b:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 a71:	50                   	push   %eax
 a72:	e8 79 f6 ff ff       	call   f0 <strchr>
 a77:	83 c4 10             	add    $0x10,%esp
 a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 a7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a81:	0f 84 23 01 00 00    	je     baa <parseEnvFile+0x165>
 a87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a8b:	0f 84 19 01 00 00    	je     baa <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 a91:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a94:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 a9a:	29 c2                	sub    %eax,%edx
 a9c:	89 d0                	mov    %edx,%eax
 a9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa4:	83 c0 01             	add    $0x1,%eax
 aa7:	83 ec 0c             	sub    $0xc,%esp
 aaa:	50                   	push   %eax
 aab:	e8 26 fc ff ff       	call   6d6 <malloc>
 ab0:	83 c4 10             	add    $0x10,%esp
 ab3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 ab6:	83 ec 04             	sub    $0x4,%esp
 ab9:	ff 75 ec             	pushl  -0x14(%ebp)
 abc:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ac2:	50                   	push   %eax
 ac3:	ff 75 e8             	pushl  -0x18(%ebp)
 ac6:	e8 8f fd ff ff       	call   85a <strncpy>
 acb:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 ace:	83 ec 0c             	sub    $0xc,%esp
 ad1:	ff 75 e8             	pushl  -0x18(%ebp)
 ad4:	e8 c5 fd ff ff       	call   89e <trim>
 ad9:	83 c4 10             	add    $0x10,%esp
 adc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 adf:	83 ec 0c             	sub    $0xc,%esp
 ae2:	ff 75 e8             	pushl  -0x18(%ebp)
 ae5:	e8 ab fa ff ff       	call   595 <free>
 aea:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 aed:	83 ec 08             	sub    $0x8,%esp
 af0:	ff 75 0c             	pushl  0xc(%ebp)
 af3:	ff 75 e4             	pushl  -0x1c(%ebp)
 af6:	e8 c2 01 00 00       	call   cbd <addToEnvironment>
 afb:	83 c4 10             	add    $0x10,%esp
 afe:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b01:	83 ec 0c             	sub    $0xc,%esp
 b04:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b0a:	50                   	push   %eax
 b0b:	e8 9f f5 ff ff       	call   af <strlen>
 b10:	83 c4 10             	add    $0x10,%esp
 b13:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b19:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b1c:	83 ec 0c             	sub    $0xc,%esp
 b1f:	50                   	push   %eax
 b20:	e8 b1 fb ff ff       	call   6d6 <malloc>
 b25:	83 c4 10             	add    $0x10,%esp
 b28:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 b2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b2e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b31:	8d 50 ff             	lea    -0x1(%eax),%edx
 b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b37:	8d 48 01             	lea    0x1(%eax),%ecx
 b3a:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b40:	01 c8                	add    %ecx,%eax
 b42:	83 ec 04             	sub    $0x4,%esp
 b45:	52                   	push   %edx
 b46:	50                   	push   %eax
 b47:	ff 75 e8             	pushl  -0x18(%ebp)
 b4a:	e8 0b fd ff ff       	call   85a <strncpy>
 b4f:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 b52:	83 ec 0c             	sub    $0xc,%esp
 b55:	ff 75 e8             	pushl  -0x18(%ebp)
 b58:	e8 41 fd ff ff       	call   89e <trim>
 b5d:	83 c4 10             	add    $0x10,%esp
 b60:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 b63:	83 ec 0c             	sub    $0xc,%esp
 b66:	ff 75 e8             	pushl  -0x18(%ebp)
 b69:	e8 27 fa ff ff       	call   595 <free>
 b6e:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 b71:	83 ec 04             	sub    $0x4,%esp
 b74:	ff 75 dc             	pushl  -0x24(%ebp)
 b77:	ff 75 0c             	pushl  0xc(%ebp)
 b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
 b7d:	e8 b8 01 00 00       	call   d3a <addValueToVariable>
 b82:	83 c4 10             	add    $0x10,%esp
 b85:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 b88:	83 ec 04             	sub    $0x4,%esp
 b8b:	ff 75 f4             	pushl  -0xc(%ebp)
 b8e:	68 00 04 00 00       	push   $0x400
 b93:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b99:	50                   	push   %eax
 b9a:	e8 4c fc ff ff       	call   7eb <readln>
 b9f:	83 c4 10             	add    $0x10,%esp
 ba2:	85 c0                	test   %eax,%eax
 ba4:	0f 85 bc fe ff ff    	jne    a66 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 baa:	83 ec 0c             	sub    $0xc,%esp
 bad:	ff 75 f4             	pushl  -0xc(%ebp)
 bb0:	e8 e3 f6 ff ff       	call   298 <close>
 bb5:	83 c4 10             	add    $0x10,%esp
	return head;
 bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 bbb:	c9                   	leave  
 bbc:	c3                   	ret    

00000bbd <comp>:

int comp(const char* s1, const char* s2)
{
 bbd:	55                   	push   %ebp
 bbe:	89 e5                	mov    %esp,%ebp
 bc0:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 bc3:	83 ec 08             	sub    $0x8,%esp
 bc6:	ff 75 0c             	pushl  0xc(%ebp)
 bc9:	ff 75 08             	pushl  0x8(%ebp)
 bcc:	e8 9f f4 ff ff       	call   70 <strcmp>
 bd1:	83 c4 10             	add    $0x10,%esp
 bd4:	85 c0                	test   %eax,%eax
 bd6:	0f 94 c0             	sete   %al
 bd9:	0f b6 c0             	movzbl %al,%eax
}
 bdc:	c9                   	leave  
 bdd:	c3                   	ret    

00000bde <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 bde:	55                   	push   %ebp
 bdf:	89 e5                	mov    %esp,%ebp
 be1:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 be4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 be8:	75 07                	jne    bf1 <environLookup+0x13>
    return NULL;
 bea:	b8 00 00 00 00       	mov    $0x0,%eax
 bef:	eb 2f                	jmp    c20 <environLookup+0x42>
  
  while (head)
 bf1:	eb 24                	jmp    c17 <environLookup+0x39>
  {
    if (comp(name, head->name))
 bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
 bf6:	83 ec 08             	sub    $0x8,%esp
 bf9:	50                   	push   %eax
 bfa:	ff 75 08             	pushl  0x8(%ebp)
 bfd:	e8 bb ff ff ff       	call   bbd <comp>
 c02:	83 c4 10             	add    $0x10,%esp
 c05:	85 c0                	test   %eax,%eax
 c07:	74 02                	je     c0b <environLookup+0x2d>
      break;
 c09:	eb 12                	jmp    c1d <environLookup+0x3f>
    head = head->next;
 c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
 c0e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c14:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c1b:	75 d6                	jne    bf3 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c20:	c9                   	leave  
 c21:	c3                   	ret    

00000c22 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c22:	55                   	push   %ebp
 c23:	89 e5                	mov    %esp,%ebp
 c25:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c2c:	75 0a                	jne    c38 <removeFromEnvironment+0x16>
    return NULL;
 c2e:	b8 00 00 00 00       	mov    $0x0,%eax
 c33:	e9 83 00 00 00       	jmp    cbb <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 c38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c3c:	74 0a                	je     c48 <removeFromEnvironment+0x26>
 c3e:	8b 45 08             	mov    0x8(%ebp),%eax
 c41:	0f b6 00             	movzbl (%eax),%eax
 c44:	84 c0                	test   %al,%al
 c46:	75 05                	jne    c4d <removeFromEnvironment+0x2b>
    return head;
 c48:	8b 45 0c             	mov    0xc(%ebp),%eax
 c4b:	eb 6e                	jmp    cbb <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
 c50:	83 ec 08             	sub    $0x8,%esp
 c53:	ff 75 08             	pushl  0x8(%ebp)
 c56:	50                   	push   %eax
 c57:	e8 61 ff ff ff       	call   bbd <comp>
 c5c:	83 c4 10             	add    $0x10,%esp
 c5f:	85 c0                	test   %eax,%eax
 c61:	74 34                	je     c97 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 c63:	8b 45 0c             	mov    0xc(%ebp),%eax
 c66:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
 c72:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 c78:	83 ec 0c             	sub    $0xc,%esp
 c7b:	50                   	push   %eax
 c7c:	e8 74 01 00 00       	call   df5 <freeVarval>
 c81:	83 c4 10             	add    $0x10,%esp
    free(head);
 c84:	83 ec 0c             	sub    $0xc,%esp
 c87:	ff 75 0c             	pushl  0xc(%ebp)
 c8a:	e8 06 f9 ff ff       	call   595 <free>
 c8f:	83 c4 10             	add    $0x10,%esp
    return tmp;
 c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c95:	eb 24                	jmp    cbb <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 c97:	8b 45 0c             	mov    0xc(%ebp),%eax
 c9a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 ca0:	83 ec 08             	sub    $0x8,%esp
 ca3:	50                   	push   %eax
 ca4:	ff 75 08             	pushl  0x8(%ebp)
 ca7:	e8 76 ff ff ff       	call   c22 <removeFromEnvironment>
 cac:	83 c4 10             	add    $0x10,%esp
 caf:	8b 55 0c             	mov    0xc(%ebp),%edx
 cb2:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 cbb:	c9                   	leave  
 cbc:	c3                   	ret    

00000cbd <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 cbd:	55                   	push   %ebp
 cbe:	89 e5                	mov    %esp,%ebp
 cc0:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 cc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 cc7:	75 05                	jne    cce <addToEnvironment+0x11>
		return head;
 cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
 ccc:	eb 6a                	jmp    d38 <addToEnvironment+0x7b>
	if (head == NULL) {
 cce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 cd2:	75 40                	jne    d14 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 cd4:	83 ec 0c             	sub    $0xc,%esp
 cd7:	68 88 00 00 00       	push   $0x88
 cdc:	e8 f5 f9 ff ff       	call   6d6 <malloc>
 ce1:	83 c4 10             	add    $0x10,%esp
 ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 ce7:	8b 45 08             	mov    0x8(%ebp),%eax
 cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cf0:	83 ec 08             	sub    $0x8,%esp
 cf3:	ff 75 f0             	pushl  -0x10(%ebp)
 cf6:	50                   	push   %eax
 cf7:	e8 44 f3 ff ff       	call   40 <strcpy>
 cfc:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d02:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d09:	00 00 00 
		head = newVar;
 d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d0f:	89 45 0c             	mov    %eax,0xc(%ebp)
 d12:	eb 21                	jmp    d35 <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d14:	8b 45 0c             	mov    0xc(%ebp),%eax
 d17:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d1d:	83 ec 08             	sub    $0x8,%esp
 d20:	50                   	push   %eax
 d21:	ff 75 08             	pushl  0x8(%ebp)
 d24:	e8 94 ff ff ff       	call   cbd <addToEnvironment>
 d29:	83 c4 10             	add    $0x10,%esp
 d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
 d2f:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 d35:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d38:	c9                   	leave  
 d39:	c3                   	ret    

00000d3a <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 d3a:	55                   	push   %ebp
 d3b:	89 e5                	mov    %esp,%ebp
 d3d:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 d40:	83 ec 08             	sub    $0x8,%esp
 d43:	ff 75 0c             	pushl  0xc(%ebp)
 d46:	ff 75 08             	pushl  0x8(%ebp)
 d49:	e8 90 fe ff ff       	call   bde <environLookup>
 d4e:	83 c4 10             	add    $0x10,%esp
 d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 d54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d58:	75 05                	jne    d5f <addValueToVariable+0x25>
		return head;
 d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
 d5d:	eb 4c                	jmp    dab <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 d5f:	83 ec 0c             	sub    $0xc,%esp
 d62:	68 04 04 00 00       	push   $0x404
 d67:	e8 6a f9 ff ff       	call   6d6 <malloc>
 d6c:	83 c4 10             	add    $0x10,%esp
 d6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 d72:	8b 45 10             	mov    0x10(%ebp),%eax
 d75:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d7b:	83 ec 08             	sub    $0x8,%esp
 d7e:	ff 75 ec             	pushl  -0x14(%ebp)
 d81:	50                   	push   %eax
 d82:	e8 b9 f2 ff ff       	call   40 <strcpy>
 d87:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d8d:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d96:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
 da2:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 da8:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 dab:	c9                   	leave  
 dac:	c3                   	ret    

00000dad <freeEnvironment>:

void freeEnvironment(variable* head)
{
 dad:	55                   	push   %ebp
 dae:	89 e5                	mov    %esp,%ebp
 db0:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 db3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 db7:	75 02                	jne    dbb <freeEnvironment+0xe>
    return;  
 db9:	eb 38                	jmp    df3 <freeEnvironment+0x46>
  freeEnvironment(head->next);
 dbb:	8b 45 08             	mov    0x8(%ebp),%eax
 dbe:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 dc4:	83 ec 0c             	sub    $0xc,%esp
 dc7:	50                   	push   %eax
 dc8:	e8 e0 ff ff ff       	call   dad <freeEnvironment>
 dcd:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 dd0:	8b 45 08             	mov    0x8(%ebp),%eax
 dd3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 dd9:	83 ec 0c             	sub    $0xc,%esp
 ddc:	50                   	push   %eax
 ddd:	e8 13 00 00 00       	call   df5 <freeVarval>
 de2:	83 c4 10             	add    $0x10,%esp
  free(head);
 de5:	83 ec 0c             	sub    $0xc,%esp
 de8:	ff 75 08             	pushl  0x8(%ebp)
 deb:	e8 a5 f7 ff ff       	call   595 <free>
 df0:	83 c4 10             	add    $0x10,%esp
}
 df3:	c9                   	leave  
 df4:	c3                   	ret    

00000df5 <freeVarval>:

void freeVarval(varval* head)
{
 df5:	55                   	push   %ebp
 df6:	89 e5                	mov    %esp,%ebp
 df8:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 dfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 dff:	75 02                	jne    e03 <freeVarval+0xe>
    return;  
 e01:	eb 23                	jmp    e26 <freeVarval+0x31>
  freeVarval(head->next);
 e03:	8b 45 08             	mov    0x8(%ebp),%eax
 e06:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e0c:	83 ec 0c             	sub    $0xc,%esp
 e0f:	50                   	push   %eax
 e10:	e8 e0 ff ff ff       	call   df5 <freeVarval>
 e15:	83 c4 10             	add    $0x10,%esp
  free(head);
 e18:	83 ec 0c             	sub    $0xc,%esp
 e1b:	ff 75 08             	pushl  0x8(%ebp)
 e1e:	e8 72 f7 ff ff       	call   595 <free>
 e23:	83 c4 10             	add    $0x10,%esp
}
 e26:	c9                   	leave  
 e27:	c3                   	ret    

00000e28 <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e28:	55                   	push   %ebp
 e29:	89 e5                	mov    %esp,%ebp
 e2b:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 e2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e32:	75 08                	jne    e3c <getPaths+0x14>
		return head;
 e34:	8b 45 0c             	mov    0xc(%ebp),%eax
 e37:	e9 e7 00 00 00       	jmp    f23 <getPaths+0xfb>
	if (head == NULL) {
 e3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 e40:	0f 85 b9 00 00 00    	jne    eff <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 e46:	83 ec 08             	sub    $0x8,%esp
 e49:	6a 3a                	push   $0x3a
 e4b:	ff 75 08             	pushl  0x8(%ebp)
 e4e:	e8 9d f2 ff ff       	call   f0 <strchr>
 e53:	83 c4 10             	add    $0x10,%esp
 e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e5d:	75 56                	jne    eb5 <getPaths+0x8d>
			pathLen = strlen(paths);
 e5f:	83 ec 0c             	sub    $0xc,%esp
 e62:	ff 75 08             	pushl  0x8(%ebp)
 e65:	e8 45 f2 ff ff       	call   af <strlen>
 e6a:	83 c4 10             	add    $0x10,%esp
 e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 e70:	83 ec 0c             	sub    $0xc,%esp
 e73:	68 04 04 00 00       	push   $0x404
 e78:	e8 59 f8 ff ff       	call   6d6 <malloc>
 e7d:	83 c4 10             	add    $0x10,%esp
 e80:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 e83:	8b 45 0c             	mov    0xc(%ebp),%eax
 e86:	83 ec 04             	sub    $0x4,%esp
 e89:	ff 75 f0             	pushl  -0x10(%ebp)
 e8c:	ff 75 08             	pushl  0x8(%ebp)
 e8f:	50                   	push   %eax
 e90:	e8 c5 f9 ff ff       	call   85a <strncpy>
 e95:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 e98:	8b 55 0c             	mov    0xc(%ebp),%edx
 e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e9e:	01 d0                	add    %edx,%eax
 ea0:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
 ea6:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 ead:	00 00 00 
			return head;
 eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
 eb3:	eb 6e                	jmp    f23 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 eb8:	8b 45 08             	mov    0x8(%ebp),%eax
 ebb:	29 c2                	sub    %eax,%edx
 ebd:	89 d0                	mov    %edx,%eax
 ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 ec2:	83 ec 0c             	sub    $0xc,%esp
 ec5:	68 04 04 00 00       	push   $0x404
 eca:	e8 07 f8 ff ff       	call   6d6 <malloc>
 ecf:	83 c4 10             	add    $0x10,%esp
 ed2:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
 ed8:	83 ec 04             	sub    $0x4,%esp
 edb:	ff 75 f0             	pushl  -0x10(%ebp)
 ede:	ff 75 08             	pushl  0x8(%ebp)
 ee1:	50                   	push   %eax
 ee2:	e8 73 f9 ff ff       	call   85a <strncpy>
 ee7:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 eea:	8b 55 0c             	mov    0xc(%ebp),%edx
 eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ef0:	01 d0                	add    %edx,%eax
 ef2:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ef8:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 efb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 eff:	8b 45 0c             	mov    0xc(%ebp),%eax
 f02:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f08:	83 ec 08             	sub    $0x8,%esp
 f0b:	50                   	push   %eax
 f0c:	ff 75 08             	pushl  0x8(%ebp)
 f0f:	e8 14 ff ff ff       	call   e28 <getPaths>
 f14:	83 c4 10             	add    $0x10,%esp
 f17:	8b 55 0c             	mov    0xc(%ebp),%edx
 f1a:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f20:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f23:	c9                   	leave  
 f24:	c3                   	ret    
