
_ln:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 2d 08 00 	movl   $0x82d,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 3e 04 00 00       	call   461 <printf>
    exit();
  23:	e8 b9 02 00 00       	call   2e1 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 fd 02 00 00       	call   341 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 40 08 00 	movl   $0x840,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 ed 03 00 00       	call   461 <printf>
  exit();
  74:	e8 68 02 00 00       	call   2e1 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  aa:	90                   	nop
  ab:	8b 45 08             	mov    0x8(%ebp),%eax
  ae:	8d 50 01             	lea    0x1(%eax),%edx
  b1:	89 55 08             	mov    %edx,0x8(%ebp)
  b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  bd:	0f b6 12             	movzbl (%edx),%edx
  c0:	88 10                	mov    %dl,(%eax)
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	84 c0                	test   %al,%al
  c7:	75 e2                	jne    ab <strcpy+0xd>
    ;
  return os;
  c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d1:	eb 08                	jmp    db <strcmp+0xd>
    p++, q++;
  d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	0f b6 00             	movzbl (%eax),%eax
  e1:	84 c0                	test   %al,%al
  e3:	74 10                	je     f5 <strcmp+0x27>
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	0f b6 10             	movzbl (%eax),%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	38 c2                	cmp    %al,%dl
  f3:	74 de                	je     d3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f b6 d0             	movzbl %al,%edx
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	0f b6 00             	movzbl (%eax),%eax
 104:	0f b6 c0             	movzbl %al,%eax
 107:	29 c2                	sub    %eax,%edx
 109:	89 d0                	mov    %edx,%eax
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    

0000010d <strlen>:

uint
strlen(char *s)
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 113:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11a:	eb 04                	jmp    120 <strlen+0x13>
 11c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 120:	8b 55 fc             	mov    -0x4(%ebp),%edx
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	01 d0                	add    %edx,%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	84 c0                	test   %al,%al
 12d:	75 ed                	jne    11c <strlen+0xf>
    ;
  return n;
 12f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <memset>:

void*
memset(void *dst, int c, uint n)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 13a:	8b 45 10             	mov    0x10(%ebp),%eax
 13d:	89 44 24 08          	mov    %eax,0x8(%esp)
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	89 44 24 04          	mov    %eax,0x4(%esp)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	89 04 24             	mov    %eax,(%esp)
 14e:	e8 26 ff ff ff       	call   79 <stosb>
  return dst;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
}
 156:	c9                   	leave  
 157:	c3                   	ret    

00000158 <strchr>:

char*
strchr(const char *s, char c)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	83 ec 04             	sub    $0x4,%esp
 15e:	8b 45 0c             	mov    0xc(%ebp),%eax
 161:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 164:	eb 14                	jmp    17a <strchr+0x22>
    if(*s == c)
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	0f b6 00             	movzbl (%eax),%eax
 16c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 16f:	75 05                	jne    176 <strchr+0x1e>
      return (char*)s;
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	eb 13                	jmp    189 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 176:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 00             	movzbl (%eax),%eax
 180:	84 c0                	test   %al,%al
 182:	75 e2                	jne    166 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 184:	b8 00 00 00 00       	mov    $0x0,%eax
}
 189:	c9                   	leave  
 18a:	c3                   	ret    

0000018b <gets>:

