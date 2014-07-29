
_shutdown:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
return shutdown();
  11:	e8 06 03 00 00       	call   31c <shutdown>
} 
  16:	83 c4 04             	add    $0x4,%esp
  19:	59                   	pop    %ecx
  1a:	5d                   	pop    %ebp
  1b:	8d 61 fc             	lea    -0x4(%ecx),%esp
  1e:	c3                   	ret    

0000001f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  1f:	55                   	push   %ebp
  20:	89 e5                	mov    %esp,%ebp
  22:	57                   	push   %edi
  23:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  27:	8b 55 10             	mov    0x10(%ebp),%edx
  2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  2d:	89 cb                	mov    %ecx,%ebx
  2f:	89 df                	mov    %ebx,%edi
  31:	89 d1                	mov    %edx,%ecx
  33:	fc                   	cld    
  34:	f3 aa                	rep stos %al,%es:(%edi)
  36:	89 ca                	mov    %ecx,%edx
  38:	89 fb                	mov    %edi,%ebx
  3a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  3d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  40:	5b                   	pop    %ebx
  41:	5f                   	pop    %edi
  42:	5d                   	pop    %ebp
  43:	c3                   	ret    

00000044 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  44:	55                   	push   %ebp
  45:	89 e5                	mov    %esp,%ebp
  47:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4a:	8b 45 08             	mov    0x8(%ebp),%eax
  4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  50:	90                   	nop
  51:	8b 45 08             	mov    0x8(%ebp),%eax
  54:	8d 50 01             	lea    0x1(%eax),%edx
  57:	89 55 08             	mov    %edx,0x8(%ebp)
  5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  60:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  63:	0f b6 12             	movzbl (%edx),%edx
  66:	88 10                	mov    %dl,(%eax)
  68:	0f b6 00             	movzbl (%eax),%eax
  6b:	84 c0                	test   %al,%al
  6d:	75 e2                	jne    51 <strcpy+0xd>
    ;
  return os;
  6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  72:	c9                   	leave  
  73:	c3                   	ret    

00000074 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  77:	eb 08                	jmp    81 <strcmp+0xd>
    p++, q++;
  79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  7d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  81:	8b 45 08             	mov    0x8(%ebp),%eax
  84:	0f b6 00             	movzbl (%eax),%eax
  87:	84 c0                	test   %al,%al
  89:	74 10                	je     9b <strcmp+0x27>
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	0f b6 10             	movzbl (%eax),%edx
  91:	8b 45 0c             	mov    0xc(%ebp),%eax
  94:	0f b6 00             	movzbl (%eax),%eax
  97:	38 c2                	cmp    %al,%dl
  99:	74 de                	je     79 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	0f b6 00             	movzbl (%eax),%eax
  a1:	0f b6 d0             	movzbl %al,%edx
  a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	0f b6 c0             	movzbl %al,%eax
  ad:	29 c2                	sub    %eax,%edx
  af:	89 d0                	mov    %edx,%eax
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <strlen>:

uint
strlen(char *s)
{
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c0:	eb 04                	jmp    c6 <strlen+0x13>
  c2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	01 d0                	add    %edx,%eax
  ce:	0f b6 00             	movzbl (%eax),%eax
  d1:	84 c0                	test   %al,%al
  d3:	75 ed                	jne    c2 <strlen+0xf>
    ;
  return n;
  d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d8:	c9                   	leave  
  d9:	c3                   	ret    

000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  dd:	8b 45 10             	mov    0x10(%ebp),%eax
  e0:	50                   	push   %eax
  e1:	ff 75 0c             	pushl  0xc(%ebp)
  e4:	ff 75 08             	pushl  0x8(%ebp)
  e7:	e8 33 ff ff ff       	call   1f <stosb>
  ec:	83 c4 0c             	add    $0xc,%esp
  return dst;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f2:	c9                   	leave  
  f3:	c3                   	ret    

000000f4 <strchr>:

char*
strchr(const char *s, char c)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	83 ec 04             	sub    $0x4,%esp
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 100:	eb 14                	jmp    116 <strchr+0x22>
    if(*s == c)
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	3a 45 fc             	cmp    -0x4(%ebp),%al
 10b:	75 05                	jne    112 <strchr+0x1e>
      return (char*)s;
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	eb 13                	jmp    125 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 112:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	84 c0                	test   %al,%al
 11e:	75 e2                	jne    102 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 120:	b8 00 00 00 00       	mov    $0x0,%eax
}
 125:	c9                   	leave  
 126:	c3                   	ret    

00000127 <gets>:

char*
gets(char *buf, int max)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 134:	eb 44                	jmp    17a <gets+0x53>
    cc = read(0, &c, 1);
 136:	83 ec 04             	sub    $0x4,%esp
 139:	6a 01                	push   $0x1
 13b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13e:	50                   	push   %eax
 13f:	6a 00                	push   $0x0
 141:	e8 46 01 00 00       	call   28c <read>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	7f 02                	jg     154 <gets+0x2d>
      break;
 152:	eb 31                	jmp    185 <gets+0x5e>
    buf[i++] = c;
 154:	8b 45 f4             	mov    -0xc(%ebp),%eax
 157:	8d 50 01             	lea    0x1(%eax),%edx
 15a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 15d:	89 c2                	mov    %eax,%edx
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	01 c2                	add    %eax,%edx
 164:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 168:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 16a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16e:	3c 0a                	cmp    $0xa,%al
 170:	74 13                	je     185 <gets+0x5e>
 172:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 176:	3c 0d                	cmp    $0xd,%al
 178:	74 0b                	je     185 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17d:	83 c0 01             	add    $0x1,%eax
 180:	3b 45 0c             	cmp    0xc(%ebp),%eax
 183:	7c b1                	jl     136 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 185:	8b 55 f4             	mov    -0xc(%ebp),%edx
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	01 d0                	add    %edx,%eax
 18d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 190:	8b 45 08             	mov    0x8(%ebp),%eax
}
 193:	c9                   	leave  
 194:	c3                   	ret    

00000195 <stat>:

int
stat(char *n, struct stat *st)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19b:	83 ec 08             	sub    $0x8,%esp
 19e:	6a 00                	push   $0x0
 1a0:	ff 75 08             	pushl  0x8(%ebp)
 1a3:	e8 0c 01 00 00       	call   2b4 <open>
 1a8:	83 c4 10             	add    $0x10,%esp
 1ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b2:	79 07                	jns    1bb <stat+0x26>
    return -1;
 1b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1b9:	eb 25                	jmp    1e0 <stat+0x4b>
  r = fstat(fd, st);
 1bb:	83 ec 08             	sub    $0x8,%esp
 1be:	ff 75 0c             	pushl  0xc(%ebp)
 1c1:	ff 75 f4             	pushl  -0xc(%ebp)
 1c4:	e8 03 01 00 00       	call   2cc <fstat>
 1c9:	83 c4 10             	add    $0x10,%esp
 1cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1cf:	83 ec 0c             	sub    $0xc,%esp
 1d2:	ff 75 f4             	pushl  -0xc(%ebp)
 1d5:	e8 c2 00 00 00       	call   29c <close>
 1da:	83 c4 10             	add    $0x10,%esp
  return r;
 1dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <atoi>:

