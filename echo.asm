
_echo:     формат файла elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 20 08 00 00       	mov    $0x820,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 22 08 00 00       	mov    $0x822,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 24 08 00 	movl   $0x824,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 fb 03 00 00       	call   454 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  67:	e8 68 02 00 00       	call   2d4 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	8d 50 01             	lea    0x1(%eax),%edx
  a4:	89 55 08             	mov    %edx,0x8(%ebp)
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b0:	0f b6 12             	movzbl (%edx),%edx
  b3:	88 10                	mov    %dl,(%eax)
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	84 c0                	test   %al,%al
  ba:	75 e2                	jne    9e <strcpy+0xd>
    ;
  return os;
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c4:	eb 08                	jmp    ce <strcmp+0xd>
    p++, q++;
  c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	0f b6 00             	movzbl (%eax),%eax
  d4:	84 c0                	test   %al,%al
  d6:	74 10                	je     e8 <strcmp+0x27>
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	0f b6 00             	movzbl (%eax),%eax
  e4:	38 c2                	cmp    %al,%dl
  e6:	74 de                	je     c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	0f b6 d0             	movzbl %al,%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 c0             	movzbl %al,%eax
  fa:	29 c2                	sub    %eax,%edx
  fc:	89 d0                	mov    %edx,%eax
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10d:	eb 04                	jmp    113 <strlen+0x13>
 10f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 113:	8b 55 fc             	mov    -0x4(%ebp),%edx
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	01 d0                	add    %edx,%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	84 c0                	test   %al,%al
 120:	75 ed                	jne    10f <strlen+0xf>
    ;
  return n;
 122:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 125:	c9                   	leave  
 126:	c3                   	ret    

00000127 <memset>:

