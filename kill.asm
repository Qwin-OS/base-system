
_kill:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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

  if(argc < 1){
  14:	83 3b 00             	cmpl   $0x0,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 7c 0f 00 00       	push   $0xf7c
  21:	6a 02                	push   $0x2
  23:	e8 34 04 00 00       	call   45c <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 97 02 00 00       	call   2c7 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e2 01 00 00       	call   235 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 98 02 00 00       	call   2f7 <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6d:	e8 55 02 00 00       	call   2c7 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	5b                   	pop    %ebx
  94:	5f                   	pop    %edi
  95:	5d                   	pop    %ebp
  96:	c3                   	ret    

00000097 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  97:	55                   	push   %ebp
  98:	89 e5                	mov    %esp,%ebp
  9a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9d:	8b 45 08             	mov    0x8(%ebp),%eax
  a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a3:	90                   	nop
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	8d 50 01             	lea    0x1(%eax),%edx
  aa:	89 55 08             	mov    %edx,0x8(%ebp)
  ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  b3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b6:	0f b6 12             	movzbl (%edx),%edx
  b9:	88 10                	mov    %dl,(%eax)
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	84 c0                	test   %al,%al
  c0:	75 e2                	jne    a4 <strcpy+0xd>
    ;
  return os;
  c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c5:	c9                   	leave  
  c6:	c3                   	ret    

000000c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ca:	eb 08                	jmp    d4 <strcmp+0xd>
    p++, q++;
  cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	0f b6 00             	movzbl (%eax),%eax
  da:	84 c0                	test   %al,%al
  dc:	74 10                	je     ee <strcmp+0x27>
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	0f b6 10             	movzbl (%eax),%edx
  e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  e7:	0f b6 00             	movzbl (%eax),%eax
  ea:	38 c2                	cmp    %al,%dl
  ec:	74 de                	je     cc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ee:	8b 45 08             	mov    0x8(%ebp),%eax
  f1:	0f b6 00             	movzbl (%eax),%eax
  f4:	0f b6 d0             	movzbl %al,%edx
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	0f b6 00             	movzbl (%eax),%eax
  fd:	0f b6 c0             	movzbl %al,%eax
 100:	29 c2                	sub    %eax,%edx
 102:	89 d0                	mov    %edx,%eax
}
 104:	5d                   	pop    %ebp
 105:	c3                   	ret    

00000106 <strlen>:

uint
strlen(char *s)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 113:	eb 04                	jmp    119 <strlen+0x13>
 115:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 119:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	01 d0                	add    %edx,%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	84 c0                	test   %al,%al
 126:	75 ed                	jne    115 <strlen+0xf>
    ;
  return n;
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <memset>:

void*
memset(void *dst, int c, uint n)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 130:	8b 45 10             	mov    0x10(%ebp),%eax
 133:	50                   	push   %eax
 134:	ff 75 0c             	pushl  0xc(%ebp)
 137:	ff 75 08             	pushl  0x8(%ebp)
 13a:	e8 33 ff ff ff       	call   72 <stosb>
 13f:	83 c4 0c             	add    $0xc,%esp
  return dst;
 142:	8b 45 08             	mov    0x8(%ebp),%eax
}
 145:	c9                   	leave  
 146:	c3                   	ret    

00000147 <strchr>:

char*
strchr(const char *s, char c)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	83 ec 04             	sub    $0x4,%esp
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 153:	eb 14                	jmp    169 <strchr+0x22>
    if(*s == c)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15e:	75 05                	jne    165 <strchr+0x1e>
      return (char*)s;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	eb 13                	jmp    178 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 165:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	0f b6 00             	movzbl (%eax),%eax
 16f:	84 c0                	test   %al,%al
 171:	75 e2                	jne    155 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 173:	b8 00 00 00 00       	mov    $0x0,%eax
}
 178:	c9                   	leave  
 179:	c3                   	ret    

0000017a <gets>:

char*
gets(char *buf, int max)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 187:	eb 44                	jmp    1cd <gets+0x53>
    cc = read(0, &c, 1);
 189:	83 ec 04             	sub    $0x4,%esp
 18c:	6a 01                	push   $0x1
 18e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 191:	50                   	push   %eax
 192:	6a 00                	push   $0x0
 194:	e8 46 01 00 00       	call   2df <read>
 199:	83 c4 10             	add    $0x10,%esp
 19c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a3:	7f 02                	jg     1a7 <gets+0x2d>
      break;
 1a5:	eb 31                	jmp    1d8 <gets+0x5e>
    buf[i++] = c;
 1a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1aa:	8d 50 01             	lea    0x1(%eax),%edx
 1ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b0:	89 c2                	mov    %eax,%edx
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	01 c2                	add    %eax,%edx
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c1:	3c 0a                	cmp    $0xa,%al
 1c3:	74 13                	je     1d8 <gets+0x5e>
 1c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c9:	3c 0d                	cmp    $0xd,%al
 1cb:	74 0b                	je     1d8 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d0:	83 c0 01             	add    $0x1,%eax
 1d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d6:	7c b1                	jl     189 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	01 d0                	add    %edx,%eax
 1e0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e6:	c9                   	leave  
 1e7:	c3                   	ret    

000001e8 <stat>:

int
stat(char *n, struct stat *st)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ee:	83 ec 08             	sub    $0x8,%esp
 1f1:	6a 00                	push   $0x0
 1f3:	ff 75 08             	pushl  0x8(%ebp)
 1f6:	e8 0c 01 00 00       	call   307 <open>
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 205:	79 07                	jns    20e <stat+0x26>
    return -1;
 207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20c:	eb 25                	jmp    233 <stat+0x4b>
  r = fstat(fd, st);
 20e:	83 ec 08             	sub    $0x8,%esp
 211:	ff 75 0c             	pushl  0xc(%ebp)
 214:	ff 75 f4             	pushl  -0xc(%ebp)
 217:	e8 03 01 00 00       	call   31f <fstat>
 21c:	83 c4 10             	add    $0x10,%esp
 21f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 222:	83 ec 0c             	sub    $0xc,%esp
 225:	ff 75 f4             	pushl  -0xc(%ebp)
 228:	e8 c2 00 00 00       	call   2ef <close>
 22d:	83 c4 10             	add    $0x10,%esp
  return r;
 230:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 233:	c9                   	leave  
 234:	c3                   	ret    

00000235 <atoi>:

