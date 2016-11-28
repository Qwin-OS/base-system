#ifndef _VFS_H_
#define _VFS_H_

typedef struct _fs_t {
	char *name;
	int (*dup)(struct file *f);
	int (*read)(struct file *f, char *p, int n);
	int (*write)(struct file *f, char *p, int n);
	int (*close)(int fd);
	int (*fstat)(struct file *f, struct stat *st);
} fs_t;

#endif
