
_pwd:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:

#define MAX_PATH 512

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 04 02 00 00    	sub    $0x204,%esp
  char path[MAX_PATH];
  getcwd(path, MAX_PATH);
  14:	83 ec 08             	sub    $0x8,%esp
  17:	68 00 02 00 00       	push   $0x200
  1c:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
  22:	50                   	push   %eax
  23:	e8 16 03 00 00       	call   33e <getcwd>
  28:	83 c4 10             	add    $0x10,%esp
  printf(0, "%s\n", path);
  2b:	83 ec 04             	sub    $0x4,%esp
  2e:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
  34:	50                   	push   %eax
  35:	68 53 0f 00 00       	push   $0xf53
  3a:	6a 00                	push   $0x0
  3c:	e8 f2 03 00 00       	call   433 <printf>
  41:	83 c4 10             	add    $0x10,%esp
  exit();
  44:	e8 55 02 00 00       	call   29e <exit>

00000049 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	57                   	push   %edi
  4d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  51:	8b 55 10             	mov    0x10(%ebp),%edx
  54:	8b 45 0c             	mov    0xc(%ebp),%eax
  57:	89 cb                	mov    %ecx,%ebx
  59:	89 df                	mov    %ebx,%edi
  5b:	89 d1                	mov    %edx,%ecx
  5d:	fc                   	cld    
  5e:	f3 aa                	rep stos %al,%es:(%edi)
  60:	89 ca                	mov    %ecx,%edx
  62:	89 fb                	mov    %edi,%ebx
  64:	89 5d 08             	mov    %ebx,0x8(%ebp)
  67:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  6a:	5b                   	pop    %ebx
  6b:	5f                   	pop    %edi
  6c:	5d                   	pop    %ebp
  6d:	c3                   	ret    

0000006e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  6e:	55                   	push   %ebp
  6f:	89 e5                	mov    %esp,%ebp
  71:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  7a:	90                   	nop
  7b:	8b 45 08             	mov    0x8(%ebp),%eax
  7e:	8d 50 01             	lea    0x1(%eax),%edx
  81:	89 55 08             	mov    %edx,0x8(%ebp)
  84:	8b 55 0c             	mov    0xc(%ebp),%edx
  87:	8d 4a 01             	lea    0x1(%edx),%ecx
  8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8d:	0f b6 12             	movzbl (%edx),%edx
  90:	88 10                	mov    %dl,(%eax)
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	75 e2                	jne    7b <strcpy+0xd>
    ;
  return os;
  99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  9c:	c9                   	leave  
  9d:	c3                   	ret    

0000009e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  a1:	eb 08                	jmp    ab <strcmp+0xd>
    p++, q++;
  a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ab:	8b 45 08             	mov    0x8(%ebp),%eax
  ae:	0f b6 00             	movzbl (%eax),%eax
  b1:	84 c0                	test   %al,%al
  b3:	74 10                	je     c5 <strcmp+0x27>
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	0f b6 10             	movzbl (%eax),%edx
  bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	38 c2                	cmp    %al,%dl
  c3:	74 de                	je     a3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  c5:	8b 45 08             	mov    0x8(%ebp),%eax
  c8:	0f b6 00             	movzbl (%eax),%eax
  cb:	0f b6 d0             	movzbl %al,%edx
  ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  d1:	0f b6 00             	movzbl (%eax),%eax
  d4:	0f b6 c0             	movzbl %al,%eax
  d7:	29 c2                	sub    %eax,%edx
  d9:	89 d0                	mov    %edx,%eax
}
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    

000000dd <strlen>:

uint
strlen(char *s)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ea:	eb 04                	jmp    f0 <strlen+0x13>
  ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	01 d0                	add    %edx,%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	84 c0                	test   %al,%al
  fd:	75 ed                	jne    ec <strlen+0xf>
    ;
  return n;
  ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <memset>:

void*
memset(void *dst, int c, uint n)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 107:	8b 45 10             	mov    0x10(%ebp),%eax
 10a:	50                   	push   %eax
 10b:	ff 75 0c             	pushl  0xc(%ebp)
 10e:	ff 75 08             	pushl  0x8(%ebp)
 111:	e8 33 ff ff ff       	call   49 <stosb>
 116:	83 c4 0c             	add    $0xc,%esp
  return dst;
 119:	8b 45 08             	mov    0x8(%ebp),%eax
}
 11c:	c9                   	leave  
 11d:	c3                   	ret    

0000011e <strchr>:

