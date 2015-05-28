#include <stdio.h>

int main (int argc, char *argv[]) {
if (getuid() != 0) {
fprintf(stderr, "reboot: must be superuser\n");
return 1;
}
else {
sleep(1);
return reboot();
}
}
