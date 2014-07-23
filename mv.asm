
_mv:     формат файла elf32-i386


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
    printf(2, "mv: usage: mv source dest\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 8c 0f 00 00       	push   $0xf8c
  1e:	6a 02                	push   $0x2
  20:	e8 47 04 00 00       	call   46c <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 aa 02 00 00       	call   2d7 <exit>
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
  42:	e8 f0 02 00 00       	call   337 <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 1b                	jns    69 <main+0x69>
    printf(2, "mv: can't move %s\n", argv[1]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 04             	add    $0x4,%eax
  54:	8b 00                	mov    (%eax),%eax
  56:	83 ec 04             	sub    $0x4,%esp
  59:	50                   	push   %eax
  5a:	68 a7 0f 00 00       	push   $0xfa7
  5f:	6a 02                	push   $0x2
  61:	e8 06 04 00 00       	call   46c <printf>
  66:	83 c4 10             	add    $0x10,%esp
  unlink(argv[1]);
  69:	8b 43 04             	mov    0x4(%ebx),%eax
  6c:	83 c0 04             	add    $0x4,%eax
  6f:	8b 00                	mov    (%eax),%eax
  71:	83 ec 0c             	sub    $0xc,%esp
  74:	50                   	push   %eax
  75:	e8 ad 02 00 00       	call   327 <unlink>
  7a:	83 c4 10             	add    $0x10,%esp
  exit();
  7d:	e8 55 02 00 00       	call   2d7 <exit>

00000082 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  85:	57                   	push   %edi
  86:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8a:	8b 55 10             	mov    0x10(%ebp),%edx
  8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  90:	89 cb                	mov    %ecx,%ebx
  92:	89 df                	mov    %ebx,%edi
  94:	89 d1                	mov    %edx,%ecx
  96:	fc                   	cld    
  97:	f3 aa                	rep stos %al,%es:(%edi)
  99:	89 ca                	mov    %ecx,%edx
  9b:	89 fb                	mov    %edi,%ebx
  9d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a3:	5b                   	pop    %ebx
  a4:	5f                   	pop    %edi
  a5:	5d                   	pop    %ebp
  a6:	c3                   	ret    

000000a7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a7:	55                   	push   %ebp
  a8:	89 e5                	mov    %esp,%ebp
  aa:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ad:	8b 45 08             	mov    0x8(%ebp),%eax
  b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b3:	90                   	nop
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	8d 50 01             	lea    0x1(%eax),%edx
  ba:	89 55 08             	mov    %edx,0x8(%ebp)
  bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  c3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  c6:	0f b6 12             	movzbl (%edx),%edx
  c9:	88 10                	mov    %dl,(%eax)
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	75 e2                	jne    b4 <strcpy+0xd>
    ;
  return os;
  d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d5:	c9                   	leave  
  d6:	c3                   	ret    

000000d7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  da:	eb 08                	jmp    e4 <strcmp+0xd>
    p++, q++;
  dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	0f b6 00             	movzbl (%eax),%eax
  ea:	84 c0                	test   %al,%al
  ec:	74 10                	je     fe <strcmp+0x27>
  ee:	8b 45 08             	mov    0x8(%ebp),%eax
  f1:	0f b6 10             	movzbl (%eax),%edx
  f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  f7:	0f b6 00             	movzbl (%eax),%eax
  fa:	38 c2                	cmp    %al,%dl
  fc:	74 de                	je     dc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fe:	8b 45 08             	mov    0x8(%ebp),%eax
 101:	0f b6 00             	movzbl (%eax),%eax
 104:	0f b6 d0             	movzbl %al,%edx
 107:	8b 45 0c             	mov    0xc(%ebp),%eax
 10a:	0f b6 00             	movzbl (%eax),%eax
 10d:	0f b6 c0             	movzbl %al,%eax
 110:	29 c2                	sub    %eax,%edx
 112:	89 d0                	mov    %edx,%eax
}
 114:	5d                   	pop    %ebp
 115:	c3                   	ret    

00000116 <strlen>:

uint
strlen(char *s)
{
 116:	55                   	push   %ebp
 117:	89 e5                	mov    %esp,%ebp
 119:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 123:	eb 04                	jmp    129 <strlen+0x13>
 125:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 129:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	01 d0                	add    %edx,%eax
 131:	0f b6 00             	movzbl (%eax),%eax
 134:	84 c0                	test   %al,%al
 136:	75 ed                	jne    125 <strlen+0xf>
    ;
  return n;
 138:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13b:	c9                   	leave  
 13c:	c3                   	ret    

0000013d <memset>:

void*
memset(void *dst, int c, uint n)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 140:	8b 45 10             	mov    0x10(%ebp),%eax
 143:	50                   	push   %eax
 144:	ff 75 0c             	pushl  0xc(%ebp)
 147:	ff 75 08             	pushl  0x8(%ebp)
 14a:	e8 33 ff ff ff       	call   82 <stosb>
 14f:	83 c4 0c             	add    $0xc,%esp
  return dst;
 152:	8b 45 08             	mov    0x8(%ebp),%eax
}
 155:	c9                   	leave  
 156:	c3                   	ret    

00000157 <strchr>:

char*
strchr(const char *s, char c)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	83 ec 04             	sub    $0x4,%esp
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 163:	eb 14                	jmp    179 <strchr+0x22>
    if(*s == c)
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	0f b6 00             	movzbl (%eax),%eax
 16b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 16e:	75 05                	jne    175 <strchr+0x1e>
      return (char*)s;
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	eb 13                	jmp    188 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 175:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	0f b6 00             	movzbl (%eax),%eax
 17f:	84 c0                	test   %al,%al
 181:	75 e2                	jne    165 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 183:	b8 00 00 00 00       	mov    $0x0,%eax
}
 188:	c9                   	leave  
 189:	c3                   	ret    

0000018a <gets>:

char*
gets(char *buf, int max)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 197:	eb 44                	jmp    1dd <gets+0x53>
    cc = read(0, &c, 1);
 199:	83 ec 04             	sub    $0x4,%esp
 19c:	6a 01                	push   $0x1
 19e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a1:	50                   	push   %eax
 1a2:	6a 00                	push   $0x0
 1a4:	e8 46 01 00 00       	call   2ef <read>
 1a9:	83 c4 10             	add    $0x10,%esp
 1ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b3:	7f 02                	jg     1b7 <gets+0x2d>
      break;
 1b5:	eb 31                	jmp    1e8 <gets+0x5e>
    buf[i++] = c;
 1b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ba:	8d 50 01             	lea    0x1(%eax),%edx
 1bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c0:	89 c2                	mov    %eax,%edx
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	01 c2                	add    %eax,%edx
 1c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d1:	3c 0a                	cmp    $0xa,%al
 1d3:	74 13                	je     1e8 <gets+0x5e>
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	3c 0d                	cmp    $0xd,%al
 1db:	74 0b                	je     1e8 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e0:	83 c0 01             	add    $0x1,%eax
 1e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e6:	7c b1                	jl     199 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	01 d0                	add    %edx,%eax
 1f0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f6:	c9                   	leave  
 1f7:	c3                   	ret    

