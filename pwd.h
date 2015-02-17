/* Copyright 2014-2015 (Flex1911)
   Qwin Libc */

#ifndef _PWD_H
#define _PWD_H

/* The passwd structure.  */
struct passwd
{
  char *pw_name;		/* Username.  */
  char *pw_passwd;		/* Password.  */
  uid_t pw_uid;		        /* User ID.  */
  gid_t pw_gid;		        /* Group ID.  */
  char *pw_gecos;		/* Real name.  */
  char *pw_dir;			/* Home directory.  */
  char *pw_shell;		/* Shell program.  */
};

struct passwd	*getpwuid (uid_t);
void		 endpwent (void);

#endif
