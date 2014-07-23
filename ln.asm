
_ln:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 7e 0f 00 00       	push   $0xf7e
  1e:	6a 02                	push   $0x2
  20:	e8 39 04 00 00       	call   45e <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9c 02 00 00       	call   2c9 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e2 02 00 00       	call   329 <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 91 0f 00 00       	push   $0xf91
  65:	6a 02                	push   $0x2
  67:	e8 f2 03 00 00       	call   45e <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 55 02 00 00       	call   2c9 <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	5b                   	pop    %ebx
  96:	5f                   	pop    %edi
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    

00000099 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  99:	55                   	push   %ebp
  9a:	89 e5                	mov    %esp,%ebp
  9c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a5:	90                   	nop
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	8d 50 01             	lea    0x1(%eax),%edx
  ac:	89 55 08             	mov    %edx,0x8(%ebp)
  af:	8b 55 0c             	mov    0xc(%ebp),%edx
  b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  b5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b8:	0f b6 12             	movzbl (%edx),%edx
  bb:	88 10                	mov    %dl,(%eax)
  bd:	0f b6 00             	movzbl (%eax),%eax
  c0:	84 c0                	test   %al,%al
  c2:	75 e2                	jne    a6 <strcpy+0xd>
    ;
  return os;
  c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c7:	c9                   	leave  
  c8:	c3                   	ret    

000000c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c9:	55                   	push   %ebp
  ca:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cc:	eb 08                	jmp    d6 <strcmp+0xd>
    p++, q++;
  ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	74 10                	je     f0 <strcmp+0x27>
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	0f b6 10             	movzbl (%eax),%edx
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	0f b6 00             	movzbl (%eax),%eax
  ec:	38 c2                	cmp    %al,%dl
  ee:	74 de                	je     ce <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	0f b6 d0             	movzbl %al,%edx
  f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	0f b6 c0             	movzbl %al,%eax
 102:	29 c2                	sub    %eax,%edx
 104:	89 d0                	mov    %edx,%eax
}
 106:	5d                   	pop    %ebp
 107:	c3                   	ret    

00000108 <strlen>:

uint
strlen(char *s)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 115:	eb 04                	jmp    11b <strlen+0x13>
 117:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11e:	8b 45 08             	mov    0x8(%ebp),%eax
 121:	01 d0                	add    %edx,%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	84 c0                	test   %al,%al
 128:	75 ed                	jne    117 <strlen+0xf>
    ;
  return n;
 12a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12d:	c9                   	leave  
 12e:	c3                   	ret    

0000012f <memset>:

void*
memset(void *dst, int c, uint n)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 132:	8b 45 10             	mov    0x10(%ebp),%eax
 135:	50                   	push   %eax
 136:	ff 75 0c             	pushl  0xc(%ebp)
 139:	ff 75 08             	pushl  0x8(%ebp)
 13c:	e8 33 ff ff ff       	call   74 <stosb>
 141:	83 c4 0c             	add    $0xc,%esp
  return dst;
 144:	8b 45 08             	mov    0x8(%ebp),%eax
}
 147:	c9                   	leave  
 148:	c3                   	ret    

00000149 <strchr>:

char*
strchr(const char *s, char c)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	83 ec 04             	sub    $0x4,%esp
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 155:	eb 14                	jmp    16b <strchr+0x22>
    if(*s == c)
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	0f b6 00             	movzbl (%eax),%eax
 15d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 160:	75 05                	jne    167 <strchr+0x1e>
      return (char*)s;
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	eb 13                	jmp    17a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 167:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 00             	movzbl (%eax),%eax
 171:	84 c0                	test   %al,%al
 173:	75 e2                	jne    157 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 175:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17a:	c9                   	leave  
 17b:	c3                   	ret    

0000017c <gets>:

char*
gets(char *buf, int max)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 189:	eb 44                	jmp    1cf <gets+0x53>
    cc = read(0, &c, 1);
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	6a 01                	push   $0x1
 190:	8d 45 ef             	lea    -0x11(%ebp),%eax
 193:	50                   	push   %eax
 194:	6a 00                	push   $0x0
 196:	e8 46 01 00 00       	call   2e1 <read>
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a5:	7f 02                	jg     1a9 <gets+0x2d>
      break;
 1a7:	eb 31                	jmp    1da <gets+0x5e>
    buf[i++] = c;
 1a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ac:	8d 50 01             	lea    0x1(%eax),%edx
 1af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b2:	89 c2                	mov    %eax,%edx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	01 c2                	add    %eax,%edx
 1b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	3c 0a                	cmp    $0xa,%al
 1c5:	74 13                	je     1da <gets+0x5e>
 1c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cb:	3c 0d                	cmp    $0xd,%al
 1cd:	74 0b                	je     1da <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d2:	83 c0 01             	add    $0x1,%eax
 1d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d8:	7c b1                	jl     18b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <getcwd>:
SYSCALL(getcwd)
 369:	b8 16 00 00 00       	mov    $0x16,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <shutdown>:
SYSCALL(shutdown)
 371:	b8 17 00 00 00       	mov    $0x17,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <buildinfo>:
SYSCALL(buildinfo)
 379:	b8 18 00 00 00       	mov    $0x18,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <lseek>:
SYSCALL(lseek)
 381:	b8 19 00 00 00       	mov    $0x19,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 18             	sub    $0x18,%esp
 38f:	8b 45 0c             	mov    0xc(%ebp),%eax
 392:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 395:	83 ec 04             	sub    $0x4,%esp
 398:	6a 01                	push   $0x1
 39a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39d:	50                   	push   %eax
 39e:	ff 75 08             	pushl  0x8(%ebp)
 3a1:	e8 43 ff ff ff       	call   2e9 <write>
 3a6:	83 c4 10             	add    $0x10,%esp
}
 3a9:	c9                   	leave  
 3aa:	c3                   	ret    

