
_init:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
      11:	83 ec 08             	sub    $0x8,%esp
      14:	6a 02                	push   $0x2
      16:	68 0c 10 00 00       	push   $0x100c
      1b:	e8 74 03 00 00       	call   394 <open>
      20:	83 c4 10             	add    $0x10,%esp
      23:	85 c0                	test   %eax,%eax
      25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
      27:	83 ec 04             	sub    $0x4,%esp
      2a:	6a 01                	push   $0x1
      2c:	6a 01                	push   $0x1
      2e:	68 0c 10 00 00       	push   $0x100c
      33:	e8 64 03 00 00       	call   39c <mknod>
      38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
      3b:	83 ec 08             	sub    $0x8,%esp
      3e:	6a 02                	push   $0x2
      40:	68 0c 10 00 00       	push   $0x100c
      45:	e8 4a 03 00 00       	call   394 <open>
      4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
      4d:	83 ec 0c             	sub    $0xc,%esp
      50:	6a 00                	push   $0x0
      52:	e8 75 03 00 00       	call   3cc <dup>
      57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
      5a:	83 ec 0c             	sub    $0xc,%esp
      5d:	6a 00                	push   $0x0
      5f:	e8 68 03 00 00       	call   3cc <dup>
      64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    //printf(1,  "Qwin\n);
    printf(1, "init: starting sh\n\n");
      67:	83 ec 08             	sub    $0x8,%esp
      6a:	68 14 10 00 00       	push   $0x1014
      6f:	6a 01                	push   $0x1
      71:	e8 73 04 00 00       	call   4e9 <printf>
      76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
      79:	e8 ce 02 00 00       	call   34c <fork>
      7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
      81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
      87:	83 ec 08             	sub    $0x8,%esp
      8a:	68 28 10 00 00       	push   $0x1028
      8f:	6a 01                	push   $0x1
      91:	e8 53 04 00 00       	call   4e9 <printf>
      96:	83 c4 10             	add    $0x10,%esp
      exit();
      99:	e8 b6 02 00 00       	call   354 <exit>
    }
    if(pid == 0){
      9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      a2:	75 2c                	jne    d0 <main+0xd0>
      exec("sh", argv);
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	68 6c 14 00 00       	push   $0x146c
      ac:	68 09 10 00 00       	push   $0x1009
      b1:	e8 d6 02 00 00       	call   38c <exec>
      b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
      b9:	83 ec 08             	sub    $0x8,%esp
      bc:	68 3b 10 00 00       	push   $0x103b
      c1:	6a 01                	push   $0x1
      c3:	e8 21 04 00 00       	call   4e9 <printf>
      c8:	83 c4 10             	add    $0x10,%esp
      exit();
      cb:	e8 84 02 00 00       	call   354 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      d0:	eb 12                	jmp    e4 <main+0xe4>
      printf(1, "zombie!\n");
      d2:	83 ec 08             	sub    $0x8,%esp
      d5:	68 51 10 00 00       	push   $0x1051
      da:	6a 01                	push   $0x1
      dc:	e8 08 04 00 00       	call   4e9 <printf>
      e1:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      e4:	e8 73 02 00 00       	call   35c <wait>
      e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
      ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
      f0:	78 08                	js     fa <main+0xfa>
      f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
      f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
      f8:	75 d8                	jne    d2 <main+0xd2>
      printf(1, "zombie!\n");
  }
      fa:	e9 68 ff ff ff       	jmp    67 <main+0x67>

000000ff <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
      ff:	55                   	push   %ebp
     100:	89 e5                	mov    %esp,%ebp
     102:	57                   	push   %edi
     103:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     104:	8b 4d 08             	mov    0x8(%ebp),%ecx
     107:	8b 55 10             	mov    0x10(%ebp),%edx
     10a:	8b 45 0c             	mov    0xc(%ebp),%eax
     10d:	89 cb                	mov    %ecx,%ebx
     10f:	89 df                	mov    %ebx,%edi
     111:	89 d1                	mov    %edx,%ecx
     113:	fc                   	cld    
     114:	f3 aa                	rep stos %al,%es:(%edi)
     116:	89 ca                	mov    %ecx,%edx
     118:	89 fb                	mov    %edi,%ebx
     11a:	89 5d 08             	mov    %ebx,0x8(%ebp)
     11d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     120:	5b                   	pop    %ebx
     121:	5f                   	pop    %edi
     122:	5d                   	pop    %ebp
     123:	c3                   	ret    

00000124 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     124:	55                   	push   %ebp
     125:	89 e5                	mov    %esp,%ebp
     127:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     12a:	8b 45 08             	mov    0x8(%ebp),%eax
     12d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     130:	90                   	nop
     131:	8b 45 08             	mov    0x8(%ebp),%eax
     134:	8d 50 01             	lea    0x1(%eax),%edx
     137:	89 55 08             	mov    %edx,0x8(%ebp)
     13a:	8b 55 0c             	mov    0xc(%ebp),%edx
     13d:	8d 4a 01             	lea    0x1(%edx),%ecx
     140:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     143:	0f b6 12             	movzbl (%edx),%edx
     146:	88 10                	mov    %dl,(%eax)
     148:	0f b6 00             	movzbl (%eax),%eax
     14b:	84 c0                	test   %al,%al
     14d:	75 e2                	jne    131 <strcpy+0xd>
    ;
  return os;
     14f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     152:	c9                   	leave  
     153:	c3                   	ret    

00000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     154:	55                   	push   %ebp
     155:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     157:	eb 08                	jmp    161 <strcmp+0xd>
    p++, q++;
     159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     15d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     161:	8b 45 08             	mov    0x8(%ebp),%eax
     164:	0f b6 00             	movzbl (%eax),%eax
     167:	84 c0                	test   %al,%al
     169:	74 10                	je     17b <strcmp+0x27>
     16b:	8b 45 08             	mov    0x8(%ebp),%eax
     16e:	0f b6 10             	movzbl (%eax),%edx
     171:	8b 45 0c             	mov    0xc(%ebp),%eax
     174:	0f b6 00             	movzbl (%eax),%eax
     177:	38 c2                	cmp    %al,%dl
     179:	74 de                	je     159 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     17b:	8b 45 08             	mov    0x8(%ebp),%eax
     17e:	0f b6 00             	movzbl (%eax),%eax
     181:	0f b6 d0             	movzbl %al,%edx
     184:	8b 45 0c             	mov    0xc(%ebp),%eax
     187:	0f b6 00             	movzbl (%eax),%eax
     18a:	0f b6 c0             	movzbl %al,%eax
     18d:	29 c2                	sub    %eax,%edx
     18f:	89 d0                	mov    %edx,%eax
}
     191:	5d                   	pop    %ebp
     192:	c3                   	ret    

00000193 <strlen>:

uint
strlen(char *s)
{
     193:	55                   	push   %ebp
     194:	89 e5                	mov    %esp,%ebp
     196:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     1a0:	eb 04                	jmp    1a6 <strlen+0x13>
     1a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     1a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     1a9:	8b 45 08             	mov    0x8(%ebp),%eax
     1ac:	01 d0                	add    %edx,%eax
     1ae:	0f b6 00             	movzbl (%eax),%eax
     1b1:	84 c0                	test   %al,%al
     1b3:	75 ed                	jne    1a2 <strlen+0xf>
    ;
  return n;
     1b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     1b8:	c9                   	leave  
     1b9:	c3                   	ret    

000001ba <memset>:

void*
memset(void *dst, int c, uint n)
{
     1ba:	55                   	push   %ebp
     1bb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     1bd:	8b 45 10             	mov    0x10(%ebp),%eax
     1c0:	50                   	push   %eax
     1c1:	ff 75 0c             	pushl  0xc(%ebp)
     1c4:	ff 75 08             	pushl  0x8(%ebp)
     1c7:	e8 33 ff ff ff       	call   ff <stosb>
     1cc:	83 c4 0c             	add    $0xc,%esp
  return dst;
     1cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
     1d2:	c9                   	leave  
     1d3:	c3                   	ret    

000001d4 <strchr>:

char*
strchr(const char *s, char c)
{
     1d4:	55                   	push   %ebp
     1d5:	89 e5                	mov    %esp,%ebp
     1d7:	83 ec 04             	sub    $0x4,%esp
     1da:	8b 45 0c             	mov    0xc(%ebp),%eax
     1dd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     1e0:	eb 14                	jmp    1f6 <strchr+0x22>
    if(*s == c)
     1e2:	8b 45 08             	mov    0x8(%ebp),%eax
     1e5:	0f b6 00             	movzbl (%eax),%eax
     1e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
     1eb:	75 05                	jne    1f2 <strchr+0x1e>
      return (char*)s;
     1ed:	8b 45 08             	mov    0x8(%ebp),%eax
     1f0:	eb 13                	jmp    205 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     1f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     1f6:	8b 45 08             	mov    0x8(%ebp),%eax
     1f9:	0f b6 00             	movzbl (%eax),%eax
     1fc:	84 c0                	test   %al,%al
     1fe:	75 e2                	jne    1e2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     200:	b8 00 00 00 00       	mov    $0x0,%eax
}
     205:	c9                   	leave  
     206:	c3                   	ret    

00000207 <gets>:

char*
gets(char *buf, int max)
{
     207:	55                   	push   %ebp
     208:	89 e5                	mov    %esp,%ebp
     20a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     20d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     214:	eb 44                	jmp    25a <gets+0x53>
    cc = read(0, &c, 1);
     216:	83 ec 04             	sub    $0x4,%esp
     219:	6a 01                	push   $0x1
     21b:	8d 45 ef             	lea    -0x11(%ebp),%eax
     21e:	50                   	push   %eax
     21f:	6a 00                	push   $0x0
     221:	e8 46 01 00 00       	call   36c <read>
     226:	83 c4 10             	add    $0x10,%esp
     229:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     22c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     230:	7f 02                	jg     234 <gets+0x2d>
      break;
     232:	eb 31                	jmp    265 <gets+0x5e>
    buf[i++] = c;
     234:	8b 45 f4             	mov    -0xc(%ebp),%eax
     237:	8d 50 01             	lea    0x1(%eax),%edx
     23a:	89 55 f4             	mov    %edx,-0xc(%ebp)
     23d:	89 c2                	mov    %eax,%edx
     23f:	8b 45 08             	mov    0x8(%ebp),%eax
     242:	01 c2                	add    %eax,%edx
     244:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     248:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     24a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     24e:	3c 0a                	cmp    $0xa,%al
     250:	74 13                	je     265 <gets+0x5e>
     252:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     256:	3c 0d                	cmp    $0xd,%al
     258:	74 0b                	je     265 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     25a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     25d:	83 c0 01             	add    $0x1,%eax
     260:	3b 45 0c             	cmp    0xc(%ebp),%eax
     263:	7c b1                	jl     216 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     265:	8b 55 f4             	mov    -0xc(%ebp),%edx
     268:	8b 45 08             	mov    0x8(%ebp),%eax
     26b:	01 d0                	add    %edx,%eax
     26d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     270:	8b 45 08             	mov    0x8(%ebp),%eax
}
     273:	c9                   	leave  
     274:	c3                   	ret    

00000275 <stat>:

int
stat(char *n, struct stat *st)
{
     275:	55                   	push   %ebp
     276:	89 e5                	mov    %esp,%ebp
     278:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     27b:	83 ec 08             	sub    $0x8,%esp
     27e:	6a 00                	push   $0x0
     280:	ff 75 08             	pushl  0x8(%ebp)
     283:	e8 0c 01 00 00       	call   394 <open>
     288:	83 c4 10             	add    $0x10,%esp
     28b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     28e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     292:	79 07                	jns    29b <stat+0x26>
    return -1;
     294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     299:	eb 25                	jmp    2c0 <stat+0x4b>
  r = fstat(fd, st);
     29b:	83 ec 08             	sub    $0x8,%esp
     29e:	ff 75 0c             	pushl  0xc(%ebp)
     2a1:	ff 75 f4             	pushl  -0xc(%ebp)
     2a4:	e8 03 01 00 00       	call   3ac <fstat>
     2a9:	83 c4 10             	add    $0x10,%esp
     2ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     2af:	83 ec 0c             	sub    $0xc,%esp
     2b2:	ff 75 f4             	pushl  -0xc(%ebp)
     2b5:	e8 c2 00 00 00       	call   37c <close>
     2ba:	83 c4 10             	add    $0x10,%esp
  return r;
     2bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     2c0:	c9                   	leave  
     2c1:	c3                   	ret    

000002c2 <atoi>:

int
atoi(const char *s)
{
     2c2:	55                   	push   %ebp
     2c3:	89 e5                	mov    %esp,%ebp
     2c5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     2c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     2cf:	eb 25                	jmp    2f6 <atoi+0x34>
    n = n*10 + *s++ - '0';
     2d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     2d4:	89 d0                	mov    %edx,%eax
     2d6:	c1 e0 02             	shl    $0x2,%eax
     2d9:	01 d0                	add    %edx,%eax
     2db:	01 c0                	add    %eax,%eax
     2dd:	89 c1                	mov    %eax,%ecx
     2df:	8b 45 08             	mov    0x8(%ebp),%eax
     2e2:	8d 50 01             	lea    0x1(%eax),%edx
     2e5:	89 55 08             	mov    %edx,0x8(%ebp)
     2e8:	0f b6 00             	movzbl (%eax),%eax
     2eb:	0f be c0             	movsbl %al,%eax
     2ee:	01 c8                	add    %ecx,%eax
     2f0:	83 e8 30             	sub    $0x30,%eax
     2f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     2f6:	8b 45 08             	mov    0x8(%ebp),%eax
     2f9:	0f b6 00             	movzbl (%eax),%eax
     2fc:	3c 2f                	cmp    $0x2f,%al
     2fe:	7e 0a                	jle    30a <atoi+0x48>
     300:	8b 45 08             	mov    0x8(%ebp),%eax
     303:	0f b6 00             	movzbl (%eax),%eax
     306:	3c 39                	cmp    $0x39,%al
     308:	7e c7                	jle    2d1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     30a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     30d:	c9                   	leave  
     30e:	c3                   	ret    

0000030f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     30f:	55                   	push   %ebp
     310:	89 e5                	mov    %esp,%ebp
     312:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     315:	8b 45 08             	mov    0x8(%ebp),%eax
     318:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     31b:	8b 45 0c             	mov    0xc(%ebp),%eax
     31e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     321:	eb 17                	jmp    33a <memmove+0x2b>
    *dst++ = *src++;
     323:	8b 45 fc             	mov    -0x4(%ebp),%eax
     326:	8d 50 01             	lea    0x1(%eax),%edx
     329:	89 55 fc             	mov    %edx,-0x4(%ebp)
     32c:	8b 55 f8             	mov    -0x8(%ebp),%edx
     32f:	8d 4a 01             	lea    0x1(%edx),%ecx
     332:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     335:	0f b6 12             	movzbl (%edx),%edx
     338:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     33a:	8b 45 10             	mov    0x10(%ebp),%eax
     33d:	8d 50 ff             	lea    -0x1(%eax),%edx
     340:	89 55 10             	mov    %edx,0x10(%ebp)
     343:	85 c0                	test   %eax,%eax
     345:	7f dc                	jg     323 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     347:	8b 45 08             	mov    0x8(%ebp),%eax
}
     34a:	c9                   	leave  
     34b:	c3                   	ret    

0000034c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     34c:	b8 01 00 00 00       	mov    $0x1,%eax
     351:	cd 40                	int    $0x40
     353:	c3                   	ret    

00000354 <exit>:
SYSCALL(exit)
     354:	b8 02 00 00 00       	mov    $0x2,%eax
     359:	cd 40                	int    $0x40
     35b:	c3                   	ret    

0000035c <wait>:
SYSCALL(wait)
     35c:	b8 03 00 00 00       	mov    $0x3,%eax
     361:	cd 40                	int    $0x40
     363:	c3                   	ret    

00000364 <pipe>:
SYSCALL(pipe)
     364:	b8 04 00 00 00       	mov    $0x4,%eax
     369:	cd 40                	int    $0x40
     36b:	c3                   	ret    

0000036c <read>:
SYSCALL(read)
     36c:	b8 05 00 00 00       	mov    $0x5,%eax
     371:	cd 40                	int    $0x40
     373:	c3                   	ret    

00000374 <write>:
SYSCALL(write)
     374:	b8 10 00 00 00       	mov    $0x10,%eax
     379:	cd 40                	int    $0x40
     37b:	c3                   	ret    

0000037c <close>:
SYSCALL(close)
     37c:	b8 15 00 00 00       	mov    $0x15,%eax
     381:	cd 40                	int    $0x40
     383:	c3                   	ret    

00000384 <kill>:
SYSCALL(kill)
     384:	b8 06 00 00 00       	mov    $0x6,%eax
     389:	cd 40                	int    $0x40
     38b:	c3                   	ret    

0000038c <exec>:
SYSCALL(exec)
     38c:	b8 07 00 00 00       	mov    $0x7,%eax
     391:	cd 40                	int    $0x40
     393:	c3                   	ret    

00000394 <open>:
SYSCALL(open)
     394:	b8 0f 00 00 00       	mov    $0xf,%eax
     399:	cd 40                	int    $0x40
     39b:	c3                   	ret    

0000039c <mknod>:
SYSCALL(mknod)
     39c:	b8 11 00 00 00       	mov    $0x11,%eax
     3a1:	cd 40                	int    $0x40
     3a3:	c3                   	ret    

000003a4 <unlink>:
SYSCALL(unlink)
     3a4:	b8 12 00 00 00       	mov    $0x12,%eax
     3a9:	cd 40                	int    $0x40
     3ab:	c3                   	ret    

000003ac <fstat>:
SYSCALL(fstat)
     3ac:	b8 08 00 00 00       	mov    $0x8,%eax
     3b1:	cd 40                	int    $0x40
     3b3:	c3                   	ret    

000003b4 <link>:
SYSCALL(link)
     3b4:	b8 13 00 00 00       	mov    $0x13,%eax
     3b9:	cd 40                	int    $0x40
     3bb:	c3                   	ret    

000003bc <mkdir>:
SYSCALL(mkdir)
     3bc:	b8 14 00 00 00       	mov    $0x14,%eax
     3c1:	cd 40                	int    $0x40
     3c3:	c3                   	ret    

000003c4 <chdir>:
SYSCALL(chdir)
     3c4:	b8 09 00 00 00       	mov    $0x9,%eax
     3c9:	cd 40                	int    $0x40
     3cb:	c3                   	ret    

000003cc <dup>:
SYSCALL(dup)
     3cc:	b8 0a 00 00 00       	mov    $0xa,%eax
     3d1:	cd 40                	int    $0x40
     3d3:	c3                   	ret    

000003d4 <getpid>:
SYSCALL(getpid)
     3d4:	b8 0b 00 00 00       	mov    $0xb,%eax
     3d9:	cd 40                	int    $0x40
     3db:	c3                   	ret    

000003dc <sbrk>:
SYSCALL(sbrk)
     3dc:	b8 0c 00 00 00       	mov    $0xc,%eax
     3e1:	cd 40                	int    $0x40
     3e3:	c3                   	ret    

000003e4 <sleep>:
SYSCALL(sleep)
     3e4:	b8 0d 00 00 00       	mov    $0xd,%eax
     3e9:	cd 40                	int    $0x40
     3eb:	c3                   	ret    

000003ec <uptime>:
SYSCALL(uptime)
     3ec:	b8 0e 00 00 00       	mov    $0xe,%eax
     3f1:	cd 40                	int    $0x40
     3f3:	c3                   	ret    

000003f4 <getcwd>:
SYSCALL(getcwd)
     3f4:	b8 16 00 00 00       	mov    $0x16,%eax
     3f9:	cd 40                	int    $0x40
     3fb:	c3                   	ret    

000003fc <shutdown>:
SYSCALL(shutdown)
     3fc:	b8 17 00 00 00       	mov    $0x17,%eax
     401:	cd 40                	int    $0x40
     403:	c3                   	ret    

00000404 <buildinfo>:
SYSCALL(buildinfo)
     404:	b8 18 00 00 00       	mov    $0x18,%eax
     409:	cd 40                	int    $0x40
     40b:	c3                   	ret    

0000040c <lseek>:
SYSCALL(lseek)
     40c:	b8 19 00 00 00       	mov    $0x19,%eax
     411:	cd 40                	int    $0x40
     413:	c3                   	ret    

00000414 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     414:	55                   	push   %ebp
     415:	89 e5                	mov    %esp,%ebp
     417:	83 ec 18             	sub    $0x18,%esp
     41a:	8b 45 0c             	mov    0xc(%ebp),%eax
     41d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     420:	83 ec 04             	sub    $0x4,%esp
     423:	6a 01                	push   $0x1
     425:	8d 45 f4             	lea    -0xc(%ebp),%eax
     428:	50                   	push   %eax
     429:	ff 75 08             	pushl  0x8(%ebp)
     42c:	e8 43 ff ff ff       	call   374 <write>
     431:	83 c4 10             	add    $0x10,%esp
}
     434:	c9                   	leave  
     435:	c3                   	ret    

00000436 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     436:	55                   	push   %ebp
     437:	89 e5                	mov    %esp,%ebp
     439:	53                   	push   %ebx
     43a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     43d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     444:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     448:	74 17                	je     461 <printint+0x2b>
     44a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     44e:	79 11                	jns    461 <printint+0x2b>
    neg = 1;
     450:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     457:	8b 45 0c             	mov    0xc(%ebp),%eax
     45a:	f7 d8                	neg    %eax
     45c:	89 45 ec             	mov    %eax,-0x14(%ebp)
     45f:	eb 06                	jmp    467 <printint+0x31>
  } else {
    x = xx;
     461:	8b 45 0c             	mov    0xc(%ebp),%eax
     464:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     467:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     46e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     471:	8d 41 01             	lea    0x1(%ecx),%eax
     474:	89 45 f4             	mov    %eax,-0xc(%ebp)
     477:	8b 5d 10             	mov    0x10(%ebp),%ebx
     47a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     47d:	ba 00 00 00 00       	mov    $0x0,%edx
     482:	f7 f3                	div    %ebx
     484:	89 d0                	mov    %edx,%eax
     486:	0f b6 80 74 14 00 00 	movzbl 0x1474(%eax),%eax
     48d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     491:	8b 5d 10             	mov    0x10(%ebp),%ebx
     494:	8b 45 ec             	mov    -0x14(%ebp),%eax
     497:	ba 00 00 00 00       	mov    $0x0,%edx
     49c:	f7 f3                	div    %ebx
     49e:	89 45 ec             	mov    %eax,-0x14(%ebp)
     4a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     4a5:	75 c7                	jne    46e <printint+0x38>
  if(neg)
     4a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4ab:	74 0e                	je     4bb <printint+0x85>
    buf[i++] = '-';
     4ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b0:	8d 50 01             	lea    0x1(%eax),%edx
     4b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
     4b6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     4bb:	eb 1d                	jmp    4da <printint+0xa4>
    putc(fd, buf[i]);
     4bd:	8d 55 dc             	lea    -0x24(%ebp),%edx
     4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c3:	01 d0                	add    %edx,%eax
     4c5:	0f b6 00             	movzbl (%eax),%eax
     4c8:	0f be c0             	movsbl %al,%eax
     4cb:	83 ec 08             	sub    $0x8,%esp
     4ce:	50                   	push   %eax
     4cf:	ff 75 08             	pushl  0x8(%ebp)
     4d2:	e8 3d ff ff ff       	call   414 <putc>
     4d7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     4da:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     4de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     4e2:	79 d9                	jns    4bd <printint+0x87>
    putc(fd, buf[i]);
}
     4e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4e7:	c9                   	leave  
     4e8:	c3                   	ret    

000004e9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     4e9:	55                   	push   %ebp
     4ea:	89 e5                	mov    %esp,%ebp
     4ec:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     4ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     4f6:	8d 45 0c             	lea    0xc(%ebp),%eax
     4f9:	83 c0 04             	add    $0x4,%eax
     4fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     4ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     506:	e9 59 01 00 00       	jmp    664 <printf+0x17b>
    c = fmt[i] & 0xff;
     50b:	8b 55 0c             	mov    0xc(%ebp),%edx
     50e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     511:	01 d0                	add    %edx,%eax
     513:	0f b6 00             	movzbl (%eax),%eax
     516:	0f be c0             	movsbl %al,%eax
     519:	25 ff 00 00 00       	and    $0xff,%eax
     51e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     521:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     525:	75 2c                	jne    553 <printf+0x6a>
      if(c == '%'){
     527:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     52b:	75 0c                	jne    539 <printf+0x50>
        state = '%';
     52d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     534:	e9 27 01 00 00       	jmp    660 <printf+0x177>
      } else {
        putc(fd, c);
     539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     53c:	0f be c0             	movsbl %al,%eax
     53f:	83 ec 08             	sub    $0x8,%esp
     542:	50                   	push   %eax
     543:	ff 75 08             	pushl  0x8(%ebp)
     546:	e8 c9 fe ff ff       	call   414 <putc>
     54b:	83 c4 10             	add    $0x10,%esp
     54e:	e9 0d 01 00 00       	jmp    660 <printf+0x177>
      }
    } else if(state == '%'){
     553:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     557:	0f 85 03 01 00 00    	jne    660 <printf+0x177>
      if(c == 'd'){
     55d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     561:	75 1e                	jne    581 <printf+0x98>
        printint(fd, *ap, 10, 1);
     563:	8b 45 e8             	mov    -0x18(%ebp),%eax
     566:	8b 00                	mov    (%eax),%eax
     568:	6a 01                	push   $0x1
     56a:	6a 0a                	push   $0xa
     56c:	50                   	push   %eax
     56d:	ff 75 08             	pushl  0x8(%ebp)
     570:	e8 c1 fe ff ff       	call   436 <printint>
     575:	83 c4 10             	add    $0x10,%esp
        ap++;
     578:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     57c:	e9 d8 00 00 00       	jmp    659 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
     581:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     585:	74 06                	je     58d <printf+0xa4>
     587:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     58b:	75 1e                	jne    5ab <printf+0xc2>
        printint(fd, *ap, 16, 0);
     58d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     590:	8b 00                	mov    (%eax),%eax
     592:	6a 00                	push   $0x0
     594:	6a 10                	push   $0x10
     596:	50                   	push   %eax
     597:	ff 75 08             	pushl  0x8(%ebp)
     59a:	e8 97 fe ff ff       	call   436 <printint>
     59f:	83 c4 10             	add    $0x10,%esp
        ap++;
     5a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     5a6:	e9 ae 00 00 00       	jmp    659 <printf+0x170>
      } else if(c == 's'){
     5ab:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     5af:	75 43                	jne    5f4 <printf+0x10b>
        s = (char*)*ap;
     5b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5b4:	8b 00                	mov    (%eax),%eax
     5b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     5b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     5bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     5c1:	75 07                	jne    5ca <printf+0xe1>
          s = "(null)";
     5c3:	c7 45 f4 5a 10 00 00 	movl   $0x105a,-0xc(%ebp)
        while(*s != 0){
     5ca:	eb 1c                	jmp    5e8 <printf+0xff>
          putc(fd, *s);
     5cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cf:	0f b6 00             	movzbl (%eax),%eax
     5d2:	0f be c0             	movsbl %al,%eax
     5d5:	83 ec 08             	sub    $0x8,%esp
     5d8:	50                   	push   %eax
     5d9:	ff 75 08             	pushl  0x8(%ebp)
     5dc:	e8 33 fe ff ff       	call   414 <putc>
     5e1:	83 c4 10             	add    $0x10,%esp
          s++;
     5e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     5e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5eb:	0f b6 00             	movzbl (%eax),%eax
     5ee:	84 c0                	test   %al,%al
     5f0:	75 da                	jne    5cc <printf+0xe3>
     5f2:	eb 65                	jmp    659 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     5f4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     5f8:	75 1d                	jne    617 <printf+0x12e>
        putc(fd, *ap);
     5fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5fd:	8b 00                	mov    (%eax),%eax
     5ff:	0f be c0             	movsbl %al,%eax
     602:	83 ec 08             	sub    $0x8,%esp
     605:	50                   	push   %eax
     606:	ff 75 08             	pushl  0x8(%ebp)
     609:	e8 06 fe ff ff       	call   414 <putc>
     60e:	83 c4 10             	add    $0x10,%esp
        ap++;
     611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     615:	eb 42                	jmp    659 <printf+0x170>
      } else if(c == '%'){
     617:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     61b:	75 17                	jne    634 <printf+0x14b>
        putc(fd, c);
     61d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     620:	0f be c0             	movsbl %al,%eax
     623:	83 ec 08             	sub    $0x8,%esp
     626:	50                   	push   %eax
     627:	ff 75 08             	pushl  0x8(%ebp)
     62a:	e8 e5 fd ff ff       	call   414 <putc>
     62f:	83 c4 10             	add    $0x10,%esp
     632:	eb 25                	jmp    659 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     634:	83 ec 08             	sub    $0x8,%esp
     637:	6a 25                	push   $0x25
     639:	ff 75 08             	pushl  0x8(%ebp)
     63c:	e8 d3 fd ff ff       	call   414 <putc>
     641:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
     644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     647:	0f be c0             	movsbl %al,%eax
     64a:	83 ec 08             	sub    $0x8,%esp
     64d:	50                   	push   %eax
     64e:	ff 75 08             	pushl  0x8(%ebp)
     651:	e8 be fd ff ff       	call   414 <putc>
     656:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     659:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     660:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     664:	8b 55 0c             	mov    0xc(%ebp),%edx
     667:	8b 45 f0             	mov    -0x10(%ebp),%eax
     66a:	01 d0                	add    %edx,%eax
     66c:	0f b6 00             	movzbl (%eax),%eax
     66f:	84 c0                	test   %al,%al
     671:	0f 85 94 fe ff ff    	jne    50b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     677:	c9                   	leave  
     678:	c3                   	ret    

00000679 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     679:	55                   	push   %ebp
     67a:	89 e5                	mov    %esp,%ebp
     67c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     67f:	8b 45 08             	mov    0x8(%ebp),%eax
     682:	83 e8 08             	sub    $0x8,%eax
     685:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     688:	a1 90 14 00 00       	mov    0x1490,%eax
     68d:	89 45 fc             	mov    %eax,-0x4(%ebp)
     690:	eb 24                	jmp    6b6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     692:	8b 45 fc             	mov    -0x4(%ebp),%eax
     695:	8b 00                	mov    (%eax),%eax
     697:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     69a:	77 12                	ja     6ae <free+0x35>
     69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     69f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     6a2:	77 24                	ja     6c8 <free+0x4f>
     6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6a7:	8b 00                	mov    (%eax),%eax
     6a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6ac:	77 1a                	ja     6c8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6b1:	8b 00                	mov    (%eax),%eax
     6b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
     6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     6bc:	76 d4                	jbe    692 <free+0x19>
     6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6c1:	8b 00                	mov    (%eax),%eax
     6c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6c6:	76 ca                	jbe    692 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6cb:	8b 40 04             	mov    0x4(%eax),%eax
     6ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6d8:	01 c2                	add    %eax,%edx
     6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6dd:	8b 00                	mov    (%eax),%eax
     6df:	39 c2                	cmp    %eax,%edx
     6e1:	75 24                	jne    707 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6e6:	8b 50 04             	mov    0x4(%eax),%edx
     6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6ec:	8b 00                	mov    (%eax),%eax
     6ee:	8b 40 04             	mov    0x4(%eax),%eax
     6f1:	01 c2                	add    %eax,%edx
     6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6f6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6fc:	8b 00                	mov    (%eax),%eax
     6fe:	8b 10                	mov    (%eax),%edx
     700:	8b 45 f8             	mov    -0x8(%ebp),%eax
     703:	89 10                	mov    %edx,(%eax)
     705:	eb 0a                	jmp    711 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     707:	8b 45 fc             	mov    -0x4(%ebp),%eax
     70a:	8b 10                	mov    (%eax),%edx
     70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     70f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     711:	8b 45 fc             	mov    -0x4(%ebp),%eax
     714:	8b 40 04             	mov    0x4(%eax),%eax
     717:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     721:	01 d0                	add    %edx,%eax
     723:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     726:	75 20                	jne    748 <free+0xcf>
    p->s.size += bp->s.size;
     728:	8b 45 fc             	mov    -0x4(%ebp),%eax
     72b:	8b 50 04             	mov    0x4(%eax),%edx
     72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     731:	8b 40 04             	mov    0x4(%eax),%eax
     734:	01 c2                	add    %eax,%edx
     736:	8b 45 fc             	mov    -0x4(%ebp),%eax
     739:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     73f:	8b 10                	mov    (%eax),%edx
     741:	8b 45 fc             	mov    -0x4(%ebp),%eax
     744:	89 10                	mov    %edx,(%eax)
     746:	eb 08                	jmp    750 <free+0xd7>
  } else
    p->s.ptr = bp;
     748:	8b 45 fc             	mov    -0x4(%ebp),%eax
     74b:	8b 55 f8             	mov    -0x8(%ebp),%edx
     74e:	89 10                	mov    %edx,(%eax)
  freep = p;
     750:	8b 45 fc             	mov    -0x4(%ebp),%eax
     753:	a3 90 14 00 00       	mov    %eax,0x1490
}
     758:	c9                   	leave  
     759:	c3                   	ret    

0000075a <morecore>:

static Header*
morecore(uint nu)
{
     75a:	55                   	push   %ebp
     75b:	89 e5                	mov    %esp,%ebp
     75d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     760:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     767:	77 07                	ja     770 <morecore+0x16>
    nu = 4096;
     769:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     770:	8b 45 08             	mov    0x8(%ebp),%eax
     773:	c1 e0 03             	shl    $0x3,%eax
     776:	83 ec 0c             	sub    $0xc,%esp
     779:	50                   	push   %eax
     77a:	e8 5d fc ff ff       	call   3dc <sbrk>
     77f:	83 c4 10             	add    $0x10,%esp
     782:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     785:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     789:	75 07                	jne    792 <morecore+0x38>
    return 0;
     78b:	b8 00 00 00 00       	mov    $0x0,%eax
     790:	eb 26                	jmp    7b8 <morecore+0x5e>
  hp = (Header*)p;
     792:	8b 45 f4             	mov    -0xc(%ebp),%eax
     795:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     798:	8b 45 f0             	mov    -0x10(%ebp),%eax
     79b:	8b 55 08             	mov    0x8(%ebp),%edx
     79e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     7a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7a4:	83 c0 08             	add    $0x8,%eax
     7a7:	83 ec 0c             	sub    $0xc,%esp
     7aa:	50                   	push   %eax
     7ab:	e8 c9 fe ff ff       	call   679 <free>
     7b0:	83 c4 10             	add    $0x10,%esp
  return freep;
     7b3:	a1 90 14 00 00       	mov    0x1490,%eax
}
     7b8:	c9                   	leave  
     7b9:	c3                   	ret    

000007ba <malloc>:

void*
malloc(uint nbytes)
{
     7ba:	55                   	push   %ebp
     7bb:	89 e5                	mov    %esp,%ebp
     7bd:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     7c0:	8b 45 08             	mov    0x8(%ebp),%eax
     7c3:	83 c0 07             	add    $0x7,%eax
     7c6:	c1 e8 03             	shr    $0x3,%eax
     7c9:	83 c0 01             	add    $0x1,%eax
     7cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     7cf:	a1 90 14 00 00       	mov    0x1490,%eax
     7d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7db:	75 23                	jne    800 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     7dd:	c7 45 f0 88 14 00 00 	movl   $0x1488,-0x10(%ebp)
     7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7e7:	a3 90 14 00 00       	mov    %eax,0x1490
     7ec:	a1 90 14 00 00       	mov    0x1490,%eax
     7f1:	a3 88 14 00 00       	mov    %eax,0x1488
    base.s.size = 0;
     7f6:	c7 05 8c 14 00 00 00 	movl   $0x0,0x148c
     7fd:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     800:	8b 45 f0             	mov    -0x10(%ebp),%eax
     803:	8b 00                	mov    (%eax),%eax
     805:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     808:	8b 45 f4             	mov    -0xc(%ebp),%eax
     80b:	8b 40 04             	mov    0x4(%eax),%eax
     80e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     811:	72 4d                	jb     860 <malloc+0xa6>
      if(p->s.size == nunits)
     813:	8b 45 f4             	mov    -0xc(%ebp),%eax
     816:	8b 40 04             	mov    0x4(%eax),%eax
     819:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     81c:	75 0c                	jne    82a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     821:	8b 10                	mov    (%eax),%edx
     823:	8b 45 f0             	mov    -0x10(%ebp),%eax
     826:	89 10                	mov    %edx,(%eax)
     828:	eb 26                	jmp    850 <malloc+0x96>
      else {
        p->s.size -= nunits;
     82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     82d:	8b 40 04             	mov    0x4(%eax),%eax
     830:	2b 45 ec             	sub    -0x14(%ebp),%eax
     833:	89 c2                	mov    %eax,%edx
     835:	8b 45 f4             	mov    -0xc(%ebp),%eax
     838:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83e:	8b 40 04             	mov    0x4(%eax),%eax
     841:	c1 e0 03             	shl    $0x3,%eax
     844:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     847:	8b 45 f4             	mov    -0xc(%ebp),%eax
     84a:	8b 55 ec             	mov    -0x14(%ebp),%edx
     84d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     850:	8b 45 f0             	mov    -0x10(%ebp),%eax
     853:	a3 90 14 00 00       	mov    %eax,0x1490
      return (void*)(p + 1);
     858:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85b:	83 c0 08             	add    $0x8,%eax
     85e:	eb 3b                	jmp    89b <malloc+0xe1>
    }
    if(p == freep)
     860:	a1 90 14 00 00       	mov    0x1490,%eax
     865:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     868:	75 1e                	jne    888 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
     86a:	83 ec 0c             	sub    $0xc,%esp
     86d:	ff 75 ec             	pushl  -0x14(%ebp)
     870:	e8 e5 fe ff ff       	call   75a <morecore>
     875:	83 c4 10             	add    $0x10,%esp
     878:	89 45 f4             	mov    %eax,-0xc(%ebp)
     87b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     87f:	75 07                	jne    888 <malloc+0xce>
        return 0;
     881:	b8 00 00 00 00       	mov    $0x0,%eax
     886:	eb 13                	jmp    89b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     888:	8b 45 f4             	mov    -0xc(%ebp),%eax
     88b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     891:	8b 00                	mov    (%eax),%eax
     893:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     896:	e9 6d ff ff ff       	jmp    808 <malloc+0x4e>
}
     89b:	c9                   	leave  
     89c:	c3                   	ret    

0000089d <isspace>:

#include "common.h"

int isspace(char c) {
     89d:	55                   	push   %ebp
     89e:	89 e5                	mov    %esp,%ebp
     8a0:	83 ec 04             	sub    $0x4,%esp
     8a3:	8b 45 08             	mov    0x8(%ebp),%eax
     8a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
     8a9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     8ad:	74 12                	je     8c1 <isspace+0x24>
     8af:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     8b3:	74 0c                	je     8c1 <isspace+0x24>
     8b5:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     8b9:	74 06                	je     8c1 <isspace+0x24>
     8bb:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     8bf:	75 07                	jne    8c8 <isspace+0x2b>
     8c1:	b8 01 00 00 00       	mov    $0x1,%eax
     8c6:	eb 05                	jmp    8cd <isspace+0x30>
     8c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
     8cd:	c9                   	leave  
     8ce:	c3                   	ret    

000008cf <readln>:

char* readln(char *buf, int max, int fd)
{
     8cf:	55                   	push   %ebp
     8d0:	89 e5                	mov    %esp,%ebp
     8d2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     8d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     8dc:	eb 45                	jmp    923 <readln+0x54>
    cc = read(fd, &c, 1);
     8de:	83 ec 04             	sub    $0x4,%esp
     8e1:	6a 01                	push   $0x1
     8e3:	8d 45 ef             	lea    -0x11(%ebp),%eax
     8e6:	50                   	push   %eax
     8e7:	ff 75 10             	pushl  0x10(%ebp)
     8ea:	e8 7d fa ff ff       	call   36c <read>
     8ef:	83 c4 10             	add    $0x10,%esp
     8f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     8f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8f9:	7f 02                	jg     8fd <readln+0x2e>
      break;
     8fb:	eb 31                	jmp    92e <readln+0x5f>
    buf[i++] = c;
     8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     900:	8d 50 01             	lea    0x1(%eax),%edx
     903:	89 55 f4             	mov    %edx,-0xc(%ebp)
     906:	89 c2                	mov    %eax,%edx
     908:	8b 45 08             	mov    0x8(%ebp),%eax
     90b:	01 c2                	add    %eax,%edx
     90d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     911:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     913:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     917:	3c 0a                	cmp    $0xa,%al
     919:	74 13                	je     92e <readln+0x5f>
     91b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     91f:	3c 0d                	cmp    $0xd,%al
     921:	74 0b                	je     92e <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     923:	8b 45 f4             	mov    -0xc(%ebp),%eax
     926:	83 c0 01             	add    $0x1,%eax
     929:	3b 45 0c             	cmp    0xc(%ebp),%eax
     92c:	7c b0                	jl     8de <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     92e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     931:	8b 45 08             	mov    0x8(%ebp),%eax
     934:	01 d0                	add    %edx,%eax
     936:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     939:	8b 45 08             	mov    0x8(%ebp),%eax
}
     93c:	c9                   	leave  
     93d:	c3                   	ret    

0000093e <strncpy>:

char* strncpy(char* dest, char* src, int n) {
     93e:	55                   	push   %ebp
     93f:	89 e5                	mov    %esp,%ebp
     941:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     944:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     94b:	eb 19                	jmp    966 <strncpy+0x28>
		dest[i] = src[i];
     94d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     950:	8b 45 08             	mov    0x8(%ebp),%eax
     953:	01 c2                	add    %eax,%edx
     955:	8b 4d fc             	mov    -0x4(%ebp),%ecx
     958:	8b 45 0c             	mov    0xc(%ebp),%eax
     95b:	01 c8                	add    %ecx,%eax
     95d:	0f b6 00             	movzbl (%eax),%eax
     960:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     962:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     966:	8b 45 fc             	mov    -0x4(%ebp),%eax
     969:	3b 45 10             	cmp    0x10(%ebp),%eax
     96c:	7d 0f                	jge    97d <strncpy+0x3f>
     96e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     971:	8b 45 0c             	mov    0xc(%ebp),%eax
     974:	01 d0                	add    %edx,%eax
     976:	0f b6 00             	movzbl (%eax),%eax
     979:	84 c0                	test   %al,%al
     97b:	75 d0                	jne    94d <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
     97d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     980:	c9                   	leave  
     981:	c3                   	ret    

00000982 <trim>:

char* trim(char* orig) {
     982:	55                   	push   %ebp
     983:	89 e5                	mov    %esp,%ebp
     985:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
     988:	8b 45 08             	mov    0x8(%ebp),%eax
     98b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
     98e:	8b 45 08             	mov    0x8(%ebp),%eax
     991:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
     994:	eb 04                	jmp    99a <trim+0x18>
     996:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     99d:	0f b6 00             	movzbl (%eax),%eax
     9a0:	0f be c0             	movsbl %al,%eax
     9a3:	50                   	push   %eax
     9a4:	e8 f4 fe ff ff       	call   89d <isspace>
     9a9:	83 c4 04             	add    $0x4,%esp
     9ac:	85 c0                	test   %eax,%eax
     9ae:	75 e6                	jne    996 <trim+0x14>
	while (*tail) { tail++; }
     9b0:	eb 04                	jmp    9b6 <trim+0x34>
     9b2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     9b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9b9:	0f b6 00             	movzbl (%eax),%eax
     9bc:	84 c0                	test   %al,%al
     9be:	75 f2                	jne    9b2 <trim+0x30>
	do { tail--; } while (isspace(*tail));
     9c0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
     9c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9c7:	0f b6 00             	movzbl (%eax),%eax
     9ca:	0f be c0             	movsbl %al,%eax
     9cd:	50                   	push   %eax
     9ce:	e8 ca fe ff ff       	call   89d <isspace>
     9d3:	83 c4 04             	add    $0x4,%esp
     9d6:	85 c0                	test   %eax,%eax
     9d8:	75 e6                	jne    9c0 <trim+0x3e>
	new = malloc(tail-head+2);
     9da:	8b 55 f0             	mov    -0x10(%ebp),%edx
     9dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9e0:	29 c2                	sub    %eax,%edx
     9e2:	89 d0                	mov    %edx,%eax
     9e4:	83 c0 02             	add    $0x2,%eax
     9e7:	83 ec 0c             	sub    $0xc,%esp
     9ea:	50                   	push   %eax
     9eb:	e8 ca fd ff ff       	call   7ba <malloc>
     9f0:	83 c4 10             	add    $0x10,%esp
     9f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
     9f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
     9f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9fc:	29 c2                	sub    %eax,%edx
     9fe:	89 d0                	mov    %edx,%eax
     a00:	83 c0 01             	add    $0x1,%eax
     a03:	83 ec 04             	sub    $0x4,%esp
     a06:	50                   	push   %eax
     a07:	ff 75 f4             	pushl  -0xc(%ebp)
     a0a:	ff 75 ec             	pushl  -0x14(%ebp)
     a0d:	e8 2c ff ff ff       	call   93e <strncpy>
     a12:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
     a15:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a1b:	29 c2                	sub    %eax,%edx
     a1d:	89 d0                	mov    %edx,%eax
     a1f:	8d 50 01             	lea    0x1(%eax),%edx
     a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
     a25:	01 d0                	add    %edx,%eax
     a27:	c6 00 00             	movb   $0x0,(%eax)
	return new;
     a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
     a2d:	c9                   	leave  
     a2e:	c3                   	ret    

00000a2f <itoa>:

char *
itoa(int value)
{
     a2f:	55                   	push   %ebp
     a30:	89 e5                	mov    %esp,%ebp
     a32:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
     a35:	8d 45 bf             	lea    -0x41(%ebp),%eax
     a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
     a3b:	8b 45 08             	mov    0x8(%ebp),%eax
     a3e:	c1 e8 1f             	shr    $0x1f,%eax
     a41:	0f b6 c0             	movzbl %al,%eax
     a44:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
     a47:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     a4b:	74 0a                	je     a57 <itoa+0x28>
    v = -value;
     a4d:	8b 45 08             	mov    0x8(%ebp),%eax
     a50:	f7 d8                	neg    %eax
     a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a55:	eb 06                	jmp    a5d <itoa+0x2e>
  else
    v = (uint)value;
     a57:	8b 45 08             	mov    0x8(%ebp),%eax
     a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
     a5d:	eb 5b                	jmp    aba <itoa+0x8b>
  {
    i = v % 10;
     a5f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     a62:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     a67:	89 c8                	mov    %ecx,%eax
     a69:	f7 e2                	mul    %edx
     a6b:	c1 ea 03             	shr    $0x3,%edx
     a6e:	89 d0                	mov    %edx,%eax
     a70:	c1 e0 02             	shl    $0x2,%eax
     a73:	01 d0                	add    %edx,%eax
     a75:	01 c0                	add    %eax,%eax
     a77:	29 c1                	sub    %eax,%ecx
     a79:	89 ca                	mov    %ecx,%edx
     a7b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
     a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a81:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     a86:	f7 e2                	mul    %edx
     a88:	89 d0                	mov    %edx,%eax
     a8a:	c1 e8 03             	shr    $0x3,%eax
     a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
     a90:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
     a94:	7f 13                	jg     aa9 <itoa+0x7a>
      *tp++ = i+'0';
     a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a99:	8d 50 01             	lea    0x1(%eax),%edx
     a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     aa2:	83 c2 30             	add    $0x30,%edx
     aa5:	88 10                	mov    %dl,(%eax)
     aa7:	eb 11                	jmp    aba <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
     aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aac:	8d 50 01             	lea    0x1(%eax),%edx
     aaf:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ab2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     ab5:	83 c2 57             	add    $0x57,%edx
     ab8:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
     aba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     abe:	75 9f                	jne    a5f <itoa+0x30>
     ac0:	8d 45 bf             	lea    -0x41(%ebp),%eax
     ac3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     ac6:	74 97                	je     a5f <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
     ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     acb:	8d 45 bf             	lea    -0x41(%ebp),%eax
     ace:	29 c2                	sub    %eax,%edx
     ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ad3:	01 d0                	add    %edx,%eax
     ad5:	83 c0 01             	add    $0x1,%eax
     ad8:	83 ec 0c             	sub    $0xc,%esp
     adb:	50                   	push   %eax
     adc:	e8 d9 fc ff ff       	call   7ba <malloc>
     ae1:	83 c4 10             	add    $0x10,%esp
     ae4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
     ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     aea:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
     aed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     af1:	74 0c                	je     aff <itoa+0xd0>
    *sp++ = '-';
     af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     af6:	8d 50 01             	lea    0x1(%eax),%edx
     af9:	89 55 ec             	mov    %edx,-0x14(%ebp)
     afc:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
     aff:	eb 15                	jmp    b16 <itoa+0xe7>
    *sp++ = *--tp;
     b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b04:	8d 50 01             	lea    0x1(%eax),%edx
     b07:	89 55 ec             	mov    %edx,-0x14(%ebp)
     b0a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b11:	0f b6 12             	movzbl (%edx),%edx
     b14:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
     b16:	8d 45 bf             	lea    -0x41(%ebp),%eax
     b19:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     b1c:	77 e3                	ja     b01 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
     b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b21:	c6 00 00             	movb   $0x0,(%eax)
  return string;
     b24:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
     b27:	c9                   	leave  
     b28:	c3                   	ret    

00000b29 <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
     b29:	55                   	push   %ebp
     b2a:	89 e5                	mov    %esp,%ebp
     b2c:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
     b32:	83 ec 08             	sub    $0x8,%esp
     b35:	6a 00                	push   $0x0
     b37:	ff 75 08             	pushl  0x8(%ebp)
     b3a:	e8 55 f8 ff ff       	call   394 <open>
     b3f:	83 c4 10             	add    $0x10,%esp
     b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     b45:	e9 22 01 00 00       	jmp    c6c <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
     b4a:	83 ec 08             	sub    $0x8,%esp
     b4d:	6a 3d                	push   $0x3d
     b4f:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     b55:	50                   	push   %eax
     b56:	e8 79 f6 ff ff       	call   1d4 <strchr>
     b5b:	83 c4 10             	add    $0x10,%esp
     b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
     b61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b65:	0f 84 23 01 00 00    	je     c8e <parseEnvFile+0x165>
     b6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b6f:	0f 84 19 01 00 00    	je     c8e <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
     b75:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b78:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     b7e:	29 c2                	sub    %eax,%edx
     b80:	89 d0                	mov    %edx,%eax
     b82:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
     b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b88:	83 c0 01             	add    $0x1,%eax
     b8b:	83 ec 0c             	sub    $0xc,%esp
     b8e:	50                   	push   %eax
     b8f:	e8 26 fc ff ff       	call   7ba <malloc>
     b94:	83 c4 10             	add    $0x10,%esp
     b97:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
     b9a:	83 ec 04             	sub    $0x4,%esp
     b9d:	ff 75 ec             	pushl  -0x14(%ebp)
     ba0:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     ba6:	50                   	push   %eax
     ba7:	ff 75 e8             	pushl  -0x18(%ebp)
     baa:	e8 8f fd ff ff       	call   93e <strncpy>
     baf:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
     bb2:	83 ec 0c             	sub    $0xc,%esp
     bb5:	ff 75 e8             	pushl  -0x18(%ebp)
     bb8:	e8 c5 fd ff ff       	call   982 <trim>
     bbd:	83 c4 10             	add    $0x10,%esp
     bc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
     bc3:	83 ec 0c             	sub    $0xc,%esp
     bc6:	ff 75 e8             	pushl  -0x18(%ebp)
     bc9:	e8 ab fa ff ff       	call   679 <free>
     bce:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
     bd1:	83 ec 08             	sub    $0x8,%esp
     bd4:	ff 75 0c             	pushl  0xc(%ebp)
     bd7:	ff 75 e4             	pushl  -0x1c(%ebp)
     bda:	e8 c2 01 00 00       	call   da1 <addToEnvironment>
     bdf:	83 c4 10             	add    $0x10,%esp
     be2:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
     be5:	83 ec 0c             	sub    $0xc,%esp
     be8:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     bee:	50                   	push   %eax
     bef:	e8 9f f5 ff ff       	call   193 <strlen>
     bf4:	83 c4 10             	add    $0x10,%esp
     bf7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
     bfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bfd:	2b 45 ec             	sub    -0x14(%ebp),%eax
     c00:	83 ec 0c             	sub    $0xc,%esp
     c03:	50                   	push   %eax
     c04:	e8 b1 fb ff ff       	call   7ba <malloc>
     c09:	83 c4 10             	add    $0x10,%esp
     c0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
     c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c12:	2b 45 ec             	sub    -0x14(%ebp),%eax
     c15:	8d 50 ff             	lea    -0x1(%eax),%edx
     c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c1b:	8d 48 01             	lea    0x1(%eax),%ecx
     c1e:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     c24:	01 c8                	add    %ecx,%eax
     c26:	83 ec 04             	sub    $0x4,%esp
     c29:	52                   	push   %edx
     c2a:	50                   	push   %eax
     c2b:	ff 75 e8             	pushl  -0x18(%ebp)
     c2e:	e8 0b fd ff ff       	call   93e <strncpy>
     c33:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
     c36:	83 ec 0c             	sub    $0xc,%esp
     c39:	ff 75 e8             	pushl  -0x18(%ebp)
     c3c:	e8 41 fd ff ff       	call   982 <trim>
     c41:	83 c4 10             	add    $0x10,%esp
     c44:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
     c47:	83 ec 0c             	sub    $0xc,%esp
     c4a:	ff 75 e8             	pushl  -0x18(%ebp)
     c4d:	e8 27 fa ff ff       	call   679 <free>
     c52:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
     c55:	83 ec 04             	sub    $0x4,%esp
     c58:	ff 75 dc             	pushl  -0x24(%ebp)
     c5b:	ff 75 0c             	pushl  0xc(%ebp)
     c5e:	ff 75 e4             	pushl  -0x1c(%ebp)
     c61:	e8 b8 01 00 00       	call   e1e <addValueToVariable>
     c66:	83 c4 10             	add    $0x10,%esp
     c69:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     c6c:	83 ec 04             	sub    $0x4,%esp
     c6f:	ff 75 f4             	pushl  -0xc(%ebp)
     c72:	68 00 04 00 00       	push   $0x400
     c77:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     c7d:	50                   	push   %eax
     c7e:	e8 4c fc ff ff       	call   8cf <readln>
     c83:	83 c4 10             	add    $0x10,%esp
     c86:	85 c0                	test   %eax,%eax
     c88:	0f 85 bc fe ff ff    	jne    b4a <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
     c8e:	83 ec 0c             	sub    $0xc,%esp
     c91:	ff 75 f4             	pushl  -0xc(%ebp)
     c94:	e8 e3 f6 ff ff       	call   37c <close>
     c99:	83 c4 10             	add    $0x10,%esp
	return head;
     c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     c9f:	c9                   	leave  
     ca0:	c3                   	ret    

00000ca1 <comp>:

int comp(const char* s1, const char* s2)
{
     ca1:	55                   	push   %ebp
     ca2:	89 e5                	mov    %esp,%ebp
     ca4:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
     ca7:	83 ec 08             	sub    $0x8,%esp
     caa:	ff 75 0c             	pushl  0xc(%ebp)
     cad:	ff 75 08             	pushl  0x8(%ebp)
     cb0:	e8 9f f4 ff ff       	call   154 <strcmp>
     cb5:	83 c4 10             	add    $0x10,%esp
     cb8:	85 c0                	test   %eax,%eax
     cba:	0f 94 c0             	sete   %al
     cbd:	0f b6 c0             	movzbl %al,%eax
}
     cc0:	c9                   	leave  
     cc1:	c3                   	ret    

00000cc2 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
     cc2:	55                   	push   %ebp
     cc3:	89 e5                	mov    %esp,%ebp
     cc5:	83 ec 08             	sub    $0x8,%esp
  if (!name)
     cc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ccc:	75 07                	jne    cd5 <environLookup+0x13>
    return NULL;
     cce:	b8 00 00 00 00       	mov    $0x0,%eax
     cd3:	eb 2f                	jmp    d04 <environLookup+0x42>
  
  while (head)
     cd5:	eb 24                	jmp    cfb <environLookup+0x39>
  {
    if (comp(name, head->name))
     cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
     cda:	83 ec 08             	sub    $0x8,%esp
     cdd:	50                   	push   %eax
     cde:	ff 75 08             	pushl  0x8(%ebp)
     ce1:	e8 bb ff ff ff       	call   ca1 <comp>
     ce6:	83 c4 10             	add    $0x10,%esp
     ce9:	85 c0                	test   %eax,%eax
     ceb:	74 02                	je     cef <environLookup+0x2d>
      break;
     ced:	eb 12                	jmp    d01 <environLookup+0x3f>
    head = head->next;
     cef:	8b 45 0c             	mov    0xc(%ebp),%eax
     cf2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     cf8:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
     cfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     cff:	75 d6                	jne    cd7 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
     d01:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     d04:	c9                   	leave  
     d05:	c3                   	ret    

00000d06 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
     d06:	55                   	push   %ebp
     d07:	89 e5                	mov    %esp,%ebp
     d09:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
     d0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     d10:	75 0a                	jne    d1c <removeFromEnvironment+0x16>
    return NULL;
     d12:	b8 00 00 00 00       	mov    $0x0,%eax
     d17:	e9 83 00 00 00       	jmp    d9f <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
     d1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     d20:	74 0a                	je     d2c <removeFromEnvironment+0x26>
     d22:	8b 45 08             	mov    0x8(%ebp),%eax
     d25:	0f b6 00             	movzbl (%eax),%eax
     d28:	84 c0                	test   %al,%al
     d2a:	75 05                	jne    d31 <removeFromEnvironment+0x2b>
    return head;
     d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
     d2f:	eb 6e                	jmp    d9f <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
     d31:	8b 45 0c             	mov    0xc(%ebp),%eax
     d34:	83 ec 08             	sub    $0x8,%esp
     d37:	ff 75 08             	pushl  0x8(%ebp)
     d3a:	50                   	push   %eax
     d3b:	e8 61 ff ff ff       	call   ca1 <comp>
     d40:	83 c4 10             	add    $0x10,%esp
     d43:	85 c0                	test   %eax,%eax
     d45:	74 34                	je     d7b <removeFromEnvironment+0x75>
  {
    tmp = head->next;
     d47:	8b 45 0c             	mov    0xc(%ebp),%eax
     d4a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
     d53:	8b 45 0c             	mov    0xc(%ebp),%eax
     d56:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     d5c:	83 ec 0c             	sub    $0xc,%esp
     d5f:	50                   	push   %eax
     d60:	e8 74 01 00 00       	call   ed9 <freeVarval>
     d65:	83 c4 10             	add    $0x10,%esp
    free(head);
     d68:	83 ec 0c             	sub    $0xc,%esp
     d6b:	ff 75 0c             	pushl  0xc(%ebp)
     d6e:	e8 06 f9 ff ff       	call   679 <free>
     d73:	83 c4 10             	add    $0x10,%esp
    return tmp;
     d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d79:	eb 24                	jmp    d9f <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
     d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
     d7e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     d84:	83 ec 08             	sub    $0x8,%esp
     d87:	50                   	push   %eax
     d88:	ff 75 08             	pushl  0x8(%ebp)
     d8b:	e8 76 ff ff ff       	call   d06 <removeFromEnvironment>
     d90:	83 c4 10             	add    $0x10,%esp
     d93:	8b 55 0c             	mov    0xc(%ebp),%edx
     d96:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
     d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     d9f:	c9                   	leave  
     da0:	c3                   	ret    

00000da1 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
     da1:	55                   	push   %ebp
     da2:	89 e5                	mov    %esp,%ebp
     da4:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
     da7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     dab:	75 05                	jne    db2 <addToEnvironment+0x11>
		return head;
     dad:	8b 45 0c             	mov    0xc(%ebp),%eax
     db0:	eb 6a                	jmp    e1c <addToEnvironment+0x7b>
	if (head == NULL) {
     db2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     db6:	75 40                	jne    df8 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
     db8:	83 ec 0c             	sub    $0xc,%esp
     dbb:	68 88 00 00 00       	push   $0x88
     dc0:	e8 f5 f9 ff ff       	call   7ba <malloc>
     dc5:	83 c4 10             	add    $0x10,%esp
     dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
     dcb:	8b 45 08             	mov    0x8(%ebp),%eax
     dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
     dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dd4:	83 ec 08             	sub    $0x8,%esp
     dd7:	ff 75 f0             	pushl  -0x10(%ebp)
     dda:	50                   	push   %eax
     ddb:	e8 44 f3 ff ff       	call   124 <strcpy>
     de0:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
     de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
     ded:	00 00 00 
		head = newVar;
     df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df3:	89 45 0c             	mov    %eax,0xc(%ebp)
     df6:	eb 21                	jmp    e19 <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
     df8:	8b 45 0c             	mov    0xc(%ebp),%eax
     dfb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     e01:	83 ec 08             	sub    $0x8,%esp
     e04:	50                   	push   %eax
     e05:	ff 75 08             	pushl  0x8(%ebp)
     e08:	e8 94 ff ff ff       	call   da1 <addToEnvironment>
     e0d:	83 c4 10             	add    $0x10,%esp
     e10:	8b 55 0c             	mov    0xc(%ebp),%edx
     e13:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
     e19:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     e1c:	c9                   	leave  
     e1d:	c3                   	ret    

00000e1e <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
     e1e:	55                   	push   %ebp
     e1f:	89 e5                	mov    %esp,%ebp
     e21:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
     e24:	83 ec 08             	sub    $0x8,%esp
     e27:	ff 75 0c             	pushl  0xc(%ebp)
     e2a:	ff 75 08             	pushl  0x8(%ebp)
     e2d:	e8 90 fe ff ff       	call   cc2 <environLookup>
     e32:	83 c4 10             	add    $0x10,%esp
     e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
     e38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e3c:	75 05                	jne    e43 <addValueToVariable+0x25>
		return head;
     e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e41:	eb 4c                	jmp    e8f <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
     e43:	83 ec 0c             	sub    $0xc,%esp
     e46:	68 04 04 00 00       	push   $0x404
     e4b:	e8 6a f9 ff ff       	call   7ba <malloc>
     e50:	83 c4 10             	add    $0x10,%esp
     e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
     e56:	8b 45 10             	mov    0x10(%ebp),%eax
     e59:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
     e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e5f:	83 ec 08             	sub    $0x8,%esp
     e62:	ff 75 ec             	pushl  -0x14(%ebp)
     e65:	50                   	push   %eax
     e66:	e8 b9 f2 ff ff       	call   124 <strcpy>
     e6b:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
     e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e71:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
     e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e7a:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
     e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e83:	8b 55 f0             	mov    -0x10(%ebp),%edx
     e86:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
     e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     e8f:	c9                   	leave  
     e90:	c3                   	ret    

00000e91 <freeEnvironment>:

void freeEnvironment(variable* head)
{
     e91:	55                   	push   %ebp
     e92:	89 e5                	mov    %esp,%ebp
     e94:	83 ec 08             	sub    $0x8,%esp
  if (!head)
     e97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e9b:	75 02                	jne    e9f <freeEnvironment+0xe>
    return;  
     e9d:	eb 38                	jmp    ed7 <freeEnvironment+0x46>
  freeEnvironment(head->next);
     e9f:	8b 45 08             	mov    0x8(%ebp),%eax
     ea2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     ea8:	83 ec 0c             	sub    $0xc,%esp
     eab:	50                   	push   %eax
     eac:	e8 e0 ff ff ff       	call   e91 <freeEnvironment>
     eb1:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
     eb4:	8b 45 08             	mov    0x8(%ebp),%eax
     eb7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     ebd:	83 ec 0c             	sub    $0xc,%esp
     ec0:	50                   	push   %eax
     ec1:	e8 13 00 00 00       	call   ed9 <freeVarval>
     ec6:	83 c4 10             	add    $0x10,%esp
  free(head);
     ec9:	83 ec 0c             	sub    $0xc,%esp
     ecc:	ff 75 08             	pushl  0x8(%ebp)
     ecf:	e8 a5 f7 ff ff       	call   679 <free>
     ed4:	83 c4 10             	add    $0x10,%esp
}
     ed7:	c9                   	leave  
     ed8:	c3                   	ret    

00000ed9 <freeVarval>:

void freeVarval(varval* head)
{
     ed9:	55                   	push   %ebp
     eda:	89 e5                	mov    %esp,%ebp
     edc:	83 ec 08             	sub    $0x8,%esp
  if (!head)
     edf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ee3:	75 02                	jne    ee7 <freeVarval+0xe>
    return;  
     ee5:	eb 23                	jmp    f0a <freeVarval+0x31>
  freeVarval(head->next);
     ee7:	8b 45 08             	mov    0x8(%ebp),%eax
     eea:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
     ef0:	83 ec 0c             	sub    $0xc,%esp
     ef3:	50                   	push   %eax
     ef4:	e8 e0 ff ff ff       	call   ed9 <freeVarval>
     ef9:	83 c4 10             	add    $0x10,%esp
  free(head);
     efc:	83 ec 0c             	sub    $0xc,%esp
     eff:	ff 75 08             	pushl  0x8(%ebp)
     f02:	e8 72 f7 ff ff       	call   679 <free>
     f07:	83 c4 10             	add    $0x10,%esp
}
     f0a:	c9                   	leave  
     f0b:	c3                   	ret    

00000f0c <getPaths>:

varval* getPaths(char* paths, varval* head) {
     f0c:	55                   	push   %ebp
     f0d:	89 e5                	mov    %esp,%ebp
     f0f:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
     f12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f16:	75 08                	jne    f20 <getPaths+0x14>
		return head;
     f18:	8b 45 0c             	mov    0xc(%ebp),%eax
     f1b:	e9 e7 00 00 00       	jmp    1007 <getPaths+0xfb>
	if (head == NULL) {
     f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f24:	0f 85 b9 00 00 00    	jne    fe3 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
     f2a:	83 ec 08             	sub    $0x8,%esp
     f2d:	6a 3a                	push   $0x3a
     f2f:	ff 75 08             	pushl  0x8(%ebp)
     f32:	e8 9d f2 ff ff       	call   1d4 <strchr>
     f37:	83 c4 10             	add    $0x10,%esp
     f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
     f3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f41:	75 56                	jne    f99 <getPaths+0x8d>
			pathLen = strlen(paths);
     f43:	83 ec 0c             	sub    $0xc,%esp
     f46:	ff 75 08             	pushl  0x8(%ebp)
     f49:	e8 45 f2 ff ff       	call   193 <strlen>
     f4e:	83 c4 10             	add    $0x10,%esp
     f51:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
     f54:	83 ec 0c             	sub    $0xc,%esp
     f57:	68 04 04 00 00       	push   $0x404
     f5c:	e8 59 f8 ff ff       	call   7ba <malloc>
     f61:	83 c4 10             	add    $0x10,%esp
     f64:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
     f67:	8b 45 0c             	mov    0xc(%ebp),%eax
     f6a:	83 ec 04             	sub    $0x4,%esp
     f6d:	ff 75 f0             	pushl  -0x10(%ebp)
     f70:	ff 75 08             	pushl  0x8(%ebp)
     f73:	50                   	push   %eax
     f74:	e8 c5 f9 ff ff       	call   93e <strncpy>
     f79:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
     f7c:	8b 55 0c             	mov    0xc(%ebp),%edx
     f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f82:	01 d0                	add    %edx,%eax
     f84:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
     f87:	8b 45 0c             	mov    0xc(%ebp),%eax
     f8a:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
     f91:	00 00 00 
			return head;
     f94:	8b 45 0c             	mov    0xc(%ebp),%eax
     f97:	eb 6e                	jmp    1007 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
     f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f9c:	8b 45 08             	mov    0x8(%ebp),%eax
     f9f:	29 c2                	sub    %eax,%edx
     fa1:	89 d0                	mov    %edx,%eax
     fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
     fa6:	83 ec 0c             	sub    $0xc,%esp
     fa9:	68 04 04 00 00       	push   $0x404
     fae:	e8 07 f8 ff ff       	call   7ba <malloc>
     fb3:	83 c4 10             	add    $0x10,%esp
     fb6:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
     fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
     fbc:	83 ec 04             	sub    $0x4,%esp
     fbf:	ff 75 f0             	pushl  -0x10(%ebp)
     fc2:	ff 75 08             	pushl  0x8(%ebp)
     fc5:	50                   	push   %eax
     fc6:	e8 73 f9 ff ff       	call   93e <strncpy>
     fcb:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
     fce:	8b 55 0c             	mov    0xc(%ebp),%edx
     fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fd4:	01 d0                	add    %edx,%eax
     fd6:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
     fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fdc:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
     fdf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
     fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
     fe6:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
     fec:	83 ec 08             	sub    $0x8,%esp
     fef:	50                   	push   %eax
     ff0:	ff 75 08             	pushl  0x8(%ebp)
     ff3:	e8 14 ff ff ff       	call   f0c <getPaths>
     ff8:	83 c4 10             	add    $0x10,%esp
     ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
     ffe:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
    1004:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    1007:	c9                   	leave  
    1008:	c3                   	ret    
