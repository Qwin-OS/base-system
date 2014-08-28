#include <stdio.h>

void
filecreate(char *path)
{
        if(touch(path) < 0)
        {
                fprintf(stderr, "touch: %s failed to create\n", path);
                return;
        }
}

int
main(int argc, char *argv[])
{
        if(argc < 2)
        {
                fprintf(stderr,"Usage: touch filepath...\n");
            exit(0);
        }
        filecreate(argv[1]);
        return 0;
}






