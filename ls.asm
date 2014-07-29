
_ls:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
       7:	83 ec 0c             	sub    $0xc,%esp
       a:	ff 75 08             	pushl  0x8(%ebp)
       d:	e8 c4 03 00 00       	call   3d6 <strlen>
      12:	83 c4 10             	add    $0x10,%esp
      15:	8b 55 08             	mov    0x8(%ebp),%edx
      18:	01 d0                	add    %edx,%eax
      1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      1d:	eb 04                	jmp    23 <fmtname+0x23>
      1f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
      23:	8b 45 f4             	mov    -0xc(%ebp),%eax
      26:	3b 45 08             	cmp    0x8(%ebp),%eax
      29:	72 0a                	jb     35 <fmtname+0x35>
      2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      2e:	0f b6 00             	movzbl (%eax),%eax
      31:	3c 2f                	cmp    $0x2f,%al
      33:	75 ea                	jne    1f <fmtname+0x1f>
    ;
  p++;
      35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
      39:	83 ec 0c             	sub    $0xc,%esp
      3c:	ff 75 f4             	pushl  -0xc(%ebp)
      3f:	e8 92 03 00 00       	call   3d6 <strlen>
      44:	83 c4 10             	add    $0x10,%esp
      47:	83 f8 0d             	cmp    $0xd,%eax
      4a:	76 05                	jbe    51 <fmtname+0x51>
    return p;
      4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4f:	eb 60                	jmp    b1 <fmtname+0xb1>
  memmove(buf, p, strlen(p));
      51:	83 ec 0c             	sub    $0xc,%esp
      54:	ff 75 f4             	pushl  -0xc(%ebp)
      57:	e8 7a 03 00 00       	call   3d6 <strlen>
      5c:	83 c4 10             	add    $0x10,%esp
      5f:	83 ec 04             	sub    $0x4,%esp
      62:	50                   	push   %eax
      63:	ff 75 f4             	pushl  -0xc(%ebp)
      66:	68 14 17 00 00       	push   $0x1714
      6b:	e8 e2 04 00 00       	call   552 <memmove>
      70:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
      73:	83 ec 0c             	sub    $0xc,%esp
      76:	ff 75 f4             	pushl  -0xc(%ebp)
      79:	e8 58 03 00 00       	call   3d6 <strlen>
      7e:	83 c4 10             	add    $0x10,%esp
      81:	ba 0e 00 00 00       	mov    $0xe,%edx
      86:	89 d3                	mov    %edx,%ebx
      88:	29 c3                	sub    %eax,%ebx
      8a:	83 ec 0c             	sub    $0xc,%esp
      8d:	ff 75 f4             	pushl  -0xc(%ebp)
      90:	e8 41 03 00 00       	call   3d6 <strlen>
      95:	83 c4 10             	add    $0x10,%esp
      98:	05 14 17 00 00       	add    $0x1714,%eax
      9d:	83 ec 04             	sub    $0x4,%esp
      a0:	53                   	push   %ebx
      a1:	6a 20                	push   $0x20
      a3:	50                   	push   %eax
      a4:	e8 54 03 00 00       	call   3fd <memset>
      a9:	83 c4 10             	add    $0x10,%esp
  return buf;
      ac:	b8 14 17 00 00       	mov    $0x1714,%eax
}
      b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      b4:	c9                   	leave  
      b5:	c3                   	ret    

000000b6 <ls>:

void
ls(char *path)
{
      b6:	55                   	push   %ebp
      b7:	89 e5                	mov    %esp,%ebp
      b9:	57                   	push   %edi
      ba:	56                   	push   %esi
      bb:	53                   	push   %ebx
      bc:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
      c2:	83 ec 08             	sub    $0x8,%esp
      c5:	6a 00                	push   $0x0
      c7:	ff 75 08             	pushl  0x8(%ebp)
      ca:	e8 08 05 00 00       	call   5d7 <open>
      cf:	83 c4 10             	add    $0x10,%esp
      d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
      d9:	79 1a                	jns    f5 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
      db:	83 ec 04             	sub    $0x4,%esp
      de:	ff 75 08             	pushl  0x8(%ebp)
      e1:	68 4c 12 00 00       	push   $0x124c
      e6:	6a 02                	push   $0x2
      e8:	e8 3f 06 00 00       	call   72c <printf>
      ed:	83 c4 10             	add    $0x10,%esp
    return;
      f0:	e9 e1 01 00 00       	jmp    2d6 <ls+0x220>
  }
  
  if(fstat(fd, &st) < 0){
      f5:	83 ec 08             	sub    $0x8,%esp
      f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
      fe:	50                   	push   %eax
      ff:	ff 75 e4             	pushl  -0x1c(%ebp)
     102:	e8 e8 04 00 00       	call   5ef <fstat>
     107:	83 c4 10             	add    $0x10,%esp
     10a:	85 c0                	test   %eax,%eax
     10c:	79 28                	jns    136 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
     10e:	83 ec 04             	sub    $0x4,%esp
     111:	ff 75 08             	pushl  0x8(%ebp)
     114:	68 60 12 00 00       	push   $0x1260
     119:	6a 02                	push   $0x2
     11b:	e8 0c 06 00 00       	call   72c <printf>
     120:	83 c4 10             	add    $0x10,%esp
    close(fd);
     123:	83 ec 0c             	sub    $0xc,%esp
     126:	ff 75 e4             	pushl  -0x1c(%ebp)
     129:	e8 91 04 00 00       	call   5bf <close>
     12e:	83 c4 10             	add    $0x10,%esp
    return;
     131:	e9 a0 01 00 00       	jmp    2d6 <ls+0x220>
  }
  
  switch(st.type){
     136:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
     13d:	98                   	cwtl   
     13e:	83 f8 01             	cmp    $0x1,%eax
     141:	74 48                	je     18b <ls+0xd5>
     143:	83 f8 02             	cmp    $0x2,%eax
     146:	0f 85 7c 01 00 00    	jne    2c8 <ls+0x212>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
     14c:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
     152:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
     158:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
     15f:	0f bf d8             	movswl %ax,%ebx
     162:	83 ec 0c             	sub    $0xc,%esp
     165:	ff 75 08             	pushl  0x8(%ebp)
     168:	e8 93 fe ff ff       	call   0 <fmtname>
     16d:	83 c4 10             	add    $0x10,%esp
     170:	83 ec 08             	sub    $0x8,%esp
     173:	57                   	push   %edi
     174:	56                   	push   %esi
     175:	53                   	push   %ebx
     176:	50                   	push   %eax
     177:	68 74 12 00 00       	push   $0x1274
     17c:	6a 01                	push   $0x1
     17e:	e8 a9 05 00 00       	call   72c <printf>
     183:	83 c4 20             	add    $0x20,%esp
    break;
     186:	e9 3d 01 00 00       	jmp    2c8 <ls+0x212>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
     18b:	83 ec 0c             	sub    $0xc,%esp
     18e:	ff 75 08             	pushl  0x8(%ebp)
     191:	e8 40 02 00 00       	call   3d6 <strlen>
     196:	83 c4 10             	add    $0x10,%esp
     199:	83 c0 10             	add    $0x10,%eax
     19c:	3d 00 02 00 00       	cmp    $0x200,%eax
     1a1:	76 17                	jbe    1ba <ls+0x104>
      printf(1, "ls: path too long\n");
     1a3:	83 ec 08             	sub    $0x8,%esp
     1a6:	68 81 12 00 00       	push   $0x1281
     1ab:	6a 01                	push   $0x1
     1ad:	e8 7a 05 00 00       	call   72c <printf>
     1b2:	83 c4 10             	add    $0x10,%esp
      break;
     1b5:	e9 0e 01 00 00       	jmp    2c8 <ls+0x212>
    }
    strcpy(buf, path);
     1ba:	83 ec 08             	sub    $0x8,%esp
     1bd:	ff 75 08             	pushl  0x8(%ebp)
     1c0:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1c6:	50                   	push   %eax
     1c7:	e8 9b 01 00 00       	call   367 <strcpy>
     1cc:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
     1cf:	83 ec 0c             	sub    $0xc,%esp
     1d2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1d8:	50                   	push   %eax
     1d9:	e8 f8 01 00 00       	call   3d6 <strlen>
     1de:	83 c4 10             	add    $0x10,%esp
     1e1:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
     1e7:	01 d0                	add    %edx,%eax
     1e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
     1ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ef:	8d 50 01             	lea    0x1(%eax),%edx
     1f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
     1f5:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     1f8:	e9 aa 00 00 00       	jmp    2a7 <ls+0x1f1>
      if(de.inum == 0)
     1fd:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
     204:	66 85 c0             	test   %ax,%ax
     207:	75 05                	jne    20e <ls+0x158>
        continue;
     209:	e9 99 00 00 00       	jmp    2a7 <ls+0x1f1>
      memmove(p, de.name, DIRSIZ);
     20e:	83 ec 04             	sub    $0x4,%esp
     211:	6a 0e                	push   $0xe
     213:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     219:	83 c0 02             	add    $0x2,%eax
     21c:	50                   	push   %eax
     21d:	ff 75 e0             	pushl  -0x20(%ebp)
     220:	e8 2d 03 00 00       	call   552 <memmove>
     225:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
     228:	8b 45 e0             	mov    -0x20(%ebp),%eax
     22b:	83 c0 0e             	add    $0xe,%eax
     22e:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
     231:	83 ec 08             	sub    $0x8,%esp
     234:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
     23a:	50                   	push   %eax
     23b:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     241:	50                   	push   %eax
     242:	e8 71 02 00 00       	call   4b8 <stat>
     247:	83 c4 10             	add    $0x10,%esp
     24a:	85 c0                	test   %eax,%eax
     24c:	79 1b                	jns    269 <ls+0x1b3>
        printf(1, "ls: cannot stat %s\n", buf);
     24e:	83 ec 04             	sub    $0x4,%esp
     251:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     257:	50                   	push   %eax
     258:	68 60 12 00 00       	push   $0x1260
     25d:	6a 01                	push   $0x1
     25f:	e8 c8 04 00 00       	call   72c <printf>
     264:	83 c4 10             	add    $0x10,%esp
        continue;
     267:	eb 3e                	jmp    2a7 <ls+0x1f1>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
     269:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
     26f:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
     275:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
     27c:	0f bf d8             	movswl %ax,%ebx
     27f:	83 ec 0c             	sub    $0xc,%esp
     282:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     288:	50                   	push   %eax
     289:	e8 72 fd ff ff       	call   0 <fmtname>
     28e:	83 c4 10             	add    $0x10,%esp
     291:	83 ec 08             	sub    $0x8,%esp
     294:	57                   	push   %edi
     295:	56                   	push   %esi
     296:	53                   	push   %ebx
     297:	50                   	push   %eax
     298:	68 74 12 00 00       	push   $0x1274
     29d:	6a 01                	push   $0x1
     29f:	e8 88 04 00 00       	call   72c <printf>
     2a4:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     2a7:	83 ec 04             	sub    $0x4,%esp
     2aa:	6a 10                	push   $0x10
     2ac:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     2b2:	50                   	push   %eax
     2b3:	ff 75 e4             	pushl  -0x1c(%ebp)
     2b6:	e8 f4 02 00 00       	call   5af <read>
     2bb:	83 c4 10             	add    $0x10,%esp
     2be:	83 f8 10             	cmp    $0x10,%eax
     2c1:	0f 84 36 ff ff ff    	je     1fd <ls+0x147>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
     2c7:	90                   	nop
  }
  close(fd);
     2c8:	83 ec 0c             	sub    $0xc,%esp
     2cb:	ff 75 e4             	pushl  -0x1c(%ebp)
     2ce:	e8 ec 02 00 00       	call   5bf <close>
     2d3:	83 c4 10             	add    $0x10,%esp
}
     2d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
     2d9:	5b                   	pop    %ebx
     2da:	5e                   	pop    %esi
     2db:	5f                   	pop    %edi
     2dc:	5d                   	pop    %ebp
     2dd:	c3                   	ret    

