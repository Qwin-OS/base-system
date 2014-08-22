#include "types.h"
#include "unistd.h"

static const char *
readpw(void)
{
static char pw[64];
for (int i = 0; i < sizeof(pw); i++) {
int r = read(0, &pw[i], 1);
if (r != 1)
return 0;
if (pw[i] == '\r') {
pw[i] = 0;
}
else if (pw[i] == '\n') {
pw[i] = 0;
return pw;
}
}
return 0;
}

int main(void) {
const char *pw;

printf(1, "Password: ");
pw = readpw();

if (pw && !strcmp(pw,"qwin")) {
static const char *argv[] = { "/bin/sh", 0 };
printf(1,"\n");
exec("/bin/sh", argv);
}
else {
main();
}
exit();
return 0;
}