int
atoi(const char *s)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1ef:	eb 25                	jmp    216 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f4:	89 d0                	mov    %edx,%eax
 1f6:	c1 e0 02             	shl    $0x2,%eax
 1f9:	01 d0                	add    %edx,%eax
 1fb:	01 c0                	add    %eax,%eax
 1fd:	89 c1                	mov    %eax,%ecx
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	8d 50 01             	lea    0x1(%eax),%edx
 205:	89 55 08             	mov    %edx,0x8(%ebp)
 208:	0f b6 00             	movzbl (%eax),%eax
 20b:	0f be c0             	movsbl %al,%eax
 20e:	01 c8                	add    %ecx,%eax
 210:	83 e8 30             	sub    $0x30,%eax
 213:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	0f b6 00             	movzbl (%eax),%eax
 21c:	3c 2f                	cmp    $0x2f,%al
 21e:	7e 0a                	jle    22a <atoi+0x48>
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	3c 39                	cmp    $0x39,%al
 228:	7e c7                	jle    1f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 22a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23b:	8b 45 0c             	mov    0xc(%ebp),%eax
 23e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 241:	eb 17                	jmp    25a <memmove+0x2b>
    *dst++ = *src++;
 243:	8b 45 fc             	mov    -0x4(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 fc             	mov    %edx,-0x4(%ebp)
 24c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 24f:	8d 4a 01             	lea    0x1(%edx),%ecx
 252:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 255:	0f b6 12             	movzbl (%edx),%edx
 258:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25a:	8b 45 10             	mov    0x10(%ebp),%eax
 25d:	8d 50 ff             	lea    -0x1(%eax),%edx
 260:	89 55 10             	mov    %edx,0x10(%ebp)
 263:	85 c0                	test   %eax,%eax
 265:	7f dc                	jg     243 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26a:	c9                   	leave  
 26b:	c3                   	ret    

0000026c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26c:	b8 01 00 00 00       	mov    $0x1,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <exit>:
SYSCALL(exit)
 274:	b8 02 00 00 00       	mov    $0x2,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <wait>:
SYSCALL(wait)
 27c:	b8 03 00 00 00       	mov    $0x3,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <pipe>:
SYSCALL(pipe)
 284:	b8 04 00 00 00       	mov    $0x4,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <read>:
SYSCALL(read)
 28c:	b8 05 00 00 00       	mov    $0x5,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <write>:
SYSCALL(write)
 294:	b8 10 00 00 00       	mov    $0x10,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <close>:
SYSCALL(close)
 29c:	b8 15 00 00 00       	mov    $0x15,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <kill>:
SYSCALL(kill)
 2a4:	b8 06 00 00 00       	mov    $0x6,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <exec>:
SYSCALL(exec)
 2ac:	b8 07 00 00 00       	mov    $0x7,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <open>:
SYSCALL(open)
 2b4:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <mknod>:
SYSCALL(mknod)
 2bc:	b8 11 00 00 00       	mov    $0x11,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <unlink>:
SYSCALL(unlink)
 2c4:	b8 12 00 00 00       	mov    $0x12,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <fstat>:
SYSCALL(fstat)
 2cc:	b8 08 00 00 00       	mov    $0x8,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <link>:
SYSCALL(link)
 2d4:	b8 13 00 00 00       	mov    $0x13,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <mkdir>:
SYSCALL(mkdir)
 2dc:	b8 14 00 00 00       	mov    $0x14,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <chdir>:
SYSCALL(chdir)
 2e4:	b8 09 00 00 00       	mov    $0x9,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <dup>:
SYSCALL(dup)
 2ec:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <getpid>:
SYSCALL(getpid)
 2f4:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <sbrk>:
SYSCALL(sbrk)
 2fc:	b8 0c 00 00 00       	mov    $0xc,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <sleep>:
SYSCALL(sleep)
 304:	b8 0d 00 00 00       	mov    $0xd,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <uptime>:
SYSCALL(uptime)
 30c:	b8 0e 00 00 00       	mov    $0xe,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <getcwd>:
SYSCALL(getcwd)
 314:	b8 16 00 00 00       	mov    $0x16,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <shutdown>:
SYSCALL(shutdown)
 31c:	b8 17 00 00 00       	mov    $0x17,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <buildinfo>:
SYSCALL(buildinfo)
 324:	b8 18 00 00 00       	mov    $0x18,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <lseek>:
SYSCALL(lseek)
 32c:	b8 19 00 00 00       	mov    $0x19,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	83 ec 18             	sub    $0x18,%esp
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 340:	83 ec 04             	sub    $0x4,%esp
 343:	6a 01                	push   $0x1
 345:	8d 45 f4             	lea    -0xc(%ebp),%eax
 348:	50                   	push   %eax
 349:	ff 75 08             	pushl  0x8(%ebp)
 34c:	e8 43 ff ff ff       	call   294 <write>
 351:	83 c4 10             	add    $0x10,%esp
}
 354:	c9                   	leave  
 355:	c3                   	ret    

00000356 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	53                   	push   %ebx
 35a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 35d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 364:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 368:	74 17                	je     381 <printint+0x2b>
 36a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 36e:	79 11                	jns    381 <printint+0x2b>
    neg = 1;
 370:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	f7 d8                	neg    %eax
 37c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37f:	eb 06                	jmp    387 <printint+0x31>
  } else {
    x = xx;
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 38e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 391:	8d 41 01             	lea    0x1(%ecx),%eax
 394:	89 45 f4             	mov    %eax,-0xc(%ebp)
 397:	8b 5d 10             	mov    0x10(%ebp),%ebx
 39a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 39d:	ba 00 00 00 00       	mov    $0x0,%edx
 3a2:	f7 f3                	div    %ebx
 3a4:	89 d0                	mov    %edx,%eax
 3a6:	0f b6 80 40 13 00 00 	movzbl 0x1340(%eax),%eax
 3ad:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b7:	ba 00 00 00 00       	mov    $0x0,%edx
 3bc:	f7 f3                	div    %ebx
 3be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c5:	75 c7                	jne    38e <printint+0x38>
  if(neg)
 3c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3cb:	74 0e                	je     3db <printint+0x85>
    buf[i++] = '-';
 3cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d0:	8d 50 01             	lea    0x1(%eax),%edx
 3d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3d6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3db:	eb 1d                	jmp    3fa <printint+0xa4>
    putc(fd, buf[i]);
 3dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e3:	01 d0                	add    %edx,%eax
 3e5:	0f b6 00             	movzbl (%eax),%eax
 3e8:	0f be c0             	movsbl %al,%eax
 3eb:	83 ec 08             	sub    $0x8,%esp
 3ee:	50                   	push   %eax
 3ef:	ff 75 08             	pushl  0x8(%ebp)
 3f2:	e8 3d ff ff ff       	call   334 <putc>
 3f7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3fa:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 402:	79 d9                	jns    3dd <printint+0x87>
    putc(fd, buf[i]);
}
 404:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 407:	c9                   	leave  
 408:	c3                   	ret    

