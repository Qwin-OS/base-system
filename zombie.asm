
_zombie:     формат файла elf32-i386


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
  if(fork() > 0)
  11:	e8 63 02 00 00       	call   279 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ed 02 00 00       	call   311 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 55 02 00 00       	call   281 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	5b                   	pop    %ebx
  4e:	5f                   	pop    %edi
  4f:	5d                   	pop    %ebp
  50:	c3                   	ret    

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5d:	90                   	nop
  5e:	8b 45 08             	mov    0x8(%ebp),%eax
  61:	8d 50 01             	lea    0x1(%eax),%edx
  64:	89 55 08             	mov    %edx,0x8(%ebp)
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  70:	0f b6 12             	movzbl (%edx),%edx
  73:	88 10                	mov    %dl,(%eax)
  75:	0f b6 00             	movzbl (%eax),%eax
  78:	84 c0                	test   %al,%al
  7a:	75 e2                	jne    5e <strcpy+0xd>
    ;
  return os;
  7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7f:	c9                   	leave  
  80:	c3                   	ret    

00000081 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  81:	55                   	push   %ebp
  82:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  84:	eb 08                	jmp    8e <strcmp+0xd>
    p++, q++;
  86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8e:	8b 45 08             	mov    0x8(%ebp),%eax
  91:	0f b6 00             	movzbl (%eax),%eax
  94:	84 c0                	test   %al,%al
  96:	74 10                	je     a8 <strcmp+0x27>
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	0f b6 10             	movzbl (%eax),%edx
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	0f b6 00             	movzbl (%eax),%eax
  a4:	38 c2                	cmp    %al,%dl
  a6:	74 de                	je     86 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f b6 d0             	movzbl %al,%edx
  b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  b4:	0f b6 00             	movzbl (%eax),%eax
  b7:	0f b6 c0             	movzbl %al,%eax
  ba:	29 c2                	sub    %eax,%edx
  bc:	89 d0                	mov    %edx,%eax
}
  be:	5d                   	pop    %ebp
  bf:	c3                   	ret    

000000c0 <strlen>:

