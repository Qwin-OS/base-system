#include <stdio.h>

int main(int argc, char *argv[]) {

fprintf(stdout, "uptime: %d seconds\n", (uptime()/100));

return 0;
}
