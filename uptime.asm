
_uptime:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp

printf(1, "uptime: %d seconds\n", (uptime()/100));
  11:	e8 1c 03 00 00       	call   332 <uptime>
  16:	89 c1                	mov    %eax,%ecx
  18:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  1d:	89 c8                	mov    %ecx,%eax
  1f:	f7 ea                	imul   %edx
  21:	c1 fa 05             	sar    $0x5,%edx
  24:	89 c8                	mov    %ecx,%eax
  26:	c1 f8 1f             	sar    $0x1f,%eax
  29:	29 c2                	sub    %eax,%edx
  2b:	89 d0                	mov    %edx,%eax
  2d:	83 ec 04             	sub    $0x4,%esp
  30:	50                   	push   %eax
  31:	68 4f 0f 00 00       	push   $0xf4f
  36:	6a 01                	push   $0x1
  38:	e8 f2 03 00 00       	call   42f <printf>
  3d:	83 c4 10             	add    $0x10,%esp

exit();
  40:	e8 55 02 00 00       	call   29a <exit>

00000045 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  45:	55                   	push   %ebp
  46:	89 e5                	mov    %esp,%ebp
  48:	57                   	push   %edi
  49:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4d:	8b 55 10             	mov    0x10(%ebp),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	89 cb                	mov    %ecx,%ebx
  55:	89 df                	mov    %ebx,%edi
  57:	89 d1                	mov    %edx,%ecx
  59:	fc                   	cld    
  5a:	f3 aa                	rep stos %al,%es:(%edi)
  5c:	89 ca                	mov    %ecx,%edx
  5e:	89 fb                	mov    %edi,%ebx
  60:	89 5d 08             	mov    %ebx,0x8(%ebp)
  63:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  66:	5b                   	pop    %ebx
  67:	5f                   	pop    %edi
  68:	5d                   	pop    %ebp
  69:	c3                   	ret    

0000006a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  6a:	55                   	push   %ebp
  6b:	89 e5                	mov    %esp,%ebp
  6d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  70:	8b 45 08             	mov    0x8(%ebp),%eax
  73:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  76:	90                   	nop
  77:	8b 45 08             	mov    0x8(%ebp),%eax
  7a:	8d 50 01             	lea    0x1(%eax),%edx
  7d:	89 55 08             	mov    %edx,0x8(%ebp)
  80:	8b 55 0c             	mov    0xc(%ebp),%edx
  83:	8d 4a 01             	lea    0x1(%edx),%ecx
  86:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  89:	0f b6 12             	movzbl (%edx),%edx
  8c:	88 10                	mov    %dl,(%eax)
  8e:	0f b6 00             	movzbl (%eax),%eax
  91:	84 c0                	test   %al,%al
  93:	75 e2                	jne    77 <strcpy+0xd>
    ;
  return os;
  95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  98:	c9                   	leave  
  99:	c3                   	ret    

0000009a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  9d:	eb 08                	jmp    a7 <strcmp+0xd>
    p++, q++;
  9f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	0f b6 00             	movzbl (%eax),%eax
  ad:	84 c0                	test   %al,%al
  af:	74 10                	je     c1 <strcmp+0x27>
  b1:	8b 45 08             	mov    0x8(%ebp),%eax
  b4:	0f b6 10             	movzbl (%eax),%edx
  b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ba:	0f b6 00             	movzbl (%eax),%eax
  bd:	38 c2                	cmp    %al,%dl
  bf:	74 de                	je     9f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	0f b6 00             	movzbl (%eax),%eax
  c7:	0f b6 d0             	movzbl %al,%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	0f b6 00             	movzbl (%eax),%eax
  d0:	0f b6 c0             	movzbl %al,%eax
  d3:	29 c2                	sub    %eax,%edx
  d5:	89 d0                	mov    %edx,%eax
}
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret    

000000d9 <strlen>:

uint
strlen(char *s)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  dc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e6:	eb 04                	jmp    ec <strlen+0x13>
  e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	01 d0                	add    %edx,%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	84 c0                	test   %al,%al
  f9:	75 ed                	jne    e8 <strlen+0xf>
    ;
  return n;
  fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fe:	c9                   	leave  
  ff:	c3                   	ret    

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 103:	8b 45 10             	mov    0x10(%ebp),%eax
 106:	50                   	push   %eax
 107:	ff 75 0c             	pushl  0xc(%ebp)
 10a:	ff 75 08             	pushl  0x8(%ebp)
 10d:	e8 33 ff ff ff       	call   45 <stosb>
 112:	83 c4 0c             	add    $0xc,%esp
  return dst;
 115:	8b 45 08             	mov    0x8(%ebp),%eax
}
 118:	c9                   	leave  
 119:	c3                   	ret    

0000011a <strchr>:

char*
strchr(const char *s, char c)
{
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	83 ec 04             	sub    $0x4,%esp
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 126:	eb 14                	jmp    13c <strchr+0x22>
    if(*s == c)
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 131:	75 05                	jne    138 <strchr+0x1e>
      return (char*)s;
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	eb 13                	jmp    14b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 138:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	84 c0                	test   %al,%al
 144:	75 e2                	jne    128 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 146:	b8 00 00 00 00       	mov    $0x0,%eax
}
 14b:	c9                   	leave  
 14c:	c3                   	ret    

0000014d <gets>:

