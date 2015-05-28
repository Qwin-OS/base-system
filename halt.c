#include <stdio.h>

int main (int argc, char *argv[]) {
if (getuid() != 0) {
fprintf(stderr, "halt: must be superuser\n");
return 1;
}
else {
return shutdown();
}
}