000003ab <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ab:	55                   	push   %ebp
 3ac:	89 e5                	mov    %esp,%ebp
 3ae:	53                   	push   %ebx
 3af:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bd:	74 17                	je     3d6 <printint+0x2b>
 3bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c3:	79 11                	jns    3d6 <printint+0x2b>
    neg = 1;
 3c5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	f7 d8                	neg    %eax
 3d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d4:	eb 06                	jmp    3dc <printint+0x31>
  } else {
    x = xx;
 3d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e6:	8d 41 01             	lea    0x1(%ecx),%eax
 3e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f2:	ba 00 00 00 00       	mov    $0x0,%edx
 3f7:	f7 f3                	div    %ebx
 3f9:	89 d0                	mov    %edx,%eax
 3fb:	0f b6 80 b8 13 00 00 	movzbl 0x13b8(%eax),%eax
 402:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 406:	8b 5d 10             	mov    0x10(%ebp),%ebx
 409:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40c:	ba 00 00 00 00       	mov    $0x0,%edx
 411:	f7 f3                	div    %ebx
 413:	89 45 ec             	mov    %eax,-0x14(%ebp)
 416:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41a:	75 c7                	jne    3e3 <printint+0x38>
  if(neg)
 41c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 420:	74 0e                	je     430 <printint+0x85>
    buf[i++] = '-';
 422:	8b 45 f4             	mov    -0xc(%ebp),%eax
 425:	8d 50 01             	lea    0x1(%eax),%edx
 428:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 430:	eb 1d                	jmp    44f <printint+0xa4>
    putc(fd, buf[i]);
 432:	8d 55 dc             	lea    -0x24(%ebp),%edx
 435:	8b 45 f4             	mov    -0xc(%ebp),%eax
 438:	01 d0                	add    %edx,%eax
 43a:	0f b6 00             	movzbl (%eax),%eax
 43d:	0f be c0             	movsbl %al,%eax
 440:	83 ec 08             	sub    $0x8,%esp
 443:	50                   	push   %eax
 444:	ff 75 08             	pushl  0x8(%ebp)
 447:	e8 3d ff ff ff       	call   389 <putc>
 44c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 44f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 453:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 457:	79 d9                	jns    432 <printint+0x87>
    putc(fd, buf[i]);
}
 459:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 45c:	c9                   	leave  
 45d:	c3                   	ret    

