
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
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bb 00 00 00       	jmp    cd <grep+0xcd>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 51                	jmp    72 <grep+0x72>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 bc 01 00 00       	call   1f5 <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2c                	je     69 <grep+0x69>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	83 c0 01             	add    $0x1,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4e:	29 c2                	sub    %eax,%edx
  50:	89 d0                	mov    %edx,%eax
  52:	89 44 24 08          	mov    %eax,0x8(%esp)
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	89 44 24 04          	mov    %eax,0x4(%esp)
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 74 05 00 00       	call   5dd <write>
      }
      p = q+1;
  69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6c:	83 c0 01             	add    $0x1,%eax
  6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  72:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  79:	00 
  7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7d:	89 04 24             	mov    %eax,(%esp)
  80:	e8 af 03 00 00       	call   434 <strchr>
  85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8c:	75 93                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8e:	81 7d f0 60 0e 00 00 	cmpl   $0xe60,-0x10(%ebp)
  95:	75 07                	jne    9e <grep+0x9e>
      m = 0;
  97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	7e 29                	jle    cd <grep+0xcd>
      m -= p - buf;
  a4:	ba 60 0e 00 00       	mov    $0xe60,%edx
  a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ac:	29 c2                	sub    %eax,%edx
  ae:	89 d0                	mov    %edx,%eax
  b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  c1:	c7 04 24 60 0e 00 00 	movl   $0xe60,(%esp)
  c8:	e8 ab 04 00 00       	call   578 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d0:	ba 00 04 00 00       	mov    $0x400,%edx
  d5:	29 c2                	sub    %eax,%edx
  d7:	89 d0                	mov    %edx,%eax
  d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  dc:	81 c2 60 0e 00 00    	add    $0xe60,%edx
  e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	89 04 24             	mov    %eax,(%esp)
  f0:	e8 e0 04 00 00       	call   5d5 <read>
  f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  fc:	0f 8f 10 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <main>:

int
main(int argc, char *argv[])
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 e4 f0             	and    $0xfffffff0,%esp
 10a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 10d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 111:	7f 19                	jg     12c <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 113:	c7 44 24 04 0c 0b 00 	movl   $0xb0c,0x4(%esp)
 11a:	00 
 11b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 122:	e8 16 06 00 00       	call   73d <printf>
    exit();
 127:	e8 91 04 00 00       	call   5bd <exit>
  }
  pattern = argv[1];
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	8b 40 04             	mov    0x4(%eax),%eax
 132:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 136:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 13a:	7f 19                	jg     155 <main+0x51>
    grep(pattern, 0);
 13c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 143:	00 
 144:	8b 44 24 18          	mov    0x18(%esp),%eax
 148:	89 04 24             	mov    %eax,(%esp)
 14b:	e8 b0 fe ff ff       	call   0 <grep>
    exit();
 150:	e8 68 04 00 00       	call   5bd <exit>
  }

  for(i = 2; i < argc; i++){
 155:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 15c:	00 
 15d:	e9 81 00 00 00       	jmp    1e3 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
 162:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 16d:	8b 45 0c             	mov    0xc(%ebp),%eax
 170:	01 d0                	add    %edx,%eax
 172:	8b 00                	mov    (%eax),%eax
 174:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 17b:	00 
 17c:	89 04 24             	mov    %eax,(%esp)
 17f:	e8 79 04 00 00       	call   5fd <open>
 184:	89 44 24 14          	mov    %eax,0x14(%esp)
 188:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 18d:	79 2f                	jns    1be <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 18f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 193:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	01 d0                	add    %edx,%eax
 19f:	8b 00                	mov    (%eax),%eax
 1a1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a5:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
 1ac:	00 
 1ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b4:	e8 84 05 00 00       	call   73d <printf>
      exit();
 1b9:	e8 ff 03 00 00       	call   5bd <exit>
    }
    grep(pattern, fd);
 1be:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ca:	89 04 24             	mov    %eax,(%esp)
 1cd:	e8 2e fe ff ff       	call   0 <grep>
    close(fd);
 1d2:	8b 44 24 14          	mov    0x14(%esp),%eax
 1d6:	89 04 24             	mov    %eax,(%esp)
 1d9:	e8 07 04 00 00       	call   5e5 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1de:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1e3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1e7:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ea:	0f 8c 72 ff ff ff    	jl     162 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1f0:	e8 c8 03 00 00       	call   5bd <exit>