char*
gets(char *buf, int max)
{
 14d:	55                   	push   %ebp
 14e:	89 e5                	mov    %esp,%ebp
 150:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 153:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 15a:	eb 44                	jmp    1a0 <gets+0x53>
    cc = read(0, &c, 1);
 15c:	83 ec 04             	sub    $0x4,%esp
 15f:	6a 01                	push   $0x1
 161:	8d 45 ef             	lea    -0x11(%ebp),%eax
 164:	50                   	push   %eax
 165:	6a 00                	push   $0x0
 167:	e8 46 01 00 00       	call   2b2 <read>
 16c:	83 c4 10             	add    $0x10,%esp
 16f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 172:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 176:	7f 02                	jg     17a <gets+0x2d>
      break;
 178:	eb 31                	jmp    1ab <gets+0x5e>
    buf[i++] = c;
 17a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17d:	8d 50 01             	lea    0x1(%eax),%edx
 180:	89 55 f4             	mov    %edx,-0xc(%ebp)
 183:	89 c2                	mov    %eax,%edx
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	01 c2                	add    %eax,%edx
 18a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 190:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 194:	3c 0a                	cmp    $0xa,%al
 196:	74 13                	je     1ab <gets+0x5e>
 198:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19c:	3c 0d                	cmp    $0xd,%al
 19e:	74 0b                	je     1ab <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a3:	83 c0 01             	add    $0x1,%eax
 1a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a9:	7c b1                	jl     15c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	01 d0                	add    %edx,%eax
 1b3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b9:	c9                   	leave  
 1ba:	c3                   	ret    

000001bb <stat>:

int
stat(char *n, struct stat *st)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c1:	83 ec 08             	sub    $0x8,%esp
 1c4:	6a 00                	push   $0x0
 1c6:	ff 75 08             	pushl  0x8(%ebp)
 1c9:	e8 0c 01 00 00       	call   2da <open>
 1ce:	83 c4 10             	add    $0x10,%esp
 1d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d8:	79 07                	jns    1e1 <stat+0x26>
    return -1;
 1da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1df:	eb 25                	jmp    206 <stat+0x4b>
  r = fstat(fd, st);
 1e1:	83 ec 08             	sub    $0x8,%esp
 1e4:	ff 75 0c             	pushl  0xc(%ebp)
 1e7:	ff 75 f4             	pushl  -0xc(%ebp)
 1ea:	e8 03 01 00 00       	call   2f2 <fstat>
 1ef:	83 c4 10             	add    $0x10,%esp
 1f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f5:	83 ec 0c             	sub    $0xc,%esp
 1f8:	ff 75 f4             	pushl  -0xc(%ebp)
 1fb:	e8 c2 00 00 00       	call   2c2 <close>
 200:	83 c4 10             	add    $0x10,%esp
  return r;
 203:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <atoi>:

int
atoi(const char *s)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 20e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 215:	eb 25                	jmp    23c <atoi+0x34>
    n = n*10 + *s++ - '0';
 217:	8b 55 fc             	mov    -0x4(%ebp),%edx
 21a:	89 d0                	mov    %edx,%eax
 21c:	c1 e0 02             	shl    $0x2,%eax
 21f:	01 d0                	add    %edx,%eax
 221:	01 c0                	add    %eax,%eax
 223:	89 c1                	mov    %eax,%ecx
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	8d 50 01             	lea    0x1(%eax),%edx
 22b:	89 55 08             	mov    %edx,0x8(%ebp)
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	0f be c0             	movsbl %al,%eax
 234:	01 c8                	add    %ecx,%eax
 236:	83 e8 30             	sub    $0x30,%eax
 239:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	0f b6 00             	movzbl (%eax),%eax
 242:	3c 2f                	cmp    $0x2f,%al
 244:	7e 0a                	jle    250 <atoi+0x48>
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	3c 39                	cmp    $0x39,%al
 24e:	7e c7                	jle    217 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 250:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    

00000255 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 261:	8b 45 0c             	mov    0xc(%ebp),%eax
 264:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 267:	eb 17                	jmp    280 <memmove+0x2b>
    *dst++ = *src++;
 269:	8b 45 fc             	mov    -0x4(%ebp),%eax
 26c:	8d 50 01             	lea    0x1(%eax),%edx
 26f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 272:	8b 55 f8             	mov    -0x8(%ebp),%edx
 275:	8d 4a 01             	lea    0x1(%edx),%ecx
 278:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 27b:	0f b6 12             	movzbl (%edx),%edx
 27e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 280:	8b 45 10             	mov    0x10(%ebp),%eax
 283:	8d 50 ff             	lea    -0x1(%eax),%edx
 286:	89 55 10             	mov    %edx,0x10(%ebp)
 289:	85 c0                	test   %eax,%eax
 28b:	7f dc                	jg     269 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 290:	c9                   	leave  
 291:	c3                   	ret    

00000292 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 292:	b8 01 00 00 00       	mov    $0x1,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <exit>:
SYSCALL(exit)
 29a:	b8 02 00 00 00       	mov    $0x2,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <wait>:
SYSCALL(wait)
 2a2:	b8 03 00 00 00       	mov    $0x3,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <pipe>:
SYSCALL(pipe)
 2aa:	b8 04 00 00 00       	mov    $0x4,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <read>:
SYSCALL(read)
 2b2:	b8 05 00 00 00       	mov    $0x5,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <write>:
SYSCALL(write)
 2ba:	b8 10 00 00 00       	mov    $0x10,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <close>:
SYSCALL(close)
 2c2:	b8 15 00 00 00       	mov    $0x15,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <kill>:
SYSCALL(kill)
 2ca:	b8 06 00 00 00       	mov    $0x6,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <exec>:
SYSCALL(exec)
 2d2:	b8 07 00 00 00       	mov    $0x7,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <open>:
SYSCALL(open)
 2da:	b8 0f 00 00 00       	mov    $0xf,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <mknod>:
SYSCALL(mknod)
 2e2:	b8 11 00 00 00       	mov    $0x11,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <unlink>:
SYSCALL(unlink)
 2ea:	b8 12 00 00 00       	mov    $0x12,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <fstat>:
SYSCALL(fstat)
 2f2:	b8 08 00 00 00       	mov    $0x8,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <link>:
SYSCALL(link)
 2fa:	b8 13 00 00 00       	mov    $0x13,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <mkdir>:
SYSCALL(mkdir)
 302:	b8 14 00 00 00       	mov    $0x14,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <chdir>:
SYSCALL(chdir)
 30a:	b8 09 00 00 00       	mov    $0x9,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <dup>:
SYSCALL(dup)
 312:	b8 0a 00 00 00       	mov    $0xa,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <getpid>:
SYSCALL(getpid)
 31a:	b8 0b 00 00 00       	mov    $0xb,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <sbrk>:
SYSCALL(sbrk)
 322:	b8 0c 00 00 00       	mov    $0xc,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <sleep>:
SYSCALL(sleep)
 32a:	b8 0d 00 00 00       	mov    $0xd,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <uptime>:
SYSCALL(uptime)
 332:	b8 0e 00 00 00       	mov    $0xe,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <getcwd>:
SYSCALL(getcwd)
 33a:	b8 16 00 00 00       	mov    $0x16,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <shutdown>:
SYSCALL(shutdown)
 342:	b8 17 00 00 00       	mov    $0x17,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <buildinfo>:
SYSCALL(buildinfo)
 34a:	b8 18 00 00 00       	mov    $0x18,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <lseek>:
SYSCALL(lseek)
 352:	b8 19 00 00 00       	mov    $0x19,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	83 ec 18             	sub    $0x18,%esp
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 366:	83 ec 04             	sub    $0x4,%esp
 369:	6a 01                	push   $0x1
 36b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36e:	50                   	push   %eax
 36f:	ff 75 08             	pushl  0x8(%ebp)
 372:	e8 43 ff ff ff       	call   2ba <write>
 377:	83 c4 10             	add    $0x10,%esp
}
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	53                   	push   %ebx
 380:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 383:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38e:	74 17                	je     3a7 <printint+0x2b>
 390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 394:	79 11                	jns    3a7 <printint+0x2b>
    neg = 1;
 396:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 39d:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a0:	f7 d8                	neg    %eax
 3a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a5:	eb 06                	jmp    3ad <printint+0x31>
  } else {
    x = xx;
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b7:	8d 41 01             	lea    0x1(%ecx),%eax
 3ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c3:	ba 00 00 00 00       	mov    $0x0,%edx
 3c8:	f7 f3                	div    %ebx
 3ca:	89 d0                	mov    %edx,%eax
 3cc:	0f b6 80 74 13 00 00 	movzbl 0x1374(%eax),%eax
 3d3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3dd:	ba 00 00 00 00       	mov    $0x0,%edx
 3e2:	f7 f3                	div    %ebx
 3e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3eb:	75 c7                	jne    3b4 <printint+0x38>
  if(neg)
 3ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f1:	74 0e                	je     401 <printint+0x85>
    buf[i++] = '-';
 3f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f6:	8d 50 01             	lea    0x1(%eax),%edx
 3f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3fc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 401:	eb 1d                	jmp    420 <printint+0xa4>
    putc(fd, buf[i]);
 403:	8d 55 dc             	lea    -0x24(%ebp),%edx
 406:	8b 45 f4             	mov    -0xc(%ebp),%eax
 409:	01 d0                	add    %edx,%eax
 40b:	0f b6 00             	movzbl (%eax),%eax
 40e:	0f be c0             	movsbl %al,%eax
 411:	83 ec 08             	sub    $0x8,%esp
 414:	50                   	push   %eax
 415:	ff 75 08             	pushl  0x8(%ebp)
 418:	e8 3d ff ff ff       	call   35a <putc>
 41d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 420:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 424:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 428:	79 d9                	jns    403 <printint+0x87>
    putc(fd, buf[i]);
}
 42a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 42d:	c9                   	leave  
 42e:	c3                   	ret    