000001f8 <stat>:

int
stat(char *n, struct stat *st)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fe:	83 ec 08             	sub    $0x8,%esp
 201:	6a 00                	push   $0x0
 203:	ff 75 08             	pushl  0x8(%ebp)
 206:	e8 0c 01 00 00       	call   317 <open>
 20b:	83 c4 10             	add    $0x10,%esp
 20e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 215:	79 07                	jns    21e <stat+0x26>
    return -1;
 217:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21c:	eb 25                	jmp    243 <stat+0x4b>
  r = fstat(fd, st);
 21e:	83 ec 08             	sub    $0x8,%esp
 221:	ff 75 0c             	pushl  0xc(%ebp)
 224:	ff 75 f4             	pushl  -0xc(%ebp)
 227:	e8 03 01 00 00       	call   32f <fstat>
 22c:	83 c4 10             	add    $0x10,%esp
 22f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 232:	83 ec 0c             	sub    $0xc,%esp
 235:	ff 75 f4             	pushl  -0xc(%ebp)
 238:	e8 c2 00 00 00       	call   2ff <close>
 23d:	83 c4 10             	add    $0x10,%esp
  return r;
 240:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 243:	c9                   	leave  
 244:	c3                   	ret    

00000245 <atoi>:

int
atoi(const char *s)
{
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 24b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 252:	eb 25                	jmp    279 <atoi+0x34>
    n = n*10 + *s++ - '0';
 254:	8b 55 fc             	mov    -0x4(%ebp),%edx
 257:	89 d0                	mov    %edx,%eax
 259:	c1 e0 02             	shl    $0x2,%eax
 25c:	01 d0                	add    %edx,%eax
 25e:	01 c0                	add    %eax,%eax
 260:	89 c1                	mov    %eax,%ecx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	8d 50 01             	lea    0x1(%eax),%edx
 268:	89 55 08             	mov    %edx,0x8(%ebp)
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	0f be c0             	movsbl %al,%eax
 271:	01 c8                	add    %ecx,%eax
 273:	83 e8 30             	sub    $0x30,%eax
 276:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	3c 2f                	cmp    $0x2f,%al
 281:	7e 0a                	jle    28d <atoi+0x48>
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 00             	movzbl (%eax),%eax
 289:	3c 39                	cmp    $0x39,%al
 28b:	7e c7                	jle    254 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 28d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 290:	c9                   	leave  
 291:	c3                   	ret    

00000292 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 29e:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a4:	eb 17                	jmp    2bd <memmove+0x2b>
    *dst++ = *src++;
 2a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a9:	8d 50 01             	lea    0x1(%eax),%edx
 2ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2af:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2b5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b8:	0f b6 12             	movzbl (%edx),%edx
 2bb:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2bd:	8b 45 10             	mov    0x10(%ebp),%eax
 2c0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c3:	89 55 10             	mov    %edx,0x10(%ebp)
 2c6:	85 c0                	test   %eax,%eax
 2c8:	7f dc                	jg     2a6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cd:	c9                   	leave  
 2ce:	c3                   	ret    

000002cf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cf:	b8 01 00 00 00       	mov    $0x1,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <exit>:
SYSCALL(exit)
 2d7:	b8 02 00 00 00       	mov    $0x2,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <wait>:
SYSCALL(wait)
 2df:	b8 03 00 00 00       	mov    $0x3,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <pipe>:
SYSCALL(pipe)
 2e7:	b8 04 00 00 00       	mov    $0x4,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <read>:
SYSCALL(read)
 2ef:	b8 05 00 00 00       	mov    $0x5,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <write>:
SYSCALL(write)
 2f7:	b8 10 00 00 00       	mov    $0x10,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <close>:
SYSCALL(close)
 2ff:	b8 15 00 00 00       	mov    $0x15,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <kill>:
SYSCALL(kill)
 307:	b8 06 00 00 00       	mov    $0x6,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <exec>:
SYSCALL(exec)
 30f:	b8 07 00 00 00       	mov    $0x7,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <open>:
SYSCALL(open)
 317:	b8 0f 00 00 00       	mov    $0xf,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <mknod>:
SYSCALL(mknod)
 31f:	b8 11 00 00 00       	mov    $0x11,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <unlink>:
SYSCALL(unlink)
 327:	b8 12 00 00 00       	mov    $0x12,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <fstat>:
SYSCALL(fstat)
 32f:	b8 08 00 00 00       	mov    $0x8,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <link>:
SYSCALL(link)
 337:	b8 13 00 00 00       	mov    $0x13,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <mkdir>:
SYSCALL(mkdir)
 33f:	b8 14 00 00 00       	mov    $0x14,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <chdir>:
SYSCALL(chdir)
 347:	b8 09 00 00 00       	mov    $0x9,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <dup>:
SYSCALL(dup)
 34f:	b8 0a 00 00 00       	mov    $0xa,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <getpid>:
SYSCALL(getpid)
 357:	b8 0b 00 00 00       	mov    $0xb,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sbrk>:
SYSCALL(sbrk)
 35f:	b8 0c 00 00 00       	mov    $0xc,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <sleep>:
SYSCALL(sleep)
 367:	b8 0d 00 00 00       	mov    $0xd,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <uptime>:
SYSCALL(uptime)
 36f:	b8 0e 00 00 00       	mov    $0xe,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <getcwd>:
SYSCALL(getcwd)
 377:	b8 16 00 00 00       	mov    $0x16,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <shutdown>:
SYSCALL(shutdown)
 37f:	b8 17 00 00 00       	mov    $0x17,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <buildinfo>:
SYSCALL(buildinfo)
 387:	b8 18 00 00 00       	mov    $0x18,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <lseek>:
SYSCALL(lseek)
 38f:	b8 19 00 00 00       	mov    $0x19,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 18             	sub    $0x18,%esp
 39d:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a3:	83 ec 04             	sub    $0x4,%esp
 3a6:	6a 01                	push   $0x1
 3a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ab:	50                   	push   %eax
 3ac:	ff 75 08             	pushl  0x8(%ebp)
 3af:	e8 43 ff ff ff       	call   2f7 <write>
 3b4:	83 c4 10             	add    $0x10,%esp
}
 3b7:	c9                   	leave  
 3b8:	c3                   	ret    

