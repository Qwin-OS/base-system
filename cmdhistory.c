
#include "cmdhistory.h"

static int cmdHistory_init;
static int cmdHistory_head;
static int cmdHistory_pos;
static int cmdHistory_count;
static char cmdHistory_commands[HISTORY_SIZE][COMMAND_SIZE];

void cmdHistory_create() {
  int i;
  
  cmdHistory_head = -1;
  cmdHistory_pos = -1;
  cmdHistory_count = 0;
  
  for (i = 0; i < HISTORY_SIZE; i++)
    memset(cmdHistory_commands[i], 0, COMMAND_SIZE);
    
  cmdHistory_init = 1;
}

void cmdHistory_push(char *value) {
  int len;
  
  len = strlen(value);
  if (!len) return;
  
  if (!cmdHistory_init)
    cmdHistory_create();
  
  if (cmdHistory_count < HISTORY_SIZE)
    cmdHistory_count++;
  
  cmdHistory_head = (cmdHistory_head + 1) % HISTORY_SIZE;
  safestrcpy(cmdHistory_commands[cmdHistory_head], value, len + 1);
  cmdHistory_pos = cmdHistory_head;
}

char* cmdHistory_next() {
    char *cmd;
    
    if (cmdHistory_pos == -1) return 0;
    
    cmd = cmdHistory_commands[cmdHistory_pos];
    
    cmdHistory_pos = (--cmdHistory_pos < 0) ? (cmdHistory_count - 1) : cmdHistory_pos;
    
    return cmd;
}

void cmdHistory_free() {
  // ??
}