void*
memset(void *dst, int c, uint n)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 12d:	8b 45 10             	mov    0x10(%ebp),%eax
 130:	89 44 24 08          	mov    %eax,0x8(%esp)
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	89 44 24 04          	mov    %eax,0x4(%esp)
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 04 24             	mov    %eax,(%esp)
 141:	e8 26 ff ff ff       	call   6c <stosb>
  return dst;
 146:	8b 45 08             	mov    0x8(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <strchr>:

char*
strchr(const char *s, char c)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	83 ec 04             	sub    $0x4,%esp
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 157:	eb 14                	jmp    16d <strchr+0x22>
    if(*s == c)
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	0f b6 00             	movzbl (%eax),%eax
 15f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 162:	75 05                	jne    169 <strchr+0x1e>
      return (char*)s;
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	eb 13                	jmp    17c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	84 c0                	test   %al,%al
 175:	75 e2                	jne    159 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 177:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <gets>:

char*
gets(char *buf, int max)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18b:	eb 4c                	jmp    1d9 <gets+0x5b>
    cc = read(0, &c, 1);
 18d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 194:	00 
 195:	8d 45 ef             	lea    -0x11(%ebp),%eax
 198:	89 44 24 04          	mov    %eax,0x4(%esp)
 19c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a3:	e8 44 01 00 00       	call   2ec <read>
 1a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1af:	7f 02                	jg     1b3 <gets+0x35>
      break;
 1b1:	eb 31                	jmp    1e4 <gets+0x66>
    buf[i++] = c;
 1b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b6:	8d 50 01             	lea    0x1(%eax),%edx
 1b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1bc:	89 c2                	mov    %eax,%edx
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	01 c2                	add    %eax,%edx
 1c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cd:	3c 0a                	cmp    $0xa,%al
 1cf:	74 13                	je     1e4 <gets+0x66>
 1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 0b                	je     1e4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e2:	7c a9                	jl     18d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	01 d0                	add    %edx,%eax
 1ec:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <stat>:

int
stat(char *n, struct stat *st)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 201:	00 
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	89 04 24             	mov    %eax,(%esp)
 208:	e8 07 01 00 00       	call   314 <open>
 20d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 214:	79 07                	jns    21d <stat+0x29>
    return -1;
 216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21b:	eb 23                	jmp    240 <stat+0x4c>
  r = fstat(fd, st);
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	89 44 24 04          	mov    %eax,0x4(%esp)
 224:	8b 45 f4             	mov    -0xc(%ebp),%eax
 227:	89 04 24             	mov    %eax,(%esp)
 22a:	e8 fd 00 00 00       	call   32c <fstat>
 22f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	89 04 24             	mov    %eax,(%esp)
 238:	e8 bf 00 00 00       	call   2fc <close>
  return r;
 23d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 240:	c9                   	leave  
 241:	c3                   	ret    

00000242 <atoi>:

int
atoi(const char *s)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24f:	eb 25                	jmp    276 <atoi+0x34>
    n = n*10 + *s++ - '0';
 251:	8b 55 fc             	mov    -0x4(%ebp),%edx
 254:	89 d0                	mov    %edx,%eax
 256:	c1 e0 02             	shl    $0x2,%eax
 259:	01 d0                	add    %edx,%eax
 25b:	01 c0                	add    %eax,%eax
 25d:	89 c1                	mov    %eax,%ecx
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 08             	mov    %edx,0x8(%ebp)
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	0f be c0             	movsbl %al,%eax
 26e:	01 c8                	add    %ecx,%eax
 270:	83 e8 30             	sub    $0x30,%eax
 273:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	3c 2f                	cmp    $0x2f,%al
 27e:	7e 0a                	jle    28a <atoi+0x48>
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	3c 39                	cmp    $0x39,%al
 288:	7e c7                	jle    251 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 28a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 29b:	8b 45 0c             	mov    0xc(%ebp),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a1:	eb 17                	jmp    2ba <memmove+0x2b>
    *dst++ = *src++;
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 50 01             	lea    0x1(%eax),%edx
 2a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2af:	8d 4a 01             	lea    0x1(%edx),%ecx
 2b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b5:	0f b6 12             	movzbl (%edx),%edx
 2b8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ba:	8b 45 10             	mov    0x10(%ebp),%eax
 2bd:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c0:	89 55 10             	mov    %edx,0x10(%ebp)
 2c3:	85 c0                	test   %eax,%eax
 2c5:	7f dc                	jg     2a3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cc:	b8 01 00 00 00       	mov    $0x1,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <exit>:
SYSCALL(exit)
 2d4:	b8 02 00 00 00       	mov    $0x2,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <wait>:
SYSCALL(wait)
 2dc:	b8 03 00 00 00       	mov    $0x3,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <pipe>:
SYSCALL(pipe)
 2e4:	b8 04 00 00 00       	mov    $0x4,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <read>:
SYSCALL(read)
 2ec:	b8 05 00 00 00       	mov    $0x5,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <write>:
SYSCALL(write)
 2f4:	b8 10 00 00 00       	mov    $0x10,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <close>:
SYSCALL(close)
 2fc:	b8 15 00 00 00       	mov    $0x15,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <kill>:
SYSCALL(kill)
 304:	b8 06 00 00 00       	mov    $0x6,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <exec>:
SYSCALL(exec)
 30c:	b8 07 00 00 00       	mov    $0x7,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <open>:
SYSCALL(open)
 314:	b8 0f 00 00 00       	mov    $0xf,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <mknod>:
SYSCALL(mknod)
 31c:	b8 11 00 00 00       	mov    $0x11,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <unlink>:
SYSCALL(unlink)
 324:	b8 12 00 00 00       	mov    $0x12,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <fstat>:
SYSCALL(fstat)
 32c:	b8 08 00 00 00       	mov    $0x8,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <link>:
SYSCALL(link)
 334:	b8 13 00 00 00       	mov    $0x13,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <mkdir>:
SYSCALL(mkdir)
 33c:	b8 14 00 00 00       	mov    $0x14,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <chdir>:
SYSCALL(chdir)
 344:	b8 09 00 00 00       	mov    $0x9,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <dup>:
SYSCALL(dup)
 34c:	b8 0a 00 00 00       	mov    $0xa,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <getpid>:
SYSCALL(getpid)
 354:	b8 0b 00 00 00       	mov    $0xb,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <sbrk>:
SYSCALL(sbrk)
 35c:	b8 0c 00 00 00       	mov    $0xc,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <sleep>:
SYSCALL(sleep)
 364:	b8 0d 00 00 00       	mov    $0xd,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <uptime>:
SYSCALL(uptime)
 36c:	b8 0e 00 00 00       	mov    $0xe,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 18             	sub    $0x18,%esp
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 380:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 387:	00 
 388:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38b:	89 44 24 04          	mov    %eax,0x4(%esp)
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	89 04 24             	mov    %eax,(%esp)
 395:	e8 5a ff ff ff       	call   2f4 <write>
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	56                   	push   %esi
 3a0:	53                   	push   %ebx
 3a1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ab:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3af:	74 17                	je     3c8 <printint+0x2c>
 3b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b5:	79 11                	jns    3c8 <printint+0x2c>
    neg = 1;
 3b7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	f7 d8                	neg    %eax
 3c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c6:	eb 06                	jmp    3ce <printint+0x32>
  } else {
    x = xx;
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d8:	8d 41 01             	lea    0x1(%ecx),%eax
 3db:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3de:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e4:	ba 00 00 00 00       	mov    $0x0,%edx
 3e9:	f7 f3                	div    %ebx
 3eb:	89 d0                	mov    %edx,%eax
 3ed:	0f b6 80 74 0a 00 00 	movzbl 0xa74(%eax),%eax
 3f4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f8:	8b 75 10             	mov    0x10(%ebp),%esi
 3fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fe:	ba 00 00 00 00       	mov    $0x0,%edx
 403:	f7 f6                	div    %esi
 405:	89 45 ec             	mov    %eax,-0x14(%ebp)
 408:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40c:	75 c7                	jne    3d5 <printint+0x39>
  if(neg)
 40e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 412:	74 10                	je     424 <printint+0x88>
    buf[i++] = '-';
 414:	8b 45 f4             	mov    -0xc(%ebp),%eax
 417:	8d 50 01             	lea    0x1(%eax),%edx
 41a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 422:	eb 1f                	jmp    443 <printint+0xa7>
 424:	eb 1d                	jmp    443 <printint+0xa7>
    putc(fd, buf[i]);
 426:	8d 55 dc             	lea    -0x24(%ebp),%edx
 429:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42c:	01 d0                	add    %edx,%eax
 42e:	0f b6 00             	movzbl (%eax),%eax
 431:	0f be c0             	movsbl %al,%eax
 434:	89 44 24 04          	mov    %eax,0x4(%esp)
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	89 04 24             	mov    %eax,(%esp)
 43e:	e8 31 ff ff ff       	call   374 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 443:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44b:	79 d9                	jns    426 <printint+0x8a>
    putc(fd, buf[i]);
}
 44d:	83 c4 30             	add    $0x30,%esp
 450:	5b                   	pop    %ebx
 451:	5e                   	pop    %esi
 452:	5d                   	pop    %ebp
 453:	c3                   	ret    