000003b9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b9:	55                   	push   %ebp
 3ba:	89 e5                	mov    %esp,%ebp
 3bc:	53                   	push   %ebx
 3bd:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3cb:	74 17                	je     3e4 <printint+0x2b>
 3cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d1:	79 11                	jns    3e4 <printint+0x2b>
    neg = 1;
 3d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	f7 d8                	neg    %eax
 3df:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e2:	eb 06                	jmp    3ea <printint+0x31>
  } else {
    x = xx;
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3f4:	8d 41 01             	lea    0x1(%ecx),%eax
 3f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 400:	ba 00 00 00 00       	mov    $0x0,%edx
 405:	f7 f3                	div    %ebx
 407:	89 d0                	mov    %edx,%eax
 409:	0f b6 80 d0 13 00 00 	movzbl 0x13d0(%eax),%eax
 410:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 414:	8b 5d 10             	mov    0x10(%ebp),%ebx
 417:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41a:	ba 00 00 00 00       	mov    $0x0,%edx
 41f:	f7 f3                	div    %ebx
 421:	89 45 ec             	mov    %eax,-0x14(%ebp)
 424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 428:	75 c7                	jne    3f1 <printint+0x38>
  if(neg)
 42a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42e:	74 0e                	je     43e <printint+0x85>
    buf[i++] = '-';
 430:	8b 45 f4             	mov    -0xc(%ebp),%eax
 433:	8d 50 01             	lea    0x1(%eax),%edx
 436:	89 55 f4             	mov    %edx,-0xc(%ebp)
 439:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 43e:	eb 1d                	jmp    45d <printint+0xa4>
    putc(fd, buf[i]);
 440:	8d 55 dc             	lea    -0x24(%ebp),%edx
 443:	8b 45 f4             	mov    -0xc(%ebp),%eax
 446:	01 d0                	add    %edx,%eax
 448:	0f b6 00             	movzbl (%eax),%eax
 44b:	0f be c0             	movsbl %al,%eax
 44e:	83 ec 08             	sub    $0x8,%esp
 451:	50                   	push   %eax
 452:	ff 75 08             	pushl  0x8(%ebp)
 455:	e8 3d ff ff ff       	call   397 <putc>
 45a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 45d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 465:	79 d9                	jns    440 <printint+0x87>
    putc(fd, buf[i]);
}
 467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 46a:	c9                   	leave  
 46b:	c3                   	ret    