0000045e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
 461:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 464:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46b:	8d 45 0c             	lea    0xc(%ebp),%eax
 46e:	83 c0 04             	add    $0x4,%eax
 471:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 474:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47b:	e9 59 01 00 00       	jmp    5d9 <printf+0x17b>
    c = fmt[i] & 0xff;
 480:	8b 55 0c             	mov    0xc(%ebp),%edx
 483:	8b 45 f0             	mov    -0x10(%ebp),%eax
 486:	01 d0                	add    %edx,%eax
 488:	0f b6 00             	movzbl (%eax),%eax
 48b:	0f be c0             	movsbl %al,%eax
 48e:	25 ff 00 00 00       	and    $0xff,%eax
 493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 496:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49a:	75 2c                	jne    4c8 <printf+0x6a>
      if(c == '%'){
 49c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a0:	75 0c                	jne    4ae <printf+0x50>
        state = '%';
 4a2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a9:	e9 27 01 00 00       	jmp    5d5 <printf+0x177>
      } else {
        putc(fd, c);
 4ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b1:	0f be c0             	movsbl %al,%eax
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	50                   	push   %eax
 4b8:	ff 75 08             	pushl  0x8(%ebp)
 4bb:	e8 c9 fe ff ff       	call   389 <putc>
 4c0:	83 c4 10             	add    $0x10,%esp
 4c3:	e9 0d 01 00 00       	jmp    5d5 <printf+0x177>
      }
    } else if(state == '%'){
 4c8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cc:	0f 85 03 01 00 00    	jne    5d5 <printf+0x177>
      if(c == 'd'){
 4d2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d6:	75 1e                	jne    4f6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4db:	8b 00                	mov    (%eax),%eax
 4dd:	6a 01                	push   $0x1
 4df:	6a 0a                	push   $0xa
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 c1 fe ff ff       	call   3ab <printint>
 4ea:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f1:	e9 d8 00 00 00       	jmp    5ce <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fa:	74 06                	je     502 <printf+0xa4>
 4fc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 500:	75 1e                	jne    520 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 502:	8b 45 e8             	mov    -0x18(%ebp),%eax
 505:	8b 00                	mov    (%eax),%eax
 507:	6a 00                	push   $0x0
 509:	6a 10                	push   $0x10
 50b:	50                   	push   %eax
 50c:	ff 75 08             	pushl  0x8(%ebp)
 50f:	e8 97 fe ff ff       	call   3ab <printint>
 514:	83 c4 10             	add    $0x10,%esp
        ap++;
 517:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51b:	e9 ae 00 00 00       	jmp    5ce <printf+0x170>
      } else if(c == 's'){
 520:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 524:	75 43                	jne    569 <printf+0x10b>
        s = (char*)*ap;
 526:	8b 45 e8             	mov    -0x18(%ebp),%eax
 529:	8b 00                	mov    (%eax),%eax
 52b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 536:	75 07                	jne    53f <printf+0xe1>
          s = "(null)";
 538:	c7 45 f4 a5 0f 00 00 	movl   $0xfa5,-0xc(%ebp)
        while(*s != 0){
 53f:	eb 1c                	jmp    55d <printf+0xff>
          putc(fd, *s);
 541:	8b 45 f4             	mov    -0xc(%ebp),%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	0f be c0             	movsbl %al,%eax
 54a:	83 ec 08             	sub    $0x8,%esp
 54d:	50                   	push   %eax
 54e:	ff 75 08             	pushl  0x8(%ebp)
 551:	e8 33 fe ff ff       	call   389 <putc>
 556:	83 c4 10             	add    $0x10,%esp
          s++;
 559:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 560:	0f b6 00             	movzbl (%eax),%eax
 563:	84 c0                	test   %al,%al
 565:	75 da                	jne    541 <printf+0xe3>
 567:	eb 65                	jmp    5ce <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 569:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56d:	75 1d                	jne    58c <printf+0x12e>
        putc(fd, *ap);
 56f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 572:	8b 00                	mov    (%eax),%eax
 574:	0f be c0             	movsbl %al,%eax
 577:	83 ec 08             	sub    $0x8,%esp
 57a:	50                   	push   %eax
 57b:	ff 75 08             	pushl  0x8(%ebp)
 57e:	e8 06 fe ff ff       	call   389 <putc>
 583:	83 c4 10             	add    $0x10,%esp
        ap++;
 586:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58a:	eb 42                	jmp    5ce <printf+0x170>
      } else if(c == '%'){
 58c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 590:	75 17                	jne    5a9 <printf+0x14b>
        putc(fd, c);
 592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 595:	0f be c0             	movsbl %al,%eax
 598:	83 ec 08             	sub    $0x8,%esp
 59b:	50                   	push   %eax
 59c:	ff 75 08             	pushl  0x8(%ebp)
 59f:	e8 e5 fd ff ff       	call   389 <putc>
 5a4:	83 c4 10             	add    $0x10,%esp
 5a7:	eb 25                	jmp    5ce <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a9:	83 ec 08             	sub    $0x8,%esp
 5ac:	6a 25                	push   $0x25
 5ae:	ff 75 08             	pushl  0x8(%ebp)
 5b1:	e8 d3 fd ff ff       	call   389 <putc>
 5b6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bc:	0f be c0             	movsbl %al,%eax
 5bf:	83 ec 08             	sub    $0x8,%esp
 5c2:	50                   	push   %eax
 5c3:	ff 75 08             	pushl  0x8(%ebp)
 5c6:	e8 be fd ff ff       	call   389 <putc>
 5cb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5df:	01 d0                	add    %edx,%eax
 5e1:	0f b6 00             	movzbl (%eax),%eax
 5e4:	84 c0                	test   %al,%al
 5e6:	0f 85 94 fe ff ff    	jne    480 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ec:	c9                   	leave  
 5ed:	c3                   	ret    

000005ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ee:	55                   	push   %ebp
 5ef:	89 e5                	mov    %esp,%ebp
 5f1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	83 e8 08             	sub    $0x8,%eax
 5fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fd:	a1 d4 13 00 00       	mov    0x13d4,%eax
 602:	89 45 fc             	mov    %eax,-0x4(%ebp)
 605:	eb 24                	jmp    62b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 607:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60f:	77 12                	ja     623 <free+0x35>
 611:	8b 45 f8             	mov    -0x8(%ebp),%eax
 614:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 617:	77 24                	ja     63d <free+0x4f>
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 621:	77 1a                	ja     63d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 631:	76 d4                	jbe    607 <free+0x19>
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63b:	76 ca                	jbe    607 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	8b 40 04             	mov    0x4(%eax),%eax
 643:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	01 c2                	add    %eax,%edx
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	39 c2                	cmp    %eax,%edx
 656:	75 24                	jne    67c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 658:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65b:	8b 50 04             	mov    0x4(%eax),%edx
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	8b 40 04             	mov    0x4(%eax),%eax
 666:	01 c2                	add    %eax,%edx
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 00                	mov    (%eax),%eax
 673:	8b 10                	mov    (%eax),%edx
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	89 10                	mov    %edx,(%eax)
 67a:	eb 0a                	jmp    686 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 10                	mov    (%eax),%edx
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 40 04             	mov    0x4(%eax),%eax
 68c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	01 d0                	add    %edx,%eax
 698:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69b:	75 20                	jne    6bd <free+0xcf>
    p->s.size += bp->s.size;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 50 04             	mov    0x4(%eax),%edx
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	8b 40 04             	mov    0x4(%eax),%eax
 6a9:	01 c2                	add    %eax,%edx
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	8b 10                	mov    (%eax),%edx
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	89 10                	mov    %edx,(%eax)
 6bb:	eb 08                	jmp    6c5 <free+0xd7>
  } else
    p->s.ptr = bp;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	a3 d4 13 00 00       	mov    %eax,0x13d4
}
 6cd:	c9                   	leave  
 6ce:	c3                   	ret    

000006cf <morecore>:

static Header*
morecore(uint nu)
{
 6cf:	55                   	push   %ebp
 6d0:	89 e5                	mov    %esp,%ebp
 6d2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6dc:	77 07                	ja     6e5 <morecore+0x16>
    nu = 4096;
 6de:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	c1 e0 03             	shl    $0x3,%eax
 6eb:	83 ec 0c             	sub    $0xc,%esp
 6ee:	50                   	push   %eax
 6ef:	e8 5d fc ff ff       	call   351 <sbrk>
 6f4:	83 c4 10             	add    $0x10,%esp
 6f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fa:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fe:	75 07                	jne    707 <morecore+0x38>
    return 0;
 700:	b8 00 00 00 00       	mov    $0x0,%eax
 705:	eb 26                	jmp    72d <morecore+0x5e>
  hp = (Header*)p;
 707:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 70d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 710:	8b 55 08             	mov    0x8(%ebp),%edx
 713:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 716:	8b 45 f0             	mov    -0x10(%ebp),%eax
 719:	83 c0 08             	add    $0x8,%eax
 71c:	83 ec 0c             	sub    $0xc,%esp
 71f:	50                   	push   %eax
 720:	e8 c9 fe ff ff       	call   5ee <free>
 725:	83 c4 10             	add    $0x10,%esp
  return freep;
 728:	a1 d4 13 00 00       	mov    0x13d4,%eax
}
 72d:	c9                   	leave  
 72e:	c3                   	ret    

0000072f <malloc>:

void*
malloc(uint nbytes)
{
 72f:	55                   	push   %ebp
 730:	89 e5                	mov    %esp,%ebp
 732:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	83 c0 07             	add    $0x7,%eax
 73b:	c1 e8 03             	shr    $0x3,%eax
 73e:	83 c0 01             	add    $0x1,%eax
 741:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 744:	a1 d4 13 00 00       	mov    0x13d4,%eax
 749:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 750:	75 23                	jne    775 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 752:	c7 45 f0 cc 13 00 00 	movl   $0x13cc,-0x10(%ebp)
 759:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75c:	a3 d4 13 00 00       	mov    %eax,0x13d4
 761:	a1 d4 13 00 00       	mov    0x13d4,%eax
 766:	a3 cc 13 00 00       	mov    %eax,0x13cc
    base.s.size = 0;
 76b:	c7 05 d0 13 00 00 00 	movl   $0x0,0x13d0
 772:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8b 40 04             	mov    0x4(%eax),%eax
 783:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 786:	72 4d                	jb     7d5 <malloc+0xa6>
      if(p->s.size == nunits)
 788:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 791:	75 0c                	jne    79f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 26                	jmp    7c5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a8:	89 c2                	mov    %eax,%edx
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	c1 e0 03             	shl    $0x3,%eax
 7b9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	a3 d4 13 00 00       	mov    %eax,0x13d4
      return (void*)(p + 1);
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	83 c0 08             	add    $0x8,%eax
 7d3:	eb 3b                	jmp    810 <malloc+0xe1>
    }
    if(p == freep)
 7d5:	a1 d4 13 00 00       	mov    0x13d4,%eax
 7da:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7dd:	75 1e                	jne    7fd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7df:	83 ec 0c             	sub    $0xc,%esp
 7e2:	ff 75 ec             	pushl  -0x14(%ebp)
 7e5:	e8 e5 fe ff ff       	call   6cf <morecore>
 7ea:	83 c4 10             	add    $0x10,%esp
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f4:	75 07                	jne    7fd <malloc+0xce>
        return 0;
 7f6:	b8 00 00 00 00       	mov    $0x0,%eax
 7fb:	eb 13                	jmp    810 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	89 45 f0             	mov    %eax,-0x10(%ebp)
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 00                	mov    (%eax),%eax
 808:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 80b:	e9 6d ff ff ff       	jmp    77d <malloc+0x4e>
}
 810:	c9                   	leave  
 811:	c3                   	ret    

