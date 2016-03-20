#include <types.h>
#include <defs.h>
#include <x86.h>
#include <traps.h>
#include <device.h>
#include <module.h>
#include <vfs.h>

MODULE("VFS");

int fs_read(fs_t *node, struct file *f, char *p, int n)
{
return node->read(f,p,n);
}

int fs_dup(fs_t *node, struct file *f)
{
return node->dup(f);
}

int fs_write(fs_t *node, struct file *f, char *p, int n)
{
return node->write(f,p,n);
}

int fs_close(fs_t *node, int fd)
{
return node->close(fd);
}

int fs_fstat(fs_t *node, struct file *f, struct stat *st)
{
return node->fstat(f,st);
}