char*
strchr(const char *s, char c)
{
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
 121:	83 ec 04             	sub    $0x4,%esp
 124:	8b 45 0c             	mov    0xc(%ebp),%eax
 127:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 12a:	eb 14                	jmp    140 <strchr+0x22>
    if(*s == c)
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	0f b6 00             	movzbl (%eax),%eax
 132:	3a 45 fc             	cmp    -0x4(%ebp),%al
 135:	75 05                	jne    13c <strchr+0x1e>
      return (char*)s;
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	eb 13                	jmp    14f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 13c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	0f b6 00             	movzbl (%eax),%eax
 146:	84 c0                	test   %al,%al
 148:	75 e2                	jne    12c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 14a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 14f:	c9                   	leave  
 150:	c3                   	ret    

00000151 <gets>:

char*
gets(char *buf, int max)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 157:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 15e:	eb 44                	jmp    1a4 <gets+0x53>
    cc = read(0, &c, 1);
 160:	83 ec 04             	sub    $0x4,%esp
 163:	6a 01                	push   $0x1
 165:	8d 45 ef             	lea    -0x11(%ebp),%eax
 168:	50                   	push   %eax
 169:	6a 00                	push   $0x0
 16b:	e8 46 01 00 00       	call   2b6 <read>
 170:	83 c4 10             	add    $0x10,%esp
 173:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 176:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 17a:	7f 02                	jg     17e <gets+0x2d>
      break;
 17c:	eb 31                	jmp    1af <gets+0x5e>
    buf[i++] = c;
 17e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 181:	8d 50 01             	lea    0x1(%eax),%edx
 184:	89 55 f4             	mov    %edx,-0xc(%ebp)
 187:	89 c2                	mov    %eax,%edx
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	01 c2                	add    %eax,%edx
 18e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 192:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 194:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 198:	3c 0a                	cmp    $0xa,%al
 19a:	74 13                	je     1af <gets+0x5e>
 19c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a0:	3c 0d                	cmp    $0xd,%al
 1a2:	74 0b                	je     1af <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a7:	83 c0 01             	add    $0x1,%eax
 1aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ad:	7c b1                	jl     160 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1af:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	01 d0                	add    %edx,%eax
 1b7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1bd:	c9                   	leave  
 1be:	c3                   	ret    

000001bf <stat>:

int
stat(char *n, struct stat *st)
{
 1bf:	55                   	push   %ebp
 1c0:	89 e5                	mov    %esp,%ebp
 1c2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c5:	83 ec 08             	sub    $0x8,%esp
 1c8:	6a 00                	push   $0x0
 1ca:	ff 75 08             	pushl  0x8(%ebp)
 1cd:	e8 0c 01 00 00       	call   2de <open>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1dc:	79 07                	jns    1e5 <stat+0x26>
    return -1;
 1de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1e3:	eb 25                	jmp    20a <stat+0x4b>
  r = fstat(fd, st);
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	ff 75 0c             	pushl  0xc(%ebp)
 1eb:	ff 75 f4             	pushl  -0xc(%ebp)
 1ee:	e8 03 01 00 00       	call   2f6 <fstat>
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f9:	83 ec 0c             	sub    $0xc,%esp
 1fc:	ff 75 f4             	pushl  -0xc(%ebp)
 1ff:	e8 c2 00 00 00       	call   2c6 <close>
 204:	83 c4 10             	add    $0x10,%esp
  return r;
 207:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 20a:	c9                   	leave  
 20b:	c3                   	ret    

0000020c <atoi>:

int
atoi(const char *s)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 219:	eb 25                	jmp    240 <atoi+0x34>
    n = n*10 + *s++ - '0';
 21b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 21e:	89 d0                	mov    %edx,%eax
 220:	c1 e0 02             	shl    $0x2,%eax
 223:	01 d0                	add    %edx,%eax
 225:	01 c0                	add    %eax,%eax
 227:	89 c1                	mov    %eax,%ecx
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	8d 50 01             	lea    0x1(%eax),%edx
 22f:	89 55 08             	mov    %edx,0x8(%ebp)
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	0f be c0             	movsbl %al,%eax
 238:	01 c8                	add    %ecx,%eax
 23a:	83 e8 30             	sub    $0x30,%eax
 23d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	3c 2f                	cmp    $0x2f,%al
 248:	7e 0a                	jle    254 <atoi+0x48>
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	3c 39                	cmp    $0x39,%al
 252:	7e c7                	jle    21b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 254:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 265:	8b 45 0c             	mov    0xc(%ebp),%eax
 268:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 26b:	eb 17                	jmp    284 <memmove+0x2b>
    *dst++ = *src++;
 26d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 270:	8d 50 01             	lea    0x1(%eax),%edx
 273:	89 55 fc             	mov    %edx,-0x4(%ebp)
 276:	8b 55 f8             	mov    -0x8(%ebp),%edx
 279:	8d 4a 01             	lea    0x1(%edx),%ecx
 27c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 27f:	0f b6 12             	movzbl (%edx),%edx
 282:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 284:	8b 45 10             	mov    0x10(%ebp),%eax
 287:	8d 50 ff             	lea    -0x1(%eax),%edx
 28a:	89 55 10             	mov    %edx,0x10(%ebp)
 28d:	85 c0                	test   %eax,%eax
 28f:	7f dc                	jg     26d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 291:	8b 45 08             	mov    0x8(%ebp),%eax
}
 294:	c9                   	leave  
 295:	c3                   	ret    

00000296 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 296:	b8 01 00 00 00       	mov    $0x1,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <exit>:
SYSCALL(exit)
 29e:	b8 02 00 00 00       	mov    $0x2,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <wait>:
SYSCALL(wait)
 2a6:	b8 03 00 00 00       	mov    $0x3,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <pipe>:
SYSCALL(pipe)
 2ae:	b8 04 00 00 00       	mov    $0x4,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <read>:
SYSCALL(read)
 2b6:	b8 05 00 00 00       	mov    $0x5,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <write>:
SYSCALL(write)
 2be:	b8 10 00 00 00       	mov    $0x10,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <close>:
SYSCALL(close)
 2c6:	b8 15 00 00 00       	mov    $0x15,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <kill>:
SYSCALL(kill)
 2ce:	b8 06 00 00 00       	mov    $0x6,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <exec>:
SYSCALL(exec)
 2d6:	b8 07 00 00 00       	mov    $0x7,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <open>:
SYSCALL(open)
 2de:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <mknod>:
SYSCALL(mknod)
 2e6:	b8 11 00 00 00       	mov    $0x11,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <unlink>:
SYSCALL(unlink)
 2ee:	b8 12 00 00 00       	mov    $0x12,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <fstat>:
SYSCALL(fstat)
 2f6:	b8 08 00 00 00       	mov    $0x8,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <link>:
SYSCALL(link)
 2fe:	b8 13 00 00 00       	mov    $0x13,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <mkdir>:
SYSCALL(mkdir)
 306:	b8 14 00 00 00       	mov    $0x14,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <chdir>:
SYSCALL(chdir)
 30e:	b8 09 00 00 00       	mov    $0x9,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <dup>:
SYSCALL(dup)
 316:	b8 0a 00 00 00       	mov    $0xa,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <getpid>:
SYSCALL(getpid)
 31e:	b8 0b 00 00 00       	mov    $0xb,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <sbrk>:
SYSCALL(sbrk)
 326:	b8 0c 00 00 00       	mov    $0xc,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <sleep>:
SYSCALL(sleep)
 32e:	b8 0d 00 00 00       	mov    $0xd,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <uptime>:
SYSCALL(uptime)
 336:	b8 0e 00 00 00       	mov    $0xe,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <getcwd>:
SYSCALL(getcwd)
 33e:	b8 16 00 00 00       	mov    $0x16,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <shutdown>:
SYSCALL(shutdown)
 346:	b8 17 00 00 00       	mov    $0x17,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <buildinfo>:
SYSCALL(buildinfo)
 34e:	b8 18 00 00 00       	mov    $0x18,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <lseek>:
SYSCALL(lseek)
 356:	b8 19 00 00 00       	mov    $0x19,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	83 ec 18             	sub    $0x18,%esp
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36a:	83 ec 04             	sub    $0x4,%esp
 36d:	6a 01                	push   $0x1
 36f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 372:	50                   	push   %eax
 373:	ff 75 08             	pushl  0x8(%ebp)
 376:	e8 43 ff ff ff       	call   2be <write>
 37b:	83 c4 10             	add    $0x10,%esp
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	53                   	push   %ebx
 384:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 392:	74 17                	je     3ab <printint+0x2b>
 394:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 398:	79 11                	jns    3ab <printint+0x2b>
    neg = 1;
 39a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	f7 d8                	neg    %eax
 3a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a9:	eb 06                	jmp    3b1 <printint+0x31>
  } else {
    x = xx;
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3bb:	8d 41 01             	lea    0x1(%ecx),%eax
 3be:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c7:	ba 00 00 00 00       	mov    $0x0,%edx
 3cc:	f7 f3                	div    %ebx
 3ce:	89 d0                	mov    %edx,%eax
 3d0:	0f b6 80 68 13 00 00 	movzbl 0x1368(%eax),%eax
 3d7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3db:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3de:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e1:	ba 00 00 00 00       	mov    $0x0,%edx
 3e6:	f7 f3                	div    %ebx
 3e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3ef:	75 c7                	jne    3b8 <printint+0x38>
  if(neg)
 3f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f5:	74 0e                	je     405 <printint+0x85>
    buf[i++] = '-';
 3f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fa:	8d 50 01             	lea    0x1(%eax),%edx
 3fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 400:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 405:	eb 1d                	jmp    424 <printint+0xa4>
    putc(fd, buf[i]);
 407:	8d 55 dc             	lea    -0x24(%ebp),%edx
 40a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40d:	01 d0                	add    %edx,%eax
 40f:	0f b6 00             	movzbl (%eax),%eax
 412:	0f be c0             	movsbl %al,%eax
 415:	83 ec 08             	sub    $0x8,%esp
 418:	50                   	push   %eax
 419:	ff 75 08             	pushl  0x8(%ebp)
 41c:	e8 3d ff ff ff       	call   35e <putc>
 421:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 424:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 428:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42c:	79 d9                	jns    407 <printint+0x87>
    putc(fd, buf[i]);
}
 42e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 431:	c9                   	leave  
 432:	c3                   	ret    