00000454 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 461:	8d 45 0c             	lea    0xc(%ebp),%eax
 464:	83 c0 04             	add    $0x4,%eax
 467:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 471:	e9 7c 01 00 00       	jmp    5f2 <printf+0x19e>
    c = fmt[i] & 0xff;
 476:	8b 55 0c             	mov    0xc(%ebp),%edx
 479:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47c:	01 d0                	add    %edx,%eax
 47e:	0f b6 00             	movzbl (%eax),%eax
 481:	0f be c0             	movsbl %al,%eax
 484:	25 ff 00 00 00       	and    $0xff,%eax
 489:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 490:	75 2c                	jne    4be <printf+0x6a>
      if(c == '%'){
 492:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 496:	75 0c                	jne    4a4 <printf+0x50>
        state = '%';
 498:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49f:	e9 4a 01 00 00       	jmp    5ee <printf+0x19a>
      } else {
        putc(fd, c);
 4a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a7:	0f be c0             	movsbl %al,%eax
 4aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ae:	8b 45 08             	mov    0x8(%ebp),%eax
 4b1:	89 04 24             	mov    %eax,(%esp)
 4b4:	e8 bb fe ff ff       	call   374 <putc>
 4b9:	e9 30 01 00 00       	jmp    5ee <printf+0x19a>
      }
    } else if(state == '%'){
 4be:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c2:	0f 85 26 01 00 00    	jne    5ee <printf+0x19a>
      if(c == 'd'){
 4c8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cc:	75 2d                	jne    4fb <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d1:	8b 00                	mov    (%eax),%eax
 4d3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4da:	00 
 4db:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4e2:	00 
 4e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	89 04 24             	mov    %eax,(%esp)
 4ed:	e8 aa fe ff ff       	call   39c <printint>
        ap++;
 4f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f6:	e9 ec 00 00 00       	jmp    5e7 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4fb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ff:	74 06                	je     507 <printf+0xb3>
 501:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 505:	75 2d                	jne    534 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 507:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50a:	8b 00                	mov    (%eax),%eax
 50c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 513:	00 
 514:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 51b:	00 
 51c:	89 44 24 04          	mov    %eax,0x4(%esp)
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	89 04 24             	mov    %eax,(%esp)
 526:	e8 71 fe ff ff       	call   39c <printint>
        ap++;
 52b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52f:	e9 b3 00 00 00       	jmp    5e7 <printf+0x193>
      } else if(c == 's'){
 534:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 538:	75 45                	jne    57f <printf+0x12b>
        s = (char*)*ap;
 53a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53d:	8b 00                	mov    (%eax),%eax
 53f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 542:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54a:	75 09                	jne    555 <printf+0x101>
          s = "(null)";
 54c:	c7 45 f4 29 08 00 00 	movl   $0x829,-0xc(%ebp)
        while(*s != 0){
 553:	eb 1e                	jmp    573 <printf+0x11f>
 555:	eb 1c                	jmp    573 <printf+0x11f>
          putc(fd, *s);
 557:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55a:	0f b6 00             	movzbl (%eax),%eax
 55d:	0f be c0             	movsbl %al,%eax
 560:	89 44 24 04          	mov    %eax,0x4(%esp)
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	89 04 24             	mov    %eax,(%esp)
 56a:	e8 05 fe ff ff       	call   374 <putc>
          s++;
 56f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 573:	8b 45 f4             	mov    -0xc(%ebp),%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	84 c0                	test   %al,%al
 57b:	75 da                	jne    557 <printf+0x103>
 57d:	eb 68                	jmp    5e7 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 583:	75 1d                	jne    5a2 <printf+0x14e>
        putc(fd, *ap);
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	0f be c0             	movsbl %al,%eax
 58d:	89 44 24 04          	mov    %eax,0x4(%esp)
 591:	8b 45 08             	mov    0x8(%ebp),%eax
 594:	89 04 24             	mov    %eax,(%esp)
 597:	e8 d8 fd ff ff       	call   374 <putc>
        ap++;
 59c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a0:	eb 45                	jmp    5e7 <printf+0x193>
      } else if(c == '%'){
 5a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a6:	75 17                	jne    5bf <printf+0x16b>
        putc(fd, c);
 5a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	89 04 24             	mov    %eax,(%esp)
 5b8:	e8 b7 fd ff ff       	call   374 <putc>
 5bd:	eb 28                	jmp    5e7 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5bf:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c6:	00 
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 a2 fd ff ff       	call   374 <putc>
        putc(fd, c);
 5d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dc:	8b 45 08             	mov    0x8(%ebp),%eax
 5df:	89 04 24             	mov    %eax,(%esp)
 5e2:	e8 8d fd ff ff       	call   374 <putc>
      }
      state = 0;
 5e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ee:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f8:	01 d0                	add    %edx,%eax
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	84 c0                	test   %al,%al
 5ff:	0f 85 71 fe ff ff    	jne    476 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 605:	c9                   	leave  
 606:	c3                   	ret    

00000607 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 607:	55                   	push   %ebp
 608:	89 e5                	mov    %esp,%ebp
 60a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	83 e8 08             	sub    $0x8,%eax
 613:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 616:	a1 90 0a 00 00       	mov    0xa90,%eax
 61b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61e:	eb 24                	jmp    644 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 628:	77 12                	ja     63c <free+0x35>
 62a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 630:	77 24                	ja     656 <free+0x4f>
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63a:	77 1a                	ja     656 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	89 45 fc             	mov    %eax,-0x4(%ebp)
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64a:	76 d4                	jbe    620 <free+0x19>
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 654:	76 ca                	jbe    620 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	8b 40 04             	mov    0x4(%eax),%eax
 65c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	01 c2                	add    %eax,%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	39 c2                	cmp    %eax,%edx
 66f:	75 24                	jne    695 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 671:	8b 45 f8             	mov    -0x8(%ebp),%eax
 674:	8b 50 04             	mov    0x4(%eax),%edx
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	8b 40 04             	mov    0x4(%eax),%eax
 67f:	01 c2                	add    %eax,%edx
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	8b 00                	mov    (%eax),%eax
 68c:	8b 10                	mov    (%eax),%edx
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	89 10                	mov    %edx,(%eax)
 693:	eb 0a                	jmp    69f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 10                	mov    (%eax),%edx
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 40 04             	mov    0x4(%eax),%eax
 6a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	01 d0                	add    %edx,%eax
 6b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b4:	75 20                	jne    6d6 <free+0xcf>
    p->s.size += bp->s.size;
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 50 04             	mov    0x4(%eax),%edx
 6bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bf:	8b 40 04             	mov    0x4(%eax),%eax
 6c2:	01 c2                	add    %eax,%edx
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cd:	8b 10                	mov    (%eax),%edx
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	89 10                	mov    %edx,(%eax)
 6d4:	eb 08                	jmp    6de <free+0xd7>
  } else
    p->s.ptr = bp;
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6dc:	89 10                	mov    %edx,(%eax)
  freep = p;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	a3 90 0a 00 00       	mov    %eax,0xa90
}
 6e6:	c9                   	leave  
 6e7:	c3                   	ret    

