
_kill:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 1b 08 00 	movl   $0x81b,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 2c 04 00 00       	call   44f <printf>
    exit();
  23:	e8 a7 02 00 00       	call   2cf <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 f1 01 00 00       	call   23d <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 ab 02 00 00       	call   2ff <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  62:	e8 68 02 00 00       	call   2cf <exit>

00000067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	57                   	push   %edi
  6b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6f:	8b 55 10             	mov    0x10(%ebp),%edx
  72:	8b 45 0c             	mov    0xc(%ebp),%eax
  75:	89 cb                	mov    %ecx,%ebx
  77:	89 df                	mov    %ebx,%edi
  79:	89 d1                	mov    %edx,%ecx
  7b:	fc                   	cld    
  7c:	f3 aa                	rep stos %al,%es:(%edi)
  7e:	89 ca                	mov    %ecx,%edx
  80:	89 fb                	mov    %edi,%ebx
  82:	89 5d 08             	mov    %ebx,0x8(%ebp)
  85:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  88:	5b                   	pop    %ebx
  89:	5f                   	pop    %edi
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  92:	8b 45 08             	mov    0x8(%ebp),%eax
  95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  98:	90                   	nop
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	8d 50 01             	lea    0x1(%eax),%edx
  9f:	89 55 08             	mov    %edx,0x8(%ebp)
  a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ab:	0f b6 12             	movzbl (%edx),%edx
  ae:	88 10                	mov    %dl,(%eax)
  b0:	0f b6 00             	movzbl (%eax),%eax
  b3:	84 c0                	test   %al,%al
  b5:	75 e2                	jne    99 <strcpy+0xd>
    ;
  return os;
  b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ba:	c9                   	leave  
  bb:	c3                   	ret    

000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  bf:	eb 08                	jmp    c9 <strcmp+0xd>
    p++, q++;
  c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	0f b6 00             	movzbl (%eax),%eax
  cf:	84 c0                	test   %al,%al
  d1:	74 10                	je     e3 <strcmp+0x27>
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	0f b6 10             	movzbl (%eax),%edx
  d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	38 c2                	cmp    %al,%dl
  e1:	74 de                	je     c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	0f b6 d0             	movzbl %al,%edx
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 c0             	movzbl %al,%eax
  f5:	29 c2                	sub    %eax,%edx
  f7:	89 d0                	mov    %edx,%eax
}
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    

000000fb <strlen>:

uint
strlen(char *s)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 108:	eb 04                	jmp    10e <strlen+0x13>
 10a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	01 d0                	add    %edx,%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	84 c0                	test   %al,%al
 11b:	75 ed                	jne    10a <strlen+0xf>
    ;
  return n;
 11d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 128:	8b 45 10             	mov    0x10(%ebp),%eax
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	89 44 24 04          	mov    %eax,0x4(%esp)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	89 04 24             	mov    %eax,(%esp)
 13c:	e8 26 ff ff ff       	call   67 <stosb>
  return dst;
 141:	8b 45 08             	mov    0x8(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <strchr>:

char*
strchr(const char *s, char c)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 152:	eb 14                	jmp    168 <strchr+0x22>
    if(*s == c)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15d:	75 05                	jne    164 <strchr+0x1e>
      return (char*)s;
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	eb 13                	jmp    177 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	84 c0                	test   %al,%al
 170:	75 e2                	jne    154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 172:	b8 00 00 00 00       	mov    $0x0,%eax
}
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <gets>:

char*
gets(char *buf, int max)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 186:	eb 4c                	jmp    1d4 <gets+0x5b>
    cc = read(0, &c, 1);
 188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 18f:	00 
 190:	8d 45 ef             	lea    -0x11(%ebp),%eax
 193:	89 44 24 04          	mov    %eax,0x4(%esp)
 197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19e:	e8 44 01 00 00       	call   2e7 <read>
 1a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1aa:	7f 02                	jg     1ae <gets+0x35>
      break;
 1ac:	eb 31                	jmp    1df <gets+0x66>
    buf[i++] = c;
 1ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b1:	8d 50 01             	lea    0x1(%eax),%edx
 1b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b7:	89 c2                	mov    %eax,%edx
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	01 c2                	add    %eax,%edx
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0a                	cmp    $0xa,%al
 1ca:	74 13                	je     1df <gets+0x66>
 1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d0:	3c 0d                	cmp    $0xd,%al
 1d2:	74 0b                	je     1df <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d7:	83 c0 01             	add    $0x1,%eax
 1da:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1dd:	7c a9                	jl     188 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1df:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	01 d0                	add    %edx,%eax
 1e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <stat>:

