// Shell.

/*
 * already included in common.h 
 */
/**/
#include <stdio.h>
#include <fcntl.h>
#include <stddef.h>
#include <environ.h>

// Parsed command representation
#define EXEC  1
#define REDIR 2
#define PIPE  3
#define LIST  4
#define BACK  5

#define MAXARGS 10
#define NULL 0

#define ENV_FILENAME "/etc/environment"
#define PATH_VAR "PATH"
#define MAX_CMD_PATH_LEN 256

#define MAX_VAR_NAME 128
#define MAX_VAR_VAL 1024
#define MAX_VAR_LINE 1024
#define PATH_SEPERATOR ':'
#define VAR_VALUE_SEPERATOR '='

void strip(char *s) {
    char *p2 = s;
    while(*s != '\0') {
    	if(*s != '\t' && *s != '\n') {
    		*p2++ = *s++;
    	} else {
    		++s;
    	}
    }
    *p2 = '\0';
}

char* readln(char *buf, int max, int fd)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(fd, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
  return buf;
}

//char* strncpy(char* dest, char* src, int n) {
//	int i;
//	for (i=0; i < n && src[i] != '\0';i++)  {
//		dest[i] = src[i];
//	}
//	return dest;
//}

char* trim(char* orig) {
	char* head;
	char* tail;
	char* new;
	head = orig;
	tail = orig;
	while (isspace(*head)) { head++ ; }
	while (*tail) { tail++; }
	do { tail--; } while (isspace(*tail));
	new = malloc(tail-head+2);
	strncpy(new,head,tail-head+1);
	new[tail-head+1] = '\0';
	return new;
}

char *
itoa(int value)
{
  char tmp[33];
  char *string;
  char *tp;
  int i;
  int v;
  int sign;
  char *sp;

  tp = tmp;
  sign = value < 0;
  if (sign)
    v = -value;
  else
    v = (int)value;
  while (v || tp == tmp)
  {
    i = v % 10;
    v = v / 10;
    if (i < 10)
      *tp++ = i+'0';
    else
      *tp++ = i + 'a' - 10;
  }

  string = (char*)malloc((tp - tmp) + sign + 1);
  sp = string;

  if (sign)
    *sp++ = '-';
  while (tp > tmp)
    *sp++ = *--tp;
  *sp = 0;
  return string;
}

variable* parseEnvFile(char* filename, variable* head) {
	char* varName;
	char* varValue;
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
		eq = strchr(line,VAR_VALUE_SEPERATOR);
		if (!eq || eq == NULL) {
			break;
		}
		eqPos = eq - line;
		tmpStr = malloc(eqPos+1);
		strncpy(tmpStr,line,eqPos);
		varName = trim(tmpStr);
		free(tmpStr);
		
		head = addToEnvironment(varName,head);
		
		lineLen = strlen(line);
		tmpStr = malloc(lineLen-eqPos);
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
	return head;
}

int comp(const char* s1, const char* s2)
{
  return strcmp(s1,s2) == 0;
}

variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
}

variable* removeFromEnvironment(const char* name, variable* head)
{
  variable* tmp;
  if (!head)
    return NULL;
  if (!name || (*name == 0) )
    return head;
  
  if (comp(head->name,name))
  {
    tmp = head->next;
    freeVarval(head->values);
    free(head);
    return tmp;
  }
      
  head->next = removeFromEnvironment(name, head->next);
  return head;
}

variable* addToEnvironment(char* name, variable* head)
{
	variable* newVar;
	char* tmpName;
	if (!name)
		return head;
	if (head == NULL) {
		newVar = (variable*) malloc( sizeof(variable) );
		tmpName = name;
		strcpy(newVar->name, tmpName);
		newVar->next = NULL;
		head = newVar;
	}
	else
		head->next = addToEnvironment(name, head->next);
	return head;
}

variable* addValueToVariable(char* name, variable* head, char* value) {
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
	if (!var)
		return head;
	newVal = (varval*) malloc( sizeof(varval) );
	tmpValue = value;
	strcpy(newVal->value, tmpValue);
	newVal->next = var->values;
	var->values = newVal;
	return head;
}

void freeEnvironment(variable* head)
{
  if (!head)
    return;  
  freeEnvironment(head->next);
  freeVarval(head->values);
  free(head);
}

