
_cat:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 82 03 00 00       	call   3a5 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 5f 03 00 00       	call   39d <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 d1 08 00 	movl   $0x8d1,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 a4 04 00 00       	call   505 <printf>
    exit();
  61:	e8 1f 03 00 00       	call   385 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 fd 02 00 00       	call   385 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 79                	jmp    10b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 11 03 00 00       	call   3c5 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 e2 08 00 	movl   $0x8e2,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 1c 04 00 00       	call   505 <printf>
      exit();
  e9:	e8 97 02 00 00       	call   385 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 a7 02 00 00       	call   3ad <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 10b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10f:	3b 45 08             	cmp    0x8(%ebp),%eax
 112:	0f 8c 7a ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 118:	e8 68 02 00 00       	call   385 <exit>

0000011d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 122:	8b 4d 08             	mov    0x8(%ebp),%ecx
 125:	8b 55 10             	mov    0x10(%ebp),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	89 cb                	mov    %ecx,%ebx
 12d:	89 df                	mov    %ebx,%edi
 12f:	89 d1                	mov    %edx,%ecx
 131:	fc                   	cld    
 132:	f3 aa                	rep stos %al,%es:(%edi)
 134:	89 ca                	mov    %ecx,%edx
 136:	89 fb                	mov    %edi,%ebx
 138:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13e:	5b                   	pop    %ebx
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14e:	90                   	nop
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	8d 50 01             	lea    0x1(%eax),%edx
 155:	89 55 08             	mov    %edx,0x8(%ebp)
 158:	8b 55 0c             	mov    0xc(%ebp),%edx
 15b:	8d 4a 01             	lea    0x1(%edx),%ecx
 15e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 161:	0f b6 12             	movzbl (%edx),%edx
 164:	88 10                	mov    %dl,(%eax)
 166:	0f b6 00             	movzbl (%eax),%eax
 169:	84 c0                	test   %al,%al
 16b:	75 e2                	jne    14f <strcpy+0xd>
    ;
  return os;
 16d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 170:	c9                   	leave  
 171:	c3                   	ret    

00000172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 175:	eb 08                	jmp    17f <strcmp+0xd>
    p++, q++;
 177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	74 10                	je     199 <strcmp+0x27>
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 10             	movzbl (%eax),%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	38 c2                	cmp    %al,%dl
 197:	74 de                	je     177 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	0f b6 d0             	movzbl %al,%edx
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	0f b6 c0             	movzbl %al,%eax
 1ab:	29 c2                	sub    %eax,%edx
 1ad:	89 d0                	mov    %edx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(char *s)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1be:	eb 04                	jmp    1c4 <strlen+0x13>
 1c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 d0                	add    %edx,%eax
 1cc:	0f b6 00             	movzbl (%eax),%eax
 1cf:	84 c0                	test   %al,%al
 1d1:	75 ed                	jne    1c0 <strlen+0xf>
    ;
  return n;
 1d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d6:	c9                   	leave  
 1d7:	c3                   	ret    

000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1de:	8b 45 10             	mov    0x10(%ebp),%eax
 1e1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	89 04 24             	mov    %eax,(%esp)
 1f2:	e8 26 ff ff ff       	call   11d <stosb>
  return dst;
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fa:	c9                   	leave  
 1fb:	c3                   	ret    

000001fc <strchr>:

char*
strchr(const char *s, char c)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	83 ec 04             	sub    $0x4,%esp
 202:	8b 45 0c             	mov    0xc(%ebp),%eax
 205:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 208:	eb 14                	jmp    21e <strchr+0x22>
    if(*s == c)
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	3a 45 fc             	cmp    -0x4(%ebp),%al
 213:	75 05                	jne    21a <strchr+0x1e>
      return (char*)s;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	eb 13                	jmp    22d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 21a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	84 c0                	test   %al,%al
 226:	75 e2                	jne    20a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 228:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <gets>:

