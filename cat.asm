
_cat:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
       6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
       8:	83 ec 04             	sub    $0x4,%esp
       b:	ff 75 f4             	pushl  -0xc(%ebp)
       e:	68 00 15 00 00       	push   $0x1500
      13:	6a 01                	push   $0x1
      15:	e8 69 03 00 00       	call   383 <write>
      1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
      1d:	83 ec 04             	sub    $0x4,%esp
      20:	68 00 02 00 00       	push   $0x200
      25:	68 00 15 00 00       	push   $0x1500
      2a:	ff 75 08             	pushl  0x8(%ebp)
      2d:	e8 49 03 00 00       	call   37b <read>
      32:	83 c4 10             	add    $0x10,%esp
      35:	89 45 f4             	mov    %eax,-0xc(%ebp)
      38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
      3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
      44:	83 ec 08             	sub    $0x8,%esp
      47:	68 18 10 00 00       	push   $0x1018
      4c:	6a 01                	push   $0x1
      4e:	e8 a5 04 00 00       	call   4f8 <printf>
      53:	83 c4 10             	add    $0x10,%esp
    exit();
      56:	e8 08 03 00 00       	call   363 <exit>
  }
}
      5b:	c9                   	leave  
      5c:	c3                   	ret    

0000005d <main>:

int
main(int argc, char *argv[])
{
      5d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
      61:	83 e4 f0             	and    $0xfffffff0,%esp
      64:	ff 71 fc             	pushl  -0x4(%ecx)
      67:	55                   	push   %ebp
      68:	89 e5                	mov    %esp,%ebp
      6a:	53                   	push   %ebx
      6b:	51                   	push   %ecx
      6c:	83 ec 10             	sub    $0x10,%esp
      6f:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
      71:	83 3b 01             	cmpl   $0x1,(%ebx)
      74:	7f 12                	jg     88 <main+0x2b>
    cat(0);
      76:	83 ec 0c             	sub    $0xc,%esp
      79:	6a 00                	push   $0x0
      7b:	e8 80 ff ff ff       	call   0 <cat>
      80:	83 c4 10             	add    $0x10,%esp
    exit();
      83:	e8 db 02 00 00       	call   363 <exit>
  }

  for(i = 1; i < argc; i++){
      88:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      8f:	eb 71                	jmp    102 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
      91:	8b 45 f4             	mov    -0xc(%ebp),%eax
      94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
      9b:	8b 43 04             	mov    0x4(%ebx),%eax
      9e:	01 d0                	add    %edx,%eax
      a0:	8b 00                	mov    (%eax),%eax
      a2:	83 ec 08             	sub    $0x8,%esp
      a5:	6a 00                	push   $0x0
      a7:	50                   	push   %eax
      a8:	e8 f6 02 00 00       	call   3a3 <open>
      ad:	83 c4 10             	add    $0x10,%esp
      b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
      b7:	79 29                	jns    e2 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
      b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
      bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
      c3:	8b 43 04             	mov    0x4(%ebx),%eax
      c6:	01 d0                	add    %edx,%eax
      c8:	8b 00                	mov    (%eax),%eax
      ca:	83 ec 04             	sub    $0x4,%esp
      cd:	50                   	push   %eax
      ce:	68 29 10 00 00       	push   $0x1029
      d3:	6a 01                	push   $0x1
      d5:	e8 1e 04 00 00       	call   4f8 <printf>
      da:	83 c4 10             	add    $0x10,%esp
      exit();
      dd:	e8 81 02 00 00       	call   363 <exit>
    }
    cat(fd);
      e2:	83 ec 0c             	sub    $0xc,%esp
      e5:	ff 75 f0             	pushl  -0x10(%ebp)
      e8:	e8 13 ff ff ff       	call   0 <cat>
      ed:	83 c4 10             	add    $0x10,%esp
    close(fd);
      f0:	83 ec 0c             	sub    $0xc,%esp
      f3:	ff 75 f0             	pushl  -0x10(%ebp)
      f6:	e8 90 02 00 00       	call   38b <close>
      fb:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
      fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     102:	8b 45 f4             	mov    -0xc(%ebp),%eax
     105:	3b 03                	cmp    (%ebx),%eax
     107:	7c 88                	jl     91 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
     109:	e8 55 02 00 00       	call   363 <exit>

0000010e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     10e:	55                   	push   %ebp
     10f:	89 e5                	mov    %esp,%ebp
     111:	57                   	push   %edi
     112:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     113:	8b 4d 08             	mov    0x8(%ebp),%ecx
     116:	8b 55 10             	mov    0x10(%ebp),%edx
     119:	8b 45 0c             	mov    0xc(%ebp),%eax
     11c:	89 cb                	mov    %ecx,%ebx
     11e:	89 df                	mov    %ebx,%edi
     120:	89 d1                	mov    %edx,%ecx
     122:	fc                   	cld    
     123:	f3 aa                	rep stos %al,%es:(%edi)
     125:	89 ca                	mov    %ecx,%edx
     127:	89 fb                	mov    %edi,%ebx
     129:	89 5d 08             	mov    %ebx,0x8(%ebp)
     12c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     12f:	5b                   	pop    %ebx
     130:	5f                   	pop    %edi
     131:	5d                   	pop    %ebp
     132:	c3                   	ret    

00000133 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     133:	55                   	push   %ebp
     134:	89 e5                	mov    %esp,%ebp
     136:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     139:	8b 45 08             	mov    0x8(%ebp),%eax
     13c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     13f:	90                   	nop
     140:	8b 45 08             	mov    0x8(%ebp),%eax
     143:	8d 50 01             	lea    0x1(%eax),%edx
     146:	89 55 08             	mov    %edx,0x8(%ebp)
     149:	8b 55 0c             	mov    0xc(%ebp),%edx
     14c:	8d 4a 01             	lea    0x1(%edx),%ecx
     14f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     152:	0f b6 12             	movzbl (%edx),%edx
     155:	88 10                	mov    %dl,(%eax)
     157:	0f b6 00             	movzbl (%eax),%eax
     15a:	84 c0                	test   %al,%al
     15c:	75 e2                	jne    140 <strcpy+0xd>
    ;
  return os;
     15e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     161:	c9                   	leave  
     162:	c3                   	ret    

00000163 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     163:	55                   	push   %ebp
     164:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     166:	eb 08                	jmp    170 <strcmp+0xd>
    p++, q++;
     168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     16c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     170:	8b 45 08             	mov    0x8(%ebp),%eax
     173:	0f b6 00             	movzbl (%eax),%eax
     176:	84 c0                	test   %al,%al
     178:	74 10                	je     18a <strcmp+0x27>
     17a:	8b 45 08             	mov    0x8(%ebp),%eax
     17d:	0f b6 10             	movzbl (%eax),%edx
     180:	8b 45 0c             	mov    0xc(%ebp),%eax
     183:	0f b6 00             	movzbl (%eax),%eax
     186:	38 c2                	cmp    %al,%dl
     188:	74 de                	je     168 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     18a:	8b 45 08             	mov    0x8(%ebp),%eax
     18d:	0f b6 00             	movzbl (%eax),%eax
     190:	0f b6 d0             	movzbl %al,%edx
     193:	8b 45 0c             	mov    0xc(%ebp),%eax
     196:	0f b6 00             	movzbl (%eax),%eax
     199:	0f b6 c0             	movzbl %al,%eax
     19c:	29 c2                	sub    %eax,%edx
     19e:	89 d0                	mov    %edx,%eax
}
     1a0:	5d                   	pop    %ebp
     1a1:	c3                   	ret    

000001a2 <strlen>:

uint
strlen(char *s)
{
     1a2:	55                   	push   %ebp
     1a3:	89 e5                	mov    %esp,%ebp
     1a5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     1a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     1af:	eb 04                	jmp    1b5 <strlen+0x13>
     1b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     1b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
     1b8:	8b 45 08             	mov    0x8(%ebp),%eax
     1bb:	01 d0                	add    %edx,%eax
     1bd:	0f b6 00             	movzbl (%eax),%eax
     1c0:	84 c0                	test   %al,%al
     1c2:	75 ed                	jne    1b1 <strlen+0xf>
    ;
  return n;
     1c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     1c7:	c9                   	leave  
     1c8:	c3                   	ret    

000001c9 <memset>:

void*
memset(void *dst, int c, uint n)
{
     1c9:	55                   	push   %ebp
     1ca:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     1cc:	8b 45 10             	mov    0x10(%ebp),%eax
     1cf:	50                   	push   %eax
     1d0:	ff 75 0c             	pushl  0xc(%ebp)
     1d3:	ff 75 08             	pushl  0x8(%ebp)
     1d6:	e8 33 ff ff ff       	call   10e <stosb>
     1db:	83 c4 0c             	add    $0xc,%esp
  return dst;
     1de:	8b 45 08             	mov    0x8(%ebp),%eax
}
     1e1:	c9                   	leave  
     1e2:	c3                   	ret    

000001e3 <strchr>:

char*
strchr(const char *s, char c)
{
     1e3:	55                   	push   %ebp
     1e4:	89 e5                	mov    %esp,%ebp
     1e6:	83 ec 04             	sub    $0x4,%esp
     1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
     1ec:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     1ef:	eb 14                	jmp    205 <strchr+0x22>
    if(*s == c)
     1f1:	8b 45 08             	mov    0x8(%ebp),%eax
     1f4:	0f b6 00             	movzbl (%eax),%eax
     1f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
     1fa:	75 05                	jne    201 <strchr+0x1e>
      return (char*)s;
     1fc:	8b 45 08             	mov    0x8(%ebp),%eax
     1ff:	eb 13                	jmp    214 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     201:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     205:	8b 45 08             	mov    0x8(%ebp),%eax
     208:	0f b6 00             	movzbl (%eax),%eax
     20b:	84 c0                	test   %al,%al
     20d:	75 e2                	jne    1f1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     20f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     214:	c9                   	leave  
     215:	c3                   	ret    

00000216 <gets>:

char*
gets(char *buf, int max)
{
     216:	55                   	push   %ebp
     217:	89 e5                	mov    %esp,%ebp
     219:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     21c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     223:	eb 44                	jmp    269 <gets+0x53>
    cc = read(0, &c, 1);
     225:	83 ec 04             	sub    $0x4,%esp
     228:	6a 01                	push   $0x1
     22a:	8d 45 ef             	lea    -0x11(%ebp),%eax
     22d:	50                   	push   %eax
     22e:	6a 00                	push   $0x0
     230:	e8 46 01 00 00       	call   37b <read>
     235:	83 c4 10             	add    $0x10,%esp
     238:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     23b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     23f:	7f 02                	jg     243 <gets+0x2d>
      break;
     241:	eb 31                	jmp    274 <gets+0x5e>
    buf[i++] = c;
     243:	8b 45 f4             	mov    -0xc(%ebp),%eax
     246:	8d 50 01             	lea    0x1(%eax),%edx
     249:	89 55 f4             	mov    %edx,-0xc(%ebp)
     24c:	89 c2                	mov    %eax,%edx
     24e:	8b 45 08             	mov    0x8(%ebp),%eax
     251:	01 c2                	add    %eax,%edx
     253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     25d:	3c 0a                	cmp    $0xa,%al
     25f:	74 13                	je     274 <gets+0x5e>
     261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     265:	3c 0d                	cmp    $0xd,%al
     267:	74 0b                	je     274 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     269:	8b 45 f4             	mov    -0xc(%ebp),%eax
     26c:	83 c0 01             	add    $0x1,%eax
     26f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     272:	7c b1                	jl     225 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     274:	8b 55 f4             	mov    -0xc(%ebp),%edx
     277:	8b 45 08             	mov    0x8(%ebp),%eax
     27a:	01 d0                	add    %edx,%eax
     27c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     27f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     282:	c9                   	leave  
     283:	c3                   	ret    

00000284 <stat>:

int
stat(char *n, struct stat *st)
{
     284:	55                   	push   %ebp
     285:	89 e5                	mov    %esp,%ebp
     287:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     28a:	83 ec 08             	sub    $0x8,%esp
     28d:	6a 00                	push   $0x0
     28f:	ff 75 08             	pushl  0x8(%ebp)
     292:	e8 0c 01 00 00       	call   3a3 <open>
     297:	83 c4 10             	add    $0x10,%esp
     29a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     29d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2a1:	79 07                	jns    2aa <stat+0x26>
    return -1;
     2a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     2a8:	eb 25                	jmp    2cf <stat+0x4b>
  r = fstat(fd, st);
     2aa:	83 ec 08             	sub    $0x8,%esp
     2ad:	ff 75 0c             	pushl  0xc(%ebp)
     2b0:	ff 75 f4             	pushl  -0xc(%ebp)
     2b3:	e8 03 01 00 00       	call   3bb <fstat>
     2b8:	83 c4 10             	add    $0x10,%esp
     2bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     2be:	83 ec 0c             	sub    $0xc,%esp
     2c1:	ff 75 f4             	pushl  -0xc(%ebp)
     2c4:	e8 c2 00 00 00       	call   38b <close>
     2c9:	83 c4 10             	add    $0x10,%esp
  return r;
     2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     2cf:	c9                   	leave  
     2d0:	c3                   	ret    

000002d1 <atoi>:

int
atoi(const char *s)
{
     2d1:	55                   	push   %ebp
     2d2:	89 e5                	mov    %esp,%ebp
     2d4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     2d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     2de:	eb 25                	jmp    305 <atoi+0x34>
    n = n*10 + *s++ - '0';
     2e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
     2e3:	89 d0                	mov    %edx,%eax
     2e5:	c1 e0 02             	shl    $0x2,%eax
     2e8:	01 d0                	add    %edx,%eax
     2ea:	01 c0                	add    %eax,%eax
     2ec:	89 c1                	mov    %eax,%ecx
     2ee:	8b 45 08             	mov    0x8(%ebp),%eax
     2f1:	8d 50 01             	lea    0x1(%eax),%edx
     2f4:	89 55 08             	mov    %edx,0x8(%ebp)
     2f7:	0f b6 00             	movzbl (%eax),%eax
     2fa:	0f be c0             	movsbl %al,%eax
     2fd:	01 c8                	add    %ecx,%eax
     2ff:	83 e8 30             	sub    $0x30,%eax
     302:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     305:	8b 45 08             	mov    0x8(%ebp),%eax
     308:	0f b6 00             	movzbl (%eax),%eax
     30b:	3c 2f                	cmp    $0x2f,%al
     30d:	7e 0a                	jle    319 <atoi+0x48>
     30f:	8b 45 08             	mov    0x8(%ebp),%eax
     312:	0f b6 00             	movzbl (%eax),%eax
     315:	3c 39                	cmp    $0x39,%al
     317:	7e c7                	jle    2e0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     319:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     31c:	c9                   	leave  
     31d:	c3                   	ret    

0000031e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     31e:	55                   	push   %ebp
     31f:	89 e5                	mov    %esp,%ebp
     321:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     324:	8b 45 08             	mov    0x8(%ebp),%eax
     327:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     32a:	8b 45 0c             	mov    0xc(%ebp),%eax
     32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     330:	eb 17                	jmp    349 <memmove+0x2b>
    *dst++ = *src++;
     332:	8b 45 fc             	mov    -0x4(%ebp),%eax
     335:	8d 50 01             	lea    0x1(%eax),%edx
     338:	89 55 fc             	mov    %edx,-0x4(%ebp)
     33b:	8b 55 f8             	mov    -0x8(%ebp),%edx
     33e:	8d 4a 01             	lea    0x1(%edx),%ecx
     341:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     344:	0f b6 12             	movzbl (%edx),%edx
     347:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     349:	8b 45 10             	mov    0x10(%ebp),%eax
     34c:	8d 50 ff             	lea    -0x1(%eax),%edx
     34f:	89 55 10             	mov    %edx,0x10(%ebp)
     352:	85 c0                	test   %eax,%eax
     354:	7f dc                	jg     332 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     356:	8b 45 08             	mov    0x8(%ebp),%eax
}
     359:	c9                   	leave  
     35a:	c3                   	ret    

0000035b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     35b:	b8 01 00 00 00       	mov    $0x1,%eax
     360:	cd 40                	int    $0x40
     362:	c3                   	ret    

00000363 <exit>:
SYSCALL(exit)
     363:	b8 02 00 00 00       	mov    $0x2,%eax
     368:	cd 40                	int    $0x40
     36a:	c3                   	ret    

0000036b <wait>:
SYSCALL(wait)
     36b:	b8 03 00 00 00       	mov    $0x3,%eax
     370:	cd 40                	int    $0x40
     372:	c3                   	ret    

00000373 <pipe>:
SYSCALL(pipe)
     373:	b8 04 00 00 00       	mov    $0x4,%eax
     378:	cd 40                	int    $0x40
     37a:	c3                   	ret    

0000037b <read>:
SYSCALL(read)
     37b:	b8 05 00 00 00       	mov    $0x5,%eax
     380:	cd 40                	int    $0x40
     382:	c3                   	ret    

00000383 <write>:
SYSCALL(write)
     383:	b8 10 00 00 00       	mov    $0x10,%eax
     388:	cd 40                	int    $0x40
     38a:	c3                   	ret    

0000038b <close>:
SYSCALL(close)
     38b:	b8 15 00 00 00       	mov    $0x15,%eax
     390:	cd 40                	int    $0x40
     392:	c3                   	ret    

00000393 <kill>:
SYSCALL(kill)
     393:	b8 06 00 00 00       	mov    $0x6,%eax
     398:	cd 40                	int    $0x40
     39a:	c3                   	ret    

0000039b <exec>:
SYSCALL(exec)
     39b:	b8 07 00 00 00       	mov    $0x7,%eax
     3a0:	cd 40                	int    $0x40
     3a2:	c3                   	ret    

000003a3 <open>:
SYSCALL(open)
     3a3:	b8 0f 00 00 00       	mov    $0xf,%eax
     3a8:	cd 40                	int    $0x40
     3aa:	c3                   	ret    

000003ab <mknod>:
SYSCALL(mknod)
     3ab:	b8 11 00 00 00       	mov    $0x11,%eax
     3b0:	cd 40                	int    $0x40
     3b2:	c3                   	ret    

000003b3 <unlink>:
SYSCALL(unlink)
     3b3:	b8 12 00 00 00       	mov    $0x12,%eax
     3b8:	cd 40                	int    $0x40
     3ba:	c3                   	ret    

000003bb <fstat>:
SYSCALL(fstat)
     3bb:	b8 08 00 00 00       	mov    $0x8,%eax
     3c0:	cd 40                	int    $0x40
     3c2:	c3                   	ret    

000003c3 <link>:
SYSCALL(link)
     3c3:	b8 13 00 00 00       	mov    $0x13,%eax
     3c8:	cd 40                	int    $0x40
     3ca:	c3                   	ret    

000003cb <mkdir>:
SYSCALL(mkdir)
     3cb:	b8 14 00 00 00       	mov    $0x14,%eax
     3d0:	cd 40                	int    $0x40
     3d2:	c3                   	ret    

000003d3 <chdir>:
SYSCALL(chdir)
     3d3:	b8 09 00 00 00       	mov    $0x9,%eax
     3d8:	cd 40                	int    $0x40
     3da:	c3                   	ret    

000003db <dup>:
SYSCALL(dup)
     3db:	b8 0a 00 00 00       	mov    $0xa,%eax
     3e0:	cd 40                	int    $0x40
     3e2:	c3                   	ret    

000003e3 <getpid>:
SYSCALL(getpid)
     3e3:	b8 0b 00 00 00       	mov    $0xb,%eax
     3e8:	cd 40                	int    $0x40
     3ea:	c3                   	ret    

000003eb <sbrk>:
SYSCALL(sbrk)
     3eb:	b8 0c 00 00 00       	mov    $0xc,%eax
     3f0:	cd 40                	int    $0x40
     3f2:	c3                   	ret    

000003f3 <sleep>:
SYSCALL(sleep)
     3f3:	b8 0d 00 00 00       	mov    $0xd,%eax
     3f8:	cd 40                	int    $0x40
     3fa:	c3                   	ret    

000003fb <uptime>:
SYSCALL(uptime)
     3fb:	b8 0e 00 00 00       	mov    $0xe,%eax
     400:	cd 40                	int    $0x40
     402:	c3                   	ret    

00000403 <getcwd>:
SYSCALL(getcwd)
     403:	b8 16 00 00 00       	mov    $0x16,%eax
     408:	cd 40                	int    $0x40
     40a:	c3                   	ret    

0000040b <shutdown>:
SYSCALL(shutdown)
     40b:	b8 17 00 00 00       	mov    $0x17,%eax
     410:	cd 40                	int    $0x40
     412:	c3                   	ret    

00000413 <buildinfo>:
SYSCALL(buildinfo)
     413:	b8 18 00 00 00       	mov    $0x18,%eax
     418:	cd 40                	int    $0x40
     41a:	c3                   	ret    

0000041b <lseek>:
SYSCALL(lseek)
     41b:	b8 19 00 00 00       	mov    $0x19,%eax
     420:	cd 40                	int    $0x40
     422:	c3                   	ret    

00000423 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     423:	55                   	push   %ebp
     424:	89 e5                	mov    %esp,%ebp
     426:	83 ec 18             	sub    $0x18,%esp
     429:	8b 45 0c             	mov    0xc(%ebp),%eax
     42c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     42f:	83 ec 04             	sub    $0x4,%esp
     432:	6a 01                	push   $0x1
     434:	8d 45 f4             	lea    -0xc(%ebp),%eax
     437:	50                   	push   %eax
     438:	ff 75 08             	pushl  0x8(%ebp)
     43b:	e8 43 ff ff ff       	call   383 <write>
     440:	83 c4 10             	add    $0x10,%esp
}
     443:	c9                   	leave  
     444:	c3                   	ret    

00000445 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     445:	55                   	push   %ebp
     446:	89 e5                	mov    %esp,%ebp
     448:	53                   	push   %ebx
     449:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     44c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     453:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     457:	74 17                	je     470 <printint+0x2b>
     459:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     45d:	79 11                	jns    470 <printint+0x2b>
    neg = 1;
     45f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     466:	8b 45 0c             	mov    0xc(%ebp),%eax
     469:	f7 d8                	neg    %eax
     46b:	89 45 ec             	mov    %eax,-0x14(%ebp)
     46e:	eb 06                	jmp    476 <printint+0x31>
  } else {
    x = xx;
     470:	8b 45 0c             	mov    0xc(%ebp),%eax
     473:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     476:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     47d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     480:	8d 41 01             	lea    0x1(%ecx),%eax
     483:	89 45 f4             	mov    %eax,-0xc(%ebp)
     486:	8b 5d 10             	mov    0x10(%ebp),%ebx
     489:	8b 45 ec             	mov    -0x14(%ebp),%eax
     48c:	ba 00 00 00 00       	mov    $0x0,%edx
     491:	f7 f3                	div    %ebx
     493:	89 d0                	mov    %edx,%eax
     495:	0f b6 80 74 14 00 00 	movzbl 0x1474(%eax),%eax
     49c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     4a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
     4a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4a6:	ba 00 00 00 00       	mov    $0x0,%edx
     4ab:	f7 f3                	div    %ebx
     4ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
     4b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     4b4:	75 c7                	jne    47d <printint+0x38>
  if(neg)
     4b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4ba:	74 0e                	je     4ca <printint+0x85>
    buf[i++] = '-';
     4bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4bf:	8d 50 01             	lea    0x1(%eax),%edx
     4c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
     4c5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     4ca:	eb 1d                	jmp    4e9 <printint+0xa4>
    putc(fd, buf[i]);
     4cc:	8d 55 dc             	lea    -0x24(%ebp),%edx
     4cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d2:	01 d0                	add    %edx,%eax
     4d4:	0f b6 00             	movzbl (%eax),%eax
     4d7:	0f be c0             	movsbl %al,%eax
     4da:	83 ec 08             	sub    $0x8,%esp
     4dd:	50                   	push   %eax
     4de:	ff 75 08             	pushl  0x8(%ebp)
     4e1:	e8 3d ff ff ff       	call   423 <putc>
     4e6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     4e9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     4ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     4f1:	79 d9                	jns    4cc <printint+0x87>
    putc(fd, buf[i]);
}
     4f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4f6:	c9                   	leave  
     4f7:	c3                   	ret    

000004f8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     4f8:	55                   	push   %ebp
     4f9:	89 e5                	mov    %esp,%ebp
     4fb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     4fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     505:	8d 45 0c             	lea    0xc(%ebp),%eax
     508:	83 c0 04             	add    $0x4,%eax
     50b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     50e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     515:	e9 59 01 00 00       	jmp    673 <printf+0x17b>
    c = fmt[i] & 0xff;
     51a:	8b 55 0c             	mov    0xc(%ebp),%edx
     51d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     520:	01 d0                	add    %edx,%eax
     522:	0f b6 00             	movzbl (%eax),%eax
     525:	0f be c0             	movsbl %al,%eax
     528:	25 ff 00 00 00       	and    $0xff,%eax
     52d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     530:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     534:	75 2c                	jne    562 <printf+0x6a>
      if(c == '%'){
     536:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     53a:	75 0c                	jne    548 <printf+0x50>
        state = '%';
     53c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     543:	e9 27 01 00 00       	jmp    66f <printf+0x177>
      } else {
        putc(fd, c);
     548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     54b:	0f be c0             	movsbl %al,%eax
     54e:	83 ec 08             	sub    $0x8,%esp
     551:	50                   	push   %eax
     552:	ff 75 08             	pushl  0x8(%ebp)
     555:	e8 c9 fe ff ff       	call   423 <putc>
     55a:	83 c4 10             	add    $0x10,%esp
     55d:	e9 0d 01 00 00       	jmp    66f <printf+0x177>
      }
    } else if(state == '%'){
     562:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     566:	0f 85 03 01 00 00    	jne    66f <printf+0x177>
      if(c == 'd'){
     56c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     570:	75 1e                	jne    590 <printf+0x98>
        printint(fd, *ap, 10, 1);
     572:	8b 45 e8             	mov    -0x18(%ebp),%eax
     575:	8b 00                	mov    (%eax),%eax
     577:	6a 01                	push   $0x1
     579:	6a 0a                	push   $0xa
     57b:	50                   	push   %eax
     57c:	ff 75 08             	pushl  0x8(%ebp)
     57f:	e8 c1 fe ff ff       	call   445 <printint>
     584:	83 c4 10             	add    $0x10,%esp
        ap++;
     587:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     58b:	e9 d8 00 00 00       	jmp    668 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
     590:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     594:	74 06                	je     59c <printf+0xa4>
     596:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     59a:	75 1e                	jne    5ba <printf+0xc2>
        printint(fd, *ap, 16, 0);
     59c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     59f:	8b 00                	mov    (%eax),%eax
     5a1:	6a 00                	push   $0x0
     5a3:	6a 10                	push   $0x10
     5a5:	50                   	push   %eax
     5a6:	ff 75 08             	pushl  0x8(%ebp)
     5a9:	e8 97 fe ff ff       	call   445 <printint>
     5ae:	83 c4 10             	add    $0x10,%esp
        ap++;
     5b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     5b5:	e9 ae 00 00 00       	jmp    668 <printf+0x170>
      } else if(c == 's'){
     5ba:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     5be:	75 43                	jne    603 <printf+0x10b>
        s = (char*)*ap;
     5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5c3:	8b 00                	mov    (%eax),%eax
     5c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     5c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     5cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     5d0:	75 07                	jne    5d9 <printf+0xe1>
          s = "(null)";
     5d2:	c7 45 f4 3e 10 00 00 	movl   $0x103e,-0xc(%ebp)
        while(*s != 0){
     5d9:	eb 1c                	jmp    5f7 <printf+0xff>
          putc(fd, *s);
     5db:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5de:	0f b6 00             	movzbl (%eax),%eax
     5e1:	0f be c0             	movsbl %al,%eax
     5e4:	83 ec 08             	sub    $0x8,%esp
     5e7:	50                   	push   %eax
     5e8:	ff 75 08             	pushl  0x8(%ebp)
     5eb:	e8 33 fe ff ff       	call   423 <putc>
     5f0:	83 c4 10             	add    $0x10,%esp
          s++;
     5f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     5f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5fa:	0f b6 00             	movzbl (%eax),%eax
     5fd:	84 c0                	test   %al,%al
     5ff:	75 da                	jne    5db <printf+0xe3>
     601:	eb 65                	jmp    668 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     603:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     607:	75 1d                	jne    626 <printf+0x12e>
        putc(fd, *ap);
     609:	8b 45 e8             	mov    -0x18(%ebp),%eax
     60c:	8b 00                	mov    (%eax),%eax
     60e:	0f be c0             	movsbl %al,%eax
     611:	83 ec 08             	sub    $0x8,%esp
     614:	50                   	push   %eax
     615:	ff 75 08             	pushl  0x8(%ebp)
     618:	e8 06 fe ff ff       	call   423 <putc>
     61d:	83 c4 10             	add    $0x10,%esp
        ap++;
     620:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     624:	eb 42                	jmp    668 <printf+0x170>
      } else if(c == '%'){
     626:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     62a:	75 17                	jne    643 <printf+0x14b>
        putc(fd, c);
     62c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     62f:	0f be c0             	movsbl %al,%eax
     632:	83 ec 08             	sub    $0x8,%esp
     635:	50                   	push   %eax
     636:	ff 75 08             	pushl  0x8(%ebp)
     639:	e8 e5 fd ff ff       	call   423 <putc>
     63e:	83 c4 10             	add    $0x10,%esp
     641:	eb 25                	jmp    668 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     643:	83 ec 08             	sub    $0x8,%esp
     646:	6a 25                	push   $0x25
     648:	ff 75 08             	pushl  0x8(%ebp)
     64b:	e8 d3 fd ff ff       	call   423 <putc>
     650:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
     653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     656:	0f be c0             	movsbl %al,%eax
     659:	83 ec 08             	sub    $0x8,%esp
     65c:	50                   	push   %eax
     65d:	ff 75 08             	pushl  0x8(%ebp)
     660:	e8 be fd ff ff       	call   423 <putc>
     665:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     668:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     66f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     673:	8b 55 0c             	mov    0xc(%ebp),%edx
     676:	8b 45 f0             	mov    -0x10(%ebp),%eax
     679:	01 d0                	add    %edx,%eax
     67b:	0f b6 00             	movzbl (%eax),%eax
     67e:	84 c0                	test   %al,%al
     680:	0f 85 94 fe ff ff    	jne    51a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     686:	c9                   	leave  
     687:	c3                   	ret    

00000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     688:	55                   	push   %ebp
     689:	89 e5                	mov    %esp,%ebp
     68b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     68e:	8b 45 08             	mov    0x8(%ebp),%eax
     691:	83 e8 08             	sub    $0x8,%eax
     694:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     697:	a1 c8 14 00 00       	mov    0x14c8,%eax
     69c:	89 45 fc             	mov    %eax,-0x4(%ebp)
     69f:	eb 24                	jmp    6c5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6a4:	8b 00                	mov    (%eax),%eax
     6a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     6a9:	77 12                	ja     6bd <free+0x35>
     6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     6b1:	77 24                	ja     6d7 <free+0x4f>
     6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6b6:	8b 00                	mov    (%eax),%eax
     6b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6bb:	77 1a                	ja     6d7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6c0:	8b 00                	mov    (%eax),%eax
     6c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
     6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     6cb:	76 d4                	jbe    6a1 <free+0x19>
     6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6d0:	8b 00                	mov    (%eax),%eax
     6d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6d5:	76 ca                	jbe    6a1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6da:	8b 40 04             	mov    0x4(%eax),%eax
     6dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6e7:	01 c2                	add    %eax,%edx
     6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6ec:	8b 00                	mov    (%eax),%eax
     6ee:	39 c2                	cmp    %eax,%edx
     6f0:	75 24                	jne    716 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6f5:	8b 50 04             	mov    0x4(%eax),%edx
     6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6fb:	8b 00                	mov    (%eax),%eax
     6fd:	8b 40 04             	mov    0x4(%eax),%eax
     700:	01 c2                	add    %eax,%edx
     702:	8b 45 f8             	mov    -0x8(%ebp),%eax
     705:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     708:	8b 45 fc             	mov    -0x4(%ebp),%eax
     70b:	8b 00                	mov    (%eax),%eax
     70d:	8b 10                	mov    (%eax),%edx
     70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     712:	89 10                	mov    %edx,(%eax)
     714:	eb 0a                	jmp    720 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     716:	8b 45 fc             	mov    -0x4(%ebp),%eax
     719:	8b 10                	mov    (%eax),%edx
     71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     71e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     720:	8b 45 fc             	mov    -0x4(%ebp),%eax
     723:	8b 40 04             	mov    0x4(%eax),%eax
     726:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     730:	01 d0                	add    %edx,%eax
     732:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     735:	75 20                	jne    757 <free+0xcf>
    p->s.size += bp->s.size;
     737:	8b 45 fc             	mov    -0x4(%ebp),%eax
     73a:	8b 50 04             	mov    0x4(%eax),%edx
     73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     740:	8b 40 04             	mov    0x4(%eax),%eax
     743:	01 c2                	add    %eax,%edx
     745:	8b 45 fc             	mov    -0x4(%ebp),%eax
     748:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     74e:	8b 10                	mov    (%eax),%edx
     750:	8b 45 fc             	mov    -0x4(%ebp),%eax
     753:	89 10                	mov    %edx,(%eax)
     755:	eb 08                	jmp    75f <free+0xd7>
  } else
    p->s.ptr = bp;
     757:	8b 45 fc             	mov    -0x4(%ebp),%eax
     75a:	8b 55 f8             	mov    -0x8(%ebp),%edx
     75d:	89 10                	mov    %edx,(%eax)
  freep = p;
     75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     762:	a3 c8 14 00 00       	mov    %eax,0x14c8
}
     767:	c9                   	leave  
     768:	c3                   	ret    

00000769 <morecore>:

static Header*
morecore(uint nu)
{
     769:	55                   	push   %ebp
     76a:	89 e5                	mov    %esp,%ebp
     76c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     76f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     776:	77 07                	ja     77f <morecore+0x16>
    nu = 4096;
     778:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     77f:	8b 45 08             	mov    0x8(%ebp),%eax
     782:	c1 e0 03             	shl    $0x3,%eax
     785:	83 ec 0c             	sub    $0xc,%esp
     788:	50                   	push   %eax
     789:	e8 5d fc ff ff       	call   3eb <sbrk>
     78e:	83 c4 10             	add    $0x10,%esp
     791:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     794:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     798:	75 07                	jne    7a1 <morecore+0x38>
    return 0;
     79a:	b8 00 00 00 00       	mov    $0x0,%eax
     79f:	eb 26                	jmp    7c7 <morecore+0x5e>
  hp = (Header*)p;
     7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     7a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7aa:	8b 55 08             	mov    0x8(%ebp),%edx
     7ad:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     7b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7b3:	83 c0 08             	add    $0x8,%eax
     7b6:	83 ec 0c             	sub    $0xc,%esp
     7b9:	50                   	push   %eax
     7ba:	e8 c9 fe ff ff       	call   688 <free>
     7bf:	83 c4 10             	add    $0x10,%esp
  return freep;
     7c2:	a1 c8 14 00 00       	mov    0x14c8,%eax
}
     7c7:	c9                   	leave  
     7c8:	c3                   	ret    

000007c9 <malloc>:

void*
malloc(uint nbytes)
{
     7c9:	55                   	push   %ebp
     7ca:	89 e5                	mov    %esp,%ebp
     7cc:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     7cf:	8b 45 08             	mov    0x8(%ebp),%eax
     7d2:	83 c0 07             	add    $0x7,%eax
     7d5:	c1 e8 03             	shr    $0x3,%eax
     7d8:	83 c0 01             	add    $0x1,%eax
     7db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     7de:	a1 c8 14 00 00       	mov    0x14c8,%eax
     7e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7ea:	75 23                	jne    80f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     7ec:	c7 45 f0 c0 14 00 00 	movl   $0x14c0,-0x10(%ebp)
     7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7f6:	a3 c8 14 00 00       	mov    %eax,0x14c8
     7fb:	a1 c8 14 00 00       	mov    0x14c8,%eax
     800:	a3 c0 14 00 00       	mov    %eax,0x14c0
    base.s.size = 0;
     805:	c7 05 c4 14 00 00 00 	movl   $0x0,0x14c4
     80c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     80f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     812:	8b 00                	mov    (%eax),%eax
     814:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     817:	8b 45 f4             	mov    -0xc(%ebp),%eax
     81a:	8b 40 04             	mov    0x4(%eax),%eax
     81d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     820:	72 4d                	jb     86f <malloc+0xa6>
      if(p->s.size == nunits)
     822:	8b 45 f4             	mov    -0xc(%ebp),%eax
     825:	8b 40 04             	mov    0x4(%eax),%eax
     828:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     82b:	75 0c                	jne    839 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     830:	8b 10                	mov    (%eax),%edx
     832:	8b 45 f0             	mov    -0x10(%ebp),%eax
     835:	89 10                	mov    %edx,(%eax)
     837:	eb 26                	jmp    85f <malloc+0x96>
      else {
        p->s.size -= nunits;
     839:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83c:	8b 40 04             	mov    0x4(%eax),%eax
     83f:	2b 45 ec             	sub    -0x14(%ebp),%eax
     842:	89 c2                	mov    %eax,%edx
     844:	8b 45 f4             	mov    -0xc(%ebp),%eax
     847:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     84d:	8b 40 04             	mov    0x4(%eax),%eax
     850:	c1 e0 03             	shl    $0x3,%eax
     853:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     856:	8b 45 f4             	mov    -0xc(%ebp),%eax
     859:	8b 55 ec             	mov    -0x14(%ebp),%edx
     85c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     85f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     862:	a3 c8 14 00 00       	mov    %eax,0x14c8
      return (void*)(p + 1);
     867:	8b 45 f4             	mov    -0xc(%ebp),%eax
     86a:	83 c0 08             	add    $0x8,%eax
     86d:	eb 3b                	jmp    8aa <malloc+0xe1>
    }
    if(p == freep)
     86f:	a1 c8 14 00 00       	mov    0x14c8,%eax
     874:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     877:	75 1e                	jne    897 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
     879:	83 ec 0c             	sub    $0xc,%esp
     87c:	ff 75 ec             	pushl  -0x14(%ebp)
     87f:	e8 e5 fe ff ff       	call   769 <morecore>
     884:	83 c4 10             	add    $0x10,%esp
     887:	89 45 f4             	mov    %eax,-0xc(%ebp)
     88a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     88e:	75 07                	jne    897 <malloc+0xce>
        return 0;
     890:	b8 00 00 00 00       	mov    $0x0,%eax
     895:	eb 13                	jmp    8aa <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     897:	8b 45 f4             	mov    -0xc(%ebp),%eax
     89a:	89 45 f0             	mov    %eax,-0x10(%ebp)
     89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8a0:	8b 00                	mov    (%eax),%eax
     8a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     8a5:	e9 6d ff ff ff       	jmp    817 <malloc+0x4e>
}
     8aa:	c9                   	leave  
     8ab:	c3                   	ret    

000008ac <isspace>:

#include "common.h"

int isspace(char c) {
     8ac:	55                   	push   %ebp
     8ad:	89 e5                	mov    %esp,%ebp
     8af:	83 ec 04             	sub    $0x4,%esp
     8b2:	8b 45 08             	mov    0x8(%ebp),%eax
     8b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
     8b8:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     8bc:	74 12                	je     8d0 <isspace+0x24>
     8be:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     8c2:	74 0c                	je     8d0 <isspace+0x24>
     8c4:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     8c8:	74 06                	je     8d0 <isspace+0x24>
     8ca:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     8ce:	75 07                	jne    8d7 <isspace+0x2b>
     8d0:	b8 01 00 00 00       	mov    $0x1,%eax
     8d5:	eb 05                	jmp    8dc <isspace+0x30>
     8d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
     8dc:	c9                   	leave  
     8dd:	c3                   	ret    

000008de <readln>:

char* readln(char *buf, int max, int fd)
{
     8de:	55                   	push   %ebp
     8df:	89 e5                	mov    %esp,%ebp
     8e1:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     8e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     8eb:	eb 45                	jmp    932 <readln+0x54>
    cc = read(fd, &c, 1);
     8ed:	83 ec 04             	sub    $0x4,%esp
     8f0:	6a 01                	push   $0x1
     8f2:	8d 45 ef             	lea    -0x11(%ebp),%eax
     8f5:	50                   	push   %eax
     8f6:	ff 75 10             	pushl  0x10(%ebp)
     8f9:	e8 7d fa ff ff       	call   37b <read>
     8fe:	83 c4 10             	add    $0x10,%esp
     901:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     904:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     908:	7f 02                	jg     90c <readln+0x2e>
      break;
     90a:	eb 31                	jmp    93d <readln+0x5f>
    buf[i++] = c;
     90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     90f:	8d 50 01             	lea    0x1(%eax),%edx
     912:	89 55 f4             	mov    %edx,-0xc(%ebp)
     915:	89 c2                	mov    %eax,%edx
     917:	8b 45 08             	mov    0x8(%ebp),%eax
     91a:	01 c2                	add    %eax,%edx
     91c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     920:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     922:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     926:	3c 0a                	cmp    $0xa,%al
     928:	74 13                	je     93d <readln+0x5f>
     92a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     92e:	3c 0d                	cmp    $0xd,%al
     930:	74 0b                	je     93d <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     932:	8b 45 f4             	mov    -0xc(%ebp),%eax
     935:	83 c0 01             	add    $0x1,%eax
     938:	3b 45 0c             	cmp    0xc(%ebp),%eax
     93b:	7c b0                	jl     8ed <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     93d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     940:	8b 45 08             	mov    0x8(%ebp),%eax
     943:	01 d0                	add    %edx,%eax
     945:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     948:	8b 45 08             	mov    0x8(%ebp),%eax
}
     94b:	c9                   	leave  
     94c:	c3                   	ret    

0000094d <strncpy>:

char* strncpy(char* dest, char* src, int n) {
     94d:	55                   	push   %ebp
     94e:	89 e5                	mov    %esp,%ebp
     950:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     953:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     95a:	eb 19                	jmp    975 <strncpy+0x28>
		dest[i] = src[i];
     95c:	8b 55 fc             	mov    -0x4(%ebp),%edx
     95f:	8b 45 08             	mov    0x8(%ebp),%eax
     962:	01 c2                	add    %eax,%edx
     964:	8b 4d fc             	mov    -0x4(%ebp),%ecx
     967:	8b 45 0c             	mov    0xc(%ebp),%eax
     96a:	01 c8                	add    %ecx,%eax
     96c:	0f b6 00             	movzbl (%eax),%eax
     96f:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     971:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     975:	8b 45 fc             	mov    -0x4(%ebp),%eax
     978:	3b 45 10             	cmp    0x10(%ebp),%eax
     97b:	7d 0f                	jge    98c <strncpy+0x3f>
     97d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     980:	8b 45 0c             	mov    0xc(%ebp),%eax
     983:	01 d0                	add    %edx,%eax
     985:	0f b6 00             	movzbl (%eax),%eax
     988:	84 c0                	test   %al,%al
     98a:	75 d0                	jne    95c <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
     98c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     98f:	c9                   	leave  
     990:	c3                   	ret    

00000991 <trim>:

char* trim(char* orig) {
     991:	55                   	push   %ebp
     992:	89 e5                	mov    %esp,%ebp
     994:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
     997:	8b 45 08             	mov    0x8(%ebp),%eax
     99a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
     99d:	8b 45 08             	mov    0x8(%ebp),%eax
     9a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
     9a3:	eb 04                	jmp    9a9 <trim+0x18>
     9a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ac:	0f b6 00             	movzbl (%eax),%eax
     9af:	0f be c0             	movsbl %al,%eax
     9b2:	50                   	push   %eax
     9b3:	e8 f4 fe ff ff       	call   8ac <isspace>
     9b8:	83 c4 04             	add    $0x4,%esp
     9bb:	85 c0                	test   %eax,%eax
     9bd:	75 e6                	jne    9a5 <trim+0x14>
	while (*tail) { tail++; }
     9bf:	eb 04                	jmp    9c5 <trim+0x34>
     9c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     9c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9c8:	0f b6 00             	movzbl (%eax),%eax
     9cb:	84 c0                	test   %al,%al
     9cd:	75 f2                	jne    9c1 <trim+0x30>
	do { tail--; } while (isspace(*tail));
     9cf:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
     9d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9d6:	0f b6 00             	movzbl (%eax),%eax
     9d9:	0f be c0             	movsbl %al,%eax
     9dc:	50                   	push   %eax
     9dd:	e8 ca fe ff ff       	call   8ac <isspace>
     9e2:	83 c4 04             	add    $0x4,%esp
     9e5:	85 c0                	test   %eax,%eax
     9e7:	75 e6                	jne    9cf <trim+0x3e>
	new = malloc(tail-head+2);
     9e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
     9ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ef:	29 c2                	sub    %eax,%edx
     9f1:	89 d0                	mov    %edx,%eax
     9f3:	83 c0 02             	add    $0x2,%eax
     9f6:	83 ec 0c             	sub    $0xc,%esp
     9f9:	50                   	push   %eax
     9fa:	e8 ca fd ff ff       	call   7c9 <malloc>
     9ff:	83 c4 10             	add    $0x10,%esp
     a02:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
     a05:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a0b:	29 c2                	sub    %eax,%edx
     a0d:	89 d0                	mov    %edx,%eax
     a0f:	83 c0 01             	add    $0x1,%eax
     a12:	83 ec 04             	sub    $0x4,%esp
     a15:	50                   	push   %eax
     a16:	ff 75 f4             	pushl  -0xc(%ebp)
     a19:	ff 75 ec             	pushl  -0x14(%ebp)
     a1c:	e8 2c ff ff ff       	call   94d <strncpy>
     a21:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
     a24:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a2a:	29 c2                	sub    %eax,%edx
     a2c:	89 d0                	mov    %edx,%eax
     a2e:	8d 50 01             	lea    0x1(%eax),%edx
     a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
     a34:	01 d0                	add    %edx,%eax
     a36:	c6 00 00             	movb   $0x0,(%eax)
	return new;
     a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
     a3c:	c9                   	leave  
     a3d:	c3                   	ret    

00000a3e <itoa>:

char *
itoa(int value)
{
     a3e:	55                   	push   %ebp
     a3f:	89 e5                	mov    %esp,%ebp
     a41:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
     a44:	8d 45 bf             	lea    -0x41(%ebp),%eax
     a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
     a4a:	8b 45 08             	mov    0x8(%ebp),%eax
     a4d:	c1 e8 1f             	shr    $0x1f,%eax
     a50:	0f b6 c0             	movzbl %al,%eax
     a53:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
     a56:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     a5a:	74 0a                	je     a66 <itoa+0x28>
    v = -value;
     a5c:	8b 45 08             	mov    0x8(%ebp),%eax
     a5f:	f7 d8                	neg    %eax
     a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a64:	eb 06                	jmp    a6c <itoa+0x2e>
  else
    v = (uint)value;
     a66:	8b 45 08             	mov    0x8(%ebp),%eax
     a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
     a6c:	eb 5b                	jmp    ac9 <itoa+0x8b>
  {
    i = v % 10;
     a6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     a71:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     a76:	89 c8                	mov    %ecx,%eax
     a78:	f7 e2                	mul    %edx
     a7a:	c1 ea 03             	shr    $0x3,%edx
     a7d:	89 d0                	mov    %edx,%eax
     a7f:	c1 e0 02             	shl    $0x2,%eax
     a82:	01 d0                	add    %edx,%eax
     a84:	01 c0                	add    %eax,%eax
     a86:	29 c1                	sub    %eax,%ecx
     a88:	89 ca                	mov    %ecx,%edx
     a8a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
     a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a90:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     a95:	f7 e2                	mul    %edx
     a97:	89 d0                	mov    %edx,%eax
     a99:	c1 e8 03             	shr    $0x3,%eax
     a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
     a9f:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
     aa3:	7f 13                	jg     ab8 <itoa+0x7a>
      *tp++ = i+'0';
     aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa8:	8d 50 01             	lea    0x1(%eax),%edx
     aab:	89 55 f4             	mov    %edx,-0xc(%ebp)
     aae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     ab1:	83 c2 30             	add    $0x30,%edx
     ab4:	88 10                	mov    %dl,(%eax)
     ab6:	eb 11                	jmp    ac9 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
     ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     abb:	8d 50 01             	lea    0x1(%eax),%edx
     abe:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ac1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     ac4:	83 c2 57             	add    $0x57,%edx
     ac7:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
     ac9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     acd:	75 9f                	jne    a6e <itoa+0x30>
     acf:	8d 45 bf             	lea    -0x41(%ebp),%eax
     ad2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     ad5:	74 97                	je     a6e <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
     ad7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ada:	8d 45 bf             	lea    -0x41(%ebp),%eax
     add:	29 c2                	sub    %eax,%edx
     adf:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ae2:	01 d0                	add    %edx,%eax
     ae4:	83 c0 01             	add    $0x1,%eax
     ae7:	83 ec 0c             	sub    $0xc,%esp
     aea:	50                   	push   %eax
     aeb:	e8 d9 fc ff ff       	call   7c9 <malloc>
     af0:	83 c4 10             	add    $0x10,%esp
     af3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
     af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
     af9:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
     afc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b00:	74 0c                	je     b0e <itoa+0xd0>
    *sp++ = '-';
     b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b05:	8d 50 01             	lea    0x1(%eax),%edx
     b08:	89 55 ec             	mov    %edx,-0x14(%ebp)
     b0b:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
     b0e:	eb 15                	jmp    b25 <itoa+0xe7>
    *sp++ = *--tp;
     b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b13:	8d 50 01             	lea    0x1(%eax),%edx
     b16:	89 55 ec             	mov    %edx,-0x14(%ebp)
     b19:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     b1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b20:	0f b6 12             	movzbl (%edx),%edx
     b23:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
     b25:	8d 45 bf             	lea    -0x41(%ebp),%eax
     b28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     b2b:	77 e3                	ja     b10 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
     b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b30:	c6 00 00             	movb   $0x0,(%eax)
  return string;
     b33:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
     b36:	c9                   	leave  
     b37:	c3                   	ret    

00000b38 <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
     b38:	55                   	push   %ebp
     b39:	89 e5                	mov    %esp,%ebp
     b3b:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
     b41:	83 ec 08             	sub    $0x8,%esp
     b44:	6a 00                	push   $0x0
     b46:	ff 75 08             	pushl  0x8(%ebp)
     b49:	e8 55 f8 ff ff       	call   3a3 <open>
     b4e:	83 c4 10             	add    $0x10,%esp
     b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     b54:	e9 22 01 00 00       	jmp    c7b <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
     b59:	83 ec 08             	sub    $0x8,%esp
     b5c:	6a 3d                	push   $0x3d
     b5e:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     b64:	50                   	push   %eax
     b65:	e8 79 f6 ff ff       	call   1e3 <strchr>
     b6a:	83 c4 10             	add    $0x10,%esp
     b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
     b70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b74:	0f 84 23 01 00 00    	je     c9d <parseEnvFile+0x165>
     b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b7e:	0f 84 19 01 00 00    	je     c9d <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
     b84:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b87:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     b8d:	29 c2                	sub    %eax,%edx
     b8f:	89 d0                	mov    %edx,%eax
     b91:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
     b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b97:	83 c0 01             	add    $0x1,%eax
     b9a:	83 ec 0c             	sub    $0xc,%esp
     b9d:	50                   	push   %eax
     b9e:	e8 26 fc ff ff       	call   7c9 <malloc>
     ba3:	83 c4 10             	add    $0x10,%esp
     ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
     ba9:	83 ec 04             	sub    $0x4,%esp
     bac:	ff 75 ec             	pushl  -0x14(%ebp)
     baf:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     bb5:	50                   	push   %eax
     bb6:	ff 75 e8             	pushl  -0x18(%ebp)
     bb9:	e8 8f fd ff ff       	call   94d <strncpy>
     bbe:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
     bc1:	83 ec 0c             	sub    $0xc,%esp
     bc4:	ff 75 e8             	pushl  -0x18(%ebp)
     bc7:	e8 c5 fd ff ff       	call   991 <trim>
     bcc:	83 c4 10             	add    $0x10,%esp
     bcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
     bd2:	83 ec 0c             	sub    $0xc,%esp
     bd5:	ff 75 e8             	pushl  -0x18(%ebp)
     bd8:	e8 ab fa ff ff       	call   688 <free>
     bdd:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
     be0:	83 ec 08             	sub    $0x8,%esp
     be3:	ff 75 0c             	pushl  0xc(%ebp)
     be6:	ff 75 e4             	pushl  -0x1c(%ebp)
     be9:	e8 c2 01 00 00       	call   db0 <addToEnvironment>
     bee:	83 c4 10             	add    $0x10,%esp
     bf1:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
     bf4:	83 ec 0c             	sub    $0xc,%esp
     bf7:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     bfd:	50                   	push   %eax
     bfe:	e8 9f f5 ff ff       	call   1a2 <strlen>
     c03:	83 c4 10             	add    $0x10,%esp
     c06:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
     c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c0c:	2b 45 ec             	sub    -0x14(%ebp),%eax
     c0f:	83 ec 0c             	sub    $0xc,%esp
     c12:	50                   	push   %eax
     c13:	e8 b1 fb ff ff       	call   7c9 <malloc>
     c18:	83 c4 10             	add    $0x10,%esp
     c1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
     c1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c21:	2b 45 ec             	sub    -0x14(%ebp),%eax
     c24:	8d 50 ff             	lea    -0x1(%eax),%edx
     c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c2a:	8d 48 01             	lea    0x1(%eax),%ecx
     c2d:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     c33:	01 c8                	add    %ecx,%eax
     c35:	83 ec 04             	sub    $0x4,%esp
     c38:	52                   	push   %edx
     c39:	50                   	push   %eax
     c3a:	ff 75 e8             	pushl  -0x18(%ebp)
     c3d:	e8 0b fd ff ff       	call   94d <strncpy>
     c42:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
     c45:	83 ec 0c             	sub    $0xc,%esp
     c48:	ff 75 e8             	pushl  -0x18(%ebp)
     c4b:	e8 41 fd ff ff       	call   991 <trim>
     c50:	83 c4 10             	add    $0x10,%esp
     c53:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
     c56:	83 ec 0c             	sub    $0xc,%esp
     c59:	ff 75 e8             	pushl  -0x18(%ebp)
     c5c:	e8 27 fa ff ff       	call   688 <free>
     c61:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
     c64:	83 ec 04             	sub    $0x4,%esp
     c67:	ff 75 dc             	pushl  -0x24(%ebp)
     c6a:	ff 75 0c             	pushl  0xc(%ebp)
     c6d:	ff 75 e4             	pushl  -0x1c(%ebp)
     c70:	e8 b8 01 00 00       	call   e2d <addValueToVariable>
     c75:	83 c4 10             	add    $0x10,%esp
     c78:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     c7b:	83 ec 04             	sub    $0x4,%esp
     c7e:	ff 75 f4             	pushl  -0xc(%ebp)
     c81:	68 00 04 00 00       	push   $0x400
     c86:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     c8c:	50                   	push   %eax
     c8d:	e8 4c fc ff ff       	call   8de <readln>
     c92:	83 c4 10             	add    $0x10,%esp
     c95:	85 c0                	test   %eax,%eax
     c97:	0f 85 bc fe ff ff    	jne    b59 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
     c9d:	83 ec 0c             	sub    $0xc,%esp
     ca0:	ff 75 f4             	pushl  -0xc(%ebp)
     ca3:	e8 e3 f6 ff ff       	call   38b <close>
     ca8:	83 c4 10             	add    $0x10,%esp
	return head;
     cab:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     cae:	c9                   	leave  
     caf:	c3                   	ret    

00000cb0 <comp>:

int comp(const char* s1, const char* s2)
{
     cb0:	55                   	push   %ebp
     cb1:	89 e5                	mov    %esp,%ebp
     cb3:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
     cb6:	83 ec 08             	sub    $0x8,%esp
     cb9:	ff 75 0c             	pushl  0xc(%ebp)
     cbc:	ff 75 08             	pushl  0x8(%ebp)
     cbf:	e8 9f f4 ff ff       	call   163 <strcmp>
     cc4:	83 c4 10             	add    $0x10,%esp
     cc7:	85 c0                	test   %eax,%eax
     cc9:	0f 94 c0             	sete   %al
     ccc:	0f b6 c0             	movzbl %al,%eax
}
     ccf:	c9                   	leave  
     cd0:	c3                   	ret    

00000cd1 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
     cd1:	55                   	push   %ebp
     cd2:	89 e5                	mov    %esp,%ebp
     cd4:	83 ec 08             	sub    $0x8,%esp
  if (!name)
     cd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     cdb:	75 07                	jne    ce4 <environLookup+0x13>
    return NULL;
     cdd:	b8 00 00 00 00       	mov    $0x0,%eax
     ce2:	eb 2f                	jmp    d13 <environLookup+0x42>
  
  while (head)
     ce4:	eb 24                	jmp    d0a <environLookup+0x39>
  {
    if (comp(name, head->name))
     ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ce9:	83 ec 08             	sub    $0x8,%esp
     cec:	50                   	push   %eax
     ced:	ff 75 08             	pushl  0x8(%ebp)
     cf0:	e8 bb ff ff ff       	call   cb0 <comp>
     cf5:	83 c4 10             	add    $0x10,%esp
     cf8:	85 c0                	test   %eax,%eax
     cfa:	74 02                	je     cfe <environLookup+0x2d>
      break;
     cfc:	eb 12                	jmp    d10 <environLookup+0x3f>
    head = head->next;
     cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
     d01:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     d07:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
     d0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     d0e:	75 d6                	jne    ce6 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
     d10:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     d13:	c9                   	leave  
     d14:	c3                   	ret    

00000d15 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
     d15:	55                   	push   %ebp
     d16:	89 e5                	mov    %esp,%ebp
     d18:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
     d1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     d1f:	75 0a                	jne    d2b <removeFromEnvironment+0x16>
    return NULL;
     d21:	b8 00 00 00 00       	mov    $0x0,%eax
     d26:	e9 83 00 00 00       	jmp    dae <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
     d2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     d2f:	74 0a                	je     d3b <removeFromEnvironment+0x26>
     d31:	8b 45 08             	mov    0x8(%ebp),%eax
     d34:	0f b6 00             	movzbl (%eax),%eax
     d37:	84 c0                	test   %al,%al
     d39:	75 05                	jne    d40 <removeFromEnvironment+0x2b>
    return head;
     d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
     d3e:	eb 6e                	jmp    dae <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
     d40:	8b 45 0c             	mov    0xc(%ebp),%eax
     d43:	83 ec 08             	sub    $0x8,%esp
     d46:	ff 75 08             	pushl  0x8(%ebp)
     d49:	50                   	push   %eax
     d4a:	e8 61 ff ff ff       	call   cb0 <comp>
     d4f:	83 c4 10             	add    $0x10,%esp
     d52:	85 c0                	test   %eax,%eax
     d54:	74 34                	je     d8a <removeFromEnvironment+0x75>
  {
    tmp = head->next;
     d56:	8b 45 0c             	mov    0xc(%ebp),%eax
     d59:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
     d62:	8b 45 0c             	mov    0xc(%ebp),%eax
     d65:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     d6b:	83 ec 0c             	sub    $0xc,%esp
     d6e:	50                   	push   %eax
     d6f:	e8 74 01 00 00       	call   ee8 <freeVarval>
     d74:	83 c4 10             	add    $0x10,%esp
    free(head);
     d77:	83 ec 0c             	sub    $0xc,%esp
     d7a:	ff 75 0c             	pushl  0xc(%ebp)
     d7d:	e8 06 f9 ff ff       	call   688 <free>
     d82:	83 c4 10             	add    $0x10,%esp
    return tmp;
     d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d88:	eb 24                	jmp    dae <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
     d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
     d8d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     d93:	83 ec 08             	sub    $0x8,%esp
     d96:	50                   	push   %eax
     d97:	ff 75 08             	pushl  0x8(%ebp)
     d9a:	e8 76 ff ff ff       	call   d15 <removeFromEnvironment>
     d9f:	83 c4 10             	add    $0x10,%esp
     da2:	8b 55 0c             	mov    0xc(%ebp),%edx
     da5:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
     dab:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     dae:	c9                   	leave  
     daf:	c3                   	ret    

00000db0 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
     db0:	55                   	push   %ebp
     db1:	89 e5                	mov    %esp,%ebp
     db3:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
     db6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     dba:	75 05                	jne    dc1 <addToEnvironment+0x11>
		return head;
     dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
     dbf:	eb 6a                	jmp    e2b <addToEnvironment+0x7b>
	if (head == NULL) {
     dc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     dc5:	75 40                	jne    e07 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
     dc7:	83 ec 0c             	sub    $0xc,%esp
     dca:	68 88 00 00 00       	push   $0x88
     dcf:	e8 f5 f9 ff ff       	call   7c9 <malloc>
     dd4:	83 c4 10             	add    $0x10,%esp
     dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
     dda:	8b 45 08             	mov    0x8(%ebp),%eax
     ddd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
     de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de3:	83 ec 08             	sub    $0x8,%esp
     de6:	ff 75 f0             	pushl  -0x10(%ebp)
     de9:	50                   	push   %eax
     dea:	e8 44 f3 ff ff       	call   133 <strcpy>
     def:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
     df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
     dfc:	00 00 00 
		head = newVar;
     dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e02:	89 45 0c             	mov    %eax,0xc(%ebp)
     e05:	eb 21                	jmp    e28 <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
     e07:	8b 45 0c             	mov    0xc(%ebp),%eax
     e0a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     e10:	83 ec 08             	sub    $0x8,%esp
     e13:	50                   	push   %eax
     e14:	ff 75 08             	pushl  0x8(%ebp)
     e17:	e8 94 ff ff ff       	call   db0 <addToEnvironment>
     e1c:	83 c4 10             	add    $0x10,%esp
     e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
     e22:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
     e28:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     e2b:	c9                   	leave  
     e2c:	c3                   	ret    

00000e2d <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
     e2d:	55                   	push   %ebp
     e2e:	89 e5                	mov    %esp,%ebp
     e30:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
     e33:	83 ec 08             	sub    $0x8,%esp
     e36:	ff 75 0c             	pushl  0xc(%ebp)
     e39:	ff 75 08             	pushl  0x8(%ebp)
     e3c:	e8 90 fe ff ff       	call   cd1 <environLookup>
     e41:	83 c4 10             	add    $0x10,%esp
     e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
     e47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e4b:	75 05                	jne    e52 <addValueToVariable+0x25>
		return head;
     e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
     e50:	eb 4c                	jmp    e9e <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
     e52:	83 ec 0c             	sub    $0xc,%esp
     e55:	68 04 04 00 00       	push   $0x404
     e5a:	e8 6a f9 ff ff       	call   7c9 <malloc>
     e5f:	83 c4 10             	add    $0x10,%esp
     e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
     e65:	8b 45 10             	mov    0x10(%ebp),%eax
     e68:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
     e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e6e:	83 ec 08             	sub    $0x8,%esp
     e71:	ff 75 ec             	pushl  -0x14(%ebp)
     e74:	50                   	push   %eax
     e75:	e8 b9 f2 ff ff       	call   133 <strcpy>
     e7a:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
     e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e80:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
     e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e89:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
     e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e92:	8b 55 f0             	mov    -0x10(%ebp),%edx
     e95:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
     e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     e9e:	c9                   	leave  
     e9f:	c3                   	ret    

00000ea0 <freeEnvironment>:

void freeEnvironment(variable* head)
{
     ea0:	55                   	push   %ebp
     ea1:	89 e5                	mov    %esp,%ebp
     ea3:	83 ec 08             	sub    $0x8,%esp
  if (!head)
     ea6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     eaa:	75 02                	jne    eae <freeEnvironment+0xe>
    return;  
     eac:	eb 38                	jmp    ee6 <freeEnvironment+0x46>
  freeEnvironment(head->next);
     eae:	8b 45 08             	mov    0x8(%ebp),%eax
     eb1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     eb7:	83 ec 0c             	sub    $0xc,%esp
     eba:	50                   	push   %eax
     ebb:	e8 e0 ff ff ff       	call   ea0 <freeEnvironment>
     ec0:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
     ec3:	8b 45 08             	mov    0x8(%ebp),%eax
     ec6:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     ecc:	83 ec 0c             	sub    $0xc,%esp
     ecf:	50                   	push   %eax
     ed0:	e8 13 00 00 00       	call   ee8 <freeVarval>
     ed5:	83 c4 10             	add    $0x10,%esp
  free(head);
     ed8:	83 ec 0c             	sub    $0xc,%esp
     edb:	ff 75 08             	pushl  0x8(%ebp)
     ede:	e8 a5 f7 ff ff       	call   688 <free>
     ee3:	83 c4 10             	add    $0x10,%esp
}
     ee6:	c9                   	leave  
     ee7:	c3                   	ret    

00000ee8 <freeVarval>:

void freeVarval(varval* head)
{
     ee8:	55                   	push   %ebp
     ee9:	89 e5                	mov    %esp,%ebp
     eeb:	83 ec 08             	sub    $0x8,%esp
  if (!head)
     eee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ef2:	75 02                	jne    ef6 <freeVarval+0xe>
    return;  
     ef4:	eb 23                	jmp    f19 <freeVarval+0x31>
  freeVarval(head->next);
     ef6:	8b 45 08             	mov    0x8(%ebp),%eax
     ef9:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
     eff:	83 ec 0c             	sub    $0xc,%esp
     f02:	50                   	push   %eax
     f03:	e8 e0 ff ff ff       	call   ee8 <freeVarval>
     f08:	83 c4 10             	add    $0x10,%esp
  free(head);
     f0b:	83 ec 0c             	sub    $0xc,%esp
     f0e:	ff 75 08             	pushl  0x8(%ebp)
     f11:	e8 72 f7 ff ff       	call   688 <free>
     f16:	83 c4 10             	add    $0x10,%esp
}
     f19:	c9                   	leave  
     f1a:	c3                   	ret    

00000f1b <getPaths>:

varval* getPaths(char* paths, varval* head) {
     f1b:	55                   	push   %ebp
     f1c:	89 e5                	mov    %esp,%ebp
     f1e:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
     f21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f25:	75 08                	jne    f2f <getPaths+0x14>
		return head;
     f27:	8b 45 0c             	mov    0xc(%ebp),%eax
     f2a:	e9 e7 00 00 00       	jmp    1016 <getPaths+0xfb>
	if (head == NULL) {
     f2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f33:	0f 85 b9 00 00 00    	jne    ff2 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
     f39:	83 ec 08             	sub    $0x8,%esp
     f3c:	6a 3a                	push   $0x3a
     f3e:	ff 75 08             	pushl  0x8(%ebp)
     f41:	e8 9d f2 ff ff       	call   1e3 <strchr>
     f46:	83 c4 10             	add    $0x10,%esp
     f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
     f4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f50:	75 56                	jne    fa8 <getPaths+0x8d>
			pathLen = strlen(paths);
     f52:	83 ec 0c             	sub    $0xc,%esp
     f55:	ff 75 08             	pushl  0x8(%ebp)
     f58:	e8 45 f2 ff ff       	call   1a2 <strlen>
     f5d:	83 c4 10             	add    $0x10,%esp
     f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
     f63:	83 ec 0c             	sub    $0xc,%esp
     f66:	68 04 04 00 00       	push   $0x404
     f6b:	e8 59 f8 ff ff       	call   7c9 <malloc>
     f70:	83 c4 10             	add    $0x10,%esp
     f73:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
     f76:	8b 45 0c             	mov    0xc(%ebp),%eax
     f79:	83 ec 04             	sub    $0x4,%esp
     f7c:	ff 75 f0             	pushl  -0x10(%ebp)
     f7f:	ff 75 08             	pushl  0x8(%ebp)
     f82:	50                   	push   %eax
     f83:	e8 c5 f9 ff ff       	call   94d <strncpy>
     f88:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
     f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
     f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f91:	01 d0                	add    %edx,%eax
     f93:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
     f96:	8b 45 0c             	mov    0xc(%ebp),%eax
     f99:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
     fa0:	00 00 00 
			return head;
     fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
     fa6:	eb 6e                	jmp    1016 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
     fa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     fab:	8b 45 08             	mov    0x8(%ebp),%eax
     fae:	29 c2                	sub    %eax,%edx
     fb0:	89 d0                	mov    %edx,%eax
     fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
     fb5:	83 ec 0c             	sub    $0xc,%esp
     fb8:	68 04 04 00 00       	push   $0x404
     fbd:	e8 07 f8 ff ff       	call   7c9 <malloc>
     fc2:	83 c4 10             	add    $0x10,%esp
     fc5:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
     fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
     fcb:	83 ec 04             	sub    $0x4,%esp
     fce:	ff 75 f0             	pushl  -0x10(%ebp)
     fd1:	ff 75 08             	pushl  0x8(%ebp)
     fd4:	50                   	push   %eax
     fd5:	e8 73 f9 ff ff       	call   94d <strncpy>
     fda:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
     fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
     fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fe3:	01 d0                	add    %edx,%eax
     fe5:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
     fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     feb:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
     fee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
     ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ff5:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
     ffb:	83 ec 08             	sub    $0x8,%esp
     ffe:	50                   	push   %eax
     fff:	ff 75 08             	pushl  0x8(%ebp)
    1002:	e8 14 ff ff ff       	call   f1b <getPaths>
    1007:	83 c4 10             	add    $0x10,%esp
    100a:	8b 55 0c             	mov    0xc(%ebp),%edx
    100d:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
    1013:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    1016:	c9                   	leave  
    1017:	c3                   	ret    