void freeVarval(varval* head)
{
  if (!head)
    return;  
  freeVarval(head->next);
  free(head);
}

varval* getPaths(char* paths, varval* head) {
	char* nextSeperator;
	int pathLen;
	if (!paths)
		return head;
	if (head == NULL) {
		nextSeperator = strchr(paths,PATH_SEPERATOR);
		if (!nextSeperator) {
			pathLen = strlen(paths);
			head = (varval*) malloc(sizeof(varval));
			strncpy(head->value,paths,pathLen);
			head->value[pathLen] = '\0';
			head->next = NULL;
			return head;
		}
		else {
			pathLen = nextSeperator - paths;
			head = (varval*) malloc(sizeof(varval));
			strncpy(head->value,paths,pathLen);
			head->value[pathLen] = '\0';
			paths = nextSeperator;
			paths++;
		}
	}
	head->next = getPaths(paths,head->next);
	return head;
}


struct cmd {
  int type;
};

struct execcmd {
  int type;
  char *argv[MAXARGS];
  char *eargv[MAXARGS];
};

struct redircmd {
  int type;
  struct cmd *cmd;
  char *file;
  char *efile;
  int mode;
  int fd;
};

struct pipecmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct listcmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct backcmd {
  int type;
  struct cmd *cmd;
};

int fork1(void);  // Fork but panics on failure.
void panic(char*);
struct cmd *parsecmd(char*);

varval* paths;

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
  int p[2];
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;
  varval* path;
  char fullPath[MAX_CMD_PATH_LEN];

  if(cmd == 0)
    exit(0);
  
  switch(cmd->type){
  default:
    panic("runcmd");

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
      exit(0);
    path = paths;
    while (path) {
		strcpy(fullPath,path->value);
		strcpy(fullPath + strlen(path->value),ecmd->argv[0]);
		execv(fullPath, ecmd->argv);
		path = path->next;
	}
    fprintf(stderr, "sh: %s: command not found\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      fprintf(stderr, "sh: %s: no such file or directory\n", rcmd->file);
      exit(0);
    }
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left);
    wait();
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
    close(p[1]);
    wait();
    wait();
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
  char *ps1;
  ps1 = "$";
  fprintf(stderr, "%s ",ps1);
  memset(buf, 0, nbuf);
  gets(buf);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

int
main(void)
{
  	variable* head;
	variable* var;
	static char buf[100];

	// load and parse env file
	head = NULL;
	head = parseEnvFile(ENV_FILENAME,head);
	var = environLookup(PATH_VAR,head);
	paths = NULL;
	paths = getPaths(var->values->value,paths);
	printf("\n");

        chdir("/root");
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      strip(buf);
     if(chdir(buf+3) < 0)
        fprintf(stderr, "sh: cd: %s: no such file or directory\n", buf+3);
      continue;
    }
    if(buf[0] == 'c' && buf[1] == 'd'){
      chdir("/root");
      continue;
    }
    if(buf[0] == 'e' && buf[1] == 'x' && buf[2] == 'i' && buf[3] == 't'){
      exit(0);
      continue;
    }
     if(buf[0] == '#'){
      continue;
    }



    if(fork1() == 0)
		runcmd(parsecmd(buf));
		wait();
    }
  
	freeVarval(paths);
	freeEnvironment(head);
	
	return 0;
}

void
panic(char *s)
{
  fprintf(stderr, "%s\n", s);
  exit(0);
}

int
fork1(void)
{
  int pid;
  
  pid = fork();
  if(pid == -1)
    panic("fork");
  return pid;
}

// Constructors

struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
  cmd->cmd = subcmd;
  cmd->file = file;
  cmd->efile = efile;
  cmd->mode = mode;
  cmd->fd = fd;
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
  cmd->cmd = subcmd;
  return (struct cmd*)cmd;
}
// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
  case '|':
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct cmd *parseline(char**, char*);
struct cmd *parsepipe(char**, char*);
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    fprintf(stderr, "leftovers: %s\n", s);
    panic("syntax");
  }
  nulterminate(cmd);
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREAT, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREAT, 1);
      break;
    }
  }
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if(!peek(ps, es, ")"))
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
  cmd = parseredirs(cmd, ps, es);
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
  int i;
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    *rcmd->efile = 0;
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    nulterminate(pcmd->left);
    nulterminate(pcmd->right);
    break;
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
