
_sh:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <runcmd>:
varval* paths;

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	81 ec 24 01 00 00    	sub    $0x124,%esp
  struct pipecmd *pcmd;
  struct redircmd *rcmd;
  varval* path;
  char fullPath[MAX_CMD_PATH_LEN];

  if(cmd == 0)
       a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       e:	75 05                	jne    15 <runcmd+0x15>
    exit();
      10:	e8 95 0f 00 00       	call   faa <exit>
  
  switch(cmd->type){
      15:	8b 45 08             	mov    0x8(%ebp),%eax
      18:	8b 00                	mov    (%eax),%eax
      1a:	83 f8 05             	cmp    $0x5,%eax
      1d:	77 09                	ja     28 <runcmd+0x28>
      1f:	8b 04 85 ac 1c 00 00 	mov    0x1cac(,%eax,4),%eax
      26:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      28:	83 ec 0c             	sub    $0xc,%esp
      2b:	68 60 1c 00 00       	push   $0x1c60
      30:	e8 44 04 00 00       	call   479 <panic>
      35:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      38:	8b 45 08             	mov    0x8(%ebp),%eax
      3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(ecmd->argv[0] == 0)
      3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      41:	8b 40 04             	mov    0x4(%eax),%eax
      44:	85 c0                	test   %eax,%eax
      46:	75 05                	jne    4d <runcmd+0x4d>
      exit();
      48:	e8 5d 0f 00 00       	call   faa <exit>
    path = paths;
      4d:	a1 b0 24 00 00       	mov    0x24b0,%eax
      52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (path) {
      55:	eb 65                	jmp    bc <runcmd+0xbc>
		strcpy(fullPath,path->value);
      57:	8b 45 f4             	mov    -0xc(%ebp),%eax
      5a:	83 ec 08             	sub    $0x8,%esp
      5d:	50                   	push   %eax
      5e:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
      64:	50                   	push   %eax
      65:	e8 10 0d 00 00       	call   d7a <strcpy>
      6a:	83 c4 10             	add    $0x10,%esp
		strcpy(fullPath + strlen(path->value),ecmd->argv[0]);
      6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
      70:	8b 58 04             	mov    0x4(%eax),%ebx
      73:	8b 45 f4             	mov    -0xc(%ebp),%eax
      76:	83 ec 0c             	sub    $0xc,%esp
      79:	50                   	push   %eax
      7a:	e8 6a 0d 00 00       	call   de9 <strlen>
      7f:	83 c4 10             	add    $0x10,%esp
      82:	8d 95 d8 fe ff ff    	lea    -0x128(%ebp),%edx
      88:	01 d0                	add    %edx,%eax
      8a:	83 ec 08             	sub    $0x8,%esp
      8d:	53                   	push   %ebx
      8e:	50                   	push   %eax
      8f:	e8 e6 0c 00 00       	call   d7a <strcpy>
      94:	83 c4 10             	add    $0x10,%esp
		exec(fullPath, ecmd->argv);
      97:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9a:	83 c0 04             	add    $0x4,%eax
      9d:	83 ec 08             	sub    $0x8,%esp
      a0:	50                   	push   %eax
      a1:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
      a7:	50                   	push   %eax
      a8:	e8 35 0f 00 00       	call   fe2 <exec>
      ad:	83 c4 10             	add    $0x10,%esp
		path = path->next;
      b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
      b3:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
      b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
      exit();
    path = paths;
    while (path) {
      bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      c0:	75 95                	jne    57 <runcmd+0x57>
		strcpy(fullPath,path->value);
		strcpy(fullPath + strlen(path->value),ecmd->argv[0]);
		exec(fullPath, ecmd->argv);
		path = path->next;
	}
    printf(2, "sh: %s: command not found\n", ecmd->argv[0]);
      c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
      c5:	8b 40 04             	mov    0x4(%eax),%eax
      c8:	83 ec 04             	sub    $0x4,%esp
      cb:	50                   	push   %eax
      cc:	68 67 1c 00 00       	push   $0x1c67
      d1:	6a 02                	push   $0x2
      d3:	e8 67 10 00 00       	call   113f <printf>
      d8:	83 c4 10             	add    $0x10,%esp
    break;
      db:	e9 c8 01 00 00       	jmp    2a8 <runcmd+0x2a8>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      e0:	8b 45 08             	mov    0x8(%ebp),%eax
      e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(rcmd->fd);
      e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
      e9:	8b 40 14             	mov    0x14(%eax),%eax
      ec:	83 ec 0c             	sub    $0xc,%esp
      ef:	50                   	push   %eax
      f0:	e8 dd 0e 00 00       	call   fd2 <close>
      f5:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fb:	8b 50 10             	mov    0x10(%eax),%edx
      fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
     101:	8b 40 08             	mov    0x8(%eax),%eax
     104:	83 ec 08             	sub    $0x8,%esp
     107:	52                   	push   %edx
     108:	50                   	push   %eax
     109:	e8 dc 0e 00 00       	call   fea <open>
     10e:	83 c4 10             	add    $0x10,%esp
     111:	85 c0                	test   %eax,%eax
     113:	79 1e                	jns    133 <runcmd+0x133>
      printf(2, "sh: %s: no such file or directory\n", rcmd->file);
     115:	8b 45 ec             	mov    -0x14(%ebp),%eax
     118:	8b 40 08             	mov    0x8(%eax),%eax
     11b:	83 ec 04             	sub    $0x4,%esp
     11e:	50                   	push   %eax
     11f:	68 84 1c 00 00       	push   $0x1c84
     124:	6a 02                	push   $0x2
     126:	e8 14 10 00 00       	call   113f <printf>
     12b:	83 c4 10             	add    $0x10,%esp
      exit();
     12e:	e8 77 0e 00 00       	call   faa <exit>
    }
    runcmd(rcmd->cmd);
     133:	8b 45 ec             	mov    -0x14(%ebp),%eax
     136:	8b 40 04             	mov    0x4(%eax),%eax
     139:	83 ec 0c             	sub    $0xc,%esp
     13c:	50                   	push   %eax
     13d:	e8 be fe ff ff       	call   0 <runcmd>
     142:	83 c4 10             	add    $0x10,%esp
    break;
     145:	e9 5e 01 00 00       	jmp    2a8 <runcmd+0x2a8>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     14a:	8b 45 08             	mov    0x8(%ebp),%eax
     14d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fork1() == 0)
     150:	e8 44 03 00 00       	call   499 <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 12                	jne    16b <runcmd+0x16b>
      runcmd(lcmd->left);
     159:	8b 45 e8             	mov    -0x18(%ebp),%eax
     15c:	8b 40 04             	mov    0x4(%eax),%eax
     15f:	83 ec 0c             	sub    $0xc,%esp
     162:	50                   	push   %eax
     163:	e8 98 fe ff ff       	call   0 <runcmd>
     168:	83 c4 10             	add    $0x10,%esp
    wait();
     16b:	e8 42 0e 00 00       	call   fb2 <wait>
    runcmd(lcmd->right);
     170:	8b 45 e8             	mov    -0x18(%ebp),%eax
     173:	8b 40 08             	mov    0x8(%eax),%eax
     176:	83 ec 0c             	sub    $0xc,%esp
     179:	50                   	push   %eax
     17a:	e8 81 fe ff ff       	call   0 <runcmd>
     17f:	83 c4 10             	add    $0x10,%esp
    break;
     182:	e9 21 01 00 00       	jmp    2a8 <runcmd+0x2a8>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     187:	8b 45 08             	mov    0x8(%ebp),%eax
     18a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pipe(p) < 0)
     18d:	83 ec 0c             	sub    $0xc,%esp
     190:	8d 45 d8             	lea    -0x28(%ebp),%eax
     193:	50                   	push   %eax
     194:	e8 21 0e 00 00       	call   fba <pipe>
     199:	83 c4 10             	add    $0x10,%esp
     19c:	85 c0                	test   %eax,%eax
     19e:	79 10                	jns    1b0 <runcmd+0x1b0>
      panic("pipe");
     1a0:	83 ec 0c             	sub    $0xc,%esp
     1a3:	68 a7 1c 00 00       	push   $0x1ca7
     1a8:	e8 cc 02 00 00       	call   479 <panic>
     1ad:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     1b0:	e8 e4 02 00 00       	call   499 <fork1>
     1b5:	85 c0                	test   %eax,%eax
     1b7:	75 4c                	jne    205 <runcmd+0x205>
      close(1);
     1b9:	83 ec 0c             	sub    $0xc,%esp
     1bc:	6a 01                	push   $0x1
     1be:	e8 0f 0e 00 00       	call   fd2 <close>
     1c3:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     1c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c9:	83 ec 0c             	sub    $0xc,%esp
     1cc:	50                   	push   %eax
     1cd:	e8 50 0e 00 00       	call   1022 <dup>
     1d2:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
     1d8:	83 ec 0c             	sub    $0xc,%esp
     1db:	50                   	push   %eax
     1dc:	e8 f1 0d 00 00       	call   fd2 <close>
     1e1:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1e7:	83 ec 0c             	sub    $0xc,%esp
     1ea:	50                   	push   %eax
     1eb:	e8 e2 0d 00 00       	call   fd2 <close>
     1f0:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     1f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f6:	8b 40 04             	mov    0x4(%eax),%eax
     1f9:	83 ec 0c             	sub    $0xc,%esp
     1fc:	50                   	push   %eax
     1fd:	e8 fe fd ff ff       	call   0 <runcmd>
     202:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     205:	e8 8f 02 00 00       	call   499 <fork1>
     20a:	85 c0                	test   %eax,%eax
     20c:	75 4c                	jne    25a <runcmd+0x25a>
      close(0);
     20e:	83 ec 0c             	sub    $0xc,%esp
     211:	6a 00                	push   $0x0
     213:	e8 ba 0d 00 00       	call   fd2 <close>
     218:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     21b:	8b 45 d8             	mov    -0x28(%ebp),%eax
     21e:	83 ec 0c             	sub    $0xc,%esp
     221:	50                   	push   %eax
     222:	e8 fb 0d 00 00       	call   1022 <dup>
     227:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     22a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     22d:	83 ec 0c             	sub    $0xc,%esp
     230:	50                   	push   %eax
     231:	e8 9c 0d 00 00       	call   fd2 <close>
     236:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     239:	8b 45 dc             	mov    -0x24(%ebp),%eax
     23c:	83 ec 0c             	sub    $0xc,%esp
     23f:	50                   	push   %eax
     240:	e8 8d 0d 00 00       	call   fd2 <close>
     245:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     24b:	8b 40 08             	mov    0x8(%eax),%eax
     24e:	83 ec 0c             	sub    $0xc,%esp
     251:	50                   	push   %eax
     252:	e8 a9 fd ff ff       	call   0 <runcmd>
     257:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     25a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     25d:	83 ec 0c             	sub    $0xc,%esp
     260:	50                   	push   %eax
     261:	e8 6c 0d 00 00       	call   fd2 <close>
     266:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     269:	8b 45 dc             	mov    -0x24(%ebp),%eax
     26c:	83 ec 0c             	sub    $0xc,%esp
     26f:	50                   	push   %eax
     270:	e8 5d 0d 00 00       	call   fd2 <close>
     275:	83 c4 10             	add    $0x10,%esp
    wait();
     278:	e8 35 0d 00 00       	call   fb2 <wait>
    wait();
     27d:	e8 30 0d 00 00       	call   fb2 <wait>
    break;
     282:	eb 24                	jmp    2a8 <runcmd+0x2a8>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     284:	8b 45 08             	mov    0x8(%ebp),%eax
     287:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(fork1() == 0)
     28a:	e8 0a 02 00 00       	call   499 <fork1>
     28f:	85 c0                	test   %eax,%eax
     291:	75 14                	jne    2a7 <runcmd+0x2a7>
      runcmd(bcmd->cmd);
     293:	8b 45 e0             	mov    -0x20(%ebp),%eax
     296:	8b 40 04             	mov    0x4(%eax),%eax
     299:	83 ec 0c             	sub    $0xc,%esp
     29c:	50                   	push   %eax
     29d:	e8 5e fd ff ff       	call   0 <runcmd>
     2a2:	83 c4 10             	add    $0x10,%esp
    break;
     2a5:	eb 00                	jmp    2a7 <runcmd+0x2a7>
     2a7:	90                   	nop
  }
  exit();
     2a8:	e8 fd 0c 00 00       	call   faa <exit>

000002ad <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     2ad:	55                   	push   %ebp
     2ae:	89 e5                	mov    %esp,%ebp
     2b0:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     2b3:	83 ec 08             	sub    $0x8,%esp
     2b6:	68 c4 1c 00 00       	push   $0x1cc4
     2bb:	6a 02                	push   $0x2
     2bd:	e8 7d 0e 00 00       	call   113f <printf>
     2c2:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     2c5:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c8:	83 ec 04             	sub    $0x4,%esp
     2cb:	50                   	push   %eax
     2cc:	6a 00                	push   $0x0
     2ce:	ff 75 08             	pushl  0x8(%ebp)
     2d1:	e8 3a 0b 00 00       	call   e10 <memset>
     2d6:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     2d9:	83 ec 08             	sub    $0x8,%esp
     2dc:	ff 75 0c             	pushl  0xc(%ebp)
     2df:	ff 75 08             	pushl  0x8(%ebp)
     2e2:	e8 76 0b 00 00       	call   e5d <gets>
     2e7:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     2ea:	8b 45 08             	mov    0x8(%ebp),%eax
     2ed:	0f b6 00             	movzbl (%eax),%eax
     2f0:	84 c0                	test   %al,%al
     2f2:	75 07                	jne    2fb <getcmd+0x4e>
    return -1;
     2f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     2f9:	eb 05                	jmp    300 <getcmd+0x53>
  return 0;
     2fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     300:	c9                   	leave  
     301:	c3                   	ret    

00000302 <main>:

int
main(void)
{
     302:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     306:	83 e4 f0             	and    $0xfffffff0,%esp
     309:	ff 71 fc             	pushl  -0x4(%ecx)
     30c:	55                   	push   %ebp
     30d:	89 e5                	mov    %esp,%ebp
     30f:	51                   	push   %ecx
     310:	83 ec 14             	sub    $0x14,%esp
	variable* var;
	static char buf[100];
	int fd;
  
  // Assumes three file descriptors open.
	while((fd = open("console", O_RDWR)) >= 0){
     313:	eb 16                	jmp    32b <main+0x29>
		if(fd >= 3){
     315:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     319:	7e 10                	jle    32b <main+0x29>
		  close(fd);
     31b:	83 ec 0c             	sub    $0xc,%esp
     31e:	ff 75 f4             	pushl  -0xc(%ebp)
     321:	e8 ac 0c 00 00       	call   fd2 <close>
     326:	83 c4 10             	add    $0x10,%esp
		  break;
     329:	eb 1b                	jmp    346 <main+0x44>
	variable* var;
	static char buf[100];
	int fd;
  
  // Assumes three file descriptors open.
	while((fd = open("console", O_RDWR)) >= 0){
     32b:	83 ec 08             	sub    $0x8,%esp
     32e:	6a 02                	push   $0x2
     330:	68 c7 1c 00 00       	push   $0x1cc7
     335:	e8 b0 0c 00 00       	call   fea <open>
     33a:	83 c4 10             	add    $0x10,%esp
     33d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     344:	79 cf                	jns    315 <main+0x13>
		  break;
		}
	}
	
	// load and parse env file
	head = NULL;
     346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	head = parseEnvFile(ENV_FILENAME,head);
     34d:	83 ec 08             	sub    $0x8,%esp
     350:	ff 75 f0             	pushl  -0x10(%ebp)
     353:	68 cf 1c 00 00       	push   $0x1ccf
     358:	e8 22 14 00 00       	call   177f <parseEnvFile>
     35d:	83 c4 10             	add    $0x10,%esp
     360:	89 45 f0             	mov    %eax,-0x10(%ebp)
	var = environLookup(PATH_VAR,head);
     363:	83 ec 08             	sub    $0x8,%esp
     366:	ff 75 f0             	pushl  -0x10(%ebp)
     369:	68 d8 1c 00 00       	push   $0x1cd8
     36e:	e8 a5 15 00 00       	call   1918 <environLookup>
     373:	83 c4 10             	add    $0x10,%esp
     376:	89 45 ec             	mov    %eax,-0x14(%ebp)
	paths = NULL;
     379:	c7 05 b0 24 00 00 00 	movl   $0x0,0x24b0
     380:	00 00 00 
	paths = getPaths(var->values->value,paths);
     383:	8b 15 b0 24 00 00    	mov    0x24b0,%edx
     389:	8b 45 ec             	mov    -0x14(%ebp),%eax
     38c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
     392:	83 ec 08             	sub    $0x8,%esp
     395:	52                   	push   %edx
     396:	50                   	push   %eax
     397:	e8 c6 17 00 00       	call   1b62 <getPaths>
     39c:	83 c4 10             	add    $0x10,%esp
     39f:	a3 b0 24 00 00       	mov    %eax,0x24b0

	
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     3a4:	e9 92 00 00 00       	jmp    43b <main+0x139>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     3a9:	0f b6 05 40 24 00 00 	movzbl 0x2440,%eax
     3b0:	3c 63                	cmp    $0x63,%al
     3b2:	75 5d                	jne    411 <main+0x10f>
     3b4:	0f b6 05 41 24 00 00 	movzbl 0x2441,%eax
     3bb:	3c 64                	cmp    $0x64,%al
     3bd:	75 52                	jne    411 <main+0x10f>
     3bf:	0f b6 05 42 24 00 00 	movzbl 0x2442,%eax
     3c6:	3c 20                	cmp    $0x20,%al
     3c8:	75 47                	jne    411 <main+0x10f>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     3ca:	83 ec 0c             	sub    $0xc,%esp
     3cd:	68 40 24 00 00       	push   $0x2440
     3d2:	e8 12 0a 00 00       	call   de9 <strlen>
     3d7:	83 c4 10             	add    $0x10,%esp
     3da:	83 e8 01             	sub    $0x1,%eax
     3dd:	c6 80 40 24 00 00 00 	movb   $0x0,0x2440(%eax)
      if(chdir(buf+3) < 0)
     3e4:	83 ec 0c             	sub    $0xc,%esp
     3e7:	68 43 24 00 00       	push   $0x2443
     3ec:	e8 29 0c 00 00       	call   101a <chdir>
     3f1:	83 c4 10             	add    $0x10,%esp
     3f4:	85 c0                	test   %eax,%eax
     3f6:	79 17                	jns    40f <main+0x10d>
        printf(2, "sh: cd: %s: no such file or directory\n", buf+3);
     3f8:	83 ec 04             	sub    $0x4,%esp
     3fb:	68 43 24 00 00       	push   $0x2443
     400:	68 e0 1c 00 00       	push   $0x1ce0
     405:	6a 02                	push   $0x2
     407:	e8 33 0d 00 00       	call   113f <printf>
     40c:	83 c4 10             	add    $0x10,%esp
      continue;
     40f:	eb 2a                	jmp    43b <main+0x139>
    }
    if(fork1() == 0)
     411:	e8 83 00 00 00       	call   499 <fork1>
     416:	85 c0                	test   %eax,%eax
     418:	75 1c                	jne    436 <main+0x134>
		runcmd(parsecmd(buf));
     41a:	83 ec 0c             	sub    $0xc,%esp
     41d:	68 40 24 00 00       	push   $0x2440
     422:	e8 c6 03 00 00       	call   7ed <parsecmd>
     427:	83 c4 10             	add    $0x10,%esp
     42a:	83 ec 0c             	sub    $0xc,%esp
     42d:	50                   	push   %eax
     42e:	e8 cd fb ff ff       	call   0 <runcmd>
     433:	83 c4 10             	add    $0x10,%esp
		wait();
     436:	e8 77 0b 00 00       	call   fb2 <wait>
	paths = getPaths(var->values->value,paths);

	
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     43b:	83 ec 08             	sub    $0x8,%esp
     43e:	6a 64                	push   $0x64
     440:	68 40 24 00 00       	push   $0x2440
     445:	e8 63 fe ff ff       	call   2ad <getcmd>
     44a:	83 c4 10             	add    $0x10,%esp
     44d:	85 c0                	test   %eax,%eax
     44f:	0f 89 54 ff ff ff    	jns    3a9 <main+0xa7>
    if(fork1() == 0)
		runcmd(parsecmd(buf));
		wait();
    }
  
	freeVarval(paths);
     455:	a1 b0 24 00 00       	mov    0x24b0,%eax
     45a:	83 ec 0c             	sub    $0xc,%esp
     45d:	50                   	push   %eax
     45e:	e8 cc 16 00 00       	call   1b2f <freeVarval>
     463:	83 c4 10             	add    $0x10,%esp
	freeEnvironment(head);
     466:	83 ec 0c             	sub    $0xc,%esp
     469:	ff 75 f0             	pushl  -0x10(%ebp)
     46c:	e8 76 16 00 00       	call   1ae7 <freeEnvironment>
     471:	83 c4 10             	add    $0x10,%esp
	
	exit();
     474:	e8 31 0b 00 00       	call   faa <exit>

00000479 <panic>:
}

void
panic(char *s)
{
     479:	55                   	push   %ebp
     47a:	89 e5                	mov    %esp,%ebp
     47c:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     47f:	83 ec 04             	sub    $0x4,%esp
     482:	ff 75 08             	pushl  0x8(%ebp)
     485:	68 07 1d 00 00       	push   $0x1d07
     48a:	6a 02                	push   $0x2
     48c:	e8 ae 0c 00 00       	call   113f <printf>
     491:	83 c4 10             	add    $0x10,%esp
  exit();
     494:	e8 11 0b 00 00       	call   faa <exit>

00000499 <fork1>:
}

