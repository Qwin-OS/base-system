#include "types.h"
#include "stat.h"
#include "unistd.h"

int main(int argc, char *argv[]) {

printf(1, "uptime: %d seconds\n", (uptime()/100));

exit();
}
