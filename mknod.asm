
_mknod:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	89 cb                	mov    %ecx,%ebx
  if(argc != 4){
  15:	83 3b 04             	cmpl   $0x4,(%ebx)
  18:	74 17                	je     31 <main+0x31>
    printf(2, "mknod: usage: mknod file minor major\n");
  1a:	83 ec 08             	sub    $0x8,%esp
  1d:	68 a8 0f 00 00       	push   $0xfa8
  22:	6a 02                	push   $0x2
  24:	e8 5f 04 00 00       	call   488 <printf>
  29:	83 c4 10             	add    $0x10,%esp
    exit();
  2c:	e8 c2 02 00 00       	call   2f3 <exit>
  }

 if(mknod(argv[1], atoi(argv[2]), atoi(argv[3])) < 0) {
  31:	8b 43 04             	mov    0x4(%ebx),%eax
  34:	83 c0 0c             	add    $0xc,%eax
  37:	8b 00                	mov    (%eax),%eax
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	50                   	push   %eax
  3d:	e8 1f 02 00 00       	call   261 <atoi>
  42:	83 c4 10             	add    $0x10,%esp
  45:	0f bf f0             	movswl %ax,%esi
  48:	8b 43 04             	mov    0x4(%ebx),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 00                	mov    (%eax),%eax
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	50                   	push   %eax
  54:	e8 08 02 00 00       	call   261 <atoi>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	0f bf d0             	movswl %ax,%edx
  5f:	8b 43 04             	mov    0x4(%ebx),%eax
  62:	83 c0 04             	add    $0x4,%eax
  65:	8b 00                	mov    (%eax),%eax
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	56                   	push   %esi
  6b:	52                   	push   %edx
  6c:	50                   	push   %eax
  6d:	e8 c9 02 00 00       	call   33b <mknod>
  72:	83 c4 10             	add    $0x10,%esp
  75:	85 c0                	test   %eax,%eax
  77:	79 20                	jns    99 <main+0x99>
   printf(2, "mknod: unable to create device file %s\n",argv[1]);
  79:	8b 43 04             	mov    0x4(%ebx),%eax
  7c:	83 c0 04             	add    $0x4,%eax
  7f:	8b 00                	mov    (%eax),%eax
  81:	83 ec 04             	sub    $0x4,%esp
  84:	50                   	push   %eax
  85:	68 d0 0f 00 00       	push   $0xfd0
  8a:	6a 02                	push   $0x2
  8c:	e8 f7 03 00 00       	call   488 <printf>
  91:	83 c4 10             	add    $0x10,%esp
   exit();
  94:	e8 5a 02 00 00       	call   2f3 <exit>
 }
  exit();
  99:	e8 55 02 00 00       	call   2f3 <exit>

0000009e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	57                   	push   %edi
  a2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a6:	8b 55 10             	mov    0x10(%ebp),%edx
  a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  ac:	89 cb                	mov    %ecx,%ebx
  ae:	89 df                	mov    %ebx,%edi
  b0:	89 d1                	mov    %edx,%ecx
  b2:	fc                   	cld    
  b3:	f3 aa                	rep stos %al,%es:(%edi)
  b5:	89 ca                	mov    %ecx,%edx
  b7:	89 fb                	mov    %edi,%ebx
  b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
  bc:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  bf:	5b                   	pop    %ebx
  c0:	5f                   	pop    %edi
  c1:	5d                   	pop    %ebp
  c2:	c3                   	ret    

000000c3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  c3:	55                   	push   %ebp
  c4:	89 e5                	mov    %esp,%ebp
  c6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  cf:	90                   	nop
  d0:	8b 45 08             	mov    0x8(%ebp),%eax
  d3:	8d 50 01             	lea    0x1(%eax),%edx
  d6:	89 55 08             	mov    %edx,0x8(%ebp)
  d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  dc:	8d 4a 01             	lea    0x1(%edx),%ecx
  df:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  e2:	0f b6 12             	movzbl (%edx),%edx
  e5:	88 10                	mov    %dl,(%eax)
  e7:	0f b6 00             	movzbl (%eax),%eax
  ea:	84 c0                	test   %al,%al
  ec:	75 e2                	jne    d0 <strcpy+0xd>
    ;
  return os;
  ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f1:	c9                   	leave  
  f2:	c3                   	ret    

000000f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f3:	55                   	push   %ebp
  f4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f6:	eb 08                	jmp    100 <strcmp+0xd>
    p++, q++;
  f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  fc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 00             	movzbl (%eax),%eax
 106:	84 c0                	test   %al,%al
 108:	74 10                	je     11a <strcmp+0x27>
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	0f b6 10             	movzbl (%eax),%edx
 110:	8b 45 0c             	mov    0xc(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	38 c2                	cmp    %al,%dl
 118:	74 de                	je     f8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	0f b6 00             	movzbl (%eax),%eax
 120:	0f b6 d0             	movzbl %al,%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	0f b6 c0             	movzbl %al,%eax
 12c:	29 c2                	sub    %eax,%edx
 12e:	89 d0                	mov    %edx,%eax
}
 130:	5d                   	pop    %ebp
 131:	c3                   	ret    

00000132 <strlen>:

