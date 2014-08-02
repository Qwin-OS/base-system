#ifndef CMDHISTORY_H
#define CMDHISTORY_H

#include "types.h"
#include "defs.h"

#define HISTORY_SIZE 16
#define COMMAND_SIZE 128

void cmdHistory_create();

void cmdHistory_push(char *value);

char* cmdHistory_next();

void cmdHistory_free();

#endif