00000812 <isspace>:

#include "common.h"

int isspace(char c) {
 812:	55                   	push   %ebp
 813:	89 e5                	mov    %esp,%ebp
 815:	83 ec 04             	sub    $0x4,%esp
 818:	8b 45 08             	mov    0x8(%ebp),%eax
 81b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 81e:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 822:	74 12                	je     836 <isspace+0x24>
 824:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 828:	74 0c                	je     836 <isspace+0x24>
 82a:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 82e:	74 06                	je     836 <isspace+0x24>
 830:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 834:	75 07                	jne    83d <isspace+0x2b>
 836:	b8 01 00 00 00       	mov    $0x1,%eax
 83b:	eb 05                	jmp    842 <isspace+0x30>
 83d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 842:	c9                   	leave  
 843:	c3                   	ret    

00000844 <readln>:

char* readln(char *buf, int max, int fd)
{
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 84a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 851:	eb 45                	jmp    898 <readln+0x54>
    cc = read(fd, &c, 1);
 853:	83 ec 04             	sub    $0x4,%esp
 856:	6a 01                	push   $0x1
 858:	8d 45 ef             	lea    -0x11(%ebp),%eax
 85b:	50                   	push   %eax
 85c:	ff 75 10             	pushl  0x10(%ebp)
 85f:	e8 7d fa ff ff       	call   2e1 <read>
 864:	83 c4 10             	add    $0x10,%esp
 867:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 86a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86e:	7f 02                	jg     872 <readln+0x2e>
      break;
 870:	eb 31                	jmp    8a3 <readln+0x5f>
    buf[i++] = c;
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8d 50 01             	lea    0x1(%eax),%edx
 878:	89 55 f4             	mov    %edx,-0xc(%ebp)
 87b:	89 c2                	mov    %eax,%edx
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
 880:	01 c2                	add    %eax,%edx
 882:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 886:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 888:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 88c:	3c 0a                	cmp    $0xa,%al
 88e:	74 13                	je     8a3 <readln+0x5f>
 890:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 894:	3c 0d                	cmp    $0xd,%al
 896:	74 0b                	je     8a3 <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	83 c0 01             	add    $0x1,%eax
 89e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 8a1:	7c b0                	jl     853 <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 8a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8a6:	8b 45 08             	mov    0x8(%ebp),%eax
 8a9:	01 d0                	add    %edx,%eax
 8ab:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 8ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8b1:	c9                   	leave  
 8b2:	c3                   	ret    

000008b3 <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 8b3:	55                   	push   %ebp
 8b4:	89 e5                	mov    %esp,%ebp
 8b6:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8c0:	eb 19                	jmp    8db <strncpy+0x28>
		dest[i] = src[i];
 8c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8c5:	8b 45 08             	mov    0x8(%ebp),%eax
 8c8:	01 c2                	add    %eax,%edx
 8ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 8cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d0:	01 c8                	add    %ecx,%eax
 8d2:	0f b6 00             	movzbl (%eax),%eax
 8d5:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8de:	3b 45 10             	cmp    0x10(%ebp),%eax
 8e1:	7d 0f                	jge    8f2 <strncpy+0x3f>
 8e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 8e9:	01 d0                	add    %edx,%eax
 8eb:	0f b6 00             	movzbl (%eax),%eax
 8ee:	84 c0                	test   %al,%al
 8f0:	75 d0                	jne    8c2 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 8f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8f5:	c9                   	leave  
 8f6:	c3                   	ret    

000008f7 <trim>:

char* trim(char* orig) {
 8f7:	55                   	push   %ebp
 8f8:	89 e5                	mov    %esp,%ebp
 8fa:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 8fd:	8b 45 08             	mov    0x8(%ebp),%eax
 900:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 903:	8b 45 08             	mov    0x8(%ebp),%eax
 906:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 909:	eb 04                	jmp    90f <trim+0x18>
 90b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 90f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 912:	0f b6 00             	movzbl (%eax),%eax
 915:	0f be c0             	movsbl %al,%eax
 918:	50                   	push   %eax
 919:	e8 f4 fe ff ff       	call   812 <isspace>
 91e:	83 c4 04             	add    $0x4,%esp
 921:	85 c0                	test   %eax,%eax
 923:	75 e6                	jne    90b <trim+0x14>
	while (*tail) { tail++; }
 925:	eb 04                	jmp    92b <trim+0x34>
 927:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 92b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92e:	0f b6 00             	movzbl (%eax),%eax
 931:	84 c0                	test   %al,%al
 933:	75 f2                	jne    927 <trim+0x30>
	do { tail--; } while (isspace(*tail));
 935:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 939:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93c:	0f b6 00             	movzbl (%eax),%eax
 93f:	0f be c0             	movsbl %al,%eax
 942:	50                   	push   %eax
 943:	e8 ca fe ff ff       	call   812 <isspace>
 948:	83 c4 04             	add    $0x4,%esp
 94b:	85 c0                	test   %eax,%eax
 94d:	75 e6                	jne    935 <trim+0x3e>
	new = malloc(tail-head+2);
 94f:	8b 55 f0             	mov    -0x10(%ebp),%edx
 952:	8b 45 f4             	mov    -0xc(%ebp),%eax
 955:	29 c2                	sub    %eax,%edx
 957:	89 d0                	mov    %edx,%eax
 959:	83 c0 02             	add    $0x2,%eax
 95c:	83 ec 0c             	sub    $0xc,%esp
 95f:	50                   	push   %eax
 960:	e8 ca fd ff ff       	call   72f <malloc>
 965:	83 c4 10             	add    $0x10,%esp
 968:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 96b:	8b 55 f0             	mov    -0x10(%ebp),%edx
 96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 971:	29 c2                	sub    %eax,%edx
 973:	89 d0                	mov    %edx,%eax
 975:	83 c0 01             	add    $0x1,%eax
 978:	83 ec 04             	sub    $0x4,%esp
 97b:	50                   	push   %eax
 97c:	ff 75 f4             	pushl  -0xc(%ebp)
 97f:	ff 75 ec             	pushl  -0x14(%ebp)
 982:	e8 2c ff ff ff       	call   8b3 <strncpy>
 987:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 98a:	8b 55 f0             	mov    -0x10(%ebp),%edx
 98d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 990:	29 c2                	sub    %eax,%edx
 992:	89 d0                	mov    %edx,%eax
 994:	8d 50 01             	lea    0x1(%eax),%edx
 997:	8b 45 ec             	mov    -0x14(%ebp),%eax
 99a:	01 d0                	add    %edx,%eax
 99c:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 99f:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 9a2:	c9                   	leave  
 9a3:	c3                   	ret    

000009a4 <itoa>:

char *
itoa(int value)
{
 9a4:	55                   	push   %ebp
 9a5:	89 e5                	mov    %esp,%ebp
 9a7:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 9aa:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 9b0:	8b 45 08             	mov    0x8(%ebp),%eax
 9b3:	c1 e8 1f             	shr    $0x1f,%eax
 9b6:	0f b6 c0             	movzbl %al,%eax
 9b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 9bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 9c0:	74 0a                	je     9cc <itoa+0x28>
    v = -value;
 9c2:	8b 45 08             	mov    0x8(%ebp),%eax
 9c5:	f7 d8                	neg    %eax
 9c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ca:	eb 06                	jmp    9d2 <itoa+0x2e>
  else
    v = (uint)value;
 9cc:	8b 45 08             	mov    0x8(%ebp),%eax
 9cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 9d2:	eb 5b                	jmp    a2f <itoa+0x8b>
  {
    i = v % 10;
 9d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 9d7:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9dc:	89 c8                	mov    %ecx,%eax
 9de:	f7 e2                	mul    %edx
 9e0:	c1 ea 03             	shr    $0x3,%edx
 9e3:	89 d0                	mov    %edx,%eax
 9e5:	c1 e0 02             	shl    $0x2,%eax
 9e8:	01 d0                	add    %edx,%eax
 9ea:	01 c0                	add    %eax,%eax
 9ec:	29 c1                	sub    %eax,%ecx
 9ee:	89 ca                	mov    %ecx,%edx
 9f0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 9f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f6:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9fb:	f7 e2                	mul    %edx
 9fd:	89 d0                	mov    %edx,%eax
 9ff:	c1 e8 03             	shr    $0x3,%eax
 a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 a05:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 a09:	7f 13                	jg     a1e <itoa+0x7a>
      *tp++ = i+'0';
 a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0e:	8d 50 01             	lea    0x1(%eax),%edx
 a11:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a17:	83 c2 30             	add    $0x30,%edx
 a1a:	88 10                	mov    %dl,(%eax)
 a1c:	eb 11                	jmp    a2f <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a21:	8d 50 01             	lea    0x1(%eax),%edx
 a24:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a2a:	83 c2 57             	add    $0x57,%edx
 a2d:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 a2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a33:	75 9f                	jne    9d4 <itoa+0x30>
 a35:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a38:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a3b:	74 97                	je     9d4 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a40:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a43:	29 c2                	sub    %eax,%edx
 a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a48:	01 d0                	add    %edx,%eax
 a4a:	83 c0 01             	add    $0x1,%eax
 a4d:	83 ec 0c             	sub    $0xc,%esp
 a50:	50                   	push   %eax
 a51:	e8 d9 fc ff ff       	call   72f <malloc>
 a56:	83 c4 10             	add    $0x10,%esp
 a59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a5f:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a62:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a66:	74 0c                	je     a74 <itoa+0xd0>
    *sp++ = '-';
 a68:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a6b:	8d 50 01             	lea    0x1(%eax),%edx
 a6e:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a71:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a74:	eb 15                	jmp    a8b <itoa+0xe7>
    *sp++ = *--tp;
 a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a79:	8d 50 01             	lea    0x1(%eax),%edx
 a7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a7f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a86:	0f b6 12             	movzbl (%edx),%edx
 a89:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 a8b:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a8e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a91:	77 e3                	ja     a76 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a96:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 a99:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 a9c:	c9                   	leave  
 a9d:	c3                   	ret    

00000a9e <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 a9e:	55                   	push   %ebp
 a9f:	89 e5                	mov    %esp,%ebp
 aa1:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 aa7:	83 ec 08             	sub    $0x8,%esp
 aaa:	6a 00                	push   $0x0
 aac:	ff 75 08             	pushl  0x8(%ebp)
 aaf:	e8 55 f8 ff ff       	call   309 <open>
 ab4:	83 c4 10             	add    $0x10,%esp
 ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 aba:	e9 22 01 00 00       	jmp    be1 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 abf:	83 ec 08             	sub    $0x8,%esp
 ac2:	6a 3d                	push   $0x3d
 ac4:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 aca:	50                   	push   %eax
 acb:	e8 79 f6 ff ff       	call   149 <strchr>
 ad0:	83 c4 10             	add    $0x10,%esp
 ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 ad6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ada:	0f 84 23 01 00 00    	je     c03 <parseEnvFile+0x165>
 ae0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ae4:	0f 84 19 01 00 00    	je     c03 <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
 aed:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 af3:	29 c2                	sub    %eax,%edx
 af5:	89 d0                	mov    %edx,%eax
 af7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 afd:	83 c0 01             	add    $0x1,%eax
 b00:	83 ec 0c             	sub    $0xc,%esp
 b03:	50                   	push   %eax
 b04:	e8 26 fc ff ff       	call   72f <malloc>
 b09:	83 c4 10             	add    $0x10,%esp
 b0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 b0f:	83 ec 04             	sub    $0x4,%esp
 b12:	ff 75 ec             	pushl  -0x14(%ebp)
 b15:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b1b:	50                   	push   %eax
 b1c:	ff 75 e8             	pushl  -0x18(%ebp)
 b1f:	e8 8f fd ff ff       	call   8b3 <strncpy>
 b24:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 b27:	83 ec 0c             	sub    $0xc,%esp
 b2a:	ff 75 e8             	pushl  -0x18(%ebp)
 b2d:	e8 c5 fd ff ff       	call   8f7 <trim>
 b32:	83 c4 10             	add    $0x10,%esp
 b35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 b38:	83 ec 0c             	sub    $0xc,%esp
 b3b:	ff 75 e8             	pushl  -0x18(%ebp)
 b3e:	e8 ab fa ff ff       	call   5ee <free>
 b43:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 b46:	83 ec 08             	sub    $0x8,%esp
 b49:	ff 75 0c             	pushl  0xc(%ebp)
 b4c:	ff 75 e4             	pushl  -0x1c(%ebp)
 b4f:	e8 c2 01 00 00       	call   d16 <addToEnvironment>
 b54:	83 c4 10             	add    $0x10,%esp
 b57:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b5a:	83 ec 0c             	sub    $0xc,%esp
 b5d:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b63:	50                   	push   %eax
 b64:	e8 9f f5 ff ff       	call   108 <strlen>
 b69:	83 c4 10             	add    $0x10,%esp
 b6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b72:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b75:	83 ec 0c             	sub    $0xc,%esp
 b78:	50                   	push   %eax
 b79:	e8 b1 fb ff ff       	call   72f <malloc>
 b7e:	83 c4 10             	add    $0x10,%esp
 b81:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b87:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b8a:	8d 50 ff             	lea    -0x1(%eax),%edx
 b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b90:	8d 48 01             	lea    0x1(%eax),%ecx
 b93:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b99:	01 c8                	add    %ecx,%eax
 b9b:	83 ec 04             	sub    $0x4,%esp
 b9e:	52                   	push   %edx
 b9f:	50                   	push   %eax
 ba0:	ff 75 e8             	pushl  -0x18(%ebp)
 ba3:	e8 0b fd ff ff       	call   8b3 <strncpy>
 ba8:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 bab:	83 ec 0c             	sub    $0xc,%esp
 bae:	ff 75 e8             	pushl  -0x18(%ebp)
 bb1:	e8 41 fd ff ff       	call   8f7 <trim>
 bb6:	83 c4 10             	add    $0x10,%esp
 bb9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 bbc:	83 ec 0c             	sub    $0xc,%esp
 bbf:	ff 75 e8             	pushl  -0x18(%ebp)
 bc2:	e8 27 fa ff ff       	call   5ee <free>
 bc7:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 bca:	83 ec 04             	sub    $0x4,%esp
 bcd:	ff 75 dc             	pushl  -0x24(%ebp)
 bd0:	ff 75 0c             	pushl  0xc(%ebp)
 bd3:	ff 75 e4             	pushl  -0x1c(%ebp)
 bd6:	e8 b8 01 00 00       	call   d93 <addValueToVariable>
 bdb:	83 c4 10             	add    $0x10,%esp
 bde:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 be1:	83 ec 04             	sub    $0x4,%esp
 be4:	ff 75 f4             	pushl  -0xc(%ebp)
 be7:	68 00 04 00 00       	push   $0x400
 bec:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 bf2:	50                   	push   %eax
 bf3:	e8 4c fc ff ff       	call   844 <readln>
 bf8:	83 c4 10             	add    $0x10,%esp
 bfb:	85 c0                	test   %eax,%eax
 bfd:	0f 85 bc fe ff ff    	jne    abf <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 c03:	83 ec 0c             	sub    $0xc,%esp
 c06:	ff 75 f4             	pushl  -0xc(%ebp)
 c09:	e8 e3 f6 ff ff       	call   2f1 <close>
 c0e:	83 c4 10             	add    $0x10,%esp
	return head;
 c11:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c14:	c9                   	leave  
 c15:	c3                   	ret    

00000c16 <comp>:

int comp(const char* s1, const char* s2)
{
 c16:	55                   	push   %ebp
 c17:	89 e5                	mov    %esp,%ebp
 c19:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 c1c:	83 ec 08             	sub    $0x8,%esp
 c1f:	ff 75 0c             	pushl  0xc(%ebp)
 c22:	ff 75 08             	pushl  0x8(%ebp)
 c25:	e8 9f f4 ff ff       	call   c9 <strcmp>
 c2a:	83 c4 10             	add    $0x10,%esp
 c2d:	85 c0                	test   %eax,%eax
 c2f:	0f 94 c0             	sete   %al
 c32:	0f b6 c0             	movzbl %al,%eax
}
 c35:	c9                   	leave  
 c36:	c3                   	ret    

00000c37 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 c37:	55                   	push   %ebp
 c38:	89 e5                	mov    %esp,%ebp
 c3a:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 c3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c41:	75 07                	jne    c4a <environLookup+0x13>
    return NULL;
 c43:	b8 00 00 00 00       	mov    $0x0,%eax
 c48:	eb 2f                	jmp    c79 <environLookup+0x42>
  
  while (head)
 c4a:	eb 24                	jmp    c70 <environLookup+0x39>
  {
    if (comp(name, head->name))
 c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
 c4f:	83 ec 08             	sub    $0x8,%esp
 c52:	50                   	push   %eax
 c53:	ff 75 08             	pushl  0x8(%ebp)
 c56:	e8 bb ff ff ff       	call   c16 <comp>
 c5b:	83 c4 10             	add    $0x10,%esp
 c5e:	85 c0                	test   %eax,%eax
 c60:	74 02                	je     c64 <environLookup+0x2d>
      break;
 c62:	eb 12                	jmp    c76 <environLookup+0x3f>
    head = head->next;
 c64:	8b 45 0c             	mov    0xc(%ebp),%eax
 c67:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c6d:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c74:	75 d6                	jne    c4c <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c76:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c79:	c9                   	leave  
 c7a:	c3                   	ret    

00000c7b <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c7b:	55                   	push   %ebp
 c7c:	89 e5                	mov    %esp,%ebp
 c7e:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c85:	75 0a                	jne    c91 <removeFromEnvironment+0x16>
    return NULL;
 c87:	b8 00 00 00 00       	mov    $0x0,%eax
 c8c:	e9 83 00 00 00       	jmp    d14 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 c91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c95:	74 0a                	je     ca1 <removeFromEnvironment+0x26>
 c97:	8b 45 08             	mov    0x8(%ebp),%eax
 c9a:	0f b6 00             	movzbl (%eax),%eax
 c9d:	84 c0                	test   %al,%al
 c9f:	75 05                	jne    ca6 <removeFromEnvironment+0x2b>
    return head;
 ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
 ca4:	eb 6e                	jmp    d14 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
 ca9:	83 ec 08             	sub    $0x8,%esp
 cac:	ff 75 08             	pushl  0x8(%ebp)
 caf:	50                   	push   %eax
 cb0:	e8 61 ff ff ff       	call   c16 <comp>
 cb5:	83 c4 10             	add    $0x10,%esp
 cb8:	85 c0                	test   %eax,%eax
 cba:	74 34                	je     cf0 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
 cbf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
 ccb:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 cd1:	83 ec 0c             	sub    $0xc,%esp
 cd4:	50                   	push   %eax
 cd5:	e8 74 01 00 00       	call   e4e <freeVarval>
 cda:	83 c4 10             	add    $0x10,%esp
    free(head);
 cdd:	83 ec 0c             	sub    $0xc,%esp
 ce0:	ff 75 0c             	pushl  0xc(%ebp)
 ce3:	e8 06 f9 ff ff       	call   5ee <free>
 ce8:	83 c4 10             	add    $0x10,%esp
    return tmp;
 ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cee:	eb 24                	jmp    d14 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
 cf3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cf9:	83 ec 08             	sub    $0x8,%esp
 cfc:	50                   	push   %eax
 cfd:	ff 75 08             	pushl  0x8(%ebp)
 d00:	e8 76 ff ff ff       	call   c7b <removeFromEnvironment>
 d05:	83 c4 10             	add    $0x10,%esp
 d08:	8b 55 0c             	mov    0xc(%ebp),%edx
 d0b:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 d11:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d14:	c9                   	leave  
 d15:	c3                   	ret    

00000d16 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 d16:	55                   	push   %ebp
 d17:	89 e5                	mov    %esp,%ebp
 d19:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 d1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 d20:	75 05                	jne    d27 <addToEnvironment+0x11>
		return head;
 d22:	8b 45 0c             	mov    0xc(%ebp),%eax
 d25:	eb 6a                	jmp    d91 <addToEnvironment+0x7b>
	if (head == NULL) {
 d27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 d2b:	75 40                	jne    d6d <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 d2d:	83 ec 0c             	sub    $0xc,%esp
 d30:	68 88 00 00 00       	push   $0x88
 d35:	e8 f5 f9 ff ff       	call   72f <malloc>
 d3a:	83 c4 10             	add    $0x10,%esp
 d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 d40:	8b 45 08             	mov    0x8(%ebp),%eax
 d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d49:	83 ec 08             	sub    $0x8,%esp
 d4c:	ff 75 f0             	pushl  -0x10(%ebp)
 d4f:	50                   	push   %eax
 d50:	e8 44 f3 ff ff       	call   99 <strcpy>
 d55:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d62:	00 00 00 
		head = newVar;
 d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d68:	89 45 0c             	mov    %eax,0xc(%ebp)
 d6b:	eb 21                	jmp    d8e <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
 d70:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d76:	83 ec 08             	sub    $0x8,%esp
 d79:	50                   	push   %eax
 d7a:	ff 75 08             	pushl  0x8(%ebp)
 d7d:	e8 94 ff ff ff       	call   d16 <addToEnvironment>
 d82:	83 c4 10             	add    $0x10,%esp
 d85:	8b 55 0c             	mov    0xc(%ebp),%edx
 d88:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d91:	c9                   	leave  
 d92:	c3                   	ret    

00000d93 <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 d93:	55                   	push   %ebp
 d94:	89 e5                	mov    %esp,%ebp
 d96:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 d99:	83 ec 08             	sub    $0x8,%esp
 d9c:	ff 75 0c             	pushl  0xc(%ebp)
 d9f:	ff 75 08             	pushl  0x8(%ebp)
 da2:	e8 90 fe ff ff       	call   c37 <environLookup>
 da7:	83 c4 10             	add    $0x10,%esp
 daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 dad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 db1:	75 05                	jne    db8 <addValueToVariable+0x25>
		return head;
 db3:	8b 45 0c             	mov    0xc(%ebp),%eax
 db6:	eb 4c                	jmp    e04 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 db8:	83 ec 0c             	sub    $0xc,%esp
 dbb:	68 04 04 00 00       	push   $0x404
 dc0:	e8 6a f9 ff ff       	call   72f <malloc>
 dc5:	83 c4 10             	add    $0x10,%esp
 dc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 dcb:	8b 45 10             	mov    0x10(%ebp),%eax
 dce:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dd4:	83 ec 08             	sub    $0x8,%esp
 dd7:	ff 75 ec             	pushl  -0x14(%ebp)
 dda:	50                   	push   %eax
 ddb:	e8 b9 f2 ff ff       	call   99 <strcpy>
 de0:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de6:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 def:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df8:	8b 55 f0             	mov    -0x10(%ebp),%edx
 dfb:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 e01:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 e04:	c9                   	leave  
 e05:	c3                   	ret    

00000e06 <freeEnvironment>:

void freeEnvironment(variable* head)
{
 e06:	55                   	push   %ebp
 e07:	89 e5                	mov    %esp,%ebp
 e09:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e10:	75 02                	jne    e14 <freeEnvironment+0xe>
    return;  
 e12:	eb 38                	jmp    e4c <freeEnvironment+0x46>
  freeEnvironment(head->next);
 e14:	8b 45 08             	mov    0x8(%ebp),%eax
 e17:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 e1d:	83 ec 0c             	sub    $0xc,%esp
 e20:	50                   	push   %eax
 e21:	e8 e0 ff ff ff       	call   e06 <freeEnvironment>
 e26:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 e29:	8b 45 08             	mov    0x8(%ebp),%eax
 e2c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 e32:	83 ec 0c             	sub    $0xc,%esp
 e35:	50                   	push   %eax
 e36:	e8 13 00 00 00       	call   e4e <freeVarval>
 e3b:	83 c4 10             	add    $0x10,%esp
  free(head);
 e3e:	83 ec 0c             	sub    $0xc,%esp
 e41:	ff 75 08             	pushl  0x8(%ebp)
 e44:	e8 a5 f7 ff ff       	call   5ee <free>
 e49:	83 c4 10             	add    $0x10,%esp
}
 e4c:	c9                   	leave  
 e4d:	c3                   	ret    

00000e4e <freeVarval>:

void freeVarval(varval* head)
{
 e4e:	55                   	push   %ebp
 e4f:	89 e5                	mov    %esp,%ebp
 e51:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e58:	75 02                	jne    e5c <freeVarval+0xe>
    return;  
 e5a:	eb 23                	jmp    e7f <freeVarval+0x31>
  freeVarval(head->next);
 e5c:	8b 45 08             	mov    0x8(%ebp),%eax
 e5f:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e65:	83 ec 0c             	sub    $0xc,%esp
 e68:	50                   	push   %eax
 e69:	e8 e0 ff ff ff       	call   e4e <freeVarval>
 e6e:	83 c4 10             	add    $0x10,%esp
  free(head);
 e71:	83 ec 0c             	sub    $0xc,%esp
 e74:	ff 75 08             	pushl  0x8(%ebp)
 e77:	e8 72 f7 ff ff       	call   5ee <free>
 e7c:	83 c4 10             	add    $0x10,%esp
}
 e7f:	c9                   	leave  
 e80:	c3                   	ret    

00000e81 <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e81:	55                   	push   %ebp
 e82:	89 e5                	mov    %esp,%ebp
 e84:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 e87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e8b:	75 08                	jne    e95 <getPaths+0x14>
		return head;
 e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
 e90:	e9 e7 00 00 00       	jmp    f7c <getPaths+0xfb>
	if (head == NULL) {
 e95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 e99:	0f 85 b9 00 00 00    	jne    f58 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 e9f:	83 ec 08             	sub    $0x8,%esp
 ea2:	6a 3a                	push   $0x3a
 ea4:	ff 75 08             	pushl  0x8(%ebp)
 ea7:	e8 9d f2 ff ff       	call   149 <strchr>
 eac:	83 c4 10             	add    $0x10,%esp
 eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 eb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 eb6:	75 56                	jne    f0e <getPaths+0x8d>
			pathLen = strlen(paths);
 eb8:	83 ec 0c             	sub    $0xc,%esp
 ebb:	ff 75 08             	pushl  0x8(%ebp)
 ebe:	e8 45 f2 ff ff       	call   108 <strlen>
 ec3:	83 c4 10             	add    $0x10,%esp
 ec6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 ec9:	83 ec 0c             	sub    $0xc,%esp
 ecc:	68 04 04 00 00       	push   $0x404
 ed1:	e8 59 f8 ff ff       	call   72f <malloc>
 ed6:	83 c4 10             	add    $0x10,%esp
 ed9:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 edc:	8b 45 0c             	mov    0xc(%ebp),%eax
 edf:	83 ec 04             	sub    $0x4,%esp
 ee2:	ff 75 f0             	pushl  -0x10(%ebp)
 ee5:	ff 75 08             	pushl  0x8(%ebp)
 ee8:	50                   	push   %eax
 ee9:	e8 c5 f9 ff ff       	call   8b3 <strncpy>
 eee:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 ef1:	8b 55 0c             	mov    0xc(%ebp),%edx
 ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ef7:	01 d0                	add    %edx,%eax
 ef9:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 efc:	8b 45 0c             	mov    0xc(%ebp),%eax
 eff:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 f06:	00 00 00 
			return head;
 f09:	8b 45 0c             	mov    0xc(%ebp),%eax
 f0c:	eb 6e                	jmp    f7c <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 f11:	8b 45 08             	mov    0x8(%ebp),%eax
 f14:	29 c2                	sub    %eax,%edx
 f16:	89 d0                	mov    %edx,%eax
 f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 f1b:	83 ec 0c             	sub    $0xc,%esp
 f1e:	68 04 04 00 00       	push   $0x404
 f23:	e8 07 f8 ff ff       	call   72f <malloc>
 f28:	83 c4 10             	add    $0x10,%esp
 f2b:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
 f31:	83 ec 04             	sub    $0x4,%esp
 f34:	ff 75 f0             	pushl  -0x10(%ebp)
 f37:	ff 75 08             	pushl  0x8(%ebp)
 f3a:	50                   	push   %eax
 f3b:	e8 73 f9 ff ff       	call   8b3 <strncpy>
 f40:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f43:	8b 55 0c             	mov    0xc(%ebp),%edx
 f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f49:	01 d0                	add    %edx,%eax
 f4b:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f51:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 f54:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f58:	8b 45 0c             	mov    0xc(%ebp),%eax
 f5b:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f61:	83 ec 08             	sub    $0x8,%esp
 f64:	50                   	push   %eax
 f65:	ff 75 08             	pushl  0x8(%ebp)
 f68:	e8 14 ff ff ff       	call   e81 <getPaths>
 f6d:	83 c4 10             	add    $0x10,%esp
 f70:	8b 55 0c             	mov    0xc(%ebp),%edx
 f73:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f79:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f7c:	c9                   	leave  
 f7d:	c3                   	ret    