uint
strlen(char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  cd:	eb 04                	jmp    d3 <strlen+0x13>
  cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	01 d0                	add    %edx,%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	84 c0                	test   %al,%al
  e0:	75 ed                	jne    cf <strlen+0xf>
    ;
  return n;
  e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e5:	c9                   	leave  
  e6:	c3                   	ret    

000000e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  ea:	8b 45 10             	mov    0x10(%ebp),%eax
  ed:	50                   	push   %eax
  ee:	ff 75 0c             	pushl  0xc(%ebp)
  f1:	ff 75 08             	pushl  0x8(%ebp)
  f4:	e8 33 ff ff ff       	call   2c <stosb>
  f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <strchr>:

char*
strchr(const char *s, char c)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 04             	sub    $0x4,%esp
 107:	8b 45 0c             	mov    0xc(%ebp),%eax
 10a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10d:	eb 14                	jmp    123 <strchr+0x22>
    if(*s == c)
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	3a 45 fc             	cmp    -0x4(%ebp),%al
 118:	75 05                	jne    11f <strchr+0x1e>
      return (char*)s;
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	eb 13                	jmp    132 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	84 c0                	test   %al,%al
 12b:	75 e2                	jne    10f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 141:	eb 44                	jmp    187 <gets+0x53>
    cc = read(0, &c, 1);
 143:	83 ec 04             	sub    $0x4,%esp
 146:	6a 01                	push   $0x1
 148:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14b:	50                   	push   %eax
 14c:	6a 00                	push   $0x0
 14e:	e8 46 01 00 00       	call   299 <read>
 153:	83 c4 10             	add    $0x10,%esp
 156:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 159:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15d:	7f 02                	jg     161 <gets+0x2d>
      break;
 15f:	eb 31                	jmp    192 <gets+0x5e>
    buf[i++] = c;
 161:	8b 45 f4             	mov    -0xc(%ebp),%eax
 164:	8d 50 01             	lea    0x1(%eax),%edx
 167:	89 55 f4             	mov    %edx,-0xc(%ebp)
 16a:	89 c2                	mov    %eax,%edx
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	01 c2                	add    %eax,%edx
 171:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 175:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 177:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17b:	3c 0a                	cmp    $0xa,%al
 17d:	74 13                	je     192 <gets+0x5e>
 17f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 183:	3c 0d                	cmp    $0xd,%al
 185:	74 0b                	je     192 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 187:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18a:	83 c0 01             	add    $0x1,%eax
 18d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 190:	7c b1                	jl     143 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 192:	8b 55 f4             	mov    -0xc(%ebp),%edx
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	01 d0                	add    %edx,%eax
 19a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a0:	c9                   	leave  
 1a1:	c3                   	ret    

000001a2 <stat>:

int
stat(char *n, struct stat *st)
{
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a8:	83 ec 08             	sub    $0x8,%esp
 1ab:	6a 00                	push   $0x0
 1ad:	ff 75 08             	pushl  0x8(%ebp)
 1b0:	e8 0c 01 00 00       	call   2c1 <open>
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bf:	79 07                	jns    1c8 <stat+0x26>
    return -1;
 1c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c6:	eb 25                	jmp    1ed <stat+0x4b>
  r = fstat(fd, st);
 1c8:	83 ec 08             	sub    $0x8,%esp
 1cb:	ff 75 0c             	pushl  0xc(%ebp)
 1ce:	ff 75 f4             	pushl  -0xc(%ebp)
 1d1:	e8 03 01 00 00       	call   2d9 <fstat>
 1d6:	83 c4 10             	add    $0x10,%esp
 1d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1dc:	83 ec 0c             	sub    $0xc,%esp
 1df:	ff 75 f4             	pushl  -0xc(%ebp)
 1e2:	e8 c2 00 00 00       	call   2a9 <close>
 1e7:	83 c4 10             	add    $0x10,%esp
  return r;
 1ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <atoi>:

int
atoi(const char *s)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fc:	eb 25                	jmp    223 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
 201:	89 d0                	mov    %edx,%eax
 203:	c1 e0 02             	shl    $0x2,%eax
 206:	01 d0                	add    %edx,%eax
 208:	01 c0                	add    %eax,%eax
 20a:	89 c1                	mov    %eax,%ecx
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8d 50 01             	lea    0x1(%eax),%edx
 212:	89 55 08             	mov    %edx,0x8(%ebp)
 215:	0f b6 00             	movzbl (%eax),%eax
 218:	0f be c0             	movsbl %al,%eax
 21b:	01 c8                	add    %ecx,%eax
 21d:	83 e8 30             	sub    $0x30,%eax
 220:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	3c 2f                	cmp    $0x2f,%al
 22b:	7e 0a                	jle    237 <atoi+0x48>
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 39                	cmp    $0x39,%al
 235:	7e c7                	jle    1fe <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 237:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23a:	c9                   	leave  
 23b:	c3                   	ret    

0000023c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 248:	8b 45 0c             	mov    0xc(%ebp),%eax
 24b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 24e:	eb 17                	jmp    267 <memmove+0x2b>
    *dst++ = *src++;
 250:	8b 45 fc             	mov    -0x4(%ebp),%eax
 253:	8d 50 01             	lea    0x1(%eax),%edx
 256:	89 55 fc             	mov    %edx,-0x4(%ebp)
 259:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25c:	8d 4a 01             	lea    0x1(%edx),%ecx
 25f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 262:	0f b6 12             	movzbl (%edx),%edx
 265:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 267:	8b 45 10             	mov    0x10(%ebp),%eax
 26a:	8d 50 ff             	lea    -0x1(%eax),%edx
 26d:	89 55 10             	mov    %edx,0x10(%ebp)
 270:	85 c0                	test   %eax,%eax
 272:	7f dc                	jg     250 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 279:	b8 01 00 00 00       	mov    $0x1,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <exit>:
SYSCALL(exit)
 281:	b8 02 00 00 00       	mov    $0x2,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <wait>:
SYSCALL(wait)
 289:	b8 03 00 00 00       	mov    $0x3,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <pipe>:
SYSCALL(pipe)
 291:	b8 04 00 00 00       	mov    $0x4,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <read>:
SYSCALL(read)
 299:	b8 05 00 00 00       	mov    $0x5,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <write>:
SYSCALL(write)
 2a1:	b8 10 00 00 00       	mov    $0x10,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <close>:
SYSCALL(close)
 2a9:	b8 15 00 00 00       	mov    $0x15,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <kill>:
SYSCALL(kill)
 2b1:	b8 06 00 00 00       	mov    $0x6,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <exec>:
SYSCALL(exec)
 2b9:	b8 07 00 00 00       	mov    $0x7,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <open>:
SYSCALL(open)
 2c1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <mknod>:
SYSCALL(mknod)
 2c9:	b8 11 00 00 00       	mov    $0x11,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <unlink>:
SYSCALL(unlink)
 2d1:	b8 12 00 00 00       	mov    $0x12,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <fstat>:
SYSCALL(fstat)
 2d9:	b8 08 00 00 00       	mov    $0x8,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <link>:
SYSCALL(link)
 2e1:	b8 13 00 00 00       	mov    $0x13,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <mkdir>:
SYSCALL(mkdir)
 2e9:	b8 14 00 00 00       	mov    $0x14,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <chdir>:
SYSCALL(chdir)
 2f1:	b8 09 00 00 00       	mov    $0x9,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <dup>:
SYSCALL(dup)
 2f9:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <getpid>:
SYSCALL(getpid)
 301:	b8 0b 00 00 00       	mov    $0xb,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <sbrk>:
SYSCALL(sbrk)
 309:	b8 0c 00 00 00       	mov    $0xc,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <sleep>:
SYSCALL(sleep)
 311:	b8 0d 00 00 00       	mov    $0xd,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <uptime>:
SYSCALL(uptime)
 319:	b8 0e 00 00 00       	mov    $0xe,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <getcwd>:
SYSCALL(getcwd)
 321:	b8 16 00 00 00       	mov    $0x16,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <shutdown>:
SYSCALL(shutdown)
 329:	b8 17 00 00 00       	mov    $0x17,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <buildinfo>:
SYSCALL(buildinfo)
 331:	b8 18 00 00 00       	mov    $0x18,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <lseek>:
SYSCALL(lseek)
 339:	b8 19 00 00 00       	mov    $0x19,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp
 344:	83 ec 18             	sub    $0x18,%esp
 347:	8b 45 0c             	mov    0xc(%ebp),%eax
 34a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 34d:	83 ec 04             	sub    $0x4,%esp
 350:	6a 01                	push   $0x1
 352:	8d 45 f4             	lea    -0xc(%ebp),%eax
 355:	50                   	push   %eax
 356:	ff 75 08             	pushl  0x8(%ebp)
 359:	e8 43 ff ff ff       	call   2a1 <write>
 35e:	83 c4 10             	add    $0x10,%esp
}
 361:	c9                   	leave  
 362:	c3                   	ret    

00000363 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 363:	55                   	push   %ebp
 364:	89 e5                	mov    %esp,%ebp
 366:	53                   	push   %ebx
 367:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 36a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 371:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 375:	74 17                	je     38e <printint+0x2b>
 377:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 37b:	79 11                	jns    38e <printint+0x2b>
    neg = 1;
 37d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	f7 d8                	neg    %eax
 389:	89 45 ec             	mov    %eax,-0x14(%ebp)
 38c:	eb 06                	jmp    394 <printint+0x31>
  } else {
    x = xx;
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 39b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 39e:	8d 41 01             	lea    0x1(%ecx),%eax
 3a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3aa:	ba 00 00 00 00       	mov    $0x0,%edx
 3af:	f7 f3                	div    %ebx
 3b1:	89 d0                	mov    %edx,%eax
 3b3:	0f b6 80 48 13 00 00 	movzbl 0x1348(%eax),%eax
 3ba:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3be:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c4:	ba 00 00 00 00       	mov    $0x0,%edx
 3c9:	f7 f3                	div    %ebx
 3cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3d2:	75 c7                	jne    39b <printint+0x38>
  if(neg)
 3d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d8:	74 0e                	je     3e8 <printint+0x85>
    buf[i++] = '-';
 3da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3dd:	8d 50 01             	lea    0x1(%eax),%edx
 3e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3e8:	eb 1d                	jmp    407 <printint+0xa4>
    putc(fd, buf[i]);
 3ea:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f0:	01 d0                	add    %edx,%eax
 3f2:	0f b6 00             	movzbl (%eax),%eax
 3f5:	0f be c0             	movsbl %al,%eax
 3f8:	83 ec 08             	sub    $0x8,%esp
 3fb:	50                   	push   %eax
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 3d ff ff ff       	call   341 <putc>
 404:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 407:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 40b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 40f:	79 d9                	jns    3ea <printint+0x87>
    putc(fd, buf[i]);
}
 411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 414:	c9                   	leave  
 415:	c3                   	ret    

