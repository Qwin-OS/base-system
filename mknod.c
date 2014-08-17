#include "types.h"
#include "unistd.h"

int main(int argc, char *argv[]) {
  if(argc != 4){
    printf(2, "mknod: usage: mknod file minor major\n");
    exit();
  }

 if(mknod(argv[1], atoi(argv[2]), atoi(argv[3])) < 0) {
   printf(2, "mknod: unable to create device file %s\n",argv[1]);
   exit();
 }
  exit();
}