0000042f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42f:	55                   	push   %ebp
 430:	89 e5                	mov    %esp,%ebp
 432:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 435:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 43c:	8d 45 0c             	lea    0xc(%ebp),%eax
 43f:	83 c0 04             	add    $0x4,%eax
 442:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 445:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 44c:	e9 59 01 00 00       	jmp    5aa <printf+0x17b>
    c = fmt[i] & 0xff;
 451:	8b 55 0c             	mov    0xc(%ebp),%edx
 454:	8b 45 f0             	mov    -0x10(%ebp),%eax
 457:	01 d0                	add    %edx,%eax
 459:	0f b6 00             	movzbl (%eax),%eax
 45c:	0f be c0             	movsbl %al,%eax
 45f:	25 ff 00 00 00       	and    $0xff,%eax
 464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46b:	75 2c                	jne    499 <printf+0x6a>
      if(c == '%'){
 46d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 471:	75 0c                	jne    47f <printf+0x50>
        state = '%';
 473:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47a:	e9 27 01 00 00       	jmp    5a6 <printf+0x177>
      } else {
        putc(fd, c);
 47f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 482:	0f be c0             	movsbl %al,%eax
 485:	83 ec 08             	sub    $0x8,%esp
 488:	50                   	push   %eax
 489:	ff 75 08             	pushl  0x8(%ebp)
 48c:	e8 c9 fe ff ff       	call   35a <putc>
 491:	83 c4 10             	add    $0x10,%esp
 494:	e9 0d 01 00 00       	jmp    5a6 <printf+0x177>
      }
    } else if(state == '%'){
 499:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 49d:	0f 85 03 01 00 00    	jne    5a6 <printf+0x177>
      if(c == 'd'){
 4a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a7:	75 1e                	jne    4c7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ac:	8b 00                	mov    (%eax),%eax
 4ae:	6a 01                	push   $0x1
 4b0:	6a 0a                	push   $0xa
 4b2:	50                   	push   %eax
 4b3:	ff 75 08             	pushl  0x8(%ebp)
 4b6:	e8 c1 fe ff ff       	call   37c <printint>
 4bb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c2:	e9 d8 00 00 00       	jmp    59f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4c7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4cb:	74 06                	je     4d3 <printf+0xa4>
 4cd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4d1:	75 1e                	jne    4f1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d6:	8b 00                	mov    (%eax),%eax
 4d8:	6a 00                	push   $0x0
 4da:	6a 10                	push   $0x10
 4dc:	50                   	push   %eax
 4dd:	ff 75 08             	pushl  0x8(%ebp)
 4e0:	e8 97 fe ff ff       	call   37c <printint>
 4e5:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ec:	e9 ae 00 00 00       	jmp    59f <printf+0x170>
      } else if(c == 's'){
 4f1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f5:	75 43                	jne    53a <printf+0x10b>
        s = (char*)*ap;
 4f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fa:	8b 00                	mov    (%eax),%eax
 4fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 507:	75 07                	jne    510 <printf+0xe1>
          s = "(null)";
 509:	c7 45 f4 63 0f 00 00 	movl   $0xf63,-0xc(%ebp)
        while(*s != 0){
 510:	eb 1c                	jmp    52e <printf+0xff>
          putc(fd, *s);
 512:	8b 45 f4             	mov    -0xc(%ebp),%eax
 515:	0f b6 00             	movzbl (%eax),%eax
 518:	0f be c0             	movsbl %al,%eax
 51b:	83 ec 08             	sub    $0x8,%esp
 51e:	50                   	push   %eax
 51f:	ff 75 08             	pushl  0x8(%ebp)
 522:	e8 33 fe ff ff       	call   35a <putc>
 527:	83 c4 10             	add    $0x10,%esp
          s++;
 52a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	84 c0                	test   %al,%al
 536:	75 da                	jne    512 <printf+0xe3>
 538:	eb 65                	jmp    59f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 53e:	75 1d                	jne    55d <printf+0x12e>
        putc(fd, *ap);
 540:	8b 45 e8             	mov    -0x18(%ebp),%eax
 543:	8b 00                	mov    (%eax),%eax
 545:	0f be c0             	movsbl %al,%eax
 548:	83 ec 08             	sub    $0x8,%esp
 54b:	50                   	push   %eax
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 06 fe ff ff       	call   35a <putc>
 554:	83 c4 10             	add    $0x10,%esp
        ap++;
 557:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55b:	eb 42                	jmp    59f <printf+0x170>
      } else if(c == '%'){
 55d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 561:	75 17                	jne    57a <printf+0x14b>
        putc(fd, c);
 563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 566:	0f be c0             	movsbl %al,%eax
 569:	83 ec 08             	sub    $0x8,%esp
 56c:	50                   	push   %eax
 56d:	ff 75 08             	pushl  0x8(%ebp)
 570:	e8 e5 fd ff ff       	call   35a <putc>
 575:	83 c4 10             	add    $0x10,%esp
 578:	eb 25                	jmp    59f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57a:	83 ec 08             	sub    $0x8,%esp
 57d:	6a 25                	push   $0x25
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 d3 fd ff ff       	call   35a <putc>
 587:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 58a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 be fd ff ff       	call   35a <putc>
 59c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 59f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b0:	01 d0                	add    %edx,%eax
 5b2:	0f b6 00             	movzbl (%eax),%eax
 5b5:	84 c0                	test   %al,%al
 5b7:	0f 85 94 fe ff ff    	jne    451 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5bd:	c9                   	leave  
 5be:	c3                   	ret    

000005bf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5bf:	55                   	push   %ebp
 5c0:	89 e5                	mov    %esp,%ebp
 5c2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	83 e8 08             	sub    $0x8,%eax
 5cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ce:	a1 90 13 00 00       	mov    0x1390,%eax
 5d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d6:	eb 24                	jmp    5fc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5db:	8b 00                	mov    (%eax),%eax
 5dd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e0:	77 12                	ja     5f4 <free+0x35>
 5e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e8:	77 24                	ja     60e <free+0x4f>
 5ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f2:	77 1a                	ja     60e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f7:	8b 00                	mov    (%eax),%eax
 5f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 602:	76 d4                	jbe    5d8 <free+0x19>
 604:	8b 45 fc             	mov    -0x4(%ebp),%eax
 607:	8b 00                	mov    (%eax),%eax
 609:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60c:	76 ca                	jbe    5d8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 60e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 611:	8b 40 04             	mov    0x4(%eax),%eax
 614:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 61b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61e:	01 c2                	add    %eax,%edx
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	39 c2                	cmp    %eax,%edx
 627:	75 24                	jne    64d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 629:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62c:	8b 50 04             	mov    0x4(%eax),%edx
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	8b 40 04             	mov    0x4(%eax),%eax
 637:	01 c2                	add    %eax,%edx
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8b 00                	mov    (%eax),%eax
 644:	8b 10                	mov    (%eax),%edx
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	89 10                	mov    %edx,(%eax)
 64b:	eb 0a                	jmp    657 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 10                	mov    (%eax),%edx
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 40 04             	mov    0x4(%eax),%eax
 65d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	01 d0                	add    %edx,%eax
 669:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66c:	75 20                	jne    68e <free+0xcf>
    p->s.size += bp->s.size;
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	8b 40 04             	mov    0x4(%eax),%eax
 67a:	01 c2                	add    %eax,%edx
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 10                	mov    (%eax),%edx
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	89 10                	mov    %edx,(%eax)
 68c:	eb 08                	jmp    696 <free+0xd7>
  } else
    p->s.ptr = bp;
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 55 f8             	mov    -0x8(%ebp),%edx
 694:	89 10                	mov    %edx,(%eax)
  freep = p;
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	a3 90 13 00 00       	mov    %eax,0x1390
}
 69e:	c9                   	leave  
 69f:	c3                   	ret    

000006a0 <morecore>:

static Header*
morecore(uint nu)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6a6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ad:	77 07                	ja     6b6 <morecore+0x16>
    nu = 4096;
 6af:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	c1 e0 03             	shl    $0x3,%eax
 6bc:	83 ec 0c             	sub    $0xc,%esp
 6bf:	50                   	push   %eax
 6c0:	e8 5d fc ff ff       	call   322 <sbrk>
 6c5:	83 c4 10             	add    $0x10,%esp
 6c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6cb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6cf:	75 07                	jne    6d8 <morecore+0x38>
    return 0;
 6d1:	b8 00 00 00 00       	mov    $0x0,%eax
 6d6:	eb 26                	jmp    6fe <morecore+0x5e>
  hp = (Header*)p;
 6d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e1:	8b 55 08             	mov    0x8(%ebp),%edx
 6e4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ea:	83 c0 08             	add    $0x8,%eax
 6ed:	83 ec 0c             	sub    $0xc,%esp
 6f0:	50                   	push   %eax
 6f1:	e8 c9 fe ff ff       	call   5bf <free>
 6f6:	83 c4 10             	add    $0x10,%esp
  return freep;
 6f9:	a1 90 13 00 00       	mov    0x1390,%eax
}
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    

