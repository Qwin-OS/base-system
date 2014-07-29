
_echo:     формат файла elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	b8 6f 0f 00 00       	mov    $0xf6f,%eax
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	b8 71 0f 00 00       	mov    $0xf71,%eax
  33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  36:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  3d:	8b 53 04             	mov    0x4(%ebx),%edx
  40:	01 ca                	add    %ecx,%edx
  42:	8b 12                	mov    (%edx),%edx
  44:	50                   	push   %eax
  45:	52                   	push   %edx
  46:	68 73 0f 00 00       	push   $0xf73
  4b:	6a 01                	push   $0x1
  4d:	e8 fd 03 00 00       	call   44f <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 55 02 00 00       	call   2ba <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	5b                   	pop    %ebx
  87:	5f                   	pop    %edi
  88:	5d                   	pop    %ebp
  89:	c3                   	ret    

0000008a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8a:	55                   	push   %ebp
  8b:	89 e5                	mov    %esp,%ebp
  8d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  90:	8b 45 08             	mov    0x8(%ebp),%eax
  93:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  96:	90                   	nop
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	8d 50 01             	lea    0x1(%eax),%edx
  9d:	89 55 08             	mov    %edx,0x8(%ebp)
  a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  a6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  a9:	0f b6 12             	movzbl (%edx),%edx
  ac:	88 10                	mov    %dl,(%eax)
  ae:	0f b6 00             	movzbl (%eax),%eax
  b1:	84 c0                	test   %al,%al
  b3:	75 e2                	jne    97 <strcpy+0xd>
    ;
  return os;
  b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b8:	c9                   	leave  
  b9:	c3                   	ret    

000000ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ba:	55                   	push   %ebp
  bb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  bd:	eb 08                	jmp    c7 <strcmp+0xd>
    p++, q++;
  bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c7:	8b 45 08             	mov    0x8(%ebp),%eax
  ca:	0f b6 00             	movzbl (%eax),%eax
  cd:	84 c0                	test   %al,%al
  cf:	74 10                	je     e1 <strcmp+0x27>
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	0f b6 10             	movzbl (%eax),%edx
  d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	38 c2                	cmp    %al,%dl
  df:	74 de                	je     bf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	0f b6 d0             	movzbl %al,%edx
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	0f b6 00             	movzbl (%eax),%eax
  f0:	0f b6 c0             	movzbl %al,%eax
  f3:	29 c2                	sub    %eax,%edx
  f5:	89 d0                	mov    %edx,%eax
}
  f7:	5d                   	pop    %ebp
  f8:	c3                   	ret    

000000f9 <strlen>:

uint
strlen(char *s)
{
  f9:	55                   	push   %ebp
  fa:	89 e5                	mov    %esp,%ebp
  fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 106:	eb 04                	jmp    10c <strlen+0x13>
 108:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	01 d0                	add    %edx,%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	84 c0                	test   %al,%al
 119:	75 ed                	jne    108 <strlen+0xf>
    ;
  return n;
 11b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11e:	c9                   	leave  
 11f:	c3                   	ret    

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 123:	8b 45 10             	mov    0x10(%ebp),%eax
 126:	50                   	push   %eax
 127:	ff 75 0c             	pushl  0xc(%ebp)
 12a:	ff 75 08             	pushl  0x8(%ebp)
 12d:	e8 33 ff ff ff       	call   65 <stosb>
 132:	83 c4 0c             	add    $0xc,%esp
  return dst;
 135:	8b 45 08             	mov    0x8(%ebp),%eax
}
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <strchr>:

char*
strchr(const char *s, char c)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 04             	sub    $0x4,%esp
 140:	8b 45 0c             	mov    0xc(%ebp),%eax
 143:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 146:	eb 14                	jmp    15c <strchr+0x22>
    if(*s == c)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 151:	75 05                	jne    158 <strchr+0x1e>
      return (char*)s;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	eb 13                	jmp    16b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 158:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	84 c0                	test   %al,%al
 164:	75 e2                	jne    148 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 166:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16b:	c9                   	leave  
 16c:	c3                   	ret    

0000016d <gets>:

char*
gets(char *buf, int max)
{
 16d:	55                   	push   %ebp
 16e:	89 e5                	mov    %esp,%ebp
 170:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 173:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17a:	eb 44                	jmp    1c0 <gets+0x53>
    cc = read(0, &c, 1);
 17c:	83 ec 04             	sub    $0x4,%esp
 17f:	6a 01                	push   $0x1
 181:	8d 45 ef             	lea    -0x11(%ebp),%eax
 184:	50                   	push   %eax
 185:	6a 00                	push   $0x0
 187:	e8 46 01 00 00       	call   2d2 <read>
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 192:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 196:	7f 02                	jg     19a <gets+0x2d>
      break;
 198:	eb 31                	jmp    1cb <gets+0x5e>
    buf[i++] = c;
 19a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19d:	8d 50 01             	lea    0x1(%eax),%edx
 1a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a3:	89 c2                	mov    %eax,%edx
 1a5:	8b 45 08             	mov    0x8(%ebp),%eax
 1a8:	01 c2                	add    %eax,%edx
 1aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ae:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b4:	3c 0a                	cmp    $0xa,%al
 1b6:	74 13                	je     1cb <gets+0x5e>
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	3c 0d                	cmp    $0xd,%al
 1be:	74 0b                	je     1cb <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c3:	83 c0 01             	add    $0x1,%eax
 1c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c9:	7c b1                	jl     17c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax
 1d3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    

000001db <stat>:

int
stat(char *n, struct stat *st)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e1:	83 ec 08             	sub    $0x8,%esp
 1e4:	6a 00                	push   $0x0
 1e6:	ff 75 08             	pushl  0x8(%ebp)
 1e9:	e8 0c 01 00 00       	call   2fa <open>
 1ee:	83 c4 10             	add    $0x10,%esp
 1f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f8:	79 07                	jns    201 <stat+0x26>
    return -1;
 1fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1ff:	eb 25                	jmp    226 <stat+0x4b>
  r = fstat(fd, st);
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 f4             	pushl  -0xc(%ebp)
 20a:	e8 03 01 00 00       	call   312 <fstat>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 215:	83 ec 0c             	sub    $0xc,%esp
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 c2 00 00 00       	call   2e2 <close>
 220:	83 c4 10             	add    $0x10,%esp
  return r;
 223:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <atoi>:

int
atoi(const char *s)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 22e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 235:	eb 25                	jmp    25c <atoi+0x34>
    n = n*10 + *s++ - '0';
 237:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23a:	89 d0                	mov    %edx,%eax
 23c:	c1 e0 02             	shl    $0x2,%eax
 23f:	01 d0                	add    %edx,%eax
 241:	01 c0                	add    %eax,%eax
 243:	89 c1                	mov    %eax,%ecx
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	8d 50 01             	lea    0x1(%eax),%edx
 24b:	89 55 08             	mov    %edx,0x8(%ebp)
 24e:	0f b6 00             	movzbl (%eax),%eax
 251:	0f be c0             	movsbl %al,%eax
 254:	01 c8                	add    %ecx,%eax
 256:	83 e8 30             	sub    $0x30,%eax
 259:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	3c 2f                	cmp    $0x2f,%al
 264:	7e 0a                	jle    270 <atoi+0x48>
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	3c 39                	cmp    $0x39,%al
 26e:	7e c7                	jle    237 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 281:	8b 45 0c             	mov    0xc(%ebp),%eax
 284:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 287:	eb 17                	jmp    2a0 <memmove+0x2b>
    *dst++ = *src++;
 289:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28c:	8d 50 01             	lea    0x1(%eax),%edx
 28f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 292:	8b 55 f8             	mov    -0x8(%ebp),%edx
 295:	8d 4a 01             	lea    0x1(%edx),%ecx
 298:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29b:	0f b6 12             	movzbl (%edx),%edx
 29e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a0:	8b 45 10             	mov    0x10(%ebp),%eax
 2a3:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a6:	89 55 10             	mov    %edx,0x10(%ebp)
 2a9:	85 c0                	test   %eax,%eax
 2ab:	7f dc                	jg     289 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b2:	b8 01 00 00 00       	mov    $0x1,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <exit>:
SYSCALL(exit)
 2ba:	b8 02 00 00 00       	mov    $0x2,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <wait>:
SYSCALL(wait)
 2c2:	b8 03 00 00 00       	mov    $0x3,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <pipe>:
SYSCALL(pipe)
 2ca:	b8 04 00 00 00       	mov    $0x4,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <read>:
SYSCALL(read)
 2d2:	b8 05 00 00 00       	mov    $0x5,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <write>:
SYSCALL(write)
 2da:	b8 10 00 00 00       	mov    $0x10,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <close>:
SYSCALL(close)
 2e2:	b8 15 00 00 00       	mov    $0x15,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <kill>:
SYSCALL(kill)
 2ea:	b8 06 00 00 00       	mov    $0x6,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <exec>:
SYSCALL(exec)
 2f2:	b8 07 00 00 00       	mov    $0x7,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <open>:
SYSCALL(open)
 2fa:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <mknod>:
SYSCALL(mknod)
 302:	b8 11 00 00 00       	mov    $0x11,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <unlink>:
SYSCALL(unlink)
 30a:	b8 12 00 00 00       	mov    $0x12,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <fstat>:
SYSCALL(fstat)
 312:	b8 08 00 00 00       	mov    $0x8,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <link>:
SYSCALL(link)
 31a:	b8 13 00 00 00       	mov    $0x13,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <mkdir>:
SYSCALL(mkdir)
 322:	b8 14 00 00 00       	mov    $0x14,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <chdir>:
SYSCALL(chdir)
 32a:	b8 09 00 00 00       	mov    $0x9,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <dup>:
SYSCALL(dup)
 332:	b8 0a 00 00 00       	mov    $0xa,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <getpid>:
SYSCALL(getpid)
 33a:	b8 0b 00 00 00       	mov    $0xb,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sbrk>:
SYSCALL(sbrk)
 342:	b8 0c 00 00 00       	mov    $0xc,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <sleep>:
SYSCALL(sleep)
 34a:	b8 0d 00 00 00       	mov    $0xd,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <uptime>:
SYSCALL(uptime)
 352:	b8 0e 00 00 00       	mov    $0xe,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <getcwd>:
SYSCALL(getcwd)
 35a:	b8 16 00 00 00       	mov    $0x16,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <shutdown>:
SYSCALL(shutdown)
 362:	b8 17 00 00 00       	mov    $0x17,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <buildinfo>:
SYSCALL(buildinfo)
 36a:	b8 18 00 00 00       	mov    $0x18,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <lseek>:
SYSCALL(lseek)
 372:	b8 19 00 00 00       	mov    $0x19,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp
 37d:	83 ec 18             	sub    $0x18,%esp
 380:	8b 45 0c             	mov    0xc(%ebp),%eax
 383:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 386:	83 ec 04             	sub    $0x4,%esp
 389:	6a 01                	push   $0x1
 38b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38e:	50                   	push   %eax
 38f:	ff 75 08             	pushl  0x8(%ebp)
 392:	e8 43 ff ff ff       	call   2da <write>
 397:	83 c4 10             	add    $0x10,%esp
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	53                   	push   %ebx
 3a0:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ae:	74 17                	je     3c7 <printint+0x2b>
 3b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b4:	79 11                	jns    3c7 <printint+0x2b>
    neg = 1;
 3b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c0:	f7 d8                	neg    %eax
 3c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c5:	eb 06                	jmp    3cd <printint+0x31>
  } else {
    x = xx;
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d7:	8d 41 01             	lea    0x1(%ecx),%eax
 3da:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e3:	ba 00 00 00 00       	mov    $0x0,%edx
 3e8:	f7 f3                	div    %ebx
 3ea:	89 d0                	mov    %edx,%eax
 3ec:	0f b6 80 8c 13 00 00 	movzbl 0x138c(%eax),%eax
 3f3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fd:	ba 00 00 00 00       	mov    $0x0,%edx
 402:	f7 f3                	div    %ebx
 404:	89 45 ec             	mov    %eax,-0x14(%ebp)
 407:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40b:	75 c7                	jne    3d4 <printint+0x38>
  if(neg)
 40d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 411:	74 0e                	je     421 <printint+0x85>
    buf[i++] = '-';
 413:	8b 45 f4             	mov    -0xc(%ebp),%eax
 416:	8d 50 01             	lea    0x1(%eax),%edx
 419:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 421:	eb 1d                	jmp    440 <printint+0xa4>
    putc(fd, buf[i]);
 423:	8d 55 dc             	lea    -0x24(%ebp),%edx
 426:	8b 45 f4             	mov    -0xc(%ebp),%eax
 429:	01 d0                	add    %edx,%eax
 42b:	0f b6 00             	movzbl (%eax),%eax
 42e:	0f be c0             	movsbl %al,%eax
 431:	83 ec 08             	sub    $0x8,%esp
 434:	50                   	push   %eax
 435:	ff 75 08             	pushl  0x8(%ebp)
 438:	e8 3d ff ff ff       	call   37a <putc>
 43d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 440:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 448:	79 d9                	jns    423 <printint+0x87>
    putc(fd, buf[i]);
}
 44a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 28             	sub    $0x28,%esp
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
 46c:	e9 59 01 00 00       	jmp    5ca <printf+0x17b>
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
 49a:	e9 27 01 00 00       	jmp    5c6 <printf+0x177>
      } else {
        putc(fd, c);
 49f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a2:	0f be c0             	movsbl %al,%eax
 4a5:	83 ec 08             	sub    $0x8,%esp
 4a8:	50                   	push   %eax
 4a9:	ff 75 08             	pushl  0x8(%ebp)
 4ac:	e8 c9 fe ff ff       	call   37a <putc>
 4b1:	83 c4 10             	add    $0x10,%esp
 4b4:	e9 0d 01 00 00       	jmp    5c6 <printf+0x177>
      }
    } else if(state == '%'){
 4b9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4bd:	0f 85 03 01 00 00    	jne    5c6 <printf+0x177>
      if(c == 'd'){
 4c3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c7:	75 1e                	jne    4e7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cc:	8b 00                	mov    (%eax),%eax
 4ce:	6a 01                	push   $0x1
 4d0:	6a 0a                	push   $0xa
 4d2:	50                   	push   %eax
 4d3:	ff 75 08             	pushl  0x8(%ebp)
 4d6:	e8 c1 fe ff ff       	call   39c <printint>
 4db:	83 c4 10             	add    $0x10,%esp
        ap++;
 4de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e2:	e9 d8 00 00 00       	jmp    5bf <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4e7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4eb:	74 06                	je     4f3 <printf+0xa4>
 4ed:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f1:	75 1e                	jne    511 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f6:	8b 00                	mov    (%eax),%eax
 4f8:	6a 00                	push   $0x0
 4fa:	6a 10                	push   $0x10
 4fc:	50                   	push   %eax
 4fd:	ff 75 08             	pushl  0x8(%ebp)
 500:	e8 97 fe ff ff       	call   39c <printint>
 505:	83 c4 10             	add    $0x10,%esp
        ap++;
 508:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50c:	e9 ae 00 00 00       	jmp    5bf <printf+0x170>
      } else if(c == 's'){
 511:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 515:	75 43                	jne    55a <printf+0x10b>
        s = (char*)*ap;
 517:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51a:	8b 00                	mov    (%eax),%eax
 51c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 51f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 523:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 527:	75 07                	jne    530 <printf+0xe1>
          s = "(null)";
 529:	c7 45 f4 78 0f 00 00 	movl   $0xf78,-0xc(%ebp)
        while(*s != 0){
 530:	eb 1c                	jmp    54e <printf+0xff>
          putc(fd, *s);
 532:	8b 45 f4             	mov    -0xc(%ebp),%eax
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	83 ec 08             	sub    $0x8,%esp
 53e:	50                   	push   %eax
 53f:	ff 75 08             	pushl  0x8(%ebp)
 542:	e8 33 fe ff ff       	call   37a <putc>
 547:	83 c4 10             	add    $0x10,%esp
          s++;
 54a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 551:	0f b6 00             	movzbl (%eax),%eax
 554:	84 c0                	test   %al,%al
 556:	75 da                	jne    532 <printf+0xe3>
 558:	eb 65                	jmp    5bf <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 55a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 55e:	75 1d                	jne    57d <printf+0x12e>
        putc(fd, *ap);
 560:	8b 45 e8             	mov    -0x18(%ebp),%eax
 563:	8b 00                	mov    (%eax),%eax
 565:	0f be c0             	movsbl %al,%eax
 568:	83 ec 08             	sub    $0x8,%esp
 56b:	50                   	push   %eax
 56c:	ff 75 08             	pushl  0x8(%ebp)
 56f:	e8 06 fe ff ff       	call   37a <putc>
 574:	83 c4 10             	add    $0x10,%esp
        ap++;
 577:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57b:	eb 42                	jmp    5bf <printf+0x170>
      } else if(c == '%'){
 57d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 581:	75 17                	jne    59a <printf+0x14b>
        putc(fd, c);
 583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 586:	0f be c0             	movsbl %al,%eax
 589:	83 ec 08             	sub    $0x8,%esp
 58c:	50                   	push   %eax
 58d:	ff 75 08             	pushl  0x8(%ebp)
 590:	e8 e5 fd ff ff       	call   37a <putc>
 595:	83 c4 10             	add    $0x10,%esp
 598:	eb 25                	jmp    5bf <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59a:	83 ec 08             	sub    $0x8,%esp
 59d:	6a 25                	push   $0x25
 59f:	ff 75 08             	pushl  0x8(%ebp)
 5a2:	e8 d3 fd ff ff       	call   37a <putc>
 5a7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ad:	0f be c0             	movsbl %al,%eax
 5b0:	83 ec 08             	sub    $0x8,%esp
 5b3:	50                   	push   %eax
 5b4:	ff 75 08             	pushl  0x8(%ebp)
 5b7:	e8 be fd ff ff       	call   37a <putc>
 5bc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 5cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d0:	01 d0                	add    %edx,%eax
 5d2:	0f b6 00             	movzbl (%eax),%eax
 5d5:	84 c0                	test   %al,%al
 5d7:	0f 85 94 fe ff ff    	jne    471 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5dd:	c9                   	leave  
 5de:	c3                   	ret    

000005df <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5df:	55                   	push   %ebp
 5e0:	89 e5                	mov    %esp,%ebp
 5e2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	83 e8 08             	sub    $0x8,%eax
 5eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ee:	a1 a8 13 00 00       	mov    0x13a8,%eax
 5f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f6:	eb 24                	jmp    61c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fb:	8b 00                	mov    (%eax),%eax
 5fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 600:	77 12                	ja     614 <free+0x35>
 602:	8b 45 f8             	mov    -0x8(%ebp),%eax
 605:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 608:	77 24                	ja     62e <free+0x4f>
 60a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60d:	8b 00                	mov    (%eax),%eax
 60f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 612:	77 1a                	ja     62e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 622:	76 d4                	jbe    5f8 <free+0x19>
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62c:	76 ca                	jbe    5f8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 62e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 631:	8b 40 04             	mov    0x4(%eax),%eax
 634:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	01 c2                	add    %eax,%edx
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	39 c2                	cmp    %eax,%edx
 647:	75 24                	jne    66d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	8b 50 04             	mov    0x4(%eax),%edx
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	8b 40 04             	mov    0x4(%eax),%eax
 657:	01 c2                	add    %eax,%edx
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	8b 10                	mov    (%eax),%edx
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	89 10                	mov    %edx,(%eax)
 66b:	eb 0a                	jmp    677 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 10                	mov    (%eax),%edx
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 40 04             	mov    0x4(%eax),%eax
 67d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	01 d0                	add    %edx,%eax
 689:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68c:	75 20                	jne    6ae <free+0xcf>
    p->s.size += bp->s.size;
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 50 04             	mov    0x4(%eax),%edx
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	8b 40 04             	mov    0x4(%eax),%eax
 69a:	01 c2                	add    %eax,%edx
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	8b 10                	mov    (%eax),%edx
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	89 10                	mov    %edx,(%eax)
 6ac:	eb 08                	jmp    6b6 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	a3 a8 13 00 00       	mov    %eax,0x13a8
}
 6be:	c9                   	leave  
 6bf:	c3                   	ret    

000006c0 <morecore>:

static Header*
morecore(uint nu)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6cd:	77 07                	ja     6d6 <morecore+0x16>
    nu = 4096;
 6cf:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	c1 e0 03             	shl    $0x3,%eax
 6dc:	83 ec 0c             	sub    $0xc,%esp
 6df:	50                   	push   %eax
 6e0:	e8 5d fc ff ff       	call   342 <sbrk>
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6eb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ef:	75 07                	jne    6f8 <morecore+0x38>
    return 0;
 6f1:	b8 00 00 00 00       	mov    $0x0,%eax
 6f6:	eb 26                	jmp    71e <morecore+0x5e>
  hp = (Header*)p;
 6f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 701:	8b 55 08             	mov    0x8(%ebp),%edx
 704:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 707:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70a:	83 c0 08             	add    $0x8,%eax
 70d:	83 ec 0c             	sub    $0xc,%esp
 710:	50                   	push   %eax
 711:	e8 c9 fe ff ff       	call   5df <free>
 716:	83 c4 10             	add    $0x10,%esp
  return freep;
 719:	a1 a8 13 00 00       	mov    0x13a8,%eax
}
 71e:	c9                   	leave  
 71f:	c3                   	ret    

00000720 <malloc>:

void*
malloc(uint nbytes)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 726:	8b 45 08             	mov    0x8(%ebp),%eax
 729:	83 c0 07             	add    $0x7,%eax
 72c:	c1 e8 03             	shr    $0x3,%eax
 72f:	83 c0 01             	add    $0x1,%eax
 732:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 735:	a1 a8 13 00 00       	mov    0x13a8,%eax
 73a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 73d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 741:	75 23                	jne    766 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 743:	c7 45 f0 a0 13 00 00 	movl   $0x13a0,-0x10(%ebp)
 74a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74d:	a3 a8 13 00 00       	mov    %eax,0x13a8
 752:	a1 a8 13 00 00       	mov    0x13a8,%eax
 757:	a3 a0 13 00 00       	mov    %eax,0x13a0
    base.s.size = 0;
 75c:	c7 05 a4 13 00 00 00 	movl   $0x0,0x13a4
 763:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 777:	72 4d                	jb     7c6 <malloc+0xa6>
      if(p->s.size == nunits)
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 782:	75 0c                	jne    790 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 10                	mov    (%eax),%edx
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	89 10                	mov    %edx,(%eax)
 78e:	eb 26                	jmp    7b6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	2b 45 ec             	sub    -0x14(%ebp),%eax
 799:	89 c2                	mov    %eax,%edx
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	c1 e0 03             	shl    $0x3,%eax
 7aa:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b9:	a3 a8 13 00 00       	mov    %eax,0x13a8
      return (void*)(p + 1);
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	83 c0 08             	add    $0x8,%eax
 7c4:	eb 3b                	jmp    801 <malloc+0xe1>
    }
    if(p == freep)
 7c6:	a1 a8 13 00 00       	mov    0x13a8,%eax
 7cb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ce:	75 1e                	jne    7ee <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7d0:	83 ec 0c             	sub    $0xc,%esp
 7d3:	ff 75 ec             	pushl  -0x14(%ebp)
 7d6:	e8 e5 fe ff ff       	call   6c0 <morecore>
 7db:	83 c4 10             	add    $0x10,%esp
 7de:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e5:	75 07                	jne    7ee <malloc+0xce>
        return 0;
 7e7:	b8 00 00 00 00       	mov    $0x0,%eax
 7ec:	eb 13                	jmp    801 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	8b 00                	mov    (%eax),%eax
 7f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7fc:	e9 6d ff ff ff       	jmp    76e <malloc+0x4e>
}
 801:	c9                   	leave  
 802:	c3                   	ret    

