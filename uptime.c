#include <stdio.h>

int main(int argc, char *argv[]) {
fprintf(stdout, "uptime: %d minutes\n", (uptime()/100/60));
return 0;
}
