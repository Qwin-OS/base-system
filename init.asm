
_init:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <setup_devices>:

char *argv[] = { "sh", 0 };

// FUCKING DEVICES
void setup_devices(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  if(open("/dev/console", O_RDWR) < 0)
       6:	83 ec 08             	sub    $0x8,%esp
       9:	6a 02                	push   $0x2
       b:	68 41 10 00 00       	push   $0x1041
      10:	e8 b4 03 00 00       	call   3c9 <open>
      15:	83 c4 10             	add    $0x10,%esp
      18:	85 c0                	test   %eax,%eax
      1a:	79 4e                	jns    6a <setup_devices+0x6a>
  {
    mknod("/dev/console", DEV_CONSOLE, 1);
      1c:	83 ec 04             	sub    $0x4,%esp
      1f:	6a 01                	push   $0x1
      21:	6a 01                	push   $0x1
      23:	68 41 10 00 00       	push   $0x1041
      28:	e8 a4 03 00 00       	call   3d1 <mknod>
      2d:	83 c4 10             	add    $0x10,%esp
    mknod("/dev/null", DEV_NULL, 1);
      30:	83 ec 04             	sub    $0x4,%esp
      33:	6a 01                	push   $0x1
      35:	6a 02                	push   $0x2
      37:	68 4e 10 00 00       	push   $0x104e
      3c:	e8 90 03 00 00       	call   3d1 <mknod>
      41:	83 c4 10             	add    $0x10,%esp
    mknod("/dev/zero", DEV_ZERO, 1);
      44:	83 ec 04             	sub    $0x4,%esp
      47:	6a 01                	push   $0x1
      49:	6a 03                	push   $0x3
      4b:	68 58 10 00 00       	push   $0x1058
      50:	e8 7c 03 00 00       	call   3d1 <mknod>
      55:	83 c4 10             	add    $0x10,%esp
    open("/dev/console", O_RDWR);
      58:	83 ec 08             	sub    $0x8,%esp
      5b:	6a 02                	push   $0x2
      5d:	68 41 10 00 00       	push   $0x1041
      62:	e8 62 03 00 00       	call   3c9 <open>
      67:	83 c4 10             	add    $0x10,%esp
  //}
  //if(open("/dev/zero", O_RDWR) < 0) 
  //{
   // mknod("/dev/zero", DEV_ZERO, 1);
  //}
}
      6a:	c9                   	leave  
      6b:	c3                   	ret    

0000006c <main>:

int
main(void)
{
      6c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
      70:	83 e4 f0             	and    $0xfffffff0,%esp
      73:	ff 71 fc             	pushl  -0x4(%ecx)
      76:	55                   	push   %ebp
      77:	89 e5                	mov    %esp,%ebp
      79:	51                   	push   %ecx
      7a:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  setup_devices();
      7d:	e8 7e ff ff ff       	call   0 <setup_devices>
  dup(0);  // stdout
      82:	83 ec 0c             	sub    $0xc,%esp
      85:	6a 00                	push   $0x0
      87:	e8 75 03 00 00       	call   401 <dup>
      8c:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
      8f:	83 ec 0c             	sub    $0xc,%esp
      92:	6a 00                	push   $0x0
      94:	e8 68 03 00 00       	call   401 <dup>
      99:	83 c4 10             	add    $0x10,%esp

  for(;;){
    //printf(1,  "Qwin\n);
    printf(1, "init: starting sh\n\n");
      9c:	83 ec 08             	sub    $0x8,%esp
      9f:	68 62 10 00 00       	push   $0x1062
      a4:	6a 01                	push   $0x1
      a6:	e8 73 04 00 00       	call   51e <printf>
      ab:	83 c4 10             	add    $0x10,%esp
    pid = fork();
      ae:	e8 ce 02 00 00       	call   381 <fork>
      b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
      b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      ba:	79 17                	jns    d3 <main+0x67>
      printf(1, "init: fork failed\n");
      bc:	83 ec 08             	sub    $0x8,%esp
      bf:	68 76 10 00 00       	push   $0x1076
      c4:	6a 01                	push   $0x1
      c6:	e8 53 04 00 00       	call   51e <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 b6 02 00 00       	call   389 <exit>
    }
    if(pid == 0){
      d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      d7:	75 2c                	jne    105 <main+0x99>
      exec("sh", argv);
      d9:	83 ec 08             	sub    $0x8,%esp
      dc:	68 d8 14 00 00       	push   $0x14d8
      e1:	68 3e 10 00 00       	push   $0x103e
      e6:	e8 d6 02 00 00       	call   3c1 <exec>
      eb:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
      ee:	83 ec 08             	sub    $0x8,%esp
      f1:	68 89 10 00 00       	push   $0x1089
      f6:	6a 01                	push   $0x1
      f8:	e8 21 04 00 00       	call   51e <printf>
      fd:	83 c4 10             	add    $0x10,%esp
      exit();
     100:	e8 84 02 00 00       	call   389 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
     105:	eb 12                	jmp    119 <main+0xad>
      printf(1, "zombie!\n");
     107:	83 ec 08             	sub    $0x8,%esp
     10a:	68 9f 10 00 00       	push   $0x109f
     10f:	6a 01                	push   $0x1
     111:	e8 08 04 00 00       	call   51e <printf>
     116:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
     119:	e8 73 02 00 00       	call   391 <wait>
     11e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     121:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     125:	78 08                	js     12f <main+0xc3>
     127:	8b 45 f0             	mov    -0x10(%ebp),%eax
     12a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     12d:	75 d8                	jne    107 <main+0x9b>
      printf(1, "zombie!\n");
  }
     12f:	e9 68 ff ff ff       	jmp    9c <main+0x30>

00000134 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     134:	55                   	push   %ebp
     135:	89 e5                	mov    %esp,%ebp
     137:	57                   	push   %edi
     138:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     139:	8b 4d 08             	mov    0x8(%ebp),%ecx
     13c:	8b 55 10             	mov    0x10(%ebp),%edx
     13f:	8b 45 0c             	mov    0xc(%ebp),%eax
     142:	89 cb                	mov    %ecx,%ebx
     144:	89 df                	mov    %ebx,%edi
     146:	89 d1                	mov    %edx,%ecx
     148:	fc                   	cld    
     149:	f3 aa                	rep stos %al,%es:(%edi)
     14b:	89 ca                	mov    %ecx,%edx
     14d:	89 fb                	mov    %edi,%ebx
     14f:	89 5d 08             	mov    %ebx,0x8(%ebp)
     152:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     155:	5b                   	pop    %ebx
     156:	5f                   	pop    %edi
     157:	5d                   	pop    %ebp
     158:	c3                   	ret    

00000159 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     159:	55                   	push   %ebp
     15a:	89 e5                	mov    %esp,%ebp
     15c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     15f:	8b 45 08             	mov    0x8(%ebp),%eax
     162:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     165:	90                   	nop
     166:	8b 45 08             	mov    0x8(%ebp),%eax
     169:	8d 50 01             	lea    0x1(%eax),%edx
     16c:	89 55 08             	mov    %edx,0x8(%ebp)
     16f:	8b 55 0c             	mov    0xc(%ebp),%edx
     172:	8d 4a 01             	lea    0x1(%edx),%ecx
     175:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     178:	0f b6 12             	movzbl (%edx),%edx
     17b:	88 10                	mov    %dl,(%eax)
     17d:	0f b6 00             	movzbl (%eax),%eax
     180:	84 c0                	test   %al,%al
     182:	75 e2                	jne    166 <strcpy+0xd>
    ;
  return os;
     184:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     187:	c9                   	leave  
     188:	c3                   	ret    

00000189 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     189:	55                   	push   %ebp
     18a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     18c:	eb 08                	jmp    196 <strcmp+0xd>
    p++, q++;
     18e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     192:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     196:	8b 45 08             	mov    0x8(%ebp),%eax
     199:	0f b6 00             	movzbl (%eax),%eax
     19c:	84 c0                	test   %al,%al
     19e:	74 10                	je     1b0 <strcmp+0x27>
     1a0:	8b 45 08             	mov    0x8(%ebp),%eax
     1a3:	0f b6 10             	movzbl (%eax),%edx
     1a6:	8b 45 0c             	mov    0xc(%ebp),%eax
     1a9:	0f b6 00             	movzbl (%eax),%eax
     1ac:	38 c2                	cmp    %al,%dl
     1ae:	74 de                	je     18e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     1b0:	8b 45 08             	mov    0x8(%ebp),%eax
     1b3:	0f b6 00             	movzbl (%eax),%eax
     1b6:	0f b6 d0             	movzbl %al,%edx
     1b9:	8b 45 0c             	mov    0xc(%ebp),%eax
     1bc:	0f b6 00             	movzbl (%eax),%eax
     1bf:	0f b6 c0             	movzbl %al,%eax
     1c2:	29 c2                	sub    %eax,%edx
     1c4:	89 d0                	mov    %edx,%eax
}
     1c6:	5d                   	pop    %ebp
     1c7:	c3                   	ret    

000001c8 <strlen>:

uint
strlen(char *s)
{
     1c8:	55                   	push   %ebp
     1c9:	89 e5                	mov    %esp,%ebp
     1cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     1ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     1d5:	eb 04                	jmp    1db <strlen+0x13>
     1d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     1db:	8b 55 fc             	mov    -0x4(%ebp),%edx
     1de:	8b 45 08             	mov    0x8(%ebp),%eax
     1e1:	01 d0                	add    %edx,%eax
     1e3:	0f b6 00             	movzbl (%eax),%eax
     1e6:	84 c0                	test   %al,%al
     1e8:	75 ed                	jne    1d7 <strlen+0xf>
    ;
  return n;
     1ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     1ed:	c9                   	leave  
     1ee:	c3                   	ret    

000001ef <memset>:

void*
memset(void *dst, int c, uint n)
{
     1ef:	55                   	push   %ebp
     1f0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     1f2:	8b 45 10             	mov    0x10(%ebp),%eax
     1f5:	50                   	push   %eax
     1f6:	ff 75 0c             	pushl  0xc(%ebp)
     1f9:	ff 75 08             	pushl  0x8(%ebp)
     1fc:	e8 33 ff ff ff       	call   134 <stosb>
     201:	83 c4 0c             	add    $0xc,%esp
  return dst;
     204:	8b 45 08             	mov    0x8(%ebp),%eax
}
     207:	c9                   	leave  
     208:	c3                   	ret    

00000209 <strchr>:

char*
strchr(const char *s, char c)
{
     209:	55                   	push   %ebp
     20a:	89 e5                	mov    %esp,%ebp
     20c:	83 ec 04             	sub    $0x4,%esp
     20f:	8b 45 0c             	mov    0xc(%ebp),%eax
     212:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     215:	eb 14                	jmp    22b <strchr+0x22>
    if(*s == c)
     217:	8b 45 08             	mov    0x8(%ebp),%eax
     21a:	0f b6 00             	movzbl (%eax),%eax
     21d:	3a 45 fc             	cmp    -0x4(%ebp),%al
     220:	75 05                	jne    227 <strchr+0x1e>
      return (char*)s;
     222:	8b 45 08             	mov    0x8(%ebp),%eax
     225:	eb 13                	jmp    23a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     227:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     22b:	8b 45 08             	mov    0x8(%ebp),%eax
     22e:	0f b6 00             	movzbl (%eax),%eax
     231:	84 c0                	test   %al,%al
     233:	75 e2                	jne    217 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     235:	b8 00 00 00 00       	mov    $0x0,%eax
}
     23a:	c9                   	leave  
     23b:	c3                   	ret    

0000023c <gets>:

char*
gets(char *buf, int max)
{
     23c:	55                   	push   %ebp
     23d:	89 e5                	mov    %esp,%ebp
     23f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     242:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     249:	eb 44                	jmp    28f <gets+0x53>
    cc = read(0, &c, 1);
     24b:	83 ec 04             	sub    $0x4,%esp
     24e:	6a 01                	push   $0x1
     250:	8d 45 ef             	lea    -0x11(%ebp),%eax
     253:	50                   	push   %eax
     254:	6a 00                	push   $0x0
     256:	e8 46 01 00 00       	call   3a1 <read>
     25b:	83 c4 10             	add    $0x10,%esp
     25e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     265:	7f 02                	jg     269 <gets+0x2d>
      break;
     267:	eb 31                	jmp    29a <gets+0x5e>
    buf[i++] = c;
     269:	8b 45 f4             	mov    -0xc(%ebp),%eax
     26c:	8d 50 01             	lea    0x1(%eax),%edx
     26f:	89 55 f4             	mov    %edx,-0xc(%ebp)
     272:	89 c2                	mov    %eax,%edx
     274:	8b 45 08             	mov    0x8(%ebp),%eax
     277:	01 c2                	add    %eax,%edx
     279:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     27d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     27f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     283:	3c 0a                	cmp    $0xa,%al
     285:	74 13                	je     29a <gets+0x5e>
     287:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     28b:	3c 0d                	cmp    $0xd,%al
     28d:	74 0b                	je     29a <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     28f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     292:	83 c0 01             	add    $0x1,%eax
     295:	3b 45 0c             	cmp    0xc(%ebp),%eax
     298:	7c b1                	jl     24b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     29a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     29d:	8b 45 08             	mov    0x8(%ebp),%eax
     2a0:	01 d0                	add    %edx,%eax
     2a2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     2a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     2a8:	c9                   	leave  
     2a9:	c3                   	ret    

000002aa <stat>:

int
stat(char *n, struct stat *st)
{
     2aa:	55                   	push   %ebp
     2ab:	89 e5                	mov    %esp,%ebp
     2ad:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     2b0:	83 ec 08             	sub    $0x8,%esp
     2b3:	6a 00                	push   $0x0
     2b5:	ff 75 08             	pushl  0x8(%ebp)
     2b8:	e8 0c 01 00 00       	call   3c9 <open>
     2bd:	83 c4 10             	add    $0x10,%esp
     2c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     2c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2c7:	79 07                	jns    2d0 <stat+0x26>
    return -1;
     2c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     2ce:	eb 25                	jmp    2f5 <stat+0x4b>
  r = fstat(fd, st);
     2d0:	83 ec 08             	sub    $0x8,%esp
     2d3:	ff 75 0c             	pushl  0xc(%ebp)
     2d6:	ff 75 f4             	pushl  -0xc(%ebp)
     2d9:	e8 03 01 00 00       	call   3e1 <fstat>
     2de:	83 c4 10             	add    $0x10,%esp
     2e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     2e4:	83 ec 0c             	sub    $0xc,%esp
     2e7:	ff 75 f4             	pushl  -0xc(%ebp)
     2ea:	e8 c2 00 00 00       	call   3b1 <close>
     2ef:	83 c4 10             	add    $0x10,%esp
  return r;
     2f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     2f5:	c9                   	leave  
     2f6:	c3                   	ret    

000002f7 <atoi>:

int
atoi(const char *s)
{
     2f7:	55                   	push   %ebp
     2f8:	89 e5                	mov    %esp,%ebp
     2fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     2fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     304:	eb 25                	jmp    32b <atoi+0x34>
    n = n*10 + *s++ - '0';
     306:	8b 55 fc             	mov    -0x4(%ebp),%edx
     309:	89 d0                	mov    %edx,%eax
     30b:	c1 e0 02             	shl    $0x2,%eax
     30e:	01 d0                	add    %edx,%eax
     310:	01 c0                	add    %eax,%eax
     312:	89 c1                	mov    %eax,%ecx
     314:	8b 45 08             	mov    0x8(%ebp),%eax
     317:	8d 50 01             	lea    0x1(%eax),%edx
     31a:	89 55 08             	mov    %edx,0x8(%ebp)
     31d:	0f b6 00             	movzbl (%eax),%eax
     320:	0f be c0             	movsbl %al,%eax
     323:	01 c8                	add    %ecx,%eax
     325:	83 e8 30             	sub    $0x30,%eax
     328:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     32b:	8b 45 08             	mov    0x8(%ebp),%eax
     32e:	0f b6 00             	movzbl (%eax),%eax
     331:	3c 2f                	cmp    $0x2f,%al
     333:	7e 0a                	jle    33f <atoi+0x48>
     335:	8b 45 08             	mov    0x8(%ebp),%eax
     338:	0f b6 00             	movzbl (%eax),%eax
     33b:	3c 39                	cmp    $0x39,%al
     33d:	7e c7                	jle    306 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     33f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     342:	c9                   	leave  
     343:	c3                   	ret    

00000344 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     344:	55                   	push   %ebp
     345:	89 e5                	mov    %esp,%ebp
     347:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     34a:	8b 45 08             	mov    0x8(%ebp),%eax
     34d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     350:	8b 45 0c             	mov    0xc(%ebp),%eax
     353:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     356:	eb 17                	jmp    36f <memmove+0x2b>
    *dst++ = *src++;
     358:	8b 45 fc             	mov    -0x4(%ebp),%eax
     35b:	8d 50 01             	lea    0x1(%eax),%edx
     35e:	89 55 fc             	mov    %edx,-0x4(%ebp)
     361:	8b 55 f8             	mov    -0x8(%ebp),%edx
     364:	8d 4a 01             	lea    0x1(%edx),%ecx
     367:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     36a:	0f b6 12             	movzbl (%edx),%edx
     36d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     36f:	8b 45 10             	mov    0x10(%ebp),%eax
     372:	8d 50 ff             	lea    -0x1(%eax),%edx
     375:	89 55 10             	mov    %edx,0x10(%ebp)
     378:	85 c0                	test   %eax,%eax
     37a:	7f dc                	jg     358 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     37c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     37f:	c9                   	leave  
     380:	c3                   	ret    

00000381 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     381:	b8 01 00 00 00       	mov    $0x1,%eax
     386:	cd 40                	int    $0x40
     388:	c3                   	ret    

00000389 <exit>:
SYSCALL(exit)
     389:	b8 02 00 00 00       	mov    $0x2,%eax
     38e:	cd 40                	int    $0x40
     390:	c3                   	ret    

00000391 <wait>:
SYSCALL(wait)
     391:	b8 03 00 00 00       	mov    $0x3,%eax
     396:	cd 40                	int    $0x40
     398:	c3                   	ret    

00000399 <pipe>:
SYSCALL(pipe)
     399:	b8 04 00 00 00       	mov    $0x4,%eax
     39e:	cd 40                	int    $0x40
     3a0:	c3                   	ret    

000003a1 <read>:
SYSCALL(read)
     3a1:	b8 05 00 00 00       	mov    $0x5,%eax
     3a6:	cd 40                	int    $0x40
     3a8:	c3                   	ret    

000003a9 <write>:
SYSCALL(write)
     3a9:	b8 10 00 00 00       	mov    $0x10,%eax
     3ae:	cd 40                	int    $0x40
     3b0:	c3                   	ret    

000003b1 <close>:
SYSCALL(close)
     3b1:	b8 15 00 00 00       	mov    $0x15,%eax
     3b6:	cd 40                	int    $0x40
     3b8:	c3                   	ret    

000003b9 <kill>:
SYSCALL(kill)
     3b9:	b8 06 00 00 00       	mov    $0x6,%eax
     3be:	cd 40                	int    $0x40
     3c0:	c3                   	ret    

000003c1 <exec>:
SYSCALL(exec)
     3c1:	b8 07 00 00 00       	mov    $0x7,%eax
     3c6:	cd 40                	int    $0x40
     3c8:	c3                   	ret    

000003c9 <open>:
SYSCALL(open)
     3c9:	b8 0f 00 00 00       	mov    $0xf,%eax
     3ce:	cd 40                	int    $0x40
     3d0:	c3                   	ret    

000003d1 <mknod>:
SYSCALL(mknod)
     3d1:	b8 11 00 00 00       	mov    $0x11,%eax
     3d6:	cd 40                	int    $0x40
     3d8:	c3                   	ret    

000003d9 <unlink>:
SYSCALL(unlink)
     3d9:	b8 12 00 00 00       	mov    $0x12,%eax
     3de:	cd 40                	int    $0x40
     3e0:	c3                   	ret    

000003e1 <fstat>:
SYSCALL(fstat)
     3e1:	b8 08 00 00 00       	mov    $0x8,%eax
     3e6:	cd 40                	int    $0x40
     3e8:	c3                   	ret    

000003e9 <link>:
SYSCALL(link)
     3e9:	b8 13 00 00 00       	mov    $0x13,%eax
     3ee:	cd 40                	int    $0x40
     3f0:	c3                   	ret    

000003f1 <mkdir>:
SYSCALL(mkdir)
     3f1:	b8 14 00 00 00       	mov    $0x14,%eax
     3f6:	cd 40                	int    $0x40
     3f8:	c3                   	ret    

000003f9 <chdir>:
SYSCALL(chdir)
     3f9:	b8 09 00 00 00       	mov    $0x9,%eax
     3fe:	cd 40                	int    $0x40
     400:	c3                   	ret    

00000401 <dup>:
SYSCALL(dup)
     401:	b8 0a 00 00 00       	mov    $0xa,%eax
     406:	cd 40                	int    $0x40
     408:	c3                   	ret    

00000409 <getpid>:
SYSCALL(getpid)
     409:	b8 0b 00 00 00       	mov    $0xb,%eax
     40e:	cd 40                	int    $0x40
     410:	c3                   	ret    

00000411 <sbrk>:
SYSCALL(sbrk)
     411:	b8 0c 00 00 00       	mov    $0xc,%eax
     416:	cd 40                	int    $0x40
     418:	c3                   	ret    

00000419 <sleep>:
SYSCALL(sleep)
     419:	b8 0d 00 00 00       	mov    $0xd,%eax
     41e:	cd 40                	int    $0x40
     420:	c3                   	ret    

00000421 <uptime>:
SYSCALL(uptime)
     421:	b8 0e 00 00 00       	mov    $0xe,%eax
     426:	cd 40                	int    $0x40
     428:	c3                   	ret    

00000429 <getcwd>:
SYSCALL(getcwd)
     429:	b8 16 00 00 00       	mov    $0x16,%eax
     42e:	cd 40                	int    $0x40
     430:	c3                   	ret    

00000431 <shutdown>:
SYSCALL(shutdown)
     431:	b8 17 00 00 00       	mov    $0x17,%eax
     436:	cd 40                	int    $0x40
     438:	c3                   	ret    

00000439 <buildinfo>:
SYSCALL(buildinfo)
     439:	b8 18 00 00 00       	mov    $0x18,%eax
     43e:	cd 40                	int    $0x40
     440:	c3                   	ret    

00000441 <lseek>:
SYSCALL(lseek)
     441:	b8 19 00 00 00       	mov    $0x19,%eax
     446:	cd 40                	int    $0x40
     448:	c3                   	ret    

00000449 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     449:	55                   	push   %ebp
     44a:	89 e5                	mov    %esp,%ebp
     44c:	83 ec 18             	sub    $0x18,%esp
     44f:	8b 45 0c             	mov    0xc(%ebp),%eax
     452:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     455:	83 ec 04             	sub    $0x4,%esp
     458:	6a 01                	push   $0x1
     45a:	8d 45 f4             	lea    -0xc(%ebp),%eax
     45d:	50                   	push   %eax
     45e:	ff 75 08             	pushl  0x8(%ebp)
     461:	e8 43 ff ff ff       	call   3a9 <write>
     466:	83 c4 10             	add    $0x10,%esp
}
     469:	c9                   	leave  
     46a:	c3                   	ret    

0000046b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     46b:	55                   	push   %ebp
     46c:	89 e5                	mov    %esp,%ebp
     46e:	53                   	push   %ebx
     46f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     479:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     47d:	74 17                	je     496 <printint+0x2b>
     47f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     483:	79 11                	jns    496 <printint+0x2b>
    neg = 1;
     485:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     48c:	8b 45 0c             	mov    0xc(%ebp),%eax
     48f:	f7 d8                	neg    %eax
     491:	89 45 ec             	mov    %eax,-0x14(%ebp)
     494:	eb 06                	jmp    49c <printint+0x31>
  } else {
    x = xx;
     496:	8b 45 0c             	mov    0xc(%ebp),%eax
     499:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     49c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     4a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     4a6:	8d 41 01             	lea    0x1(%ecx),%eax
     4a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
     4ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
     4af:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4b2:	ba 00 00 00 00       	mov    $0x0,%edx
     4b7:	f7 f3                	div    %ebx
     4b9:	89 d0                	mov    %edx,%eax
     4bb:	0f b6 80 e0 14 00 00 	movzbl 0x14e0(%eax),%eax
     4c2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     4c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
     4c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4cc:	ba 00 00 00 00       	mov    $0x0,%edx
     4d1:	f7 f3                	div    %ebx
     4d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     4d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     4da:	75 c7                	jne    4a3 <printint+0x38>
  if(neg)
     4dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4e0:	74 0e                	je     4f0 <printint+0x85>
    buf[i++] = '-';
     4e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e5:	8d 50 01             	lea    0x1(%eax),%edx
     4e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
     4eb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     4f0:	eb 1d                	jmp    50f <printint+0xa4>
    putc(fd, buf[i]);
     4f2:	8d 55 dc             	lea    -0x24(%ebp),%edx
     4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f8:	01 d0                	add    %edx,%eax
     4fa:	0f b6 00             	movzbl (%eax),%eax
     4fd:	0f be c0             	movsbl %al,%eax
     500:	83 ec 08             	sub    $0x8,%esp
     503:	50                   	push   %eax
     504:	ff 75 08             	pushl  0x8(%ebp)
     507:	e8 3d ff ff ff       	call   449 <putc>
     50c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     50f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     517:	79 d9                	jns    4f2 <printint+0x87>
    putc(fd, buf[i]);
}
     519:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     51c:	c9                   	leave  
     51d:	c3                   	ret    

0000051e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     51e:	55                   	push   %ebp
     51f:	89 e5                	mov    %esp,%ebp
     521:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     524:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     52b:	8d 45 0c             	lea    0xc(%ebp),%eax
     52e:	83 c0 04             	add    $0x4,%eax
     531:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     534:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     53b:	e9 59 01 00 00       	jmp    699 <printf+0x17b>
    c = fmt[i] & 0xff;
     540:	8b 55 0c             	mov    0xc(%ebp),%edx
     543:	8b 45 f0             	mov    -0x10(%ebp),%eax
     546:	01 d0                	add    %edx,%eax
     548:	0f b6 00             	movzbl (%eax),%eax
     54b:	0f be c0             	movsbl %al,%eax
     54e:	25 ff 00 00 00       	and    $0xff,%eax
     553:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     556:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     55a:	75 2c                	jne    588 <printf+0x6a>
      if(c == '%'){
     55c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     560:	75 0c                	jne    56e <printf+0x50>
        state = '%';
     562:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     569:	e9 27 01 00 00       	jmp    695 <printf+0x177>
      } else {
        putc(fd, c);
     56e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     571:	0f be c0             	movsbl %al,%eax
     574:	83 ec 08             	sub    $0x8,%esp
     577:	50                   	push   %eax
     578:	ff 75 08             	pushl  0x8(%ebp)
     57b:	e8 c9 fe ff ff       	call   449 <putc>
     580:	83 c4 10             	add    $0x10,%esp
     583:	e9 0d 01 00 00       	jmp    695 <printf+0x177>
      }
    } else if(state == '%'){
     588:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     58c:	0f 85 03 01 00 00    	jne    695 <printf+0x177>
      if(c == 'd'){
     592:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     596:	75 1e                	jne    5b6 <printf+0x98>
        printint(fd, *ap, 10, 1);
     598:	8b 45 e8             	mov    -0x18(%ebp),%eax
     59b:	8b 00                	mov    (%eax),%eax
     59d:	6a 01                	push   $0x1
     59f:	6a 0a                	push   $0xa
     5a1:	50                   	push   %eax
     5a2:	ff 75 08             	pushl  0x8(%ebp)
     5a5:	e8 c1 fe ff ff       	call   46b <printint>
     5aa:	83 c4 10             	add    $0x10,%esp
        ap++;
     5ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     5b1:	e9 d8 00 00 00       	jmp    68e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
     5b6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     5ba:	74 06                	je     5c2 <printf+0xa4>
     5bc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     5c0:	75 1e                	jne    5e0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
     5c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5c5:	8b 00                	mov    (%eax),%eax
     5c7:	6a 00                	push   $0x0
     5c9:	6a 10                	push   $0x10
     5cb:	50                   	push   %eax
     5cc:	ff 75 08             	pushl  0x8(%ebp)
     5cf:	e8 97 fe ff ff       	call   46b <printint>
     5d4:	83 c4 10             	add    $0x10,%esp
        ap++;
     5d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     5db:	e9 ae 00 00 00       	jmp    68e <printf+0x170>
      } else if(c == 's'){
     5e0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     5e4:	75 43                	jne    629 <printf+0x10b>
        s = (char*)*ap;
     5e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5e9:	8b 00                	mov    (%eax),%eax
     5eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     5ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     5f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     5f6:	75 07                	jne    5ff <printf+0xe1>
          s = "(null)";
     5f8:	c7 45 f4 a8 10 00 00 	movl   $0x10a8,-0xc(%ebp)
        while(*s != 0){
     5ff:	eb 1c                	jmp    61d <printf+0xff>
          putc(fd, *s);
     601:	8b 45 f4             	mov    -0xc(%ebp),%eax
     604:	0f b6 00             	movzbl (%eax),%eax
     607:	0f be c0             	movsbl %al,%eax
     60a:	83 ec 08             	sub    $0x8,%esp
     60d:	50                   	push   %eax
     60e:	ff 75 08             	pushl  0x8(%ebp)
     611:	e8 33 fe ff ff       	call   449 <putc>
     616:	83 c4 10             	add    $0x10,%esp
          s++;
     619:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     61d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     620:	0f b6 00             	movzbl (%eax),%eax
     623:	84 c0                	test   %al,%al
     625:	75 da                	jne    601 <printf+0xe3>
     627:	eb 65                	jmp    68e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     629:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     62d:	75 1d                	jne    64c <printf+0x12e>
        putc(fd, *ap);
     62f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     632:	8b 00                	mov    (%eax),%eax
     634:	0f be c0             	movsbl %al,%eax
     637:	83 ec 08             	sub    $0x8,%esp
     63a:	50                   	push   %eax
     63b:	ff 75 08             	pushl  0x8(%ebp)
     63e:	e8 06 fe ff ff       	call   449 <putc>
     643:	83 c4 10             	add    $0x10,%esp
        ap++;
     646:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     64a:	eb 42                	jmp    68e <printf+0x170>
      } else if(c == '%'){
     64c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     650:	75 17                	jne    669 <printf+0x14b>
        putc(fd, c);
     652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     655:	0f be c0             	movsbl %al,%eax
     658:	83 ec 08             	sub    $0x8,%esp
     65b:	50                   	push   %eax
     65c:	ff 75 08             	pushl  0x8(%ebp)
     65f:	e8 e5 fd ff ff       	call   449 <putc>
     664:	83 c4 10             	add    $0x10,%esp
     667:	eb 25                	jmp    68e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     669:	83 ec 08             	sub    $0x8,%esp
     66c:	6a 25                	push   $0x25
     66e:	ff 75 08             	pushl  0x8(%ebp)
     671:	e8 d3 fd ff ff       	call   449 <putc>
     676:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
     679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     67c:	0f be c0             	movsbl %al,%eax
     67f:	83 ec 08             	sub    $0x8,%esp
     682:	50                   	push   %eax
     683:	ff 75 08             	pushl  0x8(%ebp)
     686:	e8 be fd ff ff       	call   449 <putc>
     68b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     68e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     695:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     699:	8b 55 0c             	mov    0xc(%ebp),%edx
     69c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     69f:	01 d0                	add    %edx,%eax
     6a1:	0f b6 00             	movzbl (%eax),%eax
     6a4:	84 c0                	test   %al,%al
     6a6:	0f 85 94 fe ff ff    	jne    540 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     6ac:	c9                   	leave  
     6ad:	c3                   	ret    

000006ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     6ae:	55                   	push   %ebp
     6af:	89 e5                	mov    %esp,%ebp
     6b1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     6b4:	8b 45 08             	mov    0x8(%ebp),%eax
     6b7:	83 e8 08             	sub    $0x8,%eax
     6ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     6bd:	a1 fc 14 00 00       	mov    0x14fc,%eax
     6c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
     6c5:	eb 24                	jmp    6eb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6ca:	8b 00                	mov    (%eax),%eax
     6cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     6cf:	77 12                	ja     6e3 <free+0x35>
     6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     6d7:	77 24                	ja     6fd <free+0x4f>
     6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6dc:	8b 00                	mov    (%eax),%eax
     6de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6e1:	77 1a                	ja     6fd <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6e6:	8b 00                	mov    (%eax),%eax
     6e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
     6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     6f1:	76 d4                	jbe    6c7 <free+0x19>
     6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6f6:	8b 00                	mov    (%eax),%eax
     6f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6fb:	76 ca                	jbe    6c7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
     700:	8b 40 04             	mov    0x4(%eax),%eax
     703:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     70d:	01 c2                	add    %eax,%edx
     70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     712:	8b 00                	mov    (%eax),%eax
     714:	39 c2                	cmp    %eax,%edx
     716:	75 24                	jne    73c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     718:	8b 45 f8             	mov    -0x8(%ebp),%eax
     71b:	8b 50 04             	mov    0x4(%eax),%edx
     71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     721:	8b 00                	mov    (%eax),%eax
     723:	8b 40 04             	mov    0x4(%eax),%eax
     726:	01 c2                	add    %eax,%edx
     728:	8b 45 f8             	mov    -0x8(%ebp),%eax
     72b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     731:	8b 00                	mov    (%eax),%eax
     733:	8b 10                	mov    (%eax),%edx
     735:	8b 45 f8             	mov    -0x8(%ebp),%eax
     738:	89 10                	mov    %edx,(%eax)
     73a:	eb 0a                	jmp    746 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     73f:	8b 10                	mov    (%eax),%edx
     741:	8b 45 f8             	mov    -0x8(%ebp),%eax
     744:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     746:	8b 45 fc             	mov    -0x4(%ebp),%eax
     749:	8b 40 04             	mov    0x4(%eax),%eax
     74c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     753:	8b 45 fc             	mov    -0x4(%ebp),%eax
     756:	01 d0                	add    %edx,%eax
     758:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     75b:	75 20                	jne    77d <free+0xcf>
    p->s.size += bp->s.size;
     75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     760:	8b 50 04             	mov    0x4(%eax),%edx
     763:	8b 45 f8             	mov    -0x8(%ebp),%eax
     766:	8b 40 04             	mov    0x4(%eax),%eax
     769:	01 c2                	add    %eax,%edx
     76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     76e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     771:	8b 45 f8             	mov    -0x8(%ebp),%eax
     774:	8b 10                	mov    (%eax),%edx
     776:	8b 45 fc             	mov    -0x4(%ebp),%eax
     779:	89 10                	mov    %edx,(%eax)
     77b:	eb 08                	jmp    785 <free+0xd7>
  } else
    p->s.ptr = bp;
     77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     780:	8b 55 f8             	mov    -0x8(%ebp),%edx
     783:	89 10                	mov    %edx,(%eax)
  freep = p;
     785:	8b 45 fc             	mov    -0x4(%ebp),%eax
     788:	a3 fc 14 00 00       	mov    %eax,0x14fc
}
     78d:	c9                   	leave  
     78e:	c3                   	ret    

0000078f <morecore>:

static Header*
morecore(uint nu)
{
     78f:	55                   	push   %ebp
     790:	89 e5                	mov    %esp,%ebp
     792:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     795:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     79c:	77 07                	ja     7a5 <morecore+0x16>
    nu = 4096;
     79e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     7a5:	8b 45 08             	mov    0x8(%ebp),%eax
     7a8:	c1 e0 03             	shl    $0x3,%eax
     7ab:	83 ec 0c             	sub    $0xc,%esp
     7ae:	50                   	push   %eax
     7af:	e8 5d fc ff ff       	call   411 <sbrk>
     7b4:	83 c4 10             	add    $0x10,%esp
     7b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     7ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     7be:	75 07                	jne    7c7 <morecore+0x38>
    return 0;
     7c0:	b8 00 00 00 00       	mov    $0x0,%eax
     7c5:	eb 26                	jmp    7ed <morecore+0x5e>
  hp = (Header*)p;
     7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7d0:	8b 55 08             	mov    0x8(%ebp),%edx
     7d3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7d9:	83 c0 08             	add    $0x8,%eax
     7dc:	83 ec 0c             	sub    $0xc,%esp
     7df:	50                   	push   %eax
     7e0:	e8 c9 fe ff ff       	call   6ae <free>
     7e5:	83 c4 10             	add    $0x10,%esp
  return freep;
     7e8:	a1 fc 14 00 00       	mov    0x14fc,%eax
}
     7ed:	c9                   	leave  
     7ee:	c3                   	ret    

000007ef <malloc>:

void*
malloc(uint nbytes)
{
     7ef:	55                   	push   %ebp
     7f0:	89 e5                	mov    %esp,%ebp
     7f2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     7f5:	8b 45 08             	mov    0x8(%ebp),%eax
     7f8:	83 c0 07             	add    $0x7,%eax
     7fb:	c1 e8 03             	shr    $0x3,%eax
     7fe:	83 c0 01             	add    $0x1,%eax
     801:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     804:	a1 fc 14 00 00       	mov    0x14fc,%eax
     809:	89 45 f0             	mov    %eax,-0x10(%ebp)
     80c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     810:	75 23                	jne    835 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     812:	c7 45 f0 f4 14 00 00 	movl   $0x14f4,-0x10(%ebp)
     819:	8b 45 f0             	mov    -0x10(%ebp),%eax
     81c:	a3 fc 14 00 00       	mov    %eax,0x14fc
     821:	a1 fc 14 00 00       	mov    0x14fc,%eax
     826:	a3 f4 14 00 00       	mov    %eax,0x14f4
    base.s.size = 0;
     82b:	c7 05 f8 14 00 00 00 	movl   $0x0,0x14f8
     832:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     835:	8b 45 f0             	mov    -0x10(%ebp),%eax
     838:	8b 00                	mov    (%eax),%eax
     83a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     840:	8b 40 04             	mov    0x4(%eax),%eax
     843:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     846:	72 4d                	jb     895 <malloc+0xa6>
      if(p->s.size == nunits)
     848:	8b 45 f4             	mov    -0xc(%ebp),%eax
     84b:	8b 40 04             	mov    0x4(%eax),%eax
     84e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     851:	75 0c                	jne    85f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     853:	8b 45 f4             	mov    -0xc(%ebp),%eax
     856:	8b 10                	mov    (%eax),%edx
     858:	8b 45 f0             	mov    -0x10(%ebp),%eax
     85b:	89 10                	mov    %edx,(%eax)
     85d:	eb 26                	jmp    885 <malloc+0x96>
      else {
        p->s.size -= nunits;
     85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     862:	8b 40 04             	mov    0x4(%eax),%eax
     865:	2b 45 ec             	sub    -0x14(%ebp),%eax
     868:	89 c2                	mov    %eax,%edx
     86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     86d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     870:	8b 45 f4             	mov    -0xc(%ebp),%eax
     873:	8b 40 04             	mov    0x4(%eax),%eax
     876:	c1 e0 03             	shl    $0x3,%eax
     879:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     87f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     882:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     885:	8b 45 f0             	mov    -0x10(%ebp),%eax
     888:	a3 fc 14 00 00       	mov    %eax,0x14fc
      return (void*)(p + 1);
     88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     890:	83 c0 08             	add    $0x8,%eax
     893:	eb 3b                	jmp    8d0 <malloc+0xe1>
    }
    if(p == freep)
     895:	a1 fc 14 00 00       	mov    0x14fc,%eax
     89a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     89d:	75 1e                	jne    8bd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
     89f:	83 ec 0c             	sub    $0xc,%esp
     8a2:	ff 75 ec             	pushl  -0x14(%ebp)
     8a5:	e8 e5 fe ff ff       	call   78f <morecore>
     8aa:	83 c4 10             	add    $0x10,%esp
     8ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
     8b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8b4:	75 07                	jne    8bd <malloc+0xce>
        return 0;
     8b6:	b8 00 00 00 00       	mov    $0x0,%eax
     8bb:	eb 13                	jmp    8d0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
     8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c6:	8b 00                	mov    (%eax),%eax
     8c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     8cb:	e9 6d ff ff ff       	jmp    83d <malloc+0x4e>
}
     8d0:	c9                   	leave  
     8d1:	c3                   	ret    

000008d2 <isspace>:

#include "common.h"

int isspace(char c) {
     8d2:	55                   	push   %ebp
     8d3:	89 e5                	mov    %esp,%ebp
     8d5:	83 ec 04             	sub    $0x4,%esp
     8d8:	8b 45 08             	mov    0x8(%ebp),%eax
     8db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
     8de:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     8e2:	74 12                	je     8f6 <isspace+0x24>
     8e4:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     8e8:	74 0c                	je     8f6 <isspace+0x24>
     8ea:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     8ee:	74 06                	je     8f6 <isspace+0x24>
     8f0:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     8f4:	75 07                	jne    8fd <isspace+0x2b>
     8f6:	b8 01 00 00 00       	mov    $0x1,%eax
     8fb:	eb 05                	jmp    902 <isspace+0x30>
     8fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
     902:	c9                   	leave  
     903:	c3                   	ret    

00000904 <readln>:

char* readln(char *buf, int max, int fd)
{
     904:	55                   	push   %ebp
     905:	89 e5                	mov    %esp,%ebp
     907:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     90a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     911:	eb 45                	jmp    958 <readln+0x54>
    cc = read(fd, &c, 1);
     913:	83 ec 04             	sub    $0x4,%esp
     916:	6a 01                	push   $0x1
     918:	8d 45 ef             	lea    -0x11(%ebp),%eax
     91b:	50                   	push   %eax
     91c:	ff 75 10             	pushl  0x10(%ebp)
     91f:	e8 7d fa ff ff       	call   3a1 <read>
     924:	83 c4 10             	add    $0x10,%esp
     927:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     92a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     92e:	7f 02                	jg     932 <readln+0x2e>
      break;
     930:	eb 31                	jmp    963 <readln+0x5f>
    buf[i++] = c;
     932:	8b 45 f4             	mov    -0xc(%ebp),%eax
     935:	8d 50 01             	lea    0x1(%eax),%edx
     938:	89 55 f4             	mov    %edx,-0xc(%ebp)
     93b:	89 c2                	mov    %eax,%edx
     93d:	8b 45 08             	mov    0x8(%ebp),%eax
     940:	01 c2                	add    %eax,%edx
     942:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     946:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     948:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     94c:	3c 0a                	cmp    $0xa,%al
     94e:	74 13                	je     963 <readln+0x5f>
     950:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     954:	3c 0d                	cmp    $0xd,%al
     956:	74 0b                	je     963 <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     958:	8b 45 f4             	mov    -0xc(%ebp),%eax
     95b:	83 c0 01             	add    $0x1,%eax
     95e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     961:	7c b0                	jl     913 <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     963:	8b 55 f4             	mov    -0xc(%ebp),%edx
     966:	8b 45 08             	mov    0x8(%ebp),%eax
     969:	01 d0                	add    %edx,%eax
     96b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     96e:	8b 45 08             	mov    0x8(%ebp),%eax
}
     971:	c9                   	leave  
     972:	c3                   	ret    

00000973 <strncpy>:

char* strncpy(char* dest, char* src, int n) {
     973:	55                   	push   %ebp
     974:	89 e5                	mov    %esp,%ebp
     976:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     979:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     980:	eb 19                	jmp    99b <strncpy+0x28>
		dest[i] = src[i];
     982:	8b 55 fc             	mov    -0x4(%ebp),%edx
     985:	8b 45 08             	mov    0x8(%ebp),%eax
     988:	01 c2                	add    %eax,%edx
     98a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
     98d:	8b 45 0c             	mov    0xc(%ebp),%eax
     990:	01 c8                	add    %ecx,%eax
     992:	0f b6 00             	movzbl (%eax),%eax
     995:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     997:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     99b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     99e:	3b 45 10             	cmp    0x10(%ebp),%eax
     9a1:	7d 0f                	jge    9b2 <strncpy+0x3f>
     9a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
     9a6:	8b 45 0c             	mov    0xc(%ebp),%eax
     9a9:	01 d0                	add    %edx,%eax
     9ab:	0f b6 00             	movzbl (%eax),%eax
     9ae:	84 c0                	test   %al,%al
     9b0:	75 d0                	jne    982 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
     9b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9b5:	c9                   	leave  
     9b6:	c3                   	ret    

000009b7 <trim>:

char* trim(char* orig) {
     9b7:	55                   	push   %ebp
     9b8:	89 e5                	mov    %esp,%ebp
     9ba:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
     9bd:	8b 45 08             	mov    0x8(%ebp),%eax
     9c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
     9c3:	8b 45 08             	mov    0x8(%ebp),%eax
     9c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
     9c9:	eb 04                	jmp    9cf <trim+0x18>
     9cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9d2:	0f b6 00             	movzbl (%eax),%eax
     9d5:	0f be c0             	movsbl %al,%eax
     9d8:	50                   	push   %eax
     9d9:	e8 f4 fe ff ff       	call   8d2 <isspace>
     9de:	83 c4 04             	add    $0x4,%esp
     9e1:	85 c0                	test   %eax,%eax
     9e3:	75 e6                	jne    9cb <trim+0x14>
	while (*tail) { tail++; }
     9e5:	eb 04                	jmp    9eb <trim+0x34>
     9e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     9eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9ee:	0f b6 00             	movzbl (%eax),%eax
     9f1:	84 c0                	test   %al,%al
     9f3:	75 f2                	jne    9e7 <trim+0x30>
	do { tail--; } while (isspace(*tail));
     9f5:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
     9f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9fc:	0f b6 00             	movzbl (%eax),%eax
     9ff:	0f be c0             	movsbl %al,%eax
     a02:	50                   	push   %eax
     a03:	e8 ca fe ff ff       	call   8d2 <isspace>
     a08:	83 c4 04             	add    $0x4,%esp
     a0b:	85 c0                	test   %eax,%eax
     a0d:	75 e6                	jne    9f5 <trim+0x3e>
	new = malloc(tail-head+2);
     a0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a15:	29 c2                	sub    %eax,%edx
     a17:	89 d0                	mov    %edx,%eax
     a19:	83 c0 02             	add    $0x2,%eax
     a1c:	83 ec 0c             	sub    $0xc,%esp
     a1f:	50                   	push   %eax
     a20:	e8 ca fd ff ff       	call   7ef <malloc>
     a25:	83 c4 10             	add    $0x10,%esp
     a28:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
     a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a31:	29 c2                	sub    %eax,%edx
     a33:	89 d0                	mov    %edx,%eax
     a35:	83 c0 01             	add    $0x1,%eax
     a38:	83 ec 04             	sub    $0x4,%esp
     a3b:	50                   	push   %eax
     a3c:	ff 75 f4             	pushl  -0xc(%ebp)
     a3f:	ff 75 ec             	pushl  -0x14(%ebp)
     a42:	e8 2c ff ff ff       	call   973 <strncpy>
     a47:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
     a4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a50:	29 c2                	sub    %eax,%edx
     a52:	89 d0                	mov    %edx,%eax
     a54:	8d 50 01             	lea    0x1(%eax),%edx
     a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
     a5a:	01 d0                	add    %edx,%eax
     a5c:	c6 00 00             	movb   $0x0,(%eax)
	return new;
     a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
     a62:	c9                   	leave  
     a63:	c3                   	ret    

00000a64 <itoa>:

char *
itoa(int value)
{
     a64:	55                   	push   %ebp
     a65:	89 e5                	mov    %esp,%ebp
     a67:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
     a6a:	8d 45 bf             	lea    -0x41(%ebp),%eax
     a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
     a70:	8b 45 08             	mov    0x8(%ebp),%eax
     a73:	c1 e8 1f             	shr    $0x1f,%eax
     a76:	0f b6 c0             	movzbl %al,%eax
     a79:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
     a7c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     a80:	74 0a                	je     a8c <itoa+0x28>
    v = -value;
     a82:	8b 45 08             	mov    0x8(%ebp),%eax
     a85:	f7 d8                	neg    %eax
     a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a8a:	eb 06                	jmp    a92 <itoa+0x2e>
  else
    v = (uint)value;
     a8c:	8b 45 08             	mov    0x8(%ebp),%eax
     a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
     a92:	eb 5b                	jmp    aef <itoa+0x8b>
  {
    i = v % 10;
     a94:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     a97:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     a9c:	89 c8                	mov    %ecx,%eax
     a9e:	f7 e2                	mul    %edx
     aa0:	c1 ea 03             	shr    $0x3,%edx
     aa3:	89 d0                	mov    %edx,%eax
     aa5:	c1 e0 02             	shl    $0x2,%eax
     aa8:	01 d0                	add    %edx,%eax
     aaa:	01 c0                	add    %eax,%eax
     aac:	29 c1                	sub    %eax,%ecx
     aae:	89 ca                	mov    %ecx,%edx
     ab0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
     ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ab6:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     abb:	f7 e2                	mul    %edx
     abd:	89 d0                	mov    %edx,%eax
     abf:	c1 e8 03             	shr    $0x3,%eax
     ac2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
     ac5:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
     ac9:	7f 13                	jg     ade <itoa+0x7a>
      *tp++ = i+'0';
     acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ace:	8d 50 01             	lea    0x1(%eax),%edx
     ad1:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ad4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     ad7:	83 c2 30             	add    $0x30,%edx
     ada:	88 10                	mov    %dl,(%eax)
     adc:	eb 11                	jmp    aef <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
     ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ae1:	8d 50 01             	lea    0x1(%eax),%edx
     ae4:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ae7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     aea:	83 c2 57             	add    $0x57,%edx
     aed:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
     aef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     af3:	75 9f                	jne    a94 <itoa+0x30>
     af5:	8d 45 bf             	lea    -0x41(%ebp),%eax
     af8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     afb:	74 97                	je     a94 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
     afd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b00:	8d 45 bf             	lea    -0x41(%ebp),%eax
     b03:	29 c2                	sub    %eax,%edx
     b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b08:	01 d0                	add    %edx,%eax
     b0a:	83 c0 01             	add    $0x1,%eax
     b0d:	83 ec 0c             	sub    $0xc,%esp
     b10:	50                   	push   %eax
     b11:	e8 d9 fc ff ff       	call   7ef <malloc>
     b16:	83 c4 10             	add    $0x10,%esp
     b19:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
     b1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b1f:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
     b22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b26:	74 0c                	je     b34 <itoa+0xd0>
    *sp++ = '-';
     b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b2b:	8d 50 01             	lea    0x1(%eax),%edx
     b2e:	89 55 ec             	mov    %edx,-0x14(%ebp)
     b31:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
     b34:	eb 15                	jmp    b4b <itoa+0xe7>
    *sp++ = *--tp;
     b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b39:	8d 50 01             	lea    0x1(%eax),%edx
     b3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
     b3f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     b43:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b46:	0f b6 12             	movzbl (%edx),%edx
     b49:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
     b4b:	8d 45 bf             	lea    -0x41(%ebp),%eax
     b4e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     b51:	77 e3                	ja     b36 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
     b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b56:	c6 00 00             	movb   $0x0,(%eax)
  return string;
     b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
     b5c:	c9                   	leave  
     b5d:	c3                   	ret    

00000b5e <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
     b5e:	55                   	push   %ebp
     b5f:	89 e5                	mov    %esp,%ebp
     b61:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
     b67:	83 ec 08             	sub    $0x8,%esp
     b6a:	6a 00                	push   $0x0
     b6c:	ff 75 08             	pushl  0x8(%ebp)
     b6f:	e8 55 f8 ff ff       	call   3c9 <open>
     b74:	83 c4 10             	add    $0x10,%esp
     b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     b7a:	e9 22 01 00 00       	jmp    ca1 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
     b7f:	83 ec 08             	sub    $0x8,%esp
     b82:	6a 3d                	push   $0x3d
     b84:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     b8a:	50                   	push   %eax
     b8b:	e8 79 f6 ff ff       	call   209 <strchr>
     b90:	83 c4 10             	add    $0x10,%esp
     b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
     b96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b9a:	0f 84 23 01 00 00    	je     cc3 <parseEnvFile+0x165>
     ba0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ba4:	0f 84 19 01 00 00    	je     cc3 <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
     baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
     bad:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     bb3:	29 c2                	sub    %eax,%edx
     bb5:	89 d0                	mov    %edx,%eax
     bb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
     bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bbd:	83 c0 01             	add    $0x1,%eax
     bc0:	83 ec 0c             	sub    $0xc,%esp
     bc3:	50                   	push   %eax
     bc4:	e8 26 fc ff ff       	call   7ef <malloc>
     bc9:	83 c4 10             	add    $0x10,%esp
     bcc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
     bcf:	83 ec 04             	sub    $0x4,%esp
     bd2:	ff 75 ec             	pushl  -0x14(%ebp)
     bd5:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     bdb:	50                   	push   %eax
     bdc:	ff 75 e8             	pushl  -0x18(%ebp)
     bdf:	e8 8f fd ff ff       	call   973 <strncpy>
     be4:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
     be7:	83 ec 0c             	sub    $0xc,%esp
     bea:	ff 75 e8             	pushl  -0x18(%ebp)
     bed:	e8 c5 fd ff ff       	call   9b7 <trim>
     bf2:	83 c4 10             	add    $0x10,%esp
     bf5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
     bf8:	83 ec 0c             	sub    $0xc,%esp
     bfb:	ff 75 e8             	pushl  -0x18(%ebp)
     bfe:	e8 ab fa ff ff       	call   6ae <free>
     c03:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
     c06:	83 ec 08             	sub    $0x8,%esp
     c09:	ff 75 0c             	pushl  0xc(%ebp)
     c0c:	ff 75 e4             	pushl  -0x1c(%ebp)
     c0f:	e8 c2 01 00 00       	call   dd6 <addToEnvironment>
     c14:	83 c4 10             	add    $0x10,%esp
     c17:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
     c1a:	83 ec 0c             	sub    $0xc,%esp
     c1d:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     c23:	50                   	push   %eax
     c24:	e8 9f f5 ff ff       	call   1c8 <strlen>
     c29:	83 c4 10             	add    $0x10,%esp
     c2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
     c2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c32:	2b 45 ec             	sub    -0x14(%ebp),%eax
     c35:	83 ec 0c             	sub    $0xc,%esp
     c38:	50                   	push   %eax
     c39:	e8 b1 fb ff ff       	call   7ef <malloc>
     c3e:	83 c4 10             	add    $0x10,%esp
     c41:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
     c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c47:	2b 45 ec             	sub    -0x14(%ebp),%eax
     c4a:	8d 50 ff             	lea    -0x1(%eax),%edx
     c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c50:	8d 48 01             	lea    0x1(%eax),%ecx
     c53:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     c59:	01 c8                	add    %ecx,%eax
     c5b:	83 ec 04             	sub    $0x4,%esp
     c5e:	52                   	push   %edx
     c5f:	50                   	push   %eax
     c60:	ff 75 e8             	pushl  -0x18(%ebp)
     c63:	e8 0b fd ff ff       	call   973 <strncpy>
     c68:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
     c6b:	83 ec 0c             	sub    $0xc,%esp
     c6e:	ff 75 e8             	pushl  -0x18(%ebp)
     c71:	e8 41 fd ff ff       	call   9b7 <trim>
     c76:	83 c4 10             	add    $0x10,%esp
     c79:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
     c7c:	83 ec 0c             	sub    $0xc,%esp
     c7f:	ff 75 e8             	pushl  -0x18(%ebp)
     c82:	e8 27 fa ff ff       	call   6ae <free>
     c87:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
     c8a:	83 ec 04             	sub    $0x4,%esp
     c8d:	ff 75 dc             	pushl  -0x24(%ebp)
     c90:	ff 75 0c             	pushl  0xc(%ebp)
     c93:	ff 75 e4             	pushl  -0x1c(%ebp)
     c96:	e8 b8 01 00 00       	call   e53 <addValueToVariable>
     c9b:	83 c4 10             	add    $0x10,%esp
     c9e:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     ca1:	83 ec 04             	sub    $0x4,%esp
     ca4:	ff 75 f4             	pushl  -0xc(%ebp)
     ca7:	68 00 04 00 00       	push   $0x400
     cac:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     cb2:	50                   	push   %eax
     cb3:	e8 4c fc ff ff       	call   904 <readln>
     cb8:	83 c4 10             	add    $0x10,%esp
     cbb:	85 c0                	test   %eax,%eax
     cbd:	0f 85 bc fe ff ff    	jne    b7f <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
     cc3:	83 ec 0c             	sub    $0xc,%esp
     cc6:	ff 75 f4             	pushl  -0xc(%ebp)
     cc9:	e8 e3 f6 ff ff       	call   3b1 <close>
     cce:	83 c4 10             	add    $0x10,%esp
	return head;
     cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     cd4:	c9                   	leave  
     cd5:	c3                   	ret    

00000cd6 <comp>:

int comp(const char* s1, const char* s2)
{
     cd6:	55                   	push   %ebp
     cd7:	89 e5                	mov    %esp,%ebp
     cd9:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
     cdc:	83 ec 08             	sub    $0x8,%esp
     cdf:	ff 75 0c             	pushl  0xc(%ebp)
     ce2:	ff 75 08             	pushl  0x8(%ebp)
     ce5:	e8 9f f4 ff ff       	call   189 <strcmp>
     cea:	83 c4 10             	add    $0x10,%esp
     ced:	85 c0                	test   %eax,%eax
     cef:	0f 94 c0             	sete   %al
     cf2:	0f b6 c0             	movzbl %al,%eax
}
     cf5:	c9                   	leave  
     cf6:	c3                   	ret    

00000cf7 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
     cf7:	55                   	push   %ebp
     cf8:	89 e5                	mov    %esp,%ebp
     cfa:	83 ec 08             	sub    $0x8,%esp
  if (!name)
     cfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     d01:	75 07                	jne    d0a <environLookup+0x13>
    return NULL;
     d03:	b8 00 00 00 00       	mov    $0x0,%eax
     d08:	eb 2f                	jmp    d39 <environLookup+0x42>
  
  while (head)
     d0a:	eb 24                	jmp    d30 <environLookup+0x39>
  {
    if (comp(name, head->name))
     d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
     d0f:	83 ec 08             	sub    $0x8,%esp
     d12:	50                   	push   %eax
     d13:	ff 75 08             	pushl  0x8(%ebp)
     d16:	e8 bb ff ff ff       	call   cd6 <comp>
     d1b:	83 c4 10             	add    $0x10,%esp
     d1e:	85 c0                	test   %eax,%eax
     d20:	74 02                	je     d24 <environLookup+0x2d>
      break;
     d22:	eb 12                	jmp    d36 <environLookup+0x3f>
    head = head->next;
     d24:	8b 45 0c             	mov    0xc(%ebp),%eax
     d27:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     d2d:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
     d30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     d34:	75 d6                	jne    d0c <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
     d36:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     d39:	c9                   	leave  
     d3a:	c3                   	ret    

00000d3b <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
     d3b:	55                   	push   %ebp
     d3c:	89 e5                	mov    %esp,%ebp
     d3e:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
     d41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     d45:	75 0a                	jne    d51 <removeFromEnvironment+0x16>
    return NULL;
     d47:	b8 00 00 00 00       	mov    $0x0,%eax
     d4c:	e9 83 00 00 00       	jmp    dd4 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
     d51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     d55:	74 0a                	je     d61 <removeFromEnvironment+0x26>
     d57:	8b 45 08             	mov    0x8(%ebp),%eax
     d5a:	0f b6 00             	movzbl (%eax),%eax
     d5d:	84 c0                	test   %al,%al
     d5f:	75 05                	jne    d66 <removeFromEnvironment+0x2b>
    return head;
     d61:	8b 45 0c             	mov    0xc(%ebp),%eax
     d64:	eb 6e                	jmp    dd4 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
     d66:	8b 45 0c             	mov    0xc(%ebp),%eax
     d69:	83 ec 08             	sub    $0x8,%esp
     d6c:	ff 75 08             	pushl  0x8(%ebp)
     d6f:	50                   	push   %eax
     d70:	e8 61 ff ff ff       	call   cd6 <comp>
     d75:	83 c4 10             	add    $0x10,%esp
     d78:	85 c0                	test   %eax,%eax
     d7a:	74 34                	je     db0 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
     d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
     d7f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
     d88:	8b 45 0c             	mov    0xc(%ebp),%eax
     d8b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     d91:	83 ec 0c             	sub    $0xc,%esp
     d94:	50                   	push   %eax
     d95:	e8 74 01 00 00       	call   f0e <freeVarval>
     d9a:	83 c4 10             	add    $0x10,%esp
    free(head);
     d9d:	83 ec 0c             	sub    $0xc,%esp
     da0:	ff 75 0c             	pushl  0xc(%ebp)
     da3:	e8 06 f9 ff ff       	call   6ae <free>
     da8:	83 c4 10             	add    $0x10,%esp
    return tmp;
     dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dae:	eb 24                	jmp    dd4 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
     db0:	8b 45 0c             	mov    0xc(%ebp),%eax
     db3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     db9:	83 ec 08             	sub    $0x8,%esp
     dbc:	50                   	push   %eax
     dbd:	ff 75 08             	pushl  0x8(%ebp)
     dc0:	e8 76 ff ff ff       	call   d3b <removeFromEnvironment>
     dc5:	83 c4 10             	add    $0x10,%esp
     dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
     dcb:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
     dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     dd4:	c9                   	leave  
     dd5:	c3                   	ret    

00000dd6 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
     dd6:	55                   	push   %ebp
     dd7:	89 e5                	mov    %esp,%ebp
     dd9:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
     ddc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     de0:	75 05                	jne    de7 <addToEnvironment+0x11>
		return head;
     de2:	8b 45 0c             	mov    0xc(%ebp),%eax
     de5:	eb 6a                	jmp    e51 <addToEnvironment+0x7b>
	if (head == NULL) {
     de7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     deb:	75 40                	jne    e2d <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
     ded:	83 ec 0c             	sub    $0xc,%esp
     df0:	68 88 00 00 00       	push   $0x88
     df5:	e8 f5 f9 ff ff       	call   7ef <malloc>
     dfa:	83 c4 10             	add    $0x10,%esp
     dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
     e00:	8b 45 08             	mov    0x8(%ebp),%eax
     e03:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
     e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e09:	83 ec 08             	sub    $0x8,%esp
     e0c:	ff 75 f0             	pushl  -0x10(%ebp)
     e0f:	50                   	push   %eax
     e10:	e8 44 f3 ff ff       	call   159 <strcpy>
     e15:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
     e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e1b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
     e22:	00 00 00 
		head = newVar;
     e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e28:	89 45 0c             	mov    %eax,0xc(%ebp)
     e2b:	eb 21                	jmp    e4e <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
     e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
     e30:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     e36:	83 ec 08             	sub    $0x8,%esp
     e39:	50                   	push   %eax
     e3a:	ff 75 08             	pushl  0x8(%ebp)
     e3d:	e8 94 ff ff ff       	call   dd6 <addToEnvironment>
     e42:	83 c4 10             	add    $0x10,%esp
     e45:	8b 55 0c             	mov    0xc(%ebp),%edx
     e48:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
     e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     e51:	c9                   	leave  
     e52:	c3                   	ret    

00000e53 <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
     e53:	55                   	push   %ebp
     e54:	89 e5                	mov    %esp,%ebp
     e56:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
     e59:	83 ec 08             	sub    $0x8,%esp
     e5c:	ff 75 0c             	pushl  0xc(%ebp)
     e5f:	ff 75 08             	pushl  0x8(%ebp)
     e62:	e8 90 fe ff ff       	call   cf7 <environLookup>
     e67:	83 c4 10             	add    $0x10,%esp
     e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
     e6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e71:	75 05                	jne    e78 <addValueToVariable+0x25>
		return head;
     e73:	8b 45 0c             	mov    0xc(%ebp),%eax
     e76:	eb 4c                	jmp    ec4 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
     e78:	83 ec 0c             	sub    $0xc,%esp
     e7b:	68 04 04 00 00       	push   $0x404
     e80:	e8 6a f9 ff ff       	call   7ef <malloc>
     e85:	83 c4 10             	add    $0x10,%esp
     e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
     e8b:	8b 45 10             	mov    0x10(%ebp),%eax
     e8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
     e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e94:	83 ec 08             	sub    $0x8,%esp
     e97:	ff 75 ec             	pushl  -0x14(%ebp)
     e9a:	50                   	push   %eax
     e9b:	e8 b9 f2 ff ff       	call   159 <strcpy>
     ea0:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
     ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ea6:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
     eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eaf:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
     eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
     ebb:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
     ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     ec4:	c9                   	leave  
     ec5:	c3                   	ret    

00000ec6 <freeEnvironment>:

void freeEnvironment(variable* head)
{
     ec6:	55                   	push   %ebp
     ec7:	89 e5                	mov    %esp,%ebp
     ec9:	83 ec 08             	sub    $0x8,%esp
  if (!head)
     ecc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ed0:	75 02                	jne    ed4 <freeEnvironment+0xe>
    return;  
     ed2:	eb 38                	jmp    f0c <freeEnvironment+0x46>
  freeEnvironment(head->next);
     ed4:	8b 45 08             	mov    0x8(%ebp),%eax
     ed7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     edd:	83 ec 0c             	sub    $0xc,%esp
     ee0:	50                   	push   %eax
     ee1:	e8 e0 ff ff ff       	call   ec6 <freeEnvironment>
     ee6:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
     ee9:	8b 45 08             	mov    0x8(%ebp),%eax
     eec:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     ef2:	83 ec 0c             	sub    $0xc,%esp
     ef5:	50                   	push   %eax
     ef6:	e8 13 00 00 00       	call   f0e <freeVarval>
     efb:	83 c4 10             	add    $0x10,%esp
  free(head);
     efe:	83 ec 0c             	sub    $0xc,%esp
     f01:	ff 75 08             	pushl  0x8(%ebp)
     f04:	e8 a5 f7 ff ff       	call   6ae <free>
     f09:	83 c4 10             	add    $0x10,%esp
}
     f0c:	c9                   	leave  
     f0d:	c3                   	ret    

00000f0e <freeVarval>:

void freeVarval(varval* head)
{
     f0e:	55                   	push   %ebp
     f0f:	89 e5                	mov    %esp,%ebp
     f11:	83 ec 08             	sub    $0x8,%esp
  if (!head)
     f14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f18:	75 02                	jne    f1c <freeVarval+0xe>
    return;  
     f1a:	eb 23                	jmp    f3f <freeVarval+0x31>
  freeVarval(head->next);
     f1c:	8b 45 08             	mov    0x8(%ebp),%eax
     f1f:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
     f25:	83 ec 0c             	sub    $0xc,%esp
     f28:	50                   	push   %eax
     f29:	e8 e0 ff ff ff       	call   f0e <freeVarval>
     f2e:	83 c4 10             	add    $0x10,%esp
  free(head);
     f31:	83 ec 0c             	sub    $0xc,%esp
     f34:	ff 75 08             	pushl  0x8(%ebp)
     f37:	e8 72 f7 ff ff       	call   6ae <free>
     f3c:	83 c4 10             	add    $0x10,%esp
}
     f3f:	c9                   	leave  
     f40:	c3                   	ret    

00000f41 <getPaths>:

varval* getPaths(char* paths, varval* head) {
     f41:	55                   	push   %ebp
     f42:	89 e5                	mov    %esp,%ebp
     f44:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
     f47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f4b:	75 08                	jne    f55 <getPaths+0x14>
		return head;
     f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
     f50:	e9 e7 00 00 00       	jmp    103c <getPaths+0xfb>
	if (head == NULL) {
     f55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f59:	0f 85 b9 00 00 00    	jne    1018 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
     f5f:	83 ec 08             	sub    $0x8,%esp
     f62:	6a 3a                	push   $0x3a
     f64:	ff 75 08             	pushl  0x8(%ebp)
     f67:	e8 9d f2 ff ff       	call   209 <strchr>
     f6c:	83 c4 10             	add    $0x10,%esp
     f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
     f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f76:	75 56                	jne    fce <getPaths+0x8d>
			pathLen = strlen(paths);
     f78:	83 ec 0c             	sub    $0xc,%esp
     f7b:	ff 75 08             	pushl  0x8(%ebp)
     f7e:	e8 45 f2 ff ff       	call   1c8 <strlen>
     f83:	83 c4 10             	add    $0x10,%esp
     f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
     f89:	83 ec 0c             	sub    $0xc,%esp
     f8c:	68 04 04 00 00       	push   $0x404
     f91:	e8 59 f8 ff ff       	call   7ef <malloc>
     f96:	83 c4 10             	add    $0x10,%esp
     f99:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
     f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
     f9f:	83 ec 04             	sub    $0x4,%esp
     fa2:	ff 75 f0             	pushl  -0x10(%ebp)
     fa5:	ff 75 08             	pushl  0x8(%ebp)
     fa8:	50                   	push   %eax
     fa9:	e8 c5 f9 ff ff       	call   973 <strncpy>
     fae:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
     fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
     fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fb7:	01 d0                	add    %edx,%eax
     fb9:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
     fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
     fbf:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
     fc6:	00 00 00 
			return head;
     fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
     fcc:	eb 6e                	jmp    103c <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
     fce:	8b 55 f4             	mov    -0xc(%ebp),%edx
     fd1:	8b 45 08             	mov    0x8(%ebp),%eax
     fd4:	29 c2                	sub    %eax,%edx
     fd6:	89 d0                	mov    %edx,%eax
     fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
     fdb:	83 ec 0c             	sub    $0xc,%esp
     fde:	68 04 04 00 00       	push   $0x404
     fe3:	e8 07 f8 ff ff       	call   7ef <malloc>
     fe8:	83 c4 10             	add    $0x10,%esp
     feb:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
     fee:	8b 45 0c             	mov    0xc(%ebp),%eax
     ff1:	83 ec 04             	sub    $0x4,%esp
     ff4:	ff 75 f0             	pushl  -0x10(%ebp)
     ff7:	ff 75 08             	pushl  0x8(%ebp)
     ffa:	50                   	push   %eax
     ffb:	e8 73 f9 ff ff       	call   973 <strncpy>
    1000:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
    1003:	8b 55 0c             	mov    0xc(%ebp),%edx
    1006:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1009:	01 d0                	add    %edx,%eax
    100b:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
    100e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1011:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
    1014:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
    1018:	8b 45 0c             	mov    0xc(%ebp),%eax
    101b:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
    1021:	83 ec 08             	sub    $0x8,%esp
    1024:	50                   	push   %eax
    1025:	ff 75 08             	pushl  0x8(%ebp)
    1028:	e8 14 ff ff ff       	call   f41 <getPaths>
    102d:	83 c4 10             	add    $0x10,%esp
    1030:	8b 55 0c             	mov    0xc(%ebp),%edx
    1033:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
    1039:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    103c:	c9                   	leave  
    103d:	c3                   	ret    