char*
gets(char *buf, int max)
{
 18b:	55                   	push   %ebp
 18c:	89 e5                	mov    %esp,%ebp
 18e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 198:	eb 4c                	jmp    1e6 <gets+0x5b>
    cc = read(0, &c, 1);
 19a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a1:	00 
 1a2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b0:	e8 44 01 00 00       	call   2f9 <read>
 1b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1bc:	7f 02                	jg     1c0 <gets+0x35>
      break;
 1be:	eb 31                	jmp    1f1 <gets+0x66>
    buf[i++] = c;
 1c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c3:	8d 50 01             	lea    0x1(%eax),%edx
 1c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c9:	89 c2                	mov    %eax,%edx
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	01 c2                	add    %eax,%edx
 1d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1da:	3c 0a                	cmp    $0xa,%al
 1dc:	74 13                	je     1f1 <gets+0x66>
 1de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e2:	3c 0d                	cmp    $0xd,%al
 1e4:	74 0b                	je     1f1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e9:	83 c0 01             	add    $0x1,%eax
 1ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ef:	7c a9                	jl     19a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	01 d0                	add    %edx,%eax
 1f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <stat>:

int
stat(char *n, struct stat *st)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 207:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20e:	00 
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 04 24             	mov    %eax,(%esp)
 215:	e8 07 01 00 00       	call   321 <open>
 21a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 221:	79 07                	jns    22a <stat+0x29>
    return -1;
 223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 228:	eb 23                	jmp    24d <stat+0x4c>
  r = fstat(fd, st);
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 44 24 04          	mov    %eax,0x4(%esp)
 231:	8b 45 f4             	mov    -0xc(%ebp),%eax
 234:	89 04 24             	mov    %eax,(%esp)
 237:	e8 fd 00 00 00       	call   339 <fstat>
 23c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 242:	89 04 24             	mov    %eax,(%esp)
 245:	e8 bf 00 00 00       	call   309 <close>
  return r;
 24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24d:	c9                   	leave  
 24e:	c3                   	ret    

0000024f <atoi>:

int
atoi(const char *s)
{
 24f:	55                   	push   %ebp
 250:	89 e5                	mov    %esp,%ebp
 252:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25c:	eb 25                	jmp    283 <atoi+0x34>
    n = n*10 + *s++ - '0';
 25e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 261:	89 d0                	mov    %edx,%eax
 263:	c1 e0 02             	shl    $0x2,%eax
 266:	01 d0                	add    %edx,%eax
 268:	01 c0                	add    %eax,%eax
 26a:	89 c1                	mov    %eax,%ecx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	8d 50 01             	lea    0x1(%eax),%edx
 272:	89 55 08             	mov    %edx,0x8(%ebp)
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	0f be c0             	movsbl %al,%eax
 27b:	01 c8                	add    %ecx,%eax
 27d:	83 e8 30             	sub    $0x30,%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 00             	movzbl (%eax),%eax
 289:	3c 2f                	cmp    $0x2f,%al
 28b:	7e 0a                	jle    297 <atoi+0x48>
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	0f b6 00             	movzbl (%eax),%eax
 293:	3c 39                	cmp    $0x39,%al
 295:	7e c7                	jle    25e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 297:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ae:	eb 17                	jmp    2c7 <memmove+0x2b>
    *dst++ = *src++;
 2b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b3:	8d 50 01             	lea    0x1(%eax),%edx
 2b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2bc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2bf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c2:	0f b6 12             	movzbl (%edx),%edx
 2c5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c7:	8b 45 10             	mov    0x10(%ebp),%eax
 2ca:	8d 50 ff             	lea    -0x1(%eax),%edx
 2cd:	89 55 10             	mov    %edx,0x10(%ebp)
 2d0:	85 c0                	test   %eax,%eax
 2d2:	7f dc                	jg     2b0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d7:	c9                   	leave  
 2d8:	c3                   	ret    

000002d9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d9:	b8 01 00 00 00       	mov    $0x1,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <exit>:
SYSCALL(exit)
 2e1:	b8 02 00 00 00       	mov    $0x2,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <wait>:
SYSCALL(wait)
 2e9:	b8 03 00 00 00       	mov    $0x3,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <pipe>:
SYSCALL(pipe)
 2f1:	b8 04 00 00 00       	mov    $0x4,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <read>:
SYSCALL(read)
 2f9:	b8 05 00 00 00       	mov    $0x5,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <write>:
SYSCALL(write)
 301:	b8 10 00 00 00       	mov    $0x10,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <close>:
SYSCALL(close)
 309:	b8 15 00 00 00       	mov    $0x15,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <kill>:
SYSCALL(kill)
 311:	b8 06 00 00 00       	mov    $0x6,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <exec>:
SYSCALL(exec)
 319:	b8 07 00 00 00       	mov    $0x7,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <open>:
SYSCALL(open)
 321:	b8 0f 00 00 00       	mov    $0xf,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <mknod>:
SYSCALL(mknod)
 329:	b8 11 00 00 00       	mov    $0x11,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <unlink>:
SYSCALL(unlink)
 331:	b8 12 00 00 00       	mov    $0x12,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <fstat>:
SYSCALL(fstat)
 339:	b8 08 00 00 00       	mov    $0x8,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <link>:
SYSCALL(link)
 341:	b8 13 00 00 00       	mov    $0x13,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <mkdir>:
SYSCALL(mkdir)
 349:	b8 14 00 00 00       	mov    $0x14,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <chdir>:
SYSCALL(chdir)
 351:	b8 09 00 00 00       	mov    $0x9,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <dup>:
SYSCALL(dup)
 359:	b8 0a 00 00 00       	mov    $0xa,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <getpid>:
SYSCALL(getpid)
 361:	b8 0b 00 00 00       	mov    $0xb,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <sbrk>:
SYSCALL(sbrk)
 369:	b8 0c 00 00 00       	mov    $0xc,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <sleep>:
SYSCALL(sleep)
 371:	b8 0d 00 00 00       	mov    $0xd,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <uptime>:
SYSCALL(uptime)
 379:	b8 0e 00 00 00       	mov    $0xe,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 18             	sub    $0x18,%esp
 387:	8b 45 0c             	mov    0xc(%ebp),%eax
 38a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 394:	00 
 395:	8d 45 f4             	lea    -0xc(%ebp),%eax
 398:	89 44 24 04          	mov    %eax,0x4(%esp)
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	89 04 24             	mov    %eax,(%esp)
 3a2:	e8 5a ff ff ff       	call   301 <write>
}
 3a7:	c9                   	leave  
 3a8:	c3                   	ret    

000003a9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
 3ac:	56                   	push   %esi
 3ad:	53                   	push   %ebx
 3ae:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bc:	74 17                	je     3d5 <printint+0x2c>
 3be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c2:	79 11                	jns    3d5 <printint+0x2c>
    neg = 1;
 3c4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ce:	f7 d8                	neg    %eax
 3d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d3:	eb 06                	jmp    3db <printint+0x32>
  } else {
    x = xx;
 3d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e5:	8d 41 01             	lea    0x1(%ecx),%eax
 3e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f1:	ba 00 00 00 00       	mov    $0x0,%edx
 3f6:	f7 f3                	div    %ebx
 3f8:	89 d0                	mov    %edx,%eax
 3fa:	0f b6 80 a0 0a 00 00 	movzbl 0xaa0(%eax),%eax
 401:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 405:	8b 75 10             	mov    0x10(%ebp),%esi
 408:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40b:	ba 00 00 00 00       	mov    $0x0,%edx
 410:	f7 f6                	div    %esi
 412:	89 45 ec             	mov    %eax,-0x14(%ebp)
 415:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 419:	75 c7                	jne    3e2 <printint+0x39>
  if(neg)
 41b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41f:	74 10                	je     431 <printint+0x88>
    buf[i++] = '-';
 421:	8b 45 f4             	mov    -0xc(%ebp),%eax
 424:	8d 50 01             	lea    0x1(%eax),%edx
 427:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 42f:	eb 1f                	jmp    450 <printint+0xa7>
 431:	eb 1d                	jmp    450 <printint+0xa7>
    putc(fd, buf[i]);
 433:	8d 55 dc             	lea    -0x24(%ebp),%edx
 436:	8b 45 f4             	mov    -0xc(%ebp),%eax
 439:	01 d0                	add    %edx,%eax
 43b:	0f b6 00             	movzbl (%eax),%eax
 43e:	0f be c0             	movsbl %al,%eax
 441:	89 44 24 04          	mov    %eax,0x4(%esp)
 445:	8b 45 08             	mov    0x8(%ebp),%eax
 448:	89 04 24             	mov    %eax,(%esp)
 44b:	e8 31 ff ff ff       	call   381 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 450:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 458:	79 d9                	jns    433 <printint+0x8a>
    putc(fd, buf[i]);
}
 45a:	83 c4 30             	add    $0x30,%esp
 45d:	5b                   	pop    %ebx
 45e:	5e                   	pop    %esi
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    

