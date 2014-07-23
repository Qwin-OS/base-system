
_wc:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
       6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
       d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      10:	89 45 ec             	mov    %eax,-0x14(%ebp)
      13:	8b 45 ec             	mov    -0x14(%ebp),%eax
      16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
      19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
      20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
      22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      29:	eb 58                	jmp    83 <wc+0x83>
      c++;
      2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
      2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      32:	05 c0 15 00 00       	add    $0x15c0,%eax
      37:	0f b6 00             	movzbl (%eax),%eax
      3a:	3c 0a                	cmp    $0xa,%al
      3c:	75 04                	jne    42 <wc+0x42>
        l++;
      3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
      42:	8b 45 f4             	mov    -0xc(%ebp),%eax
      45:	05 c0 15 00 00       	add    $0x15c0,%eax
      4a:	0f b6 00             	movzbl (%eax),%eax
      4d:	0f be c0             	movsbl %al,%eax
      50:	83 ec 08             	sub    $0x8,%esp
      53:	50                   	push   %eax
      54:	68 c6 10 00 00       	push   $0x10c6
      59:	e8 33 02 00 00       	call   291 <strchr>
      5e:	83 c4 10             	add    $0x10,%esp
      61:	85 c0                	test   %eax,%eax
      63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
      65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
      6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
      72:	75 0b                	jne    7f <wc+0x7f>
        w++;
      74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
      78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      83:	8b 45 f4             	mov    -0xc(%ebp),%eax
      86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
      89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
      8b:	83 ec 04             	sub    $0x4,%esp
      8e:	68 00 02 00 00       	push   $0x200
      93:	68 c0 15 00 00       	push   $0x15c0
      98:	ff 75 08             	pushl  0x8(%ebp)
      9b:	e8 89 03 00 00       	call   429 <read>
      a0:	83 c4 10             	add    $0x10,%esp
      a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
      a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
      aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
      b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
      b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
      b6:	83 ec 08             	sub    $0x8,%esp
      b9:	68 cc 10 00 00       	push   $0x10cc
      be:	6a 01                	push   $0x1
      c0:	e8 e1 04 00 00       	call   5a6 <printf>
      c5:	83 c4 10             	add    $0x10,%esp
    exit();
      c8:	e8 44 03 00 00       	call   411 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
      cd:	83 ec 08             	sub    $0x8,%esp
      d0:	ff 75 0c             	pushl  0xc(%ebp)
      d3:	ff 75 e8             	pushl  -0x18(%ebp)
      d6:	ff 75 ec             	pushl  -0x14(%ebp)
      d9:	ff 75 f0             	pushl  -0x10(%ebp)
      dc:	68 dc 10 00 00       	push   $0x10dc
      e1:	6a 01                	push   $0x1
      e3:	e8 be 04 00 00       	call   5a6 <printf>
      e8:	83 c4 20             	add    $0x20,%esp
}
      eb:	c9                   	leave  
      ec:	c3                   	ret    

000000ed <main>:

int
main(int argc, char *argv[])
{
      ed:	8d 4c 24 04          	lea    0x4(%esp),%ecx
      f1:	83 e4 f0             	and    $0xfffffff0,%esp
      f4:	ff 71 fc             	pushl  -0x4(%ecx)
      f7:	55                   	push   %ebp
      f8:	89 e5                	mov    %esp,%ebp
      fa:	53                   	push   %ebx
      fb:	51                   	push   %ecx
      fc:	83 ec 10             	sub    $0x10,%esp
      ff:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
     101:	83 3b 01             	cmpl   $0x1,(%ebx)
     104:	7f 17                	jg     11d <main+0x30>
    wc(0, "");
     106:	83 ec 08             	sub    $0x8,%esp
     109:	68 e9 10 00 00       	push   $0x10e9
     10e:	6a 00                	push   $0x0
     110:	e8 eb fe ff ff       	call   0 <wc>
     115:	83 c4 10             	add    $0x10,%esp
    exit();
     118:	e8 f4 02 00 00       	call   411 <exit>
  }

  for(i = 1; i < argc; i++){
     11d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     124:	e9 83 00 00 00       	jmp    1ac <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
     129:	8b 45 f4             	mov    -0xc(%ebp),%eax
     12c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     133:	8b 43 04             	mov    0x4(%ebx),%eax
     136:	01 d0                	add    %edx,%eax
     138:	8b 00                	mov    (%eax),%eax
     13a:	83 ec 08             	sub    $0x8,%esp
     13d:	6a 00                	push   $0x0
     13f:	50                   	push   %eax
     140:	e8 0c 03 00 00       	call   451 <open>
     145:	83 c4 10             	add    $0x10,%esp
     148:	89 45 f0             	mov    %eax,-0x10(%ebp)
     14b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     14f:	79 29                	jns    17a <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
     151:	8b 45 f4             	mov    -0xc(%ebp),%eax
     154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     15b:	8b 43 04             	mov    0x4(%ebx),%eax
     15e:	01 d0                	add    %edx,%eax
     160:	8b 00                	mov    (%eax),%eax
     162:	83 ec 04             	sub    $0x4,%esp
     165:	50                   	push   %eax
     166:	68 ea 10 00 00       	push   $0x10ea
     16b:	6a 01                	push   $0x1
     16d:	e8 34 04 00 00       	call   5a6 <printf>
     172:	83 c4 10             	add    $0x10,%esp
      exit();
     175:	e8 97 02 00 00       	call   411 <exit>
    }
    wc(fd, argv[i]);
     17a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     17d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     184:	8b 43 04             	mov    0x4(%ebx),%eax
     187:	01 d0                	add    %edx,%eax
     189:	8b 00                	mov    (%eax),%eax
     18b:	83 ec 08             	sub    $0x8,%esp
     18e:	50                   	push   %eax
     18f:	ff 75 f0             	pushl  -0x10(%ebp)
     192:	e8 69 fe ff ff       	call   0 <wc>
     197:	83 c4 10             	add    $0x10,%esp
    close(fd);
     19a:	83 ec 0c             	sub    $0xc,%esp
     19d:	ff 75 f0             	pushl  -0x10(%ebp)
     1a0:	e8 94 02 00 00       	call   439 <close>
     1a5:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
     1a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1af:	3b 03                	cmp    (%ebx),%eax
     1b1:	0f 8c 72 ff ff ff    	jl     129 <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
     1b7:	e8 55 02 00 00       	call   411 <exit>

000001bc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     1bc:	55                   	push   %ebp
     1bd:	89 e5                	mov    %esp,%ebp
     1bf:	57                   	push   %edi
     1c0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     1c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
     1c4:	8b 55 10             	mov    0x10(%ebp),%edx
     1c7:	8b 45 0c             	mov    0xc(%ebp),%eax
     1ca:	89 cb                	mov    %ecx,%ebx
     1cc:	89 df                	mov    %ebx,%edi
     1ce:	89 d1                	mov    %edx,%ecx
     1d0:	fc                   	cld    
     1d1:	f3 aa                	rep stos %al,%es:(%edi)
     1d3:	89 ca                	mov    %ecx,%edx
     1d5:	89 fb                	mov    %edi,%ebx
     1d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
     1da:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     1dd:	5b                   	pop    %ebx
     1de:	5f                   	pop    %edi
     1df:	5d                   	pop    %ebp
     1e0:	c3                   	ret    

000001e1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     1e1:	55                   	push   %ebp
     1e2:	89 e5                	mov    %esp,%ebp
     1e4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     1e7:	8b 45 08             	mov    0x8(%ebp),%eax
     1ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     1ed:	90                   	nop
     1ee:	8b 45 08             	mov    0x8(%ebp),%eax
     1f1:	8d 50 01             	lea    0x1(%eax),%edx
     1f4:	89 55 08             	mov    %edx,0x8(%ebp)
     1f7:	8b 55 0c             	mov    0xc(%ebp),%edx
     1fa:	8d 4a 01             	lea    0x1(%edx),%ecx
     1fd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     200:	0f b6 12             	movzbl (%edx),%edx
     203:	88 10                	mov    %dl,(%eax)
     205:	0f b6 00             	movzbl (%eax),%eax
     208:	84 c0                	test   %al,%al
     20a:	75 e2                	jne    1ee <strcpy+0xd>
    ;
  return os;
     20c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     20f:	c9                   	leave  
     210:	c3                   	ret    

00000211 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     211:	55                   	push   %ebp
     212:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     214:	eb 08                	jmp    21e <strcmp+0xd>
    p++, q++;
     216:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     21a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     21e:	8b 45 08             	mov    0x8(%ebp),%eax
     221:	0f b6 00             	movzbl (%eax),%eax
     224:	84 c0                	test   %al,%al
     226:	74 10                	je     238 <strcmp+0x27>
     228:	8b 45 08             	mov    0x8(%ebp),%eax
     22b:	0f b6 10             	movzbl (%eax),%edx
     22e:	8b 45 0c             	mov    0xc(%ebp),%eax
     231:	0f b6 00             	movzbl (%eax),%eax
     234:	38 c2                	cmp    %al,%dl
     236:	74 de                	je     216 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     238:	8b 45 08             	mov    0x8(%ebp),%eax
     23b:	0f b6 00             	movzbl (%eax),%eax
     23e:	0f b6 d0             	movzbl %al,%edx
     241:	8b 45 0c             	mov    0xc(%ebp),%eax
     244:	0f b6 00             	movzbl (%eax),%eax
     247:	0f b6 c0             	movzbl %al,%eax
     24a:	29 c2                	sub    %eax,%edx
     24c:	89 d0                	mov    %edx,%eax
}
     24e:	5d                   	pop    %ebp
     24f:	c3                   	ret    

