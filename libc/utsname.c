#include <unistd.h>
#include <utsname.h>
#include <version.h>

int uname(struct utsname * name) {
char version_number[256] = KVERSION""PREFIX;
char version_string[256] = CODENAME" "DATE" "TIME;
char hostname[256];
gethostname(hostname);

strcpy(name->sysname, UNAME);
strcpy(name->nodename, hostname);
strcpy(name->release, version_number);
strcpy(name->version, version_string);
strcpy(name->machine, ARCH);
return 0;
}