000002de <main>:

int
main(int argc, char *argv[])
{
     2de:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     2e2:	83 e4 f0             	and    $0xfffffff0,%esp
     2e5:	ff 71 fc             	pushl  -0x4(%ecx)
     2e8:	55                   	push   %ebp
     2e9:	89 e5                	mov    %esp,%ebp
     2eb:	53                   	push   %ebx
     2ec:	51                   	push   %ecx
     2ed:	83 ec 10             	sub    $0x10,%esp
     2f0:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
     2f2:	83 3b 01             	cmpl   $0x1,(%ebx)
     2f5:	7f 15                	jg     30c <main+0x2e>
    ls(".");
     2f7:	83 ec 0c             	sub    $0xc,%esp
     2fa:	68 94 12 00 00       	push   $0x1294
     2ff:	e8 b2 fd ff ff       	call   b6 <ls>
     304:	83 c4 10             	add    $0x10,%esp
    exit();
     307:	e8 8b 02 00 00       	call   597 <exit>
  }
  for(i=1; i<argc; i++)
     30c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     313:	eb 21                	jmp    336 <main+0x58>
    ls(argv[i]);
     315:	8b 45 f4             	mov    -0xc(%ebp),%eax
     318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     31f:	8b 43 04             	mov    0x4(%ebx),%eax
     322:	01 d0                	add    %edx,%eax
     324:	8b 00                	mov    (%eax),%eax
     326:	83 ec 0c             	sub    $0xc,%esp
     329:	50                   	push   %eax
     32a:	e8 87 fd ff ff       	call   b6 <ls>
     32f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
     332:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     336:	8b 45 f4             	mov    -0xc(%ebp),%eax
     339:	3b 03                	cmp    (%ebx),%eax
     33b:	7c d8                	jl     315 <main+0x37>
    ls(argv[i]);
  exit();
     33d:	e8 55 02 00 00       	call   597 <exit>

00000342 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     342:	55                   	push   %ebp
     343:	89 e5                	mov    %esp,%ebp
     345:	57                   	push   %edi
     346:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     347:	8b 4d 08             	mov    0x8(%ebp),%ecx
     34a:	8b 55 10             	mov    0x10(%ebp),%edx
     34d:	8b 45 0c             	mov    0xc(%ebp),%eax
     350:	89 cb                	mov    %ecx,%ebx
     352:	89 df                	mov    %ebx,%edi
     354:	89 d1                	mov    %edx,%ecx
     356:	fc                   	cld    
     357:	f3 aa                	rep stos %al,%es:(%edi)
     359:	89 ca                	mov    %ecx,%edx
     35b:	89 fb                	mov    %edi,%ebx
     35d:	89 5d 08             	mov    %ebx,0x8(%ebp)
     360:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     363:	5b                   	pop    %ebx
     364:	5f                   	pop    %edi
     365:	5d                   	pop    %ebp
     366:	c3                   	ret    

00000367 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     367:	55                   	push   %ebp
     368:	89 e5                	mov    %esp,%ebp
     36a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     36d:	8b 45 08             	mov    0x8(%ebp),%eax
     370:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     373:	90                   	nop
     374:	8b 45 08             	mov    0x8(%ebp),%eax
     377:	8d 50 01             	lea    0x1(%eax),%edx
     37a:	89 55 08             	mov    %edx,0x8(%ebp)
     37d:	8b 55 0c             	mov    0xc(%ebp),%edx
     380:	8d 4a 01             	lea    0x1(%edx),%ecx
     383:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     386:	0f b6 12             	movzbl (%edx),%edx
     389:	88 10                	mov    %dl,(%eax)
     38b:	0f b6 00             	movzbl (%eax),%eax
     38e:	84 c0                	test   %al,%al
     390:	75 e2                	jne    374 <strcpy+0xd>
    ;
  return os;
     392:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     395:	c9                   	leave  
     396:	c3                   	ret    

00000397 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     397:	55                   	push   %ebp
     398:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     39a:	eb 08                	jmp    3a4 <strcmp+0xd>
    p++, q++;
     39c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     3a4:	8b 45 08             	mov    0x8(%ebp),%eax
     3a7:	0f b6 00             	movzbl (%eax),%eax
     3aa:	84 c0                	test   %al,%al
     3ac:	74 10                	je     3be <strcmp+0x27>
     3ae:	8b 45 08             	mov    0x8(%ebp),%eax
     3b1:	0f b6 10             	movzbl (%eax),%edx
     3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
     3b7:	0f b6 00             	movzbl (%eax),%eax
     3ba:	38 c2                	cmp    %al,%dl
     3bc:	74 de                	je     39c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     3be:	8b 45 08             	mov    0x8(%ebp),%eax
     3c1:	0f b6 00             	movzbl (%eax),%eax
     3c4:	0f b6 d0             	movzbl %al,%edx
     3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ca:	0f b6 00             	movzbl (%eax),%eax
     3cd:	0f b6 c0             	movzbl %al,%eax
     3d0:	29 c2                	sub    %eax,%edx
     3d2:	89 d0                	mov    %edx,%eax
}
     3d4:	5d                   	pop    %ebp
     3d5:	c3                   	ret    

000003d6 <strlen>:

uint
strlen(char *s)
{
     3d6:	55                   	push   %ebp
     3d7:	89 e5                	mov    %esp,%ebp
     3d9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     3dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     3e3:	eb 04                	jmp    3e9 <strlen+0x13>
     3e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     3e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     3ec:	8b 45 08             	mov    0x8(%ebp),%eax
     3ef:	01 d0                	add    %edx,%eax
     3f1:	0f b6 00             	movzbl (%eax),%eax
     3f4:	84 c0                	test   %al,%al
     3f6:	75 ed                	jne    3e5 <strlen+0xf>
    ;
  return n;
     3f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3fb:	c9                   	leave  
     3fc:	c3                   	ret    

000003fd <memset>:

void*
memset(void *dst, int c, uint n)
{
     3fd:	55                   	push   %ebp
     3fe:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     400:	8b 45 10             	mov    0x10(%ebp),%eax
     403:	50                   	push   %eax
     404:	ff 75 0c             	pushl  0xc(%ebp)
     407:	ff 75 08             	pushl  0x8(%ebp)
     40a:	e8 33 ff ff ff       	call   342 <stosb>
     40f:	83 c4 0c             	add    $0xc,%esp
  return dst;
     412:	8b 45 08             	mov    0x8(%ebp),%eax
}
     415:	c9                   	leave  
     416:	c3                   	ret    

00000417 <strchr>:

char*
strchr(const char *s, char c)
{
     417:	55                   	push   %ebp
     418:	89 e5                	mov    %esp,%ebp
     41a:	83 ec 04             	sub    $0x4,%esp
     41d:	8b 45 0c             	mov    0xc(%ebp),%eax
     420:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     423:	eb 14                	jmp    439 <strchr+0x22>
    if(*s == c)
     425:	8b 45 08             	mov    0x8(%ebp),%eax
     428:	0f b6 00             	movzbl (%eax),%eax
     42b:	3a 45 fc             	cmp    -0x4(%ebp),%al
     42e:	75 05                	jne    435 <strchr+0x1e>
      return (char*)s;
     430:	8b 45 08             	mov    0x8(%ebp),%eax
     433:	eb 13                	jmp    448 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     435:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     439:	8b 45 08             	mov    0x8(%ebp),%eax
     43c:	0f b6 00             	movzbl (%eax),%eax
     43f:	84 c0                	test   %al,%al
     441:	75 e2                	jne    425 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     443:	b8 00 00 00 00       	mov    $0x0,%eax
}
     448:	c9                   	leave  
     449:	c3                   	ret    

0000044a <gets>:

char*
gets(char *buf, int max)
{
     44a:	55                   	push   %ebp
     44b:	89 e5                	mov    %esp,%ebp
     44d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     450:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     457:	eb 44                	jmp    49d <gets+0x53>
    cc = read(0, &c, 1);
     459:	83 ec 04             	sub    $0x4,%esp
     45c:	6a 01                	push   $0x1
     45e:	8d 45 ef             	lea    -0x11(%ebp),%eax
     461:	50                   	push   %eax
     462:	6a 00                	push   $0x0
     464:	e8 46 01 00 00       	call   5af <read>
     469:	83 c4 10             	add    $0x10,%esp
     46c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     46f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     473:	7f 02                	jg     477 <gets+0x2d>
      break;
     475:	eb 31                	jmp    4a8 <gets+0x5e>
    buf[i++] = c;
     477:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47a:	8d 50 01             	lea    0x1(%eax),%edx
     47d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     480:	89 c2                	mov    %eax,%edx
     482:	8b 45 08             	mov    0x8(%ebp),%eax
     485:	01 c2                	add    %eax,%edx
     487:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     48b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     48d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     491:	3c 0a                	cmp    $0xa,%al
     493:	74 13                	je     4a8 <gets+0x5e>
     495:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     499:	3c 0d                	cmp    $0xd,%al
     49b:	74 0b                	je     4a8 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     49d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a0:	83 c0 01             	add    $0x1,%eax
     4a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
     4a6:	7c b1                	jl     459 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     4a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4ab:	8b 45 08             	mov    0x8(%ebp),%eax
     4ae:	01 d0                	add    %edx,%eax
     4b0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     4b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
     4b6:	c9                   	leave  
     4b7:	c3                   	ret    

000004b8 <stat>:

int
stat(char *n, struct stat *st)
{
     4b8:	55                   	push   %ebp
     4b9:	89 e5                	mov    %esp,%ebp
     4bb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     4be:	83 ec 08             	sub    $0x8,%esp
     4c1:	6a 00                	push   $0x0
     4c3:	ff 75 08             	pushl  0x8(%ebp)
     4c6:	e8 0c 01 00 00       	call   5d7 <open>
     4cb:	83 c4 10             	add    $0x10,%esp
     4ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     4d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     4d5:	79 07                	jns    4de <stat+0x26>
    return -1;
     4d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     4dc:	eb 25                	jmp    503 <stat+0x4b>
  r = fstat(fd, st);
     4de:	83 ec 08             	sub    $0x8,%esp
     4e1:	ff 75 0c             	pushl  0xc(%ebp)
     4e4:	ff 75 f4             	pushl  -0xc(%ebp)
     4e7:	e8 03 01 00 00       	call   5ef <fstat>
     4ec:	83 c4 10             	add    $0x10,%esp
     4ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     4f2:	83 ec 0c             	sub    $0xc,%esp
     4f5:	ff 75 f4             	pushl  -0xc(%ebp)
     4f8:	e8 c2 00 00 00       	call   5bf <close>
     4fd:	83 c4 10             	add    $0x10,%esp
  return r;
     500:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     503:	c9                   	leave  
     504:	c3                   	ret    

00000505 <atoi>:

int
atoi(const char *s)
{
     505:	55                   	push   %ebp
     506:	89 e5                	mov    %esp,%ebp
     508:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     50b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     512:	eb 25                	jmp    539 <atoi+0x34>
    n = n*10 + *s++ - '0';
     514:	8b 55 fc             	mov    -0x4(%ebp),%edx
     517:	89 d0                	mov    %edx,%eax
     519:	c1 e0 02             	shl    $0x2,%eax
     51c:	01 d0                	add    %edx,%eax
     51e:	01 c0                	add    %eax,%eax
     520:	89 c1                	mov    %eax,%ecx
     522:	8b 45 08             	mov    0x8(%ebp),%eax
     525:	8d 50 01             	lea    0x1(%eax),%edx
     528:	89 55 08             	mov    %edx,0x8(%ebp)
     52b:	0f b6 00             	movzbl (%eax),%eax
     52e:	0f be c0             	movsbl %al,%eax
     531:	01 c8                	add    %ecx,%eax
     533:	83 e8 30             	sub    $0x30,%eax
     536:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     539:	8b 45 08             	mov    0x8(%ebp),%eax
     53c:	0f b6 00             	movzbl (%eax),%eax
     53f:	3c 2f                	cmp    $0x2f,%al
     541:	7e 0a                	jle    54d <atoi+0x48>
     543:	8b 45 08             	mov    0x8(%ebp),%eax
     546:	0f b6 00             	movzbl (%eax),%eax
     549:	3c 39                	cmp    $0x39,%al
     54b:	7e c7                	jle    514 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     54d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     550:	c9                   	leave  
     551:	c3                   	ret    

00000552 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     552:	55                   	push   %ebp
     553:	89 e5                	mov    %esp,%ebp
     555:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     558:	8b 45 08             	mov    0x8(%ebp),%eax
     55b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     55e:	8b 45 0c             	mov    0xc(%ebp),%eax
     561:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     564:	eb 17                	jmp    57d <memmove+0x2b>
    *dst++ = *src++;
     566:	8b 45 fc             	mov    -0x4(%ebp),%eax
     569:	8d 50 01             	lea    0x1(%eax),%edx
     56c:	89 55 fc             	mov    %edx,-0x4(%ebp)
     56f:	8b 55 f8             	mov    -0x8(%ebp),%edx
     572:	8d 4a 01             	lea    0x1(%edx),%ecx
     575:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     578:	0f b6 12             	movzbl (%edx),%edx
     57b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     57d:	8b 45 10             	mov    0x10(%ebp),%eax
     580:	8d 50 ff             	lea    -0x1(%eax),%edx
     583:	89 55 10             	mov    %edx,0x10(%ebp)
     586:	85 c0                	test   %eax,%eax
     588:	7f dc                	jg     566 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     58a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     58d:	c9                   	leave  
     58e:	c3                   	ret    

0000058f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     58f:	b8 01 00 00 00       	mov    $0x1,%eax
     594:	cd 40                	int    $0x40
     596:	c3                   	ret    

00000597 <exit>:
SYSCALL(exit)
     597:	b8 02 00 00 00       	mov    $0x2,%eax
     59c:	cd 40                	int    $0x40
     59e:	c3                   	ret    

0000059f <wait>:
SYSCALL(wait)
     59f:	b8 03 00 00 00       	mov    $0x3,%eax
     5a4:	cd 40                	int    $0x40
     5a6:	c3                   	ret    

000005a7 <pipe>:
SYSCALL(pipe)
     5a7:	b8 04 00 00 00       	mov    $0x4,%eax
     5ac:	cd 40                	int    $0x40
     5ae:	c3                   	ret    

000005af <read>:
SYSCALL(read)
     5af:	b8 05 00 00 00       	mov    $0x5,%eax
     5b4:	cd 40                	int    $0x40
     5b6:	c3                   	ret    

000005b7 <write>:
SYSCALL(write)
     5b7:	b8 10 00 00 00       	mov    $0x10,%eax
     5bc:	cd 40                	int    $0x40
     5be:	c3                   	ret    

000005bf <close>:
SYSCALL(close)
     5bf:	b8 15 00 00 00       	mov    $0x15,%eax
     5c4:	cd 40                	int    $0x40
     5c6:	c3                   	ret    

000005c7 <kill>:
SYSCALL(kill)
     5c7:	b8 06 00 00 00       	mov    $0x6,%eax
     5cc:	cd 40                	int    $0x40
     5ce:	c3                   	ret    

000005cf <exec>:
SYSCALL(exec)
     5cf:	b8 07 00 00 00       	mov    $0x7,%eax
     5d4:	cd 40                	int    $0x40
     5d6:	c3                   	ret    

000005d7 <open>:
SYSCALL(open)
     5d7:	b8 0f 00 00 00       	mov    $0xf,%eax
     5dc:	cd 40                	int    $0x40
     5de:	c3                   	ret    

000005df <mknod>:
SYSCALL(mknod)
     5df:	b8 11 00 00 00       	mov    $0x11,%eax
     5e4:	cd 40                	int    $0x40
     5e6:	c3                   	ret    

000005e7 <unlink>:
SYSCALL(unlink)
     5e7:	b8 12 00 00 00       	mov    $0x12,%eax
     5ec:	cd 40                	int    $0x40
     5ee:	c3                   	ret    

000005ef <fstat>:
SYSCALL(fstat)
     5ef:	b8 08 00 00 00       	mov    $0x8,%eax
     5f4:	cd 40                	int    $0x40
     5f6:	c3                   	ret    

000005f7 <link>:
SYSCALL(link)
     5f7:	b8 13 00 00 00       	mov    $0x13,%eax
     5fc:	cd 40                	int    $0x40
     5fe:	c3                   	ret    

000005ff <mkdir>:
SYSCALL(mkdir)
     5ff:	b8 14 00 00 00       	mov    $0x14,%eax
     604:	cd 40                	int    $0x40
     606:	c3                   	ret    

00000607 <chdir>:
SYSCALL(chdir)
     607:	b8 09 00 00 00       	mov    $0x9,%eax
     60c:	cd 40                	int    $0x40
     60e:	c3                   	ret    

0000060f <dup>:
SYSCALL(dup)
     60f:	b8 0a 00 00 00       	mov    $0xa,%eax
     614:	cd 40                	int    $0x40
     616:	c3                   	ret    

00000617 <getpid>:
SYSCALL(getpid)
     617:	b8 0b 00 00 00       	mov    $0xb,%eax
     61c:	cd 40                	int    $0x40
     61e:	c3                   	ret    

0000061f <sbrk>:
SYSCALL(sbrk)
     61f:	b8 0c 00 00 00       	mov    $0xc,%eax
     624:	cd 40                	int    $0x40
     626:	c3                   	ret    

00000627 <sleep>:
SYSCALL(sleep)
     627:	b8 0d 00 00 00       	mov    $0xd,%eax
     62c:	cd 40                	int    $0x40
     62e:	c3                   	ret    

0000062f <uptime>:
SYSCALL(uptime)
     62f:	b8 0e 00 00 00       	mov    $0xe,%eax
     634:	cd 40                	int    $0x40
     636:	c3                   	ret    

00000637 <getcwd>:
SYSCALL(getcwd)
     637:	b8 16 00 00 00       	mov    $0x16,%eax
     63c:	cd 40                	int    $0x40
     63e:	c3                   	ret    

0000063f <shutdown>:
SYSCALL(shutdown)
     63f:	b8 17 00 00 00       	mov    $0x17,%eax
     644:	cd 40                	int    $0x40
     646:	c3                   	ret    

00000647 <buildinfo>:
SYSCALL(buildinfo)
     647:	b8 18 00 00 00       	mov    $0x18,%eax
     64c:	cd 40                	int    $0x40
     64e:	c3                   	ret    

0000064f <lseek>:
SYSCALL(lseek)
     64f:	b8 19 00 00 00       	mov    $0x19,%eax
     654:	cd 40                	int    $0x40
     656:	c3                   	ret    

00000657 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     657:	55                   	push   %ebp
     658:	89 e5                	mov    %esp,%ebp
     65a:	83 ec 18             	sub    $0x18,%esp
     65d:	8b 45 0c             	mov    0xc(%ebp),%eax
     660:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     663:	83 ec 04             	sub    $0x4,%esp
     666:	6a 01                	push   $0x1
     668:	8d 45 f4             	lea    -0xc(%ebp),%eax
     66b:	50                   	push   %eax
     66c:	ff 75 08             	pushl  0x8(%ebp)
     66f:	e8 43 ff ff ff       	call   5b7 <write>
     674:	83 c4 10             	add    $0x10,%esp
}
     677:	c9                   	leave  
     678:	c3                   	ret    

00000679 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     679:	55                   	push   %ebp
     67a:	89 e5                	mov    %esp,%ebp
     67c:	53                   	push   %ebx
     67d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     687:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     68b:	74 17                	je     6a4 <printint+0x2b>
     68d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     691:	79 11                	jns    6a4 <printint+0x2b>
    neg = 1;
     693:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     69a:	8b 45 0c             	mov    0xc(%ebp),%eax
     69d:	f7 d8                	neg    %eax
     69f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6a2:	eb 06                	jmp    6aa <printint+0x31>
  } else {
    x = xx;
     6a4:	8b 45 0c             	mov    0xc(%ebp),%eax
     6a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     6aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     6b1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     6b4:	8d 41 01             	lea    0x1(%ecx),%eax
     6b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
     6ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
     6bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6c0:	ba 00 00 00 00       	mov    $0x0,%edx
     6c5:	f7 f3                	div    %ebx
     6c7:	89 d0                	mov    %edx,%eax
     6c9:	0f b6 80 00 17 00 00 	movzbl 0x1700(%eax),%eax
     6d0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     6d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
     6d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6da:	ba 00 00 00 00       	mov    $0x0,%edx
     6df:	f7 f3                	div    %ebx
     6e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     6e8:	75 c7                	jne    6b1 <printint+0x38>
  if(neg)
     6ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     6ee:	74 0e                	je     6fe <printint+0x85>
    buf[i++] = '-';
     6f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6f3:	8d 50 01             	lea    0x1(%eax),%edx
     6f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
     6f9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     6fe:	eb 1d                	jmp    71d <printint+0xa4>
    putc(fd, buf[i]);
     700:	8d 55 dc             	lea    -0x24(%ebp),%edx
     703:	8b 45 f4             	mov    -0xc(%ebp),%eax
     706:	01 d0                	add    %edx,%eax
     708:	0f b6 00             	movzbl (%eax),%eax
     70b:	0f be c0             	movsbl %al,%eax
     70e:	83 ec 08             	sub    $0x8,%esp
     711:	50                   	push   %eax
     712:	ff 75 08             	pushl  0x8(%ebp)
     715:	e8 3d ff ff ff       	call   657 <putc>
     71a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     71d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     721:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     725:	79 d9                	jns    700 <printint+0x87>
    putc(fd, buf[i]);
}
     727:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     72a:	c9                   	leave  
     72b:	c3                   	ret    

0000072c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     72c:	55                   	push   %ebp
     72d:	89 e5                	mov    %esp,%ebp
     72f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     732:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     739:	8d 45 0c             	lea    0xc(%ebp),%eax
     73c:	83 c0 04             	add    $0x4,%eax
     73f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     742:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     749:	e9 59 01 00 00       	jmp    8a7 <printf+0x17b>
    c = fmt[i] & 0xff;
     74e:	8b 55 0c             	mov    0xc(%ebp),%edx
     751:	8b 45 f0             	mov    -0x10(%ebp),%eax
     754:	01 d0                	add    %edx,%eax
     756:	0f b6 00             	movzbl (%eax),%eax
     759:	0f be c0             	movsbl %al,%eax
     75c:	25 ff 00 00 00       	and    $0xff,%eax
     761:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     764:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     768:	75 2c                	jne    796 <printf+0x6a>
      if(c == '%'){
     76a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     76e:	75 0c                	jne    77c <printf+0x50>
        state = '%';
     770:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     777:	e9 27 01 00 00       	jmp    8a3 <printf+0x177>
      } else {
        putc(fd, c);
     77c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     77f:	0f be c0             	movsbl %al,%eax
     782:	83 ec 08             	sub    $0x8,%esp
     785:	50                   	push   %eax
     786:	ff 75 08             	pushl  0x8(%ebp)
     789:	e8 c9 fe ff ff       	call   657 <putc>
     78e:	83 c4 10             	add    $0x10,%esp
     791:	e9 0d 01 00 00       	jmp    8a3 <printf+0x177>
      }
    } else if(state == '%'){
     796:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     79a:	0f 85 03 01 00 00    	jne    8a3 <printf+0x177>
      if(c == 'd'){
     7a0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     7a4:	75 1e                	jne    7c4 <printf+0x98>
        printint(fd, *ap, 10, 1);
     7a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7a9:	8b 00                	mov    (%eax),%eax
     7ab:	6a 01                	push   $0x1
     7ad:	6a 0a                	push   $0xa
     7af:	50                   	push   %eax
     7b0:	ff 75 08             	pushl  0x8(%ebp)
     7b3:	e8 c1 fe ff ff       	call   679 <printint>
     7b8:	83 c4 10             	add    $0x10,%esp
        ap++;
     7bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7bf:	e9 d8 00 00 00       	jmp    89c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
     7c4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     7c8:	74 06                	je     7d0 <printf+0xa4>
     7ca:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     7ce:	75 1e                	jne    7ee <printf+0xc2>
        printint(fd, *ap, 16, 0);
     7d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7d3:	8b 00                	mov    (%eax),%eax
     7d5:	6a 00                	push   $0x0
     7d7:	6a 10                	push   $0x10
     7d9:	50                   	push   %eax
     7da:	ff 75 08             	pushl  0x8(%ebp)
     7dd:	e8 97 fe ff ff       	call   679 <printint>
     7e2:	83 c4 10             	add    $0x10,%esp
        ap++;
     7e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7e9:	e9 ae 00 00 00       	jmp    89c <printf+0x170>
      } else if(c == 's'){
     7ee:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     7f2:	75 43                	jne    837 <printf+0x10b>
        s = (char*)*ap;
     7f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7f7:	8b 00                	mov    (%eax),%eax
     7f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     7fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     804:	75 07                	jne    80d <printf+0xe1>
          s = "(null)";
     806:	c7 45 f4 96 12 00 00 	movl   $0x1296,-0xc(%ebp)
        while(*s != 0){
     80d:	eb 1c                	jmp    82b <printf+0xff>
          putc(fd, *s);
     80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     812:	0f b6 00             	movzbl (%eax),%eax
     815:	0f be c0             	movsbl %al,%eax
     818:	83 ec 08             	sub    $0x8,%esp
     81b:	50                   	push   %eax
     81c:	ff 75 08             	pushl  0x8(%ebp)
     81f:	e8 33 fe ff ff       	call   657 <putc>
     824:	83 c4 10             	add    $0x10,%esp
          s++;
     827:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     82e:	0f b6 00             	movzbl (%eax),%eax
     831:	84 c0                	test   %al,%al
     833:	75 da                	jne    80f <printf+0xe3>
     835:	eb 65                	jmp    89c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     837:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     83b:	75 1d                	jne    85a <printf+0x12e>
        putc(fd, *ap);
     83d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     840:	8b 00                	mov    (%eax),%eax
     842:	0f be c0             	movsbl %al,%eax
     845:	83 ec 08             	sub    $0x8,%esp
     848:	50                   	push   %eax
     849:	ff 75 08             	pushl  0x8(%ebp)
     84c:	e8 06 fe ff ff       	call   657 <putc>
     851:	83 c4 10             	add    $0x10,%esp
        ap++;
     854:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     858:	eb 42                	jmp    89c <printf+0x170>
      } else if(c == '%'){
     85a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     85e:	75 17                	jne    877 <printf+0x14b>
        putc(fd, c);
     860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     863:	0f be c0             	movsbl %al,%eax
     866:	83 ec 08             	sub    $0x8,%esp
     869:	50                   	push   %eax
     86a:	ff 75 08             	pushl  0x8(%ebp)
     86d:	e8 e5 fd ff ff       	call   657 <putc>
     872:	83 c4 10             	add    $0x10,%esp
     875:	eb 25                	jmp    89c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     877:	83 ec 08             	sub    $0x8,%esp
     87a:	6a 25                	push   $0x25
     87c:	ff 75 08             	pushl  0x8(%ebp)
     87f:	e8 d3 fd ff ff       	call   657 <putc>
     884:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
     887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     88a:	0f be c0             	movsbl %al,%eax
     88d:	83 ec 08             	sub    $0x8,%esp
     890:	50                   	push   %eax
     891:	ff 75 08             	pushl  0x8(%ebp)
     894:	e8 be fd ff ff       	call   657 <putc>
     899:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     89c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     8a3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     8a7:	8b 55 0c             	mov    0xc(%ebp),%edx
     8aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8ad:	01 d0                	add    %edx,%eax
     8af:	0f b6 00             	movzbl (%eax),%eax
     8b2:	84 c0                	test   %al,%al
     8b4:	0f 85 94 fe ff ff    	jne    74e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     8ba:	c9                   	leave  
     8bb:	c3                   	ret    

000008bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     8bc:	55                   	push   %ebp
     8bd:	89 e5                	mov    %esp,%ebp
     8bf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     8c2:	8b 45 08             	mov    0x8(%ebp),%eax
     8c5:	83 e8 08             	sub    $0x8,%eax
     8c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8cb:	a1 2c 17 00 00       	mov    0x172c,%eax
     8d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
     8d3:	eb 24                	jmp    8f9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     8d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8d8:	8b 00                	mov    (%eax),%eax
     8da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8dd:	77 12                	ja     8f1 <free+0x35>
     8df:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8e5:	77 24                	ja     90b <free+0x4f>
     8e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8ea:	8b 00                	mov    (%eax),%eax
     8ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     8ef:	77 1a                	ja     90b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8f4:	8b 00                	mov    (%eax),%eax
     8f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
     8f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8ff:	76 d4                	jbe    8d5 <free+0x19>
     901:	8b 45 fc             	mov    -0x4(%ebp),%eax
     904:	8b 00                	mov    (%eax),%eax
     906:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     909:	76 ca                	jbe    8d5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     90b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     90e:	8b 40 04             	mov    0x4(%eax),%eax
     911:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     918:	8b 45 f8             	mov    -0x8(%ebp),%eax
     91b:	01 c2                	add    %eax,%edx
     91d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     920:	8b 00                	mov    (%eax),%eax
     922:	39 c2                	cmp    %eax,%edx
     924:	75 24                	jne    94a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     926:	8b 45 f8             	mov    -0x8(%ebp),%eax
     929:	8b 50 04             	mov    0x4(%eax),%edx
     92c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     92f:	8b 00                	mov    (%eax),%eax
     931:	8b 40 04             	mov    0x4(%eax),%eax
     934:	01 c2                	add    %eax,%edx
     936:	8b 45 f8             	mov    -0x8(%ebp),%eax
     939:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     93c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     93f:	8b 00                	mov    (%eax),%eax
     941:	8b 10                	mov    (%eax),%edx
     943:	8b 45 f8             	mov    -0x8(%ebp),%eax
     946:	89 10                	mov    %edx,(%eax)
     948:	eb 0a                	jmp    954 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     94d:	8b 10                	mov    (%eax),%edx
     94f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     952:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     954:	8b 45 fc             	mov    -0x4(%ebp),%eax
     957:	8b 40 04             	mov    0x4(%eax),%eax
     95a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     961:	8b 45 fc             	mov    -0x4(%ebp),%eax
     964:	01 d0                	add    %edx,%eax
     966:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     969:	75 20                	jne    98b <free+0xcf>
    p->s.size += bp->s.size;
     96b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     96e:	8b 50 04             	mov    0x4(%eax),%edx
     971:	8b 45 f8             	mov    -0x8(%ebp),%eax
     974:	8b 40 04             	mov    0x4(%eax),%eax
     977:	01 c2                	add    %eax,%edx
     979:	8b 45 fc             	mov    -0x4(%ebp),%eax
     97c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     97f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     982:	8b 10                	mov    (%eax),%edx
     984:	8b 45 fc             	mov    -0x4(%ebp),%eax
     987:	89 10                	mov    %edx,(%eax)
     989:	eb 08                	jmp    993 <free+0xd7>
  } else
    p->s.ptr = bp;
     98b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     98e:	8b 55 f8             	mov    -0x8(%ebp),%edx
     991:	89 10                	mov    %edx,(%eax)
  freep = p;
     993:	8b 45 fc             	mov    -0x4(%ebp),%eax
     996:	a3 2c 17 00 00       	mov    %eax,0x172c
}
     99b:	c9                   	leave  
     99c:	c3                   	ret    

0000099d <morecore>:

static Header*
morecore(uint nu)
{
     99d:	55                   	push   %ebp
     99e:	89 e5                	mov    %esp,%ebp
     9a0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     9a3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     9aa:	77 07                	ja     9b3 <morecore+0x16>
    nu = 4096;
     9ac:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     9b3:	8b 45 08             	mov    0x8(%ebp),%eax
     9b6:	c1 e0 03             	shl    $0x3,%eax
     9b9:	83 ec 0c             	sub    $0xc,%esp
     9bc:	50                   	push   %eax
     9bd:	e8 5d fc ff ff       	call   61f <sbrk>
     9c2:	83 c4 10             	add    $0x10,%esp
     9c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     9c8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     9cc:	75 07                	jne    9d5 <morecore+0x38>
    return 0;
     9ce:	b8 00 00 00 00       	mov    $0x0,%eax
     9d3:	eb 26                	jmp    9fb <morecore+0x5e>
  hp = (Header*)p;
     9d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     9db:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9de:	8b 55 08             	mov    0x8(%ebp),%edx
     9e1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     9e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9e7:	83 c0 08             	add    $0x8,%eax
     9ea:	83 ec 0c             	sub    $0xc,%esp
     9ed:	50                   	push   %eax
     9ee:	e8 c9 fe ff ff       	call   8bc <free>
     9f3:	83 c4 10             	add    $0x10,%esp
  return freep;
     9f6:	a1 2c 17 00 00       	mov    0x172c,%eax
}
     9fb:	c9                   	leave  
     9fc:	c3                   	ret    

000009fd <malloc>:

void*
malloc(uint nbytes)
{
     9fd:	55                   	push   %ebp
     9fe:	89 e5                	mov    %esp,%ebp
     a00:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     a03:	8b 45 08             	mov    0x8(%ebp),%eax
     a06:	83 c0 07             	add    $0x7,%eax
     a09:	c1 e8 03             	shr    $0x3,%eax
     a0c:	83 c0 01             	add    $0x1,%eax
     a0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     a12:	a1 2c 17 00 00       	mov    0x172c,%eax
     a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a1e:	75 23                	jne    a43 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a20:	c7 45 f0 24 17 00 00 	movl   $0x1724,-0x10(%ebp)
     a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a2a:	a3 2c 17 00 00       	mov    %eax,0x172c
     a2f:	a1 2c 17 00 00       	mov    0x172c,%eax
     a34:	a3 24 17 00 00       	mov    %eax,0x1724
    base.s.size = 0;
     a39:	c7 05 28 17 00 00 00 	movl   $0x0,0x1728
     a40:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a46:	8b 00                	mov    (%eax),%eax
     a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a4e:	8b 40 04             	mov    0x4(%eax),%eax
     a51:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a54:	72 4d                	jb     aa3 <malloc+0xa6>
      if(p->s.size == nunits)
     a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a59:	8b 40 04             	mov    0x4(%eax),%eax
     a5c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a5f:	75 0c                	jne    a6d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a64:	8b 10                	mov    (%eax),%edx
     a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a69:	89 10                	mov    %edx,(%eax)
     a6b:	eb 26                	jmp    a93 <malloc+0x96>
      else {
        p->s.size -= nunits;
     a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a70:	8b 40 04             	mov    0x4(%eax),%eax
     a73:	2b 45 ec             	sub    -0x14(%ebp),%eax
     a76:	89 c2                	mov    %eax,%edx
     a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a7b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a81:	8b 40 04             	mov    0x4(%eax),%eax
     a84:	c1 e0 03             	shl    $0x3,%eax
     a87:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a90:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a96:	a3 2c 17 00 00       	mov    %eax,0x172c
      return (void*)(p + 1);
     a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a9e:	83 c0 08             	add    $0x8,%eax
     aa1:	eb 3b                	jmp    ade <malloc+0xe1>
    }
    if(p == freep)
     aa3:	a1 2c 17 00 00       	mov    0x172c,%eax
     aa8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     aab:	75 1e                	jne    acb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
     aad:	83 ec 0c             	sub    $0xc,%esp
     ab0:	ff 75 ec             	pushl  -0x14(%ebp)
     ab3:	e8 e5 fe ff ff       	call   99d <morecore>
     ab8:	83 c4 10             	add    $0x10,%esp
     abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
     abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ac2:	75 07                	jne    acb <malloc+0xce>
        return 0;
     ac4:	b8 00 00 00 00       	mov    $0x0,%eax
     ac9:	eb 13                	jmp    ade <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad4:	8b 00                	mov    (%eax),%eax
     ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     ad9:	e9 6d ff ff ff       	jmp    a4b <malloc+0x4e>
}
     ade:	c9                   	leave  
     adf:	c3                   	ret    

00000ae0 <isspace>:

#include "common.h"

int isspace(char c) {
     ae0:	55                   	push   %ebp
     ae1:	89 e5                	mov    %esp,%ebp
     ae3:	83 ec 04             	sub    $0x4,%esp
     ae6:	8b 45 08             	mov    0x8(%ebp),%eax
     ae9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
     aec:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     af0:	74 12                	je     b04 <isspace+0x24>
     af2:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     af6:	74 0c                	je     b04 <isspace+0x24>
     af8:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     afc:	74 06                	je     b04 <isspace+0x24>
     afe:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     b02:	75 07                	jne    b0b <isspace+0x2b>
     b04:	b8 01 00 00 00       	mov    $0x1,%eax
     b09:	eb 05                	jmp    b10 <isspace+0x30>
     b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     b10:	c9                   	leave  
     b11:	c3                   	ret    

00000b12 <readln>:

char* readln(char *buf, int max, int fd)
{
     b12:	55                   	push   %ebp
     b13:	89 e5                	mov    %esp,%ebp
     b15:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b1f:	eb 45                	jmp    b66 <readln+0x54>
    cc = read(fd, &c, 1);
     b21:	83 ec 04             	sub    $0x4,%esp
     b24:	6a 01                	push   $0x1
     b26:	8d 45 ef             	lea    -0x11(%ebp),%eax
     b29:	50                   	push   %eax
     b2a:	ff 75 10             	pushl  0x10(%ebp)
     b2d:	e8 7d fa ff ff       	call   5af <read>
     b32:	83 c4 10             	add    $0x10,%esp
     b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     b38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b3c:	7f 02                	jg     b40 <readln+0x2e>
      break;
     b3e:	eb 31                	jmp    b71 <readln+0x5f>
    buf[i++] = c;
     b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b43:	8d 50 01             	lea    0x1(%eax),%edx
     b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
     b49:	89 c2                	mov    %eax,%edx
     b4b:	8b 45 08             	mov    0x8(%ebp),%eax
     b4e:	01 c2                	add    %eax,%edx
     b50:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     b54:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     b56:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     b5a:	3c 0a                	cmp    $0xa,%al
     b5c:	74 13                	je     b71 <readln+0x5f>
     b5e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     b62:	3c 0d                	cmp    $0xd,%al
     b64:	74 0b                	je     b71 <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b69:	83 c0 01             	add    $0x1,%eax
     b6c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     b6f:	7c b0                	jl     b21 <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b74:	8b 45 08             	mov    0x8(%ebp),%eax
     b77:	01 d0                	add    %edx,%eax
     b79:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     b7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     b7f:	c9                   	leave  
     b80:	c3                   	ret    

00000b81 <strncpy>:

char* strncpy(char* dest, char* src, int n) {
     b81:	55                   	push   %ebp
     b82:	89 e5                	mov    %esp,%ebp
     b84:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     b87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     b8e:	eb 19                	jmp    ba9 <strncpy+0x28>
		dest[i] = src[i];
     b90:	8b 55 fc             	mov    -0x4(%ebp),%edx
     b93:	8b 45 08             	mov    0x8(%ebp),%eax
     b96:	01 c2                	add    %eax,%edx
     b98:	8b 4d fc             	mov    -0x4(%ebp),%ecx
     b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
     b9e:	01 c8                	add    %ecx,%eax
     ba0:	0f b6 00             	movzbl (%eax),%eax
     ba3:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
     ba5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     ba9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bac:	3b 45 10             	cmp    0x10(%ebp),%eax
     baf:	7d 0f                	jge    bc0 <strncpy+0x3f>
     bb1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb7:	01 d0                	add    %edx,%eax
     bb9:	0f b6 00             	movzbl (%eax),%eax
     bbc:	84 c0                	test   %al,%al
     bbe:	75 d0                	jne    b90 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
     bc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     bc3:	c9                   	leave  
     bc4:	c3                   	ret    

00000bc5 <trim>:

char* trim(char* orig) {
     bc5:	55                   	push   %ebp
     bc6:	89 e5                	mov    %esp,%ebp
     bc8:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
     bcb:	8b 45 08             	mov    0x8(%ebp),%eax
     bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
     bd1:	8b 45 08             	mov    0x8(%ebp),%eax
     bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
     bd7:	eb 04                	jmp    bdd <trim+0x18>
     bd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     be0:	0f b6 00             	movzbl (%eax),%eax
     be3:	0f be c0             	movsbl %al,%eax
     be6:	50                   	push   %eax
     be7:	e8 f4 fe ff ff       	call   ae0 <isspace>
     bec:	83 c4 04             	add    $0x4,%esp
     bef:	85 c0                	test   %eax,%eax
     bf1:	75 e6                	jne    bd9 <trim+0x14>
	while (*tail) { tail++; }
     bf3:	eb 04                	jmp    bf9 <trim+0x34>
     bf5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bfc:	0f b6 00             	movzbl (%eax),%eax
     bff:	84 c0                	test   %al,%al
     c01:	75 f2                	jne    bf5 <trim+0x30>
	do { tail--; } while (isspace(*tail));
     c03:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
     c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c0a:	0f b6 00             	movzbl (%eax),%eax
     c0d:	0f be c0             	movsbl %al,%eax
     c10:	50                   	push   %eax
     c11:	e8 ca fe ff ff       	call   ae0 <isspace>
     c16:	83 c4 04             	add    $0x4,%esp
     c19:	85 c0                	test   %eax,%eax
     c1b:	75 e6                	jne    c03 <trim+0x3e>
	new = malloc(tail-head+2);
     c1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c23:	29 c2                	sub    %eax,%edx
     c25:	89 d0                	mov    %edx,%eax
     c27:	83 c0 02             	add    $0x2,%eax
     c2a:	83 ec 0c             	sub    $0xc,%esp
     c2d:	50                   	push   %eax
     c2e:	e8 ca fd ff ff       	call   9fd <malloc>
     c33:	83 c4 10             	add    $0x10,%esp
     c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
     c39:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c3f:	29 c2                	sub    %eax,%edx
     c41:	89 d0                	mov    %edx,%eax
     c43:	83 c0 01             	add    $0x1,%eax
     c46:	83 ec 04             	sub    $0x4,%esp
     c49:	50                   	push   %eax
     c4a:	ff 75 f4             	pushl  -0xc(%ebp)
     c4d:	ff 75 ec             	pushl  -0x14(%ebp)
     c50:	e8 2c ff ff ff       	call   b81 <strncpy>
     c55:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
     c58:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c5e:	29 c2                	sub    %eax,%edx
     c60:	89 d0                	mov    %edx,%eax
     c62:	8d 50 01             	lea    0x1(%eax),%edx
     c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c68:	01 d0                	add    %edx,%eax
     c6a:	c6 00 00             	movb   $0x0,(%eax)
	return new;
     c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
     c70:	c9                   	leave  
     c71:	c3                   	ret    

00000c72 <itoa>:

char *
itoa(int value)
{
     c72:	55                   	push   %ebp
     c73:	89 e5                	mov    %esp,%ebp
     c75:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
     c78:	8d 45 bf             	lea    -0x41(%ebp),%eax
     c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
     c7e:	8b 45 08             	mov    0x8(%ebp),%eax
     c81:	c1 e8 1f             	shr    $0x1f,%eax
     c84:	0f b6 c0             	movzbl %al,%eax
     c87:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
     c8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c8e:	74 0a                	je     c9a <itoa+0x28>
    v = -value;
     c90:	8b 45 08             	mov    0x8(%ebp),%eax
     c93:	f7 d8                	neg    %eax
     c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
     c98:	eb 06                	jmp    ca0 <itoa+0x2e>
  else
    v = (uint)value;
     c9a:	8b 45 08             	mov    0x8(%ebp),%eax
     c9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
     ca0:	eb 5b                	jmp    cfd <itoa+0x8b>
  {
    i = v % 10;
     ca2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     ca5:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     caa:	89 c8                	mov    %ecx,%eax
     cac:	f7 e2                	mul    %edx
     cae:	c1 ea 03             	shr    $0x3,%edx
     cb1:	89 d0                	mov    %edx,%eax
     cb3:	c1 e0 02             	shl    $0x2,%eax
     cb6:	01 d0                	add    %edx,%eax
     cb8:	01 c0                	add    %eax,%eax
     cba:	29 c1                	sub    %eax,%ecx
     cbc:	89 ca                	mov    %ecx,%edx
     cbe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
     cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cc4:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
     cc9:	f7 e2                	mul    %edx
     ccb:	89 d0                	mov    %edx,%eax
     ccd:	c1 e8 03             	shr    $0x3,%eax
     cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
     cd3:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
     cd7:	7f 13                	jg     cec <itoa+0x7a>
      *tp++ = i+'0';
     cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cdc:	8d 50 01             	lea    0x1(%eax),%edx
     cdf:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ce2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     ce5:	83 c2 30             	add    $0x30,%edx
     ce8:	88 10                	mov    %dl,(%eax)
     cea:	eb 11                	jmp    cfd <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
     cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cef:	8d 50 01             	lea    0x1(%eax),%edx
     cf2:	89 55 f4             	mov    %edx,-0xc(%ebp)
     cf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     cf8:	83 c2 57             	add    $0x57,%edx
     cfb:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
     cfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d01:	75 9f                	jne    ca2 <itoa+0x30>
     d03:	8d 45 bf             	lea    -0x41(%ebp),%eax
     d06:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     d09:	74 97                	je     ca2 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
     d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d0e:	8d 45 bf             	lea    -0x41(%ebp),%eax
     d11:	29 c2                	sub    %eax,%edx
     d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d16:	01 d0                	add    %edx,%eax
     d18:	83 c0 01             	add    $0x1,%eax
     d1b:	83 ec 0c             	sub    $0xc,%esp
     d1e:	50                   	push   %eax
     d1f:	e8 d9 fc ff ff       	call   9fd <malloc>
     d24:	83 c4 10             	add    $0x10,%esp
     d27:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
     d2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
     d2d:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
     d30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d34:	74 0c                	je     d42 <itoa+0xd0>
    *sp++ = '-';
     d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d39:	8d 50 01             	lea    0x1(%eax),%edx
     d3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
     d3f:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
     d42:	eb 15                	jmp    d59 <itoa+0xe7>
    *sp++ = *--tp;
     d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d47:	8d 50 01             	lea    0x1(%eax),%edx
     d4a:	89 55 ec             	mov    %edx,-0x14(%ebp)
     d4d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     d51:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d54:	0f b6 12             	movzbl (%edx),%edx
     d57:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
     d59:	8d 45 bf             	lea    -0x41(%ebp),%eax
     d5c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     d5f:	77 e3                	ja     d44 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
     d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d64:	c6 00 00             	movb   $0x0,(%eax)
  return string;
     d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
     d6a:	c9                   	leave  
     d6b:	c3                   	ret    

00000d6c <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
     d6c:	55                   	push   %ebp
     d6d:	89 e5                	mov    %esp,%ebp
     d6f:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
     d75:	83 ec 08             	sub    $0x8,%esp
     d78:	6a 00                	push   $0x0
     d7a:	ff 75 08             	pushl  0x8(%ebp)
     d7d:	e8 55 f8 ff ff       	call   5d7 <open>
     d82:	83 c4 10             	add    $0x10,%esp
     d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     d88:	e9 22 01 00 00       	jmp    eaf <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
     d8d:	83 ec 08             	sub    $0x8,%esp
     d90:	6a 3d                	push   $0x3d
     d92:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     d98:	50                   	push   %eax
     d99:	e8 79 f6 ff ff       	call   417 <strchr>
     d9e:	83 c4 10             	add    $0x10,%esp
     da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
     da4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     da8:	0f 84 23 01 00 00    	je     ed1 <parseEnvFile+0x165>
     dae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     db2:	0f 84 19 01 00 00    	je     ed1 <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
     db8:	8b 55 f0             	mov    -0x10(%ebp),%edx
     dbb:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     dc1:	29 c2                	sub    %eax,%edx
     dc3:	89 d0                	mov    %edx,%eax
     dc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
     dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     dcb:	83 c0 01             	add    $0x1,%eax
     dce:	83 ec 0c             	sub    $0xc,%esp
     dd1:	50                   	push   %eax
     dd2:	e8 26 fc ff ff       	call   9fd <malloc>
     dd7:	83 c4 10             	add    $0x10,%esp
     dda:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
     ddd:	83 ec 04             	sub    $0x4,%esp
     de0:	ff 75 ec             	pushl  -0x14(%ebp)
     de3:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     de9:	50                   	push   %eax
     dea:	ff 75 e8             	pushl  -0x18(%ebp)
     ded:	e8 8f fd ff ff       	call   b81 <strncpy>
     df2:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
     df5:	83 ec 0c             	sub    $0xc,%esp
     df8:	ff 75 e8             	pushl  -0x18(%ebp)
     dfb:	e8 c5 fd ff ff       	call   bc5 <trim>
     e00:	83 c4 10             	add    $0x10,%esp
     e03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
     e06:	83 ec 0c             	sub    $0xc,%esp
     e09:	ff 75 e8             	pushl  -0x18(%ebp)
     e0c:	e8 ab fa ff ff       	call   8bc <free>
     e11:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
     e14:	83 ec 08             	sub    $0x8,%esp
     e17:	ff 75 0c             	pushl  0xc(%ebp)
     e1a:	ff 75 e4             	pushl  -0x1c(%ebp)
     e1d:	e8 c2 01 00 00       	call   fe4 <addToEnvironment>
     e22:	83 c4 10             	add    $0x10,%esp
     e25:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
     e28:	83 ec 0c             	sub    $0xc,%esp
     e2b:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     e31:	50                   	push   %eax
     e32:	e8 9f f5 ff ff       	call   3d6 <strlen>
     e37:	83 c4 10             	add    $0x10,%esp
     e3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
     e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e40:	2b 45 ec             	sub    -0x14(%ebp),%eax
     e43:	83 ec 0c             	sub    $0xc,%esp
     e46:	50                   	push   %eax
     e47:	e8 b1 fb ff ff       	call   9fd <malloc>
     e4c:	83 c4 10             	add    $0x10,%esp
     e4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
     e52:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e55:	2b 45 ec             	sub    -0x14(%ebp),%eax
     e58:	8d 50 ff             	lea    -0x1(%eax),%edx
     e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e5e:	8d 48 01             	lea    0x1(%eax),%ecx
     e61:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     e67:	01 c8                	add    %ecx,%eax
     e69:	83 ec 04             	sub    $0x4,%esp
     e6c:	52                   	push   %edx
     e6d:	50                   	push   %eax
     e6e:	ff 75 e8             	pushl  -0x18(%ebp)
     e71:	e8 0b fd ff ff       	call   b81 <strncpy>
     e76:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
     e79:	83 ec 0c             	sub    $0xc,%esp
     e7c:	ff 75 e8             	pushl  -0x18(%ebp)
     e7f:	e8 41 fd ff ff       	call   bc5 <trim>
     e84:	83 c4 10             	add    $0x10,%esp
     e87:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
     e8a:	83 ec 0c             	sub    $0xc,%esp
     e8d:	ff 75 e8             	pushl  -0x18(%ebp)
     e90:	e8 27 fa ff ff       	call   8bc <free>
     e95:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
     e98:	83 ec 04             	sub    $0x4,%esp
     e9b:	ff 75 dc             	pushl  -0x24(%ebp)
     e9e:	ff 75 0c             	pushl  0xc(%ebp)
     ea1:	ff 75 e4             	pushl  -0x1c(%ebp)
     ea4:	e8 b8 01 00 00       	call   1061 <addValueToVariable>
     ea9:	83 c4 10             	add    $0x10,%esp
     eac:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
     eaf:	83 ec 04             	sub    $0x4,%esp
     eb2:	ff 75 f4             	pushl  -0xc(%ebp)
     eb5:	68 00 04 00 00       	push   $0x400
     eba:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
     ec0:	50                   	push   %eax
     ec1:	e8 4c fc ff ff       	call   b12 <readln>
     ec6:	83 c4 10             	add    $0x10,%esp
     ec9:	85 c0                	test   %eax,%eax
     ecb:	0f 85 bc fe ff ff    	jne    d8d <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
     ed1:	83 ec 0c             	sub    $0xc,%esp
     ed4:	ff 75 f4             	pushl  -0xc(%ebp)
     ed7:	e8 e3 f6 ff ff       	call   5bf <close>
     edc:	83 c4 10             	add    $0x10,%esp
	return head;
     edf:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     ee2:	c9                   	leave  
     ee3:	c3                   	ret    

00000ee4 <comp>:

int comp(const char* s1, const char* s2)
{
     ee4:	55                   	push   %ebp
     ee5:	89 e5                	mov    %esp,%ebp
     ee7:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
     eea:	83 ec 08             	sub    $0x8,%esp
     eed:	ff 75 0c             	pushl  0xc(%ebp)
     ef0:	ff 75 08             	pushl  0x8(%ebp)
     ef3:	e8 9f f4 ff ff       	call   397 <strcmp>
     ef8:	83 c4 10             	add    $0x10,%esp
     efb:	85 c0                	test   %eax,%eax
     efd:	0f 94 c0             	sete   %al
     f00:	0f b6 c0             	movzbl %al,%eax
}
     f03:	c9                   	leave  
     f04:	c3                   	ret    

00000f05 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
     f05:	55                   	push   %ebp
     f06:	89 e5                	mov    %esp,%ebp
     f08:	83 ec 08             	sub    $0x8,%esp
  if (!name)
     f0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f0f:	75 07                	jne    f18 <environLookup+0x13>
    return NULL;
     f11:	b8 00 00 00 00       	mov    $0x0,%eax
     f16:	eb 2f                	jmp    f47 <environLookup+0x42>
  
  while (head)
     f18:	eb 24                	jmp    f3e <environLookup+0x39>
  {
    if (comp(name, head->name))
     f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
     f1d:	83 ec 08             	sub    $0x8,%esp
     f20:	50                   	push   %eax
     f21:	ff 75 08             	pushl  0x8(%ebp)
     f24:	e8 bb ff ff ff       	call   ee4 <comp>
     f29:	83 c4 10             	add    $0x10,%esp
     f2c:	85 c0                	test   %eax,%eax
     f2e:	74 02                	je     f32 <environLookup+0x2d>
      break;
     f30:	eb 12                	jmp    f44 <environLookup+0x3f>
    head = head->next;
     f32:	8b 45 0c             	mov    0xc(%ebp),%eax
     f35:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     f3b:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
     f3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f42:	75 d6                	jne    f1a <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
     f44:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     f47:	c9                   	leave  
     f48:	c3                   	ret    

00000f49 <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
     f49:	55                   	push   %ebp
     f4a:	89 e5                	mov    %esp,%ebp
     f4c:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
     f4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f53:	75 0a                	jne    f5f <removeFromEnvironment+0x16>
    return NULL;
     f55:	b8 00 00 00 00       	mov    $0x0,%eax
     f5a:	e9 83 00 00 00       	jmp    fe2 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
     f5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f63:	74 0a                	je     f6f <removeFromEnvironment+0x26>
     f65:	8b 45 08             	mov    0x8(%ebp),%eax
     f68:	0f b6 00             	movzbl (%eax),%eax
     f6b:	84 c0                	test   %al,%al
     f6d:	75 05                	jne    f74 <removeFromEnvironment+0x2b>
    return head;
     f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
     f72:	eb 6e                	jmp    fe2 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
     f74:	8b 45 0c             	mov    0xc(%ebp),%eax
     f77:	83 ec 08             	sub    $0x8,%esp
     f7a:	ff 75 08             	pushl  0x8(%ebp)
     f7d:	50                   	push   %eax
     f7e:	e8 61 ff ff ff       	call   ee4 <comp>
     f83:	83 c4 10             	add    $0x10,%esp
     f86:	85 c0                	test   %eax,%eax
     f88:	74 34                	je     fbe <removeFromEnvironment+0x75>
  {
    tmp = head->next;
     f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
     f8d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
     f96:	8b 45 0c             	mov    0xc(%ebp),%eax
     f99:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     f9f:	83 ec 0c             	sub    $0xc,%esp
     fa2:	50                   	push   %eax
     fa3:	e8 74 01 00 00       	call   111c <freeVarval>
     fa8:	83 c4 10             	add    $0x10,%esp
    free(head);
     fab:	83 ec 0c             	sub    $0xc,%esp
     fae:	ff 75 0c             	pushl  0xc(%ebp)
     fb1:	e8 06 f9 ff ff       	call   8bc <free>
     fb6:	83 c4 10             	add    $0x10,%esp
    return tmp;
     fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fbc:	eb 24                	jmp    fe2 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
     fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
     fc1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
     fc7:	83 ec 08             	sub    $0x8,%esp
     fca:	50                   	push   %eax
     fcb:	ff 75 08             	pushl  0x8(%ebp)
     fce:	e8 76 ff ff ff       	call   f49 <removeFromEnvironment>
     fd3:	83 c4 10             	add    $0x10,%esp
     fd6:	8b 55 0c             	mov    0xc(%ebp),%edx
     fd9:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
     fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
}
     fe2:	c9                   	leave  
     fe3:	c3                   	ret    

00000fe4 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
     fe4:	55                   	push   %ebp
     fe5:	89 e5                	mov    %esp,%ebp
     fe7:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
     fea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fee:	75 05                	jne    ff5 <addToEnvironment+0x11>
		return head;
     ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
     ff3:	eb 6a                	jmp    105f <addToEnvironment+0x7b>
	if (head == NULL) {
     ff5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     ff9:	75 40                	jne    103b <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
     ffb:	83 ec 0c             	sub    $0xc,%esp
     ffe:	68 88 00 00 00       	push   $0x88
    1003:	e8 f5 f9 ff ff       	call   9fd <malloc>
    1008:	83 c4 10             	add    $0x10,%esp
    100b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
    100e:	8b 45 08             	mov    0x8(%ebp),%eax
    1011:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
    1014:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1017:	83 ec 08             	sub    $0x8,%esp
    101a:	ff 75 f0             	pushl  -0x10(%ebp)
    101d:	50                   	push   %eax
    101e:	e8 44 f3 ff ff       	call   367 <strcpy>
    1023:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
    1026:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1029:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
    1030:	00 00 00 
		head = newVar;
    1033:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1036:	89 45 0c             	mov    %eax,0xc(%ebp)
    1039:	eb 21                	jmp    105c <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
    103b:	8b 45 0c             	mov    0xc(%ebp),%eax
    103e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    1044:	83 ec 08             	sub    $0x8,%esp
    1047:	50                   	push   %eax
    1048:	ff 75 08             	pushl  0x8(%ebp)
    104b:	e8 94 ff ff ff       	call   fe4 <addToEnvironment>
    1050:	83 c4 10             	add    $0x10,%esp
    1053:	8b 55 0c             	mov    0xc(%ebp),%edx
    1056:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
    105c:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    105f:	c9                   	leave  
    1060:	c3                   	ret    

00001061 <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
    1061:	55                   	push   %ebp
    1062:	89 e5                	mov    %esp,%ebp
    1064:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
    1067:	83 ec 08             	sub    $0x8,%esp
    106a:	ff 75 0c             	pushl  0xc(%ebp)
    106d:	ff 75 08             	pushl  0x8(%ebp)
    1070:	e8 90 fe ff ff       	call   f05 <environLookup>
    1075:	83 c4 10             	add    $0x10,%esp
    1078:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
    107b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    107f:	75 05                	jne    1086 <addValueToVariable+0x25>
		return head;
    1081:	8b 45 0c             	mov    0xc(%ebp),%eax
    1084:	eb 4c                	jmp    10d2 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
    1086:	83 ec 0c             	sub    $0xc,%esp
    1089:	68 04 04 00 00       	push   $0x404
    108e:	e8 6a f9 ff ff       	call   9fd <malloc>
    1093:	83 c4 10             	add    $0x10,%esp
    1096:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
    1099:	8b 45 10             	mov    0x10(%ebp),%eax
    109c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
    109f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10a2:	83 ec 08             	sub    $0x8,%esp
    10a5:	ff 75 ec             	pushl  -0x14(%ebp)
    10a8:	50                   	push   %eax
    10a9:	e8 b9 f2 ff ff       	call   367 <strcpy>
    10ae:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
    10b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b4:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
    10ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10bd:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
    10c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
    10c9:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
    10cf:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    10d2:	c9                   	leave  
    10d3:	c3                   	ret    

000010d4 <freeEnvironment>:

void freeEnvironment(variable* head)
{
    10d4:	55                   	push   %ebp
    10d5:	89 e5                	mov    %esp,%ebp
    10d7:	83 ec 08             	sub    $0x8,%esp
  if (!head)
    10da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10de:	75 02                	jne    10e2 <freeEnvironment+0xe>
    return;  
    10e0:	eb 38                	jmp    111a <freeEnvironment+0x46>
  freeEnvironment(head->next);
    10e2:	8b 45 08             	mov    0x8(%ebp),%eax
    10e5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    10eb:	83 ec 0c             	sub    $0xc,%esp
    10ee:	50                   	push   %eax
    10ef:	e8 e0 ff ff ff       	call   10d4 <freeEnvironment>
    10f4:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
    10f7:	8b 45 08             	mov    0x8(%ebp),%eax
    10fa:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
    1100:	83 ec 0c             	sub    $0xc,%esp
    1103:	50                   	push   %eax
    1104:	e8 13 00 00 00       	call   111c <freeVarval>
    1109:	83 c4 10             	add    $0x10,%esp
  free(head);
    110c:	83 ec 0c             	sub    $0xc,%esp
    110f:	ff 75 08             	pushl  0x8(%ebp)
    1112:	e8 a5 f7 ff ff       	call   8bc <free>
    1117:	83 c4 10             	add    $0x10,%esp
}
    111a:	c9                   	leave  
    111b:	c3                   	ret    

0000111c <freeVarval>:

void freeVarval(varval* head)
{
    111c:	55                   	push   %ebp
    111d:	89 e5                	mov    %esp,%ebp
    111f:	83 ec 08             	sub    $0x8,%esp
  if (!head)
    1122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1126:	75 02                	jne    112a <freeVarval+0xe>
    return;  
    1128:	eb 23                	jmp    114d <freeVarval+0x31>
  freeVarval(head->next);
    112a:	8b 45 08             	mov    0x8(%ebp),%eax
    112d:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
    1133:	83 ec 0c             	sub    $0xc,%esp
    1136:	50                   	push   %eax
    1137:	e8 e0 ff ff ff       	call   111c <freeVarval>
    113c:	83 c4 10             	add    $0x10,%esp
  free(head);
    113f:	83 ec 0c             	sub    $0xc,%esp
    1142:	ff 75 08             	pushl  0x8(%ebp)
    1145:	e8 72 f7 ff ff       	call   8bc <free>
    114a:	83 c4 10             	add    $0x10,%esp
}
    114d:	c9                   	leave  
    114e:	c3                   	ret    

0000114f <getPaths>:

varval* getPaths(char* paths, varval* head) {
    114f:	55                   	push   %ebp
    1150:	89 e5                	mov    %esp,%ebp
    1152:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
    1155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1159:	75 08                	jne    1163 <getPaths+0x14>
		return head;
    115b:	8b 45 0c             	mov    0xc(%ebp),%eax
    115e:	e9 e7 00 00 00       	jmp    124a <getPaths+0xfb>
	if (head == NULL) {
    1163:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1167:	0f 85 b9 00 00 00    	jne    1226 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
    116d:	83 ec 08             	sub    $0x8,%esp
    1170:	6a 3a                	push   $0x3a
    1172:	ff 75 08             	pushl  0x8(%ebp)
    1175:	e8 9d f2 ff ff       	call   417 <strchr>
    117a:	83 c4 10             	add    $0x10,%esp
    117d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
    1180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1184:	75 56                	jne    11dc <getPaths+0x8d>
			pathLen = strlen(paths);
    1186:	83 ec 0c             	sub    $0xc,%esp
    1189:	ff 75 08             	pushl  0x8(%ebp)
    118c:	e8 45 f2 ff ff       	call   3d6 <strlen>
    1191:	83 c4 10             	add    $0x10,%esp
    1194:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
    1197:	83 ec 0c             	sub    $0xc,%esp
    119a:	68 04 04 00 00       	push   $0x404
    119f:	e8 59 f8 ff ff       	call   9fd <malloc>
    11a4:	83 c4 10             	add    $0x10,%esp
    11a7:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
    11aa:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ad:	83 ec 04             	sub    $0x4,%esp
    11b0:	ff 75 f0             	pushl  -0x10(%ebp)
    11b3:	ff 75 08             	pushl  0x8(%ebp)
    11b6:	50                   	push   %eax
    11b7:	e8 c5 f9 ff ff       	call   b81 <strncpy>
    11bc:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
    11bf:	8b 55 0c             	mov    0xc(%ebp),%edx
    11c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11c5:	01 d0                	add    %edx,%eax
    11c7:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
    11ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    11cd:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
    11d4:	00 00 00 
			return head;
    11d7:	8b 45 0c             	mov    0xc(%ebp),%eax
    11da:	eb 6e                	jmp    124a <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
    11dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11df:	8b 45 08             	mov    0x8(%ebp),%eax
    11e2:	29 c2                	sub    %eax,%edx
    11e4:	89 d0                	mov    %edx,%eax
    11e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
    11e9:	83 ec 0c             	sub    $0xc,%esp
    11ec:	68 04 04 00 00       	push   $0x404
    11f1:	e8 07 f8 ff ff       	call   9fd <malloc>
    11f6:	83 c4 10             	add    $0x10,%esp
    11f9:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
    11fc:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ff:	83 ec 04             	sub    $0x4,%esp
    1202:	ff 75 f0             	pushl  -0x10(%ebp)
    1205:	ff 75 08             	pushl  0x8(%ebp)
    1208:	50                   	push   %eax
    1209:	e8 73 f9 ff ff       	call   b81 <strncpy>
    120e:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
    1211:	8b 55 0c             	mov    0xc(%ebp),%edx
    1214:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1217:	01 d0                	add    %edx,%eax
    1219:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
    121c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    121f:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
    1222:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
    1226:	8b 45 0c             	mov    0xc(%ebp),%eax
    1229:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
    122f:	83 ec 08             	sub    $0x8,%esp
    1232:	50                   	push   %eax
    1233:	ff 75 08             	pushl  0x8(%ebp)
    1236:	e8 14 ff ff ff       	call   114f <getPaths>
    123b:	83 c4 10             	add    $0x10,%esp
    123e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1241:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
    1247:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    124a:	c9                   	leave  
    124b:	c3                   	ret    