00000250 <strlen>:

uint
strlen(char *s)
{
     250:	55                   	push   %ebp
     251:	89 e5                	mov    %esp,%ebp
     253:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     256:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     25d:	eb 04                	jmp    263 <strlen+0x13>
     25f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     263:	8b 55 fc             	mov    -0x4(%ebp),%edx
     266:	8b 45 08             	mov    0x8(%ebp),%eax
     269:	01 d0                	add    %edx,%eax
     26b:	0f b6 00             	movzbl (%eax),%eax
     26e:	84 c0                	test   %al,%al
     270:	75 ed                	jne    25f <strlen+0xf>
    ;
  return n;
     272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     275:	c9                   	leave  
     276:	c3                   	ret    

00000277 <memset>:

void*
memset(void *dst, int c, uint n)
{
     277:	55                   	push   %ebp
     278:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     27a:	8b 45 10             	mov    0x10(%ebp),%eax
     27d:	50                   	push   %eax
     27e:	ff 75 0c             	pushl  0xc(%ebp)
     281:	ff 75 08             	pushl  0x8(%ebp)
     284:	e8 33 ff ff ff       	call   1bc <stosb>
     289:	83 c4 0c             	add    $0xc,%esp
  return dst;
     28c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     28f:	c9                   	leave  
     290:	c3                   	ret    

00000291 <strchr>:

char*
strchr(const char *s, char c)
{
     291:	55                   	push   %ebp
     292:	89 e5                	mov    %esp,%ebp
     294:	83 ec 04             	sub    $0x4,%esp
     297:	8b 45 0c             	mov    0xc(%ebp),%eax
     29a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     29d:	eb 14                	jmp    2b3 <strchr+0x22>
    if(*s == c)
     29f:	8b 45 08             	mov    0x8(%ebp),%eax
     2a2:	0f b6 00             	movzbl (%eax),%eax
     2a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
     2a8:	75 05                	jne    2af <strchr+0x1e>
      return (char*)s;
     2aa:	8b 45 08             	mov    0x8(%ebp),%eax
     2ad:	eb 13                	jmp    2c2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     2af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     2b3:	8b 45 08             	mov    0x8(%ebp),%eax
     2b6:	0f b6 00             	movzbl (%eax),%eax
     2b9:	84 c0                	test   %al,%al
     2bb:	75 e2                	jne    29f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     2bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2c2:	c9                   	leave  
     2c3:	c3                   	ret    

000002c4 <gets>:

char*
gets(char *buf, int max)
{
     2c4:	55                   	push   %ebp
     2c5:	89 e5                	mov    %esp,%ebp
     2c7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     2ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     2d1:	eb 44                	jmp    317 <gets+0x53>
    cc = read(0, &c, 1);
     2d3:	83 ec 04             	sub    $0x4,%esp
     2d6:	6a 01                	push   $0x1
     2d8:	8d 45 ef             	lea    -0x11(%ebp),%eax
     2db:	50                   	push   %eax
     2dc:	6a 00                	push   $0x0
     2de:	e8 46 01 00 00       	call   429 <read>
     2e3:	83 c4 10             	add    $0x10,%esp
     2e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     2e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2ed:	7f 02                	jg     2f1 <gets+0x2d>
      break;
     2ef:	eb 31                	jmp    322 <gets+0x5e>
    buf[i++] = c;
     2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2f4:	8d 50 01             	lea    0x1(%eax),%edx
     2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
     2fa:	89 c2                	mov    %eax,%edx
     2fc:	8b 45 08             	mov    0x8(%ebp),%eax
     2ff:	01 c2                	add    %eax,%edx
     301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     30b:	3c 0a                	cmp    $0xa,%al
     30d:	74 13                	je     322 <gets+0x5e>
     30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     313:	3c 0d                	cmp    $0xd,%al
     315:	74 0b                	je     322 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     317:	8b 45 f4             	mov    -0xc(%ebp),%eax
     31a:	83 c0 01             	add    $0x1,%eax
     31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
     320:	7c b1                	jl     2d3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     322:	8b 55 f4             	mov    -0xc(%ebp),%edx
     325:	8b 45 08             	mov    0x8(%ebp),%eax
     328:	01 d0                	add    %edx,%eax
     32a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     32d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     330:	c9                   	leave  
     331:	c3                   	ret    

00000332 <stat>:

int
stat(char *n, struct stat *st)
{
     332:	55                   	push   %ebp
     333:	89 e5                	mov    %esp,%ebp
     335:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     338:	83 ec 08             	sub    $0x8,%esp
     33b:	6a 00                	push   $0x0
     33d:	ff 75 08             	pushl  0x8(%ebp)
     340:	e8 0c 01 00 00       	call   451 <open>
     345:	83 c4 10             	add    $0x10,%esp
     348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     34b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     34f:	79 07                	jns    358 <stat+0x26>
    return -1;
     351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     356:	eb 25                	jmp    37d <stat+0x4b>
  r = fstat(fd, st);
     358:	83 ec 08             	sub    $0x8,%esp
     35b:	ff 75 0c             	pushl  0xc(%ebp)
     35e:	ff 75 f4             	pushl  -0xc(%ebp)
     361:	e8 03 01 00 00       	call   469 <fstat>
     366:	83 c4 10             	add    $0x10,%esp
     369:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     36c:	83 ec 0c             	sub    $0xc,%esp
     36f:	ff 75 f4             	pushl  -0xc(%ebp)
     372:	e8 c2 00 00 00       	call   439 <close>
     377:	83 c4 10             	add    $0x10,%esp
  return r;
     37a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     37d:	c9                   	leave  
     37e:	c3                   	ret    

0000037f <atoi>:

int
atoi(const char *s)
{
     37f:	55                   	push   %ebp
     380:	89 e5                	mov    %esp,%ebp
     382:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     38c:	eb 25                	jmp    3b3 <atoi+0x34>
    n = n*10 + *s++ - '0';
     38e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     391:	89 d0                	mov    %edx,%eax
     393:	c1 e0 02             	shl    $0x2,%eax
     396:	01 d0                	add    %edx,%eax
     398:	01 c0                	add    %eax,%eax
     39a:	89 c1                	mov    %eax,%ecx
     39c:	8b 45 08             	mov    0x8(%ebp),%eax
     39f:	8d 50 01             	lea    0x1(%eax),%edx
     3a2:	89 55 08             	mov    %edx,0x8(%ebp)
     3a5:	0f b6 00             	movzbl (%eax),%eax
     3a8:	0f be c0             	movsbl %al,%eax
     3ab:	01 c8                	add    %ecx,%eax
     3ad:	83 e8 30             	sub    $0x30,%eax
     3b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     3b3:	8b 45 08             	mov    0x8(%ebp),%eax
     3b6:	0f b6 00             	movzbl (%eax),%eax
     3b9:	3c 2f                	cmp    $0x2f,%al
     3bb:	7e 0a                	jle    3c7 <atoi+0x48>
     3bd:	8b 45 08             	mov    0x8(%ebp),%eax
     3c0:	0f b6 00             	movzbl (%eax),%eax
     3c3:	3c 39                	cmp    $0x39,%al
     3c5:	7e c7                	jle    38e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     3c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3ca:	c9                   	leave  
     3cb:	c3                   	ret    

000003cc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     3cc:	55                   	push   %ebp
     3cd:	89 e5                	mov    %esp,%ebp
     3cf:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     3d2:	8b 45 08             	mov    0x8(%ebp),%eax
     3d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
     3db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     3de:	eb 17                	jmp    3f7 <memmove+0x2b>
    *dst++ = *src++;
     3e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     3e3:	8d 50 01             	lea    0x1(%eax),%edx
     3e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
     3e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
     3ec:	8d 4a 01             	lea    0x1(%edx),%ecx
     3ef:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     3f2:	0f b6 12             	movzbl (%edx),%edx
     3f5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     3f7:	8b 45 10             	mov    0x10(%ebp),%eax
     3fa:	8d 50 ff             	lea    -0x1(%eax),%edx
     3fd:	89 55 10             	mov    %edx,0x10(%ebp)
     400:	85 c0                	test   %eax,%eax
     402:	7f dc                	jg     3e0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     404:	8b 45 08             	mov    0x8(%ebp),%eax
}
     407:	c9                   	leave  
     408:	c3                   	ret    

00000409 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     409:	b8 01 00 00 00       	mov    $0x1,%eax
     40e:	cd 40                	int    $0x40
     410:	c3                   	ret    

00000411 <exit>:
SYSCALL(exit)
     411:	b8 02 00 00 00       	mov    $0x2,%eax
     416:	cd 40                	int    $0x40
     418:	c3                   	ret    

00000419 <wait>:
SYSCALL(wait)
     419:	b8 03 00 00 00       	mov    $0x3,%eax
     41e:	cd 40                	int    $0x40
     420:	c3                   	ret    

00000421 <pipe>:
SYSCALL(pipe)
     421:	b8 04 00 00 00       	mov    $0x4,%eax
     426:	cd 40                	int    $0x40
     428:	c3                   	ret    

00000429 <read>:
SYSCALL(read)
     429:	b8 05 00 00 00       	mov    $0x5,%eax
     42e:	cd 40                	int    $0x40
     430:	c3                   	ret    

00000431 <write>:
SYSCALL(write)
     431:	b8 10 00 00 00       	mov    $0x10,%eax
     436:	cd 40                	int    $0x40
     438:	c3                   	ret    

00000439 <close>:
SYSCALL(close)
     439:	b8 15 00 00 00       	mov    $0x15,%eax
     43e:	cd 40                	int    $0x40
     440:	c3                   	ret    

00000441 <kill>:
SYSCALL(kill)
     441:	b8 06 00 00 00       	mov    $0x6,%eax
     446:	cd 40                	int    $0x40
     448:	c3                   	ret    

00000449 <exec>:
SYSCALL(exec)
     449:	b8 07 00 00 00       	mov    $0x7,%eax
     44e:	cd 40                	int    $0x40
     450:	c3                   	ret    

00000451 <open>:
SYSCALL(open)
     451:	b8 0f 00 00 00       	mov    $0xf,%eax
     456:	cd 40                	int    $0x40
     458:	c3                   	ret    

00000459 <mknod>:
SYSCALL(mknod)
     459:	b8 11 00 00 00       	mov    $0x11,%eax
     45e:	cd 40                	int    $0x40
     460:	c3                   	ret    

00000461 <unlink>:
SYSCALL(unlink)
     461:	b8 12 00 00 00       	mov    $0x12,%eax
     466:	cd 40                	int    $0x40
     468:	c3                   	ret    

00000469 <fstat>:
SYSCALL(fstat)
     469:	b8 08 00 00 00       	mov    $0x8,%eax
     46e:	cd 40                	int    $0x40
     470:	c3                   	ret    

00000471 <link>:
SYSCALL(link)
     471:	b8 13 00 00 00       	mov    $0x13,%eax
     476:	cd 40                	int    $0x40
     478:	c3                   	ret    

00000479 <mkdir>:
SYSCALL(mkdir)
     479:	b8 14 00 00 00       	mov    $0x14,%eax
     47e:	cd 40                	int    $0x40
     480:	c3                   	ret    

00000481 <chdir>:
SYSCALL(chdir)
     481:	b8 09 00 00 00       	mov    $0x9,%eax
     486:	cd 40                	int    $0x40
     488:	c3                   	ret    

00000489 <dup>:
SYSCALL(dup)
     489:	b8 0a 00 00 00       	mov    $0xa,%eax
     48e:	cd 40                	int    $0x40
     490:	c3                   	ret    

00000491 <getpid>:
SYSCALL(getpid)
     491:	b8 0b 00 00 00       	mov    $0xb,%eax
     496:	cd 40                	int    $0x40
     498:	c3                   	ret    

00000499 <sbrk>:
SYSCALL(sbrk)
     499:	b8 0c 00 00 00       	mov    $0xc,%eax
     49e:	cd 40                	int    $0x40
     4a0:	c3                   	ret    

000004a1 <sleep>:
SYSCALL(sleep)
     4a1:	b8 0d 00 00 00       	mov    $0xd,%eax
     4a6:	cd 40                	int    $0x40
     4a8:	c3                   	ret    

000004a9 <uptime>:
SYSCALL(uptime)
     4a9:	b8 0e 00 00 00       	mov    $0xe,%eax
     4ae:	cd 40                	int    $0x40
     4b0:	c3                   	ret    

000004b1 <getcwd>:
SYSCALL(getcwd)
     4b1:	b8 16 00 00 00       	mov    $0x16,%eax
     4b6:	cd 40                	int    $0x40
     4b8:	c3                   	ret    

000004b9 <shutdown>:
SYSCALL(shutdown)
     4b9:	b8 17 00 00 00       	mov    $0x17,%eax
     4be:	cd 40                	int    $0x40
     4c0:	c3                   	ret    

000004c1 <buildinfo>:
SYSCALL(buildinfo)
     4c1:	b8 18 00 00 00       	mov    $0x18,%eax
     4c6:	cd 40                	int    $0x40
     4c8:	c3                   	ret    

000004c9 <lseek>:
SYSCALL(lseek)
     4c9:	b8 19 00 00 00       	mov    $0x19,%eax
     4ce:	cd 40                	int    $0x40
     4d0:	c3                   	ret    

000004d1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     4d1:	55                   	push   %ebp
     4d2:	89 e5                	mov    %esp,%ebp
     4d4:	83 ec 18             	sub    $0x18,%esp
     4d7:	8b 45 0c             	mov    0xc(%ebp),%eax
     4da:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     4dd:	83 ec 04             	sub    $0x4,%esp
     4e0:	6a 01                	push   $0x1
     4e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
     4e5:	50                   	push   %eax
     4e6:	ff 75 08             	pushl  0x8(%ebp)
     4e9:	e8 43 ff ff ff       	call   431 <write>
     4ee:	83 c4 10             	add    $0x10,%esp
}
     4f1:	c9                   	leave  
     4f2:	c3                   	ret    

000004f3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     4f3:	55                   	push   %ebp
     4f4:	89 e5                	mov    %esp,%ebp
     4f6:	53                   	push   %ebx
     4f7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     4fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     501:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     505:	74 17                	je     51e <printint+0x2b>
     507:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     50b:	79 11                	jns    51e <printint+0x2b>
    neg = 1;
     50d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     514:	8b 45 0c             	mov    0xc(%ebp),%eax
     517:	f7 d8                	neg    %eax
     519:	89 45 ec             	mov    %eax,-0x14(%ebp)
     51c:	eb 06                	jmp    524 <printint+0x31>
  } else {
    x = xx;
     51e:	8b 45 0c             	mov    0xc(%ebp),%eax
     521:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     52b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     52e:	8d 41 01             	lea    0x1(%ecx),%eax
     531:	89 45 f4             	mov    %eax,-0xc(%ebp)
     534:	8b 5d 10             	mov    0x10(%ebp),%ebx
     537:	8b 45 ec             	mov    -0x14(%ebp),%eax
     53a:	ba 00 00 00 00       	mov    $0x0,%edx
     53f:	f7 f3                	div    %ebx
     541:	89 d0                	mov    %edx,%eax
     543:	0f b6 80 34 15 00 00 	movzbl 0x1534(%eax),%eax
     54a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     54e:	8b 5d 10             	mov    0x10(%ebp),%ebx
     551:	8b 45 ec             	mov    -0x14(%ebp),%eax
     554:	ba 00 00 00 00       	mov    $0x0,%edx
     559:	f7 f3                	div    %ebx
     55b:	89 45 ec             	mov    %eax,-0x14(%ebp)
     55e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     562:	75 c7                	jne    52b <printint+0x38>
  if(neg)
     564:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     568:	74 0e                	je     578 <printint+0x85>
    buf[i++] = '-';
     56a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     56d:	8d 50 01             	lea    0x1(%eax),%edx
     570:	89 55 f4             	mov    %edx,-0xc(%ebp)
     573:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     578:	eb 1d                	jmp    597 <printint+0xa4>
    putc(fd, buf[i]);
     57a:	8d 55 dc             	lea    -0x24(%ebp),%edx
     57d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     580:	01 d0                	add    %edx,%eax
     582:	0f b6 00             	movzbl (%eax),%eax
     585:	0f be c0             	movsbl %al,%eax
     588:	83 ec 08             	sub    $0x8,%esp
     58b:	50                   	push   %eax
     58c:	ff 75 08             	pushl  0x8(%ebp)
     58f:	e8 3d ff ff ff       	call   4d1 <putc>
     594:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     597:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     59b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     59f:	79 d9                	jns    57a <printint+0x87>
    putc(fd, buf[i]);
}
     5a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     5a4:	c9                   	leave  
     5a5:	c3                   	ret    

000005a6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     5a6:	55                   	push   %ebp
     5a7:	89 e5                	mov    %esp,%ebp
     5a9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     5ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     5b3:	8d 45 0c             	lea    0xc(%ebp),%eax
     5b6:	83 c0 04             	add    $0x4,%eax
     5b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     5bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     5c3:	e9 59 01 00 00       	jmp    721 <printf+0x17b>
    c = fmt[i] & 0xff;
     5c8:	8b 55 0c             	mov    0xc(%ebp),%edx
     5cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ce:	01 d0                	add    %edx,%eax
     5d0:	0f b6 00             	movzbl (%eax),%eax
     5d3:	0f be c0             	movsbl %al,%eax
     5d6:	25 ff 00 00 00       	and    $0xff,%eax
     5db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     5de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5e2:	75 2c                	jne    610 <printf+0x6a>
      if(c == '%'){
     5e4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     5e8:	75 0c                	jne    5f6 <printf+0x50>
        state = '%';
     5ea:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     5f1:	e9 27 01 00 00       	jmp    71d <printf+0x177>
      } else {
        putc(fd, c);
     5f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5f9:	0f be c0             	movsbl %al,%eax
     5fc:	83 ec 08             	sub    $0x8,%esp
     5ff:	50                   	push   %eax
     600:	ff 75 08             	pushl  0x8(%ebp)
     603:	e8 c9 fe ff ff       	call   4d1 <putc>
     608:	83 c4 10             	add    $0x10,%esp
     60b:	e9 0d 01 00 00       	jmp    71d <printf+0x177>
      }
    } else if(state == '%'){
     610:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     614:	0f 85 03 01 00 00    	jne    71d <printf+0x177>
      if(c == 'd'){
     61a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     61e:	75 1e                	jne    63e <printf+0x98>
        printint(fd, *ap, 10, 1);
     620:	8b 45 e8             	mov    -0x18(%ebp),%eax
     623:	8b 00                	mov    (%eax),%eax
     625:	6a 01                	push   $0x1
     627:	6a 0a                	push   $0xa
     629:	50                   	push   %eax
     62a:	ff 75 08             	pushl  0x8(%ebp)
     62d:	e8 c1 fe ff ff       	call   4f3 <printint>
     632:	83 c4 10             	add    $0x10,%esp
        ap++;
     635:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     639:	e9 d8 00 00 00       	jmp    716 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
     63e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     642:	74 06                	je     64a <printf+0xa4>
     644:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     648:	75 1e                	jne    668 <printf+0xc2>
        printint(fd, *ap, 16, 0);
     64a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     64d:	8b 00                	mov    (%eax),%eax
     64f:	6a 00                	push   $0x0
     651:	6a 10                	push   $0x10
     653:	50                   	push   %eax
     654:	ff 75 08             	pushl  0x8(%ebp)
     657:	e8 97 fe ff ff       	call   4f3 <printint>
     65c:	83 c4 10             	add    $0x10,%esp
        ap++;
     65f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     663:	e9 ae 00 00 00       	jmp    716 <printf+0x170>
      } else if(c == 's'){
     668:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     66c:	75 43                	jne    6b1 <printf+0x10b>
        s = (char*)*ap;
     66e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     671:	8b 00                	mov    (%eax),%eax
     673:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     676:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     67a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     67e:	75 07                	jne    687 <printf+0xe1>
          s = "(null)";
     680:	c7 45 f4 fe 10 00 00 	movl   $0x10fe,-0xc(%ebp)
        while(*s != 0){
     687:	eb 1c                	jmp    6a5 <printf+0xff>
          putc(fd, *s);
     689:	8b 45 f4             	mov    -0xc(%ebp),%eax
     68c:	0f b6 00             	movzbl (%eax),%eax
     68f:	0f be c0             	movsbl %al,%eax
     692:	83 ec 08             	sub    $0x8,%esp
     695:	50                   	push   %eax
     696:	ff 75 08             	pushl  0x8(%ebp)
     699:	e8 33 fe ff ff       	call   4d1 <putc>
     69e:	83 c4 10             	add    $0x10,%esp
          s++;
     6a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     6a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6a8:	0f b6 00             	movzbl (%eax),%eax
     6ab:	84 c0                	test   %al,%al
     6ad:	75 da                	jne    689 <printf+0xe3>
     6af:	eb 65                	jmp    716 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     6b1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     6b5:	75 1d                	jne    6d4 <printf+0x12e>
        putc(fd, *ap);
     6b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6ba:	8b 00                	mov    (%eax),%eax
     6bc:	0f be c0             	movsbl %al,%eax
     6bf:	83 ec 08             	sub    $0x8,%esp
     6c2:	50                   	push   %eax
     6c3:	ff 75 08             	pushl  0x8(%ebp)
     6c6:	e8 06 fe ff ff       	call   4d1 <putc>
     6cb:	83 c4 10             	add    $0x10,%esp
        ap++;
     6ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     6d2:	eb 42                	jmp    716 <printf+0x170>
      } else if(c == '%'){
     6d4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     6d8:	75 17                	jne    6f1 <printf+0x14b>
        putc(fd, c);
     6da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6dd:	0f be c0             	movsbl %al,%eax
     6e0:	83 ec 08             	sub    $0x8,%esp
     6e3:	50                   	push   %eax
     6e4:	ff 75 08             	pushl  0x8(%ebp)
     6e7:	e8 e5 fd ff ff       	call   4d1 <putc>
     6ec:	83 c4 10             	add    $0x10,%esp
     6ef:	eb 25                	jmp    716 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     6f1:	83 ec 08             	sub    $0x8,%esp
     6f4:	6a 25                	push   $0x25
     6f6:	ff 75 08             	pushl  0x8(%ebp)
     6f9:	e8 d3 fd ff ff       	call   4d1 <putc>
     6fe:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
     701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     704:	0f be c0             	movsbl %al,%eax
     707:	83 ec 08             	sub    $0x8,%esp
     70a:	50                   	push   %eax
     70b:	ff 75 08             	pushl  0x8(%ebp)
     70e:	e8 be fd ff ff       	call   4d1 <putc>
     713:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     716:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     71d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     721:	8b 55 0c             	mov    0xc(%ebp),%edx
     724:	8b 45 f0             	mov    -0x10(%ebp),%eax
     727:	01 d0                	add    %edx,%eax
     729:	0f b6 00             	movzbl (%eax),%eax
     72c:	84 c0                	test   %al,%al
     72e:	0f 85 94 fe ff ff    	jne    5c8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     734:	c9                   	leave  
     735:	c3                   	ret    

00000736 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     736:	55                   	push   %ebp
     737:	89 e5                	mov    %esp,%ebp
     739:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     73c:	8b 45 08             	mov    0x8(%ebp),%eax
     73f:	83 e8 08             	sub    $0x8,%eax
     742:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     745:	a1 88 15 00 00       	mov    0x1588,%eax
     74a:	89 45 fc             	mov    %eax,-0x4(%ebp)
     74d:	eb 24                	jmp    773 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     752:	8b 00                	mov    (%eax),%eax
     754:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     757:	77 12                	ja     76b <free+0x35>
     759:	8b 45 f8             	mov    -0x8(%ebp),%eax
     75c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     75f:	77 24                	ja     785 <free+0x4f>
     761:	8b 45 fc             	mov    -0x4(%ebp),%eax
     764:	8b 00                	mov    (%eax),%eax
     766:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     769:	77 1a                	ja     785 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     76e:	8b 00                	mov    (%eax),%eax
     770:	89 45 fc             	mov    %eax,-0x4(%ebp)
     773:	8b 45 f8             	mov    -0x8(%ebp),%eax
     776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     779:	76 d4                	jbe    74f <free+0x19>
     77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     77e:	8b 00                	mov    (%eax),%eax
     780:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     783:	76 ca                	jbe    74f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     785:	8b 45 f8             	mov    -0x8(%ebp),%eax
     788:	8b 40 04             	mov    0x4(%eax),%eax
     78b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     792:	8b 45 f8             	mov    -0x8(%ebp),%eax
     795:	01 c2                	add    %eax,%edx
     797:	8b 45 fc             	mov    -0x4(%ebp),%eax
     79a:	8b 00                	mov    (%eax),%eax
     79c:	39 c2                	cmp    %eax,%edx
     79e:	75 24                	jne    7c4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     7a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7a3:	8b 50 04             	mov    0x4(%eax),%edx
     7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7a9:	8b 00                	mov    (%eax),%eax
     7ab:	8b 40 04             	mov    0x4(%eax),%eax
     7ae:	01 c2                	add    %eax,%edx
     7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7b3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7b9:	8b 00                	mov    (%eax),%eax
     7bb:	8b 10                	mov    (%eax),%edx
     7bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7c0:	89 10                	mov    %edx,(%eax)
     7c2:	eb 0a                	jmp    7ce <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7c7:	8b 10                	mov    (%eax),%edx
     7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7cc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7d1:	8b 40 04             	mov    0x4(%eax),%eax
     7d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7de:	01 d0                	add    %edx,%eax
     7e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     7e3:	75 20                	jne    805 <free+0xcf>
    p->s.size += bp->s.size;
     7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7e8:	8b 50 04             	mov    0x4(%eax),%edx
     7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7ee:	8b 40 04             	mov    0x4(%eax),%eax
     7f1:	01 c2                	add    %eax,%edx
     7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7f6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7fc:	8b 10                	mov    (%eax),%edx
     7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
     801:	89 10                	mov    %edx,(%eax)
     803:	eb 08                	jmp    80d <free+0xd7>
  } else
    p->s.ptr = bp;
     805:	8b 45 fc             	mov    -0x4(%ebp),%eax
     808:	8b 55 f8             	mov    -0x8(%ebp),%edx
     80b:	89 10                	mov    %edx,(%eax)
  freep = p;
     80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     810:	a3 88 15 00 00       	mov    %eax,0x1588
}
     815:	c9                   	leave  
     816:	c3                   	ret    

00000817 <morecore>:

static Header*
morecore(uint nu)
{
     817:	55                   	push   %ebp
     818:	89 e5                	mov    %esp,%ebp
     81a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     81d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     824:	77 07                	ja     82d <morecore+0x16>
    nu = 4096;
     826:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     82d:	8b 45 08             	mov    0x8(%ebp),%eax
     830:	c1 e0 03             	shl    $0x3,%eax
     833:	83 ec 0c             	sub    $0xc,%esp
     836:	50                   	push   %eax
     837:	e8 5d fc ff ff       	call   499 <sbrk>
     83c:	83 c4 10             	add    $0x10,%esp
     83f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     842:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     846:	75 07                	jne    84f <morecore+0x38>
    return 0;
     848:	b8 00 00 00 00       	mov    $0x0,%eax
     84d:	eb 26                	jmp    875 <morecore+0x5e>
  hp = (Header*)p;
     84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     852:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     855:	8b 45 f0             	mov    -0x10(%ebp),%eax
     858:	8b 55 08             	mov    0x8(%ebp),%edx
     85b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     861:	83 c0 08             	add    $0x8,%eax
     864:	83 ec 0c             	sub    $0xc,%esp
     867:	50                   	push   %eax
     868:	e8 c9 fe ff ff       	call   736 <free>
     86d:	83 c4 10             	add    $0x10,%esp
  return freep;
     870:	a1 88 15 00 00       	mov    0x1588,%eax
}
     875:	c9                   	leave  
     876:	c3                   	ret    

00000877 <malloc>:

void*
malloc(uint nbytes)
{
     877:	55                   	push   %ebp
     878:	89 e5                	mov    %esp,%ebp
     87a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     87d:	8b 45 08             	mov    0x8(%ebp),%eax
     880:	83 c0 07             	add    $0x7,%eax
     883:	c1 e8 03             	shr    $0x3,%eax
     886:	83 c0 01             	add    $0x1,%eax
     889:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     88c:	a1 88 15 00 00       	mov    0x1588,%eax
     891:	89 45 f0             	mov    %eax,-0x10(%ebp)
     894:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     898:	75 23                	jne    8bd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     89a:	c7 45 f0 80 15 00 00 	movl   $0x1580,-0x10(%ebp)
     8a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8a4:	a3 88 15 00 00       	mov    %eax,0x1588
     8a9:	a1 88 15 00 00       	mov    0x1588,%eax
     8ae:	a3 80 15 00 00       	mov    %eax,0x1580
    base.s.size = 0;
     8b3:	c7 05 84 15 00 00 00 	movl   $0x0,0x1584
     8ba:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8c0:	8b 00                	mov    (%eax),%eax
     8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     8c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c8:	8b 40 04             	mov    0x4(%eax),%eax
     8cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     8ce:	72 4d                	jb     91d <malloc+0xa6>
      if(p->s.size == nunits)
     8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8d3:	8b 40 04             	mov    0x4(%eax),%eax
     8d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     8d9:	75 0c                	jne    8e7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8de:	8b 10                	mov    (%eax),%edx
     8e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8e3:	89 10                	mov    %edx,(%eax)
     8e5:	eb 26                	jmp    90d <malloc+0x96>
      else {
        p->s.size -= nunits;
     8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ea:	8b 40 04             	mov    0x4(%eax),%eax
     8ed:	2b 45 ec             	sub    -0x14(%ebp),%eax
     8f0:	89 c2                	mov    %eax,%edx
     8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8f5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     8f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8fb:	8b 40 04             	mov    0x4(%eax),%eax
     8fe:	c1 e0 03             	shl    $0x3,%eax
     901:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     904:	8b 45 f4             	mov    -0xc(%ebp),%eax
     907:	8b 55 ec             	mov    -0x14(%ebp),%edx
     90a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     90d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     910:	a3 88 15 00 00       	mov    %eax,0x1588
      return (void*)(p + 1);
     915:	8b 45 f4             	mov    -0xc(%ebp),%eax
     918:	83 c0 08             	add    $0x8,%eax
     91b:	eb 3b                	jmp    958 <malloc+0xe1>
    }
    if(p == freep)
     91d:	a1 88 15 00 00       	mov    0x1588,%eax
     922:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     925:	75 1e                	jne    945 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
     927:	83 ec 0c             	sub    $0xc,%esp
     92a:	ff 75 ec             	pushl  -0x14(%ebp)
     92d:	e8 e5 fe ff ff       	call   817 <morecore>
     932:	83 c4 10             	add    $0x10,%esp
     935:	89 45 f4             	mov    %eax,-0xc(%ebp)
     938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     93c:	75 07                	jne    945 <malloc+0xce>
        return 0;
     93e:	b8 00 00 00 00       	mov    $0x0,%eax
     943:	eb 13                	jmp    958 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     945:	8b 45 f4             	mov    -0xc(%ebp),%eax
     948:	89 45 f0             	mov    %eax,-0x10(%ebp)
     94b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     94e:	8b 00                	mov    (%eax),%eax
     950:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     953:	e9 6d ff ff ff       	jmp    8c5 <malloc+0x4e>
}
     958:	c9                   	leave  
     959:	c3                   	ret    

0000095a <isspace>:

#include "common.h"

int isspace(char c) {
     95a:	55                   	push   %ebp
     95b:	89 e5                	mov    %esp,%ebp
     95d:	83 ec 04             	sub    $0x4,%esp
     960:	8b 45 08             	mov    0x8(%ebp),%eax
     963:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
     966:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     96a:	74 12                	je     97e <isspace+0x24>
     96c:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     970:	74 0c                	je     97e <isspace+0x24>
     972:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     976:	74 06                	je     97e <isspace+0x24>
     978:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     97c:	75 07                	jne    985 <isspace+0x2b>
     97e:	b8 01 00 00 00       	mov    $0x1,%eax
     983:	eb 05                	jmp    98a <isspace+0x30>
     985:	b8 00 00 00 00       	mov    $0x0,%eax
}
     98a:	c9                   	leave  
     98b:	c3                   	ret    

0000098c <readln>:

char* readln(char *buf, int max, int fd)
{
     98c:	55                   	push   %ebp
     98d:	89 e5                	mov    %esp,%ebp
     98f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     992:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     999:	eb 45                	jmp    9e0 <readln+0x54>
    cc = read(fd, &c, 1);
     99b:	83 ec 04             	sub    $0x4,%esp
     99e:	6a 01                	push   $0x1
     9a0:	8d 45 ef             	lea    -0x11(%ebp),%eax
     9a3:	50                   	push   %eax
     9a4:	ff 75 10             	pushl  0x10(%ebp)
     9a7:	e8 7d fa ff ff       	call   429 <read>
     9ac:	83 c4 10             	add    $0x10,%esp
     9af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     9b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9b6:	7f 02                	jg     9ba <readln+0x2e>
      break;
     9b8:	eb 31                	jmp    9eb <readln+0x5f>
    buf[i++] = c;
     9ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9bd:	8d 50 01             	lea    0x1(%eax),%edx
     9c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
     9c3:	89 c2                	mov    %eax,%edx
     9c5:	8b 45 08             	mov    0x8(%ebp),%eax
     9c8:	01 c2                	add    %eax,%edx
     9ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     9ce:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     9d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     9d4:	3c 0a                	cmp    $0xa,%al
     9d6:	74 13                	je     9eb <readln+0x5f>
     9d8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     9dc:	3c 0d                	cmp    $0xd,%al
     9de:	74 0b                	je     9eb <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9e3:	83 c0 01             	add    $0x1,%eax
     9e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
     9e9:	7c b0                	jl     99b <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     9eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9ee:	8b 45 08             	mov    0x8(%ebp),%eax
     9f1:	01 d0                	add    %edx,%eax
     9f3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     9f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9f9:	c9                   	leave  
     9fa:	c3                   	ret    

000009fb <strncpy>:

char* strncpy(char* dest, char* src, int n) {
     9fb:	55                   	push   %ebp
     9fc:	89 e5                	mov    %esp,%ebp
     9fe:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     a01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     a08:	eb 19                	jmp    a23 <strncpy+0x28>
		dest[i] = src[i];
     a0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a0d:	8b 45 08             	mov    0x8(%ebp),%eax
     a10:	01 c2                	add    %eax,%edx
     a12:	8b 4d fc             	mov    -0x4(%ebp),%ecx
     a15:	8b 45 0c             	mov    0xc(%ebp),%eax
     a18:	01 c8                	add    %ecx,%eax
     a1a:	0f b6 00             	movzbl (%eax),%eax
     a1d:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     a1f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a26:	3b 45 10             	cmp    0x10(%ebp),%eax
     a29:	7d 0f                	jge    a3a <strncpy+0x3f>
     a2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
     a31:	01 d0                	add    %edx,%eax
     a33:	0f b6 00             	movzbl (%eax),%eax
     a36:	84 c0                	test   %al,%al
     a38:	75 d0                	jne    a0a <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
     a3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a3d:	c9                   	leave  
     a3e:	c3                   	ret    

00000a3f <trim>:

char* trim(char* orig) {
     a3f:	55                   	push   %ebp
     a40:	89 e5                	mov    %esp,%ebp
     a42:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
     a45:	8b 45 08             	mov    0x8(%ebp),%eax
     a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
     a4b:	8b 45 08             	mov    0x8(%ebp),%eax
     a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
     a51:	eb 04                	jmp    a57 <trim+0x18>
     a53:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a5a:	0f b6 00             	movzbl (%eax),%eax
     a5d:	0f be c0             	movsbl %al,%eax
     a60:	50                   	push   %eax
     a61:	e8 f4 fe ff ff       	call   95a <isspace>
     a66:	83 c4 04             	add    $0x4,%esp
     a69:	85 c0                	test   %eax,%eax
     a6b:	75 e6                	jne    a53 <trim+0x14>
	while (*tail) { tail++; }
     a6d:	eb 04                	jmp    a73 <trim+0x34>
     a6f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a76:	0f b6 00             	movzbl (%eax),%eax
     a79:	84 c0                	test   %al,%al
     a7b:	75 f2                	jne    a6f <trim+0x30>
	do { tail--; } while (isspace(*tail));
     a7d:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
     a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a84:	0f b6 00             	movzbl (%eax),%eax
     a87:	0f be c0             	movsbl %al,%eax
     a8a:	50                   	push   %eax
     a8b:	e8 ca fe ff ff       	call   95a <isspace>
     a90:	83 c4 04             	add    $0x4,%esp
     a93:	85 c0                	test   %eax,%eax
     a95:	75 e6                	jne    a7d <trim+0x3e>
	new = malloc(tail-head+2);
     a97:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a9d:	29 c2                	sub    %eax,%edx
     a9f:	89 d0                	mov    %edx,%eax
     aa1:	83 c0 02             	add    $0x2,%eax
     aa4:	83 ec 0c             	sub    $0xc,%esp
     aa7:	50                   	push   %eax
     aa8:	e8 ca fd ff ff       	call   877 <malloc>
     aad:	83 c4 10             	add    $0x10,%esp
     ab0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
     ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
     ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab9:	29 c2                	sub    %eax,%edx
     abb:	89 d0                	mov    %edx,%eax
     abd:	83 c0 01             	add    $0x1,%eax
     ac0:	83 ec 04             	sub    $0x4,%esp
     ac3:	50                   	push   %eax
     ac4:	ff 75 f4             	pushl  -0xc(%ebp)
     ac7:	ff 75 ec             	pushl  -0x14(%ebp)
     aca:	e8 2c ff ff ff       	call   9fb <strncpy>
     acf:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
     ad2:	8b 55 f0             	mov    -0x10(%ebp),%edx
     ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad8:	29 c2                	sub    %eax,%edx
     ada:	89 d0                	mov    %edx,%eax
     adc:	8d 50 01             	lea    0x1(%eax),%edx
     adf:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ae2:	01 d0                	add    %edx,%eax
     ae4:	c6 00 00             	movb   $0x0,(%eax)
	return new;
     ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
     aea:	c9                   	leave  
     aeb:	c3                   	ret    

00000aec <itoa>:

char *
itoa(int value)
{
     aec:	55                   	push   %ebp
     aed:	89 e5                	mov    %esp,%ebp
     aef:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
     af2:	8d 45 bf             	lea    -0x41(%ebp),%eax
     af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
     af8:	8b 45 08             	mov    0x8(%ebp),%eax
     afb:	c1 e8 1f             	shr    $0x1f,%eax
     afe:	0f b6 c0             	movzbl %al,%eax
     b01:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
     b04:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b08:	74 0a                	je     b14 <itoa+0x28>
    v = -value;
     b0a:	8b 45 08             	mov    0x8(%ebp),%eax
     b0d:	f7 d8                	neg    %eax
     b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b12:	eb 06                	jmp    b1a <itoa+0x2e>
  else
    v = (uint)value;
     b14:	8b 45 08             	mov    0x8(%ebp),%eax
     b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
     b1a:	eb 5b                	jmp    b77 <itoa+0x8b>
  {
    i = v % 10;
     b1c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     b1f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     b24:	89 c8                	mov    %ecx,%eax
     b26:	f7 e2                	mul    %edx
     b28:	c1 ea 03             	shr    $0x3,%edx
     b2b:	89 d0                	mov    %edx,%eax
     b2d:	c1 e0 02             	shl    $0x2,%eax
     b30:	01 d0                	add    %edx,%eax
     b32:	01 c0                	add    %eax,%eax
     b34:	29 c1                	sub    %eax,%ecx
     b36:	89 ca                	mov    %ecx,%edx
     b38:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
     b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b3e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     b43:	f7 e2                	mul    %edx
     b45:	89 d0                	mov    %edx,%eax
     b47:	c1 e8 03             	shr    $0x3,%eax
     b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
     b4d:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
     b51:	7f 13                	jg     b66 <itoa+0x7a>
      *tp++ = i+'0';
     b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b56:	8d 50 01             	lea    0x1(%eax),%edx
     b59:	89 55 f4             	mov    %edx,-0xc(%ebp)
     b5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     b5f:	83 c2 30             	add    $0x30,%edx
     b62:	88 10                	mov    %dl,(%eax)
     b64:	eb 11                	jmp    b77 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
     b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b69:	8d 50 01             	lea    0x1(%eax),%edx
     b6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
     b6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     b72:	83 c2 57             	add    $0x57,%edx
     b75:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
     b77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b7b:	75 9f                	jne    b1c <itoa+0x30>
     b7d:	8d 45 bf             	lea    -0x41(%ebp),%eax
     b80:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     b83:	74 97                	je     b1c <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
     b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b88:	8d 45 bf             	lea    -0x41(%ebp),%eax
     b8b:	29 c2                	sub    %eax,%edx
     b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b90:	01 d0                	add    %edx,%eax
     b92:	83 c0 01             	add    $0x1,%eax
     b95:	83 ec 0c             	sub    $0xc,%esp
     b98:	50                   	push   %eax
     b99:	e8 d9 fc ff ff       	call   877 <malloc>
     b9e:	83 c4 10             	add    $0x10,%esp
     ba1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
     ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
     baa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     bae:	74 0c                	je     bbc <itoa+0xd0>
    *sp++ = '-';
     bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bb3:	8d 50 01             	lea    0x1(%eax),%edx
     bb6:	89 55 ec             	mov    %edx,-0x14(%ebp)
     bb9:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
     bbc:	eb 15                	jmp    bd3 <itoa+0xe7>
    *sp++ = *--tp;
     bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bc1:	8d 50 01             	lea    0x1(%eax),%edx
     bc4:	89 55 ec             	mov    %edx,-0x14(%ebp)
     bc7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     bcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bce:	0f b6 12             	movzbl (%edx),%edx
     bd1:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
     bd3:	8d 45 bf             	lea    -0x41(%ebp),%eax
     bd6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     bd9:	77 e3                	ja     bbe <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
     bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bde:	c6 00 00             	movb   $0x0,(%eax)
  return string;
     be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
     be4:	c9                   	leave  
     be5:	c3                   	ret    

00000be6 <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
     be6:	55                   	push   %ebp
     be7:	89 e5                	mov    %esp,%ebp
     be9:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
     bef:	83 ec 08             	sub    $0x8,%esp
     bf2:	6a 00                	push   $0x0
     bf4:	ff 75 08             	pushl  0x8(%ebp)
     bf7:	e8 55 f8 ff ff       	call   451 <open>
     bfc:	83 c4 10             	add    $0x10,%esp
     bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     c02:	e9 22 01 00 00       	jmp    d29 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
     c07:	83 ec 08             	sub    $0x8,%esp
     c0a:	6a 3d                	push   $0x3d
     c0c:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     c12:	50                   	push   %eax
     c13:	e8 79 f6 ff ff       	call   291 <strchr>
     c18:	83 c4 10             	add    $0x10,%esp
     c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
     c1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c22:	0f 84 23 01 00 00    	je     d4b <parseEnvFile+0x165>
     c28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c2c:	0f 84 19 01 00 00    	je     d4b <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
     c32:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c35:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     c3b:	29 c2                	sub    %eax,%edx
     c3d:	89 d0                	mov    %edx,%eax
     c3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
     c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c45:	83 c0 01             	add    $0x1,%eax
     c48:	83 ec 0c             	sub    $0xc,%esp
     c4b:	50                   	push   %eax
     c4c:	e8 26 fc ff ff       	call   877 <malloc>
     c51:	83 c4 10             	add    $0x10,%esp
     c54:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
     c57:	83 ec 04             	sub    $0x4,%esp
     c5a:	ff 75 ec             	pushl  -0x14(%ebp)
     c5d:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     c63:	50                   	push   %eax
     c64:	ff 75 e8             	pushl  -0x18(%ebp)
     c67:	e8 8f fd ff ff       	call   9fb <strncpy>
     c6c:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
     c6f:	83 ec 0c             	sub    $0xc,%esp
     c72:	ff 75 e8             	pushl  -0x18(%ebp)
     c75:	e8 c5 fd ff ff       	call   a3f <trim>
     c7a:	83 c4 10             	add    $0x10,%esp
     c7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
     c80:	83 ec 0c             	sub    $0xc,%esp
     c83:	ff 75 e8             	pushl  -0x18(%ebp)
     c86:	e8 ab fa ff ff       	call   736 <free>
     c8b:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
     c8e:	83 ec 08             	sub    $0x8,%esp
     c91:	ff 75 0c             	pushl  0xc(%ebp)
     c94:	ff 75 e4             	pushl  -0x1c(%ebp)
     c97:	e8 c2 01 00 00       	call   e5e <addToEnvironment>
     c9c:	83 c4 10             	add    $0x10,%esp
     c9f:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
     ca2:	83 ec 0c             	sub    $0xc,%esp
     ca5:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     cab:	50                   	push   %eax
     cac:	e8 9f f5 ff ff       	call   250 <strlen>
     cb1:	83 c4 10             	add    $0x10,%esp
     cb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
     cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     cba:	2b 45 ec             	sub    -0x14(%ebp),%eax
     cbd:	83 ec 0c             	sub    $0xc,%esp
     cc0:	50                   	push   %eax
     cc1:	e8 b1 fb ff ff       	call   877 <malloc>
     cc6:	83 c4 10             	add    $0x10,%esp
     cc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
     ccc:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ccf:	2b 45 ec             	sub    -0x14(%ebp),%eax
     cd2:	8d 50 ff             	lea    -0x1(%eax),%edx
     cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cd8:	8d 48 01             	lea    0x1(%eax),%ecx
     cdb:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     ce1:	01 c8                	add    %ecx,%eax
     ce3:	83 ec 04             	sub    $0x4,%esp
     ce6:	52                   	push   %edx
     ce7:	50                   	push   %eax
     ce8:	ff 75 e8             	pushl  -0x18(%ebp)
     ceb:	e8 0b fd ff ff       	call   9fb <strncpy>
     cf0:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
     cf3:	83 ec 0c             	sub    $0xc,%esp
     cf6:	ff 75 e8             	pushl  -0x18(%ebp)
     cf9:	e8 41 fd ff ff       	call   a3f <trim>
     cfe:	83 c4 10             	add    $0x10,%esp
     d01:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
     d04:	83 ec 0c             	sub    $0xc,%esp
     d07:	ff 75 e8             	pushl  -0x18(%ebp)
     d0a:	e8 27 fa ff ff       	call   736 <free>
     d0f:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
     d12:	83 ec 04             	sub    $0x4,%esp
     d15:	ff 75 dc             	pushl  -0x24(%ebp)
     d18:	ff 75 0c             	pushl  0xc(%ebp)
     d1b:	ff 75 e4             	pushl  -0x1c(%ebp)
     d1e:	e8 b8 01 00 00       	call   edb <addValueToVariable>
     d23:	83 c4 10             	add    $0x10,%esp
     d26:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     d29:	83 ec 04             	sub    $0x4,%esp
     d2c:	ff 75 f4             	pushl  -0xc(%ebp)
     d2f:	68 00 04 00 00       	push   $0x400
     d34:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     d3a:	50                   	push   %eax
     d3b:	e8 4c fc ff ff       	call   98c <readln>
     d40:	83 c4 10             	add    $0x10,%esp
     d43:	85 c0                	test   %eax,%eax
     d45:	0f 85 bc fe ff ff    	jne    c07 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
     d4b:	83 ec 0c             	sub    $0xc,%esp
     d4e:	ff 75 f4             	pushl  -0xc(%ebp)
     d51:	e8 e3 f6 ff ff       	call   439 <close>
     d56:	83 c4 10             	add    $0x10,%esp
	return head;
     d59:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     d5c:	c9                   	leave  
     d5d:	c3                   	ret    

00000d5e <comp>:

int comp(const char* s1, const char* s2)
{
     d5e:	55                   	push   %ebp
     d5f:	89 e5                	mov    %esp,%ebp
     d61:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
     d64:	83 ec 08             	sub    $0x8,%esp
     d67:	ff 75 0c             	pushl  0xc(%ebp)
     d6a:	ff 75 08             	pushl  0x8(%ebp)
     d6d:	e8 9f f4 ff ff       	call   211 <strcmp>
     d72:	83 c4 10             	add    $0x10,%esp
     d75:	85 c0                	test   %eax,%eax
     d77:	0f 94 c0             	sete   %al
     d7a:	0f b6 c0             	movzbl %al,%eax
}
     d7d:	c9                   	leave  
     d7e:	c3                   	ret    

00000d7f <environLookup>:

variable* environLookup(const char* name, variable* head)
{
     d7f:	55                   	push   %ebp
     d80:	89 e5                	mov    %esp,%ebp
     d82:	83 ec 08             	sub    $0x8,%esp
  if (!name)
     d85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     d89:	75 07                	jne    d92 <environLookup+0x13>
    return NULL;
     d8b:	b8 00 00 00 00       	mov    $0x0,%eax
     d90:	eb 2f                	jmp    dc1 <environLookup+0x42>
  
  while (head)
     d92:	eb 24                	jmp    db8 <environLookup+0x39>
  {
    if (comp(name, head->name))
     d94:	8b 45 0c             	mov    0xc(%ebp),%eax
     d97:	83 ec 08             	sub    $0x8,%esp
     d9a:	50                   	push   %eax
     d9b:	ff 75 08             	pushl  0x8(%ebp)
     d9e:	e8 bb ff ff ff       	call   d5e <comp>
     da3:	83 c4 10             	add    $0x10,%esp
     da6:	85 c0                	test   %eax,%eax
     da8:	74 02                	je     dac <environLookup+0x2d>
      break;
     daa:	eb 12                	jmp    dbe <environLookup+0x3f>
    head = head->next;
     dac:	8b 45 0c             	mov    0xc(%ebp),%eax
     daf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     db5:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
     db8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     dbc:	75 d6                	jne    d94 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
     dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     dc1:	c9                   	leave  
     dc2:	c3                   	ret    

00000dc3 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
     dc3:	55                   	push   %ebp
     dc4:	89 e5                	mov    %esp,%ebp
     dc6:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
     dc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     dcd:	75 0a                	jne    dd9 <removeFromEnvironment+0x16>
    return NULL;
     dcf:	b8 00 00 00 00       	mov    $0x0,%eax
     dd4:	e9 83 00 00 00       	jmp    e5c <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
     dd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ddd:	74 0a                	je     de9 <removeFromEnvironment+0x26>
     ddf:	8b 45 08             	mov    0x8(%ebp),%eax
     de2:	0f b6 00             	movzbl (%eax),%eax
     de5:	84 c0                	test   %al,%al
     de7:	75 05                	jne    dee <removeFromEnvironment+0x2b>
    return head;
     de9:	8b 45 0c             	mov    0xc(%ebp),%eax
     dec:	eb 6e                	jmp    e5c <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
     dee:	8b 45 0c             	mov    0xc(%ebp),%eax
     df1:	83 ec 08             	sub    $0x8,%esp
     df4:	ff 75 08             	pushl  0x8(%ebp)
     df7:	50                   	push   %eax
     df8:	e8 61 ff ff ff       	call   d5e <comp>
     dfd:	83 c4 10             	add    $0x10,%esp
     e00:	85 c0                	test   %eax,%eax
     e02:	74 34                	je     e38 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
     e04:	8b 45 0c             	mov    0xc(%ebp),%eax
     e07:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     e0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
     e10:	8b 45 0c             	mov    0xc(%ebp),%eax
     e13:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     e19:	83 ec 0c             	sub    $0xc,%esp
     e1c:	50                   	push   %eax
     e1d:	e8 74 01 00 00       	call   f96 <freeVarval>
     e22:	83 c4 10             	add    $0x10,%esp
    free(head);
     e25:	83 ec 0c             	sub    $0xc,%esp
     e28:	ff 75 0c             	pushl  0xc(%ebp)
     e2b:	e8 06 f9 ff ff       	call   736 <free>
     e30:	83 c4 10             	add    $0x10,%esp
    return tmp;
     e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e36:	eb 24                	jmp    e5c <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
     e38:	8b 45 0c             	mov    0xc(%ebp),%eax
     e3b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     e41:	83 ec 08             	sub    $0x8,%esp
     e44:	50                   	push   %eax
     e45:	ff 75 08             	pushl  0x8(%ebp)
     e48:	e8 76 ff ff ff       	call   dc3 <removeFromEnvironment>
     e4d:	83 c4 10             	add    $0x10,%esp
     e50:	8b 55 0c             	mov    0xc(%ebp),%edx
     e53:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
     e59:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     e5c:	c9                   	leave  
     e5d:	c3                   	ret    

00000e5e <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
     e5e:	55                   	push   %ebp
     e5f:	89 e5                	mov    %esp,%ebp
     e61:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
     e64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e68:	75 05                	jne    e6f <addToEnvironment+0x11>
		return head;
     e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
     e6d:	eb 6a                	jmp    ed9 <addToEnvironment+0x7b>
	if (head == NULL) {
     e6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     e73:	75 40                	jne    eb5 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
     e75:	83 ec 0c             	sub    $0xc,%esp
     e78:	68 88 00 00 00       	push   $0x88
     e7d:	e8 f5 f9 ff ff       	call   877 <malloc>
     e82:	83 c4 10             	add    $0x10,%esp
     e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
     e88:	8b 45 08             	mov    0x8(%ebp),%eax
     e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
     e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e91:	83 ec 08             	sub    $0x8,%esp
     e94:	ff 75 f0             	pushl  -0x10(%ebp)
     e97:	50                   	push   %eax
     e98:	e8 44 f3 ff ff       	call   1e1 <strcpy>
     e9d:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
     ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ea3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
     eaa:	00 00 00 
		head = newVar;
     ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eb0:	89 45 0c             	mov    %eax,0xc(%ebp)
     eb3:	eb 21                	jmp    ed6 <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
     eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     ebe:	83 ec 08             	sub    $0x8,%esp
     ec1:	50                   	push   %eax
     ec2:	ff 75 08             	pushl  0x8(%ebp)
     ec5:	e8 94 ff ff ff       	call   e5e <addToEnvironment>
     eca:	83 c4 10             	add    $0x10,%esp
     ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
     ed0:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
     ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     ed9:	c9                   	leave  
     eda:	c3                   	ret    

00000edb <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
     edb:	55                   	push   %ebp
     edc:	89 e5                	mov    %esp,%ebp
     ede:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
     ee1:	83 ec 08             	sub    $0x8,%esp
     ee4:	ff 75 0c             	pushl  0xc(%ebp)
     ee7:	ff 75 08             	pushl  0x8(%ebp)
     eea:	e8 90 fe ff ff       	call   d7f <environLookup>
     eef:	83 c4 10             	add    $0x10,%esp
     ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
     ef5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ef9:	75 05                	jne    f00 <addValueToVariable+0x25>
		return head;
     efb:	8b 45 0c             	mov    0xc(%ebp),%eax
     efe:	eb 4c                	jmp    f4c <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
     f00:	83 ec 0c             	sub    $0xc,%esp
     f03:	68 04 04 00 00       	push   $0x404
     f08:	e8 6a f9 ff ff       	call   877 <malloc>
     f0d:	83 c4 10             	add    $0x10,%esp
     f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
     f13:	8b 45 10             	mov    0x10(%ebp),%eax
     f16:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
     f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f1c:	83 ec 08             	sub    $0x8,%esp
     f1f:	ff 75 ec             	pushl  -0x14(%ebp)
     f22:	50                   	push   %eax
     f23:	e8 b9 f2 ff ff       	call   1e1 <strcpy>
     f28:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
     f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f2e:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
     f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f37:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
     f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f40:	8b 55 f0             	mov    -0x10(%ebp),%edx
     f43:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
     f49:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     f4c:	c9                   	leave  
     f4d:	c3                   	ret    

00000f4e <freeEnvironment>:

void freeEnvironment(variable* head)
{
     f4e:	55                   	push   %ebp
     f4f:	89 e5                	mov    %esp,%ebp
     f51:	83 ec 08             	sub    $0x8,%esp
  if (!head)
     f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f58:	75 02                	jne    f5c <freeEnvironment+0xe>
    return;  
     f5a:	eb 38                	jmp    f94 <freeEnvironment+0x46>
  freeEnvironment(head->next);
     f5c:	8b 45 08             	mov    0x8(%ebp),%eax
     f5f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     f65:	83 ec 0c             	sub    $0xc,%esp
     f68:	50                   	push   %eax
     f69:	e8 e0 ff ff ff       	call   f4e <freeEnvironment>
     f6e:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
     f71:	8b 45 08             	mov    0x8(%ebp),%eax
     f74:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     f7a:	83 ec 0c             	sub    $0xc,%esp
     f7d:	50                   	push   %eax
     f7e:	e8 13 00 00 00       	call   f96 <freeVarval>
     f83:	83 c4 10             	add    $0x10,%esp
  free(head);
     f86:	83 ec 0c             	sub    $0xc,%esp
     f89:	ff 75 08             	pushl  0x8(%ebp)
     f8c:	e8 a5 f7 ff ff       	call   736 <free>
     f91:	83 c4 10             	add    $0x10,%esp
}
     f94:	c9                   	leave  
     f95:	c3                   	ret    

00000f96 <freeVarval>:

void freeVarval(varval* head)
{
     f96:	55                   	push   %ebp
     f97:	89 e5                	mov    %esp,%ebp
     f99:	83 ec 08             	sub    $0x8,%esp
  if (!head)
     f9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fa0:	75 02                	jne    fa4 <freeVarval+0xe>
    return;  
     fa2:	eb 23                	jmp    fc7 <freeVarval+0x31>
  freeVarval(head->next);
     fa4:	8b 45 08             	mov    0x8(%ebp),%eax
     fa7:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
     fad:	83 ec 0c             	sub    $0xc,%esp
     fb0:	50                   	push   %eax
     fb1:	e8 e0 ff ff ff       	call   f96 <freeVarval>
     fb6:	83 c4 10             	add    $0x10,%esp
  free(head);
     fb9:	83 ec 0c             	sub    $0xc,%esp
     fbc:	ff 75 08             	pushl  0x8(%ebp)
     fbf:	e8 72 f7 ff ff       	call   736 <free>
     fc4:	83 c4 10             	add    $0x10,%esp
}
     fc7:	c9                   	leave  
     fc8:	c3                   	ret    

00000fc9 <getPaths>:

varval* getPaths(char* paths, varval* head) {
     fc9:	55                   	push   %ebp
     fca:	89 e5                	mov    %esp,%ebp
     fcc:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
     fcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fd3:	75 08                	jne    fdd <getPaths+0x14>
		return head;
     fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
     fd8:	e9 e7 00 00 00       	jmp    10c4 <getPaths+0xfb>
	if (head == NULL) {
     fdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     fe1:	0f 85 b9 00 00 00    	jne    10a0 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
     fe7:	83 ec 08             	sub    $0x8,%esp
     fea:	6a 3a                	push   $0x3a
     fec:	ff 75 08             	pushl  0x8(%ebp)
     fef:	e8 9d f2 ff ff       	call   291 <strchr>
     ff4:	83 c4 10             	add    $0x10,%esp
     ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
     ffa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ffe:	75 56                	jne    1056 <getPaths+0x8d>
			pathLen = strlen(paths);
    1000:	83 ec 0c             	sub    $0xc,%esp
    1003:	ff 75 08             	pushl  0x8(%ebp)
    1006:	e8 45 f2 ff ff       	call   250 <strlen>
    100b:	83 c4 10             	add    $0x10,%esp
    100e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
    1011:	83 ec 0c             	sub    $0xc,%esp
    1014:	68 04 04 00 00       	push   $0x404
    1019:	e8 59 f8 ff ff       	call   877 <malloc>
    101e:	83 c4 10             	add    $0x10,%esp
    1021:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
    1024:	8b 45 0c             	mov    0xc(%ebp),%eax
    1027:	83 ec 04             	sub    $0x4,%esp
    102a:	ff 75 f0             	pushl  -0x10(%ebp)
    102d:	ff 75 08             	pushl  0x8(%ebp)
    1030:	50                   	push   %eax
    1031:	e8 c5 f9 ff ff       	call   9fb <strncpy>
    1036:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
    1039:	8b 55 0c             	mov    0xc(%ebp),%edx
    103c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    103f:	01 d0                	add    %edx,%eax
    1041:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
    1044:	8b 45 0c             	mov    0xc(%ebp),%eax
    1047:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
    104e:	00 00 00 
			return head;
    1051:	8b 45 0c             	mov    0xc(%ebp),%eax
    1054:	eb 6e                	jmp    10c4 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
    1056:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1059:	8b 45 08             	mov    0x8(%ebp),%eax
    105c:	29 c2                	sub    %eax,%edx
    105e:	89 d0                	mov    %edx,%eax
    1060:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
    1063:	83 ec 0c             	sub    $0xc,%esp
    1066:	68 04 04 00 00       	push   $0x404
    106b:	e8 07 f8 ff ff       	call   877 <malloc>
    1070:	83 c4 10             	add    $0x10,%esp
    1073:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
    1076:	8b 45 0c             	mov    0xc(%ebp),%eax
    1079:	83 ec 04             	sub    $0x4,%esp
    107c:	ff 75 f0             	pushl  -0x10(%ebp)
    107f:	ff 75 08             	pushl  0x8(%ebp)
    1082:	50                   	push   %eax
    1083:	e8 73 f9 ff ff       	call   9fb <strncpy>
    1088:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
    108b:	8b 55 0c             	mov    0xc(%ebp),%edx
    108e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1091:	01 d0                	add    %edx,%eax
    1093:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
    1096:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1099:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
    109c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
    10a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a3:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
    10a9:	83 ec 08             	sub    $0x8,%esp
    10ac:	50                   	push   %eax
    10ad:	ff 75 08             	pushl  0x8(%ebp)
    10b0:	e8 14 ff ff ff       	call   fc9 <getPaths>
    10b5:	83 c4 10             	add    $0x10,%esp
    10b8:	8b 55 0c             	mov    0xc(%ebp),%edx
    10bb:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
    10c1:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    10c4:	c9                   	leave  
    10c5:	c3                   	ret    
