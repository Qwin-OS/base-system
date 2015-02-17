#include <stdio.h>
#include <string.h>
#include <pwd.h>

static struct passwd pw_passwd;
static int *passwd_fp;

static char logname[8];
static char password[1024];
static char gecos[1024];
static char dir[1024];
static char shell[1024];

struct passwd *
getpwuid (uid_t uid)
{
  int *fp;
  char buf[1024];

  if ((fp = open ("/etc/passwd", "r")) == NULL)
    {
      return NULL;
    }

  while (gets (buf))
    {
      //sscanf (buf, "%[^:]:%[^:]:%d:%d:%[^:]:%[^:]:%s\n",
      //	      logname, password, &pw_passwd.pw_uid,
      //       &pw_passwd.pw_gid, gecos,
      //      dir, shell);
      pw_passwd.pw_name = logname;
      pw_passwd.pw_passwd = password;
      pw_passwd.pw_gecos = gecos;
      pw_passwd.pw_dir = dir;
      pw_passwd.pw_shell = shell;

      if (uid == pw_passwd.pw_uid)
	{
	  close (fp);
	  return &pw_passwd;
	}
    }
  close (fp);
  return NULL;
}