char*
gets(char *buf, int max)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23c:	eb 4c                	jmp    28a <gets+0x5b>
    cc = read(0, &c, 1);
 23e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 245:	00 
 246:	8d 45 ef             	lea    -0x11(%ebp),%eax
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 254:	e8 44 01 00 00       	call   39d <read>
 259:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 260:	7f 02                	jg     264 <gets+0x35>
      break;
 262:	eb 31                	jmp    295 <gets+0x66>
    buf[i++] = c;
 264:	8b 45 f4             	mov    -0xc(%ebp),%eax
 267:	8d 50 01             	lea    0x1(%eax),%edx
 26a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 26d:	89 c2                	mov    %eax,%edx
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	01 c2                	add    %eax,%edx
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 27a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27e:	3c 0a                	cmp    $0xa,%al
 280:	74 13                	je     295 <gets+0x66>
 282:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 286:	3c 0d                	cmp    $0xd,%al
 288:	74 0b                	je     295 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28d:	83 c0 01             	add    $0x1,%eax
 290:	3b 45 0c             	cmp    0xc(%ebp),%eax
 293:	7c a9                	jl     23e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 295:	8b 55 f4             	mov    -0xc(%ebp),%edx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	01 d0                	add    %edx,%eax
 29d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a3:	c9                   	leave  
 2a4:	c3                   	ret    

000002a5 <stat>:

int
stat(char *n, struct stat *st)
{
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b2:	00 
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	89 04 24             	mov    %eax,(%esp)
 2b9:	e8 07 01 00 00       	call   3c5 <open>
 2be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c5:	79 07                	jns    2ce <stat+0x29>
    return -1;
 2c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cc:	eb 23                	jmp    2f1 <stat+0x4c>
  r = fstat(fd, st);
 2ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d8:	89 04 24             	mov    %eax,(%esp)
 2db:	e8 fd 00 00 00       	call   3dd <fstat>
 2e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e6:	89 04 24             	mov    %eax,(%esp)
 2e9:	e8 bf 00 00 00       	call   3ad <close>
  return r;
 2ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f1:	c9                   	leave  
 2f2:	c3                   	ret    

000002f3 <atoi>:

int
atoi(const char *s)
{
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp
 2f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 300:	eb 25                	jmp    327 <atoi+0x34>
    n = n*10 + *s++ - '0';
 302:	8b 55 fc             	mov    -0x4(%ebp),%edx
 305:	89 d0                	mov    %edx,%eax
 307:	c1 e0 02             	shl    $0x2,%eax
 30a:	01 d0                	add    %edx,%eax
 30c:	01 c0                	add    %eax,%eax
 30e:	89 c1                	mov    %eax,%ecx
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	8d 50 01             	lea    0x1(%eax),%edx
 316:	89 55 08             	mov    %edx,0x8(%ebp)
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	0f be c0             	movsbl %al,%eax
 31f:	01 c8                	add    %ecx,%eax
 321:	83 e8 30             	sub    $0x30,%eax
 324:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 2f                	cmp    $0x2f,%al
 32f:	7e 0a                	jle    33b <atoi+0x48>
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	0f b6 00             	movzbl (%eax),%eax
 337:	3c 39                	cmp    $0x39,%al
 339:	7e c7                	jle    302 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 33b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33e:	c9                   	leave  
 33f:	c3                   	ret    

00000340 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 34c:	8b 45 0c             	mov    0xc(%ebp),%eax
 34f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 352:	eb 17                	jmp    36b <memmove+0x2b>
    *dst++ = *src++;
 354:	8b 45 fc             	mov    -0x4(%ebp),%eax
 357:	8d 50 01             	lea    0x1(%eax),%edx
 35a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 35d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 360:	8d 4a 01             	lea    0x1(%edx),%ecx
 363:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 366:	0f b6 12             	movzbl (%edx),%edx
 369:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 36b:	8b 45 10             	mov    0x10(%ebp),%eax
 36e:	8d 50 ff             	lea    -0x1(%eax),%edx
 371:	89 55 10             	mov    %edx,0x10(%ebp)
 374:	85 c0                	test   %eax,%eax
 376:	7f dc                	jg     354 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 378:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37b:	c9                   	leave  
 37c:	c3                   	ret    

0000037d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37d:	b8 01 00 00 00       	mov    $0x1,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <exit>:
SYSCALL(exit)
 385:	b8 02 00 00 00       	mov    $0x2,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <wait>:
SYSCALL(wait)
 38d:	b8 03 00 00 00       	mov    $0x3,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <pipe>:
SYSCALL(pipe)
 395:	b8 04 00 00 00       	mov    $0x4,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <read>:
SYSCALL(read)
 39d:	b8 05 00 00 00       	mov    $0x5,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <write>:
SYSCALL(write)
 3a5:	b8 10 00 00 00       	mov    $0x10,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <close>:
SYSCALL(close)
 3ad:	b8 15 00 00 00       	mov    $0x15,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <kill>:
SYSCALL(kill)
 3b5:	b8 06 00 00 00       	mov    $0x6,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <exec>:
SYSCALL(exec)
 3bd:	b8 07 00 00 00       	mov    $0x7,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <open>:
SYSCALL(open)
 3c5:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <mknod>:
SYSCALL(mknod)
 3cd:	b8 11 00 00 00       	mov    $0x11,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <unlink>:
SYSCALL(unlink)
 3d5:	b8 12 00 00 00       	mov    $0x12,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <fstat>:
SYSCALL(fstat)
 3dd:	b8 08 00 00 00       	mov    $0x8,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <link>:
SYSCALL(link)
 3e5:	b8 13 00 00 00       	mov    $0x13,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <mkdir>:
SYSCALL(mkdir)
 3ed:	b8 14 00 00 00       	mov    $0x14,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <chdir>:
SYSCALL(chdir)
 3f5:	b8 09 00 00 00       	mov    $0x9,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <dup>:
SYSCALL(dup)
 3fd:	b8 0a 00 00 00       	mov    $0xa,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <getpid>:
SYSCALL(getpid)
 405:	b8 0b 00 00 00       	mov    $0xb,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <sbrk>:
SYSCALL(sbrk)
 40d:	b8 0c 00 00 00       	mov    $0xc,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <sleep>:
SYSCALL(sleep)
 415:	b8 0d 00 00 00       	mov    $0xd,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <uptime>:
SYSCALL(uptime)
 41d:	b8 0e 00 00 00       	mov    $0xe,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 425:	55                   	push   %ebp
 426:	89 e5                	mov    %esp,%ebp
 428:	83 ec 18             	sub    $0x18,%esp
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 431:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 438:	00 
 439:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43c:	89 44 24 04          	mov    %eax,0x4(%esp)
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	89 04 24             	mov    %eax,(%esp)
 446:	e8 5a ff ff ff       	call   3a5 <write>
}
 44b:	c9                   	leave  
 44c:	c3                   	ret    

0000044d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	56                   	push   %esi
 451:	53                   	push   %ebx
 452:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 455:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 460:	74 17                	je     479 <printint+0x2c>
 462:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 466:	79 11                	jns    479 <printint+0x2c>
    neg = 1;
 468:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46f:	8b 45 0c             	mov    0xc(%ebp),%eax
 472:	f7 d8                	neg    %eax
 474:	89 45 ec             	mov    %eax,-0x14(%ebp)
 477:	eb 06                	jmp    47f <printint+0x32>
  } else {
    x = xx;
 479:	8b 45 0c             	mov    0xc(%ebp),%eax
 47c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 47f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 486:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 489:	8d 41 01             	lea    0x1(%ecx),%eax
 48c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 48f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 492:	8b 45 ec             	mov    -0x14(%ebp),%eax
 495:	ba 00 00 00 00       	mov    $0x0,%edx
 49a:	f7 f3                	div    %ebx
 49c:	89 d0                	mov    %edx,%eax
 49e:	0f b6 80 64 0b 00 00 	movzbl 0xb64(%eax),%eax
 4a5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4a9:	8b 75 10             	mov    0x10(%ebp),%esi
 4ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4af:	ba 00 00 00 00       	mov    $0x0,%edx
 4b4:	f7 f6                	div    %esi
 4b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bd:	75 c7                	jne    486 <printint+0x39>
  if(neg)
 4bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c3:	74 10                	je     4d5 <printint+0x88>
    buf[i++] = '-';
 4c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c8:	8d 50 01             	lea    0x1(%eax),%edx
 4cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ce:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d3:	eb 1f                	jmp    4f4 <printint+0xa7>
 4d5:	eb 1d                	jmp    4f4 <printint+0xa7>
    putc(fd, buf[i]);
 4d7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4dd:	01 d0                	add    %edx,%eax
 4df:	0f b6 00             	movzbl (%eax),%eax
 4e2:	0f be c0             	movsbl %al,%eax
 4e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ec:	89 04 24             	mov    %eax,(%esp)
 4ef:	e8 31 ff ff ff       	call   425 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fc:	79 d9                	jns    4d7 <printint+0x8a>
    putc(fd, buf[i]);
}
 4fe:	83 c4 30             	add    $0x30,%esp
 501:	5b                   	pop    %ebx
 502:	5e                   	pop    %esi
 503:	5d                   	pop    %ebp
 504:	c3                   	ret    