000006e8 <morecore>:

static Header*
morecore(uint nu)
{
 6e8:	55                   	push   %ebp
 6e9:	89 e5                	mov    %esp,%ebp
 6eb:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ee:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f5:	77 07                	ja     6fe <morecore+0x16>
    nu = 4096;
 6f7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fe:	8b 45 08             	mov    0x8(%ebp),%eax
 701:	c1 e0 03             	shl    $0x3,%eax
 704:	89 04 24             	mov    %eax,(%esp)
 707:	e8 50 fc ff ff       	call   35c <sbrk>
 70c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 713:	75 07                	jne    71c <morecore+0x34>
    return 0;
 715:	b8 00 00 00 00       	mov    $0x0,%eax
 71a:	eb 22                	jmp    73e <morecore+0x56>
  hp = (Header*)p;
 71c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 722:	8b 45 f0             	mov    -0x10(%ebp),%eax
 725:	8b 55 08             	mov    0x8(%ebp),%edx
 728:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 72b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72e:	83 c0 08             	add    $0x8,%eax
 731:	89 04 24             	mov    %eax,(%esp)
 734:	e8 ce fe ff ff       	call   607 <free>
  return freep;
 739:	a1 90 0a 00 00       	mov    0xa90,%eax
}
 73e:	c9                   	leave  
 73f:	c3                   	ret    

