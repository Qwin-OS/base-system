#include <stdio.h>

int main(int argc, char *argv[]) {
if(argc <= 1){
fprintf(stderr, "sleep: missing opperand\n");
exit(0);
}

if(argc <= 2){
int count = atoi(argv[1]);
sleep(count);
}
return 0;
}