uint
strlen(char *s)
{
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 138:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 13f:	eb 04                	jmp    145 <strlen+0x13>
 141:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 145:	8b 55 fc             	mov    -0x4(%ebp),%edx
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	01 d0                	add    %edx,%eax
 14d:	0f b6 00             	movzbl (%eax),%eax
 150:	84 c0                	test   %al,%al
 152:	75 ed                	jne    141 <strlen+0xf>
    ;
  return n;
 154:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <memset>:

void*
memset(void *dst, int c, uint n)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 15c:	8b 45 10             	mov    0x10(%ebp),%eax
 15f:	50                   	push   %eax
 160:	ff 75 0c             	pushl  0xc(%ebp)
 163:	ff 75 08             	pushl  0x8(%ebp)
 166:	e8 33 ff ff ff       	call   9e <stosb>
 16b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 171:	c9                   	leave  
 172:	c3                   	ret    

00000173 <strchr>:

char*
strchr(const char *s, char c)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
 176:	83 ec 04             	sub    $0x4,%esp
 179:	8b 45 0c             	mov    0xc(%ebp),%eax
 17c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 17f:	eb 14                	jmp    195 <strchr+0x22>
    if(*s == c)
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	3a 45 fc             	cmp    -0x4(%ebp),%al
 18a:	75 05                	jne    191 <strchr+0x1e>
      return (char*)s;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	eb 13                	jmp    1a4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 191:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	84 c0                	test   %al,%al
 19d:	75 e2                	jne    181 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 19f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <gets>:

char*
gets(char *buf, int max)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1b3:	eb 44                	jmp    1f9 <gets+0x53>
    cc = read(0, &c, 1);
 1b5:	83 ec 04             	sub    $0x4,%esp
 1b8:	6a 01                	push   $0x1
 1ba:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1bd:	50                   	push   %eax
 1be:	6a 00                	push   $0x0
 1c0:	e8 46 01 00 00       	call   30b <read>
 1c5:	83 c4 10             	add    $0x10,%esp
 1c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1cf:	7f 02                	jg     1d3 <gets+0x2d>
      break;
 1d1:	eb 31                	jmp    204 <gets+0x5e>
    buf[i++] = c;
 1d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d6:	8d 50 01             	lea    0x1(%eax),%edx
 1d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1dc:	89 c2                	mov    %eax,%edx
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	01 c2                	add    %eax,%edx
 1e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ed:	3c 0a                	cmp    $0xa,%al
 1ef:	74 13                	je     204 <gets+0x5e>
 1f1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f5:	3c 0d                	cmp    $0xd,%al
 1f7:	74 0b                	je     204 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fc:	83 c0 01             	add    $0x1,%eax
 1ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
 202:	7c b1                	jl     1b5 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 204:	8b 55 f4             	mov    -0xc(%ebp),%edx
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	01 d0                	add    %edx,%eax
 20c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 212:	c9                   	leave  
 213:	c3                   	ret    

00000214 <stat>:

int
stat(char *n, struct stat *st)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21a:	83 ec 08             	sub    $0x8,%esp
 21d:	6a 00                	push   $0x0
 21f:	ff 75 08             	pushl  0x8(%ebp)
 222:	e8 0c 01 00 00       	call   333 <open>
 227:	83 c4 10             	add    $0x10,%esp
 22a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 22d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 231:	79 07                	jns    23a <stat+0x26>
    return -1;
 233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 238:	eb 25                	jmp    25f <stat+0x4b>
  r = fstat(fd, st);
 23a:	83 ec 08             	sub    $0x8,%esp
 23d:	ff 75 0c             	pushl  0xc(%ebp)
 240:	ff 75 f4             	pushl  -0xc(%ebp)
 243:	e8 03 01 00 00       	call   34b <fstat>
 248:	83 c4 10             	add    $0x10,%esp
 24b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 24e:	83 ec 0c             	sub    $0xc,%esp
 251:	ff 75 f4             	pushl  -0xc(%ebp)
 254:	e8 c2 00 00 00       	call   31b <close>
 259:	83 c4 10             	add    $0x10,%esp
  return r;
 25c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 25f:	c9                   	leave  
 260:	c3                   	ret    

00000261 <atoi>:

int
atoi(const char *s)
{
 261:	55                   	push   %ebp
 262:	89 e5                	mov    %esp,%ebp
 264:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26e:	eb 25                	jmp    295 <atoi+0x34>
    n = n*10 + *s++ - '0';
 270:	8b 55 fc             	mov    -0x4(%ebp),%edx
 273:	89 d0                	mov    %edx,%eax
 275:	c1 e0 02             	shl    $0x2,%eax
 278:	01 d0                	add    %edx,%eax
 27a:	01 c0                	add    %eax,%eax
 27c:	89 c1                	mov    %eax,%ecx
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	8d 50 01             	lea    0x1(%eax),%edx
 284:	89 55 08             	mov    %edx,0x8(%ebp)
 287:	0f b6 00             	movzbl (%eax),%eax
 28a:	0f be c0             	movsbl %al,%eax
 28d:	01 c8                	add    %ecx,%eax
 28f:	83 e8 30             	sub    $0x30,%eax
 292:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	0f b6 00             	movzbl (%eax),%eax
 29b:	3c 2f                	cmp    $0x2f,%al
 29d:	7e 0a                	jle    2a9 <atoi+0x48>
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	3c 39                	cmp    $0x39,%al
 2a7:	7e c7                	jle    270 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ac:	c9                   	leave  
 2ad:	c3                   	ret    

000002ae <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c0:	eb 17                	jmp    2d9 <memmove+0x2b>
    *dst++ = *src++;
 2c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c5:	8d 50 01             	lea    0x1(%eax),%edx
 2c8:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2cb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2ce:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d4:	0f b6 12             	movzbl (%edx),%edx
 2d7:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d9:	8b 45 10             	mov    0x10(%ebp),%eax
 2dc:	8d 50 ff             	lea    -0x1(%eax),%edx
 2df:	89 55 10             	mov    %edx,0x10(%ebp)
 2e2:	85 c0                	test   %eax,%eax
 2e4:	7f dc                	jg     2c2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2eb:	b8 01 00 00 00       	mov    $0x1,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exit>:
SYSCALL(exit)
 2f3:	b8 02 00 00 00       	mov    $0x2,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <wait>:
SYSCALL(wait)
 2fb:	b8 03 00 00 00       	mov    $0x3,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <pipe>:
SYSCALL(pipe)
 303:	b8 04 00 00 00       	mov    $0x4,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <read>:
SYSCALL(read)
 30b:	b8 05 00 00 00       	mov    $0x5,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <write>:
SYSCALL(write)
 313:	b8 10 00 00 00       	mov    $0x10,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <close>:
SYSCALL(close)
 31b:	b8 15 00 00 00       	mov    $0x15,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <kill>:
SYSCALL(kill)
 323:	b8 06 00 00 00       	mov    $0x6,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <exec>:
SYSCALL(exec)
 32b:	b8 07 00 00 00       	mov    $0x7,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <open>:
SYSCALL(open)
 333:	b8 0f 00 00 00       	mov    $0xf,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mknod>:
SYSCALL(mknod)
 33b:	b8 11 00 00 00       	mov    $0x11,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <unlink>:
SYSCALL(unlink)
 343:	b8 12 00 00 00       	mov    $0x12,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <fstat>:
SYSCALL(fstat)
 34b:	b8 08 00 00 00       	mov    $0x8,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <link>:
SYSCALL(link)
 353:	b8 13 00 00 00       	mov    $0x13,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <mkdir>:
SYSCALL(mkdir)
 35b:	b8 14 00 00 00       	mov    $0x14,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <chdir>:
SYSCALL(chdir)
 363:	b8 09 00 00 00       	mov    $0x9,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <dup>:
SYSCALL(dup)
 36b:	b8 0a 00 00 00       	mov    $0xa,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getpid>:
SYSCALL(getpid)
 373:	b8 0b 00 00 00       	mov    $0xb,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <sbrk>:
SYSCALL(sbrk)
 37b:	b8 0c 00 00 00       	mov    $0xc,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <sleep>:
SYSCALL(sleep)
 383:	b8 0d 00 00 00       	mov    $0xd,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <uptime>:
SYSCALL(uptime)
 38b:	b8 0e 00 00 00       	mov    $0xe,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <getcwd>:
SYSCALL(getcwd)
 393:	b8 16 00 00 00       	mov    $0x16,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <shutdown>:
SYSCALL(shutdown)
 39b:	b8 17 00 00 00       	mov    $0x17,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <buildinfo>:
SYSCALL(buildinfo)
 3a3:	b8 18 00 00 00       	mov    $0x18,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <lseek>:
SYSCALL(lseek)
 3ab:	b8 19 00 00 00       	mov    $0x19,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp
 3b6:	83 ec 18             	sub    $0x18,%esp
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3bf:	83 ec 04             	sub    $0x4,%esp
 3c2:	6a 01                	push   $0x1
 3c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c7:	50                   	push   %eax
 3c8:	ff 75 08             	pushl  0x8(%ebp)
 3cb:	e8 43 ff ff ff       	call   313 <write>
 3d0:	83 c4 10             	add    $0x10,%esp
}
 3d3:	c9                   	leave  
 3d4:	c3                   	ret    

000003d5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d5:	55                   	push   %ebp
 3d6:	89 e5                	mov    %esp,%ebp
 3d8:	53                   	push   %ebx
 3d9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e7:	74 17                	je     400 <printint+0x2b>
 3e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ed:	79 11                	jns    400 <printint+0x2b>
    neg = 1;
 3ef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f9:	f7 d8                	neg    %eax
 3fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fe:	eb 06                	jmp    406 <printint+0x31>
  } else {
    x = xx;
 400:	8b 45 0c             	mov    0xc(%ebp),%eax
 403:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 40d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 410:	8d 41 01             	lea    0x1(%ecx),%eax
 413:	89 45 f4             	mov    %eax,-0xc(%ebp)
 416:	8b 5d 10             	mov    0x10(%ebp),%ebx
 419:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41c:	ba 00 00 00 00       	mov    $0x0,%edx
 421:	f7 f3                	div    %ebx
 423:	89 d0                	mov    %edx,%eax
 425:	0f b6 80 10 14 00 00 	movzbl 0x1410(%eax),%eax
 42c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 430:	8b 5d 10             	mov    0x10(%ebp),%ebx
 433:	8b 45 ec             	mov    -0x14(%ebp),%eax
 436:	ba 00 00 00 00       	mov    $0x0,%edx
 43b:	f7 f3                	div    %ebx
 43d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 440:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 444:	75 c7                	jne    40d <printint+0x38>
  if(neg)
 446:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44a:	74 0e                	je     45a <printint+0x85>
    buf[i++] = '-';
 44c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44f:	8d 50 01             	lea    0x1(%eax),%edx
 452:	89 55 f4             	mov    %edx,-0xc(%ebp)
 455:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 45a:	eb 1d                	jmp    479 <printint+0xa4>
    putc(fd, buf[i]);
 45c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	01 d0                	add    %edx,%eax
 464:	0f b6 00             	movzbl (%eax),%eax
 467:	0f be c0             	movsbl %al,%eax
 46a:	83 ec 08             	sub    $0x8,%esp
 46d:	50                   	push   %eax
 46e:	ff 75 08             	pushl  0x8(%ebp)
 471:	e8 3d ff ff ff       	call   3b3 <putc>
 476:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 479:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 481:	79 d9                	jns    45c <printint+0x87>
    putc(fd, buf[i]);
}
 483:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 486:	c9                   	leave  
 487:	c3                   	ret    