int
atoi(const char *s)
{
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 242:	eb 25                	jmp    269 <atoi+0x34>
    n = n*10 + *s++ - '0';
 244:	8b 55 fc             	mov    -0x4(%ebp),%edx
 247:	89 d0                	mov    %edx,%eax
 249:	c1 e0 02             	shl    $0x2,%eax
 24c:	01 d0                	add    %edx,%eax
 24e:	01 c0                	add    %eax,%eax
 250:	89 c1                	mov    %eax,%ecx
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	8d 50 01             	lea    0x1(%eax),%edx
 258:	89 55 08             	mov    %edx,0x8(%ebp)
 25b:	0f b6 00             	movzbl (%eax),%eax
 25e:	0f be c0             	movsbl %al,%eax
 261:	01 c8                	add    %ecx,%eax
 263:	83 e8 30             	sub    $0x30,%eax
 266:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	3c 2f                	cmp    $0x2f,%al
 271:	7e 0a                	jle    27d <atoi+0x48>
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	3c 39                	cmp    $0x39,%al
 27b:	7e c7                	jle    244 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 294:	eb 17                	jmp    2ad <memmove+0x2b>
    *dst++ = *src++;
 296:	8b 45 fc             	mov    -0x4(%ebp),%eax
 299:	8d 50 01             	lea    0x1(%eax),%edx
 29c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 29f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a8:	0f b6 12             	movzbl (%edx),%edx
 2ab:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ad:	8b 45 10             	mov    0x10(%ebp),%eax
 2b0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b3:	89 55 10             	mov    %edx,0x10(%ebp)
 2b6:	85 c0                	test   %eax,%eax
 2b8:	7f dc                	jg     296 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bd:	c9                   	leave  
 2be:	c3                   	ret    

000002bf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bf:	b8 01 00 00 00       	mov    $0x1,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <exit>:
SYSCALL(exit)
 2c7:	b8 02 00 00 00       	mov    $0x2,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <wait>:
SYSCALL(wait)
 2cf:	b8 03 00 00 00       	mov    $0x3,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <pipe>:
SYSCALL(pipe)
 2d7:	b8 04 00 00 00       	mov    $0x4,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <read>:
SYSCALL(read)
 2df:	b8 05 00 00 00       	mov    $0x5,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <write>:
SYSCALL(write)
 2e7:	b8 10 00 00 00       	mov    $0x10,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <close>:
SYSCALL(close)
 2ef:	b8 15 00 00 00       	mov    $0x15,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <kill>:
SYSCALL(kill)
 2f7:	b8 06 00 00 00       	mov    $0x6,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <exec>:
SYSCALL(exec)
 2ff:	b8 07 00 00 00       	mov    $0x7,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <open>:
SYSCALL(open)
 307:	b8 0f 00 00 00       	mov    $0xf,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <mknod>:
SYSCALL(mknod)
 30f:	b8 11 00 00 00       	mov    $0x11,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <unlink>:
SYSCALL(unlink)
 317:	b8 12 00 00 00       	mov    $0x12,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <fstat>:
SYSCALL(fstat)
 31f:	b8 08 00 00 00       	mov    $0x8,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <link>:
SYSCALL(link)
 327:	b8 13 00 00 00       	mov    $0x13,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <mkdir>:
SYSCALL(mkdir)
 32f:	b8 14 00 00 00       	mov    $0x14,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <chdir>:
SYSCALL(chdir)
 337:	b8 09 00 00 00       	mov    $0x9,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <dup>:
SYSCALL(dup)
 33f:	b8 0a 00 00 00       	mov    $0xa,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <getpid>:
SYSCALL(getpid)
 347:	b8 0b 00 00 00       	mov    $0xb,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <sbrk>:
SYSCALL(sbrk)
 34f:	b8 0c 00 00 00       	mov    $0xc,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sleep>:
SYSCALL(sleep)
 357:	b8 0d 00 00 00       	mov    $0xd,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <uptime>:
SYSCALL(uptime)
 35f:	b8 0e 00 00 00       	mov    $0xe,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <getcwd>:
SYSCALL(getcwd)
 367:	b8 16 00 00 00       	mov    $0x16,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <shutdown>:
SYSCALL(shutdown)
 36f:	b8 17 00 00 00       	mov    $0x17,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <buildinfo>:
SYSCALL(buildinfo)
 377:	b8 18 00 00 00       	mov    $0x18,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <lseek>:
SYSCALL(lseek)
 37f:	b8 19 00 00 00       	mov    $0x19,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 387:	55                   	push   %ebp
 388:	89 e5                	mov    %esp,%ebp
 38a:	83 ec 18             	sub    $0x18,%esp
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 393:	83 ec 04             	sub    $0x4,%esp
 396:	6a 01                	push   $0x1
 398:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39b:	50                   	push   %eax
 39c:	ff 75 08             	pushl  0x8(%ebp)
 39f:	e8 43 ff ff ff       	call   2e7 <write>
 3a4:	83 c4 10             	add    $0x10,%esp
}
 3a7:	c9                   	leave  
 3a8:	c3                   	ret    

000003a9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
 3ac:	53                   	push   %ebx
 3ad:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bb:	74 17                	je     3d4 <printint+0x2b>
 3bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c1:	79 11                	jns    3d4 <printint+0x2b>
    neg = 1;
 3c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	f7 d8                	neg    %eax
 3cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d2:	eb 06                	jmp    3da <printint+0x31>
  } else {
    x = xx;
 3d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e4:	8d 41 01             	lea    0x1(%ecx),%eax
 3e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f0:	ba 00 00 00 00       	mov    $0x0,%edx
 3f5:	f7 f3                	div    %ebx
 3f7:	89 d0                	mov    %edx,%eax
 3f9:	0f b6 80 a4 13 00 00 	movzbl 0x13a4(%eax),%eax
 400:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 404:	8b 5d 10             	mov    0x10(%ebp),%ebx
 407:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40a:	ba 00 00 00 00       	mov    $0x0,%edx
 40f:	f7 f3                	div    %ebx
 411:	89 45 ec             	mov    %eax,-0x14(%ebp)
 414:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 418:	75 c7                	jne    3e1 <printint+0x38>
  if(neg)
 41a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41e:	74 0e                	je     42e <printint+0x85>
    buf[i++] = '-';
 420:	8b 45 f4             	mov    -0xc(%ebp),%eax
 423:	8d 50 01             	lea    0x1(%eax),%edx
 426:	89 55 f4             	mov    %edx,-0xc(%ebp)
 429:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 42e:	eb 1d                	jmp    44d <printint+0xa4>
    putc(fd, buf[i]);
 430:	8d 55 dc             	lea    -0x24(%ebp),%edx
 433:	8b 45 f4             	mov    -0xc(%ebp),%eax
 436:	01 d0                	add    %edx,%eax
 438:	0f b6 00             	movzbl (%eax),%eax
 43b:	0f be c0             	movsbl %al,%eax
 43e:	83 ec 08             	sub    $0x8,%esp
 441:	50                   	push   %eax
 442:	ff 75 08             	pushl  0x8(%ebp)
 445:	e8 3d ff ff ff       	call   387 <putc>
 44a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 44d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 451:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 455:	79 d9                	jns    430 <printint+0x87>
    putc(fd, buf[i]);
}
 457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 45a:	c9                   	leave  
 45b:	c3                   	ret    