00000416 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 416:	55                   	push   %ebp
 417:	89 e5                	mov    %esp,%ebp
 419:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 41c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 423:	8d 45 0c             	lea    0xc(%ebp),%eax
 426:	83 c0 04             	add    $0x4,%eax
 429:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 42c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 433:	e9 59 01 00 00       	jmp    591 <printf+0x17b>
    c = fmt[i] & 0xff;
 438:	8b 55 0c             	mov    0xc(%ebp),%edx
 43b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 43e:	01 d0                	add    %edx,%eax
 440:	0f b6 00             	movzbl (%eax),%eax
 443:	0f be c0             	movsbl %al,%eax
 446:	25 ff 00 00 00       	and    $0xff,%eax
 44b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 44e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 452:	75 2c                	jne    480 <printf+0x6a>
      if(c == '%'){
 454:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 458:	75 0c                	jne    466 <printf+0x50>
        state = '%';
 45a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 461:	e9 27 01 00 00       	jmp    58d <printf+0x177>
      } else {
        putc(fd, c);
 466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 469:	0f be c0             	movsbl %al,%eax
 46c:	83 ec 08             	sub    $0x8,%esp
 46f:	50                   	push   %eax
 470:	ff 75 08             	pushl  0x8(%ebp)
 473:	e8 c9 fe ff ff       	call   341 <putc>
 478:	83 c4 10             	add    $0x10,%esp
 47b:	e9 0d 01 00 00       	jmp    58d <printf+0x177>
      }
    } else if(state == '%'){
 480:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 484:	0f 85 03 01 00 00    	jne    58d <printf+0x177>
      if(c == 'd'){
 48a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 48e:	75 1e                	jne    4ae <printf+0x98>
        printint(fd, *ap, 10, 1);
 490:	8b 45 e8             	mov    -0x18(%ebp),%eax
 493:	8b 00                	mov    (%eax),%eax
 495:	6a 01                	push   $0x1
 497:	6a 0a                	push   $0xa
 499:	50                   	push   %eax
 49a:	ff 75 08             	pushl  0x8(%ebp)
 49d:	e8 c1 fe ff ff       	call   363 <printint>
 4a2:	83 c4 10             	add    $0x10,%esp
        ap++;
 4a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4a9:	e9 d8 00 00 00       	jmp    586 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ae:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4b2:	74 06                	je     4ba <printf+0xa4>
 4b4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4b8:	75 1e                	jne    4d8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bd:	8b 00                	mov    (%eax),%eax
 4bf:	6a 00                	push   $0x0
 4c1:	6a 10                	push   $0x10
 4c3:	50                   	push   %eax
 4c4:	ff 75 08             	pushl  0x8(%ebp)
 4c7:	e8 97 fe ff ff       	call   363 <printint>
 4cc:	83 c4 10             	add    $0x10,%esp
        ap++;
 4cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d3:	e9 ae 00 00 00       	jmp    586 <printf+0x170>
      } else if(c == 's'){
 4d8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4dc:	75 43                	jne    521 <printf+0x10b>
        s = (char*)*ap;
 4de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e1:	8b 00                	mov    (%eax),%eax
 4e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ee:	75 07                	jne    4f7 <printf+0xe1>
          s = "(null)";
 4f0:	c7 45 f4 36 0f 00 00 	movl   $0xf36,-0xc(%ebp)
        while(*s != 0){
 4f7:	eb 1c                	jmp    515 <printf+0xff>
          putc(fd, *s);
 4f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fc:	0f b6 00             	movzbl (%eax),%eax
 4ff:	0f be c0             	movsbl %al,%eax
 502:	83 ec 08             	sub    $0x8,%esp
 505:	50                   	push   %eax
 506:	ff 75 08             	pushl  0x8(%ebp)
 509:	e8 33 fe ff ff       	call   341 <putc>
 50e:	83 c4 10             	add    $0x10,%esp
          s++;
 511:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 515:	8b 45 f4             	mov    -0xc(%ebp),%eax
 518:	0f b6 00             	movzbl (%eax),%eax
 51b:	84 c0                	test   %al,%al
 51d:	75 da                	jne    4f9 <printf+0xe3>
 51f:	eb 65                	jmp    586 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 521:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 525:	75 1d                	jne    544 <printf+0x12e>
        putc(fd, *ap);
 527:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52a:	8b 00                	mov    (%eax),%eax
 52c:	0f be c0             	movsbl %al,%eax
 52f:	83 ec 08             	sub    $0x8,%esp
 532:	50                   	push   %eax
 533:	ff 75 08             	pushl  0x8(%ebp)
 536:	e8 06 fe ff ff       	call   341 <putc>
 53b:	83 c4 10             	add    $0x10,%esp
        ap++;
 53e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 542:	eb 42                	jmp    586 <printf+0x170>
      } else if(c == '%'){
 544:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 548:	75 17                	jne    561 <printf+0x14b>
        putc(fd, c);
 54a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54d:	0f be c0             	movsbl %al,%eax
 550:	83 ec 08             	sub    $0x8,%esp
 553:	50                   	push   %eax
 554:	ff 75 08             	pushl  0x8(%ebp)
 557:	e8 e5 fd ff ff       	call   341 <putc>
 55c:	83 c4 10             	add    $0x10,%esp
 55f:	eb 25                	jmp    586 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 561:	83 ec 08             	sub    $0x8,%esp
 564:	6a 25                	push   $0x25
 566:	ff 75 08             	pushl  0x8(%ebp)
 569:	e8 d3 fd ff ff       	call   341 <putc>
 56e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 574:	0f be c0             	movsbl %al,%eax
 577:	83 ec 08             	sub    $0x8,%esp
 57a:	50                   	push   %eax
 57b:	ff 75 08             	pushl  0x8(%ebp)
 57e:	e8 be fd ff ff       	call   341 <putc>
 583:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 58d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 591:	8b 55 0c             	mov    0xc(%ebp),%edx
 594:	8b 45 f0             	mov    -0x10(%ebp),%eax
 597:	01 d0                	add    %edx,%eax
 599:	0f b6 00             	movzbl (%eax),%eax
 59c:	84 c0                	test   %al,%al
 59e:	0f 85 94 fe ff ff    	jne    438 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5a4:	c9                   	leave  
 5a5:	c3                   	ret    

000005a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a6:	55                   	push   %ebp
 5a7:	89 e5                	mov    %esp,%ebp
 5a9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	83 e8 08             	sub    $0x8,%eax
 5b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b5:	a1 64 13 00 00       	mov    0x1364,%eax
 5ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5bd:	eb 24                	jmp    5e3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c2:	8b 00                	mov    (%eax),%eax
 5c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c7:	77 12                	ja     5db <free+0x35>
 5c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5cf:	77 24                	ja     5f5 <free+0x4f>
 5d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d4:	8b 00                	mov    (%eax),%eax
 5d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5d9:	77 1a                	ja     5f5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5de:	8b 00                	mov    (%eax),%eax
 5e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e9:	76 d4                	jbe    5bf <free+0x19>
 5eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f3:	76 ca                	jbe    5bf <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f8:	8b 40 04             	mov    0x4(%eax),%eax
 5fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 602:	8b 45 f8             	mov    -0x8(%ebp),%eax
 605:	01 c2                	add    %eax,%edx
 607:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	39 c2                	cmp    %eax,%edx
 60e:	75 24                	jne    634 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 610:	8b 45 f8             	mov    -0x8(%ebp),%eax
 613:	8b 50 04             	mov    0x4(%eax),%edx
 616:	8b 45 fc             	mov    -0x4(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	8b 40 04             	mov    0x4(%eax),%eax
 61e:	01 c2                	add    %eax,%edx
 620:	8b 45 f8             	mov    -0x8(%ebp),%eax
 623:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 626:	8b 45 fc             	mov    -0x4(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	8b 10                	mov    (%eax),%edx
 62d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 630:	89 10                	mov    %edx,(%eax)
 632:	eb 0a                	jmp    63e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 634:	8b 45 fc             	mov    -0x4(%ebp),%eax
 637:	8b 10                	mov    (%eax),%edx
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 40 04             	mov    0x4(%eax),%eax
 644:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64e:	01 d0                	add    %edx,%eax
 650:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 653:	75 20                	jne    675 <free+0xcf>
    p->s.size += bp->s.size;
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 50 04             	mov    0x4(%eax),%edx
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	01 c2                	add    %eax,%edx
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	8b 10                	mov    (%eax),%edx
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	89 10                	mov    %edx,(%eax)
 673:	eb 08                	jmp    67d <free+0xd7>
  } else
    p->s.ptr = bp;
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 55 f8             	mov    -0x8(%ebp),%edx
 67b:	89 10                	mov    %edx,(%eax)
  freep = p;
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	a3 64 13 00 00       	mov    %eax,0x1364
}
 685:	c9                   	leave  
 686:	c3                   	ret    

00000687 <morecore>:

static Header*
morecore(uint nu)
{
 687:	55                   	push   %ebp
 688:	89 e5                	mov    %esp,%ebp
 68a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 68d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 694:	77 07                	ja     69d <morecore+0x16>
    nu = 4096;
 696:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
 6a0:	c1 e0 03             	shl    $0x3,%eax
 6a3:	83 ec 0c             	sub    $0xc,%esp
 6a6:	50                   	push   %eax
 6a7:	e8 5d fc ff ff       	call   309 <sbrk>
 6ac:	83 c4 10             	add    $0x10,%esp
 6af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6b2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6b6:	75 07                	jne    6bf <morecore+0x38>
    return 0;
 6b8:	b8 00 00 00 00       	mov    $0x0,%eax
 6bd:	eb 26                	jmp    6e5 <morecore+0x5e>
  hp = (Header*)p;
 6bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c8:	8b 55 08             	mov    0x8(%ebp),%edx
 6cb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d1:	83 c0 08             	add    $0x8,%eax
 6d4:	83 ec 0c             	sub    $0xc,%esp
 6d7:	50                   	push   %eax
 6d8:	e8 c9 fe ff ff       	call   5a6 <free>
 6dd:	83 c4 10             	add    $0x10,%esp
  return freep;
 6e0:	a1 64 13 00 00       	mov    0x1364,%eax
}
 6e5:	c9                   	leave  
 6e6:	c3                   	ret    

000006e7 <malloc>:

void*
malloc(uint nbytes)
{
 6e7:	55                   	push   %ebp
 6e8:	89 e5                	mov    %esp,%ebp
 6ea:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ed:	8b 45 08             	mov    0x8(%ebp),%eax
 6f0:	83 c0 07             	add    $0x7,%eax
 6f3:	c1 e8 03             	shr    $0x3,%eax
 6f6:	83 c0 01             	add    $0x1,%eax
 6f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6fc:	a1 64 13 00 00       	mov    0x1364,%eax
 701:	89 45 f0             	mov    %eax,-0x10(%ebp)
 704:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 708:	75 23                	jne    72d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 70a:	c7 45 f0 5c 13 00 00 	movl   $0x135c,-0x10(%ebp)
 711:	8b 45 f0             	mov    -0x10(%ebp),%eax
 714:	a3 64 13 00 00       	mov    %eax,0x1364
 719:	a1 64 13 00 00       	mov    0x1364,%eax
 71e:	a3 5c 13 00 00       	mov    %eax,0x135c
    base.s.size = 0;
 723:	c7 05 60 13 00 00 00 	movl   $0x0,0x1360
 72a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 735:	8b 45 f4             	mov    -0xc(%ebp),%eax
 738:	8b 40 04             	mov    0x4(%eax),%eax
 73b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 73e:	72 4d                	jb     78d <malloc+0xa6>
      if(p->s.size == nunits)
 740:	8b 45 f4             	mov    -0xc(%ebp),%eax
 743:	8b 40 04             	mov    0x4(%eax),%eax
 746:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 749:	75 0c                	jne    757 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 74b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74e:	8b 10                	mov    (%eax),%edx
 750:	8b 45 f0             	mov    -0x10(%ebp),%eax
 753:	89 10                	mov    %edx,(%eax)
 755:	eb 26                	jmp    77d <malloc+0x96>
      else {
        p->s.size -= nunits;
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	8b 40 04             	mov    0x4(%eax),%eax
 75d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 760:	89 c2                	mov    %eax,%edx
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	c1 e0 03             	shl    $0x3,%eax
 771:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	8b 55 ec             	mov    -0x14(%ebp),%edx
 77a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	a3 64 13 00 00       	mov    %eax,0x1364
      return (void*)(p + 1);
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	83 c0 08             	add    $0x8,%eax
 78b:	eb 3b                	jmp    7c8 <malloc+0xe1>
    }
    if(p == freep)
 78d:	a1 64 13 00 00       	mov    0x1364,%eax
 792:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 795:	75 1e                	jne    7b5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 797:	83 ec 0c             	sub    $0xc,%esp
 79a:	ff 75 ec             	pushl  -0x14(%ebp)
 79d:	e8 e5 fe ff ff       	call   687 <morecore>
 7a2:	83 c4 10             	add    $0x10,%esp
 7a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ac:	75 07                	jne    7b5 <malloc+0xce>
        return 0;
 7ae:	b8 00 00 00 00       	mov    $0x0,%eax
 7b3:	eb 13                	jmp    7c8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	8b 00                	mov    (%eax),%eax
 7c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7c3:	e9 6d ff ff ff       	jmp    735 <malloc+0x4e>
}
 7c8:	c9                   	leave  
 7c9:	c3                   	ret    

000007ca <isspace>:

#include "common.h"

int isspace(char c) {
 7ca:	55                   	push   %ebp
 7cb:	89 e5                	mov    %esp,%ebp
 7cd:	83 ec 04             	sub    $0x4,%esp
 7d0:	8b 45 08             	mov    0x8(%ebp),%eax
 7d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 7d6:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 7da:	74 12                	je     7ee <isspace+0x24>
 7dc:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 7e0:	74 0c                	je     7ee <isspace+0x24>
 7e2:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 7e6:	74 06                	je     7ee <isspace+0x24>
 7e8:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 7ec:	75 07                	jne    7f5 <isspace+0x2b>
 7ee:	b8 01 00 00 00       	mov    $0x1,%eax
 7f3:	eb 05                	jmp    7fa <isspace+0x30>
 7f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 7fa:	c9                   	leave  
 7fb:	c3                   	ret    

000007fc <readln>:

char* readln(char *buf, int max, int fd)
{
 7fc:	55                   	push   %ebp
 7fd:	89 e5                	mov    %esp,%ebp
 7ff:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 802:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 809:	eb 45                	jmp    850 <readln+0x54>
    cc = read(fd, &c, 1);
 80b:	83 ec 04             	sub    $0x4,%esp
 80e:	6a 01                	push   $0x1
 810:	8d 45 ef             	lea    -0x11(%ebp),%eax
 813:	50                   	push   %eax
 814:	ff 75 10             	pushl  0x10(%ebp)
 817:	e8 7d fa ff ff       	call   299 <read>
 81c:	83 c4 10             	add    $0x10,%esp
 81f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 822:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 826:	7f 02                	jg     82a <readln+0x2e>
      break;
 828:	eb 31                	jmp    85b <readln+0x5f>
    buf[i++] = c;
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8d 50 01             	lea    0x1(%eax),%edx
 830:	89 55 f4             	mov    %edx,-0xc(%ebp)
 833:	89 c2                	mov    %eax,%edx
 835:	8b 45 08             	mov    0x8(%ebp),%eax
 838:	01 c2                	add    %eax,%edx
 83a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 83e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 840:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 844:	3c 0a                	cmp    $0xa,%al
 846:	74 13                	je     85b <readln+0x5f>
 848:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 84c:	3c 0d                	cmp    $0xd,%al
 84e:	74 0b                	je     85b <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	83 c0 01             	add    $0x1,%eax
 856:	3b 45 0c             	cmp    0xc(%ebp),%eax
 859:	7c b0                	jl     80b <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 85b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 85e:	8b 45 08             	mov    0x8(%ebp),%eax
 861:	01 d0                	add    %edx,%eax
 863:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 866:	8b 45 08             	mov    0x8(%ebp),%eax
}
 869:	c9                   	leave  
 86a:	c3                   	ret    

0000086b <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 86b:	55                   	push   %ebp
 86c:	89 e5                	mov    %esp,%ebp
 86e:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 871:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 878:	eb 19                	jmp    893 <strncpy+0x28>
		dest[i] = src[i];
 87a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
 880:	01 c2                	add    %eax,%edx
 882:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 885:	8b 45 0c             	mov    0xc(%ebp),%eax
 888:	01 c8                	add    %ecx,%eax
 88a:	0f b6 00             	movzbl (%eax),%eax
 88d:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 88f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 893:	8b 45 fc             	mov    -0x4(%ebp),%eax
 896:	3b 45 10             	cmp    0x10(%ebp),%eax
 899:	7d 0f                	jge    8aa <strncpy+0x3f>
 89b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 89e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a1:	01 d0                	add    %edx,%eax
 8a3:	0f b6 00             	movzbl (%eax),%eax
 8a6:	84 c0                	test   %al,%al
 8a8:	75 d0                	jne    87a <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 8aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8ad:	c9                   	leave  
 8ae:	c3                   	ret    

000008af <trim>:

char* trim(char* orig) {
 8af:	55                   	push   %ebp
 8b0:	89 e5                	mov    %esp,%ebp
 8b2:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 8b5:	8b 45 08             	mov    0x8(%ebp),%eax
 8b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 8bb:	8b 45 08             	mov    0x8(%ebp),%eax
 8be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 8c1:	eb 04                	jmp    8c7 <trim+0x18>
 8c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	0f b6 00             	movzbl (%eax),%eax
 8cd:	0f be c0             	movsbl %al,%eax
 8d0:	50                   	push   %eax
 8d1:	e8 f4 fe ff ff       	call   7ca <isspace>
 8d6:	83 c4 04             	add    $0x4,%esp
 8d9:	85 c0                	test   %eax,%eax
 8db:	75 e6                	jne    8c3 <trim+0x14>
	while (*tail) { tail++; }
 8dd:	eb 04                	jmp    8e3 <trim+0x34>
 8df:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e6:	0f b6 00             	movzbl (%eax),%eax
 8e9:	84 c0                	test   %al,%al
 8eb:	75 f2                	jne    8df <trim+0x30>
	do { tail--; } while (isspace(*tail));
 8ed:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 8f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f4:	0f b6 00             	movzbl (%eax),%eax
 8f7:	0f be c0             	movsbl %al,%eax
 8fa:	50                   	push   %eax
 8fb:	e8 ca fe ff ff       	call   7ca <isspace>
 900:	83 c4 04             	add    $0x4,%esp
 903:	85 c0                	test   %eax,%eax
 905:	75 e6                	jne    8ed <trim+0x3e>
	new = malloc(tail-head+2);
 907:	8b 55 f0             	mov    -0x10(%ebp),%edx
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	29 c2                	sub    %eax,%edx
 90f:	89 d0                	mov    %edx,%eax
 911:	83 c0 02             	add    $0x2,%eax
 914:	83 ec 0c             	sub    $0xc,%esp
 917:	50                   	push   %eax
 918:	e8 ca fd ff ff       	call   6e7 <malloc>
 91d:	83 c4 10             	add    $0x10,%esp
 920:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 923:	8b 55 f0             	mov    -0x10(%ebp),%edx
 926:	8b 45 f4             	mov    -0xc(%ebp),%eax
 929:	29 c2                	sub    %eax,%edx
 92b:	89 d0                	mov    %edx,%eax
 92d:	83 c0 01             	add    $0x1,%eax
 930:	83 ec 04             	sub    $0x4,%esp
 933:	50                   	push   %eax
 934:	ff 75 f4             	pushl  -0xc(%ebp)
 937:	ff 75 ec             	pushl  -0x14(%ebp)
 93a:	e8 2c ff ff ff       	call   86b <strncpy>
 93f:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 942:	8b 55 f0             	mov    -0x10(%ebp),%edx
 945:	8b 45 f4             	mov    -0xc(%ebp),%eax
 948:	29 c2                	sub    %eax,%edx
 94a:	89 d0                	mov    %edx,%eax
 94c:	8d 50 01             	lea    0x1(%eax),%edx
 94f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 952:	01 d0                	add    %edx,%eax
 954:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 957:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 95a:	c9                   	leave  
 95b:	c3                   	ret    

0000095c <itoa>:

char *
itoa(int value)
{
 95c:	55                   	push   %ebp
 95d:	89 e5                	mov    %esp,%ebp
 95f:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 962:	8d 45 bf             	lea    -0x41(%ebp),%eax
 965:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 968:	8b 45 08             	mov    0x8(%ebp),%eax
 96b:	c1 e8 1f             	shr    $0x1f,%eax
 96e:	0f b6 c0             	movzbl %al,%eax
 971:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 974:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 978:	74 0a                	je     984 <itoa+0x28>
    v = -value;
 97a:	8b 45 08             	mov    0x8(%ebp),%eax
 97d:	f7 d8                	neg    %eax
 97f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 982:	eb 06                	jmp    98a <itoa+0x2e>
  else
    v = (uint)value;
 984:	8b 45 08             	mov    0x8(%ebp),%eax
 987:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 98a:	eb 5b                	jmp    9e7 <itoa+0x8b>
  {
    i = v % 10;
 98c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 98f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 994:	89 c8                	mov    %ecx,%eax
 996:	f7 e2                	mul    %edx
 998:	c1 ea 03             	shr    $0x3,%edx
 99b:	89 d0                	mov    %edx,%eax
 99d:	c1 e0 02             	shl    $0x2,%eax
 9a0:	01 d0                	add    %edx,%eax
 9a2:	01 c0                	add    %eax,%eax
 9a4:	29 c1                	sub    %eax,%ecx
 9a6:	89 ca                	mov    %ecx,%edx
 9a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 9ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ae:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9b3:	f7 e2                	mul    %edx
 9b5:	89 d0                	mov    %edx,%eax
 9b7:	c1 e8 03             	shr    $0x3,%eax
 9ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 9bd:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 9c1:	7f 13                	jg     9d6 <itoa+0x7a>
      *tp++ = i+'0';
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	8d 50 01             	lea    0x1(%eax),%edx
 9c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9cf:	83 c2 30             	add    $0x30,%edx
 9d2:	88 10                	mov    %dl,(%eax)
 9d4:	eb 11                	jmp    9e7 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 9d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d9:	8d 50 01             	lea    0x1(%eax),%edx
 9dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9e2:	83 c2 57             	add    $0x57,%edx
 9e5:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 9e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9eb:	75 9f                	jne    98c <itoa+0x30>
 9ed:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9f3:	74 97                	je     98c <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 9f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9f8:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9fb:	29 c2                	sub    %eax,%edx
 9fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a00:	01 d0                	add    %edx,%eax
 a02:	83 c0 01             	add    $0x1,%eax
 a05:	83 ec 0c             	sub    $0xc,%esp
 a08:	50                   	push   %eax
 a09:	e8 d9 fc ff ff       	call   6e7 <malloc>
 a0e:	83 c4 10             	add    $0x10,%esp
 a11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a17:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a1e:	74 0c                	je     a2c <itoa+0xd0>
    *sp++ = '-';
 a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a23:	8d 50 01             	lea    0x1(%eax),%edx
 a26:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a29:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a2c:	eb 15                	jmp    a43 <itoa+0xe7>
    *sp++ = *--tp;
 a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a31:	8d 50 01             	lea    0x1(%eax),%edx
 a34:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a37:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a3e:	0f b6 12             	movzbl (%edx),%edx
 a41:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 a43:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a46:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a49:	77 e3                	ja     a2e <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a4e:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 a54:	c9                   	leave  
 a55:	c3                   	ret    

00000a56 <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 a56:	55                   	push   %ebp
 a57:	89 e5                	mov    %esp,%ebp
 a59:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 a5f:	83 ec 08             	sub    $0x8,%esp
 a62:	6a 00                	push   $0x0
 a64:	ff 75 08             	pushl  0x8(%ebp)
 a67:	e8 55 f8 ff ff       	call   2c1 <open>
 a6c:	83 c4 10             	add    $0x10,%esp
 a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 a72:	e9 22 01 00 00       	jmp    b99 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 a77:	83 ec 08             	sub    $0x8,%esp
 a7a:	6a 3d                	push   $0x3d
 a7c:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 a82:	50                   	push   %eax
 a83:	e8 79 f6 ff ff       	call   101 <strchr>
 a88:	83 c4 10             	add    $0x10,%esp
 a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 a8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a92:	0f 84 23 01 00 00    	je     bbb <parseEnvFile+0x165>
 a98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a9c:	0f 84 19 01 00 00    	je     bbb <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 aa2:	8b 55 f0             	mov    -0x10(%ebp),%edx
 aa5:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 aab:	29 c2                	sub    %eax,%edx
 aad:	89 d0                	mov    %edx,%eax
 aaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ab5:	83 c0 01             	add    $0x1,%eax
 ab8:	83 ec 0c             	sub    $0xc,%esp
 abb:	50                   	push   %eax
 abc:	e8 26 fc ff ff       	call   6e7 <malloc>
 ac1:	83 c4 10             	add    $0x10,%esp
 ac4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 ac7:	83 ec 04             	sub    $0x4,%esp
 aca:	ff 75 ec             	pushl  -0x14(%ebp)
 acd:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ad3:	50                   	push   %eax
 ad4:	ff 75 e8             	pushl  -0x18(%ebp)
 ad7:	e8 8f fd ff ff       	call   86b <strncpy>
 adc:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 adf:	83 ec 0c             	sub    $0xc,%esp
 ae2:	ff 75 e8             	pushl  -0x18(%ebp)
 ae5:	e8 c5 fd ff ff       	call   8af <trim>
 aea:	83 c4 10             	add    $0x10,%esp
 aed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 af0:	83 ec 0c             	sub    $0xc,%esp
 af3:	ff 75 e8             	pushl  -0x18(%ebp)
 af6:	e8 ab fa ff ff       	call   5a6 <free>
 afb:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 afe:	83 ec 08             	sub    $0x8,%esp
 b01:	ff 75 0c             	pushl  0xc(%ebp)
 b04:	ff 75 e4             	pushl  -0x1c(%ebp)
 b07:	e8 c2 01 00 00       	call   cce <addToEnvironment>
 b0c:	83 c4 10             	add    $0x10,%esp
 b0f:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b12:	83 ec 0c             	sub    $0xc,%esp
 b15:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b1b:	50                   	push   %eax
 b1c:	e8 9f f5 ff ff       	call   c0 <strlen>
 b21:	83 c4 10             	add    $0x10,%esp
 b24:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b2a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b2d:	83 ec 0c             	sub    $0xc,%esp
 b30:	50                   	push   %eax
 b31:	e8 b1 fb ff ff       	call   6e7 <malloc>
 b36:	83 c4 10             	add    $0x10,%esp
 b39:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b3f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b42:	8d 50 ff             	lea    -0x1(%eax),%edx
 b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b48:	8d 48 01             	lea    0x1(%eax),%ecx
 b4b:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b51:	01 c8                	add    %ecx,%eax
 b53:	83 ec 04             	sub    $0x4,%esp
 b56:	52                   	push   %edx
 b57:	50                   	push   %eax
 b58:	ff 75 e8             	pushl  -0x18(%ebp)
 b5b:	e8 0b fd ff ff       	call   86b <strncpy>
 b60:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 b63:	83 ec 0c             	sub    $0xc,%esp
 b66:	ff 75 e8             	pushl  -0x18(%ebp)
 b69:	e8 41 fd ff ff       	call   8af <trim>
 b6e:	83 c4 10             	add    $0x10,%esp
 b71:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 b74:	83 ec 0c             	sub    $0xc,%esp
 b77:	ff 75 e8             	pushl  -0x18(%ebp)
 b7a:	e8 27 fa ff ff       	call   5a6 <free>
 b7f:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 b82:	83 ec 04             	sub    $0x4,%esp
 b85:	ff 75 dc             	pushl  -0x24(%ebp)
 b88:	ff 75 0c             	pushl  0xc(%ebp)
 b8b:	ff 75 e4             	pushl  -0x1c(%ebp)
 b8e:	e8 b8 01 00 00       	call   d4b <addValueToVariable>
 b93:	83 c4 10             	add    $0x10,%esp
 b96:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 b99:	83 ec 04             	sub    $0x4,%esp
 b9c:	ff 75 f4             	pushl  -0xc(%ebp)
 b9f:	68 00 04 00 00       	push   $0x400
 ba4:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 baa:	50                   	push   %eax
 bab:	e8 4c fc ff ff       	call   7fc <readln>
 bb0:	83 c4 10             	add    $0x10,%esp
 bb3:	85 c0                	test   %eax,%eax
 bb5:	0f 85 bc fe ff ff    	jne    a77 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 bbb:	83 ec 0c             	sub    $0xc,%esp
 bbe:	ff 75 f4             	pushl  -0xc(%ebp)
 bc1:	e8 e3 f6 ff ff       	call   2a9 <close>
 bc6:	83 c4 10             	add    $0x10,%esp
	return head;
 bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 bcc:	c9                   	leave  
 bcd:	c3                   	ret    

00000bce <comp>:

int comp(const char* s1, const char* s2)
{
 bce:	55                   	push   %ebp
 bcf:	89 e5                	mov    %esp,%ebp
 bd1:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 bd4:	83 ec 08             	sub    $0x8,%esp
 bd7:	ff 75 0c             	pushl  0xc(%ebp)
 bda:	ff 75 08             	pushl  0x8(%ebp)
 bdd:	e8 9f f4 ff ff       	call   81 <strcmp>
 be2:	83 c4 10             	add    $0x10,%esp
 be5:	85 c0                	test   %eax,%eax
 be7:	0f 94 c0             	sete   %al
 bea:	0f b6 c0             	movzbl %al,%eax
}
 bed:	c9                   	leave  
 bee:	c3                   	ret    

00000bef <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 bef:	55                   	push   %ebp
 bf0:	89 e5                	mov    %esp,%ebp
 bf2:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 bf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 bf9:	75 07                	jne    c02 <environLookup+0x13>
    return NULL;
 bfb:	b8 00 00 00 00       	mov    $0x0,%eax
 c00:	eb 2f                	jmp    c31 <environLookup+0x42>
  
  while (head)
 c02:	eb 24                	jmp    c28 <environLookup+0x39>
  {
    if (comp(name, head->name))
 c04:	8b 45 0c             	mov    0xc(%ebp),%eax
 c07:	83 ec 08             	sub    $0x8,%esp
 c0a:	50                   	push   %eax
 c0b:	ff 75 08             	pushl  0x8(%ebp)
 c0e:	e8 bb ff ff ff       	call   bce <comp>
 c13:	83 c4 10             	add    $0x10,%esp
 c16:	85 c0                	test   %eax,%eax
 c18:	74 02                	je     c1c <environLookup+0x2d>
      break;
 c1a:	eb 12                	jmp    c2e <environLookup+0x3f>
    head = head->next;
 c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
 c1f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c25:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c2c:	75 d6                	jne    c04 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c31:	c9                   	leave  
 c32:	c3                   	ret    

00000c33 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c33:	55                   	push   %ebp
 c34:	89 e5                	mov    %esp,%ebp
 c36:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c3d:	75 0a                	jne    c49 <removeFromEnvironment+0x16>
    return NULL;
 c3f:	b8 00 00 00 00       	mov    $0x0,%eax
 c44:	e9 83 00 00 00       	jmp    ccc <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 c49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c4d:	74 0a                	je     c59 <removeFromEnvironment+0x26>
 c4f:	8b 45 08             	mov    0x8(%ebp),%eax
 c52:	0f b6 00             	movzbl (%eax),%eax
 c55:	84 c0                	test   %al,%al
 c57:	75 05                	jne    c5e <removeFromEnvironment+0x2b>
    return head;
 c59:	8b 45 0c             	mov    0xc(%ebp),%eax
 c5c:	eb 6e                	jmp    ccc <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
 c61:	83 ec 08             	sub    $0x8,%esp
 c64:	ff 75 08             	pushl  0x8(%ebp)
 c67:	50                   	push   %eax
 c68:	e8 61 ff ff ff       	call   bce <comp>
 c6d:	83 c4 10             	add    $0x10,%esp
 c70:	85 c0                	test   %eax,%eax
 c72:	74 34                	je     ca8 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 c74:	8b 45 0c             	mov    0xc(%ebp),%eax
 c77:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 c80:	8b 45 0c             	mov    0xc(%ebp),%eax
 c83:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 c89:	83 ec 0c             	sub    $0xc,%esp
 c8c:	50                   	push   %eax
 c8d:	e8 74 01 00 00       	call   e06 <freeVarval>
 c92:	83 c4 10             	add    $0x10,%esp
    free(head);
 c95:	83 ec 0c             	sub    $0xc,%esp
 c98:	ff 75 0c             	pushl  0xc(%ebp)
 c9b:	e8 06 f9 ff ff       	call   5a6 <free>
 ca0:	83 c4 10             	add    $0x10,%esp
    return tmp;
 ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca6:	eb 24                	jmp    ccc <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
 cab:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cb1:	83 ec 08             	sub    $0x8,%esp
 cb4:	50                   	push   %eax
 cb5:	ff 75 08             	pushl  0x8(%ebp)
 cb8:	e8 76 ff ff ff       	call   c33 <removeFromEnvironment>
 cbd:	83 c4 10             	add    $0x10,%esp
 cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
 cc3:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 ccc:	c9                   	leave  
 ccd:	c3                   	ret    

00000cce <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 cce:	55                   	push   %ebp
 ccf:	89 e5                	mov    %esp,%ebp
 cd1:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 cd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 cd8:	75 05                	jne    cdf <addToEnvironment+0x11>
		return head;
 cda:	8b 45 0c             	mov    0xc(%ebp),%eax
 cdd:	eb 6a                	jmp    d49 <addToEnvironment+0x7b>
	if (head == NULL) {
 cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 ce3:	75 40                	jne    d25 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 ce5:	83 ec 0c             	sub    $0xc,%esp
 ce8:	68 88 00 00 00       	push   $0x88
 ced:	e8 f5 f9 ff ff       	call   6e7 <malloc>
 cf2:	83 c4 10             	add    $0x10,%esp
 cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 cf8:	8b 45 08             	mov    0x8(%ebp),%eax
 cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d01:	83 ec 08             	sub    $0x8,%esp
 d04:	ff 75 f0             	pushl  -0x10(%ebp)
 d07:	50                   	push   %eax
 d08:	e8 44 f3 ff ff       	call   51 <strcpy>
 d0d:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d13:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d1a:	00 00 00 
		head = newVar;
 d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d20:	89 45 0c             	mov    %eax,0xc(%ebp)
 d23:	eb 21                	jmp    d46 <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d25:	8b 45 0c             	mov    0xc(%ebp),%eax
 d28:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d2e:	83 ec 08             	sub    $0x8,%esp
 d31:	50                   	push   %eax
 d32:	ff 75 08             	pushl  0x8(%ebp)
 d35:	e8 94 ff ff ff       	call   cce <addToEnvironment>
 d3a:	83 c4 10             	add    $0x10,%esp
 d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
 d40:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 d46:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d49:	c9                   	leave  
 d4a:	c3                   	ret    

00000d4b <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 d4b:	55                   	push   %ebp
 d4c:	89 e5                	mov    %esp,%ebp
 d4e:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 d51:	83 ec 08             	sub    $0x8,%esp
 d54:	ff 75 0c             	pushl  0xc(%ebp)
 d57:	ff 75 08             	pushl  0x8(%ebp)
 d5a:	e8 90 fe ff ff       	call   bef <environLookup>
 d5f:	83 c4 10             	add    $0x10,%esp
 d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 d65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d69:	75 05                	jne    d70 <addValueToVariable+0x25>
		return head;
 d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
 d6e:	eb 4c                	jmp    dbc <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 d70:	83 ec 0c             	sub    $0xc,%esp
 d73:	68 04 04 00 00       	push   $0x404
 d78:	e8 6a f9 ff ff       	call   6e7 <malloc>
 d7d:	83 c4 10             	add    $0x10,%esp
 d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 d83:	8b 45 10             	mov    0x10(%ebp),%eax
 d86:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d8c:	83 ec 08             	sub    $0x8,%esp
 d8f:	ff 75 ec             	pushl  -0x14(%ebp)
 d92:	50                   	push   %eax
 d93:	e8 b9 f2 ff ff       	call   51 <strcpy>
 d98:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d9e:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 da7:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 db0:	8b 55 f0             	mov    -0x10(%ebp),%edx
 db3:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 db9:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 dbc:	c9                   	leave  
 dbd:	c3                   	ret    

00000dbe <freeEnvironment>:

void freeEnvironment(variable* head)
{
 dbe:	55                   	push   %ebp
 dbf:	89 e5                	mov    %esp,%ebp
 dc1:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 dc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 dc8:	75 02                	jne    dcc <freeEnvironment+0xe>
    return;  
 dca:	eb 38                	jmp    e04 <freeEnvironment+0x46>
  freeEnvironment(head->next);
 dcc:	8b 45 08             	mov    0x8(%ebp),%eax
 dcf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 dd5:	83 ec 0c             	sub    $0xc,%esp
 dd8:	50                   	push   %eax
 dd9:	e8 e0 ff ff ff       	call   dbe <freeEnvironment>
 dde:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 de1:	8b 45 08             	mov    0x8(%ebp),%eax
 de4:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 dea:	83 ec 0c             	sub    $0xc,%esp
 ded:	50                   	push   %eax
 dee:	e8 13 00 00 00       	call   e06 <freeVarval>
 df3:	83 c4 10             	add    $0x10,%esp
  free(head);
 df6:	83 ec 0c             	sub    $0xc,%esp
 df9:	ff 75 08             	pushl  0x8(%ebp)
 dfc:	e8 a5 f7 ff ff       	call   5a6 <free>
 e01:	83 c4 10             	add    $0x10,%esp
}
 e04:	c9                   	leave  
 e05:	c3                   	ret    

00000e06 <freeVarval>:

void freeVarval(varval* head)
{
 e06:	55                   	push   %ebp
 e07:	89 e5                	mov    %esp,%ebp
 e09:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e10:	75 02                	jne    e14 <freeVarval+0xe>
    return;  
 e12:	eb 23                	jmp    e37 <freeVarval+0x31>
  freeVarval(head->next);
 e14:	8b 45 08             	mov    0x8(%ebp),%eax
 e17:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e1d:	83 ec 0c             	sub    $0xc,%esp
 e20:	50                   	push   %eax
 e21:	e8 e0 ff ff ff       	call   e06 <freeVarval>
 e26:	83 c4 10             	add    $0x10,%esp
  free(head);
 e29:	83 ec 0c             	sub    $0xc,%esp
 e2c:	ff 75 08             	pushl  0x8(%ebp)
 e2f:	e8 72 f7 ff ff       	call   5a6 <free>
 e34:	83 c4 10             	add    $0x10,%esp
}
 e37:	c9                   	leave  
 e38:	c3                   	ret    

00000e39 <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e39:	55                   	push   %ebp
 e3a:	89 e5                	mov    %esp,%ebp
 e3c:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 e3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e43:	75 08                	jne    e4d <getPaths+0x14>
		return head;
 e45:	8b 45 0c             	mov    0xc(%ebp),%eax
 e48:	e9 e7 00 00 00       	jmp    f34 <getPaths+0xfb>
	if (head == NULL) {
 e4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 e51:	0f 85 b9 00 00 00    	jne    f10 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 e57:	83 ec 08             	sub    $0x8,%esp
 e5a:	6a 3a                	push   $0x3a
 e5c:	ff 75 08             	pushl  0x8(%ebp)
 e5f:	e8 9d f2 ff ff       	call   101 <strchr>
 e64:	83 c4 10             	add    $0x10,%esp
 e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 e6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e6e:	75 56                	jne    ec6 <getPaths+0x8d>
			pathLen = strlen(paths);
 e70:	83 ec 0c             	sub    $0xc,%esp
 e73:	ff 75 08             	pushl  0x8(%ebp)
 e76:	e8 45 f2 ff ff       	call   c0 <strlen>
 e7b:	83 c4 10             	add    $0x10,%esp
 e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 e81:	83 ec 0c             	sub    $0xc,%esp
 e84:	68 04 04 00 00       	push   $0x404
 e89:	e8 59 f8 ff ff       	call   6e7 <malloc>
 e8e:	83 c4 10             	add    $0x10,%esp
 e91:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 e94:	8b 45 0c             	mov    0xc(%ebp),%eax
 e97:	83 ec 04             	sub    $0x4,%esp
 e9a:	ff 75 f0             	pushl  -0x10(%ebp)
 e9d:	ff 75 08             	pushl  0x8(%ebp)
 ea0:	50                   	push   %eax
 ea1:	e8 c5 f9 ff ff       	call   86b <strncpy>
 ea6:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
 eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 eaf:	01 d0                	add    %edx,%eax
 eb1:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
 eb7:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 ebe:	00 00 00 
			return head;
 ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
 ec4:	eb 6e                	jmp    f34 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ec9:	8b 45 08             	mov    0x8(%ebp),%eax
 ecc:	29 c2                	sub    %eax,%edx
 ece:	89 d0                	mov    %edx,%eax
 ed0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 ed3:	83 ec 0c             	sub    $0xc,%esp
 ed6:	68 04 04 00 00       	push   $0x404
 edb:	e8 07 f8 ff ff       	call   6e7 <malloc>
 ee0:	83 c4 10             	add    $0x10,%esp
 ee3:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
 ee9:	83 ec 04             	sub    $0x4,%esp
 eec:	ff 75 f0             	pushl  -0x10(%ebp)
 eef:	ff 75 08             	pushl  0x8(%ebp)
 ef2:	50                   	push   %eax
 ef3:	e8 73 f9 ff ff       	call   86b <strncpy>
 ef8:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 efb:	8b 55 0c             	mov    0xc(%ebp),%edx
 efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f01:	01 d0                	add    %edx,%eax
 f03:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f09:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 f0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f10:	8b 45 0c             	mov    0xc(%ebp),%eax
 f13:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f19:	83 ec 08             	sub    $0x8,%esp
 f1c:	50                   	push   %eax
 f1d:	ff 75 08             	pushl  0x8(%ebp)
 f20:	e8 14 ff ff ff       	call   e39 <getPaths>
 f25:	83 c4 10             	add    $0x10,%esp
 f28:	8b 55 0c             	mov    0xc(%ebp),%edx
 f2b:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f31:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f34:	c9                   	leave  
 f35:	c3                   	ret    