00000488 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 488:	55                   	push   %ebp
 489:	89 e5                	mov    %esp,%ebp
 48b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 495:	8d 45 0c             	lea    0xc(%ebp),%eax
 498:	83 c0 04             	add    $0x4,%eax
 49b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a5:	e9 59 01 00 00       	jmp    603 <printf+0x17b>
    c = fmt[i] & 0xff;
 4aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b0:	01 d0                	add    %edx,%eax
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	25 ff 00 00 00       	and    $0xff,%eax
 4bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c4:	75 2c                	jne    4f2 <printf+0x6a>
      if(c == '%'){
 4c6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ca:	75 0c                	jne    4d8 <printf+0x50>
        state = '%';
 4cc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d3:	e9 27 01 00 00       	jmp    5ff <printf+0x177>
      } else {
        putc(fd, c);
 4d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4db:	0f be c0             	movsbl %al,%eax
 4de:	83 ec 08             	sub    $0x8,%esp
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 c9 fe ff ff       	call   3b3 <putc>
 4ea:	83 c4 10             	add    $0x10,%esp
 4ed:	e9 0d 01 00 00       	jmp    5ff <printf+0x177>
      }
    } else if(state == '%'){
 4f2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f6:	0f 85 03 01 00 00    	jne    5ff <printf+0x177>
      if(c == 'd'){
 4fc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 500:	75 1e                	jne    520 <printf+0x98>
        printint(fd, *ap, 10, 1);
 502:	8b 45 e8             	mov    -0x18(%ebp),%eax
 505:	8b 00                	mov    (%eax),%eax
 507:	6a 01                	push   $0x1
 509:	6a 0a                	push   $0xa
 50b:	50                   	push   %eax
 50c:	ff 75 08             	pushl  0x8(%ebp)
 50f:	e8 c1 fe ff ff       	call   3d5 <printint>
 514:	83 c4 10             	add    $0x10,%esp
        ap++;
 517:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51b:	e9 d8 00 00 00       	jmp    5f8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 520:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 524:	74 06                	je     52c <printf+0xa4>
 526:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52a:	75 1e                	jne    54a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 52c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52f:	8b 00                	mov    (%eax),%eax
 531:	6a 00                	push   $0x0
 533:	6a 10                	push   $0x10
 535:	50                   	push   %eax
 536:	ff 75 08             	pushl  0x8(%ebp)
 539:	e8 97 fe ff ff       	call   3d5 <printint>
 53e:	83 c4 10             	add    $0x10,%esp
        ap++;
 541:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 545:	e9 ae 00 00 00       	jmp    5f8 <printf+0x170>
      } else if(c == 's'){
 54a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 54e:	75 43                	jne    593 <printf+0x10b>
        s = (char*)*ap;
 550:	8b 45 e8             	mov    -0x18(%ebp),%eax
 553:	8b 00                	mov    (%eax),%eax
 555:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 558:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 55c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 560:	75 07                	jne    569 <printf+0xe1>
          s = "(null)";
 562:	c7 45 f4 f8 0f 00 00 	movl   $0xff8,-0xc(%ebp)
        while(*s != 0){
 569:	eb 1c                	jmp    587 <printf+0xff>
          putc(fd, *s);
 56b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	0f be c0             	movsbl %al,%eax
 574:	83 ec 08             	sub    $0x8,%esp
 577:	50                   	push   %eax
 578:	ff 75 08             	pushl  0x8(%ebp)
 57b:	e8 33 fe ff ff       	call   3b3 <putc>
 580:	83 c4 10             	add    $0x10,%esp
          s++;
 583:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 587:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	84 c0                	test   %al,%al
 58f:	75 da                	jne    56b <printf+0xe3>
 591:	eb 65                	jmp    5f8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 593:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 597:	75 1d                	jne    5b6 <printf+0x12e>
        putc(fd, *ap);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	83 ec 08             	sub    $0x8,%esp
 5a4:	50                   	push   %eax
 5a5:	ff 75 08             	pushl  0x8(%ebp)
 5a8:	e8 06 fe ff ff       	call   3b3 <putc>
 5ad:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b4:	eb 42                	jmp    5f8 <printf+0x170>
      } else if(c == '%'){
 5b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ba:	75 17                	jne    5d3 <printf+0x14b>
        putc(fd, c);
 5bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bf:	0f be c0             	movsbl %al,%eax
 5c2:	83 ec 08             	sub    $0x8,%esp
 5c5:	50                   	push   %eax
 5c6:	ff 75 08             	pushl  0x8(%ebp)
 5c9:	e8 e5 fd ff ff       	call   3b3 <putc>
 5ce:	83 c4 10             	add    $0x10,%esp
 5d1:	eb 25                	jmp    5f8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d3:	83 ec 08             	sub    $0x8,%esp
 5d6:	6a 25                	push   $0x25
 5d8:	ff 75 08             	pushl  0x8(%ebp)
 5db:	e8 d3 fd ff ff       	call   3b3 <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	83 ec 08             	sub    $0x8,%esp
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 be fd ff ff       	call   3b3 <putc>
 5f5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ff:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 603:	8b 55 0c             	mov    0xc(%ebp),%edx
 606:	8b 45 f0             	mov    -0x10(%ebp),%eax
 609:	01 d0                	add    %edx,%eax
 60b:	0f b6 00             	movzbl (%eax),%eax
 60e:	84 c0                	test   %al,%al
 610:	0f 85 94 fe ff ff    	jne    4aa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 616:	c9                   	leave  
 617:	c3                   	ret    

00000618 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	83 e8 08             	sub    $0x8,%eax
 624:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 627:	a1 2c 14 00 00       	mov    0x142c,%eax
 62c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62f:	eb 24                	jmp    655 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 639:	77 12                	ja     64d <free+0x35>
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 641:	77 24                	ja     667 <free+0x4f>
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64b:	77 1a                	ja     667 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	89 45 fc             	mov    %eax,-0x4(%ebp)
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65b:	76 d4                	jbe    631 <free+0x19>
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 665:	76 ca                	jbe    631 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	01 c2                	add    %eax,%edx
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	39 c2                	cmp    %eax,%edx
 680:	75 24                	jne    6a6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	8b 40 04             	mov    0x4(%eax),%eax
 690:	01 c2                	add    %eax,%edx
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
 6a4:	eb 0a                	jmp    6b0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 10                	mov    (%eax),%edx
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 40 04             	mov    0x4(%eax),%eax
 6b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	01 d0                	add    %edx,%eax
 6c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c5:	75 20                	jne    6e7 <free+0xcf>
    p->s.size += bp->s.size;
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 50 04             	mov    0x4(%eax),%edx
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	8b 40 04             	mov    0x4(%eax),%eax
 6d3:	01 c2                	add    %eax,%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
 6e5:	eb 08                	jmp    6ef <free+0xd7>
  } else
    p->s.ptr = bp;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ed:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	a3 2c 14 00 00       	mov    %eax,0x142c
}
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <morecore>:

static Header*
morecore(uint nu)
{
 6f9:	55                   	push   %ebp
 6fa:	89 e5                	mov    %esp,%ebp
 6fc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ff:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 706:	77 07                	ja     70f <morecore+0x16>
    nu = 4096;
 708:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	c1 e0 03             	shl    $0x3,%eax
 715:	83 ec 0c             	sub    $0xc,%esp
 718:	50                   	push   %eax
 719:	e8 5d fc ff ff       	call   37b <sbrk>
 71e:	83 c4 10             	add    $0x10,%esp
 721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 724:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 728:	75 07                	jne    731 <morecore+0x38>
    return 0;
 72a:	b8 00 00 00 00       	mov    $0x0,%eax
 72f:	eb 26                	jmp    757 <morecore+0x5e>
  hp = (Header*)p;
 731:	8b 45 f4             	mov    -0xc(%ebp),%eax
 734:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 737:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73a:	8b 55 08             	mov    0x8(%ebp),%edx
 73d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 740:	8b 45 f0             	mov    -0x10(%ebp),%eax
 743:	83 c0 08             	add    $0x8,%eax
 746:	83 ec 0c             	sub    $0xc,%esp
 749:	50                   	push   %eax
 74a:	e8 c9 fe ff ff       	call   618 <free>
 74f:	83 c4 10             	add    $0x10,%esp
  return freep;
 752:	a1 2c 14 00 00       	mov    0x142c,%eax
}
 757:	c9                   	leave  
 758:	c3                   	ret    

00000759 <malloc>:

void*
malloc(uint nbytes)
{
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	83 c0 07             	add    $0x7,%eax
 765:	c1 e8 03             	shr    $0x3,%eax
 768:	83 c0 01             	add    $0x1,%eax
 76b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 76e:	a1 2c 14 00 00       	mov    0x142c,%eax
 773:	89 45 f0             	mov    %eax,-0x10(%ebp)
 776:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77a:	75 23                	jne    79f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 77c:	c7 45 f0 24 14 00 00 	movl   $0x1424,-0x10(%ebp)
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	a3 2c 14 00 00       	mov    %eax,0x142c
 78b:	a1 2c 14 00 00       	mov    0x142c,%eax
 790:	a3 24 14 00 00       	mov    %eax,0x1424
    base.s.size = 0;
 795:	c7 05 28 14 00 00 00 	movl   $0x0,0x1428
 79c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b0:	72 4d                	jb     7ff <malloc+0xa6>
      if(p->s.size == nunits)
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bb:	75 0c                	jne    7c9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 10                	mov    (%eax),%edx
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	89 10                	mov    %edx,(%eax)
 7c7:	eb 26                	jmp    7ef <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d2:	89 c2                	mov    %eax,%edx
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8b 40 04             	mov    0x4(%eax),%eax
 7e0:	c1 e0 03             	shl    $0x3,%eax
 7e3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ec:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	a3 2c 14 00 00       	mov    %eax,0x142c
      return (void*)(p + 1);
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	83 c0 08             	add    $0x8,%eax
 7fd:	eb 3b                	jmp    83a <malloc+0xe1>
    }
    if(p == freep)
 7ff:	a1 2c 14 00 00       	mov    0x142c,%eax
 804:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 807:	75 1e                	jne    827 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 809:	83 ec 0c             	sub    $0xc,%esp
 80c:	ff 75 ec             	pushl  -0x14(%ebp)
 80f:	e8 e5 fe ff ff       	call   6f9 <morecore>
 814:	83 c4 10             	add    $0x10,%esp
 817:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81e:	75 07                	jne    827 <malloc+0xce>
        return 0;
 820:	b8 00 00 00 00       	mov    $0x0,%eax
 825:	eb 13                	jmp    83a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 835:	e9 6d ff ff ff       	jmp    7a7 <malloc+0x4e>
}
 83a:	c9                   	leave  
 83b:	c3                   	ret    