00000409 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 40f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 416:	8d 45 0c             	lea    0xc(%ebp),%eax
 419:	83 c0 04             	add    $0x4,%eax
 41c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 41f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 426:	e9 59 01 00 00       	jmp    584 <printf+0x17b>
    c = fmt[i] & 0xff;
 42b:	8b 55 0c             	mov    0xc(%ebp),%edx
 42e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 431:	01 d0                	add    %edx,%eax
 433:	0f b6 00             	movzbl (%eax),%eax
 436:	0f be c0             	movsbl %al,%eax
 439:	25 ff 00 00 00       	and    $0xff,%eax
 43e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 441:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 445:	75 2c                	jne    473 <printf+0x6a>
      if(c == '%'){
 447:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 44b:	75 0c                	jne    459 <printf+0x50>
        state = '%';
 44d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 454:	e9 27 01 00 00       	jmp    580 <printf+0x177>
      } else {
        putc(fd, c);
 459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 45c:	0f be c0             	movsbl %al,%eax
 45f:	83 ec 08             	sub    $0x8,%esp
 462:	50                   	push   %eax
 463:	ff 75 08             	pushl  0x8(%ebp)
 466:	e8 c9 fe ff ff       	call   334 <putc>
 46b:	83 c4 10             	add    $0x10,%esp
 46e:	e9 0d 01 00 00       	jmp    580 <printf+0x177>
      }
    } else if(state == '%'){
 473:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 477:	0f 85 03 01 00 00    	jne    580 <printf+0x177>
      if(c == 'd'){
 47d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 481:	75 1e                	jne    4a1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 483:	8b 45 e8             	mov    -0x18(%ebp),%eax
 486:	8b 00                	mov    (%eax),%eax
 488:	6a 01                	push   $0x1
 48a:	6a 0a                	push   $0xa
 48c:	50                   	push   %eax
 48d:	ff 75 08             	pushl  0x8(%ebp)
 490:	e8 c1 fe ff ff       	call   356 <printint>
 495:	83 c4 10             	add    $0x10,%esp
        ap++;
 498:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 49c:	e9 d8 00 00 00       	jmp    579 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4a1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4a5:	74 06                	je     4ad <printf+0xa4>
 4a7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ab:	75 1e                	jne    4cb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b0:	8b 00                	mov    (%eax),%eax
 4b2:	6a 00                	push   $0x0
 4b4:	6a 10                	push   $0x10
 4b6:	50                   	push   %eax
 4b7:	ff 75 08             	pushl  0x8(%ebp)
 4ba:	e8 97 fe ff ff       	call   356 <printint>
 4bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c6:	e9 ae 00 00 00       	jmp    579 <printf+0x170>
      } else if(c == 's'){
 4cb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4cf:	75 43                	jne    514 <printf+0x10b>
        s = (char*)*ap;
 4d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d4:	8b 00                	mov    (%eax),%eax
 4d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e1:	75 07                	jne    4ea <printf+0xe1>
          s = "(null)";
 4e3:	c7 45 f4 29 0f 00 00 	movl   $0xf29,-0xc(%ebp)
        while(*s != 0){
 4ea:	eb 1c                	jmp    508 <printf+0xff>
          putc(fd, *s);
 4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ef:	0f b6 00             	movzbl (%eax),%eax
 4f2:	0f be c0             	movsbl %al,%eax
 4f5:	83 ec 08             	sub    $0x8,%esp
 4f8:	50                   	push   %eax
 4f9:	ff 75 08             	pushl  0x8(%ebp)
 4fc:	e8 33 fe ff ff       	call   334 <putc>
 501:	83 c4 10             	add    $0x10,%esp
          s++;
 504:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 508:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50b:	0f b6 00             	movzbl (%eax),%eax
 50e:	84 c0                	test   %al,%al
 510:	75 da                	jne    4ec <printf+0xe3>
 512:	eb 65                	jmp    579 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 514:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 518:	75 1d                	jne    537 <printf+0x12e>
        putc(fd, *ap);
 51a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51d:	8b 00                	mov    (%eax),%eax
 51f:	0f be c0             	movsbl %al,%eax
 522:	83 ec 08             	sub    $0x8,%esp
 525:	50                   	push   %eax
 526:	ff 75 08             	pushl  0x8(%ebp)
 529:	e8 06 fe ff ff       	call   334 <putc>
 52e:	83 c4 10             	add    $0x10,%esp
        ap++;
 531:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 535:	eb 42                	jmp    579 <printf+0x170>
      } else if(c == '%'){
 537:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53b:	75 17                	jne    554 <printf+0x14b>
        putc(fd, c);
 53d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 540:	0f be c0             	movsbl %al,%eax
 543:	83 ec 08             	sub    $0x8,%esp
 546:	50                   	push   %eax
 547:	ff 75 08             	pushl  0x8(%ebp)
 54a:	e8 e5 fd ff ff       	call   334 <putc>
 54f:	83 c4 10             	add    $0x10,%esp
 552:	eb 25                	jmp    579 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 554:	83 ec 08             	sub    $0x8,%esp
 557:	6a 25                	push   $0x25
 559:	ff 75 08             	pushl  0x8(%ebp)
 55c:	e8 d3 fd ff ff       	call   334 <putc>
 561:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 564:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 567:	0f be c0             	movsbl %al,%eax
 56a:	83 ec 08             	sub    $0x8,%esp
 56d:	50                   	push   %eax
 56e:	ff 75 08             	pushl  0x8(%ebp)
 571:	e8 be fd ff ff       	call   334 <putc>
 576:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 579:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 580:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 584:	8b 55 0c             	mov    0xc(%ebp),%edx
 587:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58a:	01 d0                	add    %edx,%eax
 58c:	0f b6 00             	movzbl (%eax),%eax
 58f:	84 c0                	test   %al,%al
 591:	0f 85 94 fe ff ff    	jne    42b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 597:	c9                   	leave  
 598:	c3                   	ret    

00000599 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 599:	55                   	push   %ebp
 59a:	89 e5                	mov    %esp,%ebp
 59c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 59f:	8b 45 08             	mov    0x8(%ebp),%eax
 5a2:	83 e8 08             	sub    $0x8,%eax
 5a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a8:	a1 5c 13 00 00       	mov    0x135c,%eax
 5ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5b0:	eb 24                	jmp    5d6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b5:	8b 00                	mov    (%eax),%eax
 5b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ba:	77 12                	ja     5ce <free+0x35>
 5bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c2:	77 24                	ja     5e8 <free+0x4f>
 5c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c7:	8b 00                	mov    (%eax),%eax
 5c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5cc:	77 1a                	ja     5e8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d1:	8b 00                	mov    (%eax),%eax
 5d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5dc:	76 d4                	jbe    5b2 <free+0x19>
 5de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e6:	76 ca                	jbe    5b2 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5eb:	8b 40 04             	mov    0x4(%eax),%eax
 5ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f8:	01 c2                	add    %eax,%edx
 5fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fd:	8b 00                	mov    (%eax),%eax
 5ff:	39 c2                	cmp    %eax,%edx
 601:	75 24                	jne    627 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 603:	8b 45 f8             	mov    -0x8(%ebp),%eax
 606:	8b 50 04             	mov    0x4(%eax),%edx
 609:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60c:	8b 00                	mov    (%eax),%eax
 60e:	8b 40 04             	mov    0x4(%eax),%eax
 611:	01 c2                	add    %eax,%edx
 613:	8b 45 f8             	mov    -0x8(%ebp),%eax
 616:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	8b 10                	mov    (%eax),%edx
 620:	8b 45 f8             	mov    -0x8(%ebp),%eax
 623:	89 10                	mov    %edx,(%eax)
 625:	eb 0a                	jmp    631 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 627:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62a:	8b 10                	mov    (%eax),%edx
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 40 04             	mov    0x4(%eax),%eax
 637:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	01 d0                	add    %edx,%eax
 643:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 646:	75 20                	jne    668 <free+0xcf>
    p->s.size += bp->s.size;
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 50 04             	mov    0x4(%eax),%edx
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	8b 40 04             	mov    0x4(%eax),%eax
 654:	01 c2                	add    %eax,%edx
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 65c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65f:	8b 10                	mov    (%eax),%edx
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	89 10                	mov    %edx,(%eax)
 666:	eb 08                	jmp    670 <free+0xd7>
  } else
    p->s.ptr = bp;
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 66e:	89 10                	mov    %edx,(%eax)
  freep = p;
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	a3 5c 13 00 00       	mov    %eax,0x135c
}
 678:	c9                   	leave  
 679:	c3                   	ret    

0000067a <morecore>:

static Header*
morecore(uint nu)
{
 67a:	55                   	push   %ebp
 67b:	89 e5                	mov    %esp,%ebp
 67d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 680:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 687:	77 07                	ja     690 <morecore+0x16>
    nu = 4096;
 689:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	c1 e0 03             	shl    $0x3,%eax
 696:	83 ec 0c             	sub    $0xc,%esp
 699:	50                   	push   %eax
 69a:	e8 5d fc ff ff       	call   2fc <sbrk>
 69f:	83 c4 10             	add    $0x10,%esp
 6a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6a9:	75 07                	jne    6b2 <morecore+0x38>
    return 0;
 6ab:	b8 00 00 00 00       	mov    $0x0,%eax
 6b0:	eb 26                	jmp    6d8 <morecore+0x5e>
  hp = (Header*)p;
 6b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bb:	8b 55 08             	mov    0x8(%ebp),%edx
 6be:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c4:	83 c0 08             	add    $0x8,%eax
 6c7:	83 ec 0c             	sub    $0xc,%esp
 6ca:	50                   	push   %eax
 6cb:	e8 c9 fe ff ff       	call   599 <free>
 6d0:	83 c4 10             	add    $0x10,%esp
  return freep;
 6d3:	a1 5c 13 00 00       	mov    0x135c,%eax
}
 6d8:	c9                   	leave  
 6d9:	c3                   	ret    

000006da <malloc>:

void*
malloc(uint nbytes)
{
 6da:	55                   	push   %ebp
 6db:	89 e5                	mov    %esp,%ebp
 6dd:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	83 c0 07             	add    $0x7,%eax
 6e6:	c1 e8 03             	shr    $0x3,%eax
 6e9:	83 c0 01             	add    $0x1,%eax
 6ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6ef:	a1 5c 13 00 00       	mov    0x135c,%eax
 6f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fb:	75 23                	jne    720 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 6fd:	c7 45 f0 54 13 00 00 	movl   $0x1354,-0x10(%ebp)
 704:	8b 45 f0             	mov    -0x10(%ebp),%eax
 707:	a3 5c 13 00 00       	mov    %eax,0x135c
 70c:	a1 5c 13 00 00       	mov    0x135c,%eax
 711:	a3 54 13 00 00       	mov    %eax,0x1354
    base.s.size = 0;
 716:	c7 05 58 13 00 00 00 	movl   $0x0,0x1358
 71d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 720:	8b 45 f0             	mov    -0x10(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 728:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72b:	8b 40 04             	mov    0x4(%eax),%eax
 72e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 731:	72 4d                	jb     780 <malloc+0xa6>
      if(p->s.size == nunits)
 733:	8b 45 f4             	mov    -0xc(%ebp),%eax
 736:	8b 40 04             	mov    0x4(%eax),%eax
 739:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 73c:	75 0c                	jne    74a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 73e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 741:	8b 10                	mov    (%eax),%edx
 743:	8b 45 f0             	mov    -0x10(%ebp),%eax
 746:	89 10                	mov    %edx,(%eax)
 748:	eb 26                	jmp    770 <malloc+0x96>
      else {
        p->s.size -= nunits;
 74a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74d:	8b 40 04             	mov    0x4(%eax),%eax
 750:	2b 45 ec             	sub    -0x14(%ebp),%eax
 753:	89 c2                	mov    %eax,%edx
 755:	8b 45 f4             	mov    -0xc(%ebp),%eax
 758:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75e:	8b 40 04             	mov    0x4(%eax),%eax
 761:	c1 e0 03             	shl    $0x3,%eax
 764:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 767:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 76d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	a3 5c 13 00 00       	mov    %eax,0x135c
      return (void*)(p + 1);
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	83 c0 08             	add    $0x8,%eax
 77e:	eb 3b                	jmp    7bb <malloc+0xe1>
    }
    if(p == freep)
 780:	a1 5c 13 00 00       	mov    0x135c,%eax
 785:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 788:	75 1e                	jne    7a8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 78a:	83 ec 0c             	sub    $0xc,%esp
 78d:	ff 75 ec             	pushl  -0x14(%ebp)
 790:	e8 e5 fe ff ff       	call   67a <morecore>
 795:	83 c4 10             	add    $0x10,%esp
 798:	89 45 f4             	mov    %eax,-0xc(%ebp)
 79b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 79f:	75 07                	jne    7a8 <malloc+0xce>
        return 0;
 7a1:	b8 00 00 00 00       	mov    $0x0,%eax
 7a6:	eb 13                	jmp    7bb <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 00                	mov    (%eax),%eax
 7b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7b6:	e9 6d ff ff ff       	jmp    728 <malloc+0x4e>
}
 7bb:	c9                   	leave  
 7bc:	c3                   	ret    

000007bd <isspace>:

#include "common.h"

int isspace(char c) {
 7bd:	55                   	push   %ebp
 7be:	89 e5                	mov    %esp,%ebp
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 7c9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 7cd:	74 12                	je     7e1 <isspace+0x24>
 7cf:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 7d3:	74 0c                	je     7e1 <isspace+0x24>
 7d5:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 7d9:	74 06                	je     7e1 <isspace+0x24>
 7db:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 7df:	75 07                	jne    7e8 <isspace+0x2b>
 7e1:	b8 01 00 00 00       	mov    $0x1,%eax
 7e6:	eb 05                	jmp    7ed <isspace+0x30>
 7e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 7ed:	c9                   	leave  
 7ee:	c3                   	ret    

000007ef <readln>:

char* readln(char *buf, int max, int fd)
{
 7ef:	55                   	push   %ebp
 7f0:	89 e5                	mov    %esp,%ebp
 7f2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 7fc:	eb 45                	jmp    843 <readln+0x54>
    cc = read(fd, &c, 1);
 7fe:	83 ec 04             	sub    $0x4,%esp
 801:	6a 01                	push   $0x1
 803:	8d 45 ef             	lea    -0x11(%ebp),%eax
 806:	50                   	push   %eax
 807:	ff 75 10             	pushl  0x10(%ebp)
 80a:	e8 7d fa ff ff       	call   28c <read>
 80f:	83 c4 10             	add    $0x10,%esp
 812:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 815:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 819:	7f 02                	jg     81d <readln+0x2e>
      break;
 81b:	eb 31                	jmp    84e <readln+0x5f>
    buf[i++] = c;
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8d 50 01             	lea    0x1(%eax),%edx
 823:	89 55 f4             	mov    %edx,-0xc(%ebp)
 826:	89 c2                	mov    %eax,%edx
 828:	8b 45 08             	mov    0x8(%ebp),%eax
 82b:	01 c2                	add    %eax,%edx
 82d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 831:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 833:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 837:	3c 0a                	cmp    $0xa,%al
 839:	74 13                	je     84e <readln+0x5f>
 83b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 83f:	3c 0d                	cmp    $0xd,%al
 841:	74 0b                	je     84e <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	83 c0 01             	add    $0x1,%eax
 849:	3b 45 0c             	cmp    0xc(%ebp),%eax
 84c:	7c b0                	jl     7fe <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 84e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 851:	8b 45 08             	mov    0x8(%ebp),%eax
 854:	01 d0                	add    %edx,%eax
 856:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 859:	8b 45 08             	mov    0x8(%ebp),%eax
}
 85c:	c9                   	leave  
 85d:	c3                   	ret    

0000085e <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 85e:	55                   	push   %ebp
 85f:	89 e5                	mov    %esp,%ebp
 861:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 864:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 86b:	eb 19                	jmp    886 <strncpy+0x28>
		dest[i] = src[i];
 86d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 870:	8b 45 08             	mov    0x8(%ebp),%eax
 873:	01 c2                	add    %eax,%edx
 875:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 878:	8b 45 0c             	mov    0xc(%ebp),%eax
 87b:	01 c8                	add    %ecx,%eax
 87d:	0f b6 00             	movzbl (%eax),%eax
 880:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 882:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 886:	8b 45 fc             	mov    -0x4(%ebp),%eax
 889:	3b 45 10             	cmp    0x10(%ebp),%eax
 88c:	7d 0f                	jge    89d <strncpy+0x3f>
 88e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 891:	8b 45 0c             	mov    0xc(%ebp),%eax
 894:	01 d0                	add    %edx,%eax
 896:	0f b6 00             	movzbl (%eax),%eax
 899:	84 c0                	test   %al,%al
 89b:	75 d0                	jne    86d <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 89d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8a0:	c9                   	leave  
 8a1:	c3                   	ret    

000008a2 <trim>:

char* trim(char* orig) {
 8a2:	55                   	push   %ebp
 8a3:	89 e5                	mov    %esp,%ebp
 8a5:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 8a8:	8b 45 08             	mov    0x8(%ebp),%eax
 8ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 8ae:	8b 45 08             	mov    0x8(%ebp),%eax
 8b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 8b4:	eb 04                	jmp    8ba <trim+0x18>
 8b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	0f b6 00             	movzbl (%eax),%eax
 8c0:	0f be c0             	movsbl %al,%eax
 8c3:	50                   	push   %eax
 8c4:	e8 f4 fe ff ff       	call   7bd <isspace>
 8c9:	83 c4 04             	add    $0x4,%esp
 8cc:	85 c0                	test   %eax,%eax
 8ce:	75 e6                	jne    8b6 <trim+0x14>
	while (*tail) { tail++; }
 8d0:	eb 04                	jmp    8d6 <trim+0x34>
 8d2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	0f b6 00             	movzbl (%eax),%eax
 8dc:	84 c0                	test   %al,%al
 8de:	75 f2                	jne    8d2 <trim+0x30>
	do { tail--; } while (isspace(*tail));
 8e0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 8e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e7:	0f b6 00             	movzbl (%eax),%eax
 8ea:	0f be c0             	movsbl %al,%eax
 8ed:	50                   	push   %eax
 8ee:	e8 ca fe ff ff       	call   7bd <isspace>
 8f3:	83 c4 04             	add    $0x4,%esp
 8f6:	85 c0                	test   %eax,%eax
 8f8:	75 e6                	jne    8e0 <trim+0x3e>
	new = malloc(tail-head+2);
 8fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	29 c2                	sub    %eax,%edx
 902:	89 d0                	mov    %edx,%eax
 904:	83 c0 02             	add    $0x2,%eax
 907:	83 ec 0c             	sub    $0xc,%esp
 90a:	50                   	push   %eax
 90b:	e8 ca fd ff ff       	call   6da <malloc>
 910:	83 c4 10             	add    $0x10,%esp
 913:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 916:	8b 55 f0             	mov    -0x10(%ebp),%edx
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	29 c2                	sub    %eax,%edx
 91e:	89 d0                	mov    %edx,%eax
 920:	83 c0 01             	add    $0x1,%eax
 923:	83 ec 04             	sub    $0x4,%esp
 926:	50                   	push   %eax
 927:	ff 75 f4             	pushl  -0xc(%ebp)
 92a:	ff 75 ec             	pushl  -0x14(%ebp)
 92d:	e8 2c ff ff ff       	call   85e <strncpy>
 932:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 935:	8b 55 f0             	mov    -0x10(%ebp),%edx
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	29 c2                	sub    %eax,%edx
 93d:	89 d0                	mov    %edx,%eax
 93f:	8d 50 01             	lea    0x1(%eax),%edx
 942:	8b 45 ec             	mov    -0x14(%ebp),%eax
 945:	01 d0                	add    %edx,%eax
 947:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 94a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 94d:	c9                   	leave  
 94e:	c3                   	ret    

0000094f <itoa>:

char *
itoa(int value)
{
 94f:	55                   	push   %ebp
 950:	89 e5                	mov    %esp,%ebp
 952:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 955:	8d 45 bf             	lea    -0x41(%ebp),%eax
 958:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 95b:	8b 45 08             	mov    0x8(%ebp),%eax
 95e:	c1 e8 1f             	shr    $0x1f,%eax
 961:	0f b6 c0             	movzbl %al,%eax
 964:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 967:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 96b:	74 0a                	je     977 <itoa+0x28>
    v = -value;
 96d:	8b 45 08             	mov    0x8(%ebp),%eax
 970:	f7 d8                	neg    %eax
 972:	89 45 f0             	mov    %eax,-0x10(%ebp)
 975:	eb 06                	jmp    97d <itoa+0x2e>
  else
    v = (uint)value;
 977:	8b 45 08             	mov    0x8(%ebp),%eax
 97a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 97d:	eb 5b                	jmp    9da <itoa+0x8b>
  {
    i = v % 10;
 97f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 982:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 987:	89 c8                	mov    %ecx,%eax
 989:	f7 e2                	mul    %edx
 98b:	c1 ea 03             	shr    $0x3,%edx
 98e:	89 d0                	mov    %edx,%eax
 990:	c1 e0 02             	shl    $0x2,%eax
 993:	01 d0                	add    %edx,%eax
 995:	01 c0                	add    %eax,%eax
 997:	29 c1                	sub    %eax,%ecx
 999:	89 ca                	mov    %ecx,%edx
 99b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 99e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a1:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9a6:	f7 e2                	mul    %edx
 9a8:	89 d0                	mov    %edx,%eax
 9aa:	c1 e8 03             	shr    $0x3,%eax
 9ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 9b0:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 9b4:	7f 13                	jg     9c9 <itoa+0x7a>
      *tp++ = i+'0';
 9b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b9:	8d 50 01             	lea    0x1(%eax),%edx
 9bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9c2:	83 c2 30             	add    $0x30,%edx
 9c5:	88 10                	mov    %dl,(%eax)
 9c7:	eb 11                	jmp    9da <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 9c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cc:	8d 50 01             	lea    0x1(%eax),%edx
 9cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9d5:	83 c2 57             	add    $0x57,%edx
 9d8:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 9da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9de:	75 9f                	jne    97f <itoa+0x30>
 9e0:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9e3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9e6:	74 97                	je     97f <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 9e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9eb:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9ee:	29 c2                	sub    %eax,%edx
 9f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9f3:	01 d0                	add    %edx,%eax
 9f5:	83 c0 01             	add    $0x1,%eax
 9f8:	83 ec 0c             	sub    $0xc,%esp
 9fb:	50                   	push   %eax
 9fc:	e8 d9 fc ff ff       	call   6da <malloc>
 a01:	83 c4 10             	add    $0x10,%esp
 a04:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a07:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a0a:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a0d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a11:	74 0c                	je     a1f <itoa+0xd0>
    *sp++ = '-';
 a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a16:	8d 50 01             	lea    0x1(%eax),%edx
 a19:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a1c:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a1f:	eb 15                	jmp    a36 <itoa+0xe7>
    *sp++ = *--tp;
 a21:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a24:	8d 50 01             	lea    0x1(%eax),%edx
 a27:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a2a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a31:	0f b6 12             	movzbl (%edx),%edx
 a34:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 a36:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a39:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a3c:	77 e3                	ja     a21 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a41:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 a47:	c9                   	leave  
 a48:	c3                   	ret    

00000a49 <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 a49:	55                   	push   %ebp
 a4a:	89 e5                	mov    %esp,%ebp
 a4c:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 a52:	83 ec 08             	sub    $0x8,%esp
 a55:	6a 00                	push   $0x0
 a57:	ff 75 08             	pushl  0x8(%ebp)
 a5a:	e8 55 f8 ff ff       	call   2b4 <open>
 a5f:	83 c4 10             	add    $0x10,%esp
 a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 a65:	e9 22 01 00 00       	jmp    b8c <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 a6a:	83 ec 08             	sub    $0x8,%esp
 a6d:	6a 3d                	push   $0x3d
 a6f:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 a75:	50                   	push   %eax
 a76:	e8 79 f6 ff ff       	call   f4 <strchr>
 a7b:	83 c4 10             	add    $0x10,%esp
 a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 a81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a85:	0f 84 23 01 00 00    	je     bae <parseEnvFile+0x165>
 a8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a8f:	0f 84 19 01 00 00    	je     bae <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 a95:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a98:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 a9e:	29 c2                	sub    %eax,%edx
 aa0:	89 d0                	mov    %edx,%eax
 aa2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa8:	83 c0 01             	add    $0x1,%eax
 aab:	83 ec 0c             	sub    $0xc,%esp
 aae:	50                   	push   %eax
 aaf:	e8 26 fc ff ff       	call   6da <malloc>
 ab4:	83 c4 10             	add    $0x10,%esp
 ab7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 aba:	83 ec 04             	sub    $0x4,%esp
 abd:	ff 75 ec             	pushl  -0x14(%ebp)
 ac0:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ac6:	50                   	push   %eax
 ac7:	ff 75 e8             	pushl  -0x18(%ebp)
 aca:	e8 8f fd ff ff       	call   85e <strncpy>
 acf:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 ad2:	83 ec 0c             	sub    $0xc,%esp
 ad5:	ff 75 e8             	pushl  -0x18(%ebp)
 ad8:	e8 c5 fd ff ff       	call   8a2 <trim>
 add:	83 c4 10             	add    $0x10,%esp
 ae0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 ae3:	83 ec 0c             	sub    $0xc,%esp
 ae6:	ff 75 e8             	pushl  -0x18(%ebp)
 ae9:	e8 ab fa ff ff       	call   599 <free>
 aee:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 af1:	83 ec 08             	sub    $0x8,%esp
 af4:	ff 75 0c             	pushl  0xc(%ebp)
 af7:	ff 75 e4             	pushl  -0x1c(%ebp)
 afa:	e8 c2 01 00 00       	call   cc1 <addToEnvironment>
 aff:	83 c4 10             	add    $0x10,%esp
 b02:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b05:	83 ec 0c             	sub    $0xc,%esp
 b08:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b0e:	50                   	push   %eax
 b0f:	e8 9f f5 ff ff       	call   b3 <strlen>
 b14:	83 c4 10             	add    $0x10,%esp
 b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b1d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b20:	83 ec 0c             	sub    $0xc,%esp
 b23:	50                   	push   %eax
 b24:	e8 b1 fb ff ff       	call   6da <malloc>
 b29:	83 c4 10             	add    $0x10,%esp
 b2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b32:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b35:	8d 50 ff             	lea    -0x1(%eax),%edx
 b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b3b:	8d 48 01             	lea    0x1(%eax),%ecx
 b3e:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b44:	01 c8                	add    %ecx,%eax
 b46:	83 ec 04             	sub    $0x4,%esp
 b49:	52                   	push   %edx
 b4a:	50                   	push   %eax
 b4b:	ff 75 e8             	pushl  -0x18(%ebp)
 b4e:	e8 0b fd ff ff       	call   85e <strncpy>
 b53:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 b56:	83 ec 0c             	sub    $0xc,%esp
 b59:	ff 75 e8             	pushl  -0x18(%ebp)
 b5c:	e8 41 fd ff ff       	call   8a2 <trim>
 b61:	83 c4 10             	add    $0x10,%esp
 b64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 b67:	83 ec 0c             	sub    $0xc,%esp
 b6a:	ff 75 e8             	pushl  -0x18(%ebp)
 b6d:	e8 27 fa ff ff       	call   599 <free>
 b72:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 b75:	83 ec 04             	sub    $0x4,%esp
 b78:	ff 75 dc             	pushl  -0x24(%ebp)
 b7b:	ff 75 0c             	pushl  0xc(%ebp)
 b7e:	ff 75 e4             	pushl  -0x1c(%ebp)
 b81:	e8 b8 01 00 00       	call   d3e <addValueToVariable>
 b86:	83 c4 10             	add    $0x10,%esp
 b89:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 b8c:	83 ec 04             	sub    $0x4,%esp
 b8f:	ff 75 f4             	pushl  -0xc(%ebp)
 b92:	68 00 04 00 00       	push   $0x400
 b97:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b9d:	50                   	push   %eax
 b9e:	e8 4c fc ff ff       	call   7ef <readln>
 ba3:	83 c4 10             	add    $0x10,%esp
 ba6:	85 c0                	test   %eax,%eax
 ba8:	0f 85 bc fe ff ff    	jne    a6a <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 bae:	83 ec 0c             	sub    $0xc,%esp
 bb1:	ff 75 f4             	pushl  -0xc(%ebp)
 bb4:	e8 e3 f6 ff ff       	call   29c <close>
 bb9:	83 c4 10             	add    $0x10,%esp
	return head;
 bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 bbf:	c9                   	leave  
 bc0:	c3                   	ret    

00000bc1 <comp>:

int comp(const char* s1, const char* s2)
{
 bc1:	55                   	push   %ebp
 bc2:	89 e5                	mov    %esp,%ebp
 bc4:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 bc7:	83 ec 08             	sub    $0x8,%esp
 bca:	ff 75 0c             	pushl  0xc(%ebp)
 bcd:	ff 75 08             	pushl  0x8(%ebp)
 bd0:	e8 9f f4 ff ff       	call   74 <strcmp>
 bd5:	83 c4 10             	add    $0x10,%esp
 bd8:	85 c0                	test   %eax,%eax
 bda:	0f 94 c0             	sete   %al
 bdd:	0f b6 c0             	movzbl %al,%eax
}
 be0:	c9                   	leave  
 be1:	c3                   	ret    

00000be2 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 be2:	55                   	push   %ebp
 be3:	89 e5                	mov    %esp,%ebp
 be5:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 be8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 bec:	75 07                	jne    bf5 <environLookup+0x13>
    return NULL;
 bee:	b8 00 00 00 00       	mov    $0x0,%eax
 bf3:	eb 2f                	jmp    c24 <environLookup+0x42>
  
  while (head)
 bf5:	eb 24                	jmp    c1b <environLookup+0x39>
  {
    if (comp(name, head->name))
 bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
 bfa:	83 ec 08             	sub    $0x8,%esp
 bfd:	50                   	push   %eax
 bfe:	ff 75 08             	pushl  0x8(%ebp)
 c01:	e8 bb ff ff ff       	call   bc1 <comp>
 c06:	83 c4 10             	add    $0x10,%esp
 c09:	85 c0                	test   %eax,%eax
 c0b:	74 02                	je     c0f <environLookup+0x2d>
      break;
 c0d:	eb 12                	jmp    c21 <environLookup+0x3f>
    head = head->next;
 c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
 c12:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c18:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c1f:	75 d6                	jne    bf7 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c21:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c24:	c9                   	leave  
 c25:	c3                   	ret    

00000c26 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c26:	55                   	push   %ebp
 c27:	89 e5                	mov    %esp,%ebp
 c29:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c30:	75 0a                	jne    c3c <removeFromEnvironment+0x16>
    return NULL;
 c32:	b8 00 00 00 00       	mov    $0x0,%eax
 c37:	e9 83 00 00 00       	jmp    cbf <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c40:	74 0a                	je     c4c <removeFromEnvironment+0x26>
 c42:	8b 45 08             	mov    0x8(%ebp),%eax
 c45:	0f b6 00             	movzbl (%eax),%eax
 c48:	84 c0                	test   %al,%al
 c4a:	75 05                	jne    c51 <removeFromEnvironment+0x2b>
    return head;
 c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
 c4f:	eb 6e                	jmp    cbf <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 c51:	8b 45 0c             	mov    0xc(%ebp),%eax
 c54:	83 ec 08             	sub    $0x8,%esp
 c57:	ff 75 08             	pushl  0x8(%ebp)
 c5a:	50                   	push   %eax
 c5b:	e8 61 ff ff ff       	call   bc1 <comp>
 c60:	83 c4 10             	add    $0x10,%esp
 c63:	85 c0                	test   %eax,%eax
 c65:	74 34                	je     c9b <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 c67:	8b 45 0c             	mov    0xc(%ebp),%eax
 c6a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 c73:	8b 45 0c             	mov    0xc(%ebp),%eax
 c76:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 c7c:	83 ec 0c             	sub    $0xc,%esp
 c7f:	50                   	push   %eax
 c80:	e8 74 01 00 00       	call   df9 <freeVarval>
 c85:	83 c4 10             	add    $0x10,%esp
    free(head);
 c88:	83 ec 0c             	sub    $0xc,%esp
 c8b:	ff 75 0c             	pushl  0xc(%ebp)
 c8e:	e8 06 f9 ff ff       	call   599 <free>
 c93:	83 c4 10             	add    $0x10,%esp
    return tmp;
 c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c99:	eb 24                	jmp    cbf <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
 c9e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 ca4:	83 ec 08             	sub    $0x8,%esp
 ca7:	50                   	push   %eax
 ca8:	ff 75 08             	pushl  0x8(%ebp)
 cab:	e8 76 ff ff ff       	call   c26 <removeFromEnvironment>
 cb0:	83 c4 10             	add    $0x10,%esp
 cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
 cb6:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 cbf:	c9                   	leave  
 cc0:	c3                   	ret    

00000cc1 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 cc1:	55                   	push   %ebp
 cc2:	89 e5                	mov    %esp,%ebp
 cc4:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 cc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 ccb:	75 05                	jne    cd2 <addToEnvironment+0x11>
		return head;
 ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
 cd0:	eb 6a                	jmp    d3c <addToEnvironment+0x7b>
	if (head == NULL) {
 cd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 cd6:	75 40                	jne    d18 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 cd8:	83 ec 0c             	sub    $0xc,%esp
 cdb:	68 88 00 00 00       	push   $0x88
 ce0:	e8 f5 f9 ff ff       	call   6da <malloc>
 ce5:	83 c4 10             	add    $0x10,%esp
 ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 ceb:	8b 45 08             	mov    0x8(%ebp),%eax
 cee:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cf4:	83 ec 08             	sub    $0x8,%esp
 cf7:	ff 75 f0             	pushl  -0x10(%ebp)
 cfa:	50                   	push   %eax
 cfb:	e8 44 f3 ff ff       	call   44 <strcpy>
 d00:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d06:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d0d:	00 00 00 
		head = newVar;
 d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d13:	89 45 0c             	mov    %eax,0xc(%ebp)
 d16:	eb 21                	jmp    d39 <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d18:	8b 45 0c             	mov    0xc(%ebp),%eax
 d1b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d21:	83 ec 08             	sub    $0x8,%esp
 d24:	50                   	push   %eax
 d25:	ff 75 08             	pushl  0x8(%ebp)
 d28:	e8 94 ff ff ff       	call   cc1 <addToEnvironment>
 d2d:	83 c4 10             	add    $0x10,%esp
 d30:	8b 55 0c             	mov    0xc(%ebp),%edx
 d33:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 d39:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d3c:	c9                   	leave  
 d3d:	c3                   	ret    

00000d3e <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 d3e:	55                   	push   %ebp
 d3f:	89 e5                	mov    %esp,%ebp
 d41:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 d44:	83 ec 08             	sub    $0x8,%esp
 d47:	ff 75 0c             	pushl  0xc(%ebp)
 d4a:	ff 75 08             	pushl  0x8(%ebp)
 d4d:	e8 90 fe ff ff       	call   be2 <environLookup>
 d52:	83 c4 10             	add    $0x10,%esp
 d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 d58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d5c:	75 05                	jne    d63 <addValueToVariable+0x25>
		return head;
 d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
 d61:	eb 4c                	jmp    daf <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 d63:	83 ec 0c             	sub    $0xc,%esp
 d66:	68 04 04 00 00       	push   $0x404
 d6b:	e8 6a f9 ff ff       	call   6da <malloc>
 d70:	83 c4 10             	add    $0x10,%esp
 d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 d76:	8b 45 10             	mov    0x10(%ebp),%eax
 d79:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d7f:	83 ec 08             	sub    $0x8,%esp
 d82:	ff 75 ec             	pushl  -0x14(%ebp)
 d85:	50                   	push   %eax
 d86:	e8 b9 f2 ff ff       	call   44 <strcpy>
 d8b:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d91:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d9a:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da3:	8b 55 f0             	mov    -0x10(%ebp),%edx
 da6:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 dac:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 daf:	c9                   	leave  
 db0:	c3                   	ret    

00000db1 <freeEnvironment>:

void freeEnvironment(variable* head)
{
 db1:	55                   	push   %ebp
 db2:	89 e5                	mov    %esp,%ebp
 db4:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 db7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 dbb:	75 02                	jne    dbf <freeEnvironment+0xe>
    return;  
 dbd:	eb 38                	jmp    df7 <freeEnvironment+0x46>
  freeEnvironment(head->next);
 dbf:	8b 45 08             	mov    0x8(%ebp),%eax
 dc2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 dc8:	83 ec 0c             	sub    $0xc,%esp
 dcb:	50                   	push   %eax
 dcc:	e8 e0 ff ff ff       	call   db1 <freeEnvironment>
 dd1:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 dd4:	8b 45 08             	mov    0x8(%ebp),%eax
 dd7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 ddd:	83 ec 0c             	sub    $0xc,%esp
 de0:	50                   	push   %eax
 de1:	e8 13 00 00 00       	call   df9 <freeVarval>
 de6:	83 c4 10             	add    $0x10,%esp
  free(head);
 de9:	83 ec 0c             	sub    $0xc,%esp
 dec:	ff 75 08             	pushl  0x8(%ebp)
 def:	e8 a5 f7 ff ff       	call   599 <free>
 df4:	83 c4 10             	add    $0x10,%esp
}
 df7:	c9                   	leave  
 df8:	c3                   	ret    

00000df9 <freeVarval>:

void freeVarval(varval* head)
{
 df9:	55                   	push   %ebp
 dfa:	89 e5                	mov    %esp,%ebp
 dfc:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 dff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e03:	75 02                	jne    e07 <freeVarval+0xe>
    return;  
 e05:	eb 23                	jmp    e2a <freeVarval+0x31>
  freeVarval(head->next);
 e07:	8b 45 08             	mov    0x8(%ebp),%eax
 e0a:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e10:	83 ec 0c             	sub    $0xc,%esp
 e13:	50                   	push   %eax
 e14:	e8 e0 ff ff ff       	call   df9 <freeVarval>
 e19:	83 c4 10             	add    $0x10,%esp
  free(head);
 e1c:	83 ec 0c             	sub    $0xc,%esp
 e1f:	ff 75 08             	pushl  0x8(%ebp)
 e22:	e8 72 f7 ff ff       	call   599 <free>
 e27:	83 c4 10             	add    $0x10,%esp
}
 e2a:	c9                   	leave  
 e2b:	c3                   	ret    

00000e2c <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e2c:	55                   	push   %ebp
 e2d:	89 e5                	mov    %esp,%ebp
 e2f:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 e32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e36:	75 08                	jne    e40 <getPaths+0x14>
		return head;
 e38:	8b 45 0c             	mov    0xc(%ebp),%eax
 e3b:	e9 e7 00 00 00       	jmp    f27 <getPaths+0xfb>
	if (head == NULL) {
 e40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 e44:	0f 85 b9 00 00 00    	jne    f03 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 e4a:	83 ec 08             	sub    $0x8,%esp
 e4d:	6a 3a                	push   $0x3a
 e4f:	ff 75 08             	pushl  0x8(%ebp)
 e52:	e8 9d f2 ff ff       	call   f4 <strchr>
 e57:	83 c4 10             	add    $0x10,%esp
 e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 e5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e61:	75 56                	jne    eb9 <getPaths+0x8d>
			pathLen = strlen(paths);
 e63:	83 ec 0c             	sub    $0xc,%esp
 e66:	ff 75 08             	pushl  0x8(%ebp)
 e69:	e8 45 f2 ff ff       	call   b3 <strlen>
 e6e:	83 c4 10             	add    $0x10,%esp
 e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 e74:	83 ec 0c             	sub    $0xc,%esp
 e77:	68 04 04 00 00       	push   $0x404
 e7c:	e8 59 f8 ff ff       	call   6da <malloc>
 e81:	83 c4 10             	add    $0x10,%esp
 e84:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 e87:	8b 45 0c             	mov    0xc(%ebp),%eax
 e8a:	83 ec 04             	sub    $0x4,%esp
 e8d:	ff 75 f0             	pushl  -0x10(%ebp)
 e90:	ff 75 08             	pushl  0x8(%ebp)
 e93:	50                   	push   %eax
 e94:	e8 c5 f9 ff ff       	call   85e <strncpy>
 e99:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
 e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ea2:	01 d0                	add    %edx,%eax
 ea4:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
 eaa:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 eb1:	00 00 00 
			return head;
 eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
 eb7:	eb 6e                	jmp    f27 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ebc:	8b 45 08             	mov    0x8(%ebp),%eax
 ebf:	29 c2                	sub    %eax,%edx
 ec1:	89 d0                	mov    %edx,%eax
 ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 ec6:	83 ec 0c             	sub    $0xc,%esp
 ec9:	68 04 04 00 00       	push   $0x404
 ece:	e8 07 f8 ff ff       	call   6da <malloc>
 ed3:	83 c4 10             	add    $0x10,%esp
 ed6:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
 edc:	83 ec 04             	sub    $0x4,%esp
 edf:	ff 75 f0             	pushl  -0x10(%ebp)
 ee2:	ff 75 08             	pushl  0x8(%ebp)
 ee5:	50                   	push   %eax
 ee6:	e8 73 f9 ff ff       	call   85e <strncpy>
 eeb:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 eee:	8b 55 0c             	mov    0xc(%ebp),%edx
 ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ef4:	01 d0                	add    %edx,%eax
 ef6:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 efc:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 eff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f03:	8b 45 0c             	mov    0xc(%ebp),%eax
 f06:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f0c:	83 ec 08             	sub    $0x8,%esp
 f0f:	50                   	push   %eax
 f10:	ff 75 08             	pushl  0x8(%ebp)
 f13:	e8 14 ff ff ff       	call   e2c <getPaths>
 f18:	83 c4 10             	add    $0x10,%esp
 f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
 f1e:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f24:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f27:	c9                   	leave  
 f28:	c3                   	ret    