00000433 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
 436:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 439:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 440:	8d 45 0c             	lea    0xc(%ebp),%eax
 443:	83 c0 04             	add    $0x4,%eax
 446:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 449:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 450:	e9 59 01 00 00       	jmp    5ae <printf+0x17b>
    c = fmt[i] & 0xff;
 455:	8b 55 0c             	mov    0xc(%ebp),%edx
 458:	8b 45 f0             	mov    -0x10(%ebp),%eax
 45b:	01 d0                	add    %edx,%eax
 45d:	0f b6 00             	movzbl (%eax),%eax
 460:	0f be c0             	movsbl %al,%eax
 463:	25 ff 00 00 00       	and    $0xff,%eax
 468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 46b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46f:	75 2c                	jne    49d <printf+0x6a>
      if(c == '%'){
 471:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 475:	75 0c                	jne    483 <printf+0x50>
        state = '%';
 477:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47e:	e9 27 01 00 00       	jmp    5aa <printf+0x177>
      } else {
        putc(fd, c);
 483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 486:	0f be c0             	movsbl %al,%eax
 489:	83 ec 08             	sub    $0x8,%esp
 48c:	50                   	push   %eax
 48d:	ff 75 08             	pushl  0x8(%ebp)
 490:	e8 c9 fe ff ff       	call   35e <putc>
 495:	83 c4 10             	add    $0x10,%esp
 498:	e9 0d 01 00 00       	jmp    5aa <printf+0x177>
      }
    } else if(state == '%'){
 49d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a1:	0f 85 03 01 00 00    	jne    5aa <printf+0x177>
      if(c == 'd'){
 4a7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ab:	75 1e                	jne    4cb <printf+0x98>
        printint(fd, *ap, 10, 1);
 4ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b0:	8b 00                	mov    (%eax),%eax
 4b2:	6a 01                	push   $0x1
 4b4:	6a 0a                	push   $0xa
 4b6:	50                   	push   %eax
 4b7:	ff 75 08             	pushl  0x8(%ebp)
 4ba:	e8 c1 fe ff ff       	call   380 <printint>
 4bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c6:	e9 d8 00 00 00       	jmp    5a3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4cb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4cf:	74 06                	je     4d7 <printf+0xa4>
 4d1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4d5:	75 1e                	jne    4f5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4da:	8b 00                	mov    (%eax),%eax
 4dc:	6a 00                	push   $0x0
 4de:	6a 10                	push   $0x10
 4e0:	50                   	push   %eax
 4e1:	ff 75 08             	pushl  0x8(%ebp)
 4e4:	e8 97 fe ff ff       	call   380 <printint>
 4e9:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f0:	e9 ae 00 00 00       	jmp    5a3 <printf+0x170>
      } else if(c == 's'){
 4f5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f9:	75 43                	jne    53e <printf+0x10b>
        s = (char*)*ap;
 4fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 503:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 507:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50b:	75 07                	jne    514 <printf+0xe1>
          s = "(null)";
 50d:	c7 45 f4 57 0f 00 00 	movl   $0xf57,-0xc(%ebp)
        while(*s != 0){
 514:	eb 1c                	jmp    532 <printf+0xff>
          putc(fd, *s);
 516:	8b 45 f4             	mov    -0xc(%ebp),%eax
 519:	0f b6 00             	movzbl (%eax),%eax
 51c:	0f be c0             	movsbl %al,%eax
 51f:	83 ec 08             	sub    $0x8,%esp
 522:	50                   	push   %eax
 523:	ff 75 08             	pushl  0x8(%ebp)
 526:	e8 33 fe ff ff       	call   35e <putc>
 52b:	83 c4 10             	add    $0x10,%esp
          s++;
 52e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 532:	8b 45 f4             	mov    -0xc(%ebp),%eax
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	84 c0                	test   %al,%al
 53a:	75 da                	jne    516 <printf+0xe3>
 53c:	eb 65                	jmp    5a3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 542:	75 1d                	jne    561 <printf+0x12e>
        putc(fd, *ap);
 544:	8b 45 e8             	mov    -0x18(%ebp),%eax
 547:	8b 00                	mov    (%eax),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	83 ec 08             	sub    $0x8,%esp
 54f:	50                   	push   %eax
 550:	ff 75 08             	pushl  0x8(%ebp)
 553:	e8 06 fe ff ff       	call   35e <putc>
 558:	83 c4 10             	add    $0x10,%esp
        ap++;
 55b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55f:	eb 42                	jmp    5a3 <printf+0x170>
      } else if(c == '%'){
 561:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 565:	75 17                	jne    57e <printf+0x14b>
        putc(fd, c);
 567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	83 ec 08             	sub    $0x8,%esp
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 e5 fd ff ff       	call   35e <putc>
 579:	83 c4 10             	add    $0x10,%esp
 57c:	eb 25                	jmp    5a3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57e:	83 ec 08             	sub    $0x8,%esp
 581:	6a 25                	push   $0x25
 583:	ff 75 08             	pushl  0x8(%ebp)
 586:	e8 d3 fd ff ff       	call   35e <putc>
 58b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 58e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	83 ec 08             	sub    $0x8,%esp
 597:	50                   	push   %eax
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 be fd ff ff       	call   35e <putc>
 5a0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5aa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b4:	01 d0                	add    %edx,%eax
 5b6:	0f b6 00             	movzbl (%eax),%eax
 5b9:	84 c0                	test   %al,%al
 5bb:	0f 85 94 fe ff ff    	jne    455 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c1:	c9                   	leave  
 5c2:	c3                   	ret    

000005c3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c3:	55                   	push   %ebp
 5c4:	89 e5                	mov    %esp,%ebp
 5c6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	83 e8 08             	sub    $0x8,%eax
 5cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d2:	a1 84 13 00 00       	mov    0x1384,%eax
 5d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5da:	eb 24                	jmp    600 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5df:	8b 00                	mov    (%eax),%eax
 5e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e4:	77 12                	ja     5f8 <free+0x35>
 5e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ec:	77 24                	ja     612 <free+0x4f>
 5ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f1:	8b 00                	mov    (%eax),%eax
 5f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f6:	77 1a                	ja     612 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fb:	8b 00                	mov    (%eax),%eax
 5fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 600:	8b 45 f8             	mov    -0x8(%ebp),%eax
 603:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 606:	76 d4                	jbe    5dc <free+0x19>
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 610:	76 ca                	jbe    5dc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	8b 40 04             	mov    0x4(%eax),%eax
 618:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	01 c2                	add    %eax,%edx
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	39 c2                	cmp    %eax,%edx
 62b:	75 24                	jne    651 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 62d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 630:	8b 50 04             	mov    0x4(%eax),%edx
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	8b 40 04             	mov    0x4(%eax),%eax
 63b:	01 c2                	add    %eax,%edx
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	8b 10                	mov    (%eax),%edx
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	89 10                	mov    %edx,(%eax)
 64f:	eb 0a                	jmp    65b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 10                	mov    (%eax),%edx
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	01 d0                	add    %edx,%eax
 66d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 670:	75 20                	jne    692 <free+0xcf>
    p->s.size += bp->s.size;
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 50 04             	mov    0x4(%eax),%edx
 678:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67b:	8b 40 04             	mov    0x4(%eax),%eax
 67e:	01 c2                	add    %eax,%edx
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
 690:	eb 08                	jmp    69a <free+0xd7>
  } else
    p->s.ptr = bp;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 55 f8             	mov    -0x8(%ebp),%edx
 698:	89 10                	mov    %edx,(%eax)
  freep = p;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	a3 84 13 00 00       	mov    %eax,0x1384
}
 6a2:	c9                   	leave  
 6a3:	c3                   	ret    

000006a4 <morecore>:

static Header*
morecore(uint nu)
{
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6aa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6b1:	77 07                	ja     6ba <morecore+0x16>
    nu = 4096;
 6b3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	c1 e0 03             	shl    $0x3,%eax
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	50                   	push   %eax
 6c4:	e8 5d fc ff ff       	call   326 <sbrk>
 6c9:	83 c4 10             	add    $0x10,%esp
 6cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6cf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6d3:	75 07                	jne    6dc <morecore+0x38>
    return 0;
 6d5:	b8 00 00 00 00       	mov    $0x0,%eax
 6da:	eb 26                	jmp    702 <morecore+0x5e>
  hp = (Header*)p;
 6dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e5:	8b 55 08             	mov    0x8(%ebp),%edx
 6e8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ee:	83 c0 08             	add    $0x8,%eax
 6f1:	83 ec 0c             	sub    $0xc,%esp
 6f4:	50                   	push   %eax
 6f5:	e8 c9 fe ff ff       	call   5c3 <free>
 6fa:	83 c4 10             	add    $0x10,%esp
  return freep;
 6fd:	a1 84 13 00 00       	mov    0x1384,%eax
}
 702:	c9                   	leave  
 703:	c3                   	ret    

00000704 <malloc>:

void*
malloc(uint nbytes)
{
 704:	55                   	push   %ebp
 705:	89 e5                	mov    %esp,%ebp
 707:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	83 c0 07             	add    $0x7,%eax
 710:	c1 e8 03             	shr    $0x3,%eax
 713:	83 c0 01             	add    $0x1,%eax
 716:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 719:	a1 84 13 00 00       	mov    0x1384,%eax
 71e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 721:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 725:	75 23                	jne    74a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 727:	c7 45 f0 7c 13 00 00 	movl   $0x137c,-0x10(%ebp)
 72e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 731:	a3 84 13 00 00       	mov    %eax,0x1384
 736:	a1 84 13 00 00       	mov    0x1384,%eax
 73b:	a3 7c 13 00 00       	mov    %eax,0x137c
    base.s.size = 0;
 740:	c7 05 80 13 00 00 00 	movl   $0x0,0x1380
 747:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75b:	72 4d                	jb     7aa <malloc+0xa6>
      if(p->s.size == nunits)
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 766:	75 0c                	jne    774 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 10                	mov    (%eax),%edx
 76d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 770:	89 10                	mov    %edx,(%eax)
 772:	eb 26                	jmp    79a <malloc+0x96>
      else {
        p->s.size -= nunits;
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 77d:	89 c2                	mov    %eax,%edx
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	c1 e0 03             	shl    $0x3,%eax
 78e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	8b 55 ec             	mov    -0x14(%ebp),%edx
 797:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	a3 84 13 00 00       	mov    %eax,0x1384
      return (void*)(p + 1);
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	83 c0 08             	add    $0x8,%eax
 7a8:	eb 3b                	jmp    7e5 <malloc+0xe1>
    }
    if(p == freep)
 7aa:	a1 84 13 00 00       	mov    0x1384,%eax
 7af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7b2:	75 1e                	jne    7d2 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7b4:	83 ec 0c             	sub    $0xc,%esp
 7b7:	ff 75 ec             	pushl  -0x14(%ebp)
 7ba:	e8 e5 fe ff ff       	call   6a4 <morecore>
 7bf:	83 c4 10             	add    $0x10,%esp
 7c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c9:	75 07                	jne    7d2 <malloc+0xce>
        return 0;
 7cb:	b8 00 00 00 00       	mov    $0x0,%eax
 7d0:	eb 13                	jmp    7e5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7e0:	e9 6d ff ff ff       	jmp    752 <malloc+0x4e>
}
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    

000007e7 <isspace>:

#include "common.h"

int isspace(char c) {
 7e7:	55                   	push   %ebp
 7e8:	89 e5                	mov    %esp,%ebp
 7ea:	83 ec 04             	sub    $0x4,%esp
 7ed:	8b 45 08             	mov    0x8(%ebp),%eax
 7f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 7f3:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 7f7:	74 12                	je     80b <isspace+0x24>
 7f9:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 7fd:	74 0c                	je     80b <isspace+0x24>
 7ff:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 803:	74 06                	je     80b <isspace+0x24>
 805:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 809:	75 07                	jne    812 <isspace+0x2b>
 80b:	b8 01 00 00 00       	mov    $0x1,%eax
 810:	eb 05                	jmp    817 <isspace+0x30>
 812:	b8 00 00 00 00       	mov    $0x0,%eax
}
 817:	c9                   	leave  
 818:	c3                   	ret    

00000819 <readln>:

char* readln(char *buf, int max, int fd)
{
 819:	55                   	push   %ebp
 81a:	89 e5                	mov    %esp,%ebp
 81c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 81f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 826:	eb 45                	jmp    86d <readln+0x54>
    cc = read(fd, &c, 1);
 828:	83 ec 04             	sub    $0x4,%esp
 82b:	6a 01                	push   $0x1
 82d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 830:	50                   	push   %eax
 831:	ff 75 10             	pushl  0x10(%ebp)
 834:	e8 7d fa ff ff       	call   2b6 <read>
 839:	83 c4 10             	add    $0x10,%esp
 83c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 83f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 843:	7f 02                	jg     847 <readln+0x2e>
      break;
 845:	eb 31                	jmp    878 <readln+0x5f>
    buf[i++] = c;
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8d 50 01             	lea    0x1(%eax),%edx
 84d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 850:	89 c2                	mov    %eax,%edx
 852:	8b 45 08             	mov    0x8(%ebp),%eax
 855:	01 c2                	add    %eax,%edx
 857:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 85b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 85d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 861:	3c 0a                	cmp    $0xa,%al
 863:	74 13                	je     878 <readln+0x5f>
 865:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 869:	3c 0d                	cmp    $0xd,%al
 86b:	74 0b                	je     878 <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	83 c0 01             	add    $0x1,%eax
 873:	3b 45 0c             	cmp    0xc(%ebp),%eax
 876:	7c b0                	jl     828 <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 878:	8b 55 f4             	mov    -0xc(%ebp),%edx
 87b:	8b 45 08             	mov    0x8(%ebp),%eax
 87e:	01 d0                	add    %edx,%eax
 880:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 883:	8b 45 08             	mov    0x8(%ebp),%eax
}
 886:	c9                   	leave  
 887:	c3                   	ret    

00000888 <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 888:	55                   	push   %ebp
 889:	89 e5                	mov    %esp,%ebp
 88b:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 88e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 895:	eb 19                	jmp    8b0 <strncpy+0x28>
		dest[i] = src[i];
 897:	8b 55 fc             	mov    -0x4(%ebp),%edx
 89a:	8b 45 08             	mov    0x8(%ebp),%eax
 89d:	01 c2                	add    %eax,%edx
 89f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 8a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a5:	01 c8                	add    %ecx,%eax
 8a7:	0f b6 00             	movzbl (%eax),%eax
 8aa:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8ac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b3:	3b 45 10             	cmp    0x10(%ebp),%eax
 8b6:	7d 0f                	jge    8c7 <strncpy+0x3f>
 8b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 8be:	01 d0                	add    %edx,%eax
 8c0:	0f b6 00             	movzbl (%eax),%eax
 8c3:	84 c0                	test   %al,%al
 8c5:	75 d0                	jne    897 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 8c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8ca:	c9                   	leave  
 8cb:	c3                   	ret    

000008cc <trim>:

char* trim(char* orig) {
 8cc:	55                   	push   %ebp
 8cd:	89 e5                	mov    %esp,%ebp
 8cf:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 8d2:	8b 45 08             	mov    0x8(%ebp),%eax
 8d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 8d8:	8b 45 08             	mov    0x8(%ebp),%eax
 8db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 8de:	eb 04                	jmp    8e4 <trim+0x18>
 8e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	0f b6 00             	movzbl (%eax),%eax
 8ea:	0f be c0             	movsbl %al,%eax
 8ed:	50                   	push   %eax
 8ee:	e8 f4 fe ff ff       	call   7e7 <isspace>
 8f3:	83 c4 04             	add    $0x4,%esp
 8f6:	85 c0                	test   %eax,%eax
 8f8:	75 e6                	jne    8e0 <trim+0x14>
	while (*tail) { tail++; }
 8fa:	eb 04                	jmp    900 <trim+0x34>
 8fc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 900:	8b 45 f0             	mov    -0x10(%ebp),%eax
 903:	0f b6 00             	movzbl (%eax),%eax
 906:	84 c0                	test   %al,%al
 908:	75 f2                	jne    8fc <trim+0x30>
	do { tail--; } while (isspace(*tail));
 90a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 90e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 911:	0f b6 00             	movzbl (%eax),%eax
 914:	0f be c0             	movsbl %al,%eax
 917:	50                   	push   %eax
 918:	e8 ca fe ff ff       	call   7e7 <isspace>
 91d:	83 c4 04             	add    $0x4,%esp
 920:	85 c0                	test   %eax,%eax
 922:	75 e6                	jne    90a <trim+0x3e>
	new = malloc(tail-head+2);
 924:	8b 55 f0             	mov    -0x10(%ebp),%edx
 927:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92a:	29 c2                	sub    %eax,%edx
 92c:	89 d0                	mov    %edx,%eax
 92e:	83 c0 02             	add    $0x2,%eax
 931:	83 ec 0c             	sub    $0xc,%esp
 934:	50                   	push   %eax
 935:	e8 ca fd ff ff       	call   704 <malloc>
 93a:	83 c4 10             	add    $0x10,%esp
 93d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 940:	8b 55 f0             	mov    -0x10(%ebp),%edx
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	29 c2                	sub    %eax,%edx
 948:	89 d0                	mov    %edx,%eax
 94a:	83 c0 01             	add    $0x1,%eax
 94d:	83 ec 04             	sub    $0x4,%esp
 950:	50                   	push   %eax
 951:	ff 75 f4             	pushl  -0xc(%ebp)
 954:	ff 75 ec             	pushl  -0x14(%ebp)
 957:	e8 2c ff ff ff       	call   888 <strncpy>
 95c:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 95f:	8b 55 f0             	mov    -0x10(%ebp),%edx
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	29 c2                	sub    %eax,%edx
 967:	89 d0                	mov    %edx,%eax
 969:	8d 50 01             	lea    0x1(%eax),%edx
 96c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 96f:	01 d0                	add    %edx,%eax
 971:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 974:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 977:	c9                   	leave  
 978:	c3                   	ret    

00000979 <itoa>:

char *
itoa(int value)
{
 979:	55                   	push   %ebp
 97a:	89 e5                	mov    %esp,%ebp
 97c:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 97f:	8d 45 bf             	lea    -0x41(%ebp),%eax
 982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 985:	8b 45 08             	mov    0x8(%ebp),%eax
 988:	c1 e8 1f             	shr    $0x1f,%eax
 98b:	0f b6 c0             	movzbl %al,%eax
 98e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 991:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 995:	74 0a                	je     9a1 <itoa+0x28>
    v = -value;
 997:	8b 45 08             	mov    0x8(%ebp),%eax
 99a:	f7 d8                	neg    %eax
 99c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99f:	eb 06                	jmp    9a7 <itoa+0x2e>
  else
    v = (uint)value;
 9a1:	8b 45 08             	mov    0x8(%ebp),%eax
 9a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 9a7:	eb 5b                	jmp    a04 <itoa+0x8b>
  {
    i = v % 10;
 9a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 9ac:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9b1:	89 c8                	mov    %ecx,%eax
 9b3:	f7 e2                	mul    %edx
 9b5:	c1 ea 03             	shr    $0x3,%edx
 9b8:	89 d0                	mov    %edx,%eax
 9ba:	c1 e0 02             	shl    $0x2,%eax
 9bd:	01 d0                	add    %edx,%eax
 9bf:	01 c0                	add    %eax,%eax
 9c1:	29 c1                	sub    %eax,%ecx
 9c3:	89 ca                	mov    %ecx,%edx
 9c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 9c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cb:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9d0:	f7 e2                	mul    %edx
 9d2:	89 d0                	mov    %edx,%eax
 9d4:	c1 e8 03             	shr    $0x3,%eax
 9d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 9da:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 9de:	7f 13                	jg     9f3 <itoa+0x7a>
      *tp++ = i+'0';
 9e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e3:	8d 50 01             	lea    0x1(%eax),%edx
 9e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9ec:	83 c2 30             	add    $0x30,%edx
 9ef:	88 10                	mov    %dl,(%eax)
 9f1:	eb 11                	jmp    a04 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 9f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f6:	8d 50 01             	lea    0x1(%eax),%edx
 9f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 9ff:	83 c2 57             	add    $0x57,%edx
 a02:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 a04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a08:	75 9f                	jne    9a9 <itoa+0x30>
 a0a:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a0d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a10:	74 97                	je     9a9 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a15:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a18:	29 c2                	sub    %eax,%edx
 a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a1d:	01 d0                	add    %edx,%eax
 a1f:	83 c0 01             	add    $0x1,%eax
 a22:	83 ec 0c             	sub    $0xc,%esp
 a25:	50                   	push   %eax
 a26:	e8 d9 fc ff ff       	call   704 <malloc>
 a2b:	83 c4 10             	add    $0x10,%esp
 a2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a34:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a37:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a3b:	74 0c                	je     a49 <itoa+0xd0>
    *sp++ = '-';
 a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a40:	8d 50 01             	lea    0x1(%eax),%edx
 a43:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a46:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a49:	eb 15                	jmp    a60 <itoa+0xe7>
    *sp++ = *--tp;
 a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a4e:	8d 50 01             	lea    0x1(%eax),%edx
 a51:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a54:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a5b:	0f b6 12             	movzbl (%edx),%edx
 a5e:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 a60:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a63:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a66:	77 e3                	ja     a4b <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 a68:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a6b:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 a6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 a71:	c9                   	leave  
 a72:	c3                   	ret    

00000a73 <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 a73:	55                   	push   %ebp
 a74:	89 e5                	mov    %esp,%ebp
 a76:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 a7c:	83 ec 08             	sub    $0x8,%esp
 a7f:	6a 00                	push   $0x0
 a81:	ff 75 08             	pushl  0x8(%ebp)
 a84:	e8 55 f8 ff ff       	call   2de <open>
 a89:	83 c4 10             	add    $0x10,%esp
 a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 a8f:	e9 22 01 00 00       	jmp    bb6 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 a94:	83 ec 08             	sub    $0x8,%esp
 a97:	6a 3d                	push   $0x3d
 a99:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 a9f:	50                   	push   %eax
 aa0:	e8 79 f6 ff ff       	call   11e <strchr>
 aa5:	83 c4 10             	add    $0x10,%esp
 aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 aab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 aaf:	0f 84 23 01 00 00    	je     bd8 <parseEnvFile+0x165>
 ab5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ab9:	0f 84 19 01 00 00    	je     bd8 <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 abf:	8b 55 f0             	mov    -0x10(%ebp),%edx
 ac2:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ac8:	29 c2                	sub    %eax,%edx
 aca:	89 d0                	mov    %edx,%eax
 acc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ad2:	83 c0 01             	add    $0x1,%eax
 ad5:	83 ec 0c             	sub    $0xc,%esp
 ad8:	50                   	push   %eax
 ad9:	e8 26 fc ff ff       	call   704 <malloc>
 ade:	83 c4 10             	add    $0x10,%esp
 ae1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 ae4:	83 ec 04             	sub    $0x4,%esp
 ae7:	ff 75 ec             	pushl  -0x14(%ebp)
 aea:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 af0:	50                   	push   %eax
 af1:	ff 75 e8             	pushl  -0x18(%ebp)
 af4:	e8 8f fd ff ff       	call   888 <strncpy>
 af9:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 afc:	83 ec 0c             	sub    $0xc,%esp
 aff:	ff 75 e8             	pushl  -0x18(%ebp)
 b02:	e8 c5 fd ff ff       	call   8cc <trim>
 b07:	83 c4 10             	add    $0x10,%esp
 b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 b0d:	83 ec 0c             	sub    $0xc,%esp
 b10:	ff 75 e8             	pushl  -0x18(%ebp)
 b13:	e8 ab fa ff ff       	call   5c3 <free>
 b18:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 b1b:	83 ec 08             	sub    $0x8,%esp
 b1e:	ff 75 0c             	pushl  0xc(%ebp)
 b21:	ff 75 e4             	pushl  -0x1c(%ebp)
 b24:	e8 c2 01 00 00       	call   ceb <addToEnvironment>
 b29:	83 c4 10             	add    $0x10,%esp
 b2c:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b2f:	83 ec 0c             	sub    $0xc,%esp
 b32:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b38:	50                   	push   %eax
 b39:	e8 9f f5 ff ff       	call   dd <strlen>
 b3e:	83 c4 10             	add    $0x10,%esp
 b41:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b47:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b4a:	83 ec 0c             	sub    $0xc,%esp
 b4d:	50                   	push   %eax
 b4e:	e8 b1 fb ff ff       	call   704 <malloc>
 b53:	83 c4 10             	add    $0x10,%esp
 b56:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b5c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b5f:	8d 50 ff             	lea    -0x1(%eax),%edx
 b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b65:	8d 48 01             	lea    0x1(%eax),%ecx
 b68:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b6e:	01 c8                	add    %ecx,%eax
 b70:	83 ec 04             	sub    $0x4,%esp
 b73:	52                   	push   %edx
 b74:	50                   	push   %eax
 b75:	ff 75 e8             	pushl  -0x18(%ebp)
 b78:	e8 0b fd ff ff       	call   888 <strncpy>
 b7d:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 b80:	83 ec 0c             	sub    $0xc,%esp
 b83:	ff 75 e8             	pushl  -0x18(%ebp)
 b86:	e8 41 fd ff ff       	call   8cc <trim>
 b8b:	83 c4 10             	add    $0x10,%esp
 b8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 b91:	83 ec 0c             	sub    $0xc,%esp
 b94:	ff 75 e8             	pushl  -0x18(%ebp)
 b97:	e8 27 fa ff ff       	call   5c3 <free>
 b9c:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 b9f:	83 ec 04             	sub    $0x4,%esp
 ba2:	ff 75 dc             	pushl  -0x24(%ebp)
 ba5:	ff 75 0c             	pushl  0xc(%ebp)
 ba8:	ff 75 e4             	pushl  -0x1c(%ebp)
 bab:	e8 b8 01 00 00       	call   d68 <addValueToVariable>
 bb0:	83 c4 10             	add    $0x10,%esp
 bb3:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 bb6:	83 ec 04             	sub    $0x4,%esp
 bb9:	ff 75 f4             	pushl  -0xc(%ebp)
 bbc:	68 00 04 00 00       	push   $0x400
 bc1:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 bc7:	50                   	push   %eax
 bc8:	e8 4c fc ff ff       	call   819 <readln>
 bcd:	83 c4 10             	add    $0x10,%esp
 bd0:	85 c0                	test   %eax,%eax
 bd2:	0f 85 bc fe ff ff    	jne    a94 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 bd8:	83 ec 0c             	sub    $0xc,%esp
 bdb:	ff 75 f4             	pushl  -0xc(%ebp)
 bde:	e8 e3 f6 ff ff       	call   2c6 <close>
 be3:	83 c4 10             	add    $0x10,%esp
	return head;
 be6:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 be9:	c9                   	leave  
 bea:	c3                   	ret    

00000beb <comp>:

int comp(const char* s1, const char* s2)
{
 beb:	55                   	push   %ebp
 bec:	89 e5                	mov    %esp,%ebp
 bee:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 bf1:	83 ec 08             	sub    $0x8,%esp
 bf4:	ff 75 0c             	pushl  0xc(%ebp)
 bf7:	ff 75 08             	pushl  0x8(%ebp)
 bfa:	e8 9f f4 ff ff       	call   9e <strcmp>
 bff:	83 c4 10             	add    $0x10,%esp
 c02:	85 c0                	test   %eax,%eax
 c04:	0f 94 c0             	sete   %al
 c07:	0f b6 c0             	movzbl %al,%eax
}
 c0a:	c9                   	leave  
 c0b:	c3                   	ret    

00000c0c <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 c0c:	55                   	push   %ebp
 c0d:	89 e5                	mov    %esp,%ebp
 c0f:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c16:	75 07                	jne    c1f <environLookup+0x13>
    return NULL;
 c18:	b8 00 00 00 00       	mov    $0x0,%eax
 c1d:	eb 2f                	jmp    c4e <environLookup+0x42>
  
  while (head)
 c1f:	eb 24                	jmp    c45 <environLookup+0x39>
  {
    if (comp(name, head->name))
 c21:	8b 45 0c             	mov    0xc(%ebp),%eax
 c24:	83 ec 08             	sub    $0x8,%esp
 c27:	50                   	push   %eax
 c28:	ff 75 08             	pushl  0x8(%ebp)
 c2b:	e8 bb ff ff ff       	call   beb <comp>
 c30:	83 c4 10             	add    $0x10,%esp
 c33:	85 c0                	test   %eax,%eax
 c35:	74 02                	je     c39 <environLookup+0x2d>
      break;
 c37:	eb 12                	jmp    c4b <environLookup+0x3f>
    head = head->next;
 c39:	8b 45 0c             	mov    0xc(%ebp),%eax
 c3c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c42:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c49:	75 d6                	jne    c21 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c4e:	c9                   	leave  
 c4f:	c3                   	ret    

00000c50 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c50:	55                   	push   %ebp
 c51:	89 e5                	mov    %esp,%ebp
 c53:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c5a:	75 0a                	jne    c66 <removeFromEnvironment+0x16>
    return NULL;
 c5c:	b8 00 00 00 00       	mov    $0x0,%eax
 c61:	e9 83 00 00 00       	jmp    ce9 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 c66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c6a:	74 0a                	je     c76 <removeFromEnvironment+0x26>
 c6c:	8b 45 08             	mov    0x8(%ebp),%eax
 c6f:	0f b6 00             	movzbl (%eax),%eax
 c72:	84 c0                	test   %al,%al
 c74:	75 05                	jne    c7b <removeFromEnvironment+0x2b>
    return head;
 c76:	8b 45 0c             	mov    0xc(%ebp),%eax
 c79:	eb 6e                	jmp    ce9 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
 c7e:	83 ec 08             	sub    $0x8,%esp
 c81:	ff 75 08             	pushl  0x8(%ebp)
 c84:	50                   	push   %eax
 c85:	e8 61 ff ff ff       	call   beb <comp>
 c8a:	83 c4 10             	add    $0x10,%esp
 c8d:	85 c0                	test   %eax,%eax
 c8f:	74 34                	je     cc5 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 c91:	8b 45 0c             	mov    0xc(%ebp),%eax
 c94:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
 ca0:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 ca6:	83 ec 0c             	sub    $0xc,%esp
 ca9:	50                   	push   %eax
 caa:	e8 74 01 00 00       	call   e23 <freeVarval>
 caf:	83 c4 10             	add    $0x10,%esp
    free(head);
 cb2:	83 ec 0c             	sub    $0xc,%esp
 cb5:	ff 75 0c             	pushl  0xc(%ebp)
 cb8:	e8 06 f9 ff ff       	call   5c3 <free>
 cbd:	83 c4 10             	add    $0x10,%esp
    return tmp;
 cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cc3:	eb 24                	jmp    ce9 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
 cc8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 cce:	83 ec 08             	sub    $0x8,%esp
 cd1:	50                   	push   %eax
 cd2:	ff 75 08             	pushl  0x8(%ebp)
 cd5:	e8 76 ff ff ff       	call   c50 <removeFromEnvironment>
 cda:	83 c4 10             	add    $0x10,%esp
 cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
 ce0:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 ce9:	c9                   	leave  
 cea:	c3                   	ret    

00000ceb <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 ceb:	55                   	push   %ebp
 cec:	89 e5                	mov    %esp,%ebp
 cee:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 cf1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 cf5:	75 05                	jne    cfc <addToEnvironment+0x11>
		return head;
 cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
 cfa:	eb 6a                	jmp    d66 <addToEnvironment+0x7b>
	if (head == NULL) {
 cfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 d00:	75 40                	jne    d42 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 d02:	83 ec 0c             	sub    $0xc,%esp
 d05:	68 88 00 00 00       	push   $0x88
 d0a:	e8 f5 f9 ff ff       	call   704 <malloc>
 d0f:	83 c4 10             	add    $0x10,%esp
 d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 d15:	8b 45 08             	mov    0x8(%ebp),%eax
 d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1e:	83 ec 08             	sub    $0x8,%esp
 d21:	ff 75 f0             	pushl  -0x10(%ebp)
 d24:	50                   	push   %eax
 d25:	e8 44 f3 ff ff       	call   6e <strcpy>
 d2a:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d30:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d37:	00 00 00 
		head = newVar;
 d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d3d:	89 45 0c             	mov    %eax,0xc(%ebp)
 d40:	eb 21                	jmp    d63 <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d42:	8b 45 0c             	mov    0xc(%ebp),%eax
 d45:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d4b:	83 ec 08             	sub    $0x8,%esp
 d4e:	50                   	push   %eax
 d4f:	ff 75 08             	pushl  0x8(%ebp)
 d52:	e8 94 ff ff ff       	call   ceb <addToEnvironment>
 d57:	83 c4 10             	add    $0x10,%esp
 d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
 d5d:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 d63:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d66:	c9                   	leave  
 d67:	c3                   	ret    

00000d68 <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 d68:	55                   	push   %ebp
 d69:	89 e5                	mov    %esp,%ebp
 d6b:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 d6e:	83 ec 08             	sub    $0x8,%esp
 d71:	ff 75 0c             	pushl  0xc(%ebp)
 d74:	ff 75 08             	pushl  0x8(%ebp)
 d77:	e8 90 fe ff ff       	call   c0c <environLookup>
 d7c:	83 c4 10             	add    $0x10,%esp
 d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 d82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d86:	75 05                	jne    d8d <addValueToVariable+0x25>
		return head;
 d88:	8b 45 0c             	mov    0xc(%ebp),%eax
 d8b:	eb 4c                	jmp    dd9 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 d8d:	83 ec 0c             	sub    $0xc,%esp
 d90:	68 04 04 00 00       	push   $0x404
 d95:	e8 6a f9 ff ff       	call   704 <malloc>
 d9a:	83 c4 10             	add    $0x10,%esp
 d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 da0:	8b 45 10             	mov    0x10(%ebp),%eax
 da3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 da9:	83 ec 08             	sub    $0x8,%esp
 dac:	ff 75 ec             	pushl  -0x14(%ebp)
 daf:	50                   	push   %eax
 db0:	e8 b9 f2 ff ff       	call   6e <strcpy>
 db5:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dbb:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dc4:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
 dd0:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 dd9:	c9                   	leave  
 dda:	c3                   	ret    

00000ddb <freeEnvironment>:

void freeEnvironment(variable* head)
{
 ddb:	55                   	push   %ebp
 ddc:	89 e5                	mov    %esp,%ebp
 dde:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 de1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 de5:	75 02                	jne    de9 <freeEnvironment+0xe>
    return;  
 de7:	eb 38                	jmp    e21 <freeEnvironment+0x46>
  freeEnvironment(head->next);
 de9:	8b 45 08             	mov    0x8(%ebp),%eax
 dec:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 df2:	83 ec 0c             	sub    $0xc,%esp
 df5:	50                   	push   %eax
 df6:	e8 e0 ff ff ff       	call   ddb <freeEnvironment>
 dfb:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 dfe:	8b 45 08             	mov    0x8(%ebp),%eax
 e01:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 e07:	83 ec 0c             	sub    $0xc,%esp
 e0a:	50                   	push   %eax
 e0b:	e8 13 00 00 00       	call   e23 <freeVarval>
 e10:	83 c4 10             	add    $0x10,%esp
  free(head);
 e13:	83 ec 0c             	sub    $0xc,%esp
 e16:	ff 75 08             	pushl  0x8(%ebp)
 e19:	e8 a5 f7 ff ff       	call   5c3 <free>
 e1e:	83 c4 10             	add    $0x10,%esp
}
 e21:	c9                   	leave  
 e22:	c3                   	ret    

00000e23 <freeVarval>:

void freeVarval(varval* head)
{
 e23:	55                   	push   %ebp
 e24:	89 e5                	mov    %esp,%ebp
 e26:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e2d:	75 02                	jne    e31 <freeVarval+0xe>
    return;  
 e2f:	eb 23                	jmp    e54 <freeVarval+0x31>
  freeVarval(head->next);
 e31:	8b 45 08             	mov    0x8(%ebp),%eax
 e34:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e3a:	83 ec 0c             	sub    $0xc,%esp
 e3d:	50                   	push   %eax
 e3e:	e8 e0 ff ff ff       	call   e23 <freeVarval>
 e43:	83 c4 10             	add    $0x10,%esp
  free(head);
 e46:	83 ec 0c             	sub    $0xc,%esp
 e49:	ff 75 08             	pushl  0x8(%ebp)
 e4c:	e8 72 f7 ff ff       	call   5c3 <free>
 e51:	83 c4 10             	add    $0x10,%esp
}
 e54:	c9                   	leave  
 e55:	c3                   	ret    

00000e56 <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e56:	55                   	push   %ebp
 e57:	89 e5                	mov    %esp,%ebp
 e59:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 e5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e60:	75 08                	jne    e6a <getPaths+0x14>
		return head;
 e62:	8b 45 0c             	mov    0xc(%ebp),%eax
 e65:	e9 e7 00 00 00       	jmp    f51 <getPaths+0xfb>
	if (head == NULL) {
 e6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 e6e:	0f 85 b9 00 00 00    	jne    f2d <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 e74:	83 ec 08             	sub    $0x8,%esp
 e77:	6a 3a                	push   $0x3a
 e79:	ff 75 08             	pushl  0x8(%ebp)
 e7c:	e8 9d f2 ff ff       	call   11e <strchr>
 e81:	83 c4 10             	add    $0x10,%esp
 e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 e87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e8b:	75 56                	jne    ee3 <getPaths+0x8d>
			pathLen = strlen(paths);
 e8d:	83 ec 0c             	sub    $0xc,%esp
 e90:	ff 75 08             	pushl  0x8(%ebp)
 e93:	e8 45 f2 ff ff       	call   dd <strlen>
 e98:	83 c4 10             	add    $0x10,%esp
 e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 e9e:	83 ec 0c             	sub    $0xc,%esp
 ea1:	68 04 04 00 00       	push   $0x404
 ea6:	e8 59 f8 ff ff       	call   704 <malloc>
 eab:	83 c4 10             	add    $0x10,%esp
 eae:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
 eb4:	83 ec 04             	sub    $0x4,%esp
 eb7:	ff 75 f0             	pushl  -0x10(%ebp)
 eba:	ff 75 08             	pushl  0x8(%ebp)
 ebd:	50                   	push   %eax
 ebe:	e8 c5 f9 ff ff       	call   888 <strncpy>
 ec3:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
 ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ecc:	01 d0                	add    %edx,%eax
 ece:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
 ed4:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 edb:	00 00 00 
			return head;
 ede:	8b 45 0c             	mov    0xc(%ebp),%eax
 ee1:	eb 6e                	jmp    f51 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ee6:	8b 45 08             	mov    0x8(%ebp),%eax
 ee9:	29 c2                	sub    %eax,%edx
 eeb:	89 d0                	mov    %edx,%eax
 eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 ef0:	83 ec 0c             	sub    $0xc,%esp
 ef3:	68 04 04 00 00       	push   $0x404
 ef8:	e8 07 f8 ff ff       	call   704 <malloc>
 efd:	83 c4 10             	add    $0x10,%esp
 f00:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 f03:	8b 45 0c             	mov    0xc(%ebp),%eax
 f06:	83 ec 04             	sub    $0x4,%esp
 f09:	ff 75 f0             	pushl  -0x10(%ebp)
 f0c:	ff 75 08             	pushl  0x8(%ebp)
 f0f:	50                   	push   %eax
 f10:	e8 73 f9 ff ff       	call   888 <strncpy>
 f15:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f18:	8b 55 0c             	mov    0xc(%ebp),%edx
 f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f1e:	01 d0                	add    %edx,%eax
 f20:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f26:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 f29:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
 f30:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f36:	83 ec 08             	sub    $0x8,%esp
 f39:	50                   	push   %eax
 f3a:	ff 75 08             	pushl  0x8(%ebp)
 f3d:	e8 14 ff ff ff       	call   e56 <getPaths>
 f42:	83 c4 10             	add    $0x10,%esp
 f45:	8b 55 0c             	mov    0xc(%ebp),%edx
 f48:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f51:	c9                   	leave  
 f52:	c3                   	ret    