0000083c <isspace>:

#include "common.h"

int isspace(char c) {
 83c:	55                   	push   %ebp
 83d:	89 e5                	mov    %esp,%ebp
 83f:	83 ec 04             	sub    $0x4,%esp
 842:	8b 45 08             	mov    0x8(%ebp),%eax
 845:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 848:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 84c:	74 12                	je     860 <isspace+0x24>
 84e:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 852:	74 0c                	je     860 <isspace+0x24>
 854:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 858:	74 06                	je     860 <isspace+0x24>
 85a:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 85e:	75 07                	jne    867 <isspace+0x2b>
 860:	b8 01 00 00 00       	mov    $0x1,%eax
 865:	eb 05                	jmp    86c <isspace+0x30>
 867:	b8 00 00 00 00       	mov    $0x0,%eax
}
 86c:	c9                   	leave  
 86d:	c3                   	ret    

0000086e <readln>:

char* readln(char *buf, int max, int fd)
{
 86e:	55                   	push   %ebp
 86f:	89 e5                	mov    %esp,%ebp
 871:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 874:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 87b:	eb 45                	jmp    8c2 <readln+0x54>
    cc = read(fd, &c, 1);
 87d:	83 ec 04             	sub    $0x4,%esp
 880:	6a 01                	push   $0x1
 882:	8d 45 ef             	lea    -0x11(%ebp),%eax
 885:	50                   	push   %eax
 886:	ff 75 10             	pushl  0x10(%ebp)
 889:	e8 7d fa ff ff       	call   30b <read>
 88e:	83 c4 10             	add    $0x10,%esp
 891:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 894:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 898:	7f 02                	jg     89c <readln+0x2e>
      break;
 89a:	eb 31                	jmp    8cd <readln+0x5f>
    buf[i++] = c;
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	8d 50 01             	lea    0x1(%eax),%edx
 8a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8a5:	89 c2                	mov    %eax,%edx
 8a7:	8b 45 08             	mov    0x8(%ebp),%eax
 8aa:	01 c2                	add    %eax,%edx
 8ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8b0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 8b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8b6:	3c 0a                	cmp    $0xa,%al
 8b8:	74 13                	je     8cd <readln+0x5f>
 8ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8be:	3c 0d                	cmp    $0xd,%al
 8c0:	74 0b                	je     8cd <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	83 c0 01             	add    $0x1,%eax
 8c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 8cb:	7c b0                	jl     87d <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 8cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8d0:	8b 45 08             	mov    0x8(%ebp),%eax
 8d3:	01 d0                	add    %edx,%eax
 8d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 8d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8db:	c9                   	leave  
 8dc:	c3                   	ret    

000008dd <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 8dd:	55                   	push   %ebp
 8de:	89 e5                	mov    %esp,%ebp
 8e0:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8ea:	eb 19                	jmp    905 <strncpy+0x28>
		dest[i] = src[i];
 8ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8ef:	8b 45 08             	mov    0x8(%ebp),%eax
 8f2:	01 c2                	add    %eax,%edx
 8f4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 8f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 8fa:	01 c8                	add    %ecx,%eax
 8fc:	0f b6 00             	movzbl (%eax),%eax
 8ff:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 901:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	3b 45 10             	cmp    0x10(%ebp),%eax
 90b:	7d 0f                	jge    91c <strncpy+0x3f>
 90d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 910:	8b 45 0c             	mov    0xc(%ebp),%eax
 913:	01 d0                	add    %edx,%eax
 915:	0f b6 00             	movzbl (%eax),%eax
 918:	84 c0                	test   %al,%al
 91a:	75 d0                	jne    8ec <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 91c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 91f:	c9                   	leave  
 920:	c3                   	ret    

00000921 <trim>:

char* trim(char* orig) {
 921:	55                   	push   %ebp
 922:	89 e5                	mov    %esp,%ebp
 924:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 927:	8b 45 08             	mov    0x8(%ebp),%eax
 92a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 92d:	8b 45 08             	mov    0x8(%ebp),%eax
 930:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 933:	eb 04                	jmp    939 <trim+0x18>
 935:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 939:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93c:	0f b6 00             	movzbl (%eax),%eax
 93f:	0f be c0             	movsbl %al,%eax
 942:	50                   	push   %eax
 943:	e8 f4 fe ff ff       	call   83c <isspace>
 948:	83 c4 04             	add    $0x4,%esp
 94b:	85 c0                	test   %eax,%eax
 94d:	75 e6                	jne    935 <trim+0x14>
	while (*tail) { tail++; }
 94f:	eb 04                	jmp    955 <trim+0x34>
 951:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 955:	8b 45 f0             	mov    -0x10(%ebp),%eax
 958:	0f b6 00             	movzbl (%eax),%eax
 95b:	84 c0                	test   %al,%al
 95d:	75 f2                	jne    951 <trim+0x30>
	do { tail--; } while (isspace(*tail));
 95f:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 963:	8b 45 f0             	mov    -0x10(%ebp),%eax
 966:	0f b6 00             	movzbl (%eax),%eax
 969:	0f be c0             	movsbl %al,%eax
 96c:	50                   	push   %eax
 96d:	e8 ca fe ff ff       	call   83c <isspace>
 972:	83 c4 04             	add    $0x4,%esp
 975:	85 c0                	test   %eax,%eax
 977:	75 e6                	jne    95f <trim+0x3e>
	new = malloc(tail-head+2);
 979:	8b 55 f0             	mov    -0x10(%ebp),%edx
 97c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97f:	29 c2                	sub    %eax,%edx
 981:	89 d0                	mov    %edx,%eax
 983:	83 c0 02             	add    $0x2,%eax
 986:	83 ec 0c             	sub    $0xc,%esp
 989:	50                   	push   %eax
 98a:	e8 ca fd ff ff       	call   759 <malloc>
 98f:	83 c4 10             	add    $0x10,%esp
 992:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 995:	8b 55 f0             	mov    -0x10(%ebp),%edx
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	29 c2                	sub    %eax,%edx
 99d:	89 d0                	mov    %edx,%eax
 99f:	83 c0 01             	add    $0x1,%eax
 9a2:	83 ec 04             	sub    $0x4,%esp
 9a5:	50                   	push   %eax
 9a6:	ff 75 f4             	pushl  -0xc(%ebp)
 9a9:	ff 75 ec             	pushl  -0x14(%ebp)
 9ac:	e8 2c ff ff ff       	call   8dd <strncpy>
 9b1:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 9b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 9b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ba:	29 c2                	sub    %eax,%edx
 9bc:	89 d0                	mov    %edx,%eax
 9be:	8d 50 01             	lea    0x1(%eax),%edx
 9c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9c4:	01 d0                	add    %edx,%eax
 9c6:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 9c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 9cc:	c9                   	leave  
 9cd:	c3                   	ret    

000009ce <itoa>:

char *
itoa(int value)
{
 9ce:	55                   	push   %ebp
 9cf:	89 e5                	mov    %esp,%ebp
 9d1:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 9d4:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 9da:	8b 45 08             	mov    0x8(%ebp),%eax
 9dd:	c1 e8 1f             	shr    $0x1f,%eax
 9e0:	0f b6 c0             	movzbl %al,%eax
 9e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 9e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 9ea:	74 0a                	je     9f6 <itoa+0x28>
    v = -value;
 9ec:	8b 45 08             	mov    0x8(%ebp),%eax
 9ef:	f7 d8                	neg    %eax
 9f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9f4:	eb 06                	jmp    9fc <itoa+0x2e>
  else
    v = (uint)value;
 9f6:	8b 45 08             	mov    0x8(%ebp),%eax
 9f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 9fc:	eb 5b                	jmp    a59 <itoa+0x8b>
  {
    i = v % 10;
 9fe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 a01:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 a06:	89 c8                	mov    %ecx,%eax
 a08:	f7 e2                	mul    %edx
 a0a:	c1 ea 03             	shr    $0x3,%edx
 a0d:	89 d0                	mov    %edx,%eax
 a0f:	c1 e0 02             	shl    $0x2,%eax
 a12:	01 d0                	add    %edx,%eax
 a14:	01 c0                	add    %eax,%eax
 a16:	29 c1                	sub    %eax,%ecx
 a18:	89 ca                	mov    %ecx,%edx
 a1a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a20:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 a25:	f7 e2                	mul    %edx
 a27:	89 d0                	mov    %edx,%eax
 a29:	c1 e8 03             	shr    $0x3,%eax
 a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 a2f:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 a33:	7f 13                	jg     a48 <itoa+0x7a>
      *tp++ = i+'0';
 a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a38:	8d 50 01             	lea    0x1(%eax),%edx
 a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a41:	83 c2 30             	add    $0x30,%edx
 a44:	88 10                	mov    %dl,(%eax)
 a46:	eb 11                	jmp    a59 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4b:	8d 50 01             	lea    0x1(%eax),%edx
 a4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a54:	83 c2 57             	add    $0x57,%edx
 a57:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 a59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a5d:	75 9f                	jne    9fe <itoa+0x30>
 a5f:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a62:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a65:	74 97                	je     9fe <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a6a:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a6d:	29 c2                	sub    %eax,%edx
 a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a72:	01 d0                	add    %edx,%eax
 a74:	83 c0 01             	add    $0x1,%eax
 a77:	83 ec 0c             	sub    $0xc,%esp
 a7a:	50                   	push   %eax
 a7b:	e8 d9 fc ff ff       	call   759 <malloc>
 a80:	83 c4 10             	add    $0x10,%esp
 a83:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a89:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a8c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a90:	74 0c                	je     a9e <itoa+0xd0>
    *sp++ = '-';
 a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a95:	8d 50 01             	lea    0x1(%eax),%edx
 a98:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a9b:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a9e:	eb 15                	jmp    ab5 <itoa+0xe7>
    *sp++ = *--tp;
 aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa3:	8d 50 01             	lea    0x1(%eax),%edx
 aa6:	89 55 ec             	mov    %edx,-0x14(%ebp)
 aa9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ab0:	0f b6 12             	movzbl (%edx),%edx
 ab3:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 ab5:	8d 45 bf             	lea    -0x41(%ebp),%eax
 ab8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 abb:	77 e3                	ja     aa0 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ac0:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 ac3:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 ac6:	c9                   	leave  
 ac7:	c3                   	ret    

00000ac8 <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 ac8:	55                   	push   %ebp
 ac9:	89 e5                	mov    %esp,%ebp
 acb:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 ad1:	83 ec 08             	sub    $0x8,%esp
 ad4:	6a 00                	push   $0x0
 ad6:	ff 75 08             	pushl  0x8(%ebp)
 ad9:	e8 55 f8 ff ff       	call   333 <open>
 ade:	83 c4 10             	add    $0x10,%esp
 ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 ae4:	e9 22 01 00 00       	jmp    c0b <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 ae9:	83 ec 08             	sub    $0x8,%esp
 aec:	6a 3d                	push   $0x3d
 aee:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 af4:	50                   	push   %eax
 af5:	e8 79 f6 ff ff       	call   173 <strchr>
 afa:	83 c4 10             	add    $0x10,%esp
 afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 b00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b04:	0f 84 23 01 00 00    	je     c2d <parseEnvFile+0x165>
 b0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b0e:	0f 84 19 01 00 00    	je     c2d <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 b14:	8b 55 f0             	mov    -0x10(%ebp),%edx
 b17:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b1d:	29 c2                	sub    %eax,%edx
 b1f:	89 d0                	mov    %edx,%eax
 b21:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b27:	83 c0 01             	add    $0x1,%eax
 b2a:	83 ec 0c             	sub    $0xc,%esp
 b2d:	50                   	push   %eax
 b2e:	e8 26 fc ff ff       	call   759 <malloc>
 b33:	83 c4 10             	add    $0x10,%esp
 b36:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 b39:	83 ec 04             	sub    $0x4,%esp
 b3c:	ff 75 ec             	pushl  -0x14(%ebp)
 b3f:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b45:	50                   	push   %eax
 b46:	ff 75 e8             	pushl  -0x18(%ebp)
 b49:	e8 8f fd ff ff       	call   8dd <strncpy>
 b4e:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 b51:	83 ec 0c             	sub    $0xc,%esp
 b54:	ff 75 e8             	pushl  -0x18(%ebp)
 b57:	e8 c5 fd ff ff       	call   921 <trim>
 b5c:	83 c4 10             	add    $0x10,%esp
 b5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 b62:	83 ec 0c             	sub    $0xc,%esp
 b65:	ff 75 e8             	pushl  -0x18(%ebp)
 b68:	e8 ab fa ff ff       	call   618 <free>
 b6d:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 b70:	83 ec 08             	sub    $0x8,%esp
 b73:	ff 75 0c             	pushl  0xc(%ebp)
 b76:	ff 75 e4             	pushl  -0x1c(%ebp)
 b79:	e8 c2 01 00 00       	call   d40 <addToEnvironment>
 b7e:	83 c4 10             	add    $0x10,%esp
 b81:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b84:	83 ec 0c             	sub    $0xc,%esp
 b87:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b8d:	50                   	push   %eax
 b8e:	e8 9f f5 ff ff       	call   132 <strlen>
 b93:	83 c4 10             	add    $0x10,%esp
 b96:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b99:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b9c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b9f:	83 ec 0c             	sub    $0xc,%esp
 ba2:	50                   	push   %eax
 ba3:	e8 b1 fb ff ff       	call   759 <malloc>
 ba8:	83 c4 10             	add    $0x10,%esp
 bab:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 bae:	8b 45 e0             	mov    -0x20(%ebp),%eax
 bb1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bb4:	8d 50 ff             	lea    -0x1(%eax),%edx
 bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bba:	8d 48 01             	lea    0x1(%eax),%ecx
 bbd:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 bc3:	01 c8                	add    %ecx,%eax
 bc5:	83 ec 04             	sub    $0x4,%esp
 bc8:	52                   	push   %edx
 bc9:	50                   	push   %eax
 bca:	ff 75 e8             	pushl  -0x18(%ebp)
 bcd:	e8 0b fd ff ff       	call   8dd <strncpy>
 bd2:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 bd5:	83 ec 0c             	sub    $0xc,%esp
 bd8:	ff 75 e8             	pushl  -0x18(%ebp)
 bdb:	e8 41 fd ff ff       	call   921 <trim>
 be0:	83 c4 10             	add    $0x10,%esp
 be3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 be6:	83 ec 0c             	sub    $0xc,%esp
 be9:	ff 75 e8             	pushl  -0x18(%ebp)
 bec:	e8 27 fa ff ff       	call   618 <free>
 bf1:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 bf4:	83 ec 04             	sub    $0x4,%esp
 bf7:	ff 75 dc             	pushl  -0x24(%ebp)
 bfa:	ff 75 0c             	pushl  0xc(%ebp)
 bfd:	ff 75 e4             	pushl  -0x1c(%ebp)
 c00:	e8 b8 01 00 00       	call   dbd <addValueToVariable>
 c05:	83 c4 10             	add    $0x10,%esp
 c08:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 c0b:	83 ec 04             	sub    $0x4,%esp
 c0e:	ff 75 f4             	pushl  -0xc(%ebp)
 c11:	68 00 04 00 00       	push   $0x400
 c16:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 c1c:	50                   	push   %eax
 c1d:	e8 4c fc ff ff       	call   86e <readln>
 c22:	83 c4 10             	add    $0x10,%esp
 c25:	85 c0                	test   %eax,%eax
 c27:	0f 85 bc fe ff ff    	jne    ae9 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 c2d:	83 ec 0c             	sub    $0xc,%esp
 c30:	ff 75 f4             	pushl  -0xc(%ebp)
 c33:	e8 e3 f6 ff ff       	call   31b <close>
 c38:	83 c4 10             	add    $0x10,%esp
	return head;
 c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c3e:	c9                   	leave  
 c3f:	c3                   	ret    

00000c40 <comp>:

int comp(const char* s1, const char* s2)
{
 c40:	55                   	push   %ebp
 c41:	89 e5                	mov    %esp,%ebp
 c43:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 c46:	83 ec 08             	sub    $0x8,%esp
 c49:	ff 75 0c             	pushl  0xc(%ebp)
 c4c:	ff 75 08             	pushl  0x8(%ebp)
 c4f:	e8 9f f4 ff ff       	call   f3 <strcmp>
 c54:	83 c4 10             	add    $0x10,%esp
 c57:	85 c0                	test   %eax,%eax
 c59:	0f 94 c0             	sete   %al
 c5c:	0f b6 c0             	movzbl %al,%eax
}
 c5f:	c9                   	leave  
 c60:	c3                   	ret    

00000c61 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 c61:	55                   	push   %ebp
 c62:	89 e5                	mov    %esp,%ebp
 c64:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 c67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c6b:	75 07                	jne    c74 <environLookup+0x13>
    return NULL;
 c6d:	b8 00 00 00 00       	mov    $0x0,%eax
 c72:	eb 2f                	jmp    ca3 <environLookup+0x42>
  
  while (head)
 c74:	eb 24                	jmp    c9a <environLookup+0x39>
  {
    if (comp(name, head->name))
 c76:	8b 45 0c             	mov    0xc(%ebp),%eax
 c79:	83 ec 08             	sub    $0x8,%esp
 c7c:	50                   	push   %eax
 c7d:	ff 75 08             	pushl  0x8(%ebp)
 c80:	e8 bb ff ff ff       	call   c40 <comp>
 c85:	83 c4 10             	add    $0x10,%esp
 c88:	85 c0                	test   %eax,%eax
 c8a:	74 02                	je     c8e <environLookup+0x2d>
      break;
 c8c:	eb 12                	jmp    ca0 <environLookup+0x3f>
    head = head->next;
 c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
 c91:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c97:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c9e:	75 d6                	jne    c76 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 ca3:	c9                   	leave  
 ca4:	c3                   	ret    

00000ca5 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 ca5:	55                   	push   %ebp
 ca6:	89 e5                	mov    %esp,%ebp
 ca8:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 cab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 caf:	75 0a                	jne    cbb <removeFromEnvironment+0x16>
    return NULL;
 cb1:	b8 00 00 00 00       	mov    $0x0,%eax
 cb6:	e9 83 00 00 00       	jmp    d3e <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 cbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 cbf:	74 0a                	je     ccb <removeFromEnvironment+0x26>
 cc1:	8b 45 08             	mov    0x8(%ebp),%eax
 cc4:	0f b6 00             	movzbl (%eax),%eax
 cc7:	84 c0                	test   %al,%al
 cc9:	75 05                	jne    cd0 <removeFromEnvironment+0x2b>
    return head;
 ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
 cce:	eb 6e                	jmp    d3e <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
 cd3:	83 ec 08             	sub    $0x8,%esp
 cd6:	ff 75 08             	pushl  0x8(%ebp)
 cd9:	50                   	push   %eax
 cda:	e8 61 ff ff ff       	call   c40 <comp>
 cdf:	83 c4 10             	add    $0x10,%esp
 ce2:	85 c0                	test   %eax,%eax
 ce4:	74 34                	je     d1a <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
 ce9:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
 cf5:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 cfb:	83 ec 0c             	sub    $0xc,%esp
 cfe:	50                   	push   %eax
 cff:	e8 74 01 00 00       	call   e78 <freeVarval>
 d04:	83 c4 10             	add    $0x10,%esp
    free(head);
 d07:	83 ec 0c             	sub    $0xc,%esp
 d0a:	ff 75 0c             	pushl  0xc(%ebp)
 d0d:	e8 06 f9 ff ff       	call   618 <free>
 d12:	83 c4 10             	add    $0x10,%esp
    return tmp;
 d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d18:	eb 24                	jmp    d3e <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
 d1d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d23:	83 ec 08             	sub    $0x8,%esp
 d26:	50                   	push   %eax
 d27:	ff 75 08             	pushl  0x8(%ebp)
 d2a:	e8 76 ff ff ff       	call   ca5 <removeFromEnvironment>
 d2f:	83 c4 10             	add    $0x10,%esp
 d32:	8b 55 0c             	mov    0xc(%ebp),%edx
 d35:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d3e:	c9                   	leave  
 d3f:	c3                   	ret    

00000d40 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 d40:	55                   	push   %ebp
 d41:	89 e5                	mov    %esp,%ebp
 d43:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 d46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 d4a:	75 05                	jne    d51 <addToEnvironment+0x11>
		return head;
 d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
 d4f:	eb 6a                	jmp    dbb <addToEnvironment+0x7b>
	if (head == NULL) {
 d51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 d55:	75 40                	jne    d97 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 d57:	83 ec 0c             	sub    $0xc,%esp
 d5a:	68 88 00 00 00       	push   $0x88
 d5f:	e8 f5 f9 ff ff       	call   759 <malloc>
 d64:	83 c4 10             	add    $0x10,%esp
 d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 d6a:	8b 45 08             	mov    0x8(%ebp),%eax
 d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d73:	83 ec 08             	sub    $0x8,%esp
 d76:	ff 75 f0             	pushl  -0x10(%ebp)
 d79:	50                   	push   %eax
 d7a:	e8 44 f3 ff ff       	call   c3 <strcpy>
 d7f:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d85:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d8c:	00 00 00 
		head = newVar;
 d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d92:	89 45 0c             	mov    %eax,0xc(%ebp)
 d95:	eb 21                	jmp    db8 <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d97:	8b 45 0c             	mov    0xc(%ebp),%eax
 d9a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 da0:	83 ec 08             	sub    $0x8,%esp
 da3:	50                   	push   %eax
 da4:	ff 75 08             	pushl  0x8(%ebp)
 da7:	e8 94 ff ff ff       	call   d40 <addToEnvironment>
 dac:	83 c4 10             	add    $0x10,%esp
 daf:	8b 55 0c             	mov    0xc(%ebp),%edx
 db2:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 db8:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 dbb:	c9                   	leave  
 dbc:	c3                   	ret    

00000dbd <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 dbd:	55                   	push   %ebp
 dbe:	89 e5                	mov    %esp,%ebp
 dc0:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 dc3:	83 ec 08             	sub    $0x8,%esp
 dc6:	ff 75 0c             	pushl  0xc(%ebp)
 dc9:	ff 75 08             	pushl  0x8(%ebp)
 dcc:	e8 90 fe ff ff       	call   c61 <environLookup>
 dd1:	83 c4 10             	add    $0x10,%esp
 dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ddb:	75 05                	jne    de2 <addValueToVariable+0x25>
		return head;
 ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
 de0:	eb 4c                	jmp    e2e <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 de2:	83 ec 0c             	sub    $0xc,%esp
 de5:	68 04 04 00 00       	push   $0x404
 dea:	e8 6a f9 ff ff       	call   759 <malloc>
 def:	83 c4 10             	add    $0x10,%esp
 df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 df5:	8b 45 10             	mov    0x10(%ebp),%eax
 df8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dfe:	83 ec 08             	sub    $0x8,%esp
 e01:	ff 75 ec             	pushl  -0x14(%ebp)
 e04:	50                   	push   %eax
 e05:	e8 b9 f2 ff ff       	call   c3 <strcpy>
 e0a:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e10:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e19:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e22:	8b 55 f0             	mov    -0x10(%ebp),%edx
 e25:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 e2e:	c9                   	leave  
 e2f:	c3                   	ret    

00000e30 <freeEnvironment>:

void freeEnvironment(variable* head)
{
 e30:	55                   	push   %ebp
 e31:	89 e5                	mov    %esp,%ebp
 e33:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e3a:	75 02                	jne    e3e <freeEnvironment+0xe>
    return;  
 e3c:	eb 38                	jmp    e76 <freeEnvironment+0x46>
  freeEnvironment(head->next);
 e3e:	8b 45 08             	mov    0x8(%ebp),%eax
 e41:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 e47:	83 ec 0c             	sub    $0xc,%esp
 e4a:	50                   	push   %eax
 e4b:	e8 e0 ff ff ff       	call   e30 <freeEnvironment>
 e50:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 e53:	8b 45 08             	mov    0x8(%ebp),%eax
 e56:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 e5c:	83 ec 0c             	sub    $0xc,%esp
 e5f:	50                   	push   %eax
 e60:	e8 13 00 00 00       	call   e78 <freeVarval>
 e65:	83 c4 10             	add    $0x10,%esp
  free(head);
 e68:	83 ec 0c             	sub    $0xc,%esp
 e6b:	ff 75 08             	pushl  0x8(%ebp)
 e6e:	e8 a5 f7 ff ff       	call   618 <free>
 e73:	83 c4 10             	add    $0x10,%esp
}
 e76:	c9                   	leave  
 e77:	c3                   	ret    

00000e78 <freeVarval>:

void freeVarval(varval* head)
{
 e78:	55                   	push   %ebp
 e79:	89 e5                	mov    %esp,%ebp
 e7b:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e82:	75 02                	jne    e86 <freeVarval+0xe>
    return;  
 e84:	eb 23                	jmp    ea9 <freeVarval+0x31>
  freeVarval(head->next);
 e86:	8b 45 08             	mov    0x8(%ebp),%eax
 e89:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e8f:	83 ec 0c             	sub    $0xc,%esp
 e92:	50                   	push   %eax
 e93:	e8 e0 ff ff ff       	call   e78 <freeVarval>
 e98:	83 c4 10             	add    $0x10,%esp
  free(head);
 e9b:	83 ec 0c             	sub    $0xc,%esp
 e9e:	ff 75 08             	pushl  0x8(%ebp)
 ea1:	e8 72 f7 ff ff       	call   618 <free>
 ea6:	83 c4 10             	add    $0x10,%esp
}
 ea9:	c9                   	leave  
 eaa:	c3                   	ret    

00000eab <getPaths>:

varval* getPaths(char* paths, varval* head) {
 eab:	55                   	push   %ebp
 eac:	89 e5                	mov    %esp,%ebp
 eae:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 eb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 eb5:	75 08                	jne    ebf <getPaths+0x14>
		return head;
 eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
 eba:	e9 e7 00 00 00       	jmp    fa6 <getPaths+0xfb>
	if (head == NULL) {
 ebf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 ec3:	0f 85 b9 00 00 00    	jne    f82 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 ec9:	83 ec 08             	sub    $0x8,%esp
 ecc:	6a 3a                	push   $0x3a
 ece:	ff 75 08             	pushl  0x8(%ebp)
 ed1:	e8 9d f2 ff ff       	call   173 <strchr>
 ed6:	83 c4 10             	add    $0x10,%esp
 ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ee0:	75 56                	jne    f38 <getPaths+0x8d>
			pathLen = strlen(paths);
 ee2:	83 ec 0c             	sub    $0xc,%esp
 ee5:	ff 75 08             	pushl  0x8(%ebp)
 ee8:	e8 45 f2 ff ff       	call   132 <strlen>
 eed:	83 c4 10             	add    $0x10,%esp
 ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 ef3:	83 ec 0c             	sub    $0xc,%esp
 ef6:	68 04 04 00 00       	push   $0x404
 efb:	e8 59 f8 ff ff       	call   759 <malloc>
 f00:	83 c4 10             	add    $0x10,%esp
 f03:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 f06:	8b 45 0c             	mov    0xc(%ebp),%eax
 f09:	83 ec 04             	sub    $0x4,%esp
 f0c:	ff 75 f0             	pushl  -0x10(%ebp)
 f0f:	ff 75 08             	pushl  0x8(%ebp)
 f12:	50                   	push   %eax
 f13:	e8 c5 f9 ff ff       	call   8dd <strncpy>
 f18:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
 f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f21:	01 d0                	add    %edx,%eax
 f23:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 f26:	8b 45 0c             	mov    0xc(%ebp),%eax
 f29:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 f30:	00 00 00 
			return head;
 f33:	8b 45 0c             	mov    0xc(%ebp),%eax
 f36:	eb 6e                	jmp    fa6 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
 f3b:	8b 45 08             	mov    0x8(%ebp),%eax
 f3e:	29 c2                	sub    %eax,%edx
 f40:	89 d0                	mov    %edx,%eax
 f42:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 f45:	83 ec 0c             	sub    $0xc,%esp
 f48:	68 04 04 00 00       	push   $0x404
 f4d:	e8 07 f8 ff ff       	call   759 <malloc>
 f52:	83 c4 10             	add    $0x10,%esp
 f55:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 f58:	8b 45 0c             	mov    0xc(%ebp),%eax
 f5b:	83 ec 04             	sub    $0x4,%esp
 f5e:	ff 75 f0             	pushl  -0x10(%ebp)
 f61:	ff 75 08             	pushl  0x8(%ebp)
 f64:	50                   	push   %eax
 f65:	e8 73 f9 ff ff       	call   8dd <strncpy>
 f6a:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
 f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f73:	01 d0                	add    %edx,%eax
 f75:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f7b:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 f7e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f82:	8b 45 0c             	mov    0xc(%ebp),%eax
 f85:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f8b:	83 ec 08             	sub    $0x8,%esp
 f8e:	50                   	push   %eax
 f8f:	ff 75 08             	pushl  0x8(%ebp)
 f92:	e8 14 ff ff ff       	call   eab <getPaths>
 f97:	83 c4 10             	add    $0x10,%esp
 f9a:	8b 55 0c             	mov    0xc(%ebp),%edx
 f9d:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 fa6:	c9                   	leave  
 fa7:	c3                   	ret    
