#include <stdio.h>

int main(int argc, char *argv[]) {
  if(argc != 4){
    fprintf(stderr, "mknod: usage: mknod file minor major\n");
    exit(0);
  }

 if(mknod(argv[1], atoi(argv[2]), atoi(argv[3])) < 0) {
   fprintf(stderr, "mknod: unable to create device file %s\n",argv[1]);
   exit(0);
 }
  return 0;
}