00000700 <malloc>:

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	83 c0 07             	add    $0x7,%eax
 70c:	c1 e8 03             	shr    $0x3,%eax
 70f:	83 c0 01             	add    $0x1,%eax
 712:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 715:	a1 90 13 00 00       	mov    0x1390,%eax
 71a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 71d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 721:	75 23                	jne    746 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 723:	c7 45 f0 88 13 00 00 	movl   $0x1388,-0x10(%ebp)
 72a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72d:	a3 90 13 00 00       	mov    %eax,0x1390
 732:	a1 90 13 00 00       	mov    0x1390,%eax
 737:	a3 88 13 00 00       	mov    %eax,0x1388
    base.s.size = 0;
 73c:	c7 05 8c 13 00 00 00 	movl   $0x0,0x138c
 743:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 746:	8b 45 f0             	mov    -0x10(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 751:	8b 40 04             	mov    0x4(%eax),%eax
 754:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 757:	72 4d                	jb     7a6 <malloc+0xa6>
      if(p->s.size == nunits)
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	8b 40 04             	mov    0x4(%eax),%eax
 75f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 762:	75 0c                	jne    770 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	8b 10                	mov    (%eax),%edx
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	89 10                	mov    %edx,(%eax)
 76e:	eb 26                	jmp    796 <malloc+0x96>
      else {
        p->s.size -= nunits;
 770:	8b 45 f4             	mov    -0xc(%ebp),%eax
 773:	8b 40 04             	mov    0x4(%eax),%eax
 776:	2b 45 ec             	sub    -0x14(%ebp),%eax
 779:	89 c2                	mov    %eax,%edx
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	c1 e0 03             	shl    $0x3,%eax
 78a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	8b 55 ec             	mov    -0x14(%ebp),%edx
 793:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	a3 90 13 00 00       	mov    %eax,0x1390
      return (void*)(p + 1);
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	83 c0 08             	add    $0x8,%eax
 7a4:	eb 3b                	jmp    7e1 <malloc+0xe1>
    }
    if(p == freep)
 7a6:	a1 90 13 00 00       	mov    0x1390,%eax
 7ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ae:	75 1e                	jne    7ce <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	ff 75 ec             	pushl  -0x14(%ebp)
 7b6:	e8 e5 fe ff ff       	call   6a0 <morecore>
 7bb:	83 c4 10             	add    $0x10,%esp
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c5:	75 07                	jne    7ce <malloc+0xce>
        return 0;
 7c7:	b8 00 00 00 00       	mov    $0x0,%eax
 7cc:	eb 13                	jmp    7e1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7dc:	e9 6d ff ff ff       	jmp    74e <malloc+0x4e>
}
 7e1:	c9                   	leave  
 7e2:	c3                   	ret    

000007e3 <isspace>:

#include "common.h"

