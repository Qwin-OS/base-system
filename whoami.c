// Who Am I?

#include <stdio.h>
#include <pwd.h>

int main(int argc, char ** argv) {
	struct passwd *p = getpwuid(getuid());
	if (!p) return 0;

	fprintf(stdout, "%s\n", p->pw_name);

	endpwent();

	return 0;
}
