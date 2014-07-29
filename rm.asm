
_rm:     формат файла elf32-i386


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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: rm files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 9a 0f 00 00       	push   $0xf9a
  21:	6a 02                	push   $0x2
  23:	e8 52 04 00 00       	call   47a <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 b5 02 00 00       	call   2e5 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(unlink(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e2 02 00 00       	call   335 <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 ae 0f 00 00       	push   $0xfae
  74:	6a 02                	push   $0x2
  76:	e8 ff 03 00 00       	call   47a <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  8b:	e8 55 02 00 00       	call   2e5 <exit>

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	8d 50 01             	lea    0x1(%eax),%edx
  c8:	89 55 08             	mov    %edx,0x8(%ebp)
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d4:	0f b6 12             	movzbl (%edx),%edx
  d7:	88 10                	mov    %dl,(%eax)
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	75 e2                	jne    c2 <strcpy+0xd>
    ;
  return os;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e8:	eb 08                	jmp    f2 <strcmp+0xd>
    p++, q++;
  ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	84 c0                	test   %al,%al
  fa:	74 10                	je     10c <strcmp+0x27>
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	0f b6 10             	movzbl (%eax),%edx
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	38 c2                	cmp    %al,%dl
 10a:	74 de                	je     ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	0f b6 d0             	movzbl %al,%edx
 115:	8b 45 0c             	mov    0xc(%ebp),%eax
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	0f b6 c0             	movzbl %al,%eax
 11e:	29 c2                	sub    %eax,%edx
 120:	89 d0                	mov    %edx,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strlen>:

uint
strlen(char *s)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 131:	eb 04                	jmp    137 <strlen+0x13>
 133:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 137:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	01 d0                	add    %edx,%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	84 c0                	test   %al,%al
 144:	75 ed                	jne    133 <strlen+0xf>
    ;
  return n;
 146:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <memset>:

void*
memset(void *dst, int c, uint n)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14e:	8b 45 10             	mov    0x10(%ebp),%eax
 151:	50                   	push   %eax
 152:	ff 75 0c             	pushl  0xc(%ebp)
 155:	ff 75 08             	pushl  0x8(%ebp)
 158:	e8 33 ff ff ff       	call   90 <stosb>
 15d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strchr>:

char*
strchr(const char *s, char c)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 171:	eb 14                	jmp    187 <strchr+0x22>
    if(*s == c)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17c:	75 05                	jne    183 <strchr+0x1e>
      return (char*)s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	eb 13                	jmp    196 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 183:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 e2                	jne    173 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a5:	eb 44                	jmp    1eb <gets+0x53>
    cc = read(0, &c, 1);
 1a7:	83 ec 04             	sub    $0x4,%esp
 1aa:	6a 01                	push   $0x1
 1ac:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1af:	50                   	push   %eax
 1b0:	6a 00                	push   $0x0
 1b2:	e8 46 01 00 00       	call   2fd <read>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c1:	7f 02                	jg     1c5 <gets+0x2d>
      break;
 1c3:	eb 31                	jmp    1f6 <gets+0x5e>
    buf[i++] = c;
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	8d 50 01             	lea    0x1(%eax),%edx
 1cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ce:	89 c2                	mov    %eax,%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 c2                	add    %eax,%edx
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1db:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1df:	3c 0a                	cmp    $0xa,%al
 1e1:	74 13                	je     1f6 <gets+0x5e>
 1e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e7:	3c 0d                	cmp    $0xd,%al
 1e9:	74 0b                	je     1f6 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ee:	83 c0 01             	add    $0x1,%eax
 1f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f4:	7c b1                	jl     1a7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 201:	8b 45 08             	mov    0x8(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <stat>:

int
stat(char *n, struct stat *st)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	83 ec 08             	sub    $0x8,%esp
 20f:	6a 00                	push   $0x0
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	e8 0c 01 00 00       	call   325 <open>
 219:	83 c4 10             	add    $0x10,%esp
 21c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 223:	79 07                	jns    22c <stat+0x26>
    return -1;
 225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22a:	eb 25                	jmp    251 <stat+0x4b>
  r = fstat(fd, st);
 22c:	83 ec 08             	sub    $0x8,%esp
 22f:	ff 75 0c             	pushl  0xc(%ebp)
 232:	ff 75 f4             	pushl  -0xc(%ebp)
 235:	e8 03 01 00 00       	call   33d <fstat>
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 240:	83 ec 0c             	sub    $0xc,%esp
 243:	ff 75 f4             	pushl  -0xc(%ebp)
 246:	e8 c2 00 00 00       	call   30d <close>
 24b:	83 c4 10             	add    $0x10,%esp
  return r;
 24e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <atoi>:

int
atoi(const char *s)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 260:	eb 25                	jmp    287 <atoi+0x34>
    n = n*10 + *s++ - '0';
 262:	8b 55 fc             	mov    -0x4(%ebp),%edx
 265:	89 d0                	mov    %edx,%eax
 267:	c1 e0 02             	shl    $0x2,%eax
 26a:	01 d0                	add    %edx,%eax
 26c:	01 c0                	add    %eax,%eax
 26e:	89 c1                	mov    %eax,%ecx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	8d 50 01             	lea    0x1(%eax),%edx
 276:	89 55 08             	mov    %edx,0x8(%ebp)
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	0f be c0             	movsbl %al,%eax
 27f:	01 c8                	add    %ecx,%eax
 281:	83 e8 30             	sub    $0x30,%eax
 284:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	0f b6 00             	movzbl (%eax),%eax
 28d:	3c 2f                	cmp    $0x2f,%al
 28f:	7e 0a                	jle    29b <atoi+0x48>
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	3c 39                	cmp    $0x39,%al
 299:	7e c7                	jle    262 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b2:	eb 17                	jmp    2cb <memmove+0x2b>
    *dst++ = *src++;
 2b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b7:	8d 50 01             	lea    0x1(%eax),%edx
 2ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c0:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c6:	0f b6 12             	movzbl (%edx),%edx
 2c9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2cb:	8b 45 10             	mov    0x10(%ebp),%eax
 2ce:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d1:	89 55 10             	mov    %edx,0x10(%ebp)
 2d4:	85 c0                	test   %eax,%eax
 2d6:	7f dc                	jg     2b4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    

000002dd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2dd:	b8 01 00 00 00       	mov    $0x1,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <exit>:
SYSCALL(exit)
 2e5:	b8 02 00 00 00       	mov    $0x2,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <wait>:
SYSCALL(wait)
 2ed:	b8 03 00 00 00       	mov    $0x3,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <pipe>:
SYSCALL(pipe)
 2f5:	b8 04 00 00 00       	mov    $0x4,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <read>:
SYSCALL(read)
 2fd:	b8 05 00 00 00       	mov    $0x5,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <write>:
SYSCALL(write)
 305:	b8 10 00 00 00       	mov    $0x10,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <close>:
SYSCALL(close)
 30d:	b8 15 00 00 00       	mov    $0x15,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <kill>:
SYSCALL(kill)
 315:	b8 06 00 00 00       	mov    $0x6,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <exec>:
SYSCALL(exec)
 31d:	b8 07 00 00 00       	mov    $0x7,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <open>:
SYSCALL(open)
 325:	b8 0f 00 00 00       	mov    $0xf,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <mknod>:
SYSCALL(mknod)
 32d:	b8 11 00 00 00       	mov    $0x11,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <unlink>:
SYSCALL(unlink)
 335:	b8 12 00 00 00       	mov    $0x12,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <fstat>:
SYSCALL(fstat)
 33d:	b8 08 00 00 00       	mov    $0x8,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <link>:
SYSCALL(link)
 345:	b8 13 00 00 00       	mov    $0x13,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <mkdir>:
SYSCALL(mkdir)
 34d:	b8 14 00 00 00       	mov    $0x14,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <chdir>:
SYSCALL(chdir)
 355:	b8 09 00 00 00       	mov    $0x9,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <dup>:
SYSCALL(dup)
 35d:	b8 0a 00 00 00       	mov    $0xa,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <getpid>:
SYSCALL(getpid)
 365:	b8 0b 00 00 00       	mov    $0xb,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <sbrk>:
SYSCALL(sbrk)
 36d:	b8 0c 00 00 00       	mov    $0xc,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <sleep>:
SYSCALL(sleep)
 375:	b8 0d 00 00 00       	mov    $0xd,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <uptime>:
SYSCALL(uptime)
 37d:	b8 0e 00 00 00       	mov    $0xe,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <getcwd>:
SYSCALL(getcwd)
 385:	b8 16 00 00 00       	mov    $0x16,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <shutdown>:
SYSCALL(shutdown)
 38d:	b8 17 00 00 00       	mov    $0x17,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <buildinfo>:
SYSCALL(buildinfo)
 395:	b8 18 00 00 00       	mov    $0x18,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <lseek>:
SYSCALL(lseek)
 39d:	b8 19 00 00 00       	mov    $0x19,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a5:	55                   	push   %ebp
 3a6:	89 e5                	mov    %esp,%ebp
 3a8:	83 ec 18             	sub    $0x18,%esp
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b1:	83 ec 04             	sub    $0x4,%esp
 3b4:	6a 01                	push   $0x1
 3b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b9:	50                   	push   %eax
 3ba:	ff 75 08             	pushl  0x8(%ebp)
 3bd:	e8 43 ff ff ff       	call   305 <write>
 3c2:	83 c4 10             	add    $0x10,%esp
}
 3c5:	c9                   	leave  
 3c6:	c3                   	ret    

000003c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	53                   	push   %ebx
 3cb:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d9:	74 17                	je     3f2 <printint+0x2b>
 3db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3df:	79 11                	jns    3f2 <printint+0x2b>
    neg = 1;
 3e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3eb:	f7 d8                	neg    %eax
 3ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f0:	eb 06                	jmp    3f8 <printint+0x31>
  } else {
    x = xx;
 3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 402:	8d 41 01             	lea    0x1(%ecx),%eax
 405:	89 45 f4             	mov    %eax,-0xc(%ebp)
 408:	8b 5d 10             	mov    0x10(%ebp),%ebx
 40b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40e:	ba 00 00 00 00       	mov    $0x0,%edx
 413:	f7 f3                	div    %ebx
 415:	89 d0                	mov    %edx,%eax
 417:	0f b6 80 dc 13 00 00 	movzbl 0x13dc(%eax),%eax
 41e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 422:	8b 5d 10             	mov    0x10(%ebp),%ebx
 425:	8b 45 ec             	mov    -0x14(%ebp),%eax
 428:	ba 00 00 00 00       	mov    $0x0,%edx
 42d:	f7 f3                	div    %ebx
 42f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 432:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 436:	75 c7                	jne    3ff <printint+0x38>
  if(neg)
 438:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43c:	74 0e                	je     44c <printint+0x85>
    buf[i++] = '-';
 43e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 441:	8d 50 01             	lea    0x1(%eax),%edx
 444:	89 55 f4             	mov    %edx,-0xc(%ebp)
 447:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 44c:	eb 1d                	jmp    46b <printint+0xa4>
    putc(fd, buf[i]);
 44e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 451:	8b 45 f4             	mov    -0xc(%ebp),%eax
 454:	01 d0                	add    %edx,%eax
 456:	0f b6 00             	movzbl (%eax),%eax
 459:	0f be c0             	movsbl %al,%eax
 45c:	83 ec 08             	sub    $0x8,%esp
 45f:	50                   	push   %eax
 460:	ff 75 08             	pushl  0x8(%ebp)
 463:	e8 3d ff ff ff       	call   3a5 <putc>
 468:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 46b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 473:	79 d9                	jns    44e <printint+0x87>
    putc(fd, buf[i]);
}
 475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 478:	c9                   	leave  
 479:	c3                   	ret    

0000047a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
 47d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 480:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 487:	8d 45 0c             	lea    0xc(%ebp),%eax
 48a:	83 c0 04             	add    $0x4,%eax
 48d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 490:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 497:	e9 59 01 00 00       	jmp    5f5 <printf+0x17b>
    c = fmt[i] & 0xff;
 49c:	8b 55 0c             	mov    0xc(%ebp),%edx
 49f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a2:	01 d0                	add    %edx,%eax
 4a4:	0f b6 00             	movzbl (%eax),%eax
 4a7:	0f be c0             	movsbl %al,%eax
 4aa:	25 ff 00 00 00       	and    $0xff,%eax
 4af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b6:	75 2c                	jne    4e4 <printf+0x6a>
      if(c == '%'){
 4b8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4bc:	75 0c                	jne    4ca <printf+0x50>
        state = '%';
 4be:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c5:	e9 27 01 00 00       	jmp    5f1 <printf+0x177>
      } else {
        putc(fd, c);
 4ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4cd:	0f be c0             	movsbl %al,%eax
 4d0:	83 ec 08             	sub    $0x8,%esp
 4d3:	50                   	push   %eax
 4d4:	ff 75 08             	pushl  0x8(%ebp)
 4d7:	e8 c9 fe ff ff       	call   3a5 <putc>
 4dc:	83 c4 10             	add    $0x10,%esp
 4df:	e9 0d 01 00 00       	jmp    5f1 <printf+0x177>
      }
    } else if(state == '%'){
 4e4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e8:	0f 85 03 01 00 00    	jne    5f1 <printf+0x177>
      if(c == 'd'){
 4ee:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f2:	75 1e                	jne    512 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f7:	8b 00                	mov    (%eax),%eax
 4f9:	6a 01                	push   $0x1
 4fb:	6a 0a                	push   $0xa
 4fd:	50                   	push   %eax
 4fe:	ff 75 08             	pushl  0x8(%ebp)
 501:	e8 c1 fe ff ff       	call   3c7 <printint>
 506:	83 c4 10             	add    $0x10,%esp
        ap++;
 509:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50d:	e9 d8 00 00 00       	jmp    5ea <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 512:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 516:	74 06                	je     51e <printf+0xa4>
 518:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51c:	75 1e                	jne    53c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 51e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 521:	8b 00                	mov    (%eax),%eax
 523:	6a 00                	push   $0x0
 525:	6a 10                	push   $0x10
 527:	50                   	push   %eax
 528:	ff 75 08             	pushl  0x8(%ebp)
 52b:	e8 97 fe ff ff       	call   3c7 <printint>
 530:	83 c4 10             	add    $0x10,%esp
        ap++;
 533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 537:	e9 ae 00 00 00       	jmp    5ea <printf+0x170>
      } else if(c == 's'){
 53c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 540:	75 43                	jne    585 <printf+0x10b>
        s = (char*)*ap;
 542:	8b 45 e8             	mov    -0x18(%ebp),%eax
 545:	8b 00                	mov    (%eax),%eax
 547:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 54e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 552:	75 07                	jne    55b <printf+0xe1>
          s = "(null)";
 554:	c7 45 f4 c7 0f 00 00 	movl   $0xfc7,-0xc(%ebp)
        while(*s != 0){
 55b:	eb 1c                	jmp    579 <printf+0xff>
          putc(fd, *s);
 55d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 560:	0f b6 00             	movzbl (%eax),%eax
 563:	0f be c0             	movsbl %al,%eax
 566:	83 ec 08             	sub    $0x8,%esp
 569:	50                   	push   %eax
 56a:	ff 75 08             	pushl  0x8(%ebp)
 56d:	e8 33 fe ff ff       	call   3a5 <putc>
 572:	83 c4 10             	add    $0x10,%esp
          s++;
 575:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 579:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57c:	0f b6 00             	movzbl (%eax),%eax
 57f:	84 c0                	test   %al,%al
 581:	75 da                	jne    55d <printf+0xe3>
 583:	eb 65                	jmp    5ea <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 585:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 589:	75 1d                	jne    5a8 <printf+0x12e>
        putc(fd, *ap);
 58b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58e:	8b 00                	mov    (%eax),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	83 ec 08             	sub    $0x8,%esp
 596:	50                   	push   %eax
 597:	ff 75 08             	pushl  0x8(%ebp)
 59a:	e8 06 fe ff ff       	call   3a5 <putc>
 59f:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a6:	eb 42                	jmp    5ea <printf+0x170>
      } else if(c == '%'){
 5a8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ac:	75 17                	jne    5c5 <printf+0x14b>
        putc(fd, c);
 5ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	83 ec 08             	sub    $0x8,%esp
 5b7:	50                   	push   %eax
 5b8:	ff 75 08             	pushl  0x8(%ebp)
 5bb:	e8 e5 fd ff ff       	call   3a5 <putc>
 5c0:	83 c4 10             	add    $0x10,%esp
 5c3:	eb 25                	jmp    5ea <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c5:	83 ec 08             	sub    $0x8,%esp
 5c8:	6a 25                	push   $0x25
 5ca:	ff 75 08             	pushl  0x8(%ebp)
 5cd:	e8 d3 fd ff ff       	call   3a5 <putc>
 5d2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d8:	0f be c0             	movsbl %al,%eax
 5db:	83 ec 08             	sub    $0x8,%esp
 5de:	50                   	push   %eax
 5df:	ff 75 08             	pushl  0x8(%ebp)
 5e2:	e8 be fd ff ff       	call   3a5 <putc>
 5e7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fb:	01 d0                	add    %edx,%eax
 5fd:	0f b6 00             	movzbl (%eax),%eax
 600:	84 c0                	test   %al,%al
 602:	0f 85 94 fe ff ff    	jne    49c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 608:	c9                   	leave  
 609:	c3                   	ret    

0000060a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60a:	55                   	push   %ebp
 60b:	89 e5                	mov    %esp,%ebp
 60d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 610:	8b 45 08             	mov    0x8(%ebp),%eax
 613:	83 e8 08             	sub    $0x8,%eax
 616:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 619:	a1 f8 13 00 00       	mov    0x13f8,%eax
 61e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 621:	eb 24                	jmp    647 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62b:	77 12                	ja     63f <free+0x35>
 62d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 633:	77 24                	ja     659 <free+0x4f>
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63d:	77 1a                	ja     659 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8b 00                	mov    (%eax),%eax
 644:	89 45 fc             	mov    %eax,-0x4(%ebp)
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64d:	76 d4                	jbe    623 <free+0x19>
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 657:	76 ca                	jbe    623 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	8b 40 04             	mov    0x4(%eax),%eax
 65f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	01 c2                	add    %eax,%edx
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	39 c2                	cmp    %eax,%edx
 672:	75 24                	jne    698 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	8b 50 04             	mov    0x4(%eax),%edx
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	8b 40 04             	mov    0x4(%eax),%eax
 682:	01 c2                	add    %eax,%edx
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	8b 10                	mov    (%eax),%edx
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	89 10                	mov    %edx,(%eax)
 696:	eb 0a                	jmp    6a2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 10                	mov    (%eax),%edx
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 40 04             	mov    0x4(%eax),%eax
 6a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	01 d0                	add    %edx,%eax
 6b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b7:	75 20                	jne    6d9 <free+0xcf>
    p->s.size += bp->s.size;
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 50 04             	mov    0x4(%eax),%edx
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	01 c2                	add    %eax,%edx
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	8b 10                	mov    (%eax),%edx
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	89 10                	mov    %edx,(%eax)
 6d7:	eb 08                	jmp    6e1 <free+0xd7>
  } else
    p->s.ptr = bp;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6df:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	a3 f8 13 00 00       	mov    %eax,0x13f8
}
 6e9:	c9                   	leave  
 6ea:	c3                   	ret    

000006eb <morecore>:

static Header*
morecore(uint nu)
{
 6eb:	55                   	push   %ebp
 6ec:	89 e5                	mov    %esp,%ebp
 6ee:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f8:	77 07                	ja     701 <morecore+0x16>
    nu = 4096;
 6fa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 701:	8b 45 08             	mov    0x8(%ebp),%eax
 704:	c1 e0 03             	shl    $0x3,%eax
 707:	83 ec 0c             	sub    $0xc,%esp
 70a:	50                   	push   %eax
 70b:	e8 5d fc ff ff       	call   36d <sbrk>
 710:	83 c4 10             	add    $0x10,%esp
 713:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 716:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 71a:	75 07                	jne    723 <morecore+0x38>
    return 0;
 71c:	b8 00 00 00 00       	mov    $0x0,%eax
 721:	eb 26                	jmp    749 <morecore+0x5e>
  hp = (Header*)p;
 723:	8b 45 f4             	mov    -0xc(%ebp),%eax
 726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 729:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72c:	8b 55 08             	mov    0x8(%ebp),%edx
 72f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 732:	8b 45 f0             	mov    -0x10(%ebp),%eax
 735:	83 c0 08             	add    $0x8,%eax
 738:	83 ec 0c             	sub    $0xc,%esp
 73b:	50                   	push   %eax
 73c:	e8 c9 fe ff ff       	call   60a <free>
 741:	83 c4 10             	add    $0x10,%esp
  return freep;
 744:	a1 f8 13 00 00       	mov    0x13f8,%eax
}
 749:	c9                   	leave  
 74a:	c3                   	ret    

0000074b <malloc>:

void*
malloc(uint nbytes)
{
 74b:	55                   	push   %ebp
 74c:	89 e5                	mov    %esp,%ebp
 74e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	83 c0 07             	add    $0x7,%eax
 757:	c1 e8 03             	shr    $0x3,%eax
 75a:	83 c0 01             	add    $0x1,%eax
 75d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 760:	a1 f8 13 00 00       	mov    0x13f8,%eax
 765:	89 45 f0             	mov    %eax,-0x10(%ebp)
 768:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76c:	75 23                	jne    791 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 76e:	c7 45 f0 f0 13 00 00 	movl   $0x13f0,-0x10(%ebp)
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	a3 f8 13 00 00       	mov    %eax,0x13f8
 77d:	a1 f8 13 00 00       	mov    0x13f8,%eax
 782:	a3 f0 13 00 00       	mov    %eax,0x13f0
    base.s.size = 0;
 787:	c7 05 f4 13 00 00 00 	movl   $0x0,0x13f4
 78e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 791:	8b 45 f0             	mov    -0x10(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a2:	72 4d                	jb     7f1 <malloc+0xa6>
      if(p->s.size == nunits)
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	8b 40 04             	mov    0x4(%eax),%eax
 7aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ad:	75 0c                	jne    7bb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 10                	mov    (%eax),%edx
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	89 10                	mov    %edx,(%eax)
 7b9:	eb 26                	jmp    7e1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7c4:	89 c2                	mov    %eax,%edx
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	c1 e0 03             	shl    $0x3,%eax
 7d5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	a3 f8 13 00 00       	mov    %eax,0x13f8
      return (void*)(p + 1);
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	83 c0 08             	add    $0x8,%eax
 7ef:	eb 3b                	jmp    82c <malloc+0xe1>
    }
    if(p == freep)
 7f1:	a1 f8 13 00 00       	mov    0x13f8,%eax
 7f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f9:	75 1e                	jne    819 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	ff 75 ec             	pushl  -0x14(%ebp)
 801:	e8 e5 fe ff ff       	call   6eb <morecore>
 806:	83 c4 10             	add    $0x10,%esp
 809:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 810:	75 07                	jne    819 <malloc+0xce>
        return 0;
 812:	b8 00 00 00 00       	mov    $0x0,%eax
 817:	eb 13                	jmp    82c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 827:	e9 6d ff ff ff       	jmp    799 <malloc+0x4e>
}
 82c:	c9                   	leave  
 82d:	c3                   	ret    

0000082e <isspace>:

#include "common.h"

int isspace(char c) {
 82e:	55                   	push   %ebp
 82f:	89 e5                	mov    %esp,%ebp
 831:	83 ec 04             	sub    $0x4,%esp
 834:	8b 45 08             	mov    0x8(%ebp),%eax
 837:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
 83a:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 83e:	74 12                	je     852 <isspace+0x24>
 840:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 844:	74 0c                	je     852 <isspace+0x24>
 846:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 84a:	74 06                	je     852 <isspace+0x24>
 84c:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 850:	75 07                	jne    859 <isspace+0x2b>
 852:	b8 01 00 00 00       	mov    $0x1,%eax
 857:	eb 05                	jmp    85e <isspace+0x30>
 859:	b8 00 00 00 00       	mov    $0x0,%eax
}
 85e:	c9                   	leave  
 85f:	c3                   	ret    

00000860 <readln>:

char* readln(char *buf, int max, int fd)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 866:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 86d:	eb 45                	jmp    8b4 <readln+0x54>
    cc = read(fd, &c, 1);
 86f:	83 ec 04             	sub    $0x4,%esp
 872:	6a 01                	push   $0x1
 874:	8d 45 ef             	lea    -0x11(%ebp),%eax
 877:	50                   	push   %eax
 878:	ff 75 10             	pushl  0x10(%ebp)
 87b:	e8 7d fa ff ff       	call   2fd <read>
 880:	83 c4 10             	add    $0x10,%esp
 883:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 886:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 88a:	7f 02                	jg     88e <readln+0x2e>
      break;
 88c:	eb 31                	jmp    8bf <readln+0x5f>
    buf[i++] = c;
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	8d 50 01             	lea    0x1(%eax),%edx
 894:	89 55 f4             	mov    %edx,-0xc(%ebp)
 897:	89 c2                	mov    %eax,%edx
 899:	8b 45 08             	mov    0x8(%ebp),%eax
 89c:	01 c2                	add    %eax,%edx
 89e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8a2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 8a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8a8:	3c 0a                	cmp    $0xa,%al
 8aa:	74 13                	je     8bf <readln+0x5f>
 8ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8b0:	3c 0d                	cmp    $0xd,%al
 8b2:	74 0b                	je     8bf <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b7:	83 c0 01             	add    $0x1,%eax
 8ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
 8bd:	7c b0                	jl     86f <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 8bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8c2:	8b 45 08             	mov    0x8(%ebp),%eax
 8c5:	01 d0                	add    %edx,%eax
 8c7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 8ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8cd:	c9                   	leave  
 8ce:	c3                   	ret    

000008cf <strncpy>:

char* strncpy(char* dest, char* src, int n) {
 8cf:	55                   	push   %ebp
 8d0:	89 e5                	mov    %esp,%ebp
 8d2:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8dc:	eb 19                	jmp    8f7 <strncpy+0x28>
		dest[i] = src[i];
 8de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8e1:	8b 45 08             	mov    0x8(%ebp),%eax
 8e4:	01 c2                	add    %eax,%edx
 8e6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 8e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 8ec:	01 c8                	add    %ecx,%eax
 8ee:	0f b6 00             	movzbl (%eax),%eax
 8f1:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
 8f3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fa:	3b 45 10             	cmp    0x10(%ebp),%eax
 8fd:	7d 0f                	jge    90e <strncpy+0x3f>
 8ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 902:	8b 45 0c             	mov    0xc(%ebp),%eax
 905:	01 d0                	add    %edx,%eax
 907:	0f b6 00             	movzbl (%eax),%eax
 90a:	84 c0                	test   %al,%al
 90c:	75 d0                	jne    8de <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
 90e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 911:	c9                   	leave  
 912:	c3                   	ret    

00000913 <trim>:

char* trim(char* orig) {
 913:	55                   	push   %ebp
 914:	89 e5                	mov    %esp,%ebp
 916:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
 919:	8b 45 08             	mov    0x8(%ebp),%eax
 91c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
 91f:	8b 45 08             	mov    0x8(%ebp),%eax
 922:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
 925:	eb 04                	jmp    92b <trim+0x18>
 927:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	0f b6 00             	movzbl (%eax),%eax
 931:	0f be c0             	movsbl %al,%eax
 934:	50                   	push   %eax
 935:	e8 f4 fe ff ff       	call   82e <isspace>
 93a:	83 c4 04             	add    $0x4,%esp
 93d:	85 c0                	test   %eax,%eax
 93f:	75 e6                	jne    927 <trim+0x14>
	while (*tail) { tail++; }
 941:	eb 04                	jmp    947 <trim+0x34>
 943:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 947:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94a:	0f b6 00             	movzbl (%eax),%eax
 94d:	84 c0                	test   %al,%al
 94f:	75 f2                	jne    943 <trim+0x30>
	do { tail--; } while (isspace(*tail));
 951:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 955:	8b 45 f0             	mov    -0x10(%ebp),%eax
 958:	0f b6 00             	movzbl (%eax),%eax
 95b:	0f be c0             	movsbl %al,%eax
 95e:	50                   	push   %eax
 95f:	e8 ca fe ff ff       	call   82e <isspace>
 964:	83 c4 04             	add    $0x4,%esp
 967:	85 c0                	test   %eax,%eax
 969:	75 e6                	jne    951 <trim+0x3e>
	new = malloc(tail-head+2);
 96b:	8b 55 f0             	mov    -0x10(%ebp),%edx
 96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 971:	29 c2                	sub    %eax,%edx
 973:	89 d0                	mov    %edx,%eax
 975:	83 c0 02             	add    $0x2,%eax
 978:	83 ec 0c             	sub    $0xc,%esp
 97b:	50                   	push   %eax
 97c:	e8 ca fd ff ff       	call   74b <malloc>
 981:	83 c4 10             	add    $0x10,%esp
 984:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
 987:	8b 55 f0             	mov    -0x10(%ebp),%edx
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	29 c2                	sub    %eax,%edx
 98f:	89 d0                	mov    %edx,%eax
 991:	83 c0 01             	add    $0x1,%eax
 994:	83 ec 04             	sub    $0x4,%esp
 997:	50                   	push   %eax
 998:	ff 75 f4             	pushl  -0xc(%ebp)
 99b:	ff 75 ec             	pushl  -0x14(%ebp)
 99e:	e8 2c ff ff ff       	call   8cf <strncpy>
 9a3:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
 9a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
 9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ac:	29 c2                	sub    %eax,%edx
 9ae:	89 d0                	mov    %edx,%eax
 9b0:	8d 50 01             	lea    0x1(%eax),%edx
 9b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9b6:	01 d0                	add    %edx,%eax
 9b8:	c6 00 00             	movb   $0x0,(%eax)
	return new;
 9bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
 9be:	c9                   	leave  
 9bf:	c3                   	ret    

000009c0 <itoa>:

char *
itoa(int value)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
 9c6:	8d 45 bf             	lea    -0x41(%ebp),%eax
 9c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
 9cc:	8b 45 08             	mov    0x8(%ebp),%eax
 9cf:	c1 e8 1f             	shr    $0x1f,%eax
 9d2:	0f b6 c0             	movzbl %al,%eax
 9d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
 9d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 9dc:	74 0a                	je     9e8 <itoa+0x28>
    v = -value;
 9de:	8b 45 08             	mov    0x8(%ebp),%eax
 9e1:	f7 d8                	neg    %eax
 9e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e6:	eb 06                	jmp    9ee <itoa+0x2e>
  else
    v = (uint)value;
 9e8:	8b 45 08             	mov    0x8(%ebp),%eax
 9eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
 9ee:	eb 5b                	jmp    a4b <itoa+0x8b>
  {
    i = v % 10;
 9f0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 9f3:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 9f8:	89 c8                	mov    %ecx,%eax
 9fa:	f7 e2                	mul    %edx
 9fc:	c1 ea 03             	shr    $0x3,%edx
 9ff:	89 d0                	mov    %edx,%eax
 a01:	c1 e0 02             	shl    $0x2,%eax
 a04:	01 d0                	add    %edx,%eax
 a06:	01 c0                	add    %eax,%eax
 a08:	29 c1                	sub    %eax,%ecx
 a0a:	89 ca                	mov    %ecx,%edx
 a0c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
 a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a12:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 a17:	f7 e2                	mul    %edx
 a19:	89 d0                	mov    %edx,%eax
 a1b:	c1 e8 03             	shr    $0x3,%eax
 a1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
 a21:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 a25:	7f 13                	jg     a3a <itoa+0x7a>
      *tp++ = i+'0';
 a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2a:	8d 50 01             	lea    0x1(%eax),%edx
 a2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a33:	83 c2 30             	add    $0x30,%edx
 a36:	88 10                	mov    %dl,(%eax)
 a38:	eb 11                	jmp    a4b <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
 a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3d:	8d 50 01             	lea    0x1(%eax),%edx
 a40:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a46:	83 c2 57             	add    $0x57,%edx
 a49:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
 a4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a4f:	75 9f                	jne    9f0 <itoa+0x30>
 a51:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a54:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a57:	74 97                	je     9f0 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
 a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a5c:	8d 45 bf             	lea    -0x41(%ebp),%eax
 a5f:	29 c2                	sub    %eax,%edx
 a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a64:	01 d0                	add    %edx,%eax
 a66:	83 c0 01             	add    $0x1,%eax
 a69:	83 ec 0c             	sub    $0xc,%esp
 a6c:	50                   	push   %eax
 a6d:	e8 d9 fc ff ff       	call   74b <malloc>
 a72:	83 c4 10             	add    $0x10,%esp
 a75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
 a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a7b:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
 a7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a82:	74 0c                	je     a90 <itoa+0xd0>
    *sp++ = '-';
 a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a87:	8d 50 01             	lea    0x1(%eax),%edx
 a8a:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a8d:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
 a90:	eb 15                	jmp    aa7 <itoa+0xe7>
    *sp++ = *--tp;
 a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a95:	8d 50 01             	lea    0x1(%eax),%edx
 a98:	89 55 ec             	mov    %edx,-0x14(%ebp)
 a9b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 aa2:	0f b6 12             	movzbl (%edx),%edx
 aa5:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
 aa7:	8d 45 bf             	lea    -0x41(%ebp),%eax
 aaa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aad:	77 e3                	ja     a92 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
 aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ab2:	c6 00 00             	movb   $0x0,(%eax)
  return string;
 ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
 ab8:	c9                   	leave  
 ab9:	c3                   	ret    

00000aba <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
 aba:	55                   	push   %ebp
 abb:	89 e5                	mov    %esp,%ebp
 abd:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
 ac3:	83 ec 08             	sub    $0x8,%esp
 ac6:	6a 00                	push   $0x0
 ac8:	ff 75 08             	pushl  0x8(%ebp)
 acb:	e8 55 f8 ff ff       	call   325 <open>
 ad0:	83 c4 10             	add    $0x10,%esp
 ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 ad6:	e9 22 01 00 00       	jmp    bfd <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
 adb:	83 ec 08             	sub    $0x8,%esp
 ade:	6a 3d                	push   $0x3d
 ae0:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 ae6:	50                   	push   %eax
 ae7:	e8 79 f6 ff ff       	call   165 <strchr>
 aec:	83 c4 10             	add    $0x10,%esp
 aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
 af2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 af6:	0f 84 23 01 00 00    	je     c1f <parseEnvFile+0x165>
 afc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b00:	0f 84 19 01 00 00    	je     c1f <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
 b06:	8b 55 f0             	mov    -0x10(%ebp),%edx
 b09:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b0f:	29 c2                	sub    %eax,%edx
 b11:	89 d0                	mov    %edx,%eax
 b13:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
 b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b19:	83 c0 01             	add    $0x1,%eax
 b1c:	83 ec 0c             	sub    $0xc,%esp
 b1f:	50                   	push   %eax
 b20:	e8 26 fc ff ff       	call   74b <malloc>
 b25:	83 c4 10             	add    $0x10,%esp
 b28:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
 b2b:	83 ec 04             	sub    $0x4,%esp
 b2e:	ff 75 ec             	pushl  -0x14(%ebp)
 b31:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b37:	50                   	push   %eax
 b38:	ff 75 e8             	pushl  -0x18(%ebp)
 b3b:	e8 8f fd ff ff       	call   8cf <strncpy>
 b40:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
 b43:	83 ec 0c             	sub    $0xc,%esp
 b46:	ff 75 e8             	pushl  -0x18(%ebp)
 b49:	e8 c5 fd ff ff       	call   913 <trim>
 b4e:	83 c4 10             	add    $0x10,%esp
 b51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
 b54:	83 ec 0c             	sub    $0xc,%esp
 b57:	ff 75 e8             	pushl  -0x18(%ebp)
 b5a:	e8 ab fa ff ff       	call   60a <free>
 b5f:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
 b62:	83 ec 08             	sub    $0x8,%esp
 b65:	ff 75 0c             	pushl  0xc(%ebp)
 b68:	ff 75 e4             	pushl  -0x1c(%ebp)
 b6b:	e8 c2 01 00 00       	call   d32 <addToEnvironment>
 b70:	83 c4 10             	add    $0x10,%esp
 b73:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
 b76:	83 ec 0c             	sub    $0xc,%esp
 b79:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 b7f:	50                   	push   %eax
 b80:	e8 9f f5 ff ff       	call   124 <strlen>
 b85:	83 c4 10             	add    $0x10,%esp
 b88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
 b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 b8e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b91:	83 ec 0c             	sub    $0xc,%esp
 b94:	50                   	push   %eax
 b95:	e8 b1 fb ff ff       	call   74b <malloc>
 b9a:	83 c4 10             	add    $0x10,%esp
 b9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
 ba0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 ba3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ba6:	8d 50 ff             	lea    -0x1(%eax),%edx
 ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bac:	8d 48 01             	lea    0x1(%eax),%ecx
 baf:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 bb5:	01 c8                	add    %ecx,%eax
 bb7:	83 ec 04             	sub    $0x4,%esp
 bba:	52                   	push   %edx
 bbb:	50                   	push   %eax
 bbc:	ff 75 e8             	pushl  -0x18(%ebp)
 bbf:	e8 0b fd ff ff       	call   8cf <strncpy>
 bc4:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
 bc7:	83 ec 0c             	sub    $0xc,%esp
 bca:	ff 75 e8             	pushl  -0x18(%ebp)
 bcd:	e8 41 fd ff ff       	call   913 <trim>
 bd2:	83 c4 10             	add    $0x10,%esp
 bd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
 bd8:	83 ec 0c             	sub    $0xc,%esp
 bdb:	ff 75 e8             	pushl  -0x18(%ebp)
 bde:	e8 27 fa ff ff       	call   60a <free>
 be3:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
 be6:	83 ec 04             	sub    $0x4,%esp
 be9:	ff 75 dc             	pushl  -0x24(%ebp)
 bec:	ff 75 0c             	pushl  0xc(%ebp)
 bef:	ff 75 e4             	pushl  -0x1c(%ebp)
 bf2:	e8 b8 01 00 00       	call   daf <addValueToVariable>
 bf7:	83 c4 10             	add    $0x10,%esp
 bfa:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
 bfd:	83 ec 04             	sub    $0x4,%esp
 c00:	ff 75 f4             	pushl  -0xc(%ebp)
 c03:	68 00 04 00 00       	push   $0x400
 c08:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
 c0e:	50                   	push   %eax
 c0f:	e8 4c fc ff ff       	call   860 <readln>
 c14:	83 c4 10             	add    $0x10,%esp
 c17:	85 c0                	test   %eax,%eax
 c19:	0f 85 bc fe ff ff    	jne    adb <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
 c1f:	83 ec 0c             	sub    $0xc,%esp
 c22:	ff 75 f4             	pushl  -0xc(%ebp)
 c25:	e8 e3 f6 ff ff       	call   30d <close>
 c2a:	83 c4 10             	add    $0x10,%esp
	return head;
 c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c30:	c9                   	leave  
 c31:	c3                   	ret    

00000c32 <comp>:

int comp(const char* s1, const char* s2)
{
 c32:	55                   	push   %ebp
 c33:	89 e5                	mov    %esp,%ebp
 c35:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
 c38:	83 ec 08             	sub    $0x8,%esp
 c3b:	ff 75 0c             	pushl  0xc(%ebp)
 c3e:	ff 75 08             	pushl  0x8(%ebp)
 c41:	e8 9f f4 ff ff       	call   e5 <strcmp>
 c46:	83 c4 10             	add    $0x10,%esp
 c49:	85 c0                	test   %eax,%eax
 c4b:	0f 94 c0             	sete   %al
 c4e:	0f b6 c0             	movzbl %al,%eax
}
 c51:	c9                   	leave  
 c52:	c3                   	ret    

00000c53 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
 c53:	55                   	push   %ebp
 c54:	89 e5                	mov    %esp,%ebp
 c56:	83 ec 08             	sub    $0x8,%esp
  if (!name)
 c59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c5d:	75 07                	jne    c66 <environLookup+0x13>
    return NULL;
 c5f:	b8 00 00 00 00       	mov    $0x0,%eax
 c64:	eb 2f                	jmp    c95 <environLookup+0x42>
  
  while (head)
 c66:	eb 24                	jmp    c8c <environLookup+0x39>
  {
    if (comp(name, head->name))
 c68:	8b 45 0c             	mov    0xc(%ebp),%eax
 c6b:	83 ec 08             	sub    $0x8,%esp
 c6e:	50                   	push   %eax
 c6f:	ff 75 08             	pushl  0x8(%ebp)
 c72:	e8 bb ff ff ff       	call   c32 <comp>
 c77:	83 c4 10             	add    $0x10,%esp
 c7a:	85 c0                	test   %eax,%eax
 c7c:	74 02                	je     c80 <environLookup+0x2d>
      break;
 c7e:	eb 12                	jmp    c92 <environLookup+0x3f>
    head = head->next;
 c80:	8b 45 0c             	mov    0xc(%ebp),%eax
 c83:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 c89:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
 c8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 c90:	75 d6                	jne    c68 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
 c92:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c95:	c9                   	leave  
 c96:	c3                   	ret    

00000c97 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
 c97:	55                   	push   %ebp
 c98:	89 e5                	mov    %esp,%ebp
 c9a:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
 c9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 ca1:	75 0a                	jne    cad <removeFromEnvironment+0x16>
    return NULL;
 ca3:	b8 00 00 00 00       	mov    $0x0,%eax
 ca8:	e9 83 00 00 00       	jmp    d30 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
 cad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 cb1:	74 0a                	je     cbd <removeFromEnvironment+0x26>
 cb3:	8b 45 08             	mov    0x8(%ebp),%eax
 cb6:	0f b6 00             	movzbl (%eax),%eax
 cb9:	84 c0                	test   %al,%al
 cbb:	75 05                	jne    cc2 <removeFromEnvironment+0x2b>
    return head;
 cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
 cc0:	eb 6e                	jmp    d30 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
 cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
 cc5:	83 ec 08             	sub    $0x8,%esp
 cc8:	ff 75 08             	pushl  0x8(%ebp)
 ccb:	50                   	push   %eax
 ccc:	e8 61 ff ff ff       	call   c32 <comp>
 cd1:	83 c4 10             	add    $0x10,%esp
 cd4:	85 c0                	test   %eax,%eax
 cd6:	74 34                	je     d0c <removeFromEnvironment+0x75>
  {
    tmp = head->next;
 cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
 cdb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 ce1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
 ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
 ce7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 ced:	83 ec 0c             	sub    $0xc,%esp
 cf0:	50                   	push   %eax
 cf1:	e8 74 01 00 00       	call   e6a <freeVarval>
 cf6:	83 c4 10             	add    $0x10,%esp
    free(head);
 cf9:	83 ec 0c             	sub    $0xc,%esp
 cfc:	ff 75 0c             	pushl  0xc(%ebp)
 cff:	e8 06 f9 ff ff       	call   60a <free>
 d04:	83 c4 10             	add    $0x10,%esp
    return tmp;
 d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d0a:	eb 24                	jmp    d30 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
 d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
 d0f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d15:	83 ec 08             	sub    $0x8,%esp
 d18:	50                   	push   %eax
 d19:	ff 75 08             	pushl  0x8(%ebp)
 d1c:	e8 76 ff ff ff       	call   c97 <removeFromEnvironment>
 d21:	83 c4 10             	add    $0x10,%esp
 d24:	8b 55 0c             	mov    0xc(%ebp),%edx
 d27:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
 d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d30:	c9                   	leave  
 d31:	c3                   	ret    

00000d32 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
 d32:	55                   	push   %ebp
 d33:	89 e5                	mov    %esp,%ebp
 d35:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
 d38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 d3c:	75 05                	jne    d43 <addToEnvironment+0x11>
		return head;
 d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
 d41:	eb 6a                	jmp    dad <addToEnvironment+0x7b>
	if (head == NULL) {
 d43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 d47:	75 40                	jne    d89 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
 d49:	83 ec 0c             	sub    $0xc,%esp
 d4c:	68 88 00 00 00       	push   $0x88
 d51:	e8 f5 f9 ff ff       	call   74b <malloc>
 d56:	83 c4 10             	add    $0x10,%esp
 d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
 d5c:	8b 45 08             	mov    0x8(%ebp),%eax
 d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
 d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d65:	83 ec 08             	sub    $0x8,%esp
 d68:	ff 75 f0             	pushl  -0x10(%ebp)
 d6b:	50                   	push   %eax
 d6c:	e8 44 f3 ff ff       	call   b5 <strcpy>
 d71:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
 d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d77:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
 d7e:	00 00 00 
		head = newVar;
 d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d84:	89 45 0c             	mov    %eax,0xc(%ebp)
 d87:	eb 21                	jmp    daa <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
 d89:	8b 45 0c             	mov    0xc(%ebp),%eax
 d8c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 d92:	83 ec 08             	sub    $0x8,%esp
 d95:	50                   	push   %eax
 d96:	ff 75 08             	pushl  0x8(%ebp)
 d99:	e8 94 ff ff ff       	call   d32 <addToEnvironment>
 d9e:	83 c4 10             	add    $0x10,%esp
 da1:	8b 55 0c             	mov    0xc(%ebp),%edx
 da4:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
 daa:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 dad:	c9                   	leave  
 dae:	c3                   	ret    

00000daf <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
 daf:	55                   	push   %ebp
 db0:	89 e5                	mov    %esp,%ebp
 db2:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
 db5:	83 ec 08             	sub    $0x8,%esp
 db8:	ff 75 0c             	pushl  0xc(%ebp)
 dbb:	ff 75 08             	pushl  0x8(%ebp)
 dbe:	e8 90 fe ff ff       	call   c53 <environLookup>
 dc3:	83 c4 10             	add    $0x10,%esp
 dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
 dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 dcd:	75 05                	jne    dd4 <addValueToVariable+0x25>
		return head;
 dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
 dd2:	eb 4c                	jmp    e20 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
 dd4:	83 ec 0c             	sub    $0xc,%esp
 dd7:	68 04 04 00 00       	push   $0x404
 ddc:	e8 6a f9 ff ff       	call   74b <malloc>
 de1:	83 c4 10             	add    $0x10,%esp
 de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
 de7:	8b 45 10             	mov    0x10(%ebp),%eax
 dea:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
 ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
 df0:	83 ec 08             	sub    $0x8,%esp
 df3:	ff 75 ec             	pushl  -0x14(%ebp)
 df6:	50                   	push   %eax
 df7:	e8 b9 f2 ff ff       	call   b5 <strcpy>
 dfc:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
 dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e02:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
 e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e0b:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
 e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e14:	8b 55 f0             	mov    -0x10(%ebp),%edx
 e17:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
 e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 e20:	c9                   	leave  
 e21:	c3                   	ret    

00000e22 <freeEnvironment>:

void freeEnvironment(variable* head)
{
 e22:	55                   	push   %ebp
 e23:	89 e5                	mov    %esp,%ebp
 e25:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e2c:	75 02                	jne    e30 <freeEnvironment+0xe>
    return;  
 e2e:	eb 38                	jmp    e68 <freeEnvironment+0x46>
  freeEnvironment(head->next);
 e30:	8b 45 08             	mov    0x8(%ebp),%eax
 e33:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
 e39:	83 ec 0c             	sub    $0xc,%esp
 e3c:	50                   	push   %eax
 e3d:	e8 e0 ff ff ff       	call   e22 <freeEnvironment>
 e42:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
 e45:	8b 45 08             	mov    0x8(%ebp),%eax
 e48:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 e4e:	83 ec 0c             	sub    $0xc,%esp
 e51:	50                   	push   %eax
 e52:	e8 13 00 00 00       	call   e6a <freeVarval>
 e57:	83 c4 10             	add    $0x10,%esp
  free(head);
 e5a:	83 ec 0c             	sub    $0xc,%esp
 e5d:	ff 75 08             	pushl  0x8(%ebp)
 e60:	e8 a5 f7 ff ff       	call   60a <free>
 e65:	83 c4 10             	add    $0x10,%esp
}
 e68:	c9                   	leave  
 e69:	c3                   	ret    

00000e6a <freeVarval>:

void freeVarval(varval* head)
{
 e6a:	55                   	push   %ebp
 e6b:	89 e5                	mov    %esp,%ebp
 e6d:	83 ec 08             	sub    $0x8,%esp
  if (!head)
 e70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e74:	75 02                	jne    e78 <freeVarval+0xe>
    return;  
 e76:	eb 23                	jmp    e9b <freeVarval+0x31>
  freeVarval(head->next);
 e78:	8b 45 08             	mov    0x8(%ebp),%eax
 e7b:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 e81:	83 ec 0c             	sub    $0xc,%esp
 e84:	50                   	push   %eax
 e85:	e8 e0 ff ff ff       	call   e6a <freeVarval>
 e8a:	83 c4 10             	add    $0x10,%esp
  free(head);
 e8d:	83 ec 0c             	sub    $0xc,%esp
 e90:	ff 75 08             	pushl  0x8(%ebp)
 e93:	e8 72 f7 ff ff       	call   60a <free>
 e98:	83 c4 10             	add    $0x10,%esp
}
 e9b:	c9                   	leave  
 e9c:	c3                   	ret    

00000e9d <getPaths>:

varval* getPaths(char* paths, varval* head) {
 e9d:	55                   	push   %ebp
 e9e:	89 e5                	mov    %esp,%ebp
 ea0:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
 ea3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 ea7:	75 08                	jne    eb1 <getPaths+0x14>
		return head;
 ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
 eac:	e9 e7 00 00 00       	jmp    f98 <getPaths+0xfb>
	if (head == NULL) {
 eb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 eb5:	0f 85 b9 00 00 00    	jne    f74 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
 ebb:	83 ec 08             	sub    $0x8,%esp
 ebe:	6a 3a                	push   $0x3a
 ec0:	ff 75 08             	pushl  0x8(%ebp)
 ec3:	e8 9d f2 ff ff       	call   165 <strchr>
 ec8:	83 c4 10             	add    $0x10,%esp
 ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
 ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ed2:	75 56                	jne    f2a <getPaths+0x8d>
			pathLen = strlen(paths);
 ed4:	83 ec 0c             	sub    $0xc,%esp
 ed7:	ff 75 08             	pushl  0x8(%ebp)
 eda:	e8 45 f2 ff ff       	call   124 <strlen>
 edf:	83 c4 10             	add    $0x10,%esp
 ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 ee5:	83 ec 0c             	sub    $0xc,%esp
 ee8:	68 04 04 00 00       	push   $0x404
 eed:	e8 59 f8 ff ff       	call   74b <malloc>
 ef2:	83 c4 10             	add    $0x10,%esp
 ef5:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
 efb:	83 ec 04             	sub    $0x4,%esp
 efe:	ff 75 f0             	pushl  -0x10(%ebp)
 f01:	ff 75 08             	pushl  0x8(%ebp)
 f04:	50                   	push   %eax
 f05:	e8 c5 f9 ff ff       	call   8cf <strncpy>
 f0a:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
 f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f13:	01 d0                	add    %edx,%eax
 f15:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
 f18:	8b 45 0c             	mov    0xc(%ebp),%eax
 f1b:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
 f22:	00 00 00 
			return head;
 f25:	8b 45 0c             	mov    0xc(%ebp),%eax
 f28:	eb 6e                	jmp    f98 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
 f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 f2d:	8b 45 08             	mov    0x8(%ebp),%eax
 f30:	29 c2                	sub    %eax,%edx
 f32:	89 d0                	mov    %edx,%eax
 f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
 f37:	83 ec 0c             	sub    $0xc,%esp
 f3a:	68 04 04 00 00       	push   $0x404
 f3f:	e8 07 f8 ff ff       	call   74b <malloc>
 f44:	83 c4 10             	add    $0x10,%esp
 f47:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
 f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
 f4d:	83 ec 04             	sub    $0x4,%esp
 f50:	ff 75 f0             	pushl  -0x10(%ebp)
 f53:	ff 75 08             	pushl  0x8(%ebp)
 f56:	50                   	push   %eax
 f57:	e8 73 f9 ff ff       	call   8cf <strncpy>
 f5c:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
 f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
 f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f65:	01 d0                	add    %edx,%eax
 f67:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
 f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f6d:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
 f70:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
 f74:	8b 45 0c             	mov    0xc(%ebp),%eax
 f77:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
 f7d:	83 ec 08             	sub    $0x8,%esp
 f80:	50                   	push   %eax
 f81:	ff 75 08             	pushl  0x8(%ebp)
 f84:	e8 14 ff ff ff       	call   e9d <getPaths>
 f89:	83 c4 10             	add    $0x10,%esp
 f8c:	8b 55 0c             	mov    0xc(%ebp),%edx
 f8f:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
 f95:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 f98:	c9                   	leave  
 f99:	c3                   	ret    