0000045c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 462:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 469:	8d 45 0c             	lea    0xc(%ebp),%eax
 46c:	83 c0 04             	add    $0x4,%eax
 46f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 479:	e9 59 01 00 00       	jmp    5d7 <printf+0x17b>
    c = fmt[i] & 0xff;
 47e:	8b 55 0c             	mov    0xc(%ebp),%edx
 481:	8b 45 f0             	mov    -0x10(%ebp),%eax
 484:	01 d0                	add    %edx,%eax
 486:	0f b6 00             	movzbl (%eax),%eax
 489:	0f be c0             	movsbl %al,%eax
 48c:	25 ff 00 00 00       	and    $0xff,%eax
 491:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 494:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 498:	75 2c                	jne    4c6 <printf+0x6a>
      if(c == '%'){
 49a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 49e:	75 0c                	jne    4ac <printf+0x50>
        state = '%';
 4a0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a7:	e9 27 01 00 00       	jmp    5d3 <printf+0x177>
      } else {
        putc(fd, c);
 4ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4af:	0f be c0             	movsbl %al,%eax
 4b2:	83 ec 08             	sub    $0x8,%esp
 4b5:	50                   	push   %eax
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 c9 fe ff ff       	call   387 <putc>
 4be:	83 c4 10             	add    $0x10,%esp
 4c1:	e9 0d 01 00 00       	jmp    5d3 <printf+0x177>
      }
    } else if(state == '%'){
 4c6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ca:	0f 85 03 01 00 00    	jne    5d3 <printf+0x177>
      if(c == 'd'){
 4d0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d4:	75 1e                	jne    4f4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d9:	8b 00                	mov    (%eax),%eax
 4db:	6a 01                	push   $0x1
 4dd:	6a 0a                	push   $0xa
 4df:	50                   	push   %eax
 4e0:	ff 75 08             	pushl  0x8(%ebp)
 4e3:	e8 c1 fe ff ff       	call   3a9 <printint>
 4e8:	83 c4 10             	add    $0x10,%esp
        ap++;
 4eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ef:	e9 d8 00 00 00       	jmp    5cc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f8:	74 06                	je     500 <printf+0xa4>
 4fa:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4fe:	75 1e                	jne    51e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 500:	8b 45 e8             	mov    -0x18(%ebp),%eax
 503:	8b 00                	mov    (%eax),%eax
 505:	6a 00                	push   $0x0
 507:	6a 10                	push   $0x10
 509:	50                   	push   %eax
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 97 fe ff ff       	call   3a9 <printint>
 512:	83 c4 10             	add    $0x10,%esp
        ap++;
 515:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 519:	e9 ae 00 00 00       	jmp    5cc <printf+0x170>
      } else if(c == 's'){
 51e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 522:	75 43                	jne    567 <printf+0x10b>
        s = (char*)*ap;
 524:	8b 45 e8             	mov    -0x18(%ebp),%eax
 527:	8b 00                	mov    (%eax),%eax
 529:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 534:	75 07                	jne    53d <printf+0xe1>
          s = "(null)";
 536:	c7 45 f4 90 0f 00 00 	movl   $0xf90,-0xc(%ebp)
        while(*s != 0){
 53d:	eb 1c                	jmp    55b <printf+0xff>
          putc(fd, *s);
 53f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 542:	0f b6 00             	movzbl (%eax),%eax
 545:	0f be c0             	movsbl %al,%eax
 548:	83 ec 08             	sub    $0x8,%esp
 54b:	50                   	push   %eax
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 33 fe ff ff       	call   387 <putc>
 554:	83 c4 10             	add    $0x10,%esp
          s++;
 557:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55e:	0f b6 00             	movzbl (%eax),%eax
 561:	84 c0                	test   %al,%al
 563:	75 da                	jne    53f <printf+0xe3>
 565:	eb 65                	jmp    5cc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 567:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56b:	75 1d                	jne    58a <printf+0x12e>
        putc(fd, *ap);
 56d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 570:	8b 00                	mov    (%eax),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	83 ec 08             	sub    $0x8,%esp
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 06 fe ff ff       	call   387 <putc>
 581:	83 c4 10             	add    $0x10,%esp
        ap++;
 584:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 588:	eb 42                	jmp    5cc <printf+0x170>
      } else if(c == '%'){
 58a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58e:	75 17                	jne    5a7 <printf+0x14b>
        putc(fd, c);
 590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 593:	0f be c0             	movsbl %al,%eax
 596:	83 ec 08             	sub    $0x8,%esp
 599:	50                   	push   %eax
 59a:	ff 75 08             	pushl  0x8(%ebp)
 59d:	e8 e5 fd ff ff       	call   387 <putc>
 5a2:	83 c4 10             	add    $0x10,%esp
 5a5:	eb 25                	jmp    5cc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a7:	83 ec 08             	sub    $0x8,%esp
 5aa:	6a 25                	push   $0x25
 5ac:	ff 75 08             	pushl  0x8(%ebp)
 5af:	e8 d3 fd ff ff       	call   387 <putc>
 5b4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	83 ec 08             	sub    $0x8,%esp
 5c0:	50                   	push   %eax
 5c1:	ff 75 08             	pushl  0x8(%ebp)
 5c4:	e8 be fd ff ff       	call   387 <putc>
 5c9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5dd:	01 d0                	add    %edx,%eax
 5df:	0f b6 00             	movzbl (%eax),%eax
 5e2:	84 c0                	test   %al,%al
 5e4:	0f 85 94 fe ff ff    	jne    47e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ea:	c9                   	leave  
 5eb:	c3                   	ret    

000005ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ec:	55                   	push   %ebp
 5ed:	89 e5                	mov    %esp,%ebp
 5ef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	83 e8 08             	sub    $0x8,%eax
 5f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fb:	a1 c0 13 00 00       	mov    0x13c0,%eax
 600:	89 45 fc             	mov    %eax,-0x4(%ebp)
 603:	eb 24                	jmp    629 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60d:	77 12                	ja     621 <free+0x35>
 60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 612:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 615:	77 24                	ja     63b <free+0x4f>
 617:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61f:	77 1a                	ja     63b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	89 45 fc             	mov    %eax,-0x4(%ebp)
 629:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62f:	76 d4                	jbe    605 <free+0x19>
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 639:	76 ca                	jbe    605 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	8b 40 04             	mov    0x4(%eax),%eax
 641:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 648:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64b:	01 c2                	add    %eax,%edx
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	39 c2                	cmp    %eax,%edx
 654:	75 24                	jne    67a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	8b 50 04             	mov    0x4(%eax),%edx
 65c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	8b 40 04             	mov    0x4(%eax),%eax
 664:	01 c2                	add    %eax,%edx
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	8b 10                	mov    (%eax),%edx
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	89 10                	mov    %edx,(%eax)
 678:	eb 0a                	jmp    684 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 10                	mov    (%eax),%edx
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 40 04             	mov    0x4(%eax),%eax
 68a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	01 d0                	add    %edx,%eax
 696:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 699:	75 20                	jne    6bb <free+0xcf>
    p->s.size += bp->s.size;
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 50 04             	mov    0x4(%eax),%edx
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	8b 40 04             	mov    0x4(%eax),%eax
 6a7:	01 c2                	add    %eax,%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	8b 10                	mov    (%eax),%edx
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	89 10                	mov    %edx,(%eax)
 6b9:	eb 08                	jmp    6c3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	a3 c0 13 00 00       	mov    %eax,0x13c0
}
 6cb:	c9                   	leave  
 6cc:	c3                   	ret    

000006cd <morecore>:

static Header*
morecore(uint nu)
{
 6cd:	55                   	push   %ebp
 6ce:	89 e5                	mov    %esp,%ebp
 6d0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6da:	77 07                	ja     6e3 <morecore+0x16>
    nu = 4096;
 6dc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	c1 e0 03             	shl    $0x3,%eax
 6e9:	83 ec 0c             	sub    $0xc,%esp
 6ec:	50                   	push   %eax
 6ed:	e8 5d fc ff ff       	call   34f <sbrk>
 6f2:	83 c4 10             	add    $0x10,%esp
 6f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fc:	75 07                	jne    705 <morecore+0x38>
    return 0;
 6fe:	b8 00 00 00 00       	mov    $0x0,%eax
 703:	eb 26                	jmp    72b <morecore+0x5e>
  hp = (Header*)p;
 705:	8b 45 f4             	mov    -0xc(%ebp),%eax
 708:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 70b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70e:	8b 55 08             	mov    0x8(%ebp),%edx
 711:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 714:	8b 45 f0             	mov    -0x10(%ebp),%eax
 717:	83 c0 08             	add    $0x8,%eax
 71a:	83 ec 0c             	sub    $0xc,%esp
 71d:	50                   	push   %eax
 71e:	e8 c9 fe ff ff       	call   5ec <free>
 723:	83 c4 10             	add    $0x10,%esp
  return freep;
 726:	a1 c0 13 00 00       	mov    0x13c0,%eax
}
 72b:	c9                   	leave  
 72c:	c3                   	ret    

0000072d <malloc>:

void*
malloc(uint nbytes)
{
 72d:	55                   	push   %ebp
 72e:	89 e5                	mov    %esp,%ebp
 730:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 733:	8b 45 08             	mov    0x8(%ebp),%eax
 736:	83 c0 07             	add    $0x7,%eax
 739:	c1 e8 03             	shr    $0x3,%eax
 73c:	83 c0 01             	add    $0x1,%eax
 73f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 742:	a1 c0 13 00 00       	mov    0x13c0,%eax
 747:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74e:	75 23                	jne    773 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 750:	c7 45 f0 b8 13 00 00 	movl   $0x13b8,-0x10(%ebp)
 757:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75a:	a3 c0 13 00 00       	mov    %eax,0x13c0
 75f:	a1 c0 13 00 00       	mov    0x13c0,%eax
 764:	a3 b8 13 00 00       	mov    %eax,0x13b8
    base.s.size = 0;
 769:	c7 05 bc 13 00 00 00 	movl   $0x0,0x13bc
 770:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 773:	8b 45 f0             	mov    -0x10(%ebp),%eax
 776:	8b 00                	mov    (%eax),%eax
 778:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	8b 40 04             	mov    0x4(%eax),%eax
 781:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 784:	72 4d                	jb     7d3 <malloc+0xa6>
      if(p->s.size == nunits)
 786:	8b 45 f4             	mov    -0xc(%ebp),%eax
 789:	8b 40 04             	mov    0x4(%eax),%eax
 78c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78f:	75 0c                	jne    79d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	8b 10                	mov    (%eax),%edx
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	89 10                	mov    %edx,(%eax)
 79b:	eb 26                	jmp    7c3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a6:	89 c2                	mov    %eax,%edx
 7a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ab:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 40 04             	mov    0x4(%eax),%eax
 7b4:	c1 e0 03             	shl    $0x3,%eax
 7b7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	a3 c0 13 00 00       	mov    %eax,0x13c0
      return (void*)(p + 1);
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	83 c0 08             	add    $0x8,%eax
 7d1:	eb 3b                	jmp    80e <malloc+0xe1>
    }
    if(p == freep)
 7d3:	a1 c0 13 00 00       	mov    0x13c0,%eax
 7d8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7db:	75 1e                	jne    7fb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7dd:	83 ec 0c             	sub    $0xc,%esp
 7e0:	ff 75 ec             	pushl  -0x14(%ebp)
 7e3:	e8 e5 fe ff ff       	call   6cd <morecore>
 7e8:	83 c4 10             	add    $0x10,%esp
 7eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f2:	75 07                	jne    7fb <malloc+0xce>
        return 0;
 7f4:	b8 00 00 00 00       	mov    $0x0,%eax
 7f9:	eb 13                	jmp    80e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 00                	mov    (%eax),%eax
 806:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 809:	e9 6d ff ff ff       	jmp    77b <malloc+0x4e>
}
 80e:	c9                   	leave  
 80f:	c3                   	ret    

00000810 <isspace>:

#include "common.h"

int isspace(char c) {
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	83 ec 04             	sub    $0x4,%esp
 816:	8b 45 08             	mov    0x8(%ebp),%eax
 819:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 81c:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 820:	74 12                	je     834 <isspace+0x24>
 822:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 826:	74 0c                	je     834 <isspace+0x24>
 828:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 82c:	74 06                	je     834 <isspace+0x24>
 82e:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 832:	75 07                	jne    83b <isspace+0x2b>
 834:	b8 01 00 00 00       	mov    $0x1,%eax
 839:	eb 05                	jmp    840 <isspace+0x30>
 83b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 840:	c9                   	leave  
 841:	c3                   	ret    

00000842 <readln>:

char* readln(char *buf, int max, int fd)
{
 842:	55                   	push   %ebp
 843:	89 e5                	mov    %esp,%ebp
 845:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 848:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 84f:	eb 45                	jmp    896 <readln+0x54>
    cc = read(fd, &c, 1);
 851:	83 ec 04             	sub    $0x4,%esp
 854:	6a 01                	push   $0x1
 856:	8d 45 ef             	lea    -0x11(%ebp),%eax
 859:	50                   	push   %eax
 85a:	ff 75 10             	pushl  0x10(%ebp)
 85d:	e8 7d fa ff ff       	call   2df <read>
 862:	83 c4 10             	add    $0x10,%esp
 865:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 868:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86c:	7f 02                	jg     870 <readln+0x2e>
      break;
 86e:	eb 31                	jmp    8a1 <readln+0x5f>
    buf[i++] = c;
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8d 50 01             	lea    0x1(%eax),%edx
 876:	89 55 f4             	mov    %edx,-0xc(%ebp)
 879:	89 c2                	mov    %eax,%edx
 87b:	8b 45 08             	mov    0x8(%ebp),%eax
 87e:	01 c2                	add    %eax,%edx
 880:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 884:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 886:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 88a:	3c 0a                	cmp    $0xa,%al
 88c:	74 13                	je     8a1 <readln+0x5f>
 88e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 892:	3c 0d                	cmp    $0xd,%al
 894:	74 0b                	je     8a1 <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	83 c0 01             	add    $0x1,%eax
 89c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 89f:	7c b0                	jl     851 <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 8a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8a4:	8b 45 08             	mov    0x8(%ebp),%eax
 8a7:	01 d0                	add    %edx,%eax
 8a9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 8ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8af:	c9                   	leave  
 8b0:	c3                   	ret    

000008b1 <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 8b1:	55                   	push   %ebp
 8b2:	89 e5                	mov    %esp,%ebp
 8b4:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8be:	eb 19                	jmp    8d9 <strncpy+0x28>
		dest[i] = src[i];
 8c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8c3:	8b 45 08             	mov    0x8(%ebp),%eax
 8c6:	01 c2                	add    %eax,%edx
 8c8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 8cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 8ce:	01 c8                	add    %ecx,%eax
 8d0:	0f b6 00             	movzbl (%eax),%eax
 8d3:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8d5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dc:	3b 45 10             	cmp    0x10(%ebp),%eax
 8df:	7d 0f                	jge    8f0 <strncpy+0x3f>
 8e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 8e7:	01 d0                	add    %edx,%eax
 8e9:	0f b6 00             	movzbl (%eax),%eax
 8ec:	84 c0                	test   %al,%al
 8ee:	75 d0                	jne    8c0 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 8f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8f3:	c9                   	leave  
 8f4:	c3                   	ret    

000008f5 <trim>:

char* trim(char* orig) {
 8f5:	55                   	push   %ebp
 8f6:	89 e5                	mov    %esp,%ebp
 8f8:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 8fb:	8b 45 08             	mov    0x8(%ebp),%eax
 8fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 901:	8b 45 08             	mov    0x8(%ebp),%eax
 904:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 907:	eb 04                	jmp    90d <trim+0x18>
 909:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 910:	0f b6 00             	movzbl (%eax),%eax
 913:	0f be c0             	movsbl %al,%eax
 916:	50                   	push   %eax
 917:	e8 f4 fe ff ff       	call   810 <isspace>
 91c:	83 c4 04             	add    $0x4,%esp
 91f:	85 c0                	test   %eax,%eax
 921:	75 e6                	jne    909 <trim+0x14>
	while (*tail) { tail++; }
 923:	eb 04                	jmp    929 <trim+0x34>
 925:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	0f b6 00             	movzbl (%eax),%eax
 92f:	84 c0                	test   %al,%al
 931:	75 f2                	jne    925 <trim+0x30>
	do { tail--; } while (isspace(*tail));
 933:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 937:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93a:	0f b6 00             	movzbl (%eax),%eax
 93d:	0f be c0             	movsbl %al,%eax
 940:	50                   	push   %eax
 941:	e8 ca fe ff ff       	call   810 <isspace>
 946:	83 c4 04             	add    $0x4,%esp
 949:	85 c0                	test   %eax,%eax
 94b:	75 e6                	jne    933 <trim+0x3e>
	new = malloc(tail-head+2);
 94d:	8b 55 f0             	mov    -0x10(%ebp),%edx
 950:	8b 45 f4             	mov    -0xc(%ebp),%eax
 953:	29 c2                	sub    %eax,%edx
 955:	89 d0                	mov    %edx,%eax
 957:	83 c0 02             	add    $0x2,%eax
 95a:	83 ec 0c             	sub    $0xc,%esp
 95d:	50                   	push   %eax
 95e:	e8 ca fd ff ff       	call   72d <malloc>
 963:	83 c4 10             	add    $0x10,%esp
 966:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 969:	8b 55 f0             	mov    -0x10(%ebp),%edx
 96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96f:	29 c2                	sub    %eax,%edx
 971:	89 d0                	mov    %edx,%eax
 973:	83 c0 01             	add    $0x1,%eax
 976:	83 ec 04             	sub    $0x4,%esp
 979:	50                   	push   %eax
 97a:	ff 75 f4             	pushl  -0xc(%ebp)
 97d:	ff 75 ec             	pushl  -0x14(%ebp)
 980:	e8 2c ff ff ff       	call   8b1 <strncpy>
 985:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 988:	8b 55 f0             	mov    -0x10(%ebp),%edx
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	29 c2                	sub    %eax,%edx
 990:	89 d0                	mov    %edx,%eax
 992:	8d 50 01             	lea    0x1(%eax),%edx
 995:	8b 45 ec             	mov    -0x14(%ebp),%eax
 998:	01 d0                	add    %edx,%eax
 99a:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 99d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 9a0:	c9                   	leave  
 9a1:	c3                   	ret    

000009a2 <itoa>:

char *
itoa(int value)
{
 9a2:	55                   	push   %ebp
 9a3:	89 e5                	mov    %esp,%ebp
 9a5:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 9a8:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 9ae:	8b 45 08             	mov    0x8(%ebp),%eax
 9b1:	c1 e8 1f             	shr    $0x1f,%eax
 9b4:	0f b6 c0             	movzbl %al,%eax
 9b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 9ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 9be:	74 0a                	je     9ca <itoa+0x28>
    v = -value;
 9c0:	8b 45 08             	mov    0x8(%ebp),%eax
 9c3:	f7 d8                	neg    %eax
 9c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c8:	eb 06                	jmp    9d0 <itoa+0x2e>
  else
    v = (uint)value;
 9ca:	8b 45 08             	mov    0x8(%ebp),%eax
 9cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 9d0:	eb 5b                	jmp    a2d <itoa+0x8b>
  {
    i = v % 10;
 9d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 9d5:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9da:	89 c8                	mov    %ecx,%eax
 9dc:	f7 e2                	mul    %edx
 9de:	c1 ea 03             	shr    $0x3,%edx
 9e1:	89 d0                	mov    %edx,%eax
 9e3:	c1 e0 02             	shl    $0x2,%eax
 9e6:	01 d0                	add    %edx,%eax
 9e8:	01 c0                	add    %eax,%eax
 9ea:	29 c1                	sub    %eax,%ecx
 9ec:	89 ca                	mov    %ecx,%edx
 9ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 9f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f4:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9f9:	f7 e2                	mul    %edx
 9fb:	89 d0                	mov    %edx,%eax
 9fd:	c1 e8 03             	shr    $0x3,%eax
 a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 a03:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 a07:	7f 13                	jg     a1c <itoa+0x7a>
      *tp++ = i+'0';
 a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0c:	8d 50 01             	lea    0x1(%eax),%edx
 a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a15:	83 c2 30             	add    $0x30,%edx
 a18:	88 10                	mov    %dl,(%eax)
 a1a:	eb 11                	jmp    a2d <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1f:	8d 50 01             	lea    0x1(%eax),%edx
 a22:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a28:	83 c2 57             	add    $0x57,%edx
 a2b:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 a2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a31:	75 9f                	jne    9d2 <itoa+0x30>
 a33:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a36:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a39:	74 97                	je     9d2 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 a3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a3e:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a41:	29 c2                	sub    %eax,%edx
 a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a46:	01 d0                	add    %edx,%eax
 a48:	83 c0 01             	add    $0x1,%eax
 a4b:	83 ec 0c             	sub    $0xc,%esp
 a4e:	50                   	push   %eax
 a4f:	e8 d9 fc ff ff       	call   72d <malloc>
 a54:	83 c4 10             	add    $0x10,%esp
 a57:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a60:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a64:	74 0c                	je     a72 <itoa+0xd0>
    *sp++ = '-';
 a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a69:	8d 50 01             	lea    0x1(%eax),%edx
 a6c:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a6f:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a72:	eb 15                	jmp    a89 <itoa+0xe7>
    *sp++ = *--tp;
 a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a77:	8d 50 01             	lea    0x1(%eax),%edx
 a7a:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a7d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a84:	0f b6 12             	movzbl (%edx),%edx
 a87:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 a89:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a8c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a8f:	77 e3                	ja     a74 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 a91:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a94:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 a9a:	c9                   	leave  
 a9b:	c3                   	ret    

00000a9c <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 a9c:	55                   	push   %ebp
 a9d:	89 e5                	mov    %esp,%ebp
 a9f:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 aa5:	83 ec 08             	sub    $0x8,%esp
 aa8:	6a 00                	push   $0x0
 aaa:	ff 75 08             	pushl  0x8(%ebp)
 aad:	e8 55 f8 ff ff       	call   307 <open>
 ab2:	83 c4 10             	add    $0x10,%esp
 ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 ab8:	e9 22 01 00 00       	jmp    bdf <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 abd:	83 ec 08             	sub    $0x8,%esp
 ac0:	6a 3d                	push   $0x3d
 ac2:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ac8:	50                   	push   %eax
 ac9:	e8 79 f6 ff ff       	call   147 <strchr>
 ace:	83 c4 10             	add    $0x10,%esp
 ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 ad4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ad8:	0f 84 23 01 00 00    	je     c01 <parseEnvFile+0x165>
 ade:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ae2:	0f 84 19 01 00 00    	je     c01 <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 ae8:	8b 55 f0             	mov    -0x10(%ebp),%edx
 aeb:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 af1:	29 c2                	sub    %eax,%edx
 af3:	89 d0                	mov    %edx,%eax
 af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 afb:	83 c0 01             	add    $0x1,%eax
 afe:	83 ec 0c             	sub    $0xc,%esp
 b01:	50                   	push   %eax
 b02:	e8 26 fc ff ff       	call   72d <malloc>
 b07:	83 c4 10             	add    $0x10,%esp
 b0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 b0d:	83 ec 04             	sub    $0x4,%esp
 b10:	ff 75 ec             	pushl  -0x14(%ebp)
 b13:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b19:	50                   	push   %eax
 b1a:	ff 75 e8             	pushl  -0x18(%ebp)
 b1d:	e8 8f fd ff ff       	call   8b1 <strncpy>
 b22:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 b25:	83 ec 0c             	sub    $0xc,%esp
 b28:	ff 75 e8             	pushl  -0x18(%ebp)
 b2b:	e8 c5 fd ff ff       	call   8f5 <trim>
 b30:	83 c4 10             	add    $0x10,%esp
 b33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 b36:	83 ec 0c             	sub    $0xc,%esp
 b39:	ff 75 e8             	pushl  -0x18(%ebp)
 b3c:	e8 ab fa ff ff       	call   5ec <free>
 b41:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 b44:	83 ec 08             	sub    $0x8,%esp
 b47:	ff 75 0c             	pushl  0xc(%ebp)
 b4a:	ff 75 e4             	pushl  -0x1c(%ebp)
 b4d:	e8 c2 01 00 00       	call   d14 <addToEnvironment>
 b52:	83 c4 10             	add    $0x10,%esp
 b55:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b58:	83 ec 0c             	sub    $0xc,%esp
 b5b:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b61:	50                   	push   %eax
 b62:	e8 9f f5 ff ff       	call   106 <strlen>
 b67:	83 c4 10             	add    $0x10,%esp
 b6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b70:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b73:	83 ec 0c             	sub    $0xc,%esp
 b76:	50                   	push   %eax
 b77:	e8 b1 fb ff ff       	call   72d <malloc>
 b7c:	83 c4 10             	add    $0x10,%esp
 b7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 b82:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b85:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b88:	8d 50 ff             	lea    -0x1(%eax),%edx
 b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b8e:	8d 48 01             	lea    0x1(%eax),%ecx
 b91:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b97:	01 c8                	add    %ecx,%eax
 b99:	83 ec 04             	sub    $0x4,%esp
 b9c:	52                   	push   %edx
 b9d:	50                   	push   %eax
 b9e:	ff 75 e8             	pushl  -0x18(%ebp)
 ba1:	e8 0b fd ff ff       	call   8b1 <strncpy>
 ba6:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 ba9:	83 ec 0c             	sub    $0xc,%esp
 bac:	ff 75 e8             	pushl  -0x18(%ebp)
 baf:	e8 41 fd ff ff       	call   8f5 <trim>
 bb4:	83 c4 10             	add    $0x10,%esp
 bb7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 bba:	83 ec 0c             	sub    $0xc,%esp
 bbd:	ff 75 e8             	pushl  -0x18(%ebp)
 bc0:	e8 27 fa ff ff       	call   5ec <free>
 bc5:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 bc8:	83 ec 04             	sub    $0x4,%esp
 bcb:	ff 75 dc             	pushl  -0x24(%ebp)
 bce:	ff 75 0c             	pushl  0xc(%ebp)
 bd1:	ff 75 e4             	pushl  -0x1c(%ebp)
 bd4:	e8 b8 01 00 00       	call   d91 <addValueToVariable>
 bd9:	83 c4 10             	add    $0x10,%esp
 bdc:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 bdf:	83 ec 04             	sub    $0x4,%esp
 be2:	ff 75 f4             	pushl  -0xc(%ebp)
 be5:	68 00 04 00 00       	push   $0x400
 bea:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 bf0:	50                   	push   %eax
 bf1:	e8 4c fc ff ff       	call   842 <readln>
 bf6:	83 c4 10             	add    $0x10,%esp
 bf9:	85 c0                	test   %eax,%eax
 bfb:	0f 85 bc fe ff ff    	jne    abd <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 c01:	83 ec 0c             	sub    $0xc,%esp
 c04:	ff 75 f4             	pushl  -0xc(%ebp)
 c07:	e8 e3 f6 ff ff       	call   2ef <close>
 c0c:	83 c4 10             	add    $0x10,%esp
	return head;
 c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c12:	c9                   	leave  
 c13:	c3                   	ret    

00000c14 <comp>:

int comp(const char* s1, const char* s2)
{
 c14:	55                   	push   %ebp
 c15:	89 e5                	mov    %esp,%ebp
 c17:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 c1a:	83 ec 08             	sub    $0x8,%esp
 c1d:	ff 75 0c             	pushl  0xc(%ebp)
 c20:	ff 75 08             	pushl  0x8(%ebp)
 c23:	e8 9f f4 ff ff       	call   c7 <strcmp>
 c28:	83 c4 10             	add    $0x10,%esp
 c2b:	85 c0                	test   %eax,%eax
 c2d:	0f 94 c0             	sete   %al
 c30:	0f b6 c0             	movzbl %al,%eax
}
 c33:	c9                   	leave  
 c34:	c3                   	ret    

00000c35 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 c35:	55                   	push   %ebp
 c36:	89 e5                	mov    %esp,%ebp
 c38:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 c3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c3f:	75 07                	jne    c48 <environLookup+0x13>
    return NULL;
 c41:	b8 00 00 00 00       	mov    $0x0,%eax
 c46:	eb 2f                	jmp    c77 <environLookup+0x42>
  
  while (head)
 c48:	eb 24                	jmp    c6e <environLookup+0x39>
  {
    if (comp(name, head->name))
 c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
 c4d:	83 ec 08             	sub    $0x8,%esp
 c50:	50                   	push   %eax
 c51:	ff 75 08             	pushl  0x8(%ebp)
 c54:	e8 bb ff ff ff       	call   c14 <comp>
 c59:	83 c4 10             	add    $0x10,%esp
 c5c:	85 c0                	test   %eax,%eax
 c5e:	74 02                	je     c62 <environLookup+0x2d>
      break;
 c60:	eb 12                	jmp    c74 <environLookup+0x3f>
    head = head->next;
 c62:	8b 45 0c             	mov    0xc(%ebp),%eax
 c65:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c6b:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c72:	75 d6                	jne    c4a <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c74:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c77:	c9                   	leave  
 c78:	c3                   	ret    

00000c79 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c79:	55                   	push   %ebp
 c7a:	89 e5                	mov    %esp,%ebp
 c7c:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c83:	75 0a                	jne    c8f <removeFromEnvironment+0x16>
    return NULL;
 c85:	b8 00 00 00 00       	mov    $0x0,%eax
 c8a:	e9 83 00 00 00       	jmp    d12 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 c8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c93:	74 0a                	je     c9f <removeFromEnvironment+0x26>
 c95:	8b 45 08             	mov    0x8(%ebp),%eax
 c98:	0f b6 00             	movzbl (%eax),%eax
 c9b:	84 c0                	test   %al,%al
 c9d:	75 05                	jne    ca4 <removeFromEnvironment+0x2b>
    return head;
 c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
 ca2:	eb 6e                	jmp    d12 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
 ca7:	83 ec 08             	sub    $0x8,%esp
 caa:	ff 75 08             	pushl  0x8(%ebp)
 cad:	50                   	push   %eax
 cae:	e8 61 ff ff ff       	call   c14 <comp>
 cb3:	83 c4 10             	add    $0x10,%esp
 cb6:	85 c0                	test   %eax,%eax
 cb8:	74 34                	je     cee <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 cba:	8b 45 0c             	mov    0xc(%ebp),%eax
 cbd:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
 cc9:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 ccf:	83 ec 0c             	sub    $0xc,%esp
 cd2:	50                   	push   %eax
 cd3:	e8 74 01 00 00       	call   e4c <freeVarval>
 cd8:	83 c4 10             	add    $0x10,%esp
    free(head);
 cdb:	83 ec 0c             	sub    $0xc,%esp
 cde:	ff 75 0c             	pushl  0xc(%ebp)
 ce1:	e8 06 f9 ff ff       	call   5ec <free>
 ce6:	83 c4 10             	add    $0x10,%esp
    return tmp;
 ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cec:	eb 24                	jmp    d12 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 cee:	8b 45 0c             	mov    0xc(%ebp),%eax
 cf1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cf7:	83 ec 08             	sub    $0x8,%esp
 cfa:	50                   	push   %eax
 cfb:	ff 75 08             	pushl  0x8(%ebp)
 cfe:	e8 76 ff ff ff       	call   c79 <removeFromEnvironment>
 d03:	83 c4 10             	add    $0x10,%esp
 d06:	8b 55 0c             	mov    0xc(%ebp),%edx
 d09:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d12:	c9                   	leave  
 d13:	c3                   	ret    

00000d14 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 d14:	55                   	push   %ebp
 d15:	89 e5                	mov    %esp,%ebp
 d17:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 d1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 d1e:	75 05                	jne    d25 <addToEnvironment+0x11>
		return head;
 d20:	8b 45 0c             	mov    0xc(%ebp),%eax
 d23:	eb 6a                	jmp    d8f <addToEnvironment+0x7b>
	if (head == NULL) {
 d25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 d29:	75 40                	jne    d6b <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 d2b:	83 ec 0c             	sub    $0xc,%esp
 d2e:	68 88 00 00 00       	push   $0x88
 d33:	e8 f5 f9 ff ff       	call   72d <malloc>
 d38:	83 c4 10             	add    $0x10,%esp
 d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 d3e:	8b 45 08             	mov    0x8(%ebp),%eax
 d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d47:	83 ec 08             	sub    $0x8,%esp
 d4a:	ff 75 f0             	pushl  -0x10(%ebp)
 d4d:	50                   	push   %eax
 d4e:	e8 44 f3 ff ff       	call   97 <strcpy>
 d53:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d59:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d60:	00 00 00 
		head = newVar;
 d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d66:	89 45 0c             	mov    %eax,0xc(%ebp)
 d69:	eb 21                	jmp    d8c <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
 d6e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d74:	83 ec 08             	sub    $0x8,%esp
 d77:	50                   	push   %eax
 d78:	ff 75 08             	pushl  0x8(%ebp)
 d7b:	e8 94 ff ff ff       	call   d14 <addToEnvironment>
 d80:	83 c4 10             	add    $0x10,%esp
 d83:	8b 55 0c             	mov    0xc(%ebp),%edx
 d86:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d8f:	c9                   	leave  
 d90:	c3                   	ret    

00000d91 <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 d91:	55                   	push   %ebp
 d92:	89 e5                	mov    %esp,%ebp
 d94:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 d97:	83 ec 08             	sub    $0x8,%esp
 d9a:	ff 75 0c             	pushl  0xc(%ebp)
 d9d:	ff 75 08             	pushl  0x8(%ebp)
 da0:	e8 90 fe ff ff       	call   c35 <environLookup>
 da5:	83 c4 10             	add    $0x10,%esp
 da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 dab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 daf:	75 05                	jne    db6 <addValueToVariable+0x25>
		return head;
 db1:	8b 45 0c             	mov    0xc(%ebp),%eax
 db4:	eb 4c                	jmp    e02 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 db6:	83 ec 0c             	sub    $0xc,%esp
 db9:	68 04 04 00 00       	push   $0x404
 dbe:	e8 6a f9 ff ff       	call   72d <malloc>
 dc3:	83 c4 10             	add    $0x10,%esp
 dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 dc9:	8b 45 10             	mov    0x10(%ebp),%eax
 dcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dd2:	83 ec 08             	sub    $0x8,%esp
 dd5:	ff 75 ec             	pushl  -0x14(%ebp)
 dd8:	50                   	push   %eax
 dd9:	e8 b9 f2 ff ff       	call   97 <strcpy>
 dde:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de4:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ded:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df6:	8b 55 f0             	mov    -0x10(%ebp),%edx
 df9:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 dff:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 e02:	c9                   	leave  
 e03:	c3                   	ret    

00000e04 <freeEnvironment>:

void freeEnvironment(variable* head)
{
 e04:	55                   	push   %ebp
 e05:	89 e5                	mov    %esp,%ebp
 e07:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e0e:	75 02                	jne    e12 <freeEnvironment+0xe>
    return;  
 e10:	eb 38                	jmp    e4a <freeEnvironment+0x46>
  freeEnvironment(head->next);
 e12:	8b 45 08             	mov    0x8(%ebp),%eax
 e15:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 e1b:	83 ec 0c             	sub    $0xc,%esp
 e1e:	50                   	push   %eax
 e1f:	e8 e0 ff ff ff       	call   e04 <freeEnvironment>
 e24:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 e27:	8b 45 08             	mov    0x8(%ebp),%eax
 e2a:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 e30:	83 ec 0c             	sub    $0xc,%esp
 e33:	50                   	push   %eax
 e34:	e8 13 00 00 00       	call   e4c <freeVarval>
 e39:	83 c4 10             	add    $0x10,%esp
  free(head);
 e3c:	83 ec 0c             	sub    $0xc,%esp
 e3f:	ff 75 08             	pushl  0x8(%ebp)
 e42:	e8 a5 f7 ff ff       	call   5ec <free>
 e47:	83 c4 10             	add    $0x10,%esp
}
 e4a:	c9                   	leave  
 e4b:	c3                   	ret    

00000e4c <freeVarval>:

void freeVarval(varval* head)
{
 e4c:	55                   	push   %ebp
 e4d:	89 e5                	mov    %esp,%ebp
 e4f:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e56:	75 02                	jne    e5a <freeVarval+0xe>
    return;  
 e58:	eb 23                	jmp    e7d <freeVarval+0x31>
  freeVarval(head->next);
 e5a:	8b 45 08             	mov    0x8(%ebp),%eax
 e5d:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e63:	83 ec 0c             	sub    $0xc,%esp
 e66:	50                   	push   %eax
 e67:	e8 e0 ff ff ff       	call   e4c <freeVarval>
 e6c:	83 c4 10             	add    $0x10,%esp
  free(head);
 e6f:	83 ec 0c             	sub    $0xc,%esp
 e72:	ff 75 08             	pushl  0x8(%ebp)
 e75:	e8 72 f7 ff ff       	call   5ec <free>
 e7a:	83 c4 10             	add    $0x10,%esp
}
 e7d:	c9                   	leave  
 e7e:	c3                   	ret    

00000e7f <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e7f:	55                   	push   %ebp
 e80:	89 e5                	mov    %esp,%ebp
 e82:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 e85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e89:	75 08                	jne    e93 <getPaths+0x14>
		return head;
 e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
 e8e:	e9 e7 00 00 00       	jmp    f7a <getPaths+0xfb>
	if (head == NULL) {
 e93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 e97:	0f 85 b9 00 00 00    	jne    f56 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 e9d:	83 ec 08             	sub    $0x8,%esp
 ea0:	6a 3a                	push   $0x3a
 ea2:	ff 75 08             	pushl  0x8(%ebp)
 ea5:	e8 9d f2 ff ff       	call   147 <strchr>
 eaa:	83 c4 10             	add    $0x10,%esp
 ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 eb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 eb4:	75 56                	jne    f0c <getPaths+0x8d>
			pathLen = strlen(paths);
 eb6:	83 ec 0c             	sub    $0xc,%esp
 eb9:	ff 75 08             	pushl  0x8(%ebp)
 ebc:	e8 45 f2 ff ff       	call   106 <strlen>
 ec1:	83 c4 10             	add    $0x10,%esp
 ec4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 ec7:	83 ec 0c             	sub    $0xc,%esp
 eca:	68 04 04 00 00       	push   $0x404
 ecf:	e8 59 f8 ff ff       	call   72d <malloc>
 ed4:	83 c4 10             	add    $0x10,%esp
 ed7:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 eda:	8b 45 0c             	mov    0xc(%ebp),%eax
 edd:	83 ec 04             	sub    $0x4,%esp
 ee0:	ff 75 f0             	pushl  -0x10(%ebp)
 ee3:	ff 75 08             	pushl  0x8(%ebp)
 ee6:	50                   	push   %eax
 ee7:	e8 c5 f9 ff ff       	call   8b1 <strncpy>
 eec:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 eef:	8b 55 0c             	mov    0xc(%ebp),%edx
 ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ef5:	01 d0                	add    %edx,%eax
 ef7:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 efa:	8b 45 0c             	mov    0xc(%ebp),%eax
 efd:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 f04:	00 00 00 
			return head;
 f07:	8b 45 0c             	mov    0xc(%ebp),%eax
 f0a:	eb 6e                	jmp    f7a <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 f0f:	8b 45 08             	mov    0x8(%ebp),%eax
 f12:	29 c2                	sub    %eax,%edx
 f14:	89 d0                	mov    %edx,%eax
 f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 f19:	83 ec 0c             	sub    $0xc,%esp
 f1c:	68 04 04 00 00       	push   $0x404
 f21:	e8 07 f8 ff ff       	call   72d <malloc>
 f26:	83 c4 10             	add    $0x10,%esp
 f29:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
 f2f:	83 ec 04             	sub    $0x4,%esp
 f32:	ff 75 f0             	pushl  -0x10(%ebp)
 f35:	ff 75 08             	pushl  0x8(%ebp)
 f38:	50                   	push   %eax
 f39:	e8 73 f9 ff ff       	call   8b1 <strncpy>
 f3e:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f41:	8b 55 0c             	mov    0xc(%ebp),%edx
 f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f47:	01 d0                	add    %edx,%eax
 f49:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f4f:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 f52:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f56:	8b 45 0c             	mov    0xc(%ebp),%eax
 f59:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f5f:	83 ec 08             	sub    $0x8,%esp
 f62:	50                   	push   %eax
 f63:	ff 75 08             	pushl  0x8(%ebp)
 f66:	e8 14 ff ff ff       	call   e7f <getPaths>
 f6b:	83 c4 10             	add    $0x10,%esp
 f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
 f71:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f77:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f7a:	c9                   	leave  
 f7b:	c3                   	ret    