int
fork1(void)
{
     499:	55                   	push   %ebp
     49a:	89 e5                	mov    %esp,%ebp
     49c:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  pid = fork();
     49f:	e8 fe 0a 00 00       	call   fa2 <fork>
     4a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     4a7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     4ab:	75 10                	jne    4bd <fork1+0x24>
    panic("fork");
     4ad:	83 ec 0c             	sub    $0xc,%esp
     4b0:	68 0b 1d 00 00       	push   $0x1d0b
     4b5:	e8 bf ff ff ff       	call   479 <panic>
     4ba:	83 c4 10             	add    $0x10,%esp
  return pid;
     4bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4c0:	c9                   	leave  
     4c1:	c3                   	ret    

000004c2 <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     4c2:	55                   	push   %ebp
     4c3:	89 e5                	mov    %esp,%ebp
     4c5:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4c8:	83 ec 0c             	sub    $0xc,%esp
     4cb:	6a 54                	push   $0x54
     4cd:	e8 3e 0f 00 00       	call   1410 <malloc>
     4d2:	83 c4 10             	add    $0x10,%esp
     4d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4d8:	83 ec 04             	sub    $0x4,%esp
     4db:	6a 54                	push   $0x54
     4dd:	6a 00                	push   $0x0
     4df:	ff 75 f4             	pushl  -0xc(%ebp)
     4e2:	e8 29 09 00 00       	call   e10 <memset>
     4e7:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     4ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     4f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4f6:	c9                   	leave  
     4f7:	c3                   	ret    

000004f8 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     4f8:	55                   	push   %ebp
     4f9:	89 e5                	mov    %esp,%ebp
     4fb:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4fe:	83 ec 0c             	sub    $0xc,%esp
     501:	6a 18                	push   $0x18
     503:	e8 08 0f 00 00       	call   1410 <malloc>
     508:	83 c4 10             	add    $0x10,%esp
     50b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     50e:	83 ec 04             	sub    $0x4,%esp
     511:	6a 18                	push   $0x18
     513:	6a 00                	push   $0x0
     515:	ff 75 f4             	pushl  -0xc(%ebp)
     518:	e8 f3 08 00 00       	call   e10 <memset>
     51d:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     520:	8b 45 f4             	mov    -0xc(%ebp),%eax
     523:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     529:	8b 45 f4             	mov    -0xc(%ebp),%eax
     52c:	8b 55 08             	mov    0x8(%ebp),%edx
     52f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     532:	8b 45 f4             	mov    -0xc(%ebp),%eax
     535:	8b 55 0c             	mov    0xc(%ebp),%edx
     538:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     53b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     53e:	8b 55 10             	mov    0x10(%ebp),%edx
     541:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     544:	8b 45 f4             	mov    -0xc(%ebp),%eax
     547:	8b 55 14             	mov    0x14(%ebp),%edx
     54a:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     54d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     550:	8b 55 18             	mov    0x18(%ebp),%edx
     553:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     556:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     559:	c9                   	leave  
     55a:	c3                   	ret    

0000055b <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     55b:	55                   	push   %ebp
     55c:	89 e5                	mov    %esp,%ebp
     55e:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     561:	83 ec 0c             	sub    $0xc,%esp
     564:	6a 0c                	push   $0xc
     566:	e8 a5 0e 00 00       	call   1410 <malloc>
     56b:	83 c4 10             	add    $0x10,%esp
     56e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     571:	83 ec 04             	sub    $0x4,%esp
     574:	6a 0c                	push   $0xc
     576:	6a 00                	push   $0x0
     578:	ff 75 f4             	pushl  -0xc(%ebp)
     57b:	e8 90 08 00 00       	call   e10 <memset>
     580:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     583:	8b 45 f4             	mov    -0xc(%ebp),%eax
     586:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     58c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     58f:	8b 55 08             	mov    0x8(%ebp),%edx
     592:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     595:	8b 45 f4             	mov    -0xc(%ebp),%eax
     598:	8b 55 0c             	mov    0xc(%ebp),%edx
     59b:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     59e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     5a1:	c9                   	leave  
     5a2:	c3                   	ret    

000005a3 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     5a3:	55                   	push   %ebp
     5a4:	89 e5                	mov    %esp,%ebp
     5a6:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     5a9:	83 ec 0c             	sub    $0xc,%esp
     5ac:	6a 0c                	push   $0xc
     5ae:	e8 5d 0e 00 00       	call   1410 <malloc>
     5b3:	83 c4 10             	add    $0x10,%esp
     5b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     5b9:	83 ec 04             	sub    $0x4,%esp
     5bc:	6a 0c                	push   $0xc
     5be:	6a 00                	push   $0x0
     5c0:	ff 75 f4             	pushl  -0xc(%ebp)
     5c3:	e8 48 08 00 00       	call   e10 <memset>
     5c8:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     5cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ce:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     5d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5d7:	8b 55 08             	mov    0x8(%ebp),%edx
     5da:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     5dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e0:	8b 55 0c             	mov    0xc(%ebp),%edx
     5e3:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     5e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     5e9:	c9                   	leave  
     5ea:	c3                   	ret    

000005eb <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     5eb:	55                   	push   %ebp
     5ec:	89 e5                	mov    %esp,%ebp
     5ee:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     5f1:	83 ec 0c             	sub    $0xc,%esp
     5f4:	6a 08                	push   $0x8
     5f6:	e8 15 0e 00 00       	call   1410 <malloc>
     5fb:	83 c4 10             	add    $0x10,%esp
     5fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     601:	83 ec 04             	sub    $0x4,%esp
     604:	6a 08                	push   $0x8
     606:	6a 00                	push   $0x0
     608:	ff 75 f4             	pushl  -0xc(%ebp)
     60b:	e8 00 08 00 00       	call   e10 <memset>
     610:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     613:	8b 45 f4             	mov    -0xc(%ebp),%eax
     616:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     61f:	8b 55 08             	mov    0x8(%ebp),%edx
     622:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     625:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     628:	c9                   	leave  
     629:	c3                   	ret    

0000062a <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     62a:	55                   	push   %ebp
     62b:	89 e5                	mov    %esp,%ebp
     62d:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;
  
  s = *ps;
     630:	8b 45 08             	mov    0x8(%ebp),%eax
     633:	8b 00                	mov    (%eax),%eax
     635:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     638:	eb 04                	jmp    63e <gettoken+0x14>
    s++;
     63a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     63e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     641:	3b 45 0c             	cmp    0xc(%ebp),%eax
     644:	73 1e                	jae    664 <gettoken+0x3a>
     646:	8b 45 f4             	mov    -0xc(%ebp),%eax
     649:	0f b6 00             	movzbl (%eax),%eax
     64c:	0f be c0             	movsbl %al,%eax
     64f:	83 ec 08             	sub    $0x8,%esp
     652:	50                   	push   %eax
     653:	68 e8 23 00 00       	push   $0x23e8
     658:	e8 cd 07 00 00       	call   e2a <strchr>
     65d:	83 c4 10             	add    $0x10,%esp
     660:	85 c0                	test   %eax,%eax
     662:	75 d6                	jne    63a <gettoken+0x10>
    s++;
  if(q)
     664:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     668:	74 08                	je     672 <gettoken+0x48>
    *q = s;
     66a:	8b 45 10             	mov    0x10(%ebp),%eax
     66d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     670:	89 10                	mov    %edx,(%eax)
  ret = *s;
     672:	8b 45 f4             	mov    -0xc(%ebp),%eax
     675:	0f b6 00             	movzbl (%eax),%eax
     678:	0f be c0             	movsbl %al,%eax
     67b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     67e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     681:	0f b6 00             	movzbl (%eax),%eax
     684:	0f be c0             	movsbl %al,%eax
     687:	83 f8 29             	cmp    $0x29,%eax
     68a:	7f 14                	jg     6a0 <gettoken+0x76>
     68c:	83 f8 28             	cmp    $0x28,%eax
     68f:	7d 28                	jge    6b9 <gettoken+0x8f>
     691:	85 c0                	test   %eax,%eax
     693:	0f 84 96 00 00 00    	je     72f <gettoken+0x105>
     699:	83 f8 26             	cmp    $0x26,%eax
     69c:	74 1b                	je     6b9 <gettoken+0x8f>
     69e:	eb 3c                	jmp    6dc <gettoken+0xb2>
     6a0:	83 f8 3e             	cmp    $0x3e,%eax
     6a3:	74 1a                	je     6bf <gettoken+0x95>
     6a5:	83 f8 3e             	cmp    $0x3e,%eax
     6a8:	7f 0a                	jg     6b4 <gettoken+0x8a>
     6aa:	83 e8 3b             	sub    $0x3b,%eax
     6ad:	83 f8 01             	cmp    $0x1,%eax
     6b0:	77 2a                	ja     6dc <gettoken+0xb2>
     6b2:	eb 05                	jmp    6b9 <gettoken+0x8f>
     6b4:	83 f8 7c             	cmp    $0x7c,%eax
     6b7:	75 23                	jne    6dc <gettoken+0xb2>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     6b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     6bd:	eb 71                	jmp    730 <gettoken+0x106>
  case '>':
    s++;
     6bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     6c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c6:	0f b6 00             	movzbl (%eax),%eax
     6c9:	3c 3e                	cmp    $0x3e,%al
     6cb:	75 0d                	jne    6da <gettoken+0xb0>
      ret = '+';
     6cd:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     6d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     6d8:	eb 56                	jmp    730 <gettoken+0x106>
     6da:	eb 54                	jmp    730 <gettoken+0x106>
  default:
    ret = 'a';
     6dc:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     6e3:	eb 04                	jmp    6e9 <gettoken+0xbf>
      s++;
     6e5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     6e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6ef:	73 3c                	jae    72d <gettoken+0x103>
     6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6f4:	0f b6 00             	movzbl (%eax),%eax
     6f7:	0f be c0             	movsbl %al,%eax
     6fa:	83 ec 08             	sub    $0x8,%esp
     6fd:	50                   	push   %eax
     6fe:	68 e8 23 00 00       	push   $0x23e8
     703:	e8 22 07 00 00       	call   e2a <strchr>
     708:	83 c4 10             	add    $0x10,%esp
     70b:	85 c0                	test   %eax,%eax
     70d:	75 1e                	jne    72d <gettoken+0x103>
     70f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     712:	0f b6 00             	movzbl (%eax),%eax
     715:	0f be c0             	movsbl %al,%eax
     718:	83 ec 08             	sub    $0x8,%esp
     71b:	50                   	push   %eax
     71c:	68 ee 23 00 00       	push   $0x23ee
     721:	e8 04 07 00 00       	call   e2a <strchr>
     726:	83 c4 10             	add    $0x10,%esp
     729:	85 c0                	test   %eax,%eax
     72b:	74 b8                	je     6e5 <gettoken+0xbb>
      s++;
    break;
     72d:	eb 01                	jmp    730 <gettoken+0x106>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     72f:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     730:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     734:	74 08                	je     73e <gettoken+0x114>
    *eq = s;
     736:	8b 45 14             	mov    0x14(%ebp),%eax
     739:	8b 55 f4             	mov    -0xc(%ebp),%edx
     73c:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     73e:	eb 04                	jmp    744 <gettoken+0x11a>
    s++;
     740:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     744:	8b 45 f4             	mov    -0xc(%ebp),%eax
     747:	3b 45 0c             	cmp    0xc(%ebp),%eax
     74a:	73 1e                	jae    76a <gettoken+0x140>
     74c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     74f:	0f b6 00             	movzbl (%eax),%eax
     752:	0f be c0             	movsbl %al,%eax
     755:	83 ec 08             	sub    $0x8,%esp
     758:	50                   	push   %eax
     759:	68 e8 23 00 00       	push   $0x23e8
     75e:	e8 c7 06 00 00       	call   e2a <strchr>
     763:	83 c4 10             	add    $0x10,%esp
     766:	85 c0                	test   %eax,%eax
     768:	75 d6                	jne    740 <gettoken+0x116>
    s++;
  *ps = s;
     76a:	8b 45 08             	mov    0x8(%ebp),%eax
     76d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     770:	89 10                	mov    %edx,(%eax)
  return ret;
     772:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     775:	c9                   	leave  
     776:	c3                   	ret    

00000777 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     777:	55                   	push   %ebp
     778:	89 e5                	mov    %esp,%ebp
     77a:	83 ec 18             	sub    $0x18,%esp
  char *s;
  
  s = *ps;
     77d:	8b 45 08             	mov    0x8(%ebp),%eax
     780:	8b 00                	mov    (%eax),%eax
     782:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     785:	eb 04                	jmp    78b <peek+0x14>
    s++;
     787:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     78e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     791:	73 1e                	jae    7b1 <peek+0x3a>
     793:	8b 45 f4             	mov    -0xc(%ebp),%eax
     796:	0f b6 00             	movzbl (%eax),%eax
     799:	0f be c0             	movsbl %al,%eax
     79c:	83 ec 08             	sub    $0x8,%esp
     79f:	50                   	push   %eax
     7a0:	68 e8 23 00 00       	push   $0x23e8
     7a5:	e8 80 06 00 00       	call   e2a <strchr>
     7aa:	83 c4 10             	add    $0x10,%esp
     7ad:	85 c0                	test   %eax,%eax
     7af:	75 d6                	jne    787 <peek+0x10>
    s++;
  *ps = s;
     7b1:	8b 45 08             	mov    0x8(%ebp),%eax
     7b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7b7:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7bc:	0f b6 00             	movzbl (%eax),%eax
     7bf:	84 c0                	test   %al,%al
     7c1:	74 23                	je     7e6 <peek+0x6f>
     7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c6:	0f b6 00             	movzbl (%eax),%eax
     7c9:	0f be c0             	movsbl %al,%eax
     7cc:	83 ec 08             	sub    $0x8,%esp
     7cf:	50                   	push   %eax
     7d0:	ff 75 10             	pushl  0x10(%ebp)
     7d3:	e8 52 06 00 00       	call   e2a <strchr>
     7d8:	83 c4 10             	add    $0x10,%esp
     7db:	85 c0                	test   %eax,%eax
     7dd:	74 07                	je     7e6 <peek+0x6f>
     7df:	b8 01 00 00 00       	mov    $0x1,%eax
     7e4:	eb 05                	jmp    7eb <peek+0x74>
     7e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7eb:	c9                   	leave  
     7ec:	c3                   	ret    

000007ed <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     7ed:	55                   	push   %ebp
     7ee:	89 e5                	mov    %esp,%ebp
     7f0:	53                   	push   %ebx
     7f1:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     7f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
     7f7:	8b 45 08             	mov    0x8(%ebp),%eax
     7fa:	83 ec 0c             	sub    $0xc,%esp
     7fd:	50                   	push   %eax
     7fe:	e8 e6 05 00 00       	call   de9 <strlen>
     803:	83 c4 10             	add    $0x10,%esp
     806:	01 d8                	add    %ebx,%eax
     808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     80b:	83 ec 08             	sub    $0x8,%esp
     80e:	ff 75 f4             	pushl  -0xc(%ebp)
     811:	8d 45 08             	lea    0x8(%ebp),%eax
     814:	50                   	push   %eax
     815:	e8 61 00 00 00       	call   87b <parseline>
     81a:	83 c4 10             	add    $0x10,%esp
     81d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     820:	83 ec 04             	sub    $0x4,%esp
     823:	68 10 1d 00 00       	push   $0x1d10
     828:	ff 75 f4             	pushl  -0xc(%ebp)
     82b:	8d 45 08             	lea    0x8(%ebp),%eax
     82e:	50                   	push   %eax
     82f:	e8 43 ff ff ff       	call   777 <peek>
     834:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     837:	8b 45 08             	mov    0x8(%ebp),%eax
     83a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     83d:	74 26                	je     865 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     83f:	8b 45 08             	mov    0x8(%ebp),%eax
     842:	83 ec 04             	sub    $0x4,%esp
     845:	50                   	push   %eax
     846:	68 11 1d 00 00       	push   $0x1d11
     84b:	6a 02                	push   $0x2
     84d:	e8 ed 08 00 00       	call   113f <printf>
     852:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     855:	83 ec 0c             	sub    $0xc,%esp
     858:	68 20 1d 00 00       	push   $0x1d20
     85d:	e8 17 fc ff ff       	call   479 <panic>
     862:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     865:	83 ec 0c             	sub    $0xc,%esp
     868:	ff 75 f0             	pushl  -0x10(%ebp)
     86b:	e8 e9 03 00 00       	call   c59 <nulterminate>
     870:	83 c4 10             	add    $0x10,%esp
  return cmd;
     873:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     879:	c9                   	leave  
     87a:	c3                   	ret    

0000087b <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     87b:	55                   	push   %ebp
     87c:	89 e5                	mov    %esp,%ebp
     87e:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     881:	83 ec 08             	sub    $0x8,%esp
     884:	ff 75 0c             	pushl  0xc(%ebp)
     887:	ff 75 08             	pushl  0x8(%ebp)
     88a:	e8 99 00 00 00       	call   928 <parsepipe>
     88f:	83 c4 10             	add    $0x10,%esp
     892:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     895:	eb 23                	jmp    8ba <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     897:	6a 00                	push   $0x0
     899:	6a 00                	push   $0x0
     89b:	ff 75 0c             	pushl  0xc(%ebp)
     89e:	ff 75 08             	pushl  0x8(%ebp)
     8a1:	e8 84 fd ff ff       	call   62a <gettoken>
     8a6:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     8a9:	83 ec 0c             	sub    $0xc,%esp
     8ac:	ff 75 f4             	pushl  -0xc(%ebp)
     8af:	e8 37 fd ff ff       	call   5eb <backcmd>
     8b4:	83 c4 10             	add    $0x10,%esp
     8b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     8ba:	83 ec 04             	sub    $0x4,%esp
     8bd:	68 27 1d 00 00       	push   $0x1d27
     8c2:	ff 75 0c             	pushl  0xc(%ebp)
     8c5:	ff 75 08             	pushl  0x8(%ebp)
     8c8:	e8 aa fe ff ff       	call   777 <peek>
     8cd:	83 c4 10             	add    $0x10,%esp
     8d0:	85 c0                	test   %eax,%eax
     8d2:	75 c3                	jne    897 <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     8d4:	83 ec 04             	sub    $0x4,%esp
     8d7:	68 29 1d 00 00       	push   $0x1d29
     8dc:	ff 75 0c             	pushl  0xc(%ebp)
     8df:	ff 75 08             	pushl  0x8(%ebp)
     8e2:	e8 90 fe ff ff       	call   777 <peek>
     8e7:	83 c4 10             	add    $0x10,%esp
     8ea:	85 c0                	test   %eax,%eax
     8ec:	74 35                	je     923 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     8ee:	6a 00                	push   $0x0
     8f0:	6a 00                	push   $0x0
     8f2:	ff 75 0c             	pushl  0xc(%ebp)
     8f5:	ff 75 08             	pushl  0x8(%ebp)
     8f8:	e8 2d fd ff ff       	call   62a <gettoken>
     8fd:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     900:	83 ec 08             	sub    $0x8,%esp
     903:	ff 75 0c             	pushl  0xc(%ebp)
     906:	ff 75 08             	pushl  0x8(%ebp)
     909:	e8 6d ff ff ff       	call   87b <parseline>
     90e:	83 c4 10             	add    $0x10,%esp
     911:	83 ec 08             	sub    $0x8,%esp
     914:	50                   	push   %eax
     915:	ff 75 f4             	pushl  -0xc(%ebp)
     918:	e8 86 fc ff ff       	call   5a3 <listcmd>
     91d:	83 c4 10             	add    $0x10,%esp
     920:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     923:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     926:	c9                   	leave  
     927:	c3                   	ret    

00000928 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     928:	55                   	push   %ebp
     929:	89 e5                	mov    %esp,%ebp
     92b:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     92e:	83 ec 08             	sub    $0x8,%esp
     931:	ff 75 0c             	pushl  0xc(%ebp)
     934:	ff 75 08             	pushl  0x8(%ebp)
     937:	e8 ec 01 00 00       	call   b28 <parseexec>
     93c:	83 c4 10             	add    $0x10,%esp
     93f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     942:	83 ec 04             	sub    $0x4,%esp
     945:	68 2b 1d 00 00       	push   $0x1d2b
     94a:	ff 75 0c             	pushl  0xc(%ebp)
     94d:	ff 75 08             	pushl  0x8(%ebp)
     950:	e8 22 fe ff ff       	call   777 <peek>
     955:	83 c4 10             	add    $0x10,%esp
     958:	85 c0                	test   %eax,%eax
     95a:	74 35                	je     991 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     95c:	6a 00                	push   $0x0
     95e:	6a 00                	push   $0x0
     960:	ff 75 0c             	pushl  0xc(%ebp)
     963:	ff 75 08             	pushl  0x8(%ebp)
     966:	e8 bf fc ff ff       	call   62a <gettoken>
     96b:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     96e:	83 ec 08             	sub    $0x8,%esp
     971:	ff 75 0c             	pushl  0xc(%ebp)
     974:	ff 75 08             	pushl  0x8(%ebp)
     977:	e8 ac ff ff ff       	call   928 <parsepipe>
     97c:	83 c4 10             	add    $0x10,%esp
     97f:	83 ec 08             	sub    $0x8,%esp
     982:	50                   	push   %eax
     983:	ff 75 f4             	pushl  -0xc(%ebp)
     986:	e8 d0 fb ff ff       	call   55b <pipecmd>
     98b:	83 c4 10             	add    $0x10,%esp
     98e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     991:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     994:	c9                   	leave  
     995:	c3                   	ret    

00000996 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     996:	55                   	push   %ebp
     997:	89 e5                	mov    %esp,%ebp
     999:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     99c:	e9 b6 00 00 00       	jmp    a57 <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     9a1:	6a 00                	push   $0x0
     9a3:	6a 00                	push   $0x0
     9a5:	ff 75 10             	pushl  0x10(%ebp)
     9a8:	ff 75 0c             	pushl  0xc(%ebp)
     9ab:	e8 7a fc ff ff       	call   62a <gettoken>
     9b0:	83 c4 10             	add    $0x10,%esp
     9b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     9b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
     9b9:	50                   	push   %eax
     9ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
     9bd:	50                   	push   %eax
     9be:	ff 75 10             	pushl  0x10(%ebp)
     9c1:	ff 75 0c             	pushl  0xc(%ebp)
     9c4:	e8 61 fc ff ff       	call   62a <gettoken>
     9c9:	83 c4 10             	add    $0x10,%esp
     9cc:	83 f8 61             	cmp    $0x61,%eax
     9cf:	74 10                	je     9e1 <parseredirs+0x4b>
      panic("missing file for redirection");
     9d1:	83 ec 0c             	sub    $0xc,%esp
     9d4:	68 2d 1d 00 00       	push   $0x1d2d
     9d9:	e8 9b fa ff ff       	call   479 <panic>
     9de:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     9e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9e4:	83 f8 3c             	cmp    $0x3c,%eax
     9e7:	74 0c                	je     9f5 <parseredirs+0x5f>
     9e9:	83 f8 3e             	cmp    $0x3e,%eax
     9ec:	74 26                	je     a14 <parseredirs+0x7e>
     9ee:	83 f8 2b             	cmp    $0x2b,%eax
     9f1:	74 43                	je     a36 <parseredirs+0xa0>
     9f3:	eb 62                	jmp    a57 <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     9f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9fb:	83 ec 0c             	sub    $0xc,%esp
     9fe:	6a 00                	push   $0x0
     a00:	6a 00                	push   $0x0
     a02:	52                   	push   %edx
     a03:	50                   	push   %eax
     a04:	ff 75 08             	pushl  0x8(%ebp)
     a07:	e8 ec fa ff ff       	call   4f8 <redircmd>
     a0c:	83 c4 20             	add    $0x20,%esp
     a0f:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a12:	eb 43                	jmp    a57 <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a14:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a1a:	83 ec 0c             	sub    $0xc,%esp
     a1d:	6a 01                	push   $0x1
     a1f:	68 01 02 00 00       	push   $0x201
     a24:	52                   	push   %edx
     a25:	50                   	push   %eax
     a26:	ff 75 08             	pushl  0x8(%ebp)
     a29:	e8 ca fa ff ff       	call   4f8 <redircmd>
     a2e:	83 c4 20             	add    $0x20,%esp
     a31:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a34:	eb 21                	jmp    a57 <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a36:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a3c:	83 ec 0c             	sub    $0xc,%esp
     a3f:	6a 01                	push   $0x1
     a41:	68 01 02 00 00       	push   $0x201
     a46:	52                   	push   %edx
     a47:	50                   	push   %eax
     a48:	ff 75 08             	pushl  0x8(%ebp)
     a4b:	e8 a8 fa ff ff       	call   4f8 <redircmd>
     a50:	83 c4 20             	add    $0x20,%esp
     a53:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a56:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     a57:	83 ec 04             	sub    $0x4,%esp
     a5a:	68 4a 1d 00 00       	push   $0x1d4a
     a5f:	ff 75 10             	pushl  0x10(%ebp)
     a62:	ff 75 0c             	pushl  0xc(%ebp)
     a65:	e8 0d fd ff ff       	call   777 <peek>
     a6a:	83 c4 10             	add    $0x10,%esp
     a6d:	85 c0                	test   %eax,%eax
     a6f:	0f 85 2c ff ff ff    	jne    9a1 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     a75:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a78:	c9                   	leave  
     a79:	c3                   	ret    

00000a7a <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     a7a:	55                   	push   %ebp
     a7b:	89 e5                	mov    %esp,%ebp
     a7d:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a80:	83 ec 04             	sub    $0x4,%esp
     a83:	68 4d 1d 00 00       	push   $0x1d4d
     a88:	ff 75 0c             	pushl  0xc(%ebp)
     a8b:	ff 75 08             	pushl  0x8(%ebp)
     a8e:	e8 e4 fc ff ff       	call   777 <peek>
     a93:	83 c4 10             	add    $0x10,%esp
     a96:	85 c0                	test   %eax,%eax
     a98:	75 10                	jne    aaa <parseblock+0x30>
    panic("parseblock");
     a9a:	83 ec 0c             	sub    $0xc,%esp
     a9d:	68 4f 1d 00 00       	push   $0x1d4f
     aa2:	e8 d2 f9 ff ff       	call   479 <panic>
     aa7:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     aaa:	6a 00                	push   $0x0
     aac:	6a 00                	push   $0x0
     aae:	ff 75 0c             	pushl  0xc(%ebp)
     ab1:	ff 75 08             	pushl  0x8(%ebp)
     ab4:	e8 71 fb ff ff       	call   62a <gettoken>
     ab9:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     abc:	83 ec 08             	sub    $0x8,%esp
     abf:	ff 75 0c             	pushl  0xc(%ebp)
     ac2:	ff 75 08             	pushl  0x8(%ebp)
     ac5:	e8 b1 fd ff ff       	call   87b <parseline>
     aca:	83 c4 10             	add    $0x10,%esp
     acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     ad0:	83 ec 04             	sub    $0x4,%esp
     ad3:	68 5a 1d 00 00       	push   $0x1d5a
     ad8:	ff 75 0c             	pushl  0xc(%ebp)
     adb:	ff 75 08             	pushl  0x8(%ebp)
     ade:	e8 94 fc ff ff       	call   777 <peek>
     ae3:	83 c4 10             	add    $0x10,%esp
     ae6:	85 c0                	test   %eax,%eax
     ae8:	75 10                	jne    afa <parseblock+0x80>
    panic("syntax - missing )");
     aea:	83 ec 0c             	sub    $0xc,%esp
     aed:	68 5c 1d 00 00       	push   $0x1d5c
     af2:	e8 82 f9 ff ff       	call   479 <panic>
     af7:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     afa:	6a 00                	push   $0x0
     afc:	6a 00                	push   $0x0
     afe:	ff 75 0c             	pushl  0xc(%ebp)
     b01:	ff 75 08             	pushl  0x8(%ebp)
     b04:	e8 21 fb ff ff       	call   62a <gettoken>
     b09:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     b0c:	83 ec 04             	sub    $0x4,%esp
     b0f:	ff 75 0c             	pushl  0xc(%ebp)
     b12:	ff 75 08             	pushl  0x8(%ebp)
     b15:	ff 75 f4             	pushl  -0xc(%ebp)
     b18:	e8 79 fe ff ff       	call   996 <parseredirs>
     b1d:	83 c4 10             	add    $0x10,%esp
     b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b26:	c9                   	leave  
     b27:	c3                   	ret    

00000b28 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     b28:	55                   	push   %ebp
     b29:	89 e5                	mov    %esp,%ebp
     b2b:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     b2e:	83 ec 04             	sub    $0x4,%esp
     b31:	68 4d 1d 00 00       	push   $0x1d4d
     b36:	ff 75 0c             	pushl  0xc(%ebp)
     b39:	ff 75 08             	pushl  0x8(%ebp)
     b3c:	e8 36 fc ff ff       	call   777 <peek>
     b41:	83 c4 10             	add    $0x10,%esp
     b44:	85 c0                	test   %eax,%eax
     b46:	74 16                	je     b5e <parseexec+0x36>
    return parseblock(ps, es);
     b48:	83 ec 08             	sub    $0x8,%esp
     b4b:	ff 75 0c             	pushl  0xc(%ebp)
     b4e:	ff 75 08             	pushl  0x8(%ebp)
     b51:	e8 24 ff ff ff       	call   a7a <parseblock>
     b56:	83 c4 10             	add    $0x10,%esp
     b59:	e9 f9 00 00 00       	jmp    c57 <parseexec+0x12f>

  ret = execcmd();
     b5e:	e8 5f f9 ff ff       	call   4c2 <execcmd>
     b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b69:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     b6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     b73:	83 ec 04             	sub    $0x4,%esp
     b76:	ff 75 0c             	pushl  0xc(%ebp)
     b79:	ff 75 08             	pushl  0x8(%ebp)
     b7c:	ff 75 f0             	pushl  -0x10(%ebp)
     b7f:	e8 12 fe ff ff       	call   996 <parseredirs>
     b84:	83 c4 10             	add    $0x10,%esp
     b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b8a:	e9 88 00 00 00       	jmp    c17 <parseexec+0xef>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b8f:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b92:	50                   	push   %eax
     b93:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b96:	50                   	push   %eax
     b97:	ff 75 0c             	pushl  0xc(%ebp)
     b9a:	ff 75 08             	pushl  0x8(%ebp)
     b9d:	e8 88 fa ff ff       	call   62a <gettoken>
     ba2:	83 c4 10             	add    $0x10,%esp
     ba5:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ba8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     bac:	75 05                	jne    bb3 <parseexec+0x8b>
      break;
     bae:	e9 82 00 00 00       	jmp    c35 <parseexec+0x10d>
    if(tok != 'a')
     bb3:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     bb7:	74 10                	je     bc9 <parseexec+0xa1>
      panic("syntax");
     bb9:	83 ec 0c             	sub    $0xc,%esp
     bbc:	68 20 1d 00 00       	push   $0x1d20
     bc1:	e8 b3 f8 ff ff       	call   479 <panic>
     bc6:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     bc9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bd2:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     bd6:	8b 55 e0             	mov    -0x20(%ebp),%edx
     bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bdc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     bdf:	83 c1 08             	add    $0x8,%ecx
     be2:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     be6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     bea:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     bee:	7e 10                	jle    c00 <parseexec+0xd8>
      panic("too many args");
     bf0:	83 ec 0c             	sub    $0xc,%esp
     bf3:	68 6f 1d 00 00       	push   $0x1d6f
     bf8:	e8 7c f8 ff ff       	call   479 <panic>
     bfd:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     c00:	83 ec 04             	sub    $0x4,%esp
     c03:	ff 75 0c             	pushl  0xc(%ebp)
     c06:	ff 75 08             	pushl  0x8(%ebp)
     c09:	ff 75 f0             	pushl  -0x10(%ebp)
     c0c:	e8 85 fd ff ff       	call   996 <parseredirs>
     c11:	83 c4 10             	add    $0x10,%esp
     c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     c17:	83 ec 04             	sub    $0x4,%esp
     c1a:	68 7d 1d 00 00       	push   $0x1d7d
     c1f:	ff 75 0c             	pushl  0xc(%ebp)
     c22:	ff 75 08             	pushl  0x8(%ebp)
     c25:	e8 4d fb ff ff       	call   777 <peek>
     c2a:	83 c4 10             	add    $0x10,%esp
     c2d:	85 c0                	test   %eax,%eax
     c2f:	0f 84 5a ff ff ff    	je     b8f <parseexec+0x67>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c3b:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     c42:	00 
  cmd->eargv[argc] = 0;
     c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c46:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c49:	83 c2 08             	add    $0x8,%edx
     c4c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     c53:	00 
  return ret;
     c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     c57:	c9                   	leave  
     c58:	c3                   	ret    

00000c59 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     c59:	55                   	push   %ebp
     c5a:	89 e5                	mov    %esp,%ebp
     c5c:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     c5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c63:	75 0a                	jne    c6f <nulterminate+0x16>
    return 0;
     c65:	b8 00 00 00 00       	mov    $0x0,%eax
     c6a:	e9 e4 00 00 00       	jmp    d53 <nulterminate+0xfa>
  
  switch(cmd->type){
     c6f:	8b 45 08             	mov    0x8(%ebp),%eax
     c72:	8b 00                	mov    (%eax),%eax
     c74:	83 f8 05             	cmp    $0x5,%eax
     c77:	0f 87 d3 00 00 00    	ja     d50 <nulterminate+0xf7>
     c7d:	8b 04 85 84 1d 00 00 	mov    0x1d84(,%eax,4),%eax
     c84:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c86:	8b 45 08             	mov    0x8(%ebp),%eax
     c89:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c93:	eb 14                	jmp    ca9 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c9b:	83 c2 08             	add    $0x8,%edx
     c9e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     ca2:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     ca5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cac:	8b 55 f4             	mov    -0xc(%ebp),%edx
     caf:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     cb3:	85 c0                	test   %eax,%eax
     cb5:	75 de                	jne    c95 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     cb7:	e9 94 00 00 00       	jmp    d50 <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     cbc:	8b 45 08             	mov    0x8(%ebp),%eax
     cbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cc5:	8b 40 04             	mov    0x4(%eax),%eax
     cc8:	83 ec 0c             	sub    $0xc,%esp
     ccb:	50                   	push   %eax
     ccc:	e8 88 ff ff ff       	call   c59 <nulterminate>
     cd1:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cd7:	8b 40 0c             	mov    0xc(%eax),%eax
     cda:	c6 00 00             	movb   $0x0,(%eax)
    break;
     cdd:	eb 71                	jmp    d50 <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     cdf:	8b 45 08             	mov    0x8(%ebp),%eax
     ce2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     ce5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ce8:	8b 40 04             	mov    0x4(%eax),%eax
     ceb:	83 ec 0c             	sub    $0xc,%esp
     cee:	50                   	push   %eax
     cef:	e8 65 ff ff ff       	call   c59 <nulterminate>
     cf4:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     cf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cfa:	8b 40 08             	mov    0x8(%eax),%eax
     cfd:	83 ec 0c             	sub    $0xc,%esp
     d00:	50                   	push   %eax
     d01:	e8 53 ff ff ff       	call   c59 <nulterminate>
     d06:	83 c4 10             	add    $0x10,%esp
    break;
     d09:	eb 45                	jmp    d50 <nulterminate+0xf7>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     d0b:	8b 45 08             	mov    0x8(%ebp),%eax
     d0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d14:	8b 40 04             	mov    0x4(%eax),%eax
     d17:	83 ec 0c             	sub    $0xc,%esp
     d1a:	50                   	push   %eax
     d1b:	e8 39 ff ff ff       	call   c59 <nulterminate>
     d20:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     d23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d26:	8b 40 08             	mov    0x8(%eax),%eax
     d29:	83 ec 0c             	sub    $0xc,%esp
     d2c:	50                   	push   %eax
     d2d:	e8 27 ff ff ff       	call   c59 <nulterminate>
     d32:	83 c4 10             	add    $0x10,%esp
    break;
     d35:	eb 19                	jmp    d50 <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     d37:	8b 45 08             	mov    0x8(%ebp),%eax
     d3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     d3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     d40:	8b 40 04             	mov    0x4(%eax),%eax
     d43:	83 ec 0c             	sub    $0xc,%esp
     d46:	50                   	push   %eax
     d47:	e8 0d ff ff ff       	call   c59 <nulterminate>
     d4c:	83 c4 10             	add    $0x10,%esp
    break;
     d4f:	90                   	nop
  }
  return cmd;
     d50:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d53:	c9                   	leave  
     d54:	c3                   	ret    

00000d55 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     d55:	55                   	push   %ebp
     d56:	89 e5                	mov    %esp,%ebp
     d58:	57                   	push   %edi
     d59:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     d5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d5d:	8b 55 10             	mov    0x10(%ebp),%edx
     d60:	8b 45 0c             	mov    0xc(%ebp),%eax
     d63:	89 cb                	mov    %ecx,%ebx
     d65:	89 df                	mov    %ebx,%edi
     d67:	89 d1                	mov    %edx,%ecx
     d69:	fc                   	cld    
     d6a:	f3 aa                	rep stos %al,%es:(%edi)
     d6c:	89 ca                	mov    %ecx,%edx
     d6e:	89 fb                	mov    %edi,%ebx
     d70:	89 5d 08             	mov    %ebx,0x8(%ebp)
     d73:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d76:	5b                   	pop    %ebx
     d77:	5f                   	pop    %edi
     d78:	5d                   	pop    %ebp
     d79:	c3                   	ret    

00000d7a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     d7a:	55                   	push   %ebp
     d7b:	89 e5                	mov    %esp,%ebp
     d7d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d80:	8b 45 08             	mov    0x8(%ebp),%eax
     d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d86:	90                   	nop
     d87:	8b 45 08             	mov    0x8(%ebp),%eax
     d8a:	8d 50 01             	lea    0x1(%eax),%edx
     d8d:	89 55 08             	mov    %edx,0x8(%ebp)
     d90:	8b 55 0c             	mov    0xc(%ebp),%edx
     d93:	8d 4a 01             	lea    0x1(%edx),%ecx
     d96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     d99:	0f b6 12             	movzbl (%edx),%edx
     d9c:	88 10                	mov    %dl,(%eax)
     d9e:	0f b6 00             	movzbl (%eax),%eax
     da1:	84 c0                	test   %al,%al
     da3:	75 e2                	jne    d87 <strcpy+0xd>
    ;
  return os;
     da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     da8:	c9                   	leave  
     da9:	c3                   	ret    

00000daa <strcmp>:

int
strcmp(const char *p, const char *q)
{
     daa:	55                   	push   %ebp
     dab:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     dad:	eb 08                	jmp    db7 <strcmp+0xd>
    p++, q++;
     daf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     db3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     db7:	8b 45 08             	mov    0x8(%ebp),%eax
     dba:	0f b6 00             	movzbl (%eax),%eax
     dbd:	84 c0                	test   %al,%al
     dbf:	74 10                	je     dd1 <strcmp+0x27>
     dc1:	8b 45 08             	mov    0x8(%ebp),%eax
     dc4:	0f b6 10             	movzbl (%eax),%edx
     dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
     dca:	0f b6 00             	movzbl (%eax),%eax
     dcd:	38 c2                	cmp    %al,%dl
     dcf:	74 de                	je     daf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     dd1:	8b 45 08             	mov    0x8(%ebp),%eax
     dd4:	0f b6 00             	movzbl (%eax),%eax
     dd7:	0f b6 d0             	movzbl %al,%edx
     dda:	8b 45 0c             	mov    0xc(%ebp),%eax
     ddd:	0f b6 00             	movzbl (%eax),%eax
     de0:	0f b6 c0             	movzbl %al,%eax
     de3:	29 c2                	sub    %eax,%edx
     de5:	89 d0                	mov    %edx,%eax
}
     de7:	5d                   	pop    %ebp
     de8:	c3                   	ret    

00000de9 <strlen>:

uint
strlen(char *s)
{
     de9:	55                   	push   %ebp
     dea:	89 e5                	mov    %esp,%ebp
     dec:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     def:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     df6:	eb 04                	jmp    dfc <strlen+0x13>
     df8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     dfc:	8b 55 fc             	mov    -0x4(%ebp),%edx
     dff:	8b 45 08             	mov    0x8(%ebp),%eax
     e02:	01 d0                	add    %edx,%eax
     e04:	0f b6 00             	movzbl (%eax),%eax
     e07:	84 c0                	test   %al,%al
     e09:	75 ed                	jne    df8 <strlen+0xf>
    ;
  return n;
     e0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e0e:	c9                   	leave  
     e0f:	c3                   	ret    

00000e10 <memset>:

void*
memset(void *dst, int c, uint n)
{
     e10:	55                   	push   %ebp
     e11:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     e13:	8b 45 10             	mov    0x10(%ebp),%eax
     e16:	50                   	push   %eax
     e17:	ff 75 0c             	pushl  0xc(%ebp)
     e1a:	ff 75 08             	pushl  0x8(%ebp)
     e1d:	e8 33 ff ff ff       	call   d55 <stosb>
     e22:	83 c4 0c             	add    $0xc,%esp
  return dst;
     e25:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e28:	c9                   	leave  
     e29:	c3                   	ret    

00000e2a <strchr>:

char*
strchr(const char *s, char c)
{
     e2a:	55                   	push   %ebp
     e2b:	89 e5                	mov    %esp,%ebp
     e2d:	83 ec 04             	sub    $0x4,%esp
     e30:	8b 45 0c             	mov    0xc(%ebp),%eax
     e33:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     e36:	eb 14                	jmp    e4c <strchr+0x22>
    if(*s == c)
     e38:	8b 45 08             	mov    0x8(%ebp),%eax
     e3b:	0f b6 00             	movzbl (%eax),%eax
     e3e:	3a 45 fc             	cmp    -0x4(%ebp),%al
     e41:	75 05                	jne    e48 <strchr+0x1e>
      return (char*)s;
     e43:	8b 45 08             	mov    0x8(%ebp),%eax
     e46:	eb 13                	jmp    e5b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     e48:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     e4c:	8b 45 08             	mov    0x8(%ebp),%eax
     e4f:	0f b6 00             	movzbl (%eax),%eax
     e52:	84 c0                	test   %al,%al
     e54:	75 e2                	jne    e38 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e5b:	c9                   	leave  
     e5c:	c3                   	ret    

00000e5d <gets>:

char*
gets(char *buf, int max)
{
     e5d:	55                   	push   %ebp
     e5e:	89 e5                	mov    %esp,%ebp
     e60:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e6a:	eb 44                	jmp    eb0 <gets+0x53>
    cc = read(0, &c, 1);
     e6c:	83 ec 04             	sub    $0x4,%esp
     e6f:	6a 01                	push   $0x1
     e71:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e74:	50                   	push   %eax
     e75:	6a 00                	push   $0x0
     e77:	e8 46 01 00 00       	call   fc2 <read>
     e7c:	83 c4 10             	add    $0x10,%esp
     e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e86:	7f 02                	jg     e8a <gets+0x2d>
      break;
     e88:	eb 31                	jmp    ebb <gets+0x5e>
    buf[i++] = c;
     e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e8d:	8d 50 01             	lea    0x1(%eax),%edx
     e90:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e93:	89 c2                	mov    %eax,%edx
     e95:	8b 45 08             	mov    0x8(%ebp),%eax
     e98:	01 c2                	add    %eax,%edx
     e9a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e9e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     ea0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     ea4:	3c 0a                	cmp    $0xa,%al
     ea6:	74 13                	je     ebb <gets+0x5e>
     ea8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     eac:	3c 0d                	cmp    $0xd,%al
     eae:	74 0b                	je     ebb <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eb3:	83 c0 01             	add    $0x1,%eax
     eb6:	3b 45 0c             	cmp    0xc(%ebp),%eax
     eb9:	7c b1                	jl     e6c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ebe:	8b 45 08             	mov    0x8(%ebp),%eax
     ec1:	01 d0                	add    %edx,%eax
     ec3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     ec6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ec9:	c9                   	leave  
     eca:	c3                   	ret    

00000ecb <stat>:

int
stat(char *n, struct stat *st)
{
     ecb:	55                   	push   %ebp
     ecc:	89 e5                	mov    %esp,%ebp
     ece:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ed1:	83 ec 08             	sub    $0x8,%esp
     ed4:	6a 00                	push   $0x0
     ed6:	ff 75 08             	pushl  0x8(%ebp)
     ed9:	e8 0c 01 00 00       	call   fea <open>
     ede:	83 c4 10             	add    $0x10,%esp
     ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     ee4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ee8:	79 07                	jns    ef1 <stat+0x26>
    return -1;
     eea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eef:	eb 25                	jmp    f16 <stat+0x4b>
  r = fstat(fd, st);
     ef1:	83 ec 08             	sub    $0x8,%esp
     ef4:	ff 75 0c             	pushl  0xc(%ebp)
     ef7:	ff 75 f4             	pushl  -0xc(%ebp)
     efa:	e8 03 01 00 00       	call   1002 <fstat>
     eff:	83 c4 10             	add    $0x10,%esp
     f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     f05:	83 ec 0c             	sub    $0xc,%esp
     f08:	ff 75 f4             	pushl  -0xc(%ebp)
     f0b:	e8 c2 00 00 00       	call   fd2 <close>
     f10:	83 c4 10             	add    $0x10,%esp
  return r;
     f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f16:	c9                   	leave  
     f17:	c3                   	ret    

00000f18 <atoi>:

int
atoi(const char *s)
{
     f18:	55                   	push   %ebp
     f19:	89 e5                	mov    %esp,%ebp
     f1b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     f25:	eb 25                	jmp    f4c <atoi+0x34>
    n = n*10 + *s++ - '0';
     f27:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f2a:	89 d0                	mov    %edx,%eax
     f2c:	c1 e0 02             	shl    $0x2,%eax
     f2f:	01 d0                	add    %edx,%eax
     f31:	01 c0                	add    %eax,%eax
     f33:	89 c1                	mov    %eax,%ecx
     f35:	8b 45 08             	mov    0x8(%ebp),%eax
     f38:	8d 50 01             	lea    0x1(%eax),%edx
     f3b:	89 55 08             	mov    %edx,0x8(%ebp)
     f3e:	0f b6 00             	movzbl (%eax),%eax
     f41:	0f be c0             	movsbl %al,%eax
     f44:	01 c8                	add    %ecx,%eax
     f46:	83 e8 30             	sub    $0x30,%eax
     f49:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f4c:	8b 45 08             	mov    0x8(%ebp),%eax
     f4f:	0f b6 00             	movzbl (%eax),%eax
     f52:	3c 2f                	cmp    $0x2f,%al
     f54:	7e 0a                	jle    f60 <atoi+0x48>
     f56:	8b 45 08             	mov    0x8(%ebp),%eax
     f59:	0f b6 00             	movzbl (%eax),%eax
     f5c:	3c 39                	cmp    $0x39,%al
     f5e:	7e c7                	jle    f27 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f63:	c9                   	leave  
     f64:	c3                   	ret    

00000f65 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f65:	55                   	push   %ebp
     f66:	89 e5                	mov    %esp,%ebp
     f68:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     f6b:	8b 45 08             	mov    0x8(%ebp),%eax
     f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f71:	8b 45 0c             	mov    0xc(%ebp),%eax
     f74:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f77:	eb 17                	jmp    f90 <memmove+0x2b>
    *dst++ = *src++;
     f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f7c:	8d 50 01             	lea    0x1(%eax),%edx
     f7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
     f82:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f85:	8d 4a 01             	lea    0x1(%edx),%ecx
     f88:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     f8b:	0f b6 12             	movzbl (%edx),%edx
     f8e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f90:	8b 45 10             	mov    0x10(%ebp),%eax
     f93:	8d 50 ff             	lea    -0x1(%eax),%edx
     f96:	89 55 10             	mov    %edx,0x10(%ebp)
     f99:	85 c0                	test   %eax,%eax
     f9b:	7f dc                	jg     f79 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     fa0:	c9                   	leave  
     fa1:	c3                   	ret    

00000fa2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     fa2:	b8 01 00 00 00       	mov    $0x1,%eax
     fa7:	cd 40                	int    $0x40
     fa9:	c3                   	ret    

00000faa <exit>:
SYSCALL(exit)
     faa:	b8 02 00 00 00       	mov    $0x2,%eax
     faf:	cd 40                	int    $0x40
     fb1:	c3                   	ret    

00000fb2 <wait>:
SYSCALL(wait)
     fb2:	b8 03 00 00 00       	mov    $0x3,%eax
     fb7:	cd 40                	int    $0x40
     fb9:	c3                   	ret    

00000fba <pipe>:
SYSCALL(pipe)
     fba:	b8 04 00 00 00       	mov    $0x4,%eax
     fbf:	cd 40                	int    $0x40
     fc1:	c3                   	ret    

00000fc2 <read>:
SYSCALL(read)
     fc2:	b8 05 00 00 00       	mov    $0x5,%eax
     fc7:	cd 40                	int    $0x40
     fc9:	c3                   	ret    

00000fca <write>:
SYSCALL(write)
     fca:	b8 10 00 00 00       	mov    $0x10,%eax
     fcf:	cd 40                	int    $0x40
     fd1:	c3                   	ret    

00000fd2 <close>:
SYSCALL(close)
     fd2:	b8 15 00 00 00       	mov    $0x15,%eax
     fd7:	cd 40                	int    $0x40
     fd9:	c3                   	ret    

00000fda <kill>:
SYSCALL(kill)
     fda:	b8 06 00 00 00       	mov    $0x6,%eax
     fdf:	cd 40                	int    $0x40
     fe1:	c3                   	ret    

00000fe2 <exec>:
SYSCALL(exec)
     fe2:	b8 07 00 00 00       	mov    $0x7,%eax
     fe7:	cd 40                	int    $0x40
     fe9:	c3                   	ret    

00000fea <open>:
SYSCALL(open)
     fea:	b8 0f 00 00 00       	mov    $0xf,%eax
     fef:	cd 40                	int    $0x40
     ff1:	c3                   	ret    

00000ff2 <mknod>:
SYSCALL(mknod)
     ff2:	b8 11 00 00 00       	mov    $0x11,%eax
     ff7:	cd 40                	int    $0x40
     ff9:	c3                   	ret    

00000ffa <unlink>:
SYSCALL(unlink)
     ffa:	b8 12 00 00 00       	mov    $0x12,%eax
     fff:	cd 40                	int    $0x40
    1001:	c3                   	ret    

00001002 <fstat>:
SYSCALL(fstat)
    1002:	b8 08 00 00 00       	mov    $0x8,%eax
    1007:	cd 40                	int    $0x40
    1009:	c3                   	ret    

0000100a <link>:
SYSCALL(link)
    100a:	b8 13 00 00 00       	mov    $0x13,%eax
    100f:	cd 40                	int    $0x40
    1011:	c3                   	ret    

00001012 <mkdir>:
SYSCALL(mkdir)
    1012:	b8 14 00 00 00       	mov    $0x14,%eax
    1017:	cd 40                	int    $0x40
    1019:	c3                   	ret    

0000101a <chdir>:
SYSCALL(chdir)
    101a:	b8 09 00 00 00       	mov    $0x9,%eax
    101f:	cd 40                	int    $0x40
    1021:	c3                   	ret    

00001022 <dup>:
SYSCALL(dup)
    1022:	b8 0a 00 00 00       	mov    $0xa,%eax
    1027:	cd 40                	int    $0x40
    1029:	c3                   	ret    

0000102a <getpid>:
SYSCALL(getpid)
    102a:	b8 0b 00 00 00       	mov    $0xb,%eax
    102f:	cd 40                	int    $0x40
    1031:	c3                   	ret    

00001032 <sbrk>:
SYSCALL(sbrk)
    1032:	b8 0c 00 00 00       	mov    $0xc,%eax
    1037:	cd 40                	int    $0x40
    1039:	c3                   	ret    

0000103a <sleep>:
SYSCALL(sleep)
    103a:	b8 0d 00 00 00       	mov    $0xd,%eax
    103f:	cd 40                	int    $0x40
    1041:	c3                   	ret    

00001042 <uptime>:
SYSCALL(uptime)
    1042:	b8 0e 00 00 00       	mov    $0xe,%eax
    1047:	cd 40                	int    $0x40
    1049:	c3                   	ret    

0000104a <getcwd>:
SYSCALL(getcwd)
    104a:	b8 16 00 00 00       	mov    $0x16,%eax
    104f:	cd 40                	int    $0x40
    1051:	c3                   	ret    

00001052 <shutdown>:
SYSCALL(shutdown)
    1052:	b8 17 00 00 00       	mov    $0x17,%eax
    1057:	cd 40                	int    $0x40
    1059:	c3                   	ret    

0000105a <buildinfo>:
SYSCALL(buildinfo)
    105a:	b8 18 00 00 00       	mov    $0x18,%eax
    105f:	cd 40                	int    $0x40
    1061:	c3                   	ret    

00001062 <lseek>:
SYSCALL(lseek)
    1062:	b8 19 00 00 00       	mov    $0x19,%eax
    1067:	cd 40                	int    $0x40
    1069:	c3                   	ret    

0000106a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    106a:	55                   	push   %ebp
    106b:	89 e5                	mov    %esp,%ebp
    106d:	83 ec 18             	sub    $0x18,%esp
    1070:	8b 45 0c             	mov    0xc(%ebp),%eax
    1073:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1076:	83 ec 04             	sub    $0x4,%esp
    1079:	6a 01                	push   $0x1
    107b:	8d 45 f4             	lea    -0xc(%ebp),%eax
    107e:	50                   	push   %eax
    107f:	ff 75 08             	pushl  0x8(%ebp)
    1082:	e8 43 ff ff ff       	call   fca <write>
    1087:	83 c4 10             	add    $0x10,%esp
}
    108a:	c9                   	leave  
    108b:	c3                   	ret    

0000108c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    108c:	55                   	push   %ebp
    108d:	89 e5                	mov    %esp,%ebp
    108f:	53                   	push   %ebx
    1090:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1093:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    109a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    109e:	74 17                	je     10b7 <printint+0x2b>
    10a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    10a4:	79 11                	jns    10b7 <printint+0x2b>
    neg = 1;
    10a6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    10ad:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b0:	f7 d8                	neg    %eax
    10b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10b5:	eb 06                	jmp    10bd <printint+0x31>
  } else {
    x = xx;
    10b7:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    10bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    10c4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    10c7:	8d 41 01             	lea    0x1(%ecx),%eax
    10ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    10cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
    10d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10d3:	ba 00 00 00 00       	mov    $0x0,%edx
    10d8:	f7 f3                	div    %ebx
    10da:	89 d0                	mov    %edx,%eax
    10dc:	0f b6 80 f6 23 00 00 	movzbl 0x23f6(%eax),%eax
    10e3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    10e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
    10ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10ed:	ba 00 00 00 00       	mov    $0x0,%edx
    10f2:	f7 f3                	div    %ebx
    10f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10fb:	75 c7                	jne    10c4 <printint+0x38>
  if(neg)
    10fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1101:	74 0e                	je     1111 <printint+0x85>
    buf[i++] = '-';
    1103:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1106:	8d 50 01             	lea    0x1(%eax),%edx
    1109:	89 55 f4             	mov    %edx,-0xc(%ebp)
    110c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1111:	eb 1d                	jmp    1130 <printint+0xa4>
    putc(fd, buf[i]);
    1113:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1116:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1119:	01 d0                	add    %edx,%eax
    111b:	0f b6 00             	movzbl (%eax),%eax
    111e:	0f be c0             	movsbl %al,%eax
    1121:	83 ec 08             	sub    $0x8,%esp
    1124:	50                   	push   %eax
    1125:	ff 75 08             	pushl  0x8(%ebp)
    1128:	e8 3d ff ff ff       	call   106a <putc>
    112d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1130:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1134:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1138:	79 d9                	jns    1113 <printint+0x87>
    putc(fd, buf[i]);
}
    113a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    113d:	c9                   	leave  
    113e:	c3                   	ret    

0000113f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    113f:	55                   	push   %ebp
    1140:	89 e5                	mov    %esp,%ebp
    1142:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1145:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    114c:	8d 45 0c             	lea    0xc(%ebp),%eax
    114f:	83 c0 04             	add    $0x4,%eax
    1152:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1155:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    115c:	e9 59 01 00 00       	jmp    12ba <printf+0x17b>
    c = fmt[i] & 0xff;
    1161:	8b 55 0c             	mov    0xc(%ebp),%edx
    1164:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1167:	01 d0                	add    %edx,%eax
    1169:	0f b6 00             	movzbl (%eax),%eax
    116c:	0f be c0             	movsbl %al,%eax
    116f:	25 ff 00 00 00       	and    $0xff,%eax
    1174:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1177:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    117b:	75 2c                	jne    11a9 <printf+0x6a>
      if(c == '%'){
    117d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1181:	75 0c                	jne    118f <printf+0x50>
        state = '%';
    1183:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    118a:	e9 27 01 00 00       	jmp    12b6 <printf+0x177>
      } else {
        putc(fd, c);
    118f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1192:	0f be c0             	movsbl %al,%eax
    1195:	83 ec 08             	sub    $0x8,%esp
    1198:	50                   	push   %eax
    1199:	ff 75 08             	pushl  0x8(%ebp)
    119c:	e8 c9 fe ff ff       	call   106a <putc>
    11a1:	83 c4 10             	add    $0x10,%esp
    11a4:	e9 0d 01 00 00       	jmp    12b6 <printf+0x177>
      }
    } else if(state == '%'){
    11a9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    11ad:	0f 85 03 01 00 00    	jne    12b6 <printf+0x177>
      if(c == 'd'){
    11b3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    11b7:	75 1e                	jne    11d7 <printf+0x98>
        printint(fd, *ap, 10, 1);
    11b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11bc:	8b 00                	mov    (%eax),%eax
    11be:	6a 01                	push   $0x1
    11c0:	6a 0a                	push   $0xa
    11c2:	50                   	push   %eax
    11c3:	ff 75 08             	pushl  0x8(%ebp)
    11c6:	e8 c1 fe ff ff       	call   108c <printint>
    11cb:	83 c4 10             	add    $0x10,%esp
        ap++;
    11ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11d2:	e9 d8 00 00 00       	jmp    12af <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    11d7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    11db:	74 06                	je     11e3 <printf+0xa4>
    11dd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    11e1:	75 1e                	jne    1201 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    11e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11e6:	8b 00                	mov    (%eax),%eax
    11e8:	6a 00                	push   $0x0
    11ea:	6a 10                	push   $0x10
    11ec:	50                   	push   %eax
    11ed:	ff 75 08             	pushl  0x8(%ebp)
    11f0:	e8 97 fe ff ff       	call   108c <printint>
    11f5:	83 c4 10             	add    $0x10,%esp
        ap++;
    11f8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11fc:	e9 ae 00 00 00       	jmp    12af <printf+0x170>
      } else if(c == 's'){
    1201:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1205:	75 43                	jne    124a <printf+0x10b>
        s = (char*)*ap;
    1207:	8b 45 e8             	mov    -0x18(%ebp),%eax
    120a:	8b 00                	mov    (%eax),%eax
    120c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    120f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1217:	75 07                	jne    1220 <printf+0xe1>
          s = "(null)";
    1219:	c7 45 f4 9c 1d 00 00 	movl   $0x1d9c,-0xc(%ebp)
        while(*s != 0){
    1220:	eb 1c                	jmp    123e <printf+0xff>
          putc(fd, *s);
    1222:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1225:	0f b6 00             	movzbl (%eax),%eax
    1228:	0f be c0             	movsbl %al,%eax
    122b:	83 ec 08             	sub    $0x8,%esp
    122e:	50                   	push   %eax
    122f:	ff 75 08             	pushl  0x8(%ebp)
    1232:	e8 33 fe ff ff       	call   106a <putc>
    1237:	83 c4 10             	add    $0x10,%esp
          s++;
    123a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    123e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1241:	0f b6 00             	movzbl (%eax),%eax
    1244:	84 c0                	test   %al,%al
    1246:	75 da                	jne    1222 <printf+0xe3>
    1248:	eb 65                	jmp    12af <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    124a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    124e:	75 1d                	jne    126d <printf+0x12e>
        putc(fd, *ap);
    1250:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1253:	8b 00                	mov    (%eax),%eax
    1255:	0f be c0             	movsbl %al,%eax
    1258:	83 ec 08             	sub    $0x8,%esp
    125b:	50                   	push   %eax
    125c:	ff 75 08             	pushl  0x8(%ebp)
    125f:	e8 06 fe ff ff       	call   106a <putc>
    1264:	83 c4 10             	add    $0x10,%esp
        ap++;
    1267:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    126b:	eb 42                	jmp    12af <printf+0x170>
      } else if(c == '%'){
    126d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1271:	75 17                	jne    128a <printf+0x14b>
        putc(fd, c);
    1273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1276:	0f be c0             	movsbl %al,%eax
    1279:	83 ec 08             	sub    $0x8,%esp
    127c:	50                   	push   %eax
    127d:	ff 75 08             	pushl  0x8(%ebp)
    1280:	e8 e5 fd ff ff       	call   106a <putc>
    1285:	83 c4 10             	add    $0x10,%esp
    1288:	eb 25                	jmp    12af <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    128a:	83 ec 08             	sub    $0x8,%esp
    128d:	6a 25                	push   $0x25
    128f:	ff 75 08             	pushl  0x8(%ebp)
    1292:	e8 d3 fd ff ff       	call   106a <putc>
    1297:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    129a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    129d:	0f be c0             	movsbl %al,%eax
    12a0:	83 ec 08             	sub    $0x8,%esp
    12a3:	50                   	push   %eax
    12a4:	ff 75 08             	pushl  0x8(%ebp)
    12a7:	e8 be fd ff ff       	call   106a <putc>
    12ac:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    12af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    12b6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    12ba:	8b 55 0c             	mov    0xc(%ebp),%edx
    12bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12c0:	01 d0                	add    %edx,%eax
    12c2:	0f b6 00             	movzbl (%eax),%eax
    12c5:	84 c0                	test   %al,%al
    12c7:	0f 85 94 fe ff ff    	jne    1161 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    12cd:	c9                   	leave  
    12ce:	c3                   	ret    

000012cf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12cf:	55                   	push   %ebp
    12d0:	89 e5                	mov    %esp,%ebp
    12d2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12d5:	8b 45 08             	mov    0x8(%ebp),%eax
    12d8:	83 e8 08             	sub    $0x8,%eax
    12db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12de:	a1 ac 24 00 00       	mov    0x24ac,%eax
    12e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12e6:	eb 24                	jmp    130c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12eb:	8b 00                	mov    (%eax),%eax
    12ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12f0:	77 12                	ja     1304 <free+0x35>
    12f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12f8:	77 24                	ja     131e <free+0x4f>
    12fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12fd:	8b 00                	mov    (%eax),%eax
    12ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1302:	77 1a                	ja     131e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1304:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1307:	8b 00                	mov    (%eax),%eax
    1309:	89 45 fc             	mov    %eax,-0x4(%ebp)
    130c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    130f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1312:	76 d4                	jbe    12e8 <free+0x19>
    1314:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1317:	8b 00                	mov    (%eax),%eax
    1319:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    131c:	76 ca                	jbe    12e8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    131e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1321:	8b 40 04             	mov    0x4(%eax),%eax
    1324:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    132b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    132e:	01 c2                	add    %eax,%edx
    1330:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1333:	8b 00                	mov    (%eax),%eax
    1335:	39 c2                	cmp    %eax,%edx
    1337:	75 24                	jne    135d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1339:	8b 45 f8             	mov    -0x8(%ebp),%eax
    133c:	8b 50 04             	mov    0x4(%eax),%edx
    133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1342:	8b 00                	mov    (%eax),%eax
    1344:	8b 40 04             	mov    0x4(%eax),%eax
    1347:	01 c2                	add    %eax,%edx
    1349:	8b 45 f8             	mov    -0x8(%ebp),%eax
    134c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    134f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1352:	8b 00                	mov    (%eax),%eax
    1354:	8b 10                	mov    (%eax),%edx
    1356:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1359:	89 10                	mov    %edx,(%eax)
    135b:	eb 0a                	jmp    1367 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    135d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1360:	8b 10                	mov    (%eax),%edx
    1362:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1365:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1367:	8b 45 fc             	mov    -0x4(%ebp),%eax
    136a:	8b 40 04             	mov    0x4(%eax),%eax
    136d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1374:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1377:	01 d0                	add    %edx,%eax
    1379:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    137c:	75 20                	jne    139e <free+0xcf>
    p->s.size += bp->s.size;
    137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1381:	8b 50 04             	mov    0x4(%eax),%edx
    1384:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1387:	8b 40 04             	mov    0x4(%eax),%eax
    138a:	01 c2                	add    %eax,%edx
    138c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    138f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1392:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1395:	8b 10                	mov    (%eax),%edx
    1397:	8b 45 fc             	mov    -0x4(%ebp),%eax
    139a:	89 10                	mov    %edx,(%eax)
    139c:	eb 08                	jmp    13a6 <free+0xd7>
  } else
    p->s.ptr = bp;
    139e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
    13a4:	89 10                	mov    %edx,(%eax)
  freep = p;
    13a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13a9:	a3 ac 24 00 00       	mov    %eax,0x24ac
}
    13ae:	c9                   	leave  
    13af:	c3                   	ret    

000013b0 <morecore>:

static Header*
morecore(uint nu)
{
    13b0:	55                   	push   %ebp
    13b1:	89 e5                	mov    %esp,%ebp
    13b3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    13b6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    13bd:	77 07                	ja     13c6 <morecore+0x16>
    nu = 4096;
    13bf:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    13c6:	8b 45 08             	mov    0x8(%ebp),%eax
    13c9:	c1 e0 03             	shl    $0x3,%eax
    13cc:	83 ec 0c             	sub    $0xc,%esp
    13cf:	50                   	push   %eax
    13d0:	e8 5d fc ff ff       	call   1032 <sbrk>
    13d5:	83 c4 10             	add    $0x10,%esp
    13d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    13db:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    13df:	75 07                	jne    13e8 <morecore+0x38>
    return 0;
    13e1:	b8 00 00 00 00       	mov    $0x0,%eax
    13e6:	eb 26                	jmp    140e <morecore+0x5e>
  hp = (Header*)p;
    13e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    13ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13f1:	8b 55 08             	mov    0x8(%ebp),%edx
    13f4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    13f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13fa:	83 c0 08             	add    $0x8,%eax
    13fd:	83 ec 0c             	sub    $0xc,%esp
    1400:	50                   	push   %eax
    1401:	e8 c9 fe ff ff       	call   12cf <free>
    1406:	83 c4 10             	add    $0x10,%esp
  return freep;
    1409:	a1 ac 24 00 00       	mov    0x24ac,%eax
}
    140e:	c9                   	leave  
    140f:	c3                   	ret    

00001410 <malloc>:

void*
malloc(uint nbytes)
{
    1410:	55                   	push   %ebp
    1411:	89 e5                	mov    %esp,%ebp
    1413:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1416:	8b 45 08             	mov    0x8(%ebp),%eax
    1419:	83 c0 07             	add    $0x7,%eax
    141c:	c1 e8 03             	shr    $0x3,%eax
    141f:	83 c0 01             	add    $0x1,%eax
    1422:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1425:	a1 ac 24 00 00       	mov    0x24ac,%eax
    142a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    142d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1431:	75 23                	jne    1456 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1433:	c7 45 f0 a4 24 00 00 	movl   $0x24a4,-0x10(%ebp)
    143a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    143d:	a3 ac 24 00 00       	mov    %eax,0x24ac
    1442:	a1 ac 24 00 00       	mov    0x24ac,%eax
    1447:	a3 a4 24 00 00       	mov    %eax,0x24a4
    base.s.size = 0;
    144c:	c7 05 a8 24 00 00 00 	movl   $0x0,0x24a8
    1453:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1456:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1459:	8b 00                	mov    (%eax),%eax
    145b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    145e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1461:	8b 40 04             	mov    0x4(%eax),%eax
    1464:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1467:	72 4d                	jb     14b6 <malloc+0xa6>
      if(p->s.size == nunits)
    1469:	8b 45 f4             	mov    -0xc(%ebp),%eax
    146c:	8b 40 04             	mov    0x4(%eax),%eax
    146f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1472:	75 0c                	jne    1480 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1474:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1477:	8b 10                	mov    (%eax),%edx
    1479:	8b 45 f0             	mov    -0x10(%ebp),%eax
    147c:	89 10                	mov    %edx,(%eax)
    147e:	eb 26                	jmp    14a6 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1480:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1483:	8b 40 04             	mov    0x4(%eax),%eax
    1486:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1489:	89 c2                	mov    %eax,%edx
    148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    148e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1491:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1494:	8b 40 04             	mov    0x4(%eax),%eax
    1497:	c1 e0 03             	shl    $0x3,%eax
    149a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    149d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
    14a3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    14a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14a9:	a3 ac 24 00 00       	mov    %eax,0x24ac
      return (void*)(p + 1);
    14ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b1:	83 c0 08             	add    $0x8,%eax
    14b4:	eb 3b                	jmp    14f1 <malloc+0xe1>
    }
    if(p == freep)
    14b6:	a1 ac 24 00 00       	mov    0x24ac,%eax
    14bb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    14be:	75 1e                	jne    14de <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    14c0:	83 ec 0c             	sub    $0xc,%esp
    14c3:	ff 75 ec             	pushl  -0x14(%ebp)
    14c6:	e8 e5 fe ff ff       	call   13b0 <morecore>
    14cb:	83 c4 10             	add    $0x10,%esp
    14ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14d5:	75 07                	jne    14de <malloc+0xce>
        return 0;
    14d7:	b8 00 00 00 00       	mov    $0x0,%eax
    14dc:	eb 13                	jmp    14f1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    14e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e7:	8b 00                	mov    (%eax),%eax
    14e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    14ec:	e9 6d ff ff ff       	jmp    145e <malloc+0x4e>
}
    14f1:	c9                   	leave  
    14f2:	c3                   	ret    

000014f3 <isspace>:

#include "common.h"

int isspace(char c) {
    14f3:	55                   	push   %ebp
    14f4:	89 e5                	mov    %esp,%ebp
    14f6:	83 ec 04             	sub    $0x4,%esp
    14f9:	8b 45 08             	mov    0x8(%ebp),%eax
    14fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return (c == '\n' || c == '\t' || c == '\r' || c == ' ');
    14ff:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
    1503:	74 12                	je     1517 <isspace+0x24>
    1505:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
    1509:	74 0c                	je     1517 <isspace+0x24>
    150b:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
    150f:	74 06                	je     1517 <isspace+0x24>
    1511:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
    1515:	75 07                	jne    151e <isspace+0x2b>
    1517:	b8 01 00 00 00       	mov    $0x1,%eax
    151c:	eb 05                	jmp    1523 <isspace+0x30>
    151e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1523:	c9                   	leave  
    1524:	c3                   	ret    

00001525 <readln>:

char* readln(char *buf, int max, int fd)
{
    1525:	55                   	push   %ebp
    1526:	89 e5                	mov    %esp,%ebp
    1528:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    152b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1532:	eb 45                	jmp    1579 <readln+0x54>
    cc = read(fd, &c, 1);
    1534:	83 ec 04             	sub    $0x4,%esp
    1537:	6a 01                	push   $0x1
    1539:	8d 45 ef             	lea    -0x11(%ebp),%eax
    153c:	50                   	push   %eax
    153d:	ff 75 10             	pushl  0x10(%ebp)
    1540:	e8 7d fa ff ff       	call   fc2 <read>
    1545:	83 c4 10             	add    $0x10,%esp
    1548:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    154b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    154f:	7f 02                	jg     1553 <readln+0x2e>
      break;
    1551:	eb 31                	jmp    1584 <readln+0x5f>
    buf[i++] = c;
    1553:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1556:	8d 50 01             	lea    0x1(%eax),%edx
    1559:	89 55 f4             	mov    %edx,-0xc(%ebp)
    155c:	89 c2                	mov    %eax,%edx
    155e:	8b 45 08             	mov    0x8(%ebp),%eax
    1561:	01 c2                	add    %eax,%edx
    1563:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1567:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1569:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    156d:	3c 0a                	cmp    $0xa,%al
    156f:	74 13                	je     1584 <readln+0x5f>
    1571:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1575:	3c 0d                	cmp    $0xd,%al
    1577:	74 0b                	je     1584 <readln+0x5f>
char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1579:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157c:	83 c0 01             	add    $0x1,%eax
    157f:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1582:	7c b0                	jl     1534 <readln+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1584:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1587:	8b 45 08             	mov    0x8(%ebp),%eax
    158a:	01 d0                	add    %edx,%eax
    158c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    158f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1592:	c9                   	leave  
    1593:	c3                   	ret    

00001594 <strncpy>:

char* strncpy(char* dest, char* src, int n) {
    1594:	55                   	push   %ebp
    1595:	89 e5                	mov    %esp,%ebp
    1597:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
    159a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    15a1:	eb 19                	jmp    15bc <strncpy+0x28>
		dest[i] = src[i];
    15a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
    15a6:	8b 45 08             	mov    0x8(%ebp),%eax
    15a9:	01 c2                	add    %eax,%edx
    15ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
    15ae:	8b 45 0c             	mov    0xc(%ebp),%eax
    15b1:	01 c8                	add    %ecx,%eax
    15b3:	0f b6 00             	movzbl (%eax),%eax
    15b6:	88 02                	mov    %al,(%edx)
  return buf;
}

char* strncpy(char* dest, char* src, int n) {
	int i;
	for (i=0; i < n && src[i] != '\0';i++)  {
    15b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    15bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15bf:	3b 45 10             	cmp    0x10(%ebp),%eax
    15c2:	7d 0f                	jge    15d3 <strncpy+0x3f>
    15c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    15c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    15ca:	01 d0                	add    %edx,%eax
    15cc:	0f b6 00             	movzbl (%eax),%eax
    15cf:	84 c0                	test   %al,%al
    15d1:	75 d0                	jne    15a3 <strncpy+0xf>
		dest[i] = src[i];
	}
	return dest;
    15d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15d6:	c9                   	leave  
    15d7:	c3                   	ret    

000015d8 <trim>:

char* trim(char* orig) {
    15d8:	55                   	push   %ebp
    15d9:	89 e5                	mov    %esp,%ebp
    15db:	83 ec 18             	sub    $0x18,%esp
	char* head;
	char* tail;
	char* new;
	head = orig;
    15de:	8b 45 08             	mov    0x8(%ebp),%eax
    15e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	tail = orig;
    15e4:	8b 45 08             	mov    0x8(%ebp),%eax
    15e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (isspace(*head)) { head++ ; }
    15ea:	eb 04                	jmp    15f0 <trim+0x18>
    15ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    15f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15f3:	0f b6 00             	movzbl (%eax),%eax
    15f6:	0f be c0             	movsbl %al,%eax
    15f9:	50                   	push   %eax
    15fa:	e8 f4 fe ff ff       	call   14f3 <isspace>
    15ff:	83 c4 04             	add    $0x4,%esp
    1602:	85 c0                	test   %eax,%eax
    1604:	75 e6                	jne    15ec <trim+0x14>
	while (*tail) { tail++; }
    1606:	eb 04                	jmp    160c <trim+0x34>
    1608:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    160c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    160f:	0f b6 00             	movzbl (%eax),%eax
    1612:	84 c0                	test   %al,%al
    1614:	75 f2                	jne    1608 <trim+0x30>
	do { tail--; } while (isspace(*tail));
    1616:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
    161a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    161d:	0f b6 00             	movzbl (%eax),%eax
    1620:	0f be c0             	movsbl %al,%eax
    1623:	50                   	push   %eax
    1624:	e8 ca fe ff ff       	call   14f3 <isspace>
    1629:	83 c4 04             	add    $0x4,%esp
    162c:	85 c0                	test   %eax,%eax
    162e:	75 e6                	jne    1616 <trim+0x3e>
	new = malloc(tail-head+2);
    1630:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1633:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1636:	29 c2                	sub    %eax,%edx
    1638:	89 d0                	mov    %edx,%eax
    163a:	83 c0 02             	add    $0x2,%eax
    163d:	83 ec 0c             	sub    $0xc,%esp
    1640:	50                   	push   %eax
    1641:	e8 ca fd ff ff       	call   1410 <malloc>
    1646:	83 c4 10             	add    $0x10,%esp
    1649:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strncpy(new,head,tail-head+1);
    164c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    164f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1652:	29 c2                	sub    %eax,%edx
    1654:	89 d0                	mov    %edx,%eax
    1656:	83 c0 01             	add    $0x1,%eax
    1659:	83 ec 04             	sub    $0x4,%esp
    165c:	50                   	push   %eax
    165d:	ff 75 f4             	pushl  -0xc(%ebp)
    1660:	ff 75 ec             	pushl  -0x14(%ebp)
    1663:	e8 2c ff ff ff       	call   1594 <strncpy>
    1668:	83 c4 10             	add    $0x10,%esp
	new[tail-head+1] = '\0';
    166b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    166e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1671:	29 c2                	sub    %eax,%edx
    1673:	89 d0                	mov    %edx,%eax
    1675:	8d 50 01             	lea    0x1(%eax),%edx
    1678:	8b 45 ec             	mov    -0x14(%ebp),%eax
    167b:	01 d0                	add    %edx,%eax
    167d:	c6 00 00             	movb   $0x0,(%eax)
	return new;
    1680:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
    1683:	c9                   	leave  
    1684:	c3                   	ret    

00001685 <itoa>:

char *
itoa(int value)
{
    1685:	55                   	push   %ebp
    1686:	89 e5                	mov    %esp,%ebp
    1688:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint v;
  int sign;
  char *sp;

  tp = tmp;
    168b:	8d 45 bf             	lea    -0x41(%ebp),%eax
    168e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sign = value < 0;
    1691:	8b 45 08             	mov    0x8(%ebp),%eax
    1694:	c1 e8 1f             	shr    $0x1f,%eax
    1697:	0f b6 c0             	movzbl %al,%eax
    169a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (sign)
    169d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    16a1:	74 0a                	je     16ad <itoa+0x28>
    v = -value;
    16a3:	8b 45 08             	mov    0x8(%ebp),%eax
    16a6:	f7 d8                	neg    %eax
    16a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    16ab:	eb 06                	jmp    16b3 <itoa+0x2e>
  else
    v = (uint)value;
    16ad:	8b 45 08             	mov    0x8(%ebp),%eax
    16b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (v || tp == tmp)
    16b3:	eb 5b                	jmp    1710 <itoa+0x8b>
  {
    i = v % 10;
    16b5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    16b8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    16bd:	89 c8                	mov    %ecx,%eax
    16bf:	f7 e2                	mul    %edx
    16c1:	c1 ea 03             	shr    $0x3,%edx
    16c4:	89 d0                	mov    %edx,%eax
    16c6:	c1 e0 02             	shl    $0x2,%eax
    16c9:	01 d0                	add    %edx,%eax
    16cb:	01 c0                	add    %eax,%eax
    16cd:	29 c1                	sub    %eax,%ecx
    16cf:	89 ca                	mov    %ecx,%edx
    16d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    v = v / 10;
    16d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16d7:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    16dc:	f7 e2                	mul    %edx
    16de:	89 d0                	mov    %edx,%eax
    16e0:	c1 e8 03             	shr    $0x3,%eax
    16e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (i < 10)
    16e6:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
    16ea:	7f 13                	jg     16ff <itoa+0x7a>
      *tp++ = i+'0';
    16ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ef:	8d 50 01             	lea    0x1(%eax),%edx
    16f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
    16f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    16f8:	83 c2 30             	add    $0x30,%edx
    16fb:	88 10                	mov    %dl,(%eax)
    16fd:	eb 11                	jmp    1710 <itoa+0x8b>
    else
      *tp++ = i + 'a' - 10;
    16ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1702:	8d 50 01             	lea    0x1(%eax),%edx
    1705:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1708:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    170b:	83 c2 57             	add    $0x57,%edx
    170e:	88 10                	mov    %dl,(%eax)
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (uint)value;
  while (v || tp == tmp)
    1710:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1714:	75 9f                	jne    16b5 <itoa+0x30>
    1716:	8d 45 bf             	lea    -0x41(%ebp),%eax
    1719:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    171c:	74 97                	je     16b5 <itoa+0x30>
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
    171e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1721:	8d 45 bf             	lea    -0x41(%ebp),%eax
    1724:	29 c2                	sub    %eax,%edx
    1726:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1729:	01 d0                	add    %edx,%eax
    172b:	83 c0 01             	add    $0x1,%eax
    172e:	83 ec 0c             	sub    $0xc,%esp
    1731:	50                   	push   %eax
    1732:	e8 d9 fc ff ff       	call   1410 <malloc>
    1737:	83 c4 10             	add    $0x10,%esp
    173a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = string;
    173d:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1740:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (sign)
    1743:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1747:	74 0c                	je     1755 <itoa+0xd0>
    *sp++ = '-';
    1749:	8b 45 ec             	mov    -0x14(%ebp),%eax
    174c:	8d 50 01             	lea    0x1(%eax),%edx
    174f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    1752:	c6 00 2d             	movb   $0x2d,(%eax)
  while (tp > tmp)
    1755:	eb 15                	jmp    176c <itoa+0xe7>
    *sp++ = *--tp;
    1757:	8b 45 ec             	mov    -0x14(%ebp),%eax
    175a:	8d 50 01             	lea    0x1(%eax),%edx
    175d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    1760:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1764:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1767:	0f b6 12             	movzbl (%edx),%edx
    176a:	88 10                	mov    %dl,(%eax)
  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
    176c:	8d 45 bf             	lea    -0x41(%ebp),%eax
    176f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1772:	77 e3                	ja     1757 <itoa+0xd2>
    *sp++ = *--tp;
  *sp = 0;
    1774:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1777:	c6 00 00             	movb   $0x0,(%eax)
  return string;
    177a:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
    177d:	c9                   	leave  
    177e:	c3                   	ret    

0000177f <parseEnvFile>:
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
    177f:	55                   	push   %ebp
    1780:	89 e5                	mov    %esp,%ebp
    1782:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
    1788:	83 ec 08             	sub    $0x8,%esp
    178b:	6a 00                	push   $0x0
    178d:	ff 75 08             	pushl  0x8(%ebp)
    1790:	e8 55 f8 ff ff       	call   fea <open>
    1795:	83 c4 10             	add    $0x10,%esp
    1798:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
    179b:	e9 22 01 00 00       	jmp    18c2 <parseEnvFile+0x143>
		eq = strchr(line,VAR_VALUE_SEPERATOR);
    17a0:	83 ec 08             	sub    $0x8,%esp
    17a3:	6a 3d                	push   $0x3d
    17a5:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
    17ab:	50                   	push   %eax
    17ac:	e8 79 f6 ff ff       	call   e2a <strchr>
    17b1:	83 c4 10             	add    $0x10,%esp
    17b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (!eq || eq == NULL) {
    17b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17bb:	0f 84 23 01 00 00    	je     18e4 <parseEnvFile+0x165>
    17c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17c5:	0f 84 19 01 00 00    	je     18e4 <parseEnvFile+0x165>
			break;
		}
		eqPos = eq - line;
    17cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
    17ce:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
    17d4:	29 c2                	sub    %eax,%edx
    17d6:	89 d0                	mov    %edx,%eax
    17d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		tmpStr = malloc(eqPos+1);
    17db:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17de:	83 c0 01             	add    $0x1,%eax
    17e1:	83 ec 0c             	sub    $0xc,%esp
    17e4:	50                   	push   %eax
    17e5:	e8 26 fc ff ff       	call   1410 <malloc>
    17ea:	83 c4 10             	add    $0x10,%esp
    17ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line,eqPos);
    17f0:	83 ec 04             	sub    $0x4,%esp
    17f3:	ff 75 ec             	pushl  -0x14(%ebp)
    17f6:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
    17fc:	50                   	push   %eax
    17fd:	ff 75 e8             	pushl  -0x18(%ebp)
    1800:	e8 8f fd ff ff       	call   1594 <strncpy>
    1805:	83 c4 10             	add    $0x10,%esp
		varName = trim(tmpStr);
    1808:	83 ec 0c             	sub    $0xc,%esp
    180b:	ff 75 e8             	pushl  -0x18(%ebp)
    180e:	e8 c5 fd ff ff       	call   15d8 <trim>
    1813:	83 c4 10             	add    $0x10,%esp
    1816:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(tmpStr);
    1819:	83 ec 0c             	sub    $0xc,%esp
    181c:	ff 75 e8             	pushl  -0x18(%ebp)
    181f:	e8 ab fa ff ff       	call   12cf <free>
    1824:	83 c4 10             	add    $0x10,%esp
		
		head = addToEnvironment(varName,head);
    1827:	83 ec 08             	sub    $0x8,%esp
    182a:	ff 75 0c             	pushl  0xc(%ebp)
    182d:	ff 75 e4             	pushl  -0x1c(%ebp)
    1830:	e8 c2 01 00 00       	call   19f7 <addToEnvironment>
    1835:	83 c4 10             	add    $0x10,%esp
    1838:	89 45 0c             	mov    %eax,0xc(%ebp)
		
		lineLen = strlen(line);
    183b:	83 ec 0c             	sub    $0xc,%esp
    183e:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
    1844:	50                   	push   %eax
    1845:	e8 9f f5 ff ff       	call   de9 <strlen>
    184a:	83 c4 10             	add    $0x10,%esp
    184d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		tmpStr = malloc(lineLen-eqPos);
    1850:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1853:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1856:	83 ec 0c             	sub    $0xc,%esp
    1859:	50                   	push   %eax
    185a:	e8 b1 fb ff ff       	call   1410 <malloc>
    185f:	83 c4 10             	add    $0x10,%esp
    1862:	89 45 e8             	mov    %eax,-0x18(%ebp)
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
    1865:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1868:	2b 45 ec             	sub    -0x14(%ebp),%eax
    186b:	8d 50 ff             	lea    -0x1(%eax),%edx
    186e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1871:	8d 48 01             	lea    0x1(%eax),%ecx
    1874:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
    187a:	01 c8                	add    %ecx,%eax
    187c:	83 ec 04             	sub    $0x4,%esp
    187f:	52                   	push   %edx
    1880:	50                   	push   %eax
    1881:	ff 75 e8             	pushl  -0x18(%ebp)
    1884:	e8 0b fd ff ff       	call   1594 <strncpy>
    1889:	83 c4 10             	add    $0x10,%esp
		varValue = trim(tmpStr);
    188c:	83 ec 0c             	sub    $0xc,%esp
    188f:	ff 75 e8             	pushl  -0x18(%ebp)
    1892:	e8 41 fd ff ff       	call   15d8 <trim>
    1897:	83 c4 10             	add    $0x10,%esp
    189a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(tmpStr);
    189d:	83 ec 0c             	sub    $0xc,%esp
    18a0:	ff 75 e8             	pushl  -0x18(%ebp)
    18a3:	e8 27 fa ff ff       	call   12cf <free>
    18a8:	83 c4 10             	add    $0x10,%esp
		
		head = addValueToVariable(varName ,head, varValue);
    18ab:	83 ec 04             	sub    $0x4,%esp
    18ae:	ff 75 dc             	pushl  -0x24(%ebp)
    18b1:	ff 75 0c             	pushl  0xc(%ebp)
    18b4:	ff 75 e4             	pushl  -0x1c(%ebp)
    18b7:	e8 b8 01 00 00       	call   1a74 <addValueToVariable>
    18bc:	83 c4 10             	add    $0x10,%esp
    18bf:	89 45 0c             	mov    %eax,0xc(%ebp)
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
    18c2:	83 ec 04             	sub    $0x4,%esp
    18c5:	ff 75 f4             	pushl  -0xc(%ebp)
    18c8:	68 00 04 00 00       	push   $0x400
    18cd:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
    18d3:	50                   	push   %eax
    18d4:	e8 4c fc ff ff       	call   1525 <readln>
    18d9:	83 c4 10             	add    $0x10,%esp
    18dc:	85 c0                	test   %eax,%eax
    18de:	0f 85 bc fe ff ff    	jne    17a0 <parseEnvFile+0x21>
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
    18e4:	83 ec 0c             	sub    $0xc,%esp
    18e7:	ff 75 f4             	pushl  -0xc(%ebp)
    18ea:	e8 e3 f6 ff ff       	call   fd2 <close>
    18ef:	83 c4 10             	add    $0x10,%esp
	return head;
    18f2:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    18f5:	c9                   	leave  
    18f6:	c3                   	ret    

000018f7 <comp>:

int comp(const char* s1, const char* s2)
{
    18f7:	55                   	push   %ebp
    18f8:	89 e5                	mov    %esp,%ebp
    18fa:	83 ec 08             	sub    $0x8,%esp
  return strcmp(s1,s2) == 0;
    18fd:	83 ec 08             	sub    $0x8,%esp
    1900:	ff 75 0c             	pushl  0xc(%ebp)
    1903:	ff 75 08             	pushl  0x8(%ebp)
    1906:	e8 9f f4 ff ff       	call   daa <strcmp>
    190b:	83 c4 10             	add    $0x10,%esp
    190e:	85 c0                	test   %eax,%eax
    1910:	0f 94 c0             	sete   %al
    1913:	0f b6 c0             	movzbl %al,%eax
}
    1916:	c9                   	leave  
    1917:	c3                   	ret    

00001918 <environLookup>:

variable* environLookup(const char* name, variable* head)
{
    1918:	55                   	push   %ebp
    1919:	89 e5                	mov    %esp,%ebp
    191b:	83 ec 08             	sub    $0x8,%esp
  if (!name)
    191e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1922:	75 07                	jne    192b <environLookup+0x13>
    return NULL;
    1924:	b8 00 00 00 00       	mov    $0x0,%eax
    1929:	eb 2f                	jmp    195a <environLookup+0x42>
  
  while (head)
    192b:	eb 24                	jmp    1951 <environLookup+0x39>
  {
    if (comp(name, head->name))
    192d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1930:	83 ec 08             	sub    $0x8,%esp
    1933:	50                   	push   %eax
    1934:	ff 75 08             	pushl  0x8(%ebp)
    1937:	e8 bb ff ff ff       	call   18f7 <comp>
    193c:	83 c4 10             	add    $0x10,%esp
    193f:	85 c0                	test   %eax,%eax
    1941:	74 02                	je     1945 <environLookup+0x2d>
      break;
    1943:	eb 12                	jmp    1957 <environLookup+0x3f>
    head = head->next;
    1945:	8b 45 0c             	mov    0xc(%ebp),%eax
    1948:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    194e:	89 45 0c             	mov    %eax,0xc(%ebp)
variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
    1951:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1955:	75 d6                	jne    192d <environLookup+0x15>
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
    1957:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    195a:	c9                   	leave  
    195b:	c3                   	ret    

0000195c <removeFromEnvironment>:

variable* removeFromEnvironment(const char* name, variable* head)
{
    195c:	55                   	push   %ebp
    195d:	89 e5                	mov    %esp,%ebp
    195f:	83 ec 18             	sub    $0x18,%esp
  variable* tmp;
  if (!head)
    1962:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1966:	75 0a                	jne    1972 <removeFromEnvironment+0x16>
    return NULL;
    1968:	b8 00 00 00 00       	mov    $0x0,%eax
    196d:	e9 83 00 00 00       	jmp    19f5 <removeFromEnvironment+0x99>
  if (!name || (*name == 0) )
    1972:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1976:	74 0a                	je     1982 <removeFromEnvironment+0x26>
    1978:	8b 45 08             	mov    0x8(%ebp),%eax
    197b:	0f b6 00             	movzbl (%eax),%eax
    197e:	84 c0                	test   %al,%al
    1980:	75 05                	jne    1987 <removeFromEnvironment+0x2b>
    return head;
    1982:	8b 45 0c             	mov    0xc(%ebp),%eax
    1985:	eb 6e                	jmp    19f5 <removeFromEnvironment+0x99>
  
  if (comp(head->name,name))
    1987:	8b 45 0c             	mov    0xc(%ebp),%eax
    198a:	83 ec 08             	sub    $0x8,%esp
    198d:	ff 75 08             	pushl  0x8(%ebp)
    1990:	50                   	push   %eax
    1991:	e8 61 ff ff ff       	call   18f7 <comp>
    1996:	83 c4 10             	add    $0x10,%esp
    1999:	85 c0                	test   %eax,%eax
    199b:	74 34                	je     19d1 <removeFromEnvironment+0x75>
  {
    tmp = head->next;
    199d:	8b 45 0c             	mov    0xc(%ebp),%eax
    19a0:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    19a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    freeVarval(head->values);
    19a9:	8b 45 0c             	mov    0xc(%ebp),%eax
    19ac:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
    19b2:	83 ec 0c             	sub    $0xc,%esp
    19b5:	50                   	push   %eax
    19b6:	e8 74 01 00 00       	call   1b2f <freeVarval>
    19bb:	83 c4 10             	add    $0x10,%esp
    free(head);
    19be:	83 ec 0c             	sub    $0xc,%esp
    19c1:	ff 75 0c             	pushl  0xc(%ebp)
    19c4:	e8 06 f9 ff ff       	call   12cf <free>
    19c9:	83 c4 10             	add    $0x10,%esp
    return tmp;
    19cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19cf:	eb 24                	jmp    19f5 <removeFromEnvironment+0x99>
  }
      
  head->next = removeFromEnvironment(name, head->next);
    19d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    19d4:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    19da:	83 ec 08             	sub    $0x8,%esp
    19dd:	50                   	push   %eax
    19de:	ff 75 08             	pushl  0x8(%ebp)
    19e1:	e8 76 ff ff ff       	call   195c <removeFromEnvironment>
    19e6:	83 c4 10             	add    $0x10,%esp
    19e9:	8b 55 0c             	mov    0xc(%ebp),%edx
    19ec:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  return head;
    19f2:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    19f5:	c9                   	leave  
    19f6:	c3                   	ret    

000019f7 <addToEnvironment>:

variable* addToEnvironment(char* name, variable* head)
{
    19f7:	55                   	push   %ebp
    19f8:	89 e5                	mov    %esp,%ebp
    19fa:	83 ec 18             	sub    $0x18,%esp
	variable* newVar;
	char* tmpName;
	if (!name)
    19fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1a01:	75 05                	jne    1a08 <addToEnvironment+0x11>
		return head;
    1a03:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a06:	eb 6a                	jmp    1a72 <addToEnvironment+0x7b>
	if (head == NULL) {
    1a08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1a0c:	75 40                	jne    1a4e <addToEnvironment+0x57>
		newVar = (variable*) malloc( sizeof(variable) );
    1a0e:	83 ec 0c             	sub    $0xc,%esp
    1a11:	68 88 00 00 00       	push   $0x88
    1a16:	e8 f5 f9 ff ff       	call   1410 <malloc>
    1a1b:	83 c4 10             	add    $0x10,%esp
    1a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		tmpName = name;
    1a21:	8b 45 08             	mov    0x8(%ebp),%eax
    1a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
		strcpy(newVar->name, tmpName);
    1a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a2a:	83 ec 08             	sub    $0x8,%esp
    1a2d:	ff 75 f0             	pushl  -0x10(%ebp)
    1a30:	50                   	push   %eax
    1a31:	e8 44 f3 ff ff       	call   d7a <strcpy>
    1a36:	83 c4 10             	add    $0x10,%esp
		newVar->next = NULL;
    1a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a3c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
    1a43:	00 00 00 
		head = newVar;
    1a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a49:	89 45 0c             	mov    %eax,0xc(%ebp)
    1a4c:	eb 21                	jmp    1a6f <addToEnvironment+0x78>
	}
	else
		head->next = addToEnvironment(name, head->next);
    1a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a51:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    1a57:	83 ec 08             	sub    $0x8,%esp
    1a5a:	50                   	push   %eax
    1a5b:	ff 75 08             	pushl  0x8(%ebp)
    1a5e:	e8 94 ff ff ff       	call   19f7 <addToEnvironment>
    1a63:	83 c4 10             	add    $0x10,%esp
    1a66:	8b 55 0c             	mov    0xc(%ebp),%edx
    1a69:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
	return head;
    1a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    1a72:	c9                   	leave  
    1a73:	c3                   	ret    

00001a74 <addValueToVariable>:

variable* addValueToVariable(char* name, variable* head, char* value) {
    1a74:	55                   	push   %ebp
    1a75:	89 e5                	mov    %esp,%ebp
    1a77:	83 ec 18             	sub    $0x18,%esp
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
    1a7a:	83 ec 08             	sub    $0x8,%esp
    1a7d:	ff 75 0c             	pushl  0xc(%ebp)
    1a80:	ff 75 08             	pushl  0x8(%ebp)
    1a83:	e8 90 fe ff ff       	call   1918 <environLookup>
    1a88:	83 c4 10             	add    $0x10,%esp
    1a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!var)
    1a8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a92:	75 05                	jne    1a99 <addValueToVariable+0x25>
		return head;
    1a94:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a97:	eb 4c                	jmp    1ae5 <addValueToVariable+0x71>
	newVal = (varval*) malloc( sizeof(varval) );
    1a99:	83 ec 0c             	sub    $0xc,%esp
    1a9c:	68 04 04 00 00       	push   $0x404
    1aa1:	e8 6a f9 ff ff       	call   1410 <malloc>
    1aa6:	83 c4 10             	add    $0x10,%esp
    1aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	tmpValue = value;
    1aac:	8b 45 10             	mov    0x10(%ebp),%eax
    1aaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(newVal->value, tmpValue);
    1ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ab5:	83 ec 08             	sub    $0x8,%esp
    1ab8:	ff 75 ec             	pushl  -0x14(%ebp)
    1abb:	50                   	push   %eax
    1abc:	e8 b9 f2 ff ff       	call   d7a <strcpy>
    1ac1:	83 c4 10             	add    $0x10,%esp
	newVal->next = var->values;
    1ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
    1acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ad0:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	var->values = newVal;
    1ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad9:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1adc:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	return head;
    1ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    1ae5:	c9                   	leave  
    1ae6:	c3                   	ret    

00001ae7 <freeEnvironment>:

void freeEnvironment(variable* head)
{
    1ae7:	55                   	push   %ebp
    1ae8:	89 e5                	mov    %esp,%ebp
    1aea:	83 ec 08             	sub    $0x8,%esp
  if (!head)
    1aed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1af1:	75 02                	jne    1af5 <freeEnvironment+0xe>
    return;  
    1af3:	eb 38                	jmp    1b2d <freeEnvironment+0x46>
  freeEnvironment(head->next);
    1af5:	8b 45 08             	mov    0x8(%ebp),%eax
    1af8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    1afe:	83 ec 0c             	sub    $0xc,%esp
    1b01:	50                   	push   %eax
    1b02:	e8 e0 ff ff ff       	call   1ae7 <freeEnvironment>
    1b07:	83 c4 10             	add    $0x10,%esp
  freeVarval(head->values);
    1b0a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b0d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
    1b13:	83 ec 0c             	sub    $0xc,%esp
    1b16:	50                   	push   %eax
    1b17:	e8 13 00 00 00       	call   1b2f <freeVarval>
    1b1c:	83 c4 10             	add    $0x10,%esp
  free(head);
    1b1f:	83 ec 0c             	sub    $0xc,%esp
    1b22:	ff 75 08             	pushl  0x8(%ebp)
    1b25:	e8 a5 f7 ff ff       	call   12cf <free>
    1b2a:	83 c4 10             	add    $0x10,%esp
}
    1b2d:	c9                   	leave  
    1b2e:	c3                   	ret    

00001b2f <freeVarval>:

void freeVarval(varval* head)
{
    1b2f:	55                   	push   %ebp
    1b30:	89 e5                	mov    %esp,%ebp
    1b32:	83 ec 08             	sub    $0x8,%esp
  if (!head)
    1b35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1b39:	75 02                	jne    1b3d <freeVarval+0xe>
    return;  
    1b3b:	eb 23                	jmp    1b60 <freeVarval+0x31>
  freeVarval(head->next);
    1b3d:	8b 45 08             	mov    0x8(%ebp),%eax
    1b40:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
    1b46:	83 ec 0c             	sub    $0xc,%esp
    1b49:	50                   	push   %eax
    1b4a:	e8 e0 ff ff ff       	call   1b2f <freeVarval>
    1b4f:	83 c4 10             	add    $0x10,%esp
  free(head);
    1b52:	83 ec 0c             	sub    $0xc,%esp
    1b55:	ff 75 08             	pushl  0x8(%ebp)
    1b58:	e8 72 f7 ff ff       	call   12cf <free>
    1b5d:	83 c4 10             	add    $0x10,%esp
}
    1b60:	c9                   	leave  
    1b61:	c3                   	ret    

00001b62 <getPaths>:

varval* getPaths(char* paths, varval* head) {
    1b62:	55                   	push   %ebp
    1b63:	89 e5                	mov    %esp,%ebp
    1b65:	83 ec 18             	sub    $0x18,%esp
	char* nextSeperator;
	int pathLen;
	if (!paths)
    1b68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1b6c:	75 08                	jne    1b76 <getPaths+0x14>
		return head;
    1b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b71:	e9 e7 00 00 00       	jmp    1c5d <getPaths+0xfb>
	if (head == NULL) {
    1b76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1b7a:	0f 85 b9 00 00 00    	jne    1c39 <getPaths+0xd7>
		nextSeperator = strchr(paths,PATH_SEPERATOR);
    1b80:	83 ec 08             	sub    $0x8,%esp
    1b83:	6a 3a                	push   $0x3a
    1b85:	ff 75 08             	pushl  0x8(%ebp)
    1b88:	e8 9d f2 ff ff       	call   e2a <strchr>
    1b8d:	83 c4 10             	add    $0x10,%esp
    1b90:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (!nextSeperator) {
    1b93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b97:	75 56                	jne    1bef <getPaths+0x8d>
			pathLen = strlen(paths);
    1b99:	83 ec 0c             	sub    $0xc,%esp
    1b9c:	ff 75 08             	pushl  0x8(%ebp)
    1b9f:	e8 45 f2 ff ff       	call   de9 <strlen>
    1ba4:	83 c4 10             	add    $0x10,%esp
    1ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
    1baa:	83 ec 0c             	sub    $0xc,%esp
    1bad:	68 04 04 00 00       	push   $0x404
    1bb2:	e8 59 f8 ff ff       	call   1410 <malloc>
    1bb7:	83 c4 10             	add    $0x10,%esp
    1bba:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
    1bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
    1bc0:	83 ec 04             	sub    $0x4,%esp
    1bc3:	ff 75 f0             	pushl  -0x10(%ebp)
    1bc6:	ff 75 08             	pushl  0x8(%ebp)
    1bc9:	50                   	push   %eax
    1bca:	e8 c5 f9 ff ff       	call   1594 <strncpy>
    1bcf:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
    1bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
    1bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bd8:	01 d0                	add    %edx,%eax
    1bda:	c6 00 00             	movb   $0x0,(%eax)
			head->next = NULL;
    1bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
    1be0:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
    1be7:	00 00 00 
			return head;
    1bea:	8b 45 0c             	mov    0xc(%ebp),%eax
    1bed:	eb 6e                	jmp    1c5d <getPaths+0xfb>
		}
		else {
			pathLen = nextSeperator - paths;
    1bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bf2:	8b 45 08             	mov    0x8(%ebp),%eax
    1bf5:	29 c2                	sub    %eax,%edx
    1bf7:	89 d0                	mov    %edx,%eax
    1bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			head = (varval*) malloc(sizeof(varval));
    1bfc:	83 ec 0c             	sub    $0xc,%esp
    1bff:	68 04 04 00 00       	push   $0x404
    1c04:	e8 07 f8 ff ff       	call   1410 <malloc>
    1c09:	83 c4 10             	add    $0x10,%esp
    1c0c:	89 45 0c             	mov    %eax,0xc(%ebp)
			strncpy(head->value,paths,pathLen);
    1c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1c12:	83 ec 04             	sub    $0x4,%esp
    1c15:	ff 75 f0             	pushl  -0x10(%ebp)
    1c18:	ff 75 08             	pushl  0x8(%ebp)
    1c1b:	50                   	push   %eax
    1c1c:	e8 73 f9 ff ff       	call   1594 <strncpy>
    1c21:	83 c4 10             	add    $0x10,%esp
			head->value[pathLen] = '\0';
    1c24:	8b 55 0c             	mov    0xc(%ebp),%edx
    1c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c2a:	01 d0                	add    %edx,%eax
    1c2c:	c6 00 00             	movb   $0x0,(%eax)
			paths = nextSeperator;
    1c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c32:	89 45 08             	mov    %eax,0x8(%ebp)
			paths++;
    1c35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		}
	}
	head->next = getPaths(paths,head->next);
    1c39:	8b 45 0c             	mov    0xc(%ebp),%eax
    1c3c:	8b 80 00 04 00 00    	mov    0x400(%eax),%eax
    1c42:	83 ec 08             	sub    $0x8,%esp
    1c45:	50                   	push   %eax
    1c46:	ff 75 08             	pushl  0x8(%ebp)
    1c49:	e8 14 ff ff ff       	call   1b62 <getPaths>
    1c4e:	83 c4 10             	add    $0x10,%esp
    1c51:	8b 55 0c             	mov    0xc(%ebp),%edx
    1c54:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	return head;
    1c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
}
    1c5d:	c9                   	leave  
    1c5e:	c3                   	ret    