int isspace(char c) {
 7e3:	55                   	push   %ebp
 7e4:	89 e5                	mov    %esp,%ebp
 7e6:	83 ec 04             	sub    $0x4,%esp
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 7ef:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 7f3:	74 12                	je     807 <isspace+0x24>
 7f5:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 7f9:	74 0c                	je     807 <isspace+0x24>
 7fb:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 7ff:	74 06                	je     807 <isspace+0x24>
 801:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 805:	75 07                	jne    80e <isspace+0x2b>
 807:	b8 01 00 00 00       	mov    $0x1,%eax
 80c:	eb 05                	jmp    813 <isspace+0x30>
 80e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 813:	c9                   	leave  
 814:	c3                   	ret    

00000815 <readln>:

char* readln(char *buf, int max, int fd)
{
 815:	55                   	push   %ebp
 816:	89 e5                	mov    %esp,%ebp
 818:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 81b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 822:	eb 45                	jmp    869 <readln+0x54>
    cc = read(fd, &c, 1);
 824:	83 ec 04             	sub    $0x4,%esp
 827:	6a 01                	push   $0x1
 829:	8d 45 ef             	lea    -0x11(%ebp),%eax
 82c:	50                   	push   %eax
 82d:	ff 75 10             	pushl  0x10(%ebp)
 830:	e8 7d fa ff ff       	call   2b2 <read>
 835:	83 c4 10             	add    $0x10,%esp
 838:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 83b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83f:	7f 02                	jg     843 <readln+0x2e>
      break;
 841:	eb 31                	jmp    874 <readln+0x5f>
    buf[i++] = c;
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	8d 50 01             	lea    0x1(%eax),%edx
 849:	89 55 f4             	mov    %edx,-0xc(%ebp)
 84c:	89 c2                	mov    %eax,%edx
 84e:	8b 45 08             	mov    0x8(%ebp),%eax
 851:	01 c2                	add    %eax,%edx
 853:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 857:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 859:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 85d:	3c 0a                	cmp    $0xa,%al
 85f:	74 13                	je     874 <readln+0x5f>
 861:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 865:	3c 0d                	cmp    $0xd,%al
 867:	74 0b                	je     874 <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	83 c0 01             	add    $0x1,%eax
 86f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 872:	7c b0                	jl     824 <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 874:	8b 55 f4             	mov    -0xc(%ebp),%edx
 877:	8b 45 08             	mov    0x8(%ebp),%eax
 87a:	01 d0                	add    %edx,%eax
 87c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 882:	c9                   	leave  
 883:	c3                   	ret    

00000884 <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 884:	55                   	push   %ebp
 885:	89 e5                	mov    %esp,%ebp
 887:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 88a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 891:	eb 19                	jmp    8ac <strncpy+0x28>
		dest[i] = src[i];
 893:	8b 55 fc             	mov    -0x4(%ebp),%edx
 896:	8b 45 08             	mov    0x8(%ebp),%eax
 899:	01 c2                	add    %eax,%edx
 89b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 89e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a1:	01 c8                	add    %ecx,%eax
 8a3:	0f b6 00             	movzbl (%eax),%eax
 8a6:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8a8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8af:	3b 45 10             	cmp    0x10(%ebp),%eax
 8b2:	7d 0f                	jge    8c3 <strncpy+0x3f>
 8b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 8ba:	01 d0                	add    %edx,%eax
 8bc:	0f b6 00             	movzbl (%eax),%eax
 8bf:	84 c0                	test   %al,%al
 8c1:	75 d0                	jne    893 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 8c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8c6:	c9                   	leave  
 8c7:	c3                   	ret    

000008c8 <trim>:

char* trim(char* orig) {
 8c8:	55                   	push   %ebp
 8c9:	89 e5                	mov    %esp,%ebp
 8cb:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 8d4:	8b 45 08             	mov    0x8(%ebp),%eax
 8d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 8da:	eb 04                	jmp    8e0 <trim+0x18>
 8dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	0f b6 00             	movzbl (%eax),%eax
 8e6:	0f be c0             	movsbl %al,%eax
 8e9:	50                   	push   %eax
 8ea:	e8 f4 fe ff ff       	call   7e3 <isspace>
 8ef:	83 c4 04             	add    $0x4,%esp
 8f2:	85 c0                	test   %eax,%eax
 8f4:	75 e6                	jne    8dc <trim+0x14>
	while (*tail) { tail++; }
 8f6:	eb 04                	jmp    8fc <trim+0x34>
 8f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ff:	0f b6 00             	movzbl (%eax),%eax
 902:	84 c0                	test   %al,%al
 904:	75 f2                	jne    8f8 <trim+0x30>
	do { tail--; } while (isspace(*tail));
 906:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 90a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90d:	0f b6 00             	movzbl (%eax),%eax
 910:	0f be c0             	movsbl %al,%eax
 913:	50                   	push   %eax
 914:	e8 ca fe ff ff       	call   7e3 <isspace>
 919:	83 c4 04             	add    $0x4,%esp
 91c:	85 c0                	test   %eax,%eax
 91e:	75 e6                	jne    906 <trim+0x3e>
	new = malloc(tail-head+2);
 920:	8b 55 f0             	mov    -0x10(%ebp),%edx
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	29 c2                	sub    %eax,%edx
 928:	89 d0                	mov    %edx,%eax
 92a:	83 c0 02             	add    $0x2,%eax
 92d:	83 ec 0c             	sub    $0xc,%esp
 930:	50                   	push   %eax
 931:	e8 ca fd ff ff       	call   700 <malloc>
 936:	83 c4 10             	add    $0x10,%esp
 939:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 93c:	8b 55 f0             	mov    -0x10(%ebp),%edx
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	29 c2                	sub    %eax,%edx
 944:	89 d0                	mov    %edx,%eax
 946:	83 c0 01             	add    $0x1,%eax
 949:	83 ec 04             	sub    $0x4,%esp
 94c:	50                   	push   %eax
 94d:	ff 75 f4             	pushl  -0xc(%ebp)
 950:	ff 75 ec             	pushl  -0x14(%ebp)
 953:	e8 2c ff ff ff       	call   884 <strncpy>
 958:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 95b:	8b 55 f0             	mov    -0x10(%ebp),%edx
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	29 c2                	sub    %eax,%edx
 963:	89 d0                	mov    %edx,%eax
 965:	8d 50 01             	lea    0x1(%eax),%edx
 968:	8b 45 ec             	mov    -0x14(%ebp),%eax
 96b:	01 d0                	add    %edx,%eax
 96d:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 970:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 973:	c9                   	leave  
 974:	c3                   	ret    

00000975 <itoa>:

char *
itoa(int value)
{
 975:	55                   	push   %ebp
 976:	89 e5                	mov    %esp,%ebp
 978:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 97b:	8d 45 bf             	lea    -0x41(%ebp),%eax
 97e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 981:	8b 45 08             	mov    0x8(%ebp),%eax
 984:	c1 e8 1f             	shr    $0x1f,%eax
 987:	0f b6 c0             	movzbl %al,%eax
 98a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 98d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 991:	74 0a                	je     99d <itoa+0x28>
    v = -value;
 993:	8b 45 08             	mov    0x8(%ebp),%eax
 996:	f7 d8                	neg    %eax
 998:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99b:	eb 06                	jmp    9a3 <itoa+0x2e>
  else
    v = (uint)value;
 99d:	8b 45 08             	mov    0x8(%ebp),%eax
 9a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 9a3:	eb 5b                	jmp    a00 <itoa+0x8b>
  {
    i = v % 10;
 9a5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 9a8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9ad:	89 c8                	mov    %ecx,%eax
 9af:	f7 e2                	mul    %edx
 9b1:	c1 ea 03             	shr    $0x3,%edx
 9b4:	89 d0                	mov    %edx,%eax
 9b6:	c1 e0 02             	shl    $0x2,%eax
 9b9:	01 d0                	add    %edx,%eax
 9bb:	01 c0                	add    %eax,%eax
 9bd:	29 c1                	sub    %eax,%ecx
 9bf:	89 ca                	mov    %ecx,%edx
 9c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 9c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c7:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9cc:	f7 e2                	mul    %edx
 9ce:	89 d0                	mov    %edx,%eax
 9d0:	c1 e8 03             	shr    $0x3,%eax
 9d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 9d6:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 9da:	7f 13                	jg     9ef <itoa+0x7a>
      *tp++ = i+'0';
 9dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9df:	8d 50 01             	lea    0x1(%eax),%edx
 9e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9e8:	83 c2 30             	add    $0x30,%edx
 9eb:	88 10                	mov    %dl,(%eax)
 9ed:	eb 11                	jmp    a00 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	8d 50 01             	lea    0x1(%eax),%edx
 9f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9fb:	83 c2 57             	add    $0x57,%edx
 9fe:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 a00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a04:	75 9f                	jne    9a5 <itoa+0x30>
 a06:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a09:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a0c:	74 97                	je     9a5 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a11:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a14:	29 c2                	sub    %eax,%edx
 a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a19:	01 d0                	add    %edx,%eax
 a1b:	83 c0 01             	add    $0x1,%eax
 a1e:	83 ec 0c             	sub    $0xc,%esp
 a21:	50                   	push   %eax
 a22:	e8 d9 fc ff ff       	call   700 <malloc>
 a27:	83 c4 10             	add    $0x10,%esp
 a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a30:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a37:	74 0c                	je     a45 <itoa+0xd0>
    *sp++ = '-';
 a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a3c:	8d 50 01             	lea    0x1(%eax),%edx
 a3f:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a42:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a45:	eb 15                	jmp    a5c <itoa+0xe7>
    *sp++ = *--tp;
 a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a4a:	8d 50 01             	lea    0x1(%eax),%edx
 a4d:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a50:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a57:	0f b6 12             	movzbl (%edx),%edx
 a5a:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 a5c:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a5f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a62:	77 e3                	ja     a47 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a67:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 a6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 a6d:	c9                   	leave  
 a6e:	c3                   	ret    

00000a6f <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 a6f:	55                   	push   %ebp
 a70:	89 e5                	mov    %esp,%ebp
 a72:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 a78:	83 ec 08             	sub    $0x8,%esp
 a7b:	6a 00                	push   $0x0
 a7d:	ff 75 08             	pushl  0x8(%ebp)
 a80:	e8 55 f8 ff ff       	call   2da <open>
 a85:	83 c4 10             	add    $0x10,%esp
 a88:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 a8b:	e9 22 01 00 00       	jmp    bb2 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 a90:	83 ec 08             	sub    $0x8,%esp
 a93:	6a 3d                	push   $0x3d
 a95:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 a9b:	50                   	push   %eax
 a9c:	e8 79 f6 ff ff       	call   11a <strchr>
 aa1:	83 c4 10             	add    $0x10,%esp
 aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 aa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 aab:	0f 84 23 01 00 00    	je     bd4 <parseEnvFile+0x165>
 ab1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ab5:	0f 84 19 01 00 00    	je     bd4 <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
 abe:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ac4:	29 c2                	sub    %eax,%edx
 ac6:	89 d0                	mov    %edx,%eax
 ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ace:	83 c0 01             	add    $0x1,%eax
 ad1:	83 ec 0c             	sub    $0xc,%esp
 ad4:	50                   	push   %eax
 ad5:	e8 26 fc ff ff       	call   700 <malloc>
 ada:	83 c4 10             	add    $0x10,%esp
 add:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 ae0:	83 ec 04             	sub    $0x4,%esp
 ae3:	ff 75 ec             	pushl  -0x14(%ebp)
 ae6:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 aec:	50                   	push   %eax
 aed:	ff 75 e8             	pushl  -0x18(%ebp)
 af0:	e8 8f fd ff ff       	call   884 <strncpy>
 af5:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 af8:	83 ec 0c             	sub    $0xc,%esp
 afb:	ff 75 e8             	pushl  -0x18(%ebp)
 afe:	e8 c5 fd ff ff       	call   8c8 <trim>
 b03:	83 c4 10             	add    $0x10,%esp
 b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 b09:	83 ec 0c             	sub    $0xc,%esp
 b0c:	ff 75 e8             	pushl  -0x18(%ebp)
 b0f:	e8 ab fa ff ff       	call   5bf <free>
 b14:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 b17:	83 ec 08             	sub    $0x8,%esp
 b1a:	ff 75 0c             	pushl  0xc(%ebp)
 b1d:	ff 75 e4             	pushl  -0x1c(%ebp)
 b20:	e8 c2 01 00 00       	call   ce7 <addToEnvironment>
 b25:	83 c4 10             	add    $0x10,%esp
 b28:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b2b:	83 ec 0c             	sub    $0xc,%esp
 b2e:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b34:	50                   	push   %eax
 b35:	e8 9f f5 ff ff       	call   d9 <strlen>
 b3a:	83 c4 10             	add    $0x10,%esp
 b3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b43:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b46:	83 ec 0c             	sub    $0xc,%esp
 b49:	50                   	push   %eax
 b4a:	e8 b1 fb ff ff       	call   700 <malloc>
 b4f:	83 c4 10             	add    $0x10,%esp
 b52:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 b55:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b58:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b5b:	8d 50 ff             	lea    -0x1(%eax),%edx
 b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b61:	8d 48 01             	lea    0x1(%eax),%ecx
 b64:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b6a:	01 c8                	add    %ecx,%eax
 b6c:	83 ec 04             	sub    $0x4,%esp
 b6f:	52                   	push   %edx
 b70:	50                   	push   %eax
 b71:	ff 75 e8             	pushl  -0x18(%ebp)
 b74:	e8 0b fd ff ff       	call   884 <strncpy>
 b79:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 b7c:	83 ec 0c             	sub    $0xc,%esp
 b7f:	ff 75 e8             	pushl  -0x18(%ebp)
 b82:	e8 41 fd ff ff       	call   8c8 <trim>
 b87:	83 c4 10             	add    $0x10,%esp
 b8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 b8d:	83 ec 0c             	sub    $0xc,%esp
 b90:	ff 75 e8             	pushl  -0x18(%ebp)
 b93:	e8 27 fa ff ff       	call   5bf <free>
 b98:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 b9b:	83 ec 04             	sub    $0x4,%esp
 b9e:	ff 75 dc             	pushl  -0x24(%ebp)
 ba1:	ff 75 0c             	pushl  0xc(%ebp)
 ba4:	ff 75 e4             	pushl  -0x1c(%ebp)
 ba7:	e8 b8 01 00 00       	call   d64 <addValueToVariable>
 bac:	83 c4 10             	add    $0x10,%esp
 baf:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 bb2:	83 ec 04             	sub    $0x4,%esp
 bb5:	ff 75 f4             	pushl  -0xc(%ebp)
 bb8:	68 00 04 00 00       	push   $0x400
 bbd:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 bc3:	50                   	push   %eax
 bc4:	e8 4c fc ff ff       	call   815 <readln>
 bc9:	83 c4 10             	add    $0x10,%esp
 bcc:	85 c0                	test   %eax,%eax
 bce:	0f 85 bc fe ff ff    	jne    a90 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 bd4:	83 ec 0c             	sub    $0xc,%esp
 bd7:	ff 75 f4             	pushl  -0xc(%ebp)
 bda:	e8 e3 f6 ff ff       	call   2c2 <close>
 bdf:	83 c4 10             	add    $0x10,%esp
	return head;
 be2:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 be5:	c9                   	leave  
 be6:	c3                   	ret    

00000be7 <comp>:

int comp(const char* s1, const char* s2)
{
 be7:	55                   	push   %ebp
 be8:	89 e5                	mov    %esp,%ebp
 bea:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 bed:	83 ec 08             	sub    $0x8,%esp
 bf0:	ff 75 0c             	pushl  0xc(%ebp)
 bf3:	ff 75 08             	pushl  0x8(%ebp)
 bf6:	e8 9f f4 ff ff       	call   9a <strcmp>
 bfb:	83 c4 10             	add    $0x10,%esp
 bfe:	85 c0                	test   %eax,%eax
 c00:	0f 94 c0             	sete   %al
 c03:	0f b6 c0             	movzbl %al,%eax
}
 c06:	c9                   	leave  
 c07:	c3                   	ret    

00000c08 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 c08:	55                   	push   %ebp
 c09:	89 e5                	mov    %esp,%ebp
 c0b:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c12:	75 07                	jne    c1b <environLookup+0x13>
    return NULL;
 c14:	b8 00 00 00 00       	mov    $0x0,%eax
 c19:	eb 2f                	jmp    c4a <environLookup+0x42>
  
  while (head)
 c1b:	eb 24                	jmp    c41 <environLookup+0x39>
  {
    if (comp(name, head->name))
 c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
 c20:	83 ec 08             	sub    $0x8,%esp
 c23:	50                   	push   %eax
 c24:	ff 75 08             	pushl  0x8(%ebp)
 c27:	e8 bb ff ff ff       	call   be7 <comp>
 c2c:	83 c4 10             	add    $0x10,%esp
 c2f:	85 c0                	test   %eax,%eax
 c31:	74 02                	je     c35 <environLookup+0x2d>
      break;
 c33:	eb 12                	jmp    c47 <environLookup+0x3f>
    head = head->next;
 c35:	8b 45 0c             	mov    0xc(%ebp),%eax
 c38:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c3e:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c45:	75 d6                	jne    c1d <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c47:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c4a:	c9                   	leave  
 c4b:	c3                   	ret    

00000c4c <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c4c:	55                   	push   %ebp
 c4d:	89 e5                	mov    %esp,%ebp
 c4f:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c56:	75 0a                	jne    c62 <removeFromEnvironment+0x16>
    return NULL;
 c58:	b8 00 00 00 00       	mov    $0x0,%eax
 c5d:	e9 83 00 00 00       	jmp    ce5 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 c62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c66:	74 0a                	je     c72 <removeFromEnvironment+0x26>
 c68:	8b 45 08             	mov    0x8(%ebp),%eax
 c6b:	0f b6 00             	movzbl (%eax),%eax
 c6e:	84 c0                	test   %al,%al
 c70:	75 05                	jne    c77 <removeFromEnvironment+0x2b>
    return head;
 c72:	8b 45 0c             	mov    0xc(%ebp),%eax
 c75:	eb 6e                	jmp    ce5 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 c77:	8b 45 0c             	mov    0xc(%ebp),%eax
 c7a:	83 ec 08             	sub    $0x8,%esp
 c7d:	ff 75 08             	pushl  0x8(%ebp)
 c80:	50                   	push   %eax
 c81:	e8 61 ff ff ff       	call   be7 <comp>
 c86:	83 c4 10             	add    $0x10,%esp
 c89:	85 c0                	test   %eax,%eax
 c8b:	74 34                	je     cc1 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
 c90:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 c99:	8b 45 0c             	mov    0xc(%ebp),%eax
 c9c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 ca2:	83 ec 0c             	sub    $0xc,%esp
 ca5:	50                   	push   %eax
 ca6:	e8 74 01 00 00       	call   e1f <freeVarval>
 cab:	83 c4 10             	add    $0x10,%esp
    free(head);
 cae:	83 ec 0c             	sub    $0xc,%esp
 cb1:	ff 75 0c             	pushl  0xc(%ebp)
 cb4:	e8 06 f9 ff ff       	call   5bf <free>
 cb9:	83 c4 10             	add    $0x10,%esp
    return tmp;
 cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cbf:	eb 24                	jmp    ce5 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
 cc4:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cca:	83 ec 08             	sub    $0x8,%esp
 ccd:	50                   	push   %eax
 cce:	ff 75 08             	pushl  0x8(%ebp)
 cd1:	e8 76 ff ff ff       	call   c4c <removeFromEnvironment>
 cd6:	83 c4 10             	add    $0x10,%esp
 cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
 cdc:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 ce5:	c9                   	leave  
 ce6:	c3                   	ret    

00000ce7 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 ce7:	55                   	push   %ebp
 ce8:	89 e5                	mov    %esp,%ebp
 cea:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 ced:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 cf1:	75 05                	jne    cf8 <addToEnvironment+0x11>
		return head;
 cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
 cf6:	eb 6a                	jmp    d62 <addToEnvironment+0x7b>
	if (head == NULL) {
 cf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 cfc:	75 40                	jne    d3e <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 cfe:	83 ec 0c             	sub    $0xc,%esp
 d01:	68 88 00 00 00       	push   $0x88
 d06:	e8 f5 f9 ff ff       	call   700 <malloc>
 d0b:	83 c4 10             	add    $0x10,%esp
 d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 d11:	8b 45 08             	mov    0x8(%ebp),%eax
 d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1a:	83 ec 08             	sub    $0x8,%esp
 d1d:	ff 75 f0             	pushl  -0x10(%ebp)
 d20:	50                   	push   %eax
 d21:	e8 44 f3 ff ff       	call   6a <strcpy>
 d26:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d33:	00 00 00 
		head = newVar;
 d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d39:	89 45 0c             	mov    %eax,0xc(%ebp)
 d3c:	eb 21                	jmp    d5f <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
 d41:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d47:	83 ec 08             	sub    $0x8,%esp
 d4a:	50                   	push   %eax
 d4b:	ff 75 08             	pushl  0x8(%ebp)
 d4e:	e8 94 ff ff ff       	call   ce7 <addToEnvironment>
 d53:	83 c4 10             	add    $0x10,%esp
 d56:	8b 55 0c             	mov    0xc(%ebp),%edx
 d59:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d62:	c9                   	leave  
 d63:	c3                   	ret    

00000d64 <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 d64:	55                   	push   %ebp
 d65:	89 e5                	mov    %esp,%ebp
 d67:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 d6a:	83 ec 08             	sub    $0x8,%esp
 d6d:	ff 75 0c             	pushl  0xc(%ebp)
 d70:	ff 75 08             	pushl  0x8(%ebp)
 d73:	e8 90 fe ff ff       	call   c08 <environLookup>
 d78:	83 c4 10             	add    $0x10,%esp
 d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d82:	75 05                	jne    d89 <addValueToVariable+0x25>
		return head;
 d84:	8b 45 0c             	mov    0xc(%ebp),%eax
 d87:	eb 4c                	jmp    dd5 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 d89:	83 ec 0c             	sub    $0xc,%esp
 d8c:	68 04 04 00 00       	push   $0x404
 d91:	e8 6a f9 ff ff       	call   700 <malloc>
 d96:	83 c4 10             	add    $0x10,%esp
 d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 d9c:	8b 45 10             	mov    0x10(%ebp),%eax
 d9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 da5:	83 ec 08             	sub    $0x8,%esp
 da8:	ff 75 ec             	pushl  -0x14(%ebp)
 dab:	50                   	push   %eax
 dac:	e8 b9 f2 ff ff       	call   6a <strcpy>
 db1:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 db7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dc0:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
 dcc:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 dd5:	c9                   	leave  
 dd6:	c3                   	ret    

00000dd7 <freeEnvironment>:

void freeEnvironment(variable* head)
{
 dd7:	55                   	push   %ebp
 dd8:	89 e5                	mov    %esp,%ebp
 dda:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 de1:	75 02                	jne    de5 <freeEnvironment+0xe>
    return;  
 de3:	eb 38                	jmp    e1d <freeEnvironment+0x46>
  freeEnvironment(head->next);
 de5:	8b 45 08             	mov    0x8(%ebp),%eax
 de8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 dee:	83 ec 0c             	sub    $0xc,%esp
 df1:	50                   	push   %eax
 df2:	e8 e0 ff ff ff       	call   dd7 <freeEnvironment>
 df7:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 dfa:	8b 45 08             	mov    0x8(%ebp),%eax
 dfd:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 e03:	83 ec 0c             	sub    $0xc,%esp
 e06:	50                   	push   %eax
 e07:	e8 13 00 00 00       	call   e1f <freeVarval>
 e0c:	83 c4 10             	add    $0x10,%esp
  free(head);
 e0f:	83 ec 0c             	sub    $0xc,%esp
 e12:	ff 75 08             	pushl  0x8(%ebp)
 e15:	e8 a5 f7 ff ff       	call   5bf <free>
 e1a:	83 c4 10             	add    $0x10,%esp
}
 e1d:	c9                   	leave  
 e1e:	c3                   	ret    

00000e1f <freeVarval>:

void freeVarval(varval* head)
{
 e1f:	55                   	push   %ebp
 e20:	89 e5                	mov    %esp,%ebp
 e22:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e29:	75 02                	jne    e2d <freeVarval+0xe>
    return;  
 e2b:	eb 23                	jmp    e50 <freeVarval+0x31>
  freeVarval(head->next);
 e2d:	8b 45 08             	mov    0x8(%ebp),%eax
 e30:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e36:	83 ec 0c             	sub    $0xc,%esp
 e39:	50                   	push   %eax
 e3a:	e8 e0 ff ff ff       	call   e1f <freeVarval>
 e3f:	83 c4 10             	add    $0x10,%esp
  free(head);
 e42:	83 ec 0c             	sub    $0xc,%esp
 e45:	ff 75 08             	pushl  0x8(%ebp)
 e48:	e8 72 f7 ff ff       	call   5bf <free>
 e4d:	83 c4 10             	add    $0x10,%esp
}
 e50:	c9                   	leave  
 e51:	c3                   	ret    

00000e52 <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e52:	55                   	push   %ebp
 e53:	89 e5                	mov    %esp,%ebp
 e55:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 e58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e5c:	75 08                	jne    e66 <getPaths+0x14>
		return head;
 e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
 e61:	e9 e7 00 00 00       	jmp    f4d <getPaths+0xfb>
	if (head == NULL) {
 e66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 e6a:	0f 85 b9 00 00 00    	jne    f29 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 e70:	83 ec 08             	sub    $0x8,%esp
 e73:	6a 3a                	push   $0x3a
 e75:	ff 75 08             	pushl  0x8(%ebp)
 e78:	e8 9d f2 ff ff       	call   11a <strchr>
 e7d:	83 c4 10             	add    $0x10,%esp
 e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 e83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e87:	75 56                	jne    edf <getPaths+0x8d>
			pathLen = strlen(paths);
 e89:	83 ec 0c             	sub    $0xc,%esp
 e8c:	ff 75 08             	pushl  0x8(%ebp)
 e8f:	e8 45 f2 ff ff       	call   d9 <strlen>
 e94:	83 c4 10             	add    $0x10,%esp
 e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 e9a:	83 ec 0c             	sub    $0xc,%esp
 e9d:	68 04 04 00 00       	push   $0x404
 ea2:	e8 59 f8 ff ff       	call   700 <malloc>
 ea7:	83 c4 10             	add    $0x10,%esp
 eaa:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 ead:	8b 45 0c             	mov    0xc(%ebp),%eax
 eb0:	83 ec 04             	sub    $0x4,%esp
 eb3:	ff 75 f0             	pushl  -0x10(%ebp)
 eb6:	ff 75 08             	pushl  0x8(%ebp)
 eb9:	50                   	push   %eax
 eba:	e8 c5 f9 ff ff       	call   884 <strncpy>
 ebf:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
 ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ec8:	01 d0                	add    %edx,%eax
 eca:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
 ed0:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 ed7:	00 00 00 
			return head;
 eda:	8b 45 0c             	mov    0xc(%ebp),%eax
 edd:	eb 6e                	jmp    f4d <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ee2:	8b 45 08             	mov    0x8(%ebp),%eax
 ee5:	29 c2                	sub    %eax,%edx
 ee7:	89 d0                	mov    %edx,%eax
 ee9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 eec:	83 ec 0c             	sub    $0xc,%esp
 eef:	68 04 04 00 00       	push   $0x404
 ef4:	e8 07 f8 ff ff       	call   700 <malloc>
 ef9:	83 c4 10             	add    $0x10,%esp
 efc:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 eff:	8b 45 0c             	mov    0xc(%ebp),%eax
 f02:	83 ec 04             	sub    $0x4,%esp
 f05:	ff 75 f0             	pushl  -0x10(%ebp)
 f08:	ff 75 08             	pushl  0x8(%ebp)
 f0b:	50                   	push   %eax
 f0c:	e8 73 f9 ff ff       	call   884 <strncpy>
 f11:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f14:	8b 55 0c             	mov    0xc(%ebp),%edx
 f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f1a:	01 d0                	add    %edx,%eax
 f1c:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f22:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 f25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f29:	8b 45 0c             	mov    0xc(%ebp),%eax
 f2c:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f32:	83 ec 08             	sub    $0x8,%esp
 f35:	50                   	push   %eax
 f36:	ff 75 08             	pushl  0x8(%ebp)
 f39:	e8 14 ff ff ff       	call   e52 <getPaths>
 f3e:	83 c4 10             	add    $0x10,%esp
 f41:	8b 55 0c             	mov    0xc(%ebp),%edx
 f44:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f4d:	c9                   	leave  
 f4e:	c3                   	ret    