00000461 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 467:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46e:	8d 45 0c             	lea    0xc(%ebp),%eax
 471:	83 c0 04             	add    $0x4,%eax
 474:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 477:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47e:	e9 7c 01 00 00       	jmp    5ff <printf+0x19e>
    c = fmt[i] & 0xff;
 483:	8b 55 0c             	mov    0xc(%ebp),%edx
 486:	8b 45 f0             	mov    -0x10(%ebp),%eax
 489:	01 d0                	add    %edx,%eax
 48b:	0f b6 00             	movzbl (%eax),%eax
 48e:	0f be c0             	movsbl %al,%eax
 491:	25 ff 00 00 00       	and    $0xff,%eax
 496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 499:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49d:	75 2c                	jne    4cb <printf+0x6a>
      if(c == '%'){
 49f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a3:	75 0c                	jne    4b1 <printf+0x50>
        state = '%';
 4a5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ac:	e9 4a 01 00 00       	jmp    5fb <printf+0x19a>
      } else {
        putc(fd, c);
 4b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b4:	0f be c0             	movsbl %al,%eax
 4b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	89 04 24             	mov    %eax,(%esp)
 4c1:	e8 bb fe ff ff       	call   381 <putc>
 4c6:	e9 30 01 00 00       	jmp    5fb <printf+0x19a>
      }
    } else if(state == '%'){
 4cb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cf:	0f 85 26 01 00 00    	jne    5fb <printf+0x19a>
      if(c == 'd'){
 4d5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d9:	75 2d                	jne    508 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4de:	8b 00                	mov    (%eax),%eax
 4e0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e7:	00 
 4e8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4ef:	00 
 4f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	89 04 24             	mov    %eax,(%esp)
 4fa:	e8 aa fe ff ff       	call   3a9 <printint>
        ap++;
 4ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 503:	e9 ec 00 00 00       	jmp    5f4 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 508:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50c:	74 06                	je     514 <printf+0xb3>
 50e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 512:	75 2d                	jne    541 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 514:	8b 45 e8             	mov    -0x18(%ebp),%eax
 517:	8b 00                	mov    (%eax),%eax
 519:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 520:	00 
 521:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 528:	00 
 529:	89 44 24 04          	mov    %eax,0x4(%esp)
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	89 04 24             	mov    %eax,(%esp)
 533:	e8 71 fe ff ff       	call   3a9 <printint>
        ap++;
 538:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53c:	e9 b3 00 00 00       	jmp    5f4 <printf+0x193>
      } else if(c == 's'){
 541:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 545:	75 45                	jne    58c <printf+0x12b>
        s = (char*)*ap;
 547:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54a:	8b 00                	mov    (%eax),%eax
 54c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 553:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 557:	75 09                	jne    562 <printf+0x101>
          s = "(null)";
 559:	c7 45 f4 54 08 00 00 	movl   $0x854,-0xc(%ebp)
        while(*s != 0){
 560:	eb 1e                	jmp    580 <printf+0x11f>
 562:	eb 1c                	jmp    580 <printf+0x11f>
          putc(fd, *s);
 564:	8b 45 f4             	mov    -0xc(%ebp),%eax
 567:	0f b6 00             	movzbl (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	89 44 24 04          	mov    %eax,0x4(%esp)
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	89 04 24             	mov    %eax,(%esp)
 577:	e8 05 fe ff ff       	call   381 <putc>
          s++;
 57c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	0f b6 00             	movzbl (%eax),%eax
 586:	84 c0                	test   %al,%al
 588:	75 da                	jne    564 <printf+0x103>
 58a:	eb 68                	jmp    5f4 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 590:	75 1d                	jne    5af <printf+0x14e>
        putc(fd, *ap);
 592:	8b 45 e8             	mov    -0x18(%ebp),%eax
 595:	8b 00                	mov    (%eax),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	89 44 24 04          	mov    %eax,0x4(%esp)
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	89 04 24             	mov    %eax,(%esp)
 5a4:	e8 d8 fd ff ff       	call   381 <putc>
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ad:	eb 45                	jmp    5f4 <printf+0x193>
      } else if(c == '%'){
 5af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b3:	75 17                	jne    5cc <printf+0x16b>
        putc(fd, c);
 5b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	89 04 24             	mov    %eax,(%esp)
 5c5:	e8 b7 fd ff ff       	call   381 <putc>
 5ca:	eb 28                	jmp    5f4 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d3:	00 
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	89 04 24             	mov    %eax,(%esp)
 5da:	e8 a2 fd ff ff       	call   381 <putc>
        putc(fd, c);
 5df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e2:	0f be c0             	movsbl %al,%eax
 5e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	89 04 24             	mov    %eax,(%esp)
 5ef:	e8 8d fd ff ff       	call   381 <putc>
      }
      state = 0;
 5f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5fb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ff:	8b 55 0c             	mov    0xc(%ebp),%edx
 602:	8b 45 f0             	mov    -0x10(%ebp),%eax
 605:	01 d0                	add    %edx,%eax
 607:	0f b6 00             	movzbl (%eax),%eax
 60a:	84 c0                	test   %al,%al
 60c:	0f 85 71 fe ff ff    	jne    483 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 612:	c9                   	leave  
 613:	c3                   	ret    

00000614 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 614:	55                   	push   %ebp
 615:	89 e5                	mov    %esp,%ebp
 617:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61a:	8b 45 08             	mov    0x8(%ebp),%eax
 61d:	83 e8 08             	sub    $0x8,%eax
 620:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 623:	a1 bc 0a 00 00       	mov    0xabc,%eax
 628:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62b:	eb 24                	jmp    651 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 635:	77 12                	ja     649 <free+0x35>
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63d:	77 24                	ja     663 <free+0x4f>
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8b 00                	mov    (%eax),%eax
 644:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 647:	77 1a                	ja     663 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 657:	76 d4                	jbe    62d <free+0x19>
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 661:	76 ca                	jbe    62d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	8b 40 04             	mov    0x4(%eax),%eax
 669:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	01 c2                	add    %eax,%edx
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	39 c2                	cmp    %eax,%edx
 67c:	75 24                	jne    6a2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	8b 50 04             	mov    0x4(%eax),%edx
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	8b 40 04             	mov    0x4(%eax),%eax
 68c:	01 c2                	add    %eax,%edx
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	8b 10                	mov    (%eax),%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	89 10                	mov    %edx,(%eax)
 6a0:	eb 0a                	jmp    6ac <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 10                	mov    (%eax),%edx
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 40 04             	mov    0x4(%eax),%eax
 6b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	01 d0                	add    %edx,%eax
 6be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c1:	75 20                	jne    6e3 <free+0xcf>
    p->s.size += bp->s.size;
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	8b 50 04             	mov    0x4(%eax),%edx
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	8b 40 04             	mov    0x4(%eax),%eax
 6cf:	01 c2                	add    %eax,%edx
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	8b 10                	mov    (%eax),%edx
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	89 10                	mov    %edx,(%eax)
 6e1:	eb 08                	jmp    6eb <free+0xd7>
  } else
    p->s.ptr = bp;
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	a3 bc 0a 00 00       	mov    %eax,0xabc
}
 6f3:	c9                   	leave  
 6f4:	c3                   	ret    

000006f5 <morecore>:

static Header*
morecore(uint nu)
{
 6f5:	55                   	push   %ebp
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 702:	77 07                	ja     70b <morecore+0x16>
    nu = 4096;
 704:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	c1 e0 03             	shl    $0x3,%eax
 711:	89 04 24             	mov    %eax,(%esp)
 714:	e8 50 fc ff ff       	call   369 <sbrk>
 719:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 71c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 720:	75 07                	jne    729 <morecore+0x34>
    return 0;
 722:	b8 00 00 00 00       	mov    $0x0,%eax
 727:	eb 22                	jmp    74b <morecore+0x56>
  hp = (Header*)p;
 729:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 72f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 732:	8b 55 08             	mov    0x8(%ebp),%edx
 735:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	83 c0 08             	add    $0x8,%eax
 73e:	89 04 24             	mov    %eax,(%esp)
 741:	e8 ce fe ff ff       	call   614 <free>
  return freep;
 746:	a1 bc 0a 00 00       	mov    0xabc,%eax
}
 74b:	c9                   	leave  
 74c:	c3                   	ret    

0000074d <malloc>:

void*
malloc(uint nbytes)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 753:	8b 45 08             	mov    0x8(%ebp),%eax
 756:	83 c0 07             	add    $0x7,%eax
 759:	c1 e8 03             	shr    $0x3,%eax
 75c:	83 c0 01             	add    $0x1,%eax
 75f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 762:	a1 bc 0a 00 00       	mov    0xabc,%eax
 767:	89 45 f0             	mov    %eax,-0x10(%ebp)
 76a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76e:	75 23                	jne    793 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 770:	c7 45 f0 b4 0a 00 00 	movl   $0xab4,-0x10(%ebp)
 777:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77a:	a3 bc 0a 00 00       	mov    %eax,0xabc
 77f:	a1 bc 0a 00 00       	mov    0xabc,%eax
 784:	a3 b4 0a 00 00       	mov    %eax,0xab4
    base.s.size = 0;
 789:	c7 05 b8 0a 00 00 00 	movl   $0x0,0xab8
 790:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a4:	72 4d                	jb     7f3 <malloc+0xa6>
      if(p->s.size == nunits)
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7af:	75 0c                	jne    7bd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	8b 10                	mov    (%eax),%edx
 7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b9:	89 10                	mov    %edx,(%eax)
 7bb:	eb 26                	jmp    7e3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 40 04             	mov    0x4(%eax),%eax
 7c3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7c6:	89 c2                	mov    %eax,%edx
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	c1 e0 03             	shl    $0x3,%eax
 7d7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e6:	a3 bc 0a 00 00       	mov    %eax,0xabc
      return (void*)(p + 1);
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	83 c0 08             	add    $0x8,%eax
 7f1:	eb 38                	jmp    82b <malloc+0xde>
    }
    if(p == freep)
 7f3:	a1 bc 0a 00 00       	mov    0xabc,%eax
 7f8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7fb:	75 1b                	jne    818 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 800:	89 04 24             	mov    %eax,(%esp)
 803:	e8 ed fe ff ff       	call   6f5 <morecore>
 808:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80f:	75 07                	jne    818 <malloc+0xcb>
        return 0;
 811:	b8 00 00 00 00       	mov    $0x0,%eax
 816:	eb 13                	jmp    82b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	8b 00                	mov    (%eax),%eax
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 826:	e9 70 ff ff ff       	jmp    79b <malloc+0x4e>
}
 82b:	c9                   	leave  
 82c:	c3                   	ret    