000001f5 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	0f b6 00             	movzbl (%eax),%eax
 201:	3c 5e                	cmp    $0x5e,%al
 203:	75 17                	jne    21c <match+0x27>
    return matchhere(re+1, text);
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8d 50 01             	lea    0x1(%eax),%edx
 20b:	8b 45 0c             	mov    0xc(%ebp),%eax
 20e:	89 44 24 04          	mov    %eax,0x4(%esp)
 212:	89 14 24             	mov    %edx,(%esp)
 215:	e8 36 00 00 00       	call   250 <matchhere>
 21a:	eb 32                	jmp    24e <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 21c:	8b 45 0c             	mov    0xc(%ebp),%eax
 21f:	89 44 24 04          	mov    %eax,0x4(%esp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	89 04 24             	mov    %eax,(%esp)
 229:	e8 22 00 00 00       	call   250 <matchhere>
 22e:	85 c0                	test   %eax,%eax
 230:	74 07                	je     239 <match+0x44>
      return 1;
 232:	b8 01 00 00 00       	mov    $0x1,%eax
 237:	eb 15                	jmp    24e <match+0x59>
  }while(*text++ != '\0');
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	8d 50 01             	lea    0x1(%eax),%edx
 23f:	89 55 0c             	mov    %edx,0xc(%ebp)
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	75 d3                	jne    21c <match+0x27>
  return 0;
 249:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	84 c0                	test   %al,%al
 25e:	75 0a                	jne    26a <matchhere+0x1a>
    return 1;
 260:	b8 01 00 00 00       	mov    $0x1,%eax
 265:	e9 9b 00 00 00       	jmp    305 <matchhere+0xb5>
  if(re[1] == '*')
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	83 c0 01             	add    $0x1,%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2a                	cmp    $0x2a,%al
 275:	75 24                	jne    29b <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	8d 48 02             	lea    0x2(%eax),%ecx
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	0f b6 00             	movzbl (%eax),%eax
 283:	0f be c0             	movsbl %al,%eax
 286:	8b 55 0c             	mov    0xc(%ebp),%edx
 289:	89 54 24 08          	mov    %edx,0x8(%esp)
 28d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 291:	89 04 24             	mov    %eax,(%esp)
 294:	e8 6e 00 00 00       	call   307 <matchstar>
 299:	eb 6a                	jmp    305 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	3c 24                	cmp    $0x24,%al
 2a3:	75 1d                	jne    2c2 <matchhere+0x72>
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	83 c0 01             	add    $0x1,%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	84 c0                	test   %al,%al
 2b0:	75 10                	jne    2c2 <matchhere+0x72>
    return *text == '\0';
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	84 c0                	test   %al,%al
 2ba:	0f 94 c0             	sete   %al
 2bd:	0f b6 c0             	movzbl %al,%eax
 2c0:	eb 43                	jmp    305 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c5:	0f b6 00             	movzbl (%eax),%eax
 2c8:	84 c0                	test   %al,%al
 2ca:	74 34                	je     300 <matchhere+0xb0>
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	3c 2e                	cmp    $0x2e,%al
 2d4:	74 10                	je     2e6 <matchhere+0x96>
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	0f b6 10             	movzbl (%eax),%edx
 2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	38 c2                	cmp    %al,%dl
 2e4:	75 1a                	jne    300 <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e9:	8d 50 01             	lea    0x1(%eax),%edx
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	83 c0 01             	add    $0x1,%eax
 2f2:	89 54 24 04          	mov    %edx,0x4(%esp)
 2f6:	89 04 24             	mov    %eax,(%esp)
 2f9:	e8 52 ff ff ff       	call   250 <matchhere>
 2fe:	eb 05                	jmp    305 <matchhere+0xb5>
  return 0;
 300:	b8 00 00 00 00       	mov    $0x0,%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 307:	55                   	push   %ebp
 308:	89 e5                	mov    %esp,%ebp
 30a:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 30d:	8b 45 10             	mov    0x10(%ebp),%eax
 310:	89 44 24 04          	mov    %eax,0x4(%esp)
 314:	8b 45 0c             	mov    0xc(%ebp),%eax
 317:	89 04 24             	mov    %eax,(%esp)
 31a:	e8 31 ff ff ff       	call   250 <matchhere>
 31f:	85 c0                	test   %eax,%eax
 321:	74 07                	je     32a <matchstar+0x23>
      return 1;
 323:	b8 01 00 00 00       	mov    $0x1,%eax
 328:	eb 29                	jmp    353 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 32a:	8b 45 10             	mov    0x10(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	84 c0                	test   %al,%al
 332:	74 1a                	je     34e <matchstar+0x47>
 334:	8b 45 10             	mov    0x10(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 10             	mov    %edx,0x10(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	3b 45 08             	cmp    0x8(%ebp),%eax
 346:	74 c5                	je     30d <matchstar+0x6>
 348:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 34c:	74 bf                	je     30d <matchstar+0x6>
  return 0;
 34e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	57                   	push   %edi
 359:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 35a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35d:	8b 55 10             	mov    0x10(%ebp),%edx
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	89 cb                	mov    %ecx,%ebx
 365:	89 df                	mov    %ebx,%edi
 367:	89 d1                	mov    %edx,%ecx
 369:	fc                   	cld    
 36a:	f3 aa                	rep stos %al,%es:(%edi)
 36c:	89 ca                	mov    %ecx,%edx
 36e:	89 fb                	mov    %edi,%ebx
 370:	89 5d 08             	mov    %ebx,0x8(%ebp)
 373:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 376:	5b                   	pop    %ebx
 377:	5f                   	pop    %edi
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    

0000037a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp
 37d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 386:	90                   	nop
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	8d 50 01             	lea    0x1(%eax),%edx
 38d:	89 55 08             	mov    %edx,0x8(%ebp)
 390:	8b 55 0c             	mov    0xc(%ebp),%edx
 393:	8d 4a 01             	lea    0x1(%edx),%ecx
 396:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 399:	0f b6 12             	movzbl (%edx),%edx
 39c:	88 10                	mov    %dl,(%eax)
 39e:	0f b6 00             	movzbl (%eax),%eax
 3a1:	84 c0                	test   %al,%al
 3a3:	75 e2                	jne    387 <strcpy+0xd>
    ;
  return os;
 3a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a8:	c9                   	leave  
 3a9:	c3                   	ret    

000003aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3ad:	eb 08                	jmp    3b7 <strcmp+0xd>
    p++, q++;
 3af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	84 c0                	test   %al,%al
 3bf:	74 10                	je     3d1 <strcmp+0x27>
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	0f b6 10             	movzbl (%eax),%edx
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	38 c2                	cmp    %al,%dl
 3cf:	74 de                	je     3af <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	0f b6 d0             	movzbl %al,%edx
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	0f b6 c0             	movzbl %al,%eax
 3e3:	29 c2                	sub    %eax,%edx
 3e5:	89 d0                	mov    %edx,%eax
}
 3e7:	5d                   	pop    %ebp
 3e8:	c3                   	ret    

000003e9 <strlen>:

uint
strlen(char *s)
{
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp
 3ec:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f6:	eb 04                	jmp    3fc <strlen+0x13>
 3f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
 402:	01 d0                	add    %edx,%eax
 404:	0f b6 00             	movzbl (%eax),%eax
 407:	84 c0                	test   %al,%al
 409:	75 ed                	jne    3f8 <strlen+0xf>
    ;
  return n;
 40b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 40e:	c9                   	leave  
 40f:	c3                   	ret    

00000410 <memset>:

void*
memset(void *dst, int c, uint n)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 416:	8b 45 10             	mov    0x10(%ebp),%eax
 419:	89 44 24 08          	mov    %eax,0x8(%esp)
 41d:	8b 45 0c             	mov    0xc(%ebp),%eax
 420:	89 44 24 04          	mov    %eax,0x4(%esp)
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	89 04 24             	mov    %eax,(%esp)
 42a:	e8 26 ff ff ff       	call   355 <stosb>
  return dst;
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <strchr>:

char*
strchr(const char *s, char c)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 04             	sub    $0x4,%esp
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 440:	eb 14                	jmp    456 <strchr+0x22>
    if(*s == c)
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	0f b6 00             	movzbl (%eax),%eax
 448:	3a 45 fc             	cmp    -0x4(%ebp),%al
 44b:	75 05                	jne    452 <strchr+0x1e>
      return (char*)s;
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	eb 13                	jmp    465 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 452:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 456:	8b 45 08             	mov    0x8(%ebp),%eax
 459:	0f b6 00             	movzbl (%eax),%eax
 45c:	84 c0                	test   %al,%al
 45e:	75 e2                	jne    442 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 460:	b8 00 00 00 00       	mov    $0x0,%eax
}
 465:	c9                   	leave  
 466:	c3                   	ret    

00000467 <gets>:

char*
gets(char *buf, int max)
{
 467:	55                   	push   %ebp
 468:	89 e5                	mov    %esp,%ebp
 46a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 474:	eb 4c                	jmp    4c2 <gets+0x5b>
    cc = read(0, &c, 1);
 476:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 47d:	00 
 47e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 481:	89 44 24 04          	mov    %eax,0x4(%esp)
 485:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 48c:	e8 44 01 00 00       	call   5d5 <read>
 491:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 498:	7f 02                	jg     49c <gets+0x35>
      break;
 49a:	eb 31                	jmp    4cd <gets+0x66>
    buf[i++] = c;
 49c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49f:	8d 50 01             	lea    0x1(%eax),%edx
 4a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a5:	89 c2                	mov    %eax,%edx
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	01 c2                	add    %eax,%edx
 4ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b6:	3c 0a                	cmp    $0xa,%al
 4b8:	74 13                	je     4cd <gets+0x66>
 4ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4be:	3c 0d                	cmp    $0xd,%al
 4c0:	74 0b                	je     4cd <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c5:	83 c0 01             	add    $0x1,%eax
 4c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4cb:	7c a9                	jl     476 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	01 d0                	add    %edx,%eax
 4d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4db:	c9                   	leave  
 4dc:	c3                   	ret    

000004dd <stat>:

int
stat(char *n, struct stat *st)
{
 4dd:	55                   	push   %ebp
 4de:	89 e5                	mov    %esp,%ebp
 4e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4ea:	00 
 4eb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ee:	89 04 24             	mov    %eax,(%esp)
 4f1:	e8 07 01 00 00       	call   5fd <open>
 4f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fd:	79 07                	jns    506 <stat+0x29>
    return -1;
 4ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 504:	eb 23                	jmp    529 <stat+0x4c>
  r = fstat(fd, st);
 506:	8b 45 0c             	mov    0xc(%ebp),%eax
 509:	89 44 24 04          	mov    %eax,0x4(%esp)
 50d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 510:	89 04 24             	mov    %eax,(%esp)
 513:	e8 fd 00 00 00       	call   615 <fstat>
 518:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	89 04 24             	mov    %eax,(%esp)
 521:	e8 bf 00 00 00       	call   5e5 <close>
  return r;
 526:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 529:	c9                   	leave  
 52a:	c3                   	ret    

0000052b <atoi>:

int
atoi(const char *s)
{
 52b:	55                   	push   %ebp
 52c:	89 e5                	mov    %esp,%ebp
 52e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 531:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 538:	eb 25                	jmp    55f <atoi+0x34>
    n = n*10 + *s++ - '0';
 53a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 53d:	89 d0                	mov    %edx,%eax
 53f:	c1 e0 02             	shl    $0x2,%eax
 542:	01 d0                	add    %edx,%eax
 544:	01 c0                	add    %eax,%eax
 546:	89 c1                	mov    %eax,%ecx
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	8d 50 01             	lea    0x1(%eax),%edx
 54e:	89 55 08             	mov    %edx,0x8(%ebp)
 551:	0f b6 00             	movzbl (%eax),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	01 c8                	add    %ecx,%eax
 559:	83 e8 30             	sub    $0x30,%eax
 55c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	3c 2f                	cmp    $0x2f,%al
 567:	7e 0a                	jle    573 <atoi+0x48>
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	0f b6 00             	movzbl (%eax),%eax
 56f:	3c 39                	cmp    $0x39,%al
 571:	7e c7                	jle    53a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 573:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 576:	c9                   	leave  
 577:	c3                   	ret    

00000578 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 57e:	8b 45 08             	mov    0x8(%ebp),%eax
 581:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 584:	8b 45 0c             	mov    0xc(%ebp),%eax
 587:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 58a:	eb 17                	jmp    5a3 <memmove+0x2b>
    *dst++ = *src++;
 58c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 58f:	8d 50 01             	lea    0x1(%eax),%edx
 592:	89 55 fc             	mov    %edx,-0x4(%ebp)
 595:	8b 55 f8             	mov    -0x8(%ebp),%edx
 598:	8d 4a 01             	lea    0x1(%edx),%ecx
 59b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 59e:	0f b6 12             	movzbl (%edx),%edx
 5a1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5a3:	8b 45 10             	mov    0x10(%ebp),%eax
 5a6:	8d 50 ff             	lea    -0x1(%eax),%edx
 5a9:	89 55 10             	mov    %edx,0x10(%ebp)
 5ac:	85 c0                	test   %eax,%eax
 5ae:	7f dc                	jg     58c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b3:	c9                   	leave  
 5b4:	c3                   	ret    

000005b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5b5:	b8 01 00 00 00       	mov    $0x1,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <exit>:
SYSCALL(exit)
 5bd:	b8 02 00 00 00       	mov    $0x2,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <wait>:
SYSCALL(wait)
 5c5:	b8 03 00 00 00       	mov    $0x3,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <pipe>:
SYSCALL(pipe)
 5cd:	b8 04 00 00 00       	mov    $0x4,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <read>:
SYSCALL(read)
 5d5:	b8 05 00 00 00       	mov    $0x5,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <write>:
SYSCALL(write)
 5dd:	b8 10 00 00 00       	mov    $0x10,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <close>:
SYSCALL(close)
 5e5:	b8 15 00 00 00       	mov    $0x15,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <kill>:
SYSCALL(kill)
 5ed:	b8 06 00 00 00       	mov    $0x6,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <exec>:
SYSCALL(exec)
 5f5:	b8 07 00 00 00       	mov    $0x7,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <open>:
SYSCALL(open)
 5fd:	b8 0f 00 00 00       	mov    $0xf,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <mknod>:
SYSCALL(mknod)
 605:	b8 11 00 00 00       	mov    $0x11,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <unlink>:
SYSCALL(unlink)
 60d:	b8 12 00 00 00       	mov    $0x12,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <fstat>:
SYSCALL(fstat)
 615:	b8 08 00 00 00       	mov    $0x8,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <link>:
SYSCALL(link)
 61d:	b8 13 00 00 00       	mov    $0x13,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <mkdir>:
SYSCALL(mkdir)
 625:	b8 14 00 00 00       	mov    $0x14,%eax
 62a:	cd 40                	int    $0x40
 62c:	c3                   	ret    

0000062d <chdir>:
SYSCALL(chdir)
 62d:	b8 09 00 00 00       	mov    $0x9,%eax
 632:	cd 40                	int    $0x40
 634:	c3                   	ret    

00000635 <dup>:
SYSCALL(dup)
 635:	b8 0a 00 00 00       	mov    $0xa,%eax
 63a:	cd 40                	int    $0x40
 63c:	c3                   	ret    

0000063d <getpid>:
SYSCALL(getpid)
 63d:	b8 0b 00 00 00       	mov    $0xb,%eax
 642:	cd 40                	int    $0x40
 644:	c3                   	ret    

00000645 <sbrk>:
SYSCALL(sbrk)
 645:	b8 0c 00 00 00       	mov    $0xc,%eax
 64a:	cd 40                	int    $0x40
 64c:	c3                   	ret    

0000064d <sleep>:
SYSCALL(sleep)
 64d:	b8 0d 00 00 00       	mov    $0xd,%eax
 652:	cd 40                	int    $0x40
 654:	c3                   	ret    

00000655 <uptime>:
SYSCALL(uptime)
 655:	b8 0e 00 00 00       	mov    $0xe,%eax
 65a:	cd 40                	int    $0x40
 65c:	c3                   	ret    

0000065d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 65d:	55                   	push   %ebp
 65e:	89 e5                	mov    %esp,%ebp
 660:	83 ec 18             	sub    $0x18,%esp
 663:	8b 45 0c             	mov    0xc(%ebp),%eax
 666:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 669:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 670:	00 
 671:	8d 45 f4             	lea    -0xc(%ebp),%eax
 674:	89 44 24 04          	mov    %eax,0x4(%esp)
 678:	8b 45 08             	mov    0x8(%ebp),%eax
 67b:	89 04 24             	mov    %eax,(%esp)
 67e:	e8 5a ff ff ff       	call   5dd <write>
}
 683:	c9                   	leave  
 684:	c3                   	ret    

00000685 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 685:	55                   	push   %ebp
 686:	89 e5                	mov    %esp,%ebp
 688:	56                   	push   %esi
 689:	53                   	push   %ebx
 68a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 68d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 694:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 698:	74 17                	je     6b1 <printint+0x2c>
 69a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 69e:	79 11                	jns    6b1 <printint+0x2c>
    neg = 1;
 6a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6aa:	f7 d8                	neg    %eax
 6ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6af:	eb 06                	jmp    6b7 <printint+0x32>
  } else {
    x = xx;
 6b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6c1:	8d 41 01             	lea    0x1(%ecx),%eax
 6c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6cd:	ba 00 00 00 00       	mov    $0x0,%edx
 6d2:	f7 f3                	div    %ebx
 6d4:	89 d0                	mov    %edx,%eax
 6d6:	0f b6 80 10 0e 00 00 	movzbl 0xe10(%eax),%eax
 6dd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6e1:	8b 75 10             	mov    0x10(%ebp),%esi
 6e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6e7:	ba 00 00 00 00       	mov    $0x0,%edx
 6ec:	f7 f6                	div    %esi
 6ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6f5:	75 c7                	jne    6be <printint+0x39>
  if(neg)
 6f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fb:	74 10                	je     70d <printint+0x88>
    buf[i++] = '-';
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	8d 50 01             	lea    0x1(%eax),%edx
 703:	89 55 f4             	mov    %edx,-0xc(%ebp)
 706:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 70b:	eb 1f                	jmp    72c <printint+0xa7>
 70d:	eb 1d                	jmp    72c <printint+0xa7>
    putc(fd, buf[i]);
 70f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 712:	8b 45 f4             	mov    -0xc(%ebp),%eax
 715:	01 d0                	add    %edx,%eax
 717:	0f b6 00             	movzbl (%eax),%eax
 71a:	0f be c0             	movsbl %al,%eax
 71d:	89 44 24 04          	mov    %eax,0x4(%esp)
 721:	8b 45 08             	mov    0x8(%ebp),%eax
 724:	89 04 24             	mov    %eax,(%esp)
 727:	e8 31 ff ff ff       	call   65d <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 72c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 734:	79 d9                	jns    70f <printint+0x8a>
    putc(fd, buf[i]);
}
 736:	83 c4 30             	add    $0x30,%esp
 739:	5b                   	pop    %ebx
 73a:	5e                   	pop    %esi
 73b:	5d                   	pop    %ebp
 73c:	c3                   	ret    

0000073d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 73d:	55                   	push   %ebp
 73e:	89 e5                	mov    %esp,%ebp
 740:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 743:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 74a:	8d 45 0c             	lea    0xc(%ebp),%eax
 74d:	83 c0 04             	add    $0x4,%eax
 750:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 753:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 75a:	e9 7c 01 00 00       	jmp    8db <printf+0x19e>
    c = fmt[i] & 0xff;
 75f:	8b 55 0c             	mov    0xc(%ebp),%edx
 762:	8b 45 f0             	mov    -0x10(%ebp),%eax
 765:	01 d0                	add    %edx,%eax
 767:	0f b6 00             	movzbl (%eax),%eax
 76a:	0f be c0             	movsbl %al,%eax
 76d:	25 ff 00 00 00       	and    $0xff,%eax
 772:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 775:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 779:	75 2c                	jne    7a7 <printf+0x6a>
      if(c == '%'){
 77b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 77f:	75 0c                	jne    78d <printf+0x50>
        state = '%';
 781:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 788:	e9 4a 01 00 00       	jmp    8d7 <printf+0x19a>
      } else {
        putc(fd, c);
 78d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 790:	0f be c0             	movsbl %al,%eax
 793:	89 44 24 04          	mov    %eax,0x4(%esp)
 797:	8b 45 08             	mov    0x8(%ebp),%eax
 79a:	89 04 24             	mov    %eax,(%esp)
 79d:	e8 bb fe ff ff       	call   65d <putc>
 7a2:	e9 30 01 00 00       	jmp    8d7 <printf+0x19a>
      }
    } else if(state == '%'){
 7a7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7ab:	0f 85 26 01 00 00    	jne    8d7 <printf+0x19a>
      if(c == 'd'){
 7b1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7b5:	75 2d                	jne    7e4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7c3:	00 
 7c4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7cb:	00 
 7cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d0:	8b 45 08             	mov    0x8(%ebp),%eax
 7d3:	89 04 24             	mov    %eax,(%esp)
 7d6:	e8 aa fe ff ff       	call   685 <printint>
        ap++;
 7db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7df:	e9 ec 00 00 00       	jmp    8d0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 7e4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7e8:	74 06                	je     7f0 <printf+0xb3>
 7ea:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ee:	75 2d                	jne    81d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7fc:	00 
 7fd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 804:	00 
 805:	89 44 24 04          	mov    %eax,0x4(%esp)
 809:	8b 45 08             	mov    0x8(%ebp),%eax
 80c:	89 04 24             	mov    %eax,(%esp)
 80f:	e8 71 fe ff ff       	call   685 <printint>
        ap++;
 814:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 818:	e9 b3 00 00 00       	jmp    8d0 <printf+0x193>
      } else if(c == 's'){
 81d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 821:	75 45                	jne    868 <printf+0x12b>
        s = (char*)*ap;
 823:	8b 45 e8             	mov    -0x18(%ebp),%eax
 826:	8b 00                	mov    (%eax),%eax
 828:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 82b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 82f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 833:	75 09                	jne    83e <printf+0x101>
          s = "(null)";
 835:	c7 45 f4 42 0b 00 00 	movl   $0xb42,-0xc(%ebp)
        while(*s != 0){
 83c:	eb 1e                	jmp    85c <printf+0x11f>
 83e:	eb 1c                	jmp    85c <printf+0x11f>
          putc(fd, *s);
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	0f b6 00             	movzbl (%eax),%eax
 846:	0f be c0             	movsbl %al,%eax
 849:	89 44 24 04          	mov    %eax,0x4(%esp)
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
 850:	89 04 24             	mov    %eax,(%esp)
 853:	e8 05 fe ff ff       	call   65d <putc>
          s++;
 858:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	0f b6 00             	movzbl (%eax),%eax
 862:	84 c0                	test   %al,%al
 864:	75 da                	jne    840 <printf+0x103>
 866:	eb 68                	jmp    8d0 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 868:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 86c:	75 1d                	jne    88b <printf+0x14e>
        putc(fd, *ap);
 86e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	0f be c0             	movsbl %al,%eax
 876:	89 44 24 04          	mov    %eax,0x4(%esp)
 87a:	8b 45 08             	mov    0x8(%ebp),%eax
 87d:	89 04 24             	mov    %eax,(%esp)
 880:	e8 d8 fd ff ff       	call   65d <putc>
        ap++;
 885:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 889:	eb 45                	jmp    8d0 <printf+0x193>
      } else if(c == '%'){
 88b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 88f:	75 17                	jne    8a8 <printf+0x16b>
        putc(fd, c);
 891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 894:	0f be c0             	movsbl %al,%eax
 897:	89 44 24 04          	mov    %eax,0x4(%esp)
 89b:	8b 45 08             	mov    0x8(%ebp),%eax
 89e:	89 04 24             	mov    %eax,(%esp)
 8a1:	e8 b7 fd ff ff       	call   65d <putc>
 8a6:	eb 28                	jmp    8d0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8a8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8af:	00 
 8b0:	8b 45 08             	mov    0x8(%ebp),%eax
 8b3:	89 04 24             	mov    %eax,(%esp)
 8b6:	e8 a2 fd ff ff       	call   65d <putc>
        putc(fd, c);
 8bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8be:	0f be c0             	movsbl %al,%eax
 8c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c5:	8b 45 08             	mov    0x8(%ebp),%eax
 8c8:	89 04 24             	mov    %eax,(%esp)
 8cb:	e8 8d fd ff ff       	call   65d <putc>
      }
      state = 0;
 8d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8d7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8db:	8b 55 0c             	mov    0xc(%ebp),%edx
 8de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e1:	01 d0                	add    %edx,%eax
 8e3:	0f b6 00             	movzbl (%eax),%eax
 8e6:	84 c0                	test   %al,%al
 8e8:	0f 85 71 fe ff ff    	jne    75f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8ee:	c9                   	leave  
 8ef:	c3                   	ret    

000008f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8f6:	8b 45 08             	mov    0x8(%ebp),%eax
 8f9:	83 e8 08             	sub    $0x8,%eax
 8fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ff:	a1 48 0e 00 00       	mov    0xe48,%eax
 904:	89 45 fc             	mov    %eax,-0x4(%ebp)
 907:	eb 24                	jmp    92d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	8b 00                	mov    (%eax),%eax
 90e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 911:	77 12                	ja     925 <free+0x35>
 913:	8b 45 f8             	mov    -0x8(%ebp),%eax
 916:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 919:	77 24                	ja     93f <free+0x4f>
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	8b 00                	mov    (%eax),%eax
 920:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 923:	77 1a                	ja     93f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 92d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 930:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 933:	76 d4                	jbe    909 <free+0x19>
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 93d:	76 ca                	jbe    909 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 93f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 94c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94f:	01 c2                	add    %eax,%edx
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8b 00                	mov    (%eax),%eax
 956:	39 c2                	cmp    %eax,%edx
 958:	75 24                	jne    97e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 95a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95d:	8b 50 04             	mov    0x4(%eax),%edx
 960:	8b 45 fc             	mov    -0x4(%ebp),%eax
 963:	8b 00                	mov    (%eax),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	01 c2                	add    %eax,%edx
 96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	8b 00                	mov    (%eax),%eax
 975:	8b 10                	mov    (%eax),%edx
 977:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97a:	89 10                	mov    %edx,(%eax)
 97c:	eb 0a                	jmp    988 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	8b 10                	mov    (%eax),%edx
 983:	8b 45 f8             	mov    -0x8(%ebp),%eax
 986:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 988:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98b:	8b 40 04             	mov    0x4(%eax),%eax
 98e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 995:	8b 45 fc             	mov    -0x4(%ebp),%eax
 998:	01 d0                	add    %edx,%eax
 99a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 99d:	75 20                	jne    9bf <free+0xcf>
    p->s.size += bp->s.size;
 99f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a2:	8b 50 04             	mov    0x4(%eax),%edx
 9a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a8:	8b 40 04             	mov    0x4(%eax),%eax
 9ab:	01 c2                	add    %eax,%edx
 9ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b6:	8b 10                	mov    (%eax),%edx
 9b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bb:	89 10                	mov    %edx,(%eax)
 9bd:	eb 08                	jmp    9c7 <free+0xd7>
  } else
    p->s.ptr = bp;
 9bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9c5:	89 10                	mov    %edx,(%eax)
  freep = p;
 9c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ca:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 9cf:	c9                   	leave  
 9d0:	c3                   	ret    

000009d1 <morecore>:

static Header*
morecore(uint nu)
{
 9d1:	55                   	push   %ebp
 9d2:	89 e5                	mov    %esp,%ebp
 9d4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9d7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9de:	77 07                	ja     9e7 <morecore+0x16>
    nu = 4096;
 9e0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9e7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ea:	c1 e0 03             	shl    $0x3,%eax
 9ed:	89 04 24             	mov    %eax,(%esp)
 9f0:	e8 50 fc ff ff       	call   645 <sbrk>
 9f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9f8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9fc:	75 07                	jne    a05 <morecore+0x34>
    return 0;
 9fe:	b8 00 00 00 00       	mov    $0x0,%eax
 a03:	eb 22                	jmp    a27 <morecore+0x56>
  hp = (Header*)p;
 a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0e:	8b 55 08             	mov    0x8(%ebp),%edx
 a11:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a17:	83 c0 08             	add    $0x8,%eax
 a1a:	89 04 24             	mov    %eax,(%esp)
 a1d:	e8 ce fe ff ff       	call   8f0 <free>
  return freep;
 a22:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a27:	c9                   	leave  
 a28:	c3                   	ret    

00000a29 <malloc>:

void*
malloc(uint nbytes)
{
 a29:	55                   	push   %ebp
 a2a:	89 e5                	mov    %esp,%ebp
 a2c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a2f:	8b 45 08             	mov    0x8(%ebp),%eax
 a32:	83 c0 07             	add    $0x7,%eax
 a35:	c1 e8 03             	shr    $0x3,%eax
 a38:	83 c0 01             	add    $0x1,%eax
 a3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a3e:	a1 48 0e 00 00       	mov    0xe48,%eax
 a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a4a:	75 23                	jne    a6f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a4c:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a56:	a3 48 0e 00 00       	mov    %eax,0xe48
 a5b:	a1 48 0e 00 00       	mov    0xe48,%eax
 a60:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a65:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 a6c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a72:	8b 00                	mov    (%eax),%eax
 a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7a:	8b 40 04             	mov    0x4(%eax),%eax
 a7d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a80:	72 4d                	jb     acf <malloc+0xa6>
      if(p->s.size == nunits)
 a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a85:	8b 40 04             	mov    0x4(%eax),%eax
 a88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a8b:	75 0c                	jne    a99 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a90:	8b 10                	mov    (%eax),%edx
 a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a95:	89 10                	mov    %edx,(%eax)
 a97:	eb 26                	jmp    abf <malloc+0x96>
      else {
        p->s.size -= nunits;
 a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9c:	8b 40 04             	mov    0x4(%eax),%eax
 a9f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aa2:	89 c2                	mov    %eax,%edx
 aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aad:	8b 40 04             	mov    0x4(%eax),%eax
 ab0:	c1 e0 03             	shl    $0x3,%eax
 ab3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 abc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac2:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aca:	83 c0 08             	add    $0x8,%eax
 acd:	eb 38                	jmp    b07 <malloc+0xde>
    }
    if(p == freep)
 acf:	a1 48 0e 00 00       	mov    0xe48,%eax
 ad4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ad7:	75 1b                	jne    af4 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 adc:	89 04 24             	mov    %eax,(%esp)
 adf:	e8 ed fe ff ff       	call   9d1 <morecore>
 ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aeb:	75 07                	jne    af4 <malloc+0xcb>
        return 0;
 aed:	b8 00 00 00 00       	mov    $0x0,%eax
 af2:	eb 13                	jmp    b07 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afd:	8b 00                	mov    (%eax),%eax
 aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b02:	e9 70 ff ff ff       	jmp    a77 <malloc+0x4e>
}
 b07:	c9                   	leave  
 b08:	c3                   	ret    
