#include <stdio.h>

int main(int argc, char * argv[]) {
	if ((argc > 1 && argv[1][0] == '-') || (argc < 2)) {
		char tmp[256];
		gethostname(tmp);
		printf("%s\n", tmp);
		return 0;
	} else {
			sethostname(argv[1]);
			int file = open("/etc/hostname", "w");
			if (!file) {
				return 1;
			} else {
				fprintf(file, "%s\n", argv[1]);
				close(file);
				return 0;
			}
		}
	return 0;
}
