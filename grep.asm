
_grep:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
       6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
       d:	e9 ad 00 00 00       	jmp    bf <grep+0xbf>
    m += n;
      12:	8b 45 ec             	mov    -0x14(%ebp),%eax
      15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
      18:	c7 45 f0 80 17 00 00 	movl   $0x1780,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
      1f:	eb 4a                	jmp    6b <grep+0x6b>
      *q = 0;
      21:	8b 45 e8             	mov    -0x18(%ebp),%eax
      24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
      27:	83 ec 08             	sub    $0x8,%esp
      2a:	ff 75 f0             	pushl  -0x10(%ebp)
      2d:	ff 75 08             	pushl  0x8(%ebp)
      30:	e8 9a 01 00 00       	call   1cf <match>
      35:	83 c4 10             	add    $0x10,%esp
      38:	85 c0                	test   %eax,%eax
      3a:	74 26                	je     62 <grep+0x62>
        *q = '\n';
      3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
      3f:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
      42:	8b 45 e8             	mov    -0x18(%ebp),%eax
      45:	83 c0 01             	add    $0x1,%eax
      48:	89 c2                	mov    %eax,%edx
      4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      4d:	29 c2                	sub    %eax,%edx
      4f:	89 d0                	mov    %edx,%eax
      51:	83 ec 04             	sub    $0x4,%esp
      54:	50                   	push   %eax
      55:	ff 75 f0             	pushl  -0x10(%ebp)
      58:	6a 01                	push   $0x1
      5a:	e8 41 05 00 00       	call   5a0 <write>
      5f:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
      62:	8b 45 e8             	mov    -0x18(%ebp),%eax
      65:	83 c0 01             	add    $0x1,%eax
      68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      6b:	83 ec 08             	sub    $0x8,%esp
      6e:	6a 0a                	push   $0xa
      70:	ff 75 f0             	pushl  -0x10(%ebp)
      73:	e8 88 03 00 00       	call   400 <strchr>
      78:	83 c4 10             	add    $0x10,%esp
      7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
      82:	75 9d                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
      84:	81 7d f0 80 17 00 00 	cmpl   $0x1780,-0x10(%ebp)
      8b:	75 07                	jne    94 <grep+0x94>
      m = 0;
      8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
      94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      98:	7e 25                	jle    bf <grep+0xbf>
      m -= p - buf;
      9a:	ba 80 17 00 00       	mov    $0x1780,%edx
      9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a2:	29 c2                	sub    %eax,%edx
      a4:	89 d0                	mov    %edx,%eax
      a6:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
      a9:	83 ec 04             	sub    $0x4,%esp
      ac:	ff 75 f4             	pushl  -0xc(%ebp)
      af:	ff 75 f0             	pushl  -0x10(%ebp)
      b2:	68 80 17 00 00       	push   $0x1780
      b7:	e8 7f 04 00 00       	call   53b <memmove>
      bc:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
      bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
      c2:	ba 00 04 00 00       	mov    $0x400,%edx
      c7:	29 c2                	sub    %eax,%edx
      c9:	89 d0                	mov    %edx,%eax
      cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
      ce:	81 c2 80 17 00 00    	add    $0x1780,%edx
      d4:	83 ec 04             	sub    $0x4,%esp
      d7:	50                   	push   %eax
      d8:	52                   	push   %edx
      d9:	ff 75 0c             	pushl  0xc(%ebp)
      dc:	e8 b7 04 00 00       	call   598 <read>
      e1:	83 c4 10             	add    $0x10,%esp
      e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      eb:	0f 8f 21 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
      f1:	c9                   	leave  
      f2:	c3                   	ret    

000000f3 <main>:

int
main(int argc, char *argv[])
{
      f3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
      f7:	83 e4 f0             	and    $0xfffffff0,%esp
      fa:	ff 71 fc             	pushl  -0x4(%ecx)
      fd:	55                   	push   %ebp
      fe:	89 e5                	mov    %esp,%ebp
     100:	53                   	push   %ebx
     101:	51                   	push   %ecx
     102:	83 ec 10             	sub    $0x10,%esp
     105:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
     107:	83 3b 01             	cmpl   $0x1,(%ebx)
     10a:	7f 17                	jg     123 <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
     10c:	83 ec 08             	sub    $0x8,%esp
     10f:	68 38 12 00 00       	push   $0x1238
     114:	6a 02                	push   $0x2
     116:	e8 fa 05 00 00       	call   715 <printf>
     11b:	83 c4 10             	add    $0x10,%esp
    exit();
     11e:	e8 5d 04 00 00       	call   580 <exit>
  }
  pattern = argv[1];
     123:	8b 43 04             	mov    0x4(%ebx),%eax
     126:	8b 40 04             	mov    0x4(%eax),%eax
     129:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
     12c:	83 3b 02             	cmpl   $0x2,(%ebx)
     12f:	7f 15                	jg     146 <main+0x53>
    grep(pattern, 0);
     131:	83 ec 08             	sub    $0x8,%esp
     134:	6a 00                	push   $0x0
     136:	ff 75 f0             	pushl  -0x10(%ebp)
     139:	e8 c2 fe ff ff       	call   0 <grep>
     13e:	83 c4 10             	add    $0x10,%esp
    exit();
     141:	e8 3a 04 00 00       	call   580 <exit>
  }

  for(i = 2; i < argc; i++){
     146:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
     14d:	eb 74                	jmp    1c3 <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
     14f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     152:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     159:	8b 43 04             	mov    0x4(%ebx),%eax
     15c:	01 d0                	add    %edx,%eax
     15e:	8b 00                	mov    (%eax),%eax
     160:	83 ec 08             	sub    $0x8,%esp
     163:	6a 00                	push   $0x0
     165:	50                   	push   %eax
     166:	e8 55 04 00 00       	call   5c0 <open>
     16b:	83 c4 10             	add    $0x10,%esp
     16e:	89 45 ec             	mov    %eax,-0x14(%ebp)
     171:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     175:	79 29                	jns    1a0 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
     177:	8b 45 f4             	mov    -0xc(%ebp),%eax
     17a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     181:	8b 43 04             	mov    0x4(%ebx),%eax
     184:	01 d0                	add    %edx,%eax
     186:	8b 00                	mov    (%eax),%eax
     188:	83 ec 04             	sub    $0x4,%esp
     18b:	50                   	push   %eax
     18c:	68 58 12 00 00       	push   $0x1258
     191:	6a 01                	push   $0x1
     193:	e8 7d 05 00 00       	call   715 <printf>
     198:	83 c4 10             	add    $0x10,%esp
      exit();
     19b:	e8 e0 03 00 00       	call   580 <exit>
    }
    grep(pattern, fd);
     1a0:	83 ec 08             	sub    $0x8,%esp
     1a3:	ff 75 ec             	pushl  -0x14(%ebp)
     1a6:	ff 75 f0             	pushl  -0x10(%ebp)
     1a9:	e8 52 fe ff ff       	call   0 <grep>
     1ae:	83 c4 10             	add    $0x10,%esp
    close(fd);
     1b1:	83 ec 0c             	sub    $0xc,%esp
     1b4:	ff 75 ec             	pushl  -0x14(%ebp)
     1b7:	e8 ec 03 00 00       	call   5a8 <close>
     1bc:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
     1bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1c6:	3b 03                	cmp    (%ebx),%eax
     1c8:	7c 85                	jl     14f <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
     1ca:	e8 b1 03 00 00       	call   580 <exit>

000001cf <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
     1cf:	55                   	push   %ebp
     1d0:	89 e5                	mov    %esp,%ebp
     1d2:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
     1d5:	8b 45 08             	mov    0x8(%ebp),%eax
     1d8:	0f b6 00             	movzbl (%eax),%eax
     1db:	3c 5e                	cmp    $0x5e,%al
     1dd:	75 17                	jne    1f6 <match+0x27>
    return matchhere(re+1, text);
     1df:	8b 45 08             	mov    0x8(%ebp),%eax
     1e2:	83 c0 01             	add    $0x1,%eax
     1e5:	83 ec 08             	sub    $0x8,%esp
     1e8:	ff 75 0c             	pushl  0xc(%ebp)
     1eb:	50                   	push   %eax
     1ec:	e8 38 00 00 00       	call   229 <matchhere>
     1f1:	83 c4 10             	add    $0x10,%esp
     1f4:	eb 31                	jmp    227 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
     1f6:	83 ec 08             	sub    $0x8,%esp
     1f9:	ff 75 0c             	pushl  0xc(%ebp)
     1fc:	ff 75 08             	pushl  0x8(%ebp)
     1ff:	e8 25 00 00 00       	call   229 <matchhere>
     204:	83 c4 10             	add    $0x10,%esp
     207:	85 c0                	test   %eax,%eax
     209:	74 07                	je     212 <match+0x43>
      return 1;
     20b:	b8 01 00 00 00       	mov    $0x1,%eax
     210:	eb 15                	jmp    227 <match+0x58>
  }while(*text++ != '\0');
     212:	8b 45 0c             	mov    0xc(%ebp),%eax
     215:	8d 50 01             	lea    0x1(%eax),%edx
     218:	89 55 0c             	mov    %edx,0xc(%ebp)
     21b:	0f b6 00             	movzbl (%eax),%eax
     21e:	84 c0                	test   %al,%al
     220:	75 d4                	jne    1f6 <match+0x27>
  return 0;
     222:	b8 00 00 00 00       	mov    $0x0,%eax
}
     227:	c9                   	leave  
     228:	c3                   	ret    