0000046c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 472:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 479:	8d 45 0c             	lea    0xc(%ebp),%eax
 47c:	83 c0 04             	add    $0x4,%eax
 47f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 482:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 489:	e9 59 01 00 00       	jmp    5e7 <printf+0x17b>
    c = fmt[i] & 0xff;
 48e:	8b 55 0c             	mov    0xc(%ebp),%edx
 491:	8b 45 f0             	mov    -0x10(%ebp),%eax
 494:	01 d0                	add    %edx,%eax
 496:	0f b6 00             	movzbl (%eax),%eax
 499:	0f be c0             	movsbl %al,%eax
 49c:	25 ff 00 00 00       	and    $0xff,%eax
 4a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a8:	75 2c                	jne    4d6 <printf+0x6a>
      if(c == '%'){
 4aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ae:	75 0c                	jne    4bc <printf+0x50>
        state = '%';
 4b0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b7:	e9 27 01 00 00       	jmp    5e3 <printf+0x177>
      } else {
        putc(fd, c);
 4bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4bf:	0f be c0             	movsbl %al,%eax
 4c2:	83 ec 08             	sub    $0x8,%esp
 4c5:	50                   	push   %eax
 4c6:	ff 75 08             	pushl  0x8(%ebp)
 4c9:	e8 c9 fe ff ff       	call   397 <putc>
 4ce:	83 c4 10             	add    $0x10,%esp
 4d1:	e9 0d 01 00 00       	jmp    5e3 <printf+0x177>
      }
    } else if(state == '%'){
 4d6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4da:	0f 85 03 01 00 00    	jne    5e3 <printf+0x177>
      if(c == 'd'){
 4e0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e4:	75 1e                	jne    504 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e9:	8b 00                	mov    (%eax),%eax
 4eb:	6a 01                	push   $0x1
 4ed:	6a 0a                	push   $0xa
 4ef:	50                   	push   %eax
 4f0:	ff 75 08             	pushl  0x8(%ebp)
 4f3:	e8 c1 fe ff ff       	call   3b9 <printint>
 4f8:	83 c4 10             	add    $0x10,%esp
        ap++;
 4fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ff:	e9 d8 00 00 00       	jmp    5dc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 504:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 508:	74 06                	je     510 <printf+0xa4>
 50a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 50e:	75 1e                	jne    52e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 510:	8b 45 e8             	mov    -0x18(%ebp),%eax
 513:	8b 00                	mov    (%eax),%eax
 515:	6a 00                	push   $0x0
 517:	6a 10                	push   $0x10
 519:	50                   	push   %eax
 51a:	ff 75 08             	pushl  0x8(%ebp)
 51d:	e8 97 fe ff ff       	call   3b9 <printint>
 522:	83 c4 10             	add    $0x10,%esp
        ap++;
 525:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 529:	e9 ae 00 00 00       	jmp    5dc <printf+0x170>
      } else if(c == 's'){
 52e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 532:	75 43                	jne    577 <printf+0x10b>
        s = (char*)*ap;
 534:	8b 45 e8             	mov    -0x18(%ebp),%eax
 537:	8b 00                	mov    (%eax),%eax
 539:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 544:	75 07                	jne    54d <printf+0xe1>
          s = "(null)";
 546:	c7 45 f4 ba 0f 00 00 	movl   $0xfba,-0xc(%ebp)
        while(*s != 0){
 54d:	eb 1c                	jmp    56b <printf+0xff>
          putc(fd, *s);
 54f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 552:	0f b6 00             	movzbl (%eax),%eax
 555:	0f be c0             	movsbl %al,%eax
 558:	83 ec 08             	sub    $0x8,%esp
 55b:	50                   	push   %eax
 55c:	ff 75 08             	pushl  0x8(%ebp)
 55f:	e8 33 fe ff ff       	call   397 <putc>
 564:	83 c4 10             	add    $0x10,%esp
          s++;
 567:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	84 c0                	test   %al,%al
 573:	75 da                	jne    54f <printf+0xe3>
 575:	eb 65                	jmp    5dc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 577:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 57b:	75 1d                	jne    59a <printf+0x12e>
        putc(fd, *ap);
 57d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 580:	8b 00                	mov    (%eax),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	83 ec 08             	sub    $0x8,%esp
 588:	50                   	push   %eax
 589:	ff 75 08             	pushl  0x8(%ebp)
 58c:	e8 06 fe ff ff       	call   397 <putc>
 591:	83 c4 10             	add    $0x10,%esp
        ap++;
 594:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 598:	eb 42                	jmp    5dc <printf+0x170>
      } else if(c == '%'){
 59a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 59e:	75 17                	jne    5b7 <printf+0x14b>
        putc(fd, c);
 5a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	83 ec 08             	sub    $0x8,%esp
 5a9:	50                   	push   %eax
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 e5 fd ff ff       	call   397 <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
 5b5:	eb 25                	jmp    5dc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b7:	83 ec 08             	sub    $0x8,%esp
 5ba:	6a 25                	push   $0x25
 5bc:	ff 75 08             	pushl  0x8(%ebp)
 5bf:	e8 d3 fd ff ff       	call   397 <putc>
 5c4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ca:	0f be c0             	movsbl %al,%eax
 5cd:	83 ec 08             	sub    $0x8,%esp
 5d0:	50                   	push   %eax
 5d1:	ff 75 08             	pushl  0x8(%ebp)
 5d4:	e8 be fd ff ff       	call   397 <putc>
 5d9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5e7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ed:	01 d0                	add    %edx,%eax
 5ef:	0f b6 00             	movzbl (%eax),%eax
 5f2:	84 c0                	test   %al,%al
 5f4:	0f 85 94 fe ff ff    	jne    48e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5fa:	c9                   	leave  
 5fb:	c3                   	ret    

000005fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	83 e8 08             	sub    $0x8,%eax
 608:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60b:	a1 ec 13 00 00       	mov    0x13ec,%eax
 610:	89 45 fc             	mov    %eax,-0x4(%ebp)
 613:	eb 24                	jmp    639 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61d:	77 12                	ja     631 <free+0x35>
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 625:	77 24                	ja     64b <free+0x4f>
 627:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62a:	8b 00                	mov    (%eax),%eax
 62c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62f:	77 1a                	ja     64b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	89 45 fc             	mov    %eax,-0x4(%ebp)
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63f:	76 d4                	jbe    615 <free+0x19>
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 649:	76 ca                	jbe    615 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	8b 40 04             	mov    0x4(%eax),%eax
 651:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 658:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65b:	01 c2                	add    %eax,%edx
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	39 c2                	cmp    %eax,%edx
 664:	75 24                	jne    68a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	8b 50 04             	mov    0x4(%eax),%edx
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	8b 40 04             	mov    0x4(%eax),%eax
 674:	01 c2                	add    %eax,%edx
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	8b 10                	mov    (%eax),%edx
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	89 10                	mov    %edx,(%eax)
 688:	eb 0a                	jmp    694 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 10                	mov    (%eax),%edx
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 40 04             	mov    0x4(%eax),%eax
 69a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	01 d0                	add    %edx,%eax
 6a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a9:	75 20                	jne    6cb <free+0xcf>
    p->s.size += bp->s.size;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 50 04             	mov    0x4(%eax),%edx
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	8b 40 04             	mov    0x4(%eax),%eax
 6b7:	01 c2                	add    %eax,%edx
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	8b 10                	mov    (%eax),%edx
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	89 10                	mov    %edx,(%eax)
 6c9:	eb 08                	jmp    6d3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	a3 ec 13 00 00       	mov    %eax,0x13ec
}
 6db:	c9                   	leave  
 6dc:	c3                   	ret    

000006dd <morecore>:

static Header*
morecore(uint nu)
{
 6dd:	55                   	push   %ebp
 6de:	89 e5                	mov    %esp,%ebp
 6e0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6e3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ea:	77 07                	ja     6f3 <morecore+0x16>
    nu = 4096;
 6ec:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6f3:	8b 45 08             	mov    0x8(%ebp),%eax
 6f6:	c1 e0 03             	shl    $0x3,%eax
 6f9:	83 ec 0c             	sub    $0xc,%esp
 6fc:	50                   	push   %eax
 6fd:	e8 5d fc ff ff       	call   35f <sbrk>
 702:	83 c4 10             	add    $0x10,%esp
 705:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 708:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 70c:	75 07                	jne    715 <morecore+0x38>
    return 0;
 70e:	b8 00 00 00 00       	mov    $0x0,%eax
 713:	eb 26                	jmp    73b <morecore+0x5e>
  hp = (Header*)p;
 715:	8b 45 f4             	mov    -0xc(%ebp),%eax
 718:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 71b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71e:	8b 55 08             	mov    0x8(%ebp),%edx
 721:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 724:	8b 45 f0             	mov    -0x10(%ebp),%eax
 727:	83 c0 08             	add    $0x8,%eax
 72a:	83 ec 0c             	sub    $0xc,%esp
 72d:	50                   	push   %eax
 72e:	e8 c9 fe ff ff       	call   5fc <free>
 733:	83 c4 10             	add    $0x10,%esp
  return freep;
 736:	a1 ec 13 00 00       	mov    0x13ec,%eax
}
 73b:	c9                   	leave  
 73c:	c3                   	ret    

0000073d <malloc>:

void*
malloc(uint nbytes)
{
 73d:	55                   	push   %ebp
 73e:	89 e5                	mov    %esp,%ebp
 740:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 743:	8b 45 08             	mov    0x8(%ebp),%eax
 746:	83 c0 07             	add    $0x7,%eax
 749:	c1 e8 03             	shr    $0x3,%eax
 74c:	83 c0 01             	add    $0x1,%eax
 74f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 752:	a1 ec 13 00 00       	mov    0x13ec,%eax
 757:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 75e:	75 23                	jne    783 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 760:	c7 45 f0 e4 13 00 00 	movl   $0x13e4,-0x10(%ebp)
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	a3 ec 13 00 00       	mov    %eax,0x13ec
 76f:	a1 ec 13 00 00       	mov    0x13ec,%eax
 774:	a3 e4 13 00 00       	mov    %eax,0x13e4
    base.s.size = 0;
 779:	c7 05 e8 13 00 00 00 	movl   $0x0,0x13e8
 780:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 794:	72 4d                	jb     7e3 <malloc+0xa6>
      if(p->s.size == nunits)
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79f:	75 0c                	jne    7ad <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 10                	mov    (%eax),%edx
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	89 10                	mov    %edx,(%eax)
 7ab:	eb 26                	jmp    7d3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7b6:	89 c2                	mov    %eax,%edx
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	c1 e0 03             	shl    $0x3,%eax
 7c7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	a3 ec 13 00 00       	mov    %eax,0x13ec
      return (void*)(p + 1);
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	83 c0 08             	add    $0x8,%eax
 7e1:	eb 3b                	jmp    81e <malloc+0xe1>
    }
    if(p == freep)
 7e3:	a1 ec 13 00 00       	mov    0x13ec,%eax
 7e8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7eb:	75 1e                	jne    80b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7ed:	83 ec 0c             	sub    $0xc,%esp
 7f0:	ff 75 ec             	pushl  -0x14(%ebp)
 7f3:	e8 e5 fe ff ff       	call   6dd <morecore>
 7f8:	83 c4 10             	add    $0x10,%esp
 7fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 802:	75 07                	jne    80b <malloc+0xce>
        return 0;
 804:	b8 00 00 00 00       	mov    $0x0,%eax
 809:	eb 13                	jmp    81e <malloc+0xe1>
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
 819:	e9 6d ff ff ff       	jmp    78b <malloc+0x4e>
}
 81e:	c9                   	leave  
 81f:	c3                   	ret    

00000820 <isspace>:

#include "common.h"

int isspace(char c) {
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	83 ec 04             	sub    $0x4,%esp
 826:	8b 45 08             	mov    0x8(%ebp),%eax
 829:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 82c:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 830:	74 12                	je     844 <isspace+0x24>
 832:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 836:	74 0c                	je     844 <isspace+0x24>
 838:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 83c:	74 06                	je     844 <isspace+0x24>
 83e:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 842:	75 07                	jne    84b <isspace+0x2b>
 844:	b8 01 00 00 00       	mov    $0x1,%eax
 849:	eb 05                	jmp    850 <isspace+0x30>
 84b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 850:	c9                   	leave  
 851:	c3                   	ret    

00000852 <readln>:

char* readln(char *buf, int max, int fd)
{
 852:	55                   	push   %ebp
 853:	89 e5                	mov    %esp,%ebp
 855:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 858:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 85f:	eb 45                	jmp    8a6 <readln+0x54>
    cc = read(fd, &c, 1);
 861:	83 ec 04             	sub    $0x4,%esp
 864:	6a 01                	push   $0x1
 866:	8d 45 ef             	lea    -0x11(%ebp),%eax
 869:	50                   	push   %eax
 86a:	ff 75 10             	pushl  0x10(%ebp)
 86d:	e8 7d fa ff ff       	call   2ef <read>
 872:	83 c4 10             	add    $0x10,%esp
 875:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 878:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 87c:	7f 02                	jg     880 <readln+0x2e>
      break;
 87e:	eb 31                	jmp    8b1 <readln+0x5f>
    buf[i++] = c;
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	8d 50 01             	lea    0x1(%eax),%edx
 886:	89 55 f4             	mov    %edx,-0xc(%ebp)
 889:	89 c2                	mov    %eax,%edx
 88b:	8b 45 08             	mov    0x8(%ebp),%eax
 88e:	01 c2                	add    %eax,%edx
 890:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 894:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 896:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 89a:	3c 0a                	cmp    $0xa,%al
 89c:	74 13                	je     8b1 <readln+0x5f>
 89e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8a2:	3c 0d                	cmp    $0xd,%al
 8a4:	74 0b                	je     8b1 <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	83 c0 01             	add    $0x1,%eax
 8ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
 8af:	7c b0                	jl     861 <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 8b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8b4:	8b 45 08             	mov    0x8(%ebp),%eax
 8b7:	01 d0                	add    %edx,%eax
 8b9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 8bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8bf:	c9                   	leave  
 8c0:	c3                   	ret    

000008c1 <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 8c1:	55                   	push   %ebp
 8c2:	89 e5                	mov    %esp,%ebp
 8c4:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8ce:	eb 19                	jmp    8e9 <strncpy+0x28>
		dest[i] = src[i];
 8d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8d3:	8b 45 08             	mov    0x8(%ebp),%eax
 8d6:	01 c2                	add    %eax,%edx
 8d8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 8db:	8b 45 0c             	mov    0xc(%ebp),%eax
 8de:	01 c8                	add    %ecx,%eax
 8e0:	0f b6 00             	movzbl (%eax),%eax
 8e3:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ec:	3b 45 10             	cmp    0x10(%ebp),%eax
 8ef:	7d 0f                	jge    900 <strncpy+0x3f>
 8f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 8f7:	01 d0                	add    %edx,%eax
 8f9:	0f b6 00             	movzbl (%eax),%eax
 8fc:	84 c0                	test   %al,%al
 8fe:	75 d0                	jne    8d0 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 900:	8b 45 08             	mov    0x8(%ebp),%eax
}
 903:	c9                   	leave  
 904:	c3                   	ret    

00000905 <trim>:

char* trim(char* orig) {
 905:	55                   	push   %ebp
 906:	89 e5                	mov    %esp,%ebp
 908:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 90b:	8b 45 08             	mov    0x8(%ebp),%eax
 90e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 911:	8b 45 08             	mov    0x8(%ebp),%eax
 914:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 917:	eb 04                	jmp    91d <trim+0x18>
 919:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	0f b6 00             	movzbl (%eax),%eax
 923:	0f be c0             	movsbl %al,%eax
 926:	50                   	push   %eax
 927:	e8 f4 fe ff ff       	call   820 <isspace>
 92c:	83 c4 04             	add    $0x4,%esp
 92f:	85 c0                	test   %eax,%eax
 931:	75 e6                	jne    919 <trim+0x14>
	while (*tail) { tail++; }
 933:	eb 04                	jmp    939 <trim+0x34>
 935:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 939:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93c:	0f b6 00             	movzbl (%eax),%eax
 93f:	84 c0                	test   %al,%al
 941:	75 f2                	jne    935 <trim+0x30>
	do { tail--; } while (isspace(*tail));
 943:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 947:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94a:	0f b6 00             	movzbl (%eax),%eax
 94d:	0f be c0             	movsbl %al,%eax
 950:	50                   	push   %eax
 951:	e8 ca fe ff ff       	call   820 <isspace>
 956:	83 c4 04             	add    $0x4,%esp
 959:	85 c0                	test   %eax,%eax
 95b:	75 e6                	jne    943 <trim+0x3e>
	new = malloc(tail-head+2);
 95d:	8b 55 f0             	mov    -0x10(%ebp),%edx
 960:	8b 45 f4             	mov    -0xc(%ebp),%eax
 963:	29 c2                	sub    %eax,%edx
 965:	89 d0                	mov    %edx,%eax
 967:	83 c0 02             	add    $0x2,%eax
 96a:	83 ec 0c             	sub    $0xc,%esp
 96d:	50                   	push   %eax
 96e:	e8 ca fd ff ff       	call   73d <malloc>
 973:	83 c4 10             	add    $0x10,%esp
 976:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 979:	8b 55 f0             	mov    -0x10(%ebp),%edx
 97c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97f:	29 c2                	sub    %eax,%edx
 981:	89 d0                	mov    %edx,%eax
 983:	83 c0 01             	add    $0x1,%eax
 986:	83 ec 04             	sub    $0x4,%esp
 989:	50                   	push   %eax
 98a:	ff 75 f4             	pushl  -0xc(%ebp)
 98d:	ff 75 ec             	pushl  -0x14(%ebp)
 990:	e8 2c ff ff ff       	call   8c1 <strncpy>
 995:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 998:	8b 55 f0             	mov    -0x10(%ebp),%edx
 99b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99e:	29 c2                	sub    %eax,%edx
 9a0:	89 d0                	mov    %edx,%eax
 9a2:	8d 50 01             	lea    0x1(%eax),%edx
 9a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9a8:	01 d0                	add    %edx,%eax
 9aa:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 9ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 9b0:	c9                   	leave  
 9b1:	c3                   	ret    

000009b2 <itoa>:

char *
itoa(int value)
{
 9b2:	55                   	push   %ebp
 9b3:	89 e5                	mov    %esp,%ebp
 9b5:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 9b8:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 9be:	8b 45 08             	mov    0x8(%ebp),%eax
 9c1:	c1 e8 1f             	shr    $0x1f,%eax
 9c4:	0f b6 c0             	movzbl %al,%eax
 9c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 9ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 9ce:	74 0a                	je     9da <itoa+0x28>
    v = -value;
 9d0:	8b 45 08             	mov    0x8(%ebp),%eax
 9d3:	f7 d8                	neg    %eax
 9d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9d8:	eb 06                	jmp    9e0 <itoa+0x2e>
  else
    v = (uint)value;
 9da:	8b 45 08             	mov    0x8(%ebp),%eax
 9dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 9e0:	eb 5b                	jmp    a3d <itoa+0x8b>
  {
    i = v % 10;
 9e2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 9e5:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9ea:	89 c8                	mov    %ecx,%eax
 9ec:	f7 e2                	mul    %edx
 9ee:	c1 ea 03             	shr    $0x3,%edx
 9f1:	89 d0                	mov    %edx,%eax
 9f3:	c1 e0 02             	shl    $0x2,%eax
 9f6:	01 d0                	add    %edx,%eax
 9f8:	01 c0                	add    %eax,%eax
 9fa:	29 c1                	sub    %eax,%ecx
 9fc:	89 ca                	mov    %ecx,%edx
 9fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a04:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 a09:	f7 e2                	mul    %edx
 a0b:	89 d0                	mov    %edx,%eax
 a0d:	c1 e8 03             	shr    $0x3,%eax
 a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 a13:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 a17:	7f 13                	jg     a2c <itoa+0x7a>
      *tp++ = i+'0';
 a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1c:	8d 50 01             	lea    0x1(%eax),%edx
 a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a25:	83 c2 30             	add    $0x30,%edx
 a28:	88 10                	mov    %dl,(%eax)
 a2a:	eb 11                	jmp    a3d <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2f:	8d 50 01             	lea    0x1(%eax),%edx
 a32:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a38:	83 c2 57             	add    $0x57,%edx
 a3b:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 a3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a41:	75 9f                	jne    9e2 <itoa+0x30>
 a43:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a46:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a49:	74 97                	je     9e2 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 a4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a4e:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a51:	29 c2                	sub    %eax,%edx
 a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a56:	01 d0                	add    %edx,%eax
 a58:	83 c0 01             	add    $0x1,%eax
 a5b:	83 ec 0c             	sub    $0xc,%esp
 a5e:	50                   	push   %eax
 a5f:	e8 d9 fc ff ff       	call   73d <malloc>
 a64:	83 c4 10             	add    $0x10,%esp
 a67:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a6d:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a74:	74 0c                	je     a82 <itoa+0xd0>
    *sp++ = '-';
 a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a79:	8d 50 01             	lea    0x1(%eax),%edx
 a7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a7f:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a82:	eb 15                	jmp    a99 <itoa+0xe7>
    *sp++ = *--tp;
 a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a87:	8d 50 01             	lea    0x1(%eax),%edx
 a8a:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a8d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a94:	0f b6 12             	movzbl (%edx),%edx
 a97:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 a99:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a9c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a9f:	77 e3                	ja     a84 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa4:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 aa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 aaa:	c9                   	leave  
 aab:	c3                   	ret    

00000aac <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 aac:	55                   	push   %ebp
 aad:	89 e5                	mov    %esp,%ebp
 aaf:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 ab5:	83 ec 08             	sub    $0x8,%esp
 ab8:	6a 00                	push   $0x0
 aba:	ff 75 08             	pushl  0x8(%ebp)
 abd:	e8 55 f8 ff ff       	call   317 <open>
 ac2:	83 c4 10             	add    $0x10,%esp
 ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 ac8:	e9 22 01 00 00       	jmp    bef <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 acd:	83 ec 08             	sub    $0x8,%esp
 ad0:	6a 3d                	push   $0x3d
 ad2:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ad8:	50                   	push   %eax
 ad9:	e8 79 f6 ff ff       	call   157 <strchr>
 ade:	83 c4 10             	add    $0x10,%esp
 ae1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 ae4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ae8:	0f 84 23 01 00 00    	je     c11 <parseEnvFile+0x165>
 aee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 af2:	0f 84 19 01 00 00    	je     c11 <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 af8:	8b 55 f0             	mov    -0x10(%ebp),%edx
 afb:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b01:	29 c2                	sub    %eax,%edx
 b03:	89 d0                	mov    %edx,%eax
 b05:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b0b:	83 c0 01             	add    $0x1,%eax
 b0e:	83 ec 0c             	sub    $0xc,%esp
 b11:	50                   	push   %eax
 b12:	e8 26 fc ff ff       	call   73d <malloc>
 b17:	83 c4 10             	add    $0x10,%esp
 b1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 b1d:	83 ec 04             	sub    $0x4,%esp
 b20:	ff 75 ec             	pushl  -0x14(%ebp)
 b23:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b29:	50                   	push   %eax
 b2a:	ff 75 e8             	pushl  -0x18(%ebp)
 b2d:	e8 8f fd ff ff       	call   8c1 <strncpy>
 b32:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 b35:	83 ec 0c             	sub    $0xc,%esp
 b38:	ff 75 e8             	pushl  -0x18(%ebp)
 b3b:	e8 c5 fd ff ff       	call   905 <trim>
 b40:	83 c4 10             	add    $0x10,%esp
 b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 b46:	83 ec 0c             	sub    $0xc,%esp
 b49:	ff 75 e8             	pushl  -0x18(%ebp)
 b4c:	e8 ab fa ff ff       	call   5fc <free>
 b51:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 b54:	83 ec 08             	sub    $0x8,%esp
 b57:	ff 75 0c             	pushl  0xc(%ebp)
 b5a:	ff 75 e4             	pushl  -0x1c(%ebp)
 b5d:	e8 c2 01 00 00       	call   d24 <addToEnvironment>
 b62:	83 c4 10             	add    $0x10,%esp
 b65:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b68:	83 ec 0c             	sub    $0xc,%esp
 b6b:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b71:	50                   	push   %eax
 b72:	e8 9f f5 ff ff       	call   116 <strlen>
 b77:	83 c4 10             	add    $0x10,%esp
 b7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b80:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b83:	83 ec 0c             	sub    $0xc,%esp
 b86:	50                   	push   %eax
 b87:	e8 b1 fb ff ff       	call   73d <malloc>
 b8c:	83 c4 10             	add    $0x10,%esp
 b8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 b92:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b95:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b98:	8d 50 ff             	lea    -0x1(%eax),%edx
 b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b9e:	8d 48 01             	lea    0x1(%eax),%ecx
 ba1:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ba7:	01 c8                	add    %ecx,%eax
 ba9:	83 ec 04             	sub    $0x4,%esp
 bac:	52                   	push   %edx
 bad:	50                   	push   %eax
 bae:	ff 75 e8             	pushl  -0x18(%ebp)
 bb1:	e8 0b fd ff ff       	call   8c1 <strncpy>
 bb6:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 bb9:	83 ec 0c             	sub    $0xc,%esp
 bbc:	ff 75 e8             	pushl  -0x18(%ebp)
 bbf:	e8 41 fd ff ff       	call   905 <trim>
 bc4:	83 c4 10             	add    $0x10,%esp
 bc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 bca:	83 ec 0c             	sub    $0xc,%esp
 bcd:	ff 75 e8             	pushl  -0x18(%ebp)
 bd0:	e8 27 fa ff ff       	call   5fc <free>
 bd5:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 bd8:	83 ec 04             	sub    $0x4,%esp
 bdb:	ff 75 dc             	pushl  -0x24(%ebp)
 bde:	ff 75 0c             	pushl  0xc(%ebp)
 be1:	ff 75 e4             	pushl  -0x1c(%ebp)
 be4:	e8 b8 01 00 00       	call   da1 <addValueToVariable>
 be9:	83 c4 10             	add    $0x10,%esp
 bec:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 bef:	83 ec 04             	sub    $0x4,%esp
 bf2:	ff 75 f4             	pushl  -0xc(%ebp)
 bf5:	68 00 04 00 00       	push   $0x400
 bfa:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 c00:	50                   	push   %eax
 c01:	e8 4c fc ff ff       	call   852 <readln>
 c06:	83 c4 10             	add    $0x10,%esp
 c09:	85 c0                	test   %eax,%eax
 c0b:	0f 85 bc fe ff ff    	jne    acd <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 c11:	83 ec 0c             	sub    $0xc,%esp
 c14:	ff 75 f4             	pushl  -0xc(%ebp)
 c17:	e8 e3 f6 ff ff       	call   2ff <close>
 c1c:	83 c4 10             	add    $0x10,%esp
	return head;
 c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c22:	c9                   	leave  
 c23:	c3                   	ret    

00000c24 <comp>:

int comp(const char* s1, const char* s2)
{
 c24:	55                   	push   %ebp
 c25:	89 e5                	mov    %esp,%ebp
 c27:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 c2a:	83 ec 08             	sub    $0x8,%esp
 c2d:	ff 75 0c             	pushl  0xc(%ebp)
 c30:	ff 75 08             	pushl  0x8(%ebp)
 c33:	e8 9f f4 ff ff       	call   d7 <strcmp>
 c38:	83 c4 10             	add    $0x10,%esp
 c3b:	85 c0                	test   %eax,%eax
 c3d:	0f 94 c0             	sete   %al
 c40:	0f b6 c0             	movzbl %al,%eax
}
 c43:	c9                   	leave  
 c44:	c3                   	ret    

00000c45 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 c45:	55                   	push   %ebp
 c46:	89 e5                	mov    %esp,%ebp
 c48:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 c4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c4f:	75 07                	jne    c58 <environLookup+0x13>
    return NULL;
 c51:	b8 00 00 00 00       	mov    $0x0,%eax
 c56:	eb 2f                	jmp    c87 <environLookup+0x42>
  
  while (head)
 c58:	eb 24                	jmp    c7e <environLookup+0x39>
  {
    if (comp(name, head->name))
 c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
 c5d:	83 ec 08             	sub    $0x8,%esp
 c60:	50                   	push   %eax
 c61:	ff 75 08             	pushl  0x8(%ebp)
 c64:	e8 bb ff ff ff       	call   c24 <comp>
 c69:	83 c4 10             	add    $0x10,%esp
 c6c:	85 c0                	test   %eax,%eax
 c6e:	74 02                	je     c72 <environLookup+0x2d>
      break;
 c70:	eb 12                	jmp    c84 <environLookup+0x3f>
    head = head->next;
 c72:	8b 45 0c             	mov    0xc(%ebp),%eax
 c75:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c7b:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c82:	75 d6                	jne    c5a <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c84:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c87:	c9                   	leave  
 c88:	c3                   	ret    

00000c89 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c89:	55                   	push   %ebp
 c8a:	89 e5                	mov    %esp,%ebp
 c8c:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c93:	75 0a                	jne    c9f <removeFromEnvironment+0x16>
    return NULL;
 c95:	b8 00 00 00 00       	mov    $0x0,%eax
 c9a:	e9 83 00 00 00       	jmp    d22 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 c9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 ca3:	74 0a                	je     caf <removeFromEnvironment+0x26>
 ca5:	8b 45 08             	mov    0x8(%ebp),%eax
 ca8:	0f b6 00             	movzbl (%eax),%eax
 cab:	84 c0                	test   %al,%al
 cad:	75 05                	jne    cb4 <removeFromEnvironment+0x2b>
    return head;
 caf:	8b 45 0c             	mov    0xc(%ebp),%eax
 cb2:	eb 6e                	jmp    d22 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
 cb7:	83 ec 08             	sub    $0x8,%esp
 cba:	ff 75 08             	pushl  0x8(%ebp)
 cbd:	50                   	push   %eax
 cbe:	e8 61 ff ff ff       	call   c24 <comp>
 cc3:	83 c4 10             	add    $0x10,%esp
 cc6:	85 c0                	test   %eax,%eax
 cc8:	74 34                	je     cfe <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 cca:	8b 45 0c             	mov    0xc(%ebp),%eax
 ccd:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
 cd9:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 cdf:	83 ec 0c             	sub    $0xc,%esp
 ce2:	50                   	push   %eax
 ce3:	e8 74 01 00 00       	call   e5c <freeVarval>
 ce8:	83 c4 10             	add    $0x10,%esp
    free(head);
 ceb:	83 ec 0c             	sub    $0xc,%esp
 cee:	ff 75 0c             	pushl  0xc(%ebp)
 cf1:	e8 06 f9 ff ff       	call   5fc <free>
 cf6:	83 c4 10             	add    $0x10,%esp
    return tmp;
 cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cfc:	eb 24                	jmp    d22 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
 d01:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d07:	83 ec 08             	sub    $0x8,%esp
 d0a:	50                   	push   %eax
 d0b:	ff 75 08             	pushl  0x8(%ebp)
 d0e:	e8 76 ff ff ff       	call   c89 <removeFromEnvironment>
 d13:	83 c4 10             	add    $0x10,%esp
 d16:	8b 55 0c             	mov    0xc(%ebp),%edx
 d19:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d22:	c9                   	leave  
 d23:	c3                   	ret    

00000d24 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 d24:	55                   	push   %ebp
 d25:	89 e5                	mov    %esp,%ebp
 d27:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 d2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 d2e:	75 05                	jne    d35 <addToEnvironment+0x11>
		return head;
 d30:	8b 45 0c             	mov    0xc(%ebp),%eax
 d33:	eb 6a                	jmp    d9f <addToEnvironment+0x7b>
	if (head == NULL) {
 d35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 d39:	75 40                	jne    d7b <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 d3b:	83 ec 0c             	sub    $0xc,%esp
 d3e:	68 88 00 00 00       	push   $0x88
 d43:	e8 f5 f9 ff ff       	call   73d <malloc>
 d48:	83 c4 10             	add    $0x10,%esp
 d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 d4e:	8b 45 08             	mov    0x8(%ebp),%eax
 d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d57:	83 ec 08             	sub    $0x8,%esp
 d5a:	ff 75 f0             	pushl  -0x10(%ebp)
 d5d:	50                   	push   %eax
 d5e:	e8 44 f3 ff ff       	call   a7 <strcpy>
 d63:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d69:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d70:	00 00 00 
		head = newVar;
 d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d76:	89 45 0c             	mov    %eax,0xc(%ebp)
 d79:	eb 21                	jmp    d9c <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
 d7e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d84:	83 ec 08             	sub    $0x8,%esp
 d87:	50                   	push   %eax
 d88:	ff 75 08             	pushl  0x8(%ebp)
 d8b:	e8 94 ff ff ff       	call   d24 <addToEnvironment>
 d90:	83 c4 10             	add    $0x10,%esp
 d93:	8b 55 0c             	mov    0xc(%ebp),%edx
 d96:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d9f:	c9                   	leave  
 da0:	c3                   	ret    

00000da1 <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 da1:	55                   	push   %ebp
 da2:	89 e5                	mov    %esp,%ebp
 da4:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 da7:	83 ec 08             	sub    $0x8,%esp
 daa:	ff 75 0c             	pushl  0xc(%ebp)
 dad:	ff 75 08             	pushl  0x8(%ebp)
 db0:	e8 90 fe ff ff       	call   c45 <environLookup>
 db5:	83 c4 10             	add    $0x10,%esp
 db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 dbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 dbf:	75 05                	jne    dc6 <addValueToVariable+0x25>
		return head;
 dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
 dc4:	eb 4c                	jmp    e12 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 dc6:	83 ec 0c             	sub    $0xc,%esp
 dc9:	68 04 04 00 00       	push   $0x404
 dce:	e8 6a f9 ff ff       	call   73d <malloc>
 dd3:	83 c4 10             	add    $0x10,%esp
 dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 dd9:	8b 45 10             	mov    0x10(%ebp),%eax
 ddc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 de2:	83 ec 08             	sub    $0x8,%esp
 de5:	ff 75 ec             	pushl  -0x14(%ebp)
 de8:	50                   	push   %eax
 de9:	e8 b9 f2 ff ff       	call   a7 <strcpy>
 dee:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df4:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dfd:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e06:	8b 55 f0             	mov    -0x10(%ebp),%edx
 e09:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 e12:	c9                   	leave  
 e13:	c3                   	ret    

00000e14 <freeEnvironment>:

void freeEnvironment(variable* head)
{
 e14:	55                   	push   %ebp
 e15:	89 e5                	mov    %esp,%ebp
 e17:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e1e:	75 02                	jne    e22 <freeEnvironment+0xe>
    return;  
 e20:	eb 38                	jmp    e5a <freeEnvironment+0x46>
  freeEnvironment(head->next);
 e22:	8b 45 08             	mov    0x8(%ebp),%eax
 e25:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 e2b:	83 ec 0c             	sub    $0xc,%esp
 e2e:	50                   	push   %eax
 e2f:	e8 e0 ff ff ff       	call   e14 <freeEnvironment>
 e34:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 e37:	8b 45 08             	mov    0x8(%ebp),%eax
 e3a:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 e40:	83 ec 0c             	sub    $0xc,%esp
 e43:	50                   	push   %eax
 e44:	e8 13 00 00 00       	call   e5c <freeVarval>
 e49:	83 c4 10             	add    $0x10,%esp
  free(head);
 e4c:	83 ec 0c             	sub    $0xc,%esp
 e4f:	ff 75 08             	pushl  0x8(%ebp)
 e52:	e8 a5 f7 ff ff       	call   5fc <free>
 e57:	83 c4 10             	add    $0x10,%esp
}
 e5a:	c9                   	leave  
 e5b:	c3                   	ret    

00000e5c <freeVarval>:

void freeVarval(varval* head)
{
 e5c:	55                   	push   %ebp
 e5d:	89 e5                	mov    %esp,%ebp
 e5f:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e66:	75 02                	jne    e6a <freeVarval+0xe>
    return;  
 e68:	eb 23                	jmp    e8d <freeVarval+0x31>
  freeVarval(head->next);
 e6a:	8b 45 08             	mov    0x8(%ebp),%eax
 e6d:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e73:	83 ec 0c             	sub    $0xc,%esp
 e76:	50                   	push   %eax
 e77:	e8 e0 ff ff ff       	call   e5c <freeVarval>
 e7c:	83 c4 10             	add    $0x10,%esp
  free(head);
 e7f:	83 ec 0c             	sub    $0xc,%esp
 e82:	ff 75 08             	pushl  0x8(%ebp)
 e85:	e8 72 f7 ff ff       	call   5fc <free>
 e8a:	83 c4 10             	add    $0x10,%esp
}
 e8d:	c9                   	leave  
 e8e:	c3                   	ret    

00000e8f <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e8f:	55                   	push   %ebp
 e90:	89 e5                	mov    %esp,%ebp
 e92:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 e95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e99:	75 08                	jne    ea3 <getPaths+0x14>
		return head;
 e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
 e9e:	e9 e7 00 00 00       	jmp    f8a <getPaths+0xfb>
	if (head == NULL) {
 ea3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 ea7:	0f 85 b9 00 00 00    	jne    f66 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 ead:	83 ec 08             	sub    $0x8,%esp
 eb0:	6a 3a                	push   $0x3a
 eb2:	ff 75 08             	pushl  0x8(%ebp)
 eb5:	e8 9d f2 ff ff       	call   157 <strchr>
 eba:	83 c4 10             	add    $0x10,%esp
 ebd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 ec0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ec4:	75 56                	jne    f1c <getPaths+0x8d>
			pathLen = strlen(paths);
 ec6:	83 ec 0c             	sub    $0xc,%esp
 ec9:	ff 75 08             	pushl  0x8(%ebp)
 ecc:	e8 45 f2 ff ff       	call   116 <strlen>
 ed1:	83 c4 10             	add    $0x10,%esp
 ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 ed7:	83 ec 0c             	sub    $0xc,%esp
 eda:	68 04 04 00 00       	push   $0x404
 edf:	e8 59 f8 ff ff       	call   73d <malloc>
 ee4:	83 c4 10             	add    $0x10,%esp
 ee7:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 eea:	8b 45 0c             	mov    0xc(%ebp),%eax
 eed:	83 ec 04             	sub    $0x4,%esp
 ef0:	ff 75 f0             	pushl  -0x10(%ebp)
 ef3:	ff 75 08             	pushl  0x8(%ebp)
 ef6:	50                   	push   %eax
 ef7:	e8 c5 f9 ff ff       	call   8c1 <strncpy>
 efc:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 eff:	8b 55 0c             	mov    0xc(%ebp),%edx
 f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f05:	01 d0                	add    %edx,%eax
 f07:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
 f0d:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 f14:	00 00 00 
			return head;
 f17:	8b 45 0c             	mov    0xc(%ebp),%eax
 f1a:	eb 6e                	jmp    f8a <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 f1f:	8b 45 08             	mov    0x8(%ebp),%eax
 f22:	29 c2                	sub    %eax,%edx
 f24:	89 d0                	mov    %edx,%eax
 f26:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 f29:	83 ec 0c             	sub    $0xc,%esp
 f2c:	68 04 04 00 00       	push   $0x404
 f31:	e8 07 f8 ff ff       	call   73d <malloc>
 f36:	83 c4 10             	add    $0x10,%esp
 f39:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
 f3f:	83 ec 04             	sub    $0x4,%esp
 f42:	ff 75 f0             	pushl  -0x10(%ebp)
 f45:	ff 75 08             	pushl  0x8(%ebp)
 f48:	50                   	push   %eax
 f49:	e8 73 f9 ff ff       	call   8c1 <strncpy>
 f4e:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f51:	8b 55 0c             	mov    0xc(%ebp),%edx
 f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f57:	01 d0                	add    %edx,%eax
 f59:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f5f:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 f62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f66:	8b 45 0c             	mov    0xc(%ebp),%eax
 f69:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f6f:	83 ec 08             	sub    $0x8,%esp
 f72:	50                   	push   %eax
 f73:	ff 75 08             	pushl  0x8(%ebp)
 f76:	e8 14 ff ff ff       	call   e8f <getPaths>
 f7b:	83 c4 10             	add    $0x10,%esp
 f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
 f81:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f87:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f8a:	c9                   	leave  
 f8b:	c3                   	ret    