int
stat(char *n, struct stat *st)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fc:	00 
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	89 04 24             	mov    %eax,(%esp)
 203:	e8 07 01 00 00       	call   30f <open>
 208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20f:	79 07                	jns    218 <stat+0x29>
    return -1;
 211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 216:	eb 23                	jmp    23b <stat+0x4c>
  r = fstat(fd, st);
 218:	8b 45 0c             	mov    0xc(%ebp),%eax
 21b:	89 44 24 04          	mov    %eax,0x4(%esp)
 21f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 222:	89 04 24             	mov    %eax,(%esp)
 225:	e8 fd 00 00 00       	call   327 <fstat>
 22a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	89 04 24             	mov    %eax,(%esp)
 233:	e8 bf 00 00 00       	call   2f7 <close>
  return r;
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <atoi>:

int
atoi(const char *s)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24a:	eb 25                	jmp    271 <atoi+0x34>
    n = n*10 + *s++ - '0';
 24c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24f:	89 d0                	mov    %edx,%eax
 251:	c1 e0 02             	shl    $0x2,%eax
 254:	01 d0                	add    %edx,%eax
 256:	01 c0                	add    %eax,%eax
 258:	89 c1                	mov    %eax,%ecx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 08             	mov    %edx,0x8(%ebp)
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	0f be c0             	movsbl %al,%eax
 269:	01 c8                	add    %ecx,%eax
 26b:	83 e8 30             	sub    $0x30,%eax
 26e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 2f                	cmp    $0x2f,%al
 279:	7e 0a                	jle    285 <atoi+0x48>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	0f b6 00             	movzbl (%eax),%eax
 281:	3c 39                	cmp    $0x39,%al
 283:	7e c7                	jle    24c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 296:	8b 45 0c             	mov    0xc(%ebp),%eax
 299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29c:	eb 17                	jmp    2b5 <memmove+0x2b>
    *dst++ = *src++;
 29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a1:	8d 50 01             	lea    0x1(%eax),%edx
 2a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2aa:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b0:	0f b6 12             	movzbl (%edx),%edx
 2b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b5:	8b 45 10             	mov    0x10(%ebp),%eax
 2b8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2bb:	89 55 10             	mov    %edx,0x10(%ebp)
 2be:	85 c0                	test   %eax,%eax
 2c0:	7f dc                	jg     29e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c7:	b8 01 00 00 00       	mov    $0x1,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <exit>:
SYSCALL(exit)
 2cf:	b8 02 00 00 00       	mov    $0x2,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <wait>:
SYSCALL(wait)
 2d7:	b8 03 00 00 00       	mov    $0x3,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <pipe>:
SYSCALL(pipe)
 2df:	b8 04 00 00 00       	mov    $0x4,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <read>:
SYSCALL(read)
 2e7:	b8 05 00 00 00       	mov    $0x5,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <write>:
SYSCALL(write)
 2ef:	b8 10 00 00 00       	mov    $0x10,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <close>:
SYSCALL(close)
 2f7:	b8 15 00 00 00       	mov    $0x15,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <kill>:
SYSCALL(kill)
 2ff:	b8 06 00 00 00       	mov    $0x6,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <exec>:
SYSCALL(exec)
 307:	b8 07 00 00 00       	mov    $0x7,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <open>:
SYSCALL(open)
 30f:	b8 0f 00 00 00       	mov    $0xf,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <mknod>:
SYSCALL(mknod)
 317:	b8 11 00 00 00       	mov    $0x11,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <unlink>:
SYSCALL(unlink)
 31f:	b8 12 00 00 00       	mov    $0x12,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <fstat>:
SYSCALL(fstat)
 327:	b8 08 00 00 00       	mov    $0x8,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <link>:
SYSCALL(link)
 32f:	b8 13 00 00 00       	mov    $0x13,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <mkdir>:
SYSCALL(mkdir)
 337:	b8 14 00 00 00       	mov    $0x14,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <chdir>:
SYSCALL(chdir)
 33f:	b8 09 00 00 00       	mov    $0x9,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <dup>:
SYSCALL(dup)
 347:	b8 0a 00 00 00       	mov    $0xa,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <getpid>:
SYSCALL(getpid)
 34f:	b8 0b 00 00 00       	mov    $0xb,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sbrk>:
SYSCALL(sbrk)
 357:	b8 0c 00 00 00       	mov    $0xc,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sleep>:
SYSCALL(sleep)
 35f:	b8 0d 00 00 00       	mov    $0xd,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <uptime>:
SYSCALL(uptime)
 367:	b8 0e 00 00 00       	mov    $0xe,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 18             	sub    $0x18,%esp
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 382:	00 
 383:	8d 45 f4             	lea    -0xc(%ebp),%eax
 386:	89 44 24 04          	mov    %eax,0x4(%esp)
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	89 04 24             	mov    %eax,(%esp)
 390:	e8 5a ff ff ff       	call   2ef <write>
}
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	56                   	push   %esi
 39b:	53                   	push   %ebx
 39c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3aa:	74 17                	je     3c3 <printint+0x2c>
 3ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b0:	79 11                	jns    3c3 <printint+0x2c>
    neg = 1;
 3b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	f7 d8                	neg    %eax
 3be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c1:	eb 06                	jmp    3c9 <printint+0x32>
  } else {
    x = xx;
 3c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d3:	8d 41 01             	lea    0x1(%ecx),%eax
 3d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3df:	ba 00 00 00 00       	mov    $0x0,%edx
 3e4:	f7 f3                	div    %ebx
 3e6:	89 d0                	mov    %edx,%eax
 3e8:	0f b6 80 7c 0a 00 00 	movzbl 0xa7c(%eax),%eax
 3ef:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f3:	8b 75 10             	mov    0x10(%ebp),%esi
 3f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f9:	ba 00 00 00 00       	mov    $0x0,%edx
 3fe:	f7 f6                	div    %esi
 400:	89 45 ec             	mov    %eax,-0x14(%ebp)
 403:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 407:	75 c7                	jne    3d0 <printint+0x39>
  if(neg)
 409:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 40d:	74 10                	je     41f <printint+0x88>
    buf[i++] = '-';
 40f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 412:	8d 50 01             	lea    0x1(%eax),%edx
 415:	89 55 f4             	mov    %edx,-0xc(%ebp)
 418:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 41d:	eb 1f                	jmp    43e <printint+0xa7>
 41f:	eb 1d                	jmp    43e <printint+0xa7>
    putc(fd, buf[i]);
 421:	8d 55 dc             	lea    -0x24(%ebp),%edx
 424:	8b 45 f4             	mov    -0xc(%ebp),%eax
 427:	01 d0                	add    %edx,%eax
 429:	0f b6 00             	movzbl (%eax),%eax
 42c:	0f be c0             	movsbl %al,%eax
 42f:	89 44 24 04          	mov    %eax,0x4(%esp)
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	89 04 24             	mov    %eax,(%esp)
 439:	e8 31 ff ff ff       	call   36f <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 43e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 446:	79 d9                	jns    421 <printint+0x8a>
    putc(fd, buf[i]);
}
 448:	83 c4 30             	add    $0x30,%esp
 44b:	5b                   	pop    %ebx
 44c:	5e                   	pop    %esi
 44d:	5d                   	pop    %ebp
 44e:	c3                   	ret    