00000229 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
     229:	55                   	push   %ebp
     22a:	89 e5                	mov    %esp,%ebp
     22c:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
     22f:	8b 45 08             	mov    0x8(%ebp),%eax
     232:	0f b6 00             	movzbl (%eax),%eax
     235:	84 c0                	test   %al,%al
     237:	75 0a                	jne    243 <matchhere+0x1a>
    return 1;
     239:	b8 01 00 00 00       	mov    $0x1,%eax
     23e:	e9 99 00 00 00       	jmp    2dc <matchhere+0xb3>
  if(re[1] == '*')
     243:	8b 45 08             	mov    0x8(%ebp),%eax
     246:	83 c0 01             	add    $0x1,%eax
     249:	0f b6 00             	movzbl (%eax),%eax
     24c:	3c 2a                	cmp    $0x2a,%al
     24e:	75 21                	jne    271 <matchhere+0x48>
    return matchstar(re[0], re+2, text);
     250:	8b 45 08             	mov    0x8(%ebp),%eax
     253:	8d 50 02             	lea    0x2(%eax),%edx
     256:	8b 45 08             	mov    0x8(%ebp),%eax
     259:	0f b6 00             	movzbl (%eax),%eax
     25c:	0f be c0             	movsbl %al,%eax
     25f:	83 ec 04             	sub    $0x4,%esp
     262:	ff 75 0c             	pushl  0xc(%ebp)
     265:	52                   	push   %edx
     266:	50                   	push   %eax
     267:	e8 72 00 00 00       	call   2de <matchstar>
     26c:	83 c4 10             	add    $0x10,%esp
     26f:	eb 6b                	jmp    2dc <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
     271:	8b 45 08             	mov    0x8(%ebp),%eax
     274:	0f b6 00             	movzbl (%eax),%eax
     277:	3c 24                	cmp    $0x24,%al
     279:	75 1d                	jne    298 <matchhere+0x6f>
     27b:	8b 45 08             	mov    0x8(%ebp),%eax
     27e:	83 c0 01             	add    $0x1,%eax
     281:	0f b6 00             	movzbl (%eax),%eax
     284:	84 c0                	test   %al,%al
     286:	75 10                	jne    298 <matchhere+0x6f>
    return *text == '\0';
     288:	8b 45 0c             	mov    0xc(%ebp),%eax
     28b:	0f b6 00             	movzbl (%eax),%eax
     28e:	84 c0                	test   %al,%al
     290:	0f 94 c0             	sete   %al
     293:	0f b6 c0             	movzbl %al,%eax
     296:	eb 44                	jmp    2dc <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
     298:	8b 45 0c             	mov    0xc(%ebp),%eax
     29b:	0f b6 00             	movzbl (%eax),%eax
     29e:	84 c0                	test   %al,%al
     2a0:	74 35                	je     2d7 <matchhere+0xae>
     2a2:	8b 45 08             	mov    0x8(%ebp),%eax
     2a5:	0f b6 00             	movzbl (%eax),%eax
     2a8:	3c 2e                	cmp    $0x2e,%al
     2aa:	74 10                	je     2bc <matchhere+0x93>
     2ac:	8b 45 08             	mov    0x8(%ebp),%eax
     2af:	0f b6 10             	movzbl (%eax),%edx
     2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
     2b5:	0f b6 00             	movzbl (%eax),%eax
     2b8:	38 c2                	cmp    %al,%dl
     2ba:	75 1b                	jne    2d7 <matchhere+0xae>
    return matchhere(re+1, text+1);
     2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
     2bf:	8d 50 01             	lea    0x1(%eax),%edx
     2c2:	8b 45 08             	mov    0x8(%ebp),%eax
     2c5:	83 c0 01             	add    $0x1,%eax
     2c8:	83 ec 08             	sub    $0x8,%esp
     2cb:	52                   	push   %edx
     2cc:	50                   	push   %eax
     2cd:	e8 57 ff ff ff       	call   229 <matchhere>
     2d2:	83 c4 10             	add    $0x10,%esp
     2d5:	eb 05                	jmp    2dc <matchhere+0xb3>
  return 0;
     2d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2dc:	c9                   	leave  
     2dd:	c3                   	ret    

000002de <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
     2de:	55                   	push   %ebp
     2df:	89 e5                	mov    %esp,%ebp
     2e1:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
     2e4:	83 ec 08             	sub    $0x8,%esp
     2e7:	ff 75 10             	pushl  0x10(%ebp)
     2ea:	ff 75 0c             	pushl  0xc(%ebp)
     2ed:	e8 37 ff ff ff       	call   229 <matchhere>
     2f2:	83 c4 10             	add    $0x10,%esp
     2f5:	85 c0                	test   %eax,%eax
     2f7:	74 07                	je     300 <matchstar+0x22>
      return 1;
     2f9:	b8 01 00 00 00       	mov    $0x1,%eax
     2fe:	eb 29                	jmp    329 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
     300:	8b 45 10             	mov    0x10(%ebp),%eax
     303:	0f b6 00             	movzbl (%eax),%eax
     306:	84 c0                	test   %al,%al
     308:	74 1a                	je     324 <matchstar+0x46>
     30a:	8b 45 10             	mov    0x10(%ebp),%eax
     30d:	8d 50 01             	lea    0x1(%eax),%edx
     310:	89 55 10             	mov    %edx,0x10(%ebp)
     313:	0f b6 00             	movzbl (%eax),%eax
     316:	0f be c0             	movsbl %al,%eax
     319:	3b 45 08             	cmp    0x8(%ebp),%eax
     31c:	74 c6                	je     2e4 <matchstar+0x6>
     31e:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
     322:	74 c0                	je     2e4 <matchstar+0x6>
  return 0;
     324:	b8 00 00 00 00       	mov    $0x0,%eax
}
     329:	c9                   	leave  
     32a:	c3                   	ret    

0000032b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     32b:	55                   	push   %ebp
     32c:	89 e5                	mov    %esp,%ebp
     32e:	57                   	push   %edi
     32f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     330:	8b 4d 08             	mov    0x8(%ebp),%ecx
     333:	8b 55 10             	mov    0x10(%ebp),%edx
     336:	8b 45 0c             	mov    0xc(%ebp),%eax
     339:	89 cb                	mov    %ecx,%ebx
     33b:	89 df                	mov    %ebx,%edi
     33d:	89 d1                	mov    %edx,%ecx
     33f:	fc                   	cld    
     340:	f3 aa                	rep stos %al,%es:(%edi)
     342:	89 ca                	mov    %ecx,%edx
     344:	89 fb                	mov    %edi,%ebx
     346:	89 5d 08             	mov    %ebx,0x8(%ebp)
     349:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     34c:	5b                   	pop    %ebx
     34d:	5f                   	pop    %edi
     34e:	5d                   	pop    %ebp
     34f:	c3                   	ret    

00000350 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     350:	55                   	push   %ebp
     351:	89 e5                	mov    %esp,%ebp
     353:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     356:	8b 45 08             	mov    0x8(%ebp),%eax
     359:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     35c:	90                   	nop
     35d:	8b 45 08             	mov    0x8(%ebp),%eax
     360:	8d 50 01             	lea    0x1(%eax),%edx
     363:	89 55 08             	mov    %edx,0x8(%ebp)
     366:	8b 55 0c             	mov    0xc(%ebp),%edx
     369:	8d 4a 01             	lea    0x1(%edx),%ecx
     36c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     36f:	0f b6 12             	movzbl (%edx),%edx
     372:	88 10                	mov    %dl,(%eax)
     374:	0f b6 00             	movzbl (%eax),%eax
     377:	84 c0                	test   %al,%al
     379:	75 e2                	jne    35d <strcpy+0xd>
    ;
  return os;
     37b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     37e:	c9                   	leave  
     37f:	c3                   	ret    

00000380 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     383:	eb 08                	jmp    38d <strcmp+0xd>
    p++, q++;
     385:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     389:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     38d:	8b 45 08             	mov    0x8(%ebp),%eax
     390:	0f b6 00             	movzbl (%eax),%eax
     393:	84 c0                	test   %al,%al
     395:	74 10                	je     3a7 <strcmp+0x27>
     397:	8b 45 08             	mov    0x8(%ebp),%eax
     39a:	0f b6 10             	movzbl (%eax),%edx
     39d:	8b 45 0c             	mov    0xc(%ebp),%eax
     3a0:	0f b6 00             	movzbl (%eax),%eax
     3a3:	38 c2                	cmp    %al,%dl
     3a5:	74 de                	je     385 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     3a7:	8b 45 08             	mov    0x8(%ebp),%eax
     3aa:	0f b6 00             	movzbl (%eax),%eax
     3ad:	0f b6 d0             	movzbl %al,%edx
     3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
     3b3:	0f b6 00             	movzbl (%eax),%eax
     3b6:	0f b6 c0             	movzbl %al,%eax
     3b9:	29 c2                	sub    %eax,%edx
     3bb:	89 d0                	mov    %edx,%eax
}
     3bd:	5d                   	pop    %ebp
     3be:	c3                   	ret    

000003bf <strlen>:

uint
strlen(char *s)
{
     3bf:	55                   	push   %ebp
     3c0:	89 e5                	mov    %esp,%ebp
     3c2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     3c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     3cc:	eb 04                	jmp    3d2 <strlen+0x13>
     3ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     3d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
     3d5:	8b 45 08             	mov    0x8(%ebp),%eax
     3d8:	01 d0                	add    %edx,%eax
     3da:	0f b6 00             	movzbl (%eax),%eax
     3dd:	84 c0                	test   %al,%al
     3df:	75 ed                	jne    3ce <strlen+0xf>
    ;
  return n;
     3e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3e4:	c9                   	leave  
     3e5:	c3                   	ret    

000003e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     3e6:	55                   	push   %ebp
     3e7:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     3e9:	8b 45 10             	mov    0x10(%ebp),%eax
     3ec:	50                   	push   %eax
     3ed:	ff 75 0c             	pushl  0xc(%ebp)
     3f0:	ff 75 08             	pushl  0x8(%ebp)
     3f3:	e8 33 ff ff ff       	call   32b <stosb>
     3f8:	83 c4 0c             	add    $0xc,%esp
  return dst;
     3fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
     3fe:	c9                   	leave  
     3ff:	c3                   	ret    

00000400 <strchr>:

char*
strchr(const char *s, char c)
{
     400:	55                   	push   %ebp
     401:	89 e5                	mov    %esp,%ebp
     403:	83 ec 04             	sub    $0x4,%esp
     406:	8b 45 0c             	mov    0xc(%ebp),%eax
     409:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     40c:	eb 14                	jmp    422 <strchr+0x22>
    if(*s == c)
     40e:	8b 45 08             	mov    0x8(%ebp),%eax
     411:	0f b6 00             	movzbl (%eax),%eax
     414:	3a 45 fc             	cmp    -0x4(%ebp),%al
     417:	75 05                	jne    41e <strchr+0x1e>
      return (char*)s;
     419:	8b 45 08             	mov    0x8(%ebp),%eax
     41c:	eb 13                	jmp    431 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     41e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     422:	8b 45 08             	mov    0x8(%ebp),%eax
     425:	0f b6 00             	movzbl (%eax),%eax
     428:	84 c0                	test   %al,%al
     42a:	75 e2                	jne    40e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     42c:	b8 00 00 00 00       	mov    $0x0,%eax
}
     431:	c9                   	leave  
     432:	c3                   	ret    

00000433 <gets>:

char*
gets(char *buf, int max)
{
     433:	55                   	push   %ebp
     434:	89 e5                	mov    %esp,%ebp
     436:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     440:	eb 44                	jmp    486 <gets+0x53>
    cc = read(0, &c, 1);
     442:	83 ec 04             	sub    $0x4,%esp
     445:	6a 01                	push   $0x1
     447:	8d 45 ef             	lea    -0x11(%ebp),%eax
     44a:	50                   	push   %eax
     44b:	6a 00                	push   $0x0
     44d:	e8 46 01 00 00       	call   598 <read>
     452:	83 c4 10             	add    $0x10,%esp
     455:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     458:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     45c:	7f 02                	jg     460 <gets+0x2d>
      break;
     45e:	eb 31                	jmp    491 <gets+0x5e>
    buf[i++] = c;
     460:	8b 45 f4             	mov    -0xc(%ebp),%eax
     463:	8d 50 01             	lea    0x1(%eax),%edx
     466:	89 55 f4             	mov    %edx,-0xc(%ebp)
     469:	89 c2                	mov    %eax,%edx
     46b:	8b 45 08             	mov    0x8(%ebp),%eax
     46e:	01 c2                	add    %eax,%edx
     470:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     474:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     476:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     47a:	3c 0a                	cmp    $0xa,%al
     47c:	74 13                	je     491 <gets+0x5e>
     47e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     482:	3c 0d                	cmp    $0xd,%al
     484:	74 0b                	je     491 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     486:	8b 45 f4             	mov    -0xc(%ebp),%eax
     489:	83 c0 01             	add    $0x1,%eax
     48c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     48f:	7c b1                	jl     442 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     491:	8b 55 f4             	mov    -0xc(%ebp),%edx
     494:	8b 45 08             	mov    0x8(%ebp),%eax
     497:	01 d0                	add    %edx,%eax
     499:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     49c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     49f:	c9                   	leave  
     4a0:	c3                   	ret    

000004a1 <stat>:

int
stat(char *n, struct stat *st)
{
     4a1:	55                   	push   %ebp
     4a2:	89 e5                	mov    %esp,%ebp
     4a4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     4a7:	83 ec 08             	sub    $0x8,%esp
     4aa:	6a 00                	push   $0x0
     4ac:	ff 75 08             	pushl  0x8(%ebp)
     4af:	e8 0c 01 00 00       	call   5c0 <open>
     4b4:	83 c4 10             	add    $0x10,%esp
     4b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     4ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     4be:	79 07                	jns    4c7 <stat+0x26>
    return -1;
     4c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     4c5:	eb 25                	jmp    4ec <stat+0x4b>
  r = fstat(fd, st);
     4c7:	83 ec 08             	sub    $0x8,%esp
     4ca:	ff 75 0c             	pushl  0xc(%ebp)
     4cd:	ff 75 f4             	pushl  -0xc(%ebp)
     4d0:	e8 03 01 00 00       	call   5d8 <fstat>
     4d5:	83 c4 10             	add    $0x10,%esp
     4d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     4db:	83 ec 0c             	sub    $0xc,%esp
     4de:	ff 75 f4             	pushl  -0xc(%ebp)
     4e1:	e8 c2 00 00 00       	call   5a8 <close>
     4e6:	83 c4 10             	add    $0x10,%esp
  return r;
     4e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     4ec:	c9                   	leave  
     4ed:	c3                   	ret    

000004ee <atoi>:

int
atoi(const char *s)
{
     4ee:	55                   	push   %ebp
     4ef:	89 e5                	mov    %esp,%ebp
     4f1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     4f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     4fb:	eb 25                	jmp    522 <atoi+0x34>
    n = n*10 + *s++ - '0';
     4fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
     500:	89 d0                	mov    %edx,%eax
     502:	c1 e0 02             	shl    $0x2,%eax
     505:	01 d0                	add    %edx,%eax
     507:	01 c0                	add    %eax,%eax
     509:	89 c1                	mov    %eax,%ecx
     50b:	8b 45 08             	mov    0x8(%ebp),%eax
     50e:	8d 50 01             	lea    0x1(%eax),%edx
     511:	89 55 08             	mov    %edx,0x8(%ebp)
     514:	0f b6 00             	movzbl (%eax),%eax
     517:	0f be c0             	movsbl %al,%eax
     51a:	01 c8                	add    %ecx,%eax
     51c:	83 e8 30             	sub    $0x30,%eax
     51f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     522:	8b 45 08             	mov    0x8(%ebp),%eax
     525:	0f b6 00             	movzbl (%eax),%eax
     528:	3c 2f                	cmp    $0x2f,%al
     52a:	7e 0a                	jle    536 <atoi+0x48>
     52c:	8b 45 08             	mov    0x8(%ebp),%eax
     52f:	0f b6 00             	movzbl (%eax),%eax
     532:	3c 39                	cmp    $0x39,%al
     534:	7e c7                	jle    4fd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     536:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     539:	c9                   	leave  
     53a:	c3                   	ret    

0000053b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     53b:	55                   	push   %ebp
     53c:	89 e5                	mov    %esp,%ebp
     53e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     541:	8b 45 08             	mov    0x8(%ebp),%eax
     544:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     547:	8b 45 0c             	mov    0xc(%ebp),%eax
     54a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     54d:	eb 17                	jmp    566 <memmove+0x2b>
    *dst++ = *src++;
     54f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     552:	8d 50 01             	lea    0x1(%eax),%edx
     555:	89 55 fc             	mov    %edx,-0x4(%ebp)
     558:	8b 55 f8             	mov    -0x8(%ebp),%edx
     55b:	8d 4a 01             	lea    0x1(%edx),%ecx
     55e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     561:	0f b6 12             	movzbl (%edx),%edx
     564:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     566:	8b 45 10             	mov    0x10(%ebp),%eax
     569:	8d 50 ff             	lea    -0x1(%eax),%edx
     56c:	89 55 10             	mov    %edx,0x10(%ebp)
     56f:	85 c0                	test   %eax,%eax
     571:	7f dc                	jg     54f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     573:	8b 45 08             	mov    0x8(%ebp),%eax
}
     576:	c9                   	leave  
     577:	c3                   	ret    

00000578 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     578:	b8 01 00 00 00       	mov    $0x1,%eax
     57d:	cd 40                	int    $0x40
     57f:	c3                   	ret    

00000580 <exit>:
SYSCALL(exit)
     580:	b8 02 00 00 00       	mov    $0x2,%eax
     585:	cd 40                	int    $0x40
     587:	c3                   	ret    

00000588 <wait>:
SYSCALL(wait)
     588:	b8 03 00 00 00       	mov    $0x3,%eax
     58d:	cd 40                	int    $0x40
     58f:	c3                   	ret    

00000590 <pipe>:
SYSCALL(pipe)
     590:	b8 04 00 00 00       	mov    $0x4,%eax
     595:	cd 40                	int    $0x40
     597:	c3                   	ret    

00000598 <read>:
SYSCALL(read)
     598:	b8 05 00 00 00       	mov    $0x5,%eax
     59d:	cd 40                	int    $0x40
     59f:	c3                   	ret    

000005a0 <write>:
SYSCALL(write)
     5a0:	b8 10 00 00 00       	mov    $0x10,%eax
     5a5:	cd 40                	int    $0x40
     5a7:	c3                   	ret    

000005a8 <close>:
SYSCALL(close)
     5a8:	b8 15 00 00 00       	mov    $0x15,%eax
     5ad:	cd 40                	int    $0x40
     5af:	c3                   	ret    

000005b0 <kill>:
SYSCALL(kill)
     5b0:	b8 06 00 00 00       	mov    $0x6,%eax
     5b5:	cd 40                	int    $0x40
     5b7:	c3                   	ret    

000005b8 <exec>:
SYSCALL(exec)
     5b8:	b8 07 00 00 00       	mov    $0x7,%eax
     5bd:	cd 40                	int    $0x40
     5bf:	c3                   	ret    

000005c0 <open>:
SYSCALL(open)
     5c0:	b8 0f 00 00 00       	mov    $0xf,%eax
     5c5:	cd 40                	int    $0x40
     5c7:	c3                   	ret    

000005c8 <mknod>:
SYSCALL(mknod)
     5c8:	b8 11 00 00 00       	mov    $0x11,%eax
     5cd:	cd 40                	int    $0x40
     5cf:	c3                   	ret    

000005d0 <unlink>:
SYSCALL(unlink)
     5d0:	b8 12 00 00 00       	mov    $0x12,%eax
     5d5:	cd 40                	int    $0x40
     5d7:	c3                   	ret    

000005d8 <fstat>:
SYSCALL(fstat)
     5d8:	b8 08 00 00 00       	mov    $0x8,%eax
     5dd:	cd 40                	int    $0x40
     5df:	c3                   	ret    

000005e0 <link>:
SYSCALL(link)
     5e0:	b8 13 00 00 00       	mov    $0x13,%eax
     5e5:	cd 40                	int    $0x40
     5e7:	c3                   	ret    

000005e8 <mkdir>:
SYSCALL(mkdir)
     5e8:	b8 14 00 00 00       	mov    $0x14,%eax
     5ed:	cd 40                	int    $0x40
     5ef:	c3                   	ret    

000005f0 <chdir>:
SYSCALL(chdir)
     5f0:	b8 09 00 00 00       	mov    $0x9,%eax
     5f5:	cd 40                	int    $0x40
     5f7:	c3                   	ret    

000005f8 <dup>:
SYSCALL(dup)
     5f8:	b8 0a 00 00 00       	mov    $0xa,%eax
     5fd:	cd 40                	int    $0x40
     5ff:	c3                   	ret    

00000600 <getpid>:
SYSCALL(getpid)
     600:	b8 0b 00 00 00       	mov    $0xb,%eax
     605:	cd 40                	int    $0x40
     607:	c3                   	ret    

00000608 <sbrk>:
SYSCALL(sbrk)
     608:	b8 0c 00 00 00       	mov    $0xc,%eax
     60d:	cd 40                	int    $0x40
     60f:	c3                   	ret    

00000610 <sleep>:
SYSCALL(sleep)
     610:	b8 0d 00 00 00       	mov    $0xd,%eax
     615:	cd 40                	int    $0x40
     617:	c3                   	ret    

00000618 <uptime>:
SYSCALL(uptime)
     618:	b8 0e 00 00 00       	mov    $0xe,%eax
     61d:	cd 40                	int    $0x40
     61f:	c3                   	ret    

00000620 <getcwd>:
SYSCALL(getcwd)
     620:	b8 16 00 00 00       	mov    $0x16,%eax
     625:	cd 40                	int    $0x40
     627:	c3                   	ret    

00000628 <shutdown>:
SYSCALL(shutdown)
     628:	b8 17 00 00 00       	mov    $0x17,%eax
     62d:	cd 40                	int    $0x40
     62f:	c3                   	ret    

00000630 <buildinfo>:
SYSCALL(buildinfo)
     630:	b8 18 00 00 00       	mov    $0x18,%eax
     635:	cd 40                	int    $0x40
     637:	c3                   	ret    

00000638 <lseek>:
SYSCALL(lseek)
     638:	b8 19 00 00 00       	mov    $0x19,%eax
     63d:	cd 40                	int    $0x40
     63f:	c3                   	ret    

00000640 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     640:	55                   	push   %ebp
     641:	89 e5                	mov    %esp,%ebp
     643:	83 ec 18             	sub    $0x18,%esp
     646:	8b 45 0c             	mov    0xc(%ebp),%eax
     649:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     64c:	83 ec 04             	sub    $0x4,%esp
     64f:	6a 01                	push   $0x1
     651:	8d 45 f4             	lea    -0xc(%ebp),%eax
     654:	50                   	push   %eax
     655:	ff 75 08             	pushl  0x8(%ebp)
     658:	e8 43 ff ff ff       	call   5a0 <write>
     65d:	83 c4 10             	add    $0x10,%esp
}
     660:	c9                   	leave  
     661:	c3                   	ret    

00000662 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     662:	55                   	push   %ebp
     663:	89 e5                	mov    %esp,%ebp
     665:	53                   	push   %ebx
     666:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     669:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     670:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     674:	74 17                	je     68d <printint+0x2b>
     676:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     67a:	79 11                	jns    68d <printint+0x2b>
    neg = 1;
     67c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     683:	8b 45 0c             	mov    0xc(%ebp),%eax
     686:	f7 d8                	neg    %eax
     688:	89 45 ec             	mov    %eax,-0x14(%ebp)
     68b:	eb 06                	jmp    693 <printint+0x31>
  } else {
    x = xx;
     68d:	8b 45 0c             	mov    0xc(%ebp),%eax
     690:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     69a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     69d:	8d 41 01             	lea    0x1(%ecx),%eax
     6a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
     6a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
     6a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6a9:	ba 00 00 00 00       	mov    $0x0,%edx
     6ae:	f7 f3                	div    %ebx
     6b0:	89 d0                	mov    %edx,%eax
     6b2:	0f b6 80 04 17 00 00 	movzbl 0x1704(%eax),%eax
     6b9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     6bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
     6c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6c3:	ba 00 00 00 00       	mov    $0x0,%edx
     6c8:	f7 f3                	div    %ebx
     6ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     6d1:	75 c7                	jne    69a <printint+0x38>
  if(neg)
     6d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     6d7:	74 0e                	je     6e7 <printint+0x85>
    buf[i++] = '-';
     6d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6dc:	8d 50 01             	lea    0x1(%eax),%edx
     6df:	89 55 f4             	mov    %edx,-0xc(%ebp)
     6e2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     6e7:	eb 1d                	jmp    706 <printint+0xa4>
    putc(fd, buf[i]);
     6e9:	8d 55 dc             	lea    -0x24(%ebp),%edx
     6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ef:	01 d0                	add    %edx,%eax
     6f1:	0f b6 00             	movzbl (%eax),%eax
     6f4:	0f be c0             	movsbl %al,%eax
     6f7:	83 ec 08             	sub    $0x8,%esp
     6fa:	50                   	push   %eax
     6fb:	ff 75 08             	pushl  0x8(%ebp)
     6fe:	e8 3d ff ff ff       	call   640 <putc>
     703:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     706:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     70a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     70e:	79 d9                	jns    6e9 <printint+0x87>
    putc(fd, buf[i]);
}
     710:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     713:	c9                   	leave  
     714:	c3                   	ret    

00000715 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     715:	55                   	push   %ebp
     716:	89 e5                	mov    %esp,%ebp
     718:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     71b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     722:	8d 45 0c             	lea    0xc(%ebp),%eax
     725:	83 c0 04             	add    $0x4,%eax
     728:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     72b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     732:	e9 59 01 00 00       	jmp    890 <printf+0x17b>
    c = fmt[i] & 0xff;
     737:	8b 55 0c             	mov    0xc(%ebp),%edx
     73a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     73d:	01 d0                	add    %edx,%eax
     73f:	0f b6 00             	movzbl (%eax),%eax
     742:	0f be c0             	movsbl %al,%eax
     745:	25 ff 00 00 00       	and    $0xff,%eax
     74a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     74d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     751:	75 2c                	jne    77f <printf+0x6a>
      if(c == '%'){
     753:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     757:	75 0c                	jne    765 <printf+0x50>
        state = '%';
     759:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     760:	e9 27 01 00 00       	jmp    88c <printf+0x177>
      } else {
        putc(fd, c);
     765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     768:	0f be c0             	movsbl %al,%eax
     76b:	83 ec 08             	sub    $0x8,%esp
     76e:	50                   	push   %eax
     76f:	ff 75 08             	pushl  0x8(%ebp)
     772:	e8 c9 fe ff ff       	call   640 <putc>
     777:	83 c4 10             	add    $0x10,%esp
     77a:	e9 0d 01 00 00       	jmp    88c <printf+0x177>
      }
    } else if(state == '%'){
     77f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     783:	0f 85 03 01 00 00    	jne    88c <printf+0x177>
      if(c == 'd'){
     789:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     78d:	75 1e                	jne    7ad <printf+0x98>
        printint(fd, *ap, 10, 1);
     78f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     792:	8b 00                	mov    (%eax),%eax
     794:	6a 01                	push   $0x1
     796:	6a 0a                	push   $0xa
     798:	50                   	push   %eax
     799:	ff 75 08             	pushl  0x8(%ebp)
     79c:	e8 c1 fe ff ff       	call   662 <printint>
     7a1:	83 c4 10             	add    $0x10,%esp
        ap++;
     7a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7a8:	e9 d8 00 00 00       	jmp    885 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
     7ad:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     7b1:	74 06                	je     7b9 <printf+0xa4>
     7b3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     7b7:	75 1e                	jne    7d7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
     7b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7bc:	8b 00                	mov    (%eax),%eax
     7be:	6a 00                	push   $0x0
     7c0:	6a 10                	push   $0x10
     7c2:	50                   	push   %eax
     7c3:	ff 75 08             	pushl  0x8(%ebp)
     7c6:	e8 97 fe ff ff       	call   662 <printint>
     7cb:	83 c4 10             	add    $0x10,%esp
        ap++;
     7ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7d2:	e9 ae 00 00 00       	jmp    885 <printf+0x170>
      } else if(c == 's'){
     7d7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     7db:	75 43                	jne    820 <printf+0x10b>
        s = (char*)*ap;
     7dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7e0:	8b 00                	mov    (%eax),%eax
     7e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     7e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     7e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     7ed:	75 07                	jne    7f6 <printf+0xe1>
          s = "(null)";
     7ef:	c7 45 f4 6e 12 00 00 	movl   $0x126e,-0xc(%ebp)
        while(*s != 0){
     7f6:	eb 1c                	jmp    814 <printf+0xff>
          putc(fd, *s);
     7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7fb:	0f b6 00             	movzbl (%eax),%eax
     7fe:	0f be c0             	movsbl %al,%eax
     801:	83 ec 08             	sub    $0x8,%esp
     804:	50                   	push   %eax
     805:	ff 75 08             	pushl  0x8(%ebp)
     808:	e8 33 fe ff ff       	call   640 <putc>
     80d:	83 c4 10             	add    $0x10,%esp
          s++;
     810:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     814:	8b 45 f4             	mov    -0xc(%ebp),%eax
     817:	0f b6 00             	movzbl (%eax),%eax
     81a:	84 c0                	test   %al,%al
     81c:	75 da                	jne    7f8 <printf+0xe3>
     81e:	eb 65                	jmp    885 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     820:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     824:	75 1d                	jne    843 <printf+0x12e>
        putc(fd, *ap);
     826:	8b 45 e8             	mov    -0x18(%ebp),%eax
     829:	8b 00                	mov    (%eax),%eax
     82b:	0f be c0             	movsbl %al,%eax
     82e:	83 ec 08             	sub    $0x8,%esp
     831:	50                   	push   %eax
     832:	ff 75 08             	pushl  0x8(%ebp)
     835:	e8 06 fe ff ff       	call   640 <putc>
     83a:	83 c4 10             	add    $0x10,%esp
        ap++;
     83d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     841:	eb 42                	jmp    885 <printf+0x170>
      } else if(c == '%'){
     843:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     847:	75 17                	jne    860 <printf+0x14b>
        putc(fd, c);
     849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     84c:	0f be c0             	movsbl %al,%eax
     84f:	83 ec 08             	sub    $0x8,%esp
     852:	50                   	push   %eax
     853:	ff 75 08             	pushl  0x8(%ebp)
     856:	e8 e5 fd ff ff       	call   640 <putc>
     85b:	83 c4 10             	add    $0x10,%esp
     85e:	eb 25                	jmp    885 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     860:	83 ec 08             	sub    $0x8,%esp
     863:	6a 25                	push   $0x25
     865:	ff 75 08             	pushl  0x8(%ebp)
     868:	e8 d3 fd ff ff       	call   640 <putc>
     86d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
     870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     873:	0f be c0             	movsbl %al,%eax
     876:	83 ec 08             	sub    $0x8,%esp
     879:	50                   	push   %eax
     87a:	ff 75 08             	pushl  0x8(%ebp)
     87d:	e8 be fd ff ff       	call   640 <putc>
     882:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     885:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     88c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     890:	8b 55 0c             	mov    0xc(%ebp),%edx
     893:	8b 45 f0             	mov    -0x10(%ebp),%eax
     896:	01 d0                	add    %edx,%eax
     898:	0f b6 00             	movzbl (%eax),%eax
     89b:	84 c0                	test   %al,%al
     89d:	0f 85 94 fe ff ff    	jne    737 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     8a3:	c9                   	leave  
     8a4:	c3                   	ret    

000008a5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     8a5:	55                   	push   %ebp
     8a6:	89 e5                	mov    %esp,%ebp
     8a8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     8ab:	8b 45 08             	mov    0x8(%ebp),%eax
     8ae:	83 e8 08             	sub    $0x8,%eax
     8b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8b4:	a1 48 17 00 00       	mov    0x1748,%eax
     8b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
     8bc:	eb 24                	jmp    8e2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8c1:	8b 00                	mov    (%eax),%eax
     8c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8c6:	77 12                	ja     8da <free+0x35>
     8c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8ce:	77 24                	ja     8f4 <free+0x4f>
     8d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8d3:	8b 00                	mov    (%eax),%eax
     8d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     8d8:	77 1a                	ja     8f4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8da:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8dd:	8b 00                	mov    (%eax),%eax
     8df:	89 45 fc             	mov    %eax,-0x4(%ebp)
     8e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8e8:	76 d4                	jbe    8be <free+0x19>
     8ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8ed:	8b 00                	mov    (%eax),%eax
     8ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     8f2:	76 ca                	jbe    8be <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     8f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8f7:	8b 40 04             	mov    0x4(%eax),%eax
     8fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     901:	8b 45 f8             	mov    -0x8(%ebp),%eax
     904:	01 c2                	add    %eax,%edx
     906:	8b 45 fc             	mov    -0x4(%ebp),%eax
     909:	8b 00                	mov    (%eax),%eax
     90b:	39 c2                	cmp    %eax,%edx
     90d:	75 24                	jne    933 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     90f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     912:	8b 50 04             	mov    0x4(%eax),%edx
     915:	8b 45 fc             	mov    -0x4(%ebp),%eax
     918:	8b 00                	mov    (%eax),%eax
     91a:	8b 40 04             	mov    0x4(%eax),%eax
     91d:	01 c2                	add    %eax,%edx
     91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     922:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     925:	8b 45 fc             	mov    -0x4(%ebp),%eax
     928:	8b 00                	mov    (%eax),%eax
     92a:	8b 10                	mov    (%eax),%edx
     92c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     92f:	89 10                	mov    %edx,(%eax)
     931:	eb 0a                	jmp    93d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     933:	8b 45 fc             	mov    -0x4(%ebp),%eax
     936:	8b 10                	mov    (%eax),%edx
     938:	8b 45 f8             	mov    -0x8(%ebp),%eax
     93b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     93d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     940:	8b 40 04             	mov    0x4(%eax),%eax
     943:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     94d:	01 d0                	add    %edx,%eax
     94f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     952:	75 20                	jne    974 <free+0xcf>
    p->s.size += bp->s.size;
     954:	8b 45 fc             	mov    -0x4(%ebp),%eax
     957:	8b 50 04             	mov    0x4(%eax),%edx
     95a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     95d:	8b 40 04             	mov    0x4(%eax),%eax
     960:	01 c2                	add    %eax,%edx
     962:	8b 45 fc             	mov    -0x4(%ebp),%eax
     965:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     968:	8b 45 f8             	mov    -0x8(%ebp),%eax
     96b:	8b 10                	mov    (%eax),%edx
     96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     970:	89 10                	mov    %edx,(%eax)
     972:	eb 08                	jmp    97c <free+0xd7>
  } else
    p->s.ptr = bp;
     974:	8b 45 fc             	mov    -0x4(%ebp),%eax
     977:	8b 55 f8             	mov    -0x8(%ebp),%edx
     97a:	89 10                	mov    %edx,(%eax)
  freep = p;
     97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     97f:	a3 48 17 00 00       	mov    %eax,0x1748
}
     984:	c9                   	leave  
     985:	c3                   	ret    

00000986 <morecore>:

static Header*
morecore(uint nu)
{
     986:	55                   	push   %ebp
     987:	89 e5                	mov    %esp,%ebp
     989:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     98c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     993:	77 07                	ja     99c <morecore+0x16>
    nu = 4096;
     995:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     99c:	8b 45 08             	mov    0x8(%ebp),%eax
     99f:	c1 e0 03             	shl    $0x3,%eax
     9a2:	83 ec 0c             	sub    $0xc,%esp
     9a5:	50                   	push   %eax
     9a6:	e8 5d fc ff ff       	call   608 <sbrk>
     9ab:	83 c4 10             	add    $0x10,%esp
     9ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     9b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     9b5:	75 07                	jne    9be <morecore+0x38>
    return 0;
     9b7:	b8 00 00 00 00       	mov    $0x0,%eax
     9bc:	eb 26                	jmp    9e4 <morecore+0x5e>
  hp = (Header*)p;
     9be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     9c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9c7:	8b 55 08             	mov    0x8(%ebp),%edx
     9ca:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     9cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9d0:	83 c0 08             	add    $0x8,%eax
     9d3:	83 ec 0c             	sub    $0xc,%esp
     9d6:	50                   	push   %eax
     9d7:	e8 c9 fe ff ff       	call   8a5 <free>
     9dc:	83 c4 10             	add    $0x10,%esp
  return freep;
     9df:	a1 48 17 00 00       	mov    0x1748,%eax
}
     9e4:	c9                   	leave  
     9e5:	c3                   	ret    

000009e6 <malloc>:

void*
malloc(uint nbytes)
{
     9e6:	55                   	push   %ebp
     9e7:	89 e5                	mov    %esp,%ebp
     9e9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     9ec:	8b 45 08             	mov    0x8(%ebp),%eax
     9ef:	83 c0 07             	add    $0x7,%eax
     9f2:	c1 e8 03             	shr    $0x3,%eax
     9f5:	83 c0 01             	add    $0x1,%eax
     9f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     9fb:	a1 48 17 00 00       	mov    0x1748,%eax
     a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a07:	75 23                	jne    a2c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a09:	c7 45 f0 40 17 00 00 	movl   $0x1740,-0x10(%ebp)
     a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a13:	a3 48 17 00 00       	mov    %eax,0x1748
     a18:	a1 48 17 00 00       	mov    0x1748,%eax
     a1d:	a3 40 17 00 00       	mov    %eax,0x1740
    base.s.size = 0;
     a22:	c7 05 44 17 00 00 00 	movl   $0x0,0x1744
     a29:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a2f:	8b 00                	mov    (%eax),%eax
     a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a37:	8b 40 04             	mov    0x4(%eax),%eax
     a3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a3d:	72 4d                	jb     a8c <malloc+0xa6>
      if(p->s.size == nunits)
     a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a42:	8b 40 04             	mov    0x4(%eax),%eax
     a45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a48:	75 0c                	jne    a56 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a4d:	8b 10                	mov    (%eax),%edx
     a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a52:	89 10                	mov    %edx,(%eax)
     a54:	eb 26                	jmp    a7c <malloc+0x96>
      else {
        p->s.size -= nunits;
     a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a59:	8b 40 04             	mov    0x4(%eax),%eax
     a5c:	2b 45 ec             	sub    -0x14(%ebp),%eax
     a5f:	89 c2                	mov    %eax,%edx
     a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a64:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a6a:	8b 40 04             	mov    0x4(%eax),%eax
     a6d:	c1 e0 03             	shl    $0x3,%eax
     a70:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a76:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a79:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a7f:	a3 48 17 00 00       	mov    %eax,0x1748
      return (void*)(p + 1);
     a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a87:	83 c0 08             	add    $0x8,%eax
     a8a:	eb 3b                	jmp    ac7 <malloc+0xe1>
    }
    if(p == freep)
     a8c:	a1 48 17 00 00       	mov    0x1748,%eax
     a91:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a94:	75 1e                	jne    ab4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
     a96:	83 ec 0c             	sub    $0xc,%esp
     a99:	ff 75 ec             	pushl  -0x14(%ebp)
     a9c:	e8 e5 fe ff ff       	call   986 <morecore>
     aa1:	83 c4 10             	add    $0x10,%esp
     aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
     aa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     aab:	75 07                	jne    ab4 <malloc+0xce>
        return 0;
     aad:	b8 00 00 00 00       	mov    $0x0,%eax
     ab2:	eb 13                	jmp    ac7 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
     aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
     abd:	8b 00                	mov    (%eax),%eax
     abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     ac2:	e9 6d ff ff ff       	jmp    a34 <malloc+0x4e>
}
     ac7:	c9                   	leave  
     ac8:	c3                   	ret    

00000ac9 <isspace>:

#include "common.h"

int isspace(char c) {
     ac9:	55                   	push   %ebp
     aca:	89 e5                	mov    %esp,%ebp
     acc:	83 ec 04             	sub    $0x4,%esp
     acf:	8b 45 08             	mov    0x8(%ebp),%eax
     ad2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
     ad5:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     ad9:	74 12                	je     aed <isspace+0x24>
     adb:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     adf:	74 0c                	je     aed <isspace+0x24>
     ae1:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     ae5:	74 06                	je     aed <isspace+0x24>
     ae7:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     aeb:	75 07                	jne    af4 <isspace+0x2b>
     aed:	b8 01 00 00 00       	mov    $0x1,%eax
     af2:	eb 05                	jmp    af9 <isspace+0x30>
     af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
     af9:	c9                   	leave  
     afa:	c3                   	ret    

00000afb <readln>:

char* readln(char *buf, int max, int fd)
{
     afb:	55                   	push   %ebp
     afc:	89 e5                	mov    %esp,%ebp
     afe:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b08:	eb 45                	jmp    b4f <readln+0x54>
    cc = read(fd, &c, 1);
     b0a:	83 ec 04             	sub    $0x4,%esp
     b0d:	6a 01                	push   $0x1
     b0f:	8d 45 ef             	lea    -0x11(%ebp),%eax
     b12:	50                   	push   %eax
     b13:	ff 75 10             	pushl  0x10(%ebp)
     b16:	e8 7d fa ff ff       	call   598 <read>
     b1b:	83 c4 10             	add    $0x10,%esp
     b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     b21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b25:	7f 02                	jg     b29 <readln+0x2e>
      break;
     b27:	eb 31                	jmp    b5a <readln+0x5f>
    buf[i++] = c;
     b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b2c:	8d 50 01             	lea    0x1(%eax),%edx
     b2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
     b32:	89 c2                	mov    %eax,%edx
     b34:	8b 45 08             	mov    0x8(%ebp),%eax
     b37:	01 c2                	add    %eax,%edx
     b39:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     b3d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     b3f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     b43:	3c 0a                	cmp    $0xa,%al
     b45:	74 13                	je     b5a <readln+0x5f>
     b47:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     b4b:	3c 0d                	cmp    $0xd,%al
     b4d:	74 0b                	je     b5a <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b52:	83 c0 01             	add    $0x1,%eax
     b55:	3b 45 0c             	cmp    0xc(%ebp),%eax
     b58:	7c b0                	jl     b0a <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     b5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b5d:	8b 45 08             	mov    0x8(%ebp),%eax
     b60:	01 d0                	add    %edx,%eax
     b62:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     b65:	8b 45 08             	mov    0x8(%ebp),%eax
}
     b68:	c9                   	leave  
     b69:	c3                   	ret    

00000b6a <strncpy>:

char* strncpy(char* dest, char* src, int n) {
     b6a:	55                   	push   %ebp
     b6b:	89 e5                	mov    %esp,%ebp
     b6d:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     b70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     b77:	eb 19                	jmp    b92 <strncpy+0x28>
		dest[i] = src[i];
     b79:	8b 55 fc             	mov    -0x4(%ebp),%edx
     b7c:	8b 45 08             	mov    0x8(%ebp),%eax
     b7f:	01 c2                	add    %eax,%edx
     b81:	8b 4d fc             	mov    -0x4(%ebp),%ecx
     b84:	8b 45 0c             	mov    0xc(%ebp),%eax
     b87:	01 c8                	add    %ecx,%eax
     b89:	0f b6 00             	movzbl (%eax),%eax
     b8c:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     b8e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b95:	3b 45 10             	cmp    0x10(%ebp),%eax
     b98:	7d 0f                	jge    ba9 <strncpy+0x3f>
     b9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
     ba0:	01 d0                	add    %edx,%eax
     ba2:	0f b6 00             	movzbl (%eax),%eax
     ba5:	84 c0                	test   %al,%al
     ba7:	75 d0                	jne    b79 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
     ba9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     bac:	c9                   	leave  
     bad:	c3                   	ret    

00000bae <trim>:

char* trim(char* orig) {
     bae:	55                   	push   %ebp
     baf:	89 e5                	mov    %esp,%ebp
     bb1:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
     bb4:	8b 45 08             	mov    0x8(%ebp),%eax
     bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
     bba:	8b 45 08             	mov    0x8(%ebp),%eax
     bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
     bc0:	eb 04                	jmp    bc6 <trim+0x18>
     bc2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bc9:	0f b6 00             	movzbl (%eax),%eax
     bcc:	0f be c0             	movsbl %al,%eax
     bcf:	50                   	push   %eax
     bd0:	e8 f4 fe ff ff       	call   ac9 <isspace>
     bd5:	83 c4 04             	add    $0x4,%esp
     bd8:	85 c0                	test   %eax,%eax
     bda:	75 e6                	jne    bc2 <trim+0x14>
	while (*tail) { tail++; }
     bdc:	eb 04                	jmp    be2 <trim+0x34>
     bde:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     be5:	0f b6 00             	movzbl (%eax),%eax
     be8:	84 c0                	test   %al,%al
     bea:	75 f2                	jne    bde <trim+0x30>
	do { tail--; } while (isspace(*tail));
     bec:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
     bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bf3:	0f b6 00             	movzbl (%eax),%eax
     bf6:	0f be c0             	movsbl %al,%eax
     bf9:	50                   	push   %eax
     bfa:	e8 ca fe ff ff       	call   ac9 <isspace>
     bff:	83 c4 04             	add    $0x4,%esp
     c02:	85 c0                	test   %eax,%eax
     c04:	75 e6                	jne    bec <trim+0x3e>
	new = malloc(tail-head+2);
     c06:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c0c:	29 c2                	sub    %eax,%edx
     c0e:	89 d0                	mov    %edx,%eax
     c10:	83 c0 02             	add    $0x2,%eax
     c13:	83 ec 0c             	sub    $0xc,%esp
     c16:	50                   	push   %eax
     c17:	e8 ca fd ff ff       	call   9e6 <malloc>
     c1c:	83 c4 10             	add    $0x10,%esp
     c1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
     c22:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c28:	29 c2                	sub    %eax,%edx
     c2a:	89 d0                	mov    %edx,%eax
     c2c:	83 c0 01             	add    $0x1,%eax
     c2f:	83 ec 04             	sub    $0x4,%esp
     c32:	50                   	push   %eax
     c33:	ff 75 f4             	pushl  -0xc(%ebp)
     c36:	ff 75 ec             	pushl  -0x14(%ebp)
     c39:	e8 2c ff ff ff       	call   b6a <strncpy>
     c3e:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
     c41:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c47:	29 c2                	sub    %eax,%edx
     c49:	89 d0                	mov    %edx,%eax
     c4b:	8d 50 01             	lea    0x1(%eax),%edx
     c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c51:	01 d0                	add    %edx,%eax
     c53:	c6 00 00             	movb   $0x0,(%eax)
	return new;
     c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
     c59:	c9                   	leave  
     c5a:	c3                   	ret    

00000c5b <itoa>:

char *
itoa(int value)
{
     c5b:	55                   	push   %ebp
     c5c:	89 e5                	mov    %esp,%ebp
     c5e:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
     c61:	8d 45 bf             	lea    -0x41(%ebp),%eax
     c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
     c67:	8b 45 08             	mov    0x8(%ebp),%eax
     c6a:	c1 e8 1f             	shr    $0x1f,%eax
     c6d:	0f b6 c0             	movzbl %al,%eax
     c70:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
     c73:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c77:	74 0a                	je     c83 <itoa+0x28>
    v = -value;
     c79:	8b 45 08             	mov    0x8(%ebp),%eax
     c7c:	f7 d8                	neg    %eax
     c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     c81:	eb 06                	jmp    c89 <itoa+0x2e>
  else
    v = (uint)value;
     c83:	8b 45 08             	mov    0x8(%ebp),%eax
     c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
     c89:	eb 5b                	jmp    ce6 <itoa+0x8b>
  {
    i = v % 10;
     c8b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     c8e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     c93:	89 c8                	mov    %ecx,%eax
     c95:	f7 e2                	mul    %edx
     c97:	c1 ea 03             	shr    $0x3,%edx
     c9a:	89 d0                	mov    %edx,%eax
     c9c:	c1 e0 02             	shl    $0x2,%eax
     c9f:	01 d0                	add    %edx,%eax
     ca1:	01 c0                	add    %eax,%eax
     ca3:	29 c1                	sub    %eax,%ecx
     ca5:	89 ca                	mov    %ecx,%edx
     ca7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
     caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cad:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     cb2:	f7 e2                	mul    %edx
     cb4:	89 d0                	mov    %edx,%eax
     cb6:	c1 e8 03             	shr    $0x3,%eax
     cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
     cbc:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
     cc0:	7f 13                	jg     cd5 <itoa+0x7a>
      *tp++ = i+'0';
     cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc5:	8d 50 01             	lea    0x1(%eax),%edx
     cc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ccb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     cce:	83 c2 30             	add    $0x30,%edx
     cd1:	88 10                	mov    %dl,(%eax)
     cd3:	eb 11                	jmp    ce6 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
     cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cd8:	8d 50 01             	lea    0x1(%eax),%edx
     cdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
     cde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     ce1:	83 c2 57             	add    $0x57,%edx
     ce4:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
     ce6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cea:	75 9f                	jne    c8b <itoa+0x30>
     cec:	8d 45 bf             	lea    -0x41(%ebp),%eax
     cef:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     cf2:	74 97                	je     c8b <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
     cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cf7:	8d 45 bf             	lea    -0x41(%ebp),%eax
     cfa:	29 c2                	sub    %eax,%edx
     cfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cff:	01 d0                	add    %edx,%eax
     d01:	83 c0 01             	add    $0x1,%eax
     d04:	83 ec 0c             	sub    $0xc,%esp
     d07:	50                   	push   %eax
     d08:	e8 d9 fc ff ff       	call   9e6 <malloc>
     d0d:	83 c4 10             	add    $0x10,%esp
     d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
     d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
     d16:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
     d19:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d1d:	74 0c                	je     d2b <itoa+0xd0>
    *sp++ = '-';
     d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d22:	8d 50 01             	lea    0x1(%eax),%edx
     d25:	89 55 ec             	mov    %edx,-0x14(%ebp)
     d28:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
     d2b:	eb 15                	jmp    d42 <itoa+0xe7>
    *sp++ = *--tp;
     d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d30:	8d 50 01             	lea    0x1(%eax),%edx
     d33:	89 55 ec             	mov    %edx,-0x14(%ebp)
     d36:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     d3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d3d:	0f b6 12             	movzbl (%edx),%edx
     d40:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
     d42:	8d 45 bf             	lea    -0x41(%ebp),%eax
     d45:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     d48:	77 e3                	ja     d2d <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
     d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d4d:	c6 00 00             	movb   $0x0,(%eax)
  return string;
     d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
     d53:	c9                   	leave  
     d54:	c3                   	ret    

00000d55 <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
     d55:	55                   	push   %ebp
     d56:	89 e5                	mov    %esp,%ebp
     d58:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
     d5e:	83 ec 08             	sub    $0x8,%esp
     d61:	6a 00                	push   $0x0
     d63:	ff 75 08             	pushl  0x8(%ebp)
     d66:	e8 55 f8 ff ff       	call   5c0 <open>
     d6b:	83 c4 10             	add    $0x10,%esp
     d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     d71:	e9 22 01 00 00       	jmp    e98 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
     d76:	83 ec 08             	sub    $0x8,%esp
     d79:	6a 3d                	push   $0x3d
     d7b:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     d81:	50                   	push   %eax
     d82:	e8 79 f6 ff ff       	call   400 <strchr>
     d87:	83 c4 10             	add    $0x10,%esp
     d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
     d8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d91:	0f 84 23 01 00 00    	je     eba <parseEnvFile+0x165>
     d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d9b:	0f 84 19 01 00 00    	je     eba <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
     da1:	8b 55 f0             	mov    -0x10(%ebp),%edx
     da4:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     daa:	29 c2                	sub    %eax,%edx
     dac:	89 d0                	mov    %edx,%eax
     dae:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
     db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     db4:	83 c0 01             	add    $0x1,%eax
     db7:	83 ec 0c             	sub    $0xc,%esp
     dba:	50                   	push   %eax
     dbb:	e8 26 fc ff ff       	call   9e6 <malloc>
     dc0:	83 c4 10             	add    $0x10,%esp
     dc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
     dc6:	83 ec 04             	sub    $0x4,%esp
     dc9:	ff 75 ec             	pushl  -0x14(%ebp)
     dcc:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     dd2:	50                   	push   %eax
     dd3:	ff 75 e8             	pushl  -0x18(%ebp)
     dd6:	e8 8f fd ff ff       	call   b6a <strncpy>
     ddb:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
     dde:	83 ec 0c             	sub    $0xc,%esp
     de1:	ff 75 e8             	pushl  -0x18(%ebp)
     de4:	e8 c5 fd ff ff       	call   bae <trim>
     de9:	83 c4 10             	add    $0x10,%esp
     dec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
     def:	83 ec 0c             	sub    $0xc,%esp
     df2:	ff 75 e8             	pushl  -0x18(%ebp)
     df5:	e8 ab fa ff ff       	call   8a5 <free>
     dfa:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
     dfd:	83 ec 08             	sub    $0x8,%esp
     e00:	ff 75 0c             	pushl  0xc(%ebp)
     e03:	ff 75 e4             	pushl  -0x1c(%ebp)
     e06:	e8 c2 01 00 00       	call   fcd <addToEnvironment>
     e0b:	83 c4 10             	add    $0x10,%esp
     e0e:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
     e11:	83 ec 0c             	sub    $0xc,%esp
     e14:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     e1a:	50                   	push   %eax
     e1b:	e8 9f f5 ff ff       	call   3bf <strlen>
     e20:	83 c4 10             	add    $0x10,%esp
     e23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
     e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e29:	2b 45 ec             	sub    -0x14(%ebp),%eax
     e2c:	83 ec 0c             	sub    $0xc,%esp
     e2f:	50                   	push   %eax
     e30:	e8 b1 fb ff ff       	call   9e6 <malloc>
     e35:	83 c4 10             	add    $0x10,%esp
     e38:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
     e3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e3e:	2b 45 ec             	sub    -0x14(%ebp),%eax
     e41:	8d 50 ff             	lea    -0x1(%eax),%edx
     e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e47:	8d 48 01             	lea    0x1(%eax),%ecx
     e4a:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     e50:	01 c8                	add    %ecx,%eax
     e52:	83 ec 04             	sub    $0x4,%esp
     e55:	52                   	push   %edx
     e56:	50                   	push   %eax
     e57:	ff 75 e8             	pushl  -0x18(%ebp)
     e5a:	e8 0b fd ff ff       	call   b6a <strncpy>
     e5f:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
     e62:	83 ec 0c             	sub    $0xc,%esp
     e65:	ff 75 e8             	pushl  -0x18(%ebp)
     e68:	e8 41 fd ff ff       	call   bae <trim>
     e6d:	83 c4 10             	add    $0x10,%esp
     e70:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
     e73:	83 ec 0c             	sub    $0xc,%esp
     e76:	ff 75 e8             	pushl  -0x18(%ebp)
     e79:	e8 27 fa ff ff       	call   8a5 <free>
     e7e:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
     e81:	83 ec 04             	sub    $0x4,%esp
     e84:	ff 75 dc             	pushl  -0x24(%ebp)
     e87:	ff 75 0c             	pushl  0xc(%ebp)
     e8a:	ff 75 e4             	pushl  -0x1c(%ebp)
     e8d:	e8 b8 01 00 00       	call   104a <addValueToVariable>
     e92:	83 c4 10             	add    $0x10,%esp
     e95:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     e98:	83 ec 04             	sub    $0x4,%esp
     e9b:	ff 75 f4             	pushl  -0xc(%ebp)
     e9e:	68 00 04 00 00       	push   $0x400
     ea3:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     ea9:	50                   	push   %eax
     eaa:	e8 4c fc ff ff       	call   afb <readln>
     eaf:	83 c4 10             	add    $0x10,%esp
     eb2:	85 c0                	test   %eax,%eax
     eb4:	0f 85 bc fe ff ff    	jne    d76 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
     eba:	83 ec 0c             	sub    $0xc,%esp
     ebd:	ff 75 f4             	pushl  -0xc(%ebp)
     ec0:	e8 e3 f6 ff ff       	call   5a8 <close>
     ec5:	83 c4 10             	add    $0x10,%esp
	return head;
     ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     ecb:	c9                   	leave  
     ecc:	c3                   	ret    

00000ecd <comp>:

int comp(const char* s1, const char* s2)
{
     ecd:	55                   	push   %ebp
     ece:	89 e5                	mov    %esp,%ebp
     ed0:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
     ed3:	83 ec 08             	sub    $0x8,%esp
     ed6:	ff 75 0c             	pushl  0xc(%ebp)
     ed9:	ff 75 08             	pushl  0x8(%ebp)
     edc:	e8 9f f4 ff ff       	call   380 <strcmp>
     ee1:	83 c4 10             	add    $0x10,%esp
     ee4:	85 c0                	test   %eax,%eax
     ee6:	0f 94 c0             	sete   %al
     ee9:	0f b6 c0             	movzbl %al,%eax
}
     eec:	c9                   	leave  
     eed:	c3                   	ret    

00000eee <environLookup>:

variable* environLookup(const char* name, variable* head)
{
     eee:	55                   	push   %ebp
     eef:	89 e5                	mov    %esp,%ebp
     ef1:	83 ec 08             	sub    $0x8,%esp
  if (!name)
     ef4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ef8:	75 07                	jne    f01 <environLookup+0x13>
    return NULL;
     efa:	b8 00 00 00 00       	mov    $0x0,%eax
     eff:	eb 2f                	jmp    f30 <environLookup+0x42>
  
  while (head)
     f01:	eb 24                	jmp    f27 <environLookup+0x39>
  {
    if (comp(name, head->name))
     f03:	8b 45 0c             	mov    0xc(%ebp),%eax
     f06:	83 ec 08             	sub    $0x8,%esp
     f09:	50                   	push   %eax
     f0a:	ff 75 08             	pushl  0x8(%ebp)
     f0d:	e8 bb ff ff ff       	call   ecd <comp>
     f12:	83 c4 10             	add    $0x10,%esp
     f15:	85 c0                	test   %eax,%eax
     f17:	74 02                	je     f1b <environLookup+0x2d>
      break;
     f19:	eb 12                	jmp    f2d <environLookup+0x3f>
    head = head->next;
     f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f1e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     f24:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
     f27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f2b:	75 d6                	jne    f03 <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
     f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     f30:	c9                   	leave  
     f31:	c3                   	ret    

00000f32 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
     f32:	55                   	push   %ebp
     f33:	89 e5                	mov    %esp,%ebp
     f35:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
     f38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f3c:	75 0a                	jne    f48 <removeFromEnvironment+0x16>
    return NULL;
     f3e:	b8 00 00 00 00       	mov    $0x0,%eax
     f43:	e9 83 00 00 00       	jmp    fcb <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
     f48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f4c:	74 0a                	je     f58 <removeFromEnvironment+0x26>
     f4e:	8b 45 08             	mov    0x8(%ebp),%eax
     f51:	0f b6 00             	movzbl (%eax),%eax
     f54:	84 c0                	test   %al,%al
     f56:	75 05                	jne    f5d <removeFromEnvironment+0x2b>
    return head;
     f58:	8b 45 0c             	mov    0xc(%ebp),%eax
     f5b:	eb 6e                	jmp    fcb <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
     f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
     f60:	83 ec 08             	sub    $0x8,%esp
     f63:	ff 75 08             	pushl  0x8(%ebp)
     f66:	50                   	push   %eax
     f67:	e8 61 ff ff ff       	call   ecd <comp>
     f6c:	83 c4 10             	add    $0x10,%esp
     f6f:	85 c0                	test   %eax,%eax
     f71:	74 34                	je     fa7 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
     f73:	8b 45 0c             	mov    0xc(%ebp),%eax
     f76:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
     f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
     f82:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     f88:	83 ec 0c             	sub    $0xc,%esp
     f8b:	50                   	push   %eax
     f8c:	e8 74 01 00 00       	call   1105 <freeVarval>
     f91:	83 c4 10             	add    $0x10,%esp
    free(head);
     f94:	83 ec 0c             	sub    $0xc,%esp
     f97:	ff 75 0c             	pushl  0xc(%ebp)
     f9a:	e8 06 f9 ff ff       	call   8a5 <free>
     f9f:	83 c4 10             	add    $0x10,%esp
    return tmp;
     fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fa5:	eb 24                	jmp    fcb <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
     fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
     faa:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     fb0:	83 ec 08             	sub    $0x8,%esp
     fb3:	50                   	push   %eax
     fb4:	ff 75 08             	pushl  0x8(%ebp)
     fb7:	e8 76 ff ff ff       	call   f32 <removeFromEnvironment>
     fbc:	83 c4 10             	add    $0x10,%esp
     fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
     fc2:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
     fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     fcb:	c9                   	leave  
     fcc:	c3                   	ret    

00000fcd <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
     fcd:	55                   	push   %ebp
     fce:	89 e5                	mov    %esp,%ebp
     fd0:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
     fd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fd7:	75 05                	jne    fde <addToEnvironment+0x11>
		return head;
     fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
     fdc:	eb 6a                	jmp    1048 <addToEnvironment+0x7b>
	if (head == NULL) {
     fde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     fe2:	75 40                	jne    1024 <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
     fe4:	83 ec 0c             	sub    $0xc,%esp
     fe7:	68 88 00 00 00       	push   $0x88
     fec:	e8 f5 f9 ff ff       	call   9e6 <malloc>
     ff1:	83 c4 10             	add    $0x10,%esp
     ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
     ff7:	8b 45 08             	mov    0x8(%ebp),%eax
     ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
     ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1000:	83 ec 08             	sub    $0x8,%esp
    1003:	ff 75 f0             	pushl  -0x10(%ebp)
    1006:	50                   	push   %eax
    1007:	e8 44 f3 ff ff       	call   350 <strcpy>
    100c:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
    100f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1012:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
    1019:	00 00 00 
		head = newVar;
    101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    101f:	89 45 0c             	mov    %eax,0xc(%ebp)
    1022:	eb 21                	jmp    1045 <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
    1024:	8b 45 0c             	mov    0xc(%ebp),%eax
    1027:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    102d:	83 ec 08             	sub    $0x8,%esp
    1030:	50                   	push   %eax
    1031:	ff 75 08             	pushl  0x8(%ebp)
    1034:	e8 94 ff ff ff       	call   fcd <addToEnvironment>
    1039:	83 c4 10             	add    $0x10,%esp
    103c:	8b 55 0c             	mov    0xc(%ebp),%edx
    103f:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
    1045:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    1048:	c9                   	leave  
    1049:	c3                   	ret    

0000104a <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
    104a:	55                   	push   %ebp
    104b:	89 e5                	mov    %esp,%ebp
    104d:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
    1050:	83 ec 08             	sub    $0x8,%esp
    1053:	ff 75 0c             	pushl  0xc(%ebp)
    1056:	ff 75 08             	pushl  0x8(%ebp)
    1059:	e8 90 fe ff ff       	call   eee <environLookup>
    105e:	83 c4 10             	add    $0x10,%esp
    1061:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
    1064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1068:	75 05                	jne    106f <addValueToVariable+0x25>
		return head;
    106a:	8b 45 0c             	mov    0xc(%ebp),%eax
    106d:	eb 4c                	jmp    10bb <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
    106f:	83 ec 0c             	sub    $0xc,%esp
    1072:	68 04 04 00 00       	push   $0x404
    1077:	e8 6a f9 ff ff       	call   9e6 <malloc>
    107c:	83 c4 10             	add    $0x10,%esp
    107f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
    1082:	8b 45 10             	mov    0x10(%ebp),%eax
    1085:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
    1088:	8b 45 f0             	mov    -0x10(%ebp),%eax
    108b:	83 ec 08             	sub    $0x8,%esp
    108e:	ff 75 ec             	pushl  -0x14(%ebp)
    1091:	50                   	push   %eax
    1092:	e8 b9 f2 ff ff       	call   350 <strcpy>
    1097:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
    109a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    109d:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
    10a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10a6:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
    10ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10af:	8b 55 f0             	mov    -0x10(%ebp),%edx
    10b2:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
    10b8:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    10bb:	c9                   	leave  
    10bc:	c3                   	ret    

000010bd <freeEnvironment>:

void freeEnvironment(variable* head)
{
    10bd:	55                   	push   %ebp
    10be:	89 e5                	mov    %esp,%ebp
    10c0:	83 ec 08             	sub    $0x8,%esp
  if (!head)
    10c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10c7:	75 02                	jne    10cb <freeEnvironment+0xe>
    return;  
    10c9:	eb 38                	jmp    1103 <freeEnvironment+0x46>
  freeEnvironment(head->next);
    10cb:	8b 45 08             	mov    0x8(%ebp),%eax
    10ce:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    10d4:	83 ec 0c             	sub    $0xc,%esp
    10d7:	50                   	push   %eax
    10d8:	e8 e0 ff ff ff       	call   10bd <freeEnvironment>
    10dd:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
    10e0:	8b 45 08             	mov    0x8(%ebp),%eax
    10e3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
    10e9:	83 ec 0c             	sub    $0xc,%esp
    10ec:	50                   	push   %eax
    10ed:	e8 13 00 00 00       	call   1105 <freeVarval>
    10f2:	83 c4 10             	add    $0x10,%esp
  free(head);
    10f5:	83 ec 0c             	sub    $0xc,%esp
    10f8:	ff 75 08             	pushl  0x8(%ebp)
    10fb:	e8 a5 f7 ff ff       	call   8a5 <free>
    1100:	83 c4 10             	add    $0x10,%esp
}
    1103:	c9                   	leave  
    1104:	c3                   	ret    

00001105 <freeVarval>:

void freeVarval(varval* head)
{
    1105:	55                   	push   %ebp
    1106:	89 e5                	mov    %esp,%ebp
    1108:	83 ec 08             	sub    $0x8,%esp
  if (!head)
    110b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    110f:	75 02                	jne    1113 <freeVarval+0xe>
    return;  
    1111:	eb 23                	jmp    1136 <freeVarval+0x31>
  freeVarval(head->next);
    1113:	8b 45 08             	mov    0x8(%ebp),%eax
    1116:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
    111c:	83 ec 0c             	sub    $0xc,%esp
    111f:	50                   	push   %eax
    1120:	e8 e0 ff ff ff       	call   1105 <freeVarval>
    1125:	83 c4 10             	add    $0x10,%esp
  free(head);
    1128:	83 ec 0c             	sub    $0xc,%esp
    112b:	ff 75 08             	pushl  0x8(%ebp)
    112e:	e8 72 f7 ff ff       	call   8a5 <free>
    1133:	83 c4 10             	add    $0x10,%esp
}
    1136:	c9                   	leave  
    1137:	c3                   	ret    

00001138 <getPaths>:

varval* getPaths(char* paths, varval* head) {
    1138:	55                   	push   %ebp
    1139:	89 e5                	mov    %esp,%ebp
    113b:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
    113e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1142:	75 08                	jne    114c <getPaths+0x14>
		return head;
    1144:	8b 45 0c             	mov    0xc(%ebp),%eax
    1147:	e9 e7 00 00 00       	jmp    1233 <getPaths+0xfb>
	if (head == NULL) {
    114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1150:	0f 85 b9 00 00 00    	jne    120f <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
    1156:	83 ec 08             	sub    $0x8,%esp
    1159:	6a 3a                	push   $0x3a
    115b:	ff 75 08             	pushl  0x8(%ebp)
    115e:	e8 9d f2 ff ff       	call   400 <strchr>
    1163:	83 c4 10             	add    $0x10,%esp
    1166:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
    1169:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    116d:	75 56                	jne    11c5 <getPaths+0x8d>
			pathLen = strlen(paths);
    116f:	83 ec 0c             	sub    $0xc,%esp
    1172:	ff 75 08             	pushl  0x8(%ebp)
    1175:	e8 45 f2 ff ff       	call   3bf <strlen>
    117a:	83 c4 10             	add    $0x10,%esp
    117d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
    1180:	83 ec 0c             	sub    $0xc,%esp
    1183:	68 04 04 00 00       	push   $0x404
    1188:	e8 59 f8 ff ff       	call   9e6 <malloc>
    118d:	83 c4 10             	add    $0x10,%esp
    1190:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
    1193:	8b 45 0c             	mov    0xc(%ebp),%eax
    1196:	83 ec 04             	sub    $0x4,%esp
    1199:	ff 75 f0             	pushl  -0x10(%ebp)
    119c:	ff 75 08             	pushl  0x8(%ebp)
    119f:	50                   	push   %eax
    11a0:	e8 c5 f9 ff ff       	call   b6a <strncpy>
    11a5:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
    11a8:	8b 55 0c             	mov    0xc(%ebp),%edx
    11ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11ae:	01 d0                	add    %edx,%eax
    11b0:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
    11b3:	8b 45 0c             	mov    0xc(%ebp),%eax
    11b6:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
    11bd:	00 00 00 
			return head;
    11c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c3:	eb 6e                	jmp    1233 <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
    11c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11c8:	8b 45 08             	mov    0x8(%ebp),%eax
    11cb:	29 c2                	sub    %eax,%edx
    11cd:	89 d0                	mov    %edx,%eax
    11cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
    11d2:	83 ec 0c             	sub    $0xc,%esp
    11d5:	68 04 04 00 00       	push   $0x404
    11da:	e8 07 f8 ff ff       	call   9e6 <malloc>
    11df:	83 c4 10             	add    $0x10,%esp
    11e2:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
    11e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e8:	83 ec 04             	sub    $0x4,%esp
    11eb:	ff 75 f0             	pushl  -0x10(%ebp)
    11ee:	ff 75 08             	pushl  0x8(%ebp)
    11f1:	50                   	push   %eax
    11f2:	e8 73 f9 ff ff       	call   b6a <strncpy>
    11f7:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
    11fa:	8b 55 0c             	mov    0xc(%ebp),%edx
    11fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1200:	01 d0                	add    %edx,%eax
    1202:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
    1205:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1208:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
    120b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
    120f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1212:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
    1218:	83 ec 08             	sub    $0x8,%esp
    121b:	50                   	push   %eax
    121c:	ff 75 08             	pushl  0x8(%ebp)
    121f:	e8 14 ff ff ff       	call   1138 <getPaths>
    1224:	83 c4 10             	add    $0x10,%esp
    1227:	8b 55 0c             	mov    0xc(%ebp),%edx
    122a:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
    1230:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    1233:	c9                   	leave  
    1234:	c3                   	ret    
