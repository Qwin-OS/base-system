#ifndef _DEVICE_H_
#define _DEVICE_H_

// table mapping major device number to
// device functions
struct device_t {
  char *name;
  int enabled;
  int (*read)(struct inode*, char*, int);
  int (*write)(struct inode*, char*, int);
};

extern struct device_t device_t[];
extern struct device_t device_get(int);

#define DEV_TTY 1
#define DEV_NULL 2
#define DEV_ZERO 3

#endif