00000505 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 505:	55                   	push   %ebp
 506:	89 e5                	mov    %esp,%ebp
 508:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 50b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 512:	8d 45 0c             	lea    0xc(%ebp),%eax
 515:	83 c0 04             	add    $0x4,%eax
 518:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 51b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 522:	e9 7c 01 00 00       	jmp    6a3 <printf+0x19e>
    c = fmt[i] & 0xff;
 527:	8b 55 0c             	mov    0xc(%ebp),%edx
 52a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 52d:	01 d0                	add    %edx,%eax
 52f:	0f b6 00             	movzbl (%eax),%eax
 532:	0f be c0             	movsbl %al,%eax
 535:	25 ff 00 00 00       	and    $0xff,%eax
 53a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 53d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 541:	75 2c                	jne    56f <printf+0x6a>
      if(c == '%'){
 543:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 547:	75 0c                	jne    555 <printf+0x50>
        state = '%';
 549:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 550:	e9 4a 01 00 00       	jmp    69f <printf+0x19a>
      } else {
        putc(fd, c);
 555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	89 44 24 04          	mov    %eax,0x4(%esp)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 bb fe ff ff       	call   425 <putc>
 56a:	e9 30 01 00 00       	jmp    69f <printf+0x19a>
      }
    } else if(state == '%'){
 56f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 573:	0f 85 26 01 00 00    	jne    69f <printf+0x19a>
      if(c == 'd'){
 579:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 57d:	75 2d                	jne    5ac <printf+0xa7>
        printint(fd, *ap, 10, 1);
 57f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 582:	8b 00                	mov    (%eax),%eax
 584:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 58b:	00 
 58c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 593:	00 
 594:	89 44 24 04          	mov    %eax,0x4(%esp)
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	89 04 24             	mov    %eax,(%esp)
 59e:	e8 aa fe ff ff       	call   44d <printint>
        ap++;
 5a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a7:	e9 ec 00 00 00       	jmp    698 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5ac:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b0:	74 06                	je     5b8 <printf+0xb3>
 5b2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5b6:	75 2d                	jne    5e5 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bb:	8b 00                	mov    (%eax),%eax
 5bd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5c4:	00 
 5c5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5cc:	00 
 5cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	89 04 24             	mov    %eax,(%esp)
 5d7:	e8 71 fe ff ff       	call   44d <printint>
        ap++;
 5dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e0:	e9 b3 00 00 00       	jmp    698 <printf+0x193>
      } else if(c == 's'){
 5e5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e9:	75 45                	jne    630 <printf+0x12b>
        s = (char*)*ap;
 5eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fb:	75 09                	jne    606 <printf+0x101>
          s = "(null)";
 5fd:	c7 45 f4 f7 08 00 00 	movl   $0x8f7,-0xc(%ebp)
        while(*s != 0){
 604:	eb 1e                	jmp    624 <printf+0x11f>
 606:	eb 1c                	jmp    624 <printf+0x11f>
          putc(fd, *s);
 608:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60b:	0f b6 00             	movzbl (%eax),%eax
 60e:	0f be c0             	movsbl %al,%eax
 611:	89 44 24 04          	mov    %eax,0x4(%esp)
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	89 04 24             	mov    %eax,(%esp)
 61b:	e8 05 fe ff ff       	call   425 <putc>
          s++;
 620:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 624:	8b 45 f4             	mov    -0xc(%ebp),%eax
 627:	0f b6 00             	movzbl (%eax),%eax
 62a:	84 c0                	test   %al,%al
 62c:	75 da                	jne    608 <printf+0x103>
 62e:	eb 68                	jmp    698 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 630:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 634:	75 1d                	jne    653 <printf+0x14e>
        putc(fd, *ap);
 636:	8b 45 e8             	mov    -0x18(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	0f be c0             	movsbl %al,%eax
 63e:	89 44 24 04          	mov    %eax,0x4(%esp)
 642:	8b 45 08             	mov    0x8(%ebp),%eax
 645:	89 04 24             	mov    %eax,(%esp)
 648:	e8 d8 fd ff ff       	call   425 <putc>
        ap++;
 64d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 651:	eb 45                	jmp    698 <printf+0x193>
      } else if(c == '%'){
 653:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 657:	75 17                	jne    670 <printf+0x16b>
        putc(fd, c);
 659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	89 44 24 04          	mov    %eax,0x4(%esp)
 663:	8b 45 08             	mov    0x8(%ebp),%eax
 666:	89 04 24             	mov    %eax,(%esp)
 669:	e8 b7 fd ff ff       	call   425 <putc>
 66e:	eb 28                	jmp    698 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 670:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 677:	00 
 678:	8b 45 08             	mov    0x8(%ebp),%eax
 67b:	89 04 24             	mov    %eax,(%esp)
 67e:	e8 a2 fd ff ff       	call   425 <putc>
        putc(fd, c);
 683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 686:	0f be c0             	movsbl %al,%eax
 689:	89 44 24 04          	mov    %eax,0x4(%esp)
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
 690:	89 04 24             	mov    %eax,(%esp)
 693:	e8 8d fd ff ff       	call   425 <putc>
      }
      state = 0;
 698:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a9:	01 d0                	add    %edx,%eax
 6ab:	0f b6 00             	movzbl (%eax),%eax
 6ae:	84 c0                	test   %al,%al
 6b0:	0f 85 71 fe ff ff    	jne    527 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b6:	c9                   	leave  
 6b7:	c3                   	ret    

000006b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	83 e8 08             	sub    $0x8,%eax
 6c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c7:	a1 88 0b 00 00       	mov    0xb88,%eax
 6cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cf:	eb 24                	jmp    6f5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	77 12                	ja     6ed <free+0x35>
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e1:	77 24                	ja     707 <free+0x4f>
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6eb:	77 1a                	ja     707 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fb:	76 d4                	jbe    6d1 <free+0x19>
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 705:	76 ca                	jbe    6d1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	8b 40 04             	mov    0x4(%eax),%eax
 70d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 714:	8b 45 f8             	mov    -0x8(%ebp),%eax
 717:	01 c2                	add    %eax,%edx
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	39 c2                	cmp    %eax,%edx
 720:	75 24                	jne    746 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	8b 50 04             	mov    0x4(%eax),%edx
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	8b 40 04             	mov    0x4(%eax),%eax
 730:	01 c2                	add    %eax,%edx
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	8b 10                	mov    (%eax),%edx
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	89 10                	mov    %edx,(%eax)
 744:	eb 0a                	jmp    750 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 10                	mov    (%eax),%edx
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 40 04             	mov    0x4(%eax),%eax
 756:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	01 d0                	add    %edx,%eax
 762:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 765:	75 20                	jne    787 <free+0xcf>
    p->s.size += bp->s.size;
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 50 04             	mov    0x4(%eax),%edx
 76d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	01 c2                	add    %eax,%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	8b 10                	mov    (%eax),%edx
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	89 10                	mov    %edx,(%eax)
 785:	eb 08                	jmp    78f <free+0xd7>
  } else
    p->s.ptr = bp;
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 78d:	89 10                	mov    %edx,(%eax)
  freep = p;
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 797:	c9                   	leave  
 798:	c3                   	ret    

00000799 <morecore>:

static Header*
morecore(uint nu)
{
 799:	55                   	push   %ebp
 79a:	89 e5                	mov    %esp,%ebp
 79c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a6:	77 07                	ja     7af <morecore+0x16>
    nu = 4096;
 7a8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7af:	8b 45 08             	mov    0x8(%ebp),%eax
 7b2:	c1 e0 03             	shl    $0x3,%eax
 7b5:	89 04 24             	mov    %eax,(%esp)
 7b8:	e8 50 fc ff ff       	call   40d <sbrk>
 7bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c4:	75 07                	jne    7cd <morecore+0x34>
    return 0;
 7c6:	b8 00 00 00 00       	mov    $0x0,%eax
 7cb:	eb 22                	jmp    7ef <morecore+0x56>
  hp = (Header*)p;
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	8b 55 08             	mov    0x8(%ebp),%edx
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	83 c0 08             	add    $0x8,%eax
 7e2:	89 04 24             	mov    %eax,(%esp)
 7e5:	e8 ce fe ff ff       	call   6b8 <free>
  return freep;
 7ea:	a1 88 0b 00 00       	mov    0xb88,%eax
}
 7ef:	c9                   	leave  
 7f0:	c3                   	ret    

000007f1 <malloc>:

void*
malloc(uint nbytes)
{
 7f1:	55                   	push   %ebp
 7f2:	89 e5                	mov    %esp,%ebp
 7f4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f7:	8b 45 08             	mov    0x8(%ebp),%eax
 7fa:	83 c0 07             	add    $0x7,%eax
 7fd:	c1 e8 03             	shr    $0x3,%eax
 800:	83 c0 01             	add    $0x1,%eax
 803:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 806:	a1 88 0b 00 00       	mov    0xb88,%eax
 80b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 812:	75 23                	jne    837 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 814:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
 81b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81e:	a3 88 0b 00 00       	mov    %eax,0xb88
 823:	a1 88 0b 00 00       	mov    0xb88,%eax
 828:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 82d:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 834:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 837:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83a:	8b 00                	mov    (%eax),%eax
 83c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 40 04             	mov    0x4(%eax),%eax
 845:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 848:	72 4d                	jb     897 <malloc+0xa6>
      if(p->s.size == nunits)
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	8b 40 04             	mov    0x4(%eax),%eax
 850:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 853:	75 0c                	jne    861 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8b 10                	mov    (%eax),%edx
 85a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85d:	89 10                	mov    %edx,(%eax)
 85f:	eb 26                	jmp    887 <malloc+0x96>
      else {
        p->s.size -= nunits;
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	8b 40 04             	mov    0x4(%eax),%eax
 867:	2b 45 ec             	sub    -0x14(%ebp),%eax
 86a:	89 c2                	mov    %eax,%edx
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8b 40 04             	mov    0x4(%eax),%eax
 878:	c1 e0 03             	shl    $0x3,%eax
 87b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 55 ec             	mov    -0x14(%ebp),%edx
 884:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 887:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88a:	a3 88 0b 00 00       	mov    %eax,0xb88
      return (void*)(p + 1);
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	83 c0 08             	add    $0x8,%eax
 895:	eb 38                	jmp    8cf <malloc+0xde>
    }
    if(p == freep)
 897:	a1 88 0b 00 00       	mov    0xb88,%eax
 89c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 89f:	75 1b                	jne    8bc <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a4:	89 04 24             	mov    %eax,(%esp)
 8a7:	e8 ed fe ff ff       	call   799 <morecore>
 8ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b3:	75 07                	jne    8bc <malloc+0xcb>
        return 0;
 8b5:	b8 00 00 00 00       	mov    $0x0,%eax
 8ba:	eb 13                	jmp    8cf <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ca:	e9 70 ff ff ff       	jmp    83f <malloc+0x4e>
}
 8cf:	c9                   	leave  
 8d0:	c3                   	ret    