00000803 <isspace>:

#include "common.h"

int isspace(char c) {
 803:	55                   	push   %ebp
 804:	89 e5                	mov    %esp,%ebp
 806:	83 ec 04             	sub    $0x4,%esp
 809:	8b 45 08             	mov    0x8(%ebp),%eax
 80c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 80f:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 813:	74 12                	je     827 <isspace+0x24>
 815:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 819:	74 0c                	je     827 <isspace+0x24>
 81b:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 81f:	74 06                	je     827 <isspace+0x24>
 821:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 825:	75 07                	jne    82e <isspace+0x2b>
 827:	b8 01 00 00 00       	mov    $0x1,%eax
 82c:	eb 05                	jmp    833 <isspace+0x30>
 82e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 833:	c9                   	leave  
 834:	c3                   	ret    

00000835 <readln>:

char* readln(char *buf, int max, int fd)
{
 835:	55                   	push   %ebp
 836:	89 e5                	mov    %esp,%ebp
 838:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 83b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 842:	eb 45                	jmp    889 <readln+0x54>
    cc = read(fd, &c, 1);
 844:	83 ec 04             	sub    $0x4,%esp
 847:	6a 01                	push   $0x1
 849:	8d 45 ef             	lea    -0x11(%ebp),%eax
 84c:	50                   	push   %eax
 84d:	ff 75 10             	pushl  0x10(%ebp)
 850:	e8 7d fa ff ff       	call   2d2 <read>
 855:	83 c4 10             	add    $0x10,%esp
 858:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 85b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85f:	7f 02                	jg     863 <readln+0x2e>
      break;
 861:	eb 31                	jmp    894 <readln+0x5f>
    buf[i++] = c;
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	8d 50 01             	lea    0x1(%eax),%edx
 869:	89 55 f4             	mov    %edx,-0xc(%ebp)
 86c:	89 c2                	mov    %eax,%edx
 86e:	8b 45 08             	mov    0x8(%ebp),%eax
 871:	01 c2                	add    %eax,%edx
 873:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 877:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 879:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 87d:	3c 0a                	cmp    $0xa,%al
 87f:	74 13                	je     894 <readln+0x5f>
 881:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 885:	3c 0d                	cmp    $0xd,%al
 887:	74 0b                	je     894 <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	83 c0 01             	add    $0x1,%eax
 88f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 892:	7c b0                	jl     844 <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 894:	8b 55 f4             	mov    -0xc(%ebp),%edx
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	01 d0                	add    %edx,%eax
 89c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 89f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8a2:	c9                   	leave  
 8a3:	c3                   	ret    

000008a4 <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 8a4:	55                   	push   %ebp
 8a5:	89 e5                	mov    %esp,%ebp
 8a7:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8b1:	eb 19                	jmp    8cc <strncpy+0x28>
		dest[i] = src[i];
 8b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8b6:	8b 45 08             	mov    0x8(%ebp),%eax
 8b9:	01 c2                	add    %eax,%edx
 8bb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 8be:	8b 45 0c             	mov    0xc(%ebp),%eax
 8c1:	01 c8                	add    %ecx,%eax
 8c3:	0f b6 00             	movzbl (%eax),%eax
 8c6:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	3b 45 10             	cmp    0x10(%ebp),%eax
 8d2:	7d 0f                	jge    8e3 <strncpy+0x3f>
 8d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 8da:	01 d0                	add    %edx,%eax
 8dc:	0f b6 00             	movzbl (%eax),%eax
 8df:	84 c0                	test   %al,%al
 8e1:	75 d0                	jne    8b3 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 8e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8e6:	c9                   	leave  
 8e7:	c3                   	ret    

000008e8 <trim>:

char* trim(char* orig) {
 8e8:	55                   	push   %ebp
 8e9:	89 e5                	mov    %esp,%ebp
 8eb:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 8ee:	8b 45 08             	mov    0x8(%ebp),%eax
 8f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 8f4:	8b 45 08             	mov    0x8(%ebp),%eax
 8f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 8fa:	eb 04                	jmp    900 <trim+0x18>
 8fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	0f b6 00             	movzbl (%eax),%eax
 906:	0f be c0             	movsbl %al,%eax
 909:	50                   	push   %eax
 90a:	e8 f4 fe ff ff       	call   803 <isspace>
 90f:	83 c4 04             	add    $0x4,%esp
 912:	85 c0                	test   %eax,%eax
 914:	75 e6                	jne    8fc <trim+0x14>
	while (*tail) { tail++; }
 916:	eb 04                	jmp    91c <trim+0x34>
 918:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 91c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91f:	0f b6 00             	movzbl (%eax),%eax
 922:	84 c0                	test   %al,%al
 924:	75 f2                	jne    918 <trim+0x30>
	do { tail--; } while (isspace(*tail));
 926:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 92a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92d:	0f b6 00             	movzbl (%eax),%eax
 930:	0f be c0             	movsbl %al,%eax
 933:	50                   	push   %eax
 934:	e8 ca fe ff ff       	call   803 <isspace>
 939:	83 c4 04             	add    $0x4,%esp
 93c:	85 c0                	test   %eax,%eax
 93e:	75 e6                	jne    926 <trim+0x3e>
	new = malloc(tail-head+2);
 940:	8b 55 f0             	mov    -0x10(%ebp),%edx
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	29 c2                	sub    %eax,%edx
 948:	89 d0                	mov    %edx,%eax
 94a:	83 c0 02             	add    $0x2,%eax
 94d:	83 ec 0c             	sub    $0xc,%esp
 950:	50                   	push   %eax
 951:	e8 ca fd ff ff       	call   720 <malloc>
 956:	83 c4 10             	add    $0x10,%esp
 959:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 95c:	8b 55 f0             	mov    -0x10(%ebp),%edx
 95f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 962:	29 c2                	sub    %eax,%edx
 964:	89 d0                	mov    %edx,%eax
 966:	83 c0 01             	add    $0x1,%eax
 969:	83 ec 04             	sub    $0x4,%esp
 96c:	50                   	push   %eax
 96d:	ff 75 f4             	pushl  -0xc(%ebp)
 970:	ff 75 ec             	pushl  -0x14(%ebp)
 973:	e8 2c ff ff ff       	call   8a4 <strncpy>
 978:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 97b:	8b 55 f0             	mov    -0x10(%ebp),%edx
 97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 981:	29 c2                	sub    %eax,%edx
 983:	89 d0                	mov    %edx,%eax
 985:	8d 50 01             	lea    0x1(%eax),%edx
 988:	8b 45 ec             	mov    -0x14(%ebp),%eax
 98b:	01 d0                	add    %edx,%eax
 98d:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 990:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 993:	c9                   	leave  
 994:	c3                   	ret    

00000995 <itoa>:

char *
itoa(int value)
{
 995:	55                   	push   %ebp
 996:	89 e5                	mov    %esp,%ebp
 998:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 99b:	8d 45 bf             	lea    -0x41(%ebp),%eax
 99e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 9a1:	8b 45 08             	mov    0x8(%ebp),%eax
 9a4:	c1 e8 1f             	shr    $0x1f,%eax
 9a7:	0f b6 c0             	movzbl %al,%eax
 9aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 9ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 9b1:	74 0a                	je     9bd <itoa+0x28>
    v = -value;
 9b3:	8b 45 08             	mov    0x8(%ebp),%eax
 9b6:	f7 d8                	neg    %eax
 9b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9bb:	eb 06                	jmp    9c3 <itoa+0x2e>
  else
    v = (uint)value;
 9bd:	8b 45 08             	mov    0x8(%ebp),%eax
 9c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 9c3:	eb 5b                	jmp    a20 <itoa+0x8b>
  {
    i = v % 10;
 9c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 9c8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9cd:	89 c8                	mov    %ecx,%eax
 9cf:	f7 e2                	mul    %edx
 9d1:	c1 ea 03             	shr    $0x3,%edx
 9d4:	89 d0                	mov    %edx,%eax
 9d6:	c1 e0 02             	shl    $0x2,%eax
 9d9:	01 d0                	add    %edx,%eax
 9db:	01 c0                	add    %eax,%eax
 9dd:	29 c1                	sub    %eax,%ecx
 9df:	89 ca                	mov    %ecx,%edx
 9e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 9e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e7:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9ec:	f7 e2                	mul    %edx
 9ee:	89 d0                	mov    %edx,%eax
 9f0:	c1 e8 03             	shr    $0x3,%eax
 9f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 9f6:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 9fa:	7f 13                	jg     a0f <itoa+0x7a>
      *tp++ = i+'0';
 9fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ff:	8d 50 01             	lea    0x1(%eax),%edx
 a02:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a08:	83 c2 30             	add    $0x30,%edx
 a0b:	88 10                	mov    %dl,(%eax)
 a0d:	eb 11                	jmp    a20 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a12:	8d 50 01             	lea    0x1(%eax),%edx
 a15:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a18:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a1b:	83 c2 57             	add    $0x57,%edx
 a1e:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 a20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a24:	75 9f                	jne    9c5 <itoa+0x30>
 a26:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a29:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a2c:	74 97                	je     9c5 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a31:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a34:	29 c2                	sub    %eax,%edx
 a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a39:	01 d0                	add    %edx,%eax
 a3b:	83 c0 01             	add    $0x1,%eax
 a3e:	83 ec 0c             	sub    $0xc,%esp
 a41:	50                   	push   %eax
 a42:	e8 d9 fc ff ff       	call   720 <malloc>
 a47:	83 c4 10             	add    $0x10,%esp
 a4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a50:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a57:	74 0c                	je     a65 <itoa+0xd0>
    *sp++ = '-';
 a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a5c:	8d 50 01             	lea    0x1(%eax),%edx
 a5f:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a62:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a65:	eb 15                	jmp    a7c <itoa+0xe7>
    *sp++ = *--tp;
 a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a6a:	8d 50 01             	lea    0x1(%eax),%edx
 a6d:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a70:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a74:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a77:	0f b6 12             	movzbl (%edx),%edx
 a7a:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 a7c:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a7f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a82:	77 e3                	ja     a67 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a87:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 a8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 a8d:	c9                   	leave  
 a8e:	c3                   	ret    

00000a8f <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 a8f:	55                   	push   %ebp
 a90:	89 e5                	mov    %esp,%ebp
 a92:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 a98:	83 ec 08             	sub    $0x8,%esp
 a9b:	6a 00                	push   $0x0
 a9d:	ff 75 08             	pushl  0x8(%ebp)
 aa0:	e8 55 f8 ff ff       	call   2fa <open>
 aa5:	83 c4 10             	add    $0x10,%esp
 aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 aab:	e9 22 01 00 00       	jmp    bd2 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 ab0:	83 ec 08             	sub    $0x8,%esp
 ab3:	6a 3d                	push   $0x3d
 ab5:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 abb:	50                   	push   %eax
 abc:	e8 79 f6 ff ff       	call   13a <strchr>
 ac1:	83 c4 10             	add    $0x10,%esp
 ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 ac7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 acb:	0f 84 23 01 00 00    	je     bf4 <parseEnvFile+0x165>
 ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ad5:	0f 84 19 01 00 00    	je     bf4 <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 adb:	8b 55 f0             	mov    -0x10(%ebp),%edx
 ade:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ae4:	29 c2                	sub    %eax,%edx
 ae6:	89 d0                	mov    %edx,%eax
 ae8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aee:	83 c0 01             	add    $0x1,%eax
 af1:	83 ec 0c             	sub    $0xc,%esp
 af4:	50                   	push   %eax
 af5:	e8 26 fc ff ff       	call   720 <malloc>
 afa:	83 c4 10             	add    $0x10,%esp
 afd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 b00:	83 ec 04             	sub    $0x4,%esp
 b03:	ff 75 ec             	pushl  -0x14(%ebp)
 b06:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b0c:	50                   	push   %eax
 b0d:	ff 75 e8             	pushl  -0x18(%ebp)
 b10:	e8 8f fd ff ff       	call   8a4 <strncpy>
 b15:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 b18:	83 ec 0c             	sub    $0xc,%esp
 b1b:	ff 75 e8             	pushl  -0x18(%ebp)
 b1e:	e8 c5 fd ff ff       	call   8e8 <trim>
 b23:	83 c4 10             	add    $0x10,%esp
 b26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 b29:	83 ec 0c             	sub    $0xc,%esp
 b2c:	ff 75 e8             	pushl  -0x18(%ebp)
 b2f:	e8 ab fa ff ff       	call   5df <free>
 b34:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 b37:	83 ec 08             	sub    $0x8,%esp
 b3a:	ff 75 0c             	pushl  0xc(%ebp)
 b3d:	ff 75 e4             	pushl  -0x1c(%ebp)
 b40:	e8 c2 01 00 00       	call   d07 <addToEnvironment>
 b45:	83 c4 10             	add    $0x10,%esp
 b48:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b4b:	83 ec 0c             	sub    $0xc,%esp
 b4e:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b54:	50                   	push   %eax
 b55:	e8 9f f5 ff ff       	call   f9 <strlen>
 b5a:	83 c4 10             	add    $0x10,%esp
 b5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b63:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b66:	83 ec 0c             	sub    $0xc,%esp
 b69:	50                   	push   %eax
 b6a:	e8 b1 fb ff ff       	call   720 <malloc>
 b6f:	83 c4 10             	add    $0x10,%esp
 b72:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b78:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b7b:	8d 50 ff             	lea    -0x1(%eax),%edx
 b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b81:	8d 48 01             	lea    0x1(%eax),%ecx
 b84:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b8a:	01 c8                	add    %ecx,%eax
 b8c:	83 ec 04             	sub    $0x4,%esp
 b8f:	52                   	push   %edx
 b90:	50                   	push   %eax
 b91:	ff 75 e8             	pushl  -0x18(%ebp)
 b94:	e8 0b fd ff ff       	call   8a4 <strncpy>
 b99:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 b9c:	83 ec 0c             	sub    $0xc,%esp
 b9f:	ff 75 e8             	pushl  -0x18(%ebp)
 ba2:	e8 41 fd ff ff       	call   8e8 <trim>
 ba7:	83 c4 10             	add    $0x10,%esp
 baa:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 bad:	83 ec 0c             	sub    $0xc,%esp
 bb0:	ff 75 e8             	pushl  -0x18(%ebp)
 bb3:	e8 27 fa ff ff       	call   5df <free>
 bb8:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 bbb:	83 ec 04             	sub    $0x4,%esp
 bbe:	ff 75 dc             	pushl  -0x24(%ebp)
 bc1:	ff 75 0c             	pushl  0xc(%ebp)
 bc4:	ff 75 e4             	pushl  -0x1c(%ebp)
 bc7:	e8 b8 01 00 00       	call   d84 <addValueToVariable>
 bcc:	83 c4 10             	add    $0x10,%esp
 bcf:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 bd2:	83 ec 04             	sub    $0x4,%esp
 bd5:	ff 75 f4             	pushl  -0xc(%ebp)
 bd8:	68 00 04 00 00       	push   $0x400
 bdd:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 be3:	50                   	push   %eax
 be4:	e8 4c fc ff ff       	call   835 <readln>
 be9:	83 c4 10             	add    $0x10,%esp
 bec:	85 c0                	test   %eax,%eax
 bee:	0f 85 bc fe ff ff    	jne    ab0 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 bf4:	83 ec 0c             	sub    $0xc,%esp
 bf7:	ff 75 f4             	pushl  -0xc(%ebp)
 bfa:	e8 e3 f6 ff ff       	call   2e2 <close>
 bff:	83 c4 10             	add    $0x10,%esp
	return head;
 c02:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c05:	c9                   	leave  
 c06:	c3                   	ret    

00000c07 <comp>:

int comp(const char* s1, const char* s2)
{
 c07:	55                   	push   %ebp
 c08:	89 e5                	mov    %esp,%ebp
 c0a:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 c0d:	83 ec 08             	sub    $0x8,%esp
 c10:	ff 75 0c             	pushl  0xc(%ebp)
 c13:	ff 75 08             	pushl  0x8(%ebp)
 c16:	e8 9f f4 ff ff       	call   ba <strcmp>
 c1b:	83 c4 10             	add    $0x10,%esp
 c1e:	85 c0                	test   %eax,%eax
 c20:	0f 94 c0             	sete   %al
 c23:	0f b6 c0             	movzbl %al,%eax
}
 c26:	c9                   	leave  
 c27:	c3                   	ret    

00000c28 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 c28:	55                   	push   %ebp
 c29:	89 e5                	mov    %esp,%ebp
 c2b:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 c2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c32:	75 07                	jne    c3b <environLookup+0x13>
    return NULL;
 c34:	b8 00 00 00 00       	mov    $0x0,%eax
 c39:	eb 2f                	jmp    c6a <environLookup+0x42>
  
  while (head)
 c3b:	eb 24                	jmp    c61 <environLookup+0x39>
  {
    if (comp(name, head->name))
 c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
 c40:	83 ec 08             	sub    $0x8,%esp
 c43:	50                   	push   %eax
 c44:	ff 75 08             	pushl  0x8(%ebp)
 c47:	e8 bb ff ff ff       	call   c07 <comp>
 c4c:	83 c4 10             	add    $0x10,%esp
 c4f:	85 c0                	test   %eax,%eax
 c51:	74 02                	je     c55 <environLookup+0x2d>
      break;
 c53:	eb 12                	jmp    c67 <environLookup+0x3f>
    head = head->next;
 c55:	8b 45 0c             	mov    0xc(%ebp),%eax
 c58:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c5e:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c65:	75 d6                	jne    c3d <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c67:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c6a:	c9                   	leave  
 c6b:	c3                   	ret    

00000c6c <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c6c:	55                   	push   %ebp
 c6d:	89 e5                	mov    %esp,%ebp
 c6f:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c76:	75 0a                	jne    c82 <removeFromEnvironment+0x16>
    return NULL;
 c78:	b8 00 00 00 00       	mov    $0x0,%eax
 c7d:	e9 83 00 00 00       	jmp    d05 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 c82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c86:	74 0a                	je     c92 <removeFromEnvironment+0x26>
 c88:	8b 45 08             	mov    0x8(%ebp),%eax
 c8b:	0f b6 00             	movzbl (%eax),%eax
 c8e:	84 c0                	test   %al,%al
 c90:	75 05                	jne    c97 <removeFromEnvironment+0x2b>
    return head;
 c92:	8b 45 0c             	mov    0xc(%ebp),%eax
 c95:	eb 6e                	jmp    d05 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 c97:	8b 45 0c             	mov    0xc(%ebp),%eax
 c9a:	83 ec 08             	sub    $0x8,%esp
 c9d:	ff 75 08             	pushl  0x8(%ebp)
 ca0:	50                   	push   %eax
 ca1:	e8 61 ff ff ff       	call   c07 <comp>
 ca6:	83 c4 10             	add    $0x10,%esp
 ca9:	85 c0                	test   %eax,%eax
 cab:	74 34                	je     ce1 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 cad:	8b 45 0c             	mov    0xc(%ebp),%eax
 cb0:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
 cbc:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 cc2:	83 ec 0c             	sub    $0xc,%esp
 cc5:	50                   	push   %eax
 cc6:	e8 74 01 00 00       	call   e3f <freeVarval>
 ccb:	83 c4 10             	add    $0x10,%esp
    free(head);
 cce:	83 ec 0c             	sub    $0xc,%esp
 cd1:	ff 75 0c             	pushl  0xc(%ebp)
 cd4:	e8 06 f9 ff ff       	call   5df <free>
 cd9:	83 c4 10             	add    $0x10,%esp
    return tmp;
 cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cdf:	eb 24                	jmp    d05 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
 ce4:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cea:	83 ec 08             	sub    $0x8,%esp
 ced:	50                   	push   %eax
 cee:	ff 75 08             	pushl  0x8(%ebp)
 cf1:	e8 76 ff ff ff       	call   c6c <removeFromEnvironment>
 cf6:	83 c4 10             	add    $0x10,%esp
 cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
 cfc:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 d02:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d05:	c9                   	leave  
 d06:	c3                   	ret    

00000d07 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 d07:	55                   	push   %ebp
 d08:	89 e5                	mov    %esp,%ebp
 d0a:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 d0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 d11:	75 05                	jne    d18 <addToEnvironment+0x11>
		return head;
 d13:	8b 45 0c             	mov    0xc(%ebp),%eax
 d16:	eb 6a                	jmp    d82 <addToEnvironment+0x7b>
	if (head == NULL) {
 d18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 d1c:	75 40                	jne    d5e <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 d1e:	83 ec 0c             	sub    $0xc,%esp
 d21:	68 88 00 00 00       	push   $0x88
 d26:	e8 f5 f9 ff ff       	call   720 <malloc>
 d2b:	83 c4 10             	add    $0x10,%esp
 d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 d31:	8b 45 08             	mov    0x8(%ebp),%eax
 d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d3a:	83 ec 08             	sub    $0x8,%esp
 d3d:	ff 75 f0             	pushl  -0x10(%ebp)
 d40:	50                   	push   %eax
 d41:	e8 44 f3 ff ff       	call   8a <strcpy>
 d46:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d4c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d53:	00 00 00 
		head = newVar;
 d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d59:	89 45 0c             	mov    %eax,0xc(%ebp)
 d5c:	eb 21                	jmp    d7f <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
 d61:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d67:	83 ec 08             	sub    $0x8,%esp
 d6a:	50                   	push   %eax
 d6b:	ff 75 08             	pushl  0x8(%ebp)
 d6e:	e8 94 ff ff ff       	call   d07 <addToEnvironment>
 d73:	83 c4 10             	add    $0x10,%esp
 d76:	8b 55 0c             	mov    0xc(%ebp),%edx
 d79:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d82:	c9                   	leave  
 d83:	c3                   	ret    

00000d84 <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 d84:	55                   	push   %ebp
 d85:	89 e5                	mov    %esp,%ebp
 d87:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 d8a:	83 ec 08             	sub    $0x8,%esp
 d8d:	ff 75 0c             	pushl  0xc(%ebp)
 d90:	ff 75 08             	pushl  0x8(%ebp)
 d93:	e8 90 fe ff ff       	call   c28 <environLookup>
 d98:	83 c4 10             	add    $0x10,%esp
 d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 d9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 da2:	75 05                	jne    da9 <addValueToVariable+0x25>
		return head;
 da4:	8b 45 0c             	mov    0xc(%ebp),%eax
 da7:	eb 4c                	jmp    df5 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 da9:	83 ec 0c             	sub    $0xc,%esp
 dac:	68 04 04 00 00       	push   $0x404
 db1:	e8 6a f9 ff ff       	call   720 <malloc>
 db6:	83 c4 10             	add    $0x10,%esp
 db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 dbc:	8b 45 10             	mov    0x10(%ebp),%eax
 dbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dc5:	83 ec 08             	sub    $0x8,%esp
 dc8:	ff 75 ec             	pushl  -0x14(%ebp)
 dcb:	50                   	push   %eax
 dcc:	e8 b9 f2 ff ff       	call   8a <strcpy>
 dd1:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 de0:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de9:	8b 55 f0             	mov    -0x10(%ebp),%edx
 dec:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 df2:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 df5:	c9                   	leave  
 df6:	c3                   	ret    

00000df7 <freeEnvironment>:

void freeEnvironment(variable* head)
{
 df7:	55                   	push   %ebp
 df8:	89 e5                	mov    %esp,%ebp
 dfa:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 dfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e01:	75 02                	jne    e05 <freeEnvironment+0xe>
    return;  
 e03:	eb 38                	jmp    e3d <freeEnvironment+0x46>
  freeEnvironment(head->next);
 e05:	8b 45 08             	mov    0x8(%ebp),%eax
 e08:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 e0e:	83 ec 0c             	sub    $0xc,%esp
 e11:	50                   	push   %eax
 e12:	e8 e0 ff ff ff       	call   df7 <freeEnvironment>
 e17:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 e1a:	8b 45 08             	mov    0x8(%ebp),%eax
 e1d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 e23:	83 ec 0c             	sub    $0xc,%esp
 e26:	50                   	push   %eax
 e27:	e8 13 00 00 00       	call   e3f <freeVarval>
 e2c:	83 c4 10             	add    $0x10,%esp
  free(head);
 e2f:	83 ec 0c             	sub    $0xc,%esp
 e32:	ff 75 08             	pushl  0x8(%ebp)
 e35:	e8 a5 f7 ff ff       	call   5df <free>
 e3a:	83 c4 10             	add    $0x10,%esp
}
 e3d:	c9                   	leave  
 e3e:	c3                   	ret    

00000e3f <freeVarval>:

void freeVarval(varval* head)
{
 e3f:	55                   	push   %ebp
 e40:	89 e5                	mov    %esp,%ebp
 e42:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e49:	75 02                	jne    e4d <freeVarval+0xe>
    return;  
 e4b:	eb 23                	jmp    e70 <freeVarval+0x31>
  freeVarval(head->next);
 e4d:	8b 45 08             	mov    0x8(%ebp),%eax
 e50:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e56:	83 ec 0c             	sub    $0xc,%esp
 e59:	50                   	push   %eax
 e5a:	e8 e0 ff ff ff       	call   e3f <freeVarval>
 e5f:	83 c4 10             	add    $0x10,%esp
  free(head);
 e62:	83 ec 0c             	sub    $0xc,%esp
 e65:	ff 75 08             	pushl  0x8(%ebp)
 e68:	e8 72 f7 ff ff       	call   5df <free>
 e6d:	83 c4 10             	add    $0x10,%esp
}
 e70:	c9                   	leave  
 e71:	c3                   	ret    

00000e72 <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e72:	55                   	push   %ebp
 e73:	89 e5                	mov    %esp,%ebp
 e75:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 e78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e7c:	75 08                	jne    e86 <getPaths+0x14>
		return head;
 e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
 e81:	e9 e7 00 00 00       	jmp    f6d <getPaths+0xfb>
	if (head == NULL) {
 e86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 e8a:	0f 85 b9 00 00 00    	jne    f49 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 e90:	83 ec 08             	sub    $0x8,%esp
 e93:	6a 3a                	push   $0x3a
 e95:	ff 75 08             	pushl  0x8(%ebp)
 e98:	e8 9d f2 ff ff       	call   13a <strchr>
 e9d:	83 c4 10             	add    $0x10,%esp
 ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 ea3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ea7:	75 56                	jne    eff <getPaths+0x8d>
			pathLen = strlen(paths);
 ea9:	83 ec 0c             	sub    $0xc,%esp
 eac:	ff 75 08             	pushl  0x8(%ebp)
 eaf:	e8 45 f2 ff ff       	call   f9 <strlen>
 eb4:	83 c4 10             	add    $0x10,%esp
 eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 eba:	83 ec 0c             	sub    $0xc,%esp
 ebd:	68 04 04 00 00       	push   $0x404
 ec2:	e8 59 f8 ff ff       	call   720 <malloc>
 ec7:	83 c4 10             	add    $0x10,%esp
 eca:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
 ed0:	83 ec 04             	sub    $0x4,%esp
 ed3:	ff 75 f0             	pushl  -0x10(%ebp)
 ed6:	ff 75 08             	pushl  0x8(%ebp)
 ed9:	50                   	push   %eax
 eda:	e8 c5 f9 ff ff       	call   8a4 <strncpy>
 edf:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 ee2:	8b 55 0c             	mov    0xc(%ebp),%edx
 ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ee8:	01 d0                	add    %edx,%eax
 eea:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 eed:	8b 45 0c             	mov    0xc(%ebp),%eax
 ef0:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 ef7:	00 00 00 
			return head;
 efa:	8b 45 0c             	mov    0xc(%ebp),%eax
 efd:	eb 6e                	jmp    f6d <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
 f02:	8b 45 08             	mov    0x8(%ebp),%eax
 f05:	29 c2                	sub    %eax,%edx
 f07:	89 d0                	mov    %edx,%eax
 f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 f0c:	83 ec 0c             	sub    $0xc,%esp
 f0f:	68 04 04 00 00       	push   $0x404
 f14:	e8 07 f8 ff ff       	call   720 <malloc>
 f19:	83 c4 10             	add    $0x10,%esp
 f1c:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
 f22:	83 ec 04             	sub    $0x4,%esp
 f25:	ff 75 f0             	pushl  -0x10(%ebp)
 f28:	ff 75 08             	pushl  0x8(%ebp)
 f2b:	50                   	push   %eax
 f2c:	e8 73 f9 ff ff       	call   8a4 <strncpy>
 f31:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f34:	8b 55 0c             	mov    0xc(%ebp),%edx
 f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f3a:	01 d0                	add    %edx,%eax
 f3c:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f42:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 f45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f49:	8b 45 0c             	mov    0xc(%ebp),%eax
 f4c:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f52:	83 ec 08             	sub    $0x8,%esp
 f55:	50                   	push   %eax
 f56:	ff 75 08             	pushl  0x8(%ebp)
 f59:	e8 14 ff ff ff       	call   e72 <getPaths>
 f5e:	83 c4 10             	add    $0x10,%esp
 f61:	8b 55 0c             	mov    0xc(%ebp),%edx
 f64:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f6d:	c9                   	leave  
 f6e:	c3                   	ret    