00000740 <malloc>:

void*
malloc(uint nbytes)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 746:	8b 45 08             	mov    0x8(%ebp),%eax
 749:	83 c0 07             	add    $0x7,%eax
 74c:	c1 e8 03             	shr    $0x3,%eax
 74f:	83 c0 01             	add    $0x1,%eax
 752:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 755:	a1 90 0a 00 00       	mov    0xa90,%eax
 75a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 761:	75 23                	jne    786 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 763:	c7 45 f0 88 0a 00 00 	movl   $0xa88,-0x10(%ebp)
 76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76d:	a3 90 0a 00 00       	mov    %eax,0xa90
 772:	a1 90 0a 00 00       	mov    0xa90,%eax
 777:	a3 88 0a 00 00       	mov    %eax,0xa88
    base.s.size = 0;
 77c:	c7 05 8c 0a 00 00 00 	movl   $0x0,0xa8c
 783:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	8b 00                	mov    (%eax),%eax
 78b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	8b 40 04             	mov    0x4(%eax),%eax
 794:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 797:	72 4d                	jb     7e6 <malloc+0xa6>
      if(p->s.size == nunits)
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a2:	75 0c                	jne    7b0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	8b 10                	mov    (%eax),%edx
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	89 10                	mov    %edx,(%eax)
 7ae:	eb 26                	jmp    7d6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7b9:	89 c2                	mov    %eax,%edx
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	8b 40 04             	mov    0x4(%eax),%eax
 7c7:	c1 e0 03             	shl    $0x3,%eax
 7ca:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d9:	a3 90 0a 00 00       	mov    %eax,0xa90
      return (void*)(p + 1);
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	83 c0 08             	add    $0x8,%eax
 7e4:	eb 38                	jmp    81e <malloc+0xde>
    }
    if(p == freep)
 7e6:	a1 90 0a 00 00       	mov    0xa90,%eax
 7eb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ee:	75 1b                	jne    80b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f3:	89 04 24             	mov    %eax,(%esp)
 7f6:	e8 ed fe ff ff       	call   6e8 <morecore>
 7fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 802:	75 07                	jne    80b <malloc+0xcb>
        return 0;
 804:	b8 00 00 00 00       	mov    $0x0,%eax
 809:	eb 13                	jmp    81e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 819:	e9 70 ff ff ff       	jmp    78e <malloc+0x4e>
}
 81e:	c9                   	leave  
 81f:	c3                   	ret    