0000044f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 455:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 45c:	8d 45 0c             	lea    0xc(%ebp),%eax
 45f:	83 c0 04             	add    $0x4,%eax
 462:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 465:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 46c:	e9 7c 01 00 00       	jmp    5ed <printf+0x19e>
    c = fmt[i] & 0xff;
 471:	8b 55 0c             	mov    0xc(%ebp),%edx
 474:	8b 45 f0             	mov    -0x10(%ebp),%eax
 477:	01 d0                	add    %edx,%eax
 479:	0f b6 00             	movzbl (%eax),%eax
 47c:	0f be c0             	movsbl %al,%eax
 47f:	25 ff 00 00 00       	and    $0xff,%eax
 484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 487:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48b:	75 2c                	jne    4b9 <printf+0x6a>
      if(c == '%'){
 48d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 491:	75 0c                	jne    49f <printf+0x50>
        state = '%';
 493:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49a:	e9 4a 01 00 00       	jmp    5e9 <printf+0x19a>
      } else {
        putc(fd, c);
 49f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a2:	0f be c0             	movsbl %al,%eax
 4a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	89 04 24             	mov    %eax,(%esp)
 4af:	e8 bb fe ff ff       	call   36f <putc>
 4b4:	e9 30 01 00 00       	jmp    5e9 <printf+0x19a>
      }
    } else if(state == '%'){
 4b9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4bd:	0f 85 26 01 00 00    	jne    5e9 <printf+0x19a>
      if(c == 'd'){
 4c3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c7:	75 2d                	jne    4f6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cc:	8b 00                	mov    (%eax),%eax
 4ce:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d5:	00 
 4d6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4dd:	00 
 4de:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	89 04 24             	mov    %eax,(%esp)
 4e8:	e8 aa fe ff ff       	call   397 <printint>
        ap++;
 4ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f1:	e9 ec 00 00 00       	jmp    5e2 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4f6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fa:	74 06                	je     502 <printf+0xb3>
 4fc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 500:	75 2d                	jne    52f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 502:	8b 45 e8             	mov    -0x18(%ebp),%eax
 505:	8b 00                	mov    (%eax),%eax
 507:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 50e:	00 
 50f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 516:	00 
 517:	89 44 24 04          	mov    %eax,0x4(%esp)
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	89 04 24             	mov    %eax,(%esp)
 521:	e8 71 fe ff ff       	call   397 <printint>
        ap++;
 526:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52a:	e9 b3 00 00 00       	jmp    5e2 <printf+0x193>
      } else if(c == 's'){
 52f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 533:	75 45                	jne    57a <printf+0x12b>
        s = (char*)*ap;
 535:	8b 45 e8             	mov    -0x18(%ebp),%eax
 538:	8b 00                	mov    (%eax),%eax
 53a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 545:	75 09                	jne    550 <printf+0x101>
          s = "(null)";
 547:	c7 45 f4 2f 08 00 00 	movl   $0x82f,-0xc(%ebp)
        while(*s != 0){
 54e:	eb 1e                	jmp    56e <printf+0x11f>
 550:	eb 1c                	jmp    56e <printf+0x11f>
          putc(fd, *s);
 552:	8b 45 f4             	mov    -0xc(%ebp),%eax
 555:	0f b6 00             	movzbl (%eax),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	89 44 24 04          	mov    %eax,0x4(%esp)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 05 fe ff ff       	call   36f <putc>
          s++;
 56a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 571:	0f b6 00             	movzbl (%eax),%eax
 574:	84 c0                	test   %al,%al
 576:	75 da                	jne    552 <printf+0x103>
 578:	eb 68                	jmp    5e2 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 57e:	75 1d                	jne    59d <printf+0x14e>
        putc(fd, *ap);
 580:	8b 45 e8             	mov    -0x18(%ebp),%eax
 583:	8b 00                	mov    (%eax),%eax
 585:	0f be c0             	movsbl %al,%eax
 588:	89 44 24 04          	mov    %eax,0x4(%esp)
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
 58f:	89 04 24             	mov    %eax,(%esp)
 592:	e8 d8 fd ff ff       	call   36f <putc>
        ap++;
 597:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59b:	eb 45                	jmp    5e2 <printf+0x193>
      } else if(c == '%'){
 59d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a1:	75 17                	jne    5ba <printf+0x16b>
        putc(fd, c);
 5a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	89 04 24             	mov    %eax,(%esp)
 5b3:	e8 b7 fd ff ff       	call   36f <putc>
 5b8:	eb 28                	jmp    5e2 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ba:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c1:	00 
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	89 04 24             	mov    %eax,(%esp)
 5c8:	e8 a2 fd ff ff       	call   36f <putc>
        putc(fd, c);
 5cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	89 04 24             	mov    %eax,(%esp)
 5dd:	e8 8d fd ff ff       	call   36f <putc>
      }
      state = 0;
 5e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ed:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f3:	01 d0                	add    %edx,%eax
 5f5:	0f b6 00             	movzbl (%eax),%eax
 5f8:	84 c0                	test   %al,%al
 5fa:	0f 85 71 fe ff ff    	jne    471 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 600:	c9                   	leave  
 601:	c3                   	ret    

00000602 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
 605:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	83 e8 08             	sub    $0x8,%eax
 60e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	a1 98 0a 00 00       	mov    0xa98,%eax
 616:	89 45 fc             	mov    %eax,-0x4(%ebp)
 619:	eb 24                	jmp    63f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 623:	77 12                	ja     637 <free+0x35>
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62b:	77 24                	ja     651 <free+0x4f>
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 635:	77 1a                	ja     651 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 645:	76 d4                	jbe    61b <free+0x19>
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64f:	76 ca                	jbe    61b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	8b 40 04             	mov    0x4(%eax),%eax
 657:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	01 c2                	add    %eax,%edx
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	39 c2                	cmp    %eax,%edx
 66a:	75 24                	jne    690 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	8b 50 04             	mov    0x4(%eax),%edx
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	8b 40 04             	mov    0x4(%eax),%eax
 67a:	01 c2                	add    %eax,%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	8b 10                	mov    (%eax),%edx
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	89 10                	mov    %edx,(%eax)
 68e:	eb 0a                	jmp    69a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 10                	mov    (%eax),%edx
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 40 04             	mov    0x4(%eax),%eax
 6a0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	01 d0                	add    %edx,%eax
 6ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6af:	75 20                	jne    6d1 <free+0xcf>
    p->s.size += bp->s.size;
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 50 04             	mov    0x4(%eax),%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	8b 40 04             	mov    0x4(%eax),%eax
 6bd:	01 c2                	add    %eax,%edx
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	8b 10                	mov    (%eax),%edx
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	89 10                	mov    %edx,(%eax)
 6cf:	eb 08                	jmp    6d9 <free+0xd7>
  } else
    p->s.ptr = bp;
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 6e1:	c9                   	leave  
 6e2:	c3                   	ret    

000006e3 <morecore>:

static Header*
morecore(uint nu)
{
 6e3:	55                   	push   %ebp
 6e4:	89 e5                	mov    %esp,%ebp
 6e6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6e9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f0:	77 07                	ja     6f9 <morecore+0x16>
    nu = 4096;
 6f2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
 6fc:	c1 e0 03             	shl    $0x3,%eax
 6ff:	89 04 24             	mov    %eax,(%esp)
 702:	e8 50 fc ff ff       	call   357 <sbrk>
 707:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 70e:	75 07                	jne    717 <morecore+0x34>
    return 0;
 710:	b8 00 00 00 00       	mov    $0x0,%eax
 715:	eb 22                	jmp    739 <morecore+0x56>
  hp = (Header*)p;
 717:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 71d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 720:	8b 55 08             	mov    0x8(%ebp),%edx
 723:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 726:	8b 45 f0             	mov    -0x10(%ebp),%eax
 729:	83 c0 08             	add    $0x8,%eax
 72c:	89 04 24             	mov    %eax,(%esp)
 72f:	e8 ce fe ff ff       	call   602 <free>
  return freep;
 734:	a1 98 0a 00 00       	mov    0xa98,%eax
}
 739:	c9                   	leave  
 73a:	c3                   	ret    

0000073b <malloc>:

void*
malloc(uint nbytes)
{
 73b:	55                   	push   %ebp
 73c:	89 e5                	mov    %esp,%ebp
 73e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 741:	8b 45 08             	mov    0x8(%ebp),%eax
 744:	83 c0 07             	add    $0x7,%eax
 747:	c1 e8 03             	shr    $0x3,%eax
 74a:	83 c0 01             	add    $0x1,%eax
 74d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 750:	a1 98 0a 00 00       	mov    0xa98,%eax
 755:	89 45 f0             	mov    %eax,-0x10(%ebp)
 758:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 75c:	75 23                	jne    781 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 75e:	c7 45 f0 90 0a 00 00 	movl   $0xa90,-0x10(%ebp)
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	a3 98 0a 00 00       	mov    %eax,0xa98
 76d:	a1 98 0a 00 00       	mov    0xa98,%eax
 772:	a3 90 0a 00 00       	mov    %eax,0xa90
    base.s.size = 0;
 777:	c7 05 94 0a 00 00 00 	movl   $0x0,0xa94
 77e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 781:	8b 45 f0             	mov    -0x10(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 40 04             	mov    0x4(%eax),%eax
 78f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 792:	72 4d                	jb     7e1 <malloc+0xa6>
      if(p->s.size == nunits)
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79d:	75 0c                	jne    7ab <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 10                	mov    (%eax),%edx
 7a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a7:	89 10                	mov    %edx,(%eax)
 7a9:	eb 26                	jmp    7d1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7b4:	89 c2                	mov    %eax,%edx
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 40 04             	mov    0x4(%eax),%eax
 7c2:	c1 e0 03             	shl    $0x3,%eax
 7c5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ce:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	a3 98 0a 00 00       	mov    %eax,0xa98
      return (void*)(p + 1);
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	83 c0 08             	add    $0x8,%eax
 7df:	eb 38                	jmp    819 <malloc+0xde>
    }
    if(p == freep)
 7e1:	a1 98 0a 00 00       	mov    0xa98,%eax
 7e6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7e9:	75 1b                	jne    806 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ee:	89 04 24             	mov    %eax,(%esp)
 7f1:	e8 ed fe ff ff       	call   6e3 <morecore>
 7f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7fd:	75 07                	jne    806 <malloc+0xcb>
        return 0;
 7ff:	b8 00 00 00 00       	mov    $0x0,%eax
 804:	eb 13                	jmp    819 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 814:	e9 70 ff ff ff       	jmp    789 <malloc+0x4e>
}
 819:	c9                   	leave  
 81a:	c3                   	ret    
