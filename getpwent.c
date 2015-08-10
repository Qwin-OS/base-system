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
getpwnam (const char *name)
{
  FILE *fp;
  char buf[1024];

  if ((fp = fopen ("/etc/passwd", "r")) == NULL)
    {
      return NULL;
    }

  while (fgets (buf, 1024, fp))
    {
      sscanf (buf, "%s:%s:%d:%d:%s:%s:%s\n",
      	      logname, password, &pw_passwd.pw_uid,
             &pw_passwd.pw_gid, gecos,
            dir, shell);
      pw_passwd.pw_name = logname;
      pw_passwd.pw_passwd = password;
      pw_passwd.pw_gecos = gecos;
      pw_passwd.pw_dir = dir;
      pw_passwd.pw_shell = shell;

      if (!strcmp (logname, name))
	{
	  fclose (fp);
	  return &pw_passwd;
	}
    }
  fclose (fp);
  return NULL;
}


struct passwd *
getpwuid (uid_t uid)
{
  FILE *fp;
  char buf[1024];

  if ((fp = fopen ("/etc/passwd", "r")) == NULL)
    {
      return NULL;
    }

  while (fgets (buf, 1024, fp))
    {
      sscanf (buf, "%s:%s:%d:%d:%s:%s:%s\n",
      	      logname, password, &pw_passwd.pw_uid,
             &pw_passwd.pw_gid, gecos,
            dir, shell);
      pw_passwd.pw_name = logname;
      pw_passwd.pw_passwd = password;
      pw_passwd.pw_gecos = gecos;
      pw_passwd.pw_dir = dir;
      pw_passwd.pw_shell = shell;

      if (uid == pw_passwd.pw_uid)
	{
	  fclose (fp);
	  return &pw_passwd;
	}
    }
  fclose (fp);
  return NULL;
}

struct passwd *
getpwent ()
{
  char buf[1024];

  if (passwd_fp == NULL)
    return NULL;

  if (fgets (buf, sizeof (buf), passwd_fp) == NULL)
    return NULL;

  sscanf (buf, "%s:%s:%d:%d:%s:%s:%s\n",
	  logname, password, &pw_passwd.pw_uid,
         &pw_passwd.pw_gid, gecos,
	  dir, shell);
  pw_passwd.pw_name = logname;
  pw_passwd.pw_passwd = password;
  pw_passwd.pw_gecos = gecos;
  pw_passwd.pw_dir = dir;
  pw_passwd.pw_shell = shell;

  return &pw_passwd;
}

void
setpwent ()
{
  if (passwd_fp != NULL)
    fclose (passwd_fp);

  passwd_fp = fopen ("/etc/passwd", "r");
}

void
endpwent ()
{
  if (passwd_fp != NULL)
    fclose (passwd_fp);
}
