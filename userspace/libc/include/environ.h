
#ifndef ENVIRON_H
#define ENVIRON_H

#include <unistd.h>

#define MAX_VAR_NAME 128
#define MAX_VAR_VAL 1024
#define MAX_VAR_LINE 1024
#define PATH_SEPERATOR ':'
#define VAR_VALUE_SEPERATOR '='

typedef struct variable
{
  char name[MAX_VAR_NAME];
  struct varval *values;
  struct variable *next;
} variable;

typedef struct varval
{
  char value[MAX_VAR_VAL];
  struct varval *next;
} varval;

/* parses a PATH_SEPERATOR seperated string into a list of varval structs */
varval* getPaths(char* paths, varval* head);

/* parses a file and adds it's content to the supplied variavle* structure */
variable* parseEnvFile(char* filename,variable* head);

/* Adds a new variable with given name and val to a chain (linked list) of variables,
pointed by head. Returns the new head */
variable* addToEnvironment(char* name, variable* head);

/* Adds a new value with given value to a chain (linked list) of values 
of the variable by the name name,in the linked list
pointed by head. Returns the new head */
variable* addValueToVariable(char* name, variable* head, char* value);

/* Removes variables indicated by name from the variable chain.
Returns the new head*/
variable* removeFromEnvironment(const char* name, variable* head);

/* Releases all memory that was allocated for the chain */
void freeEnvironment(variable* head);

/* Finds a variable by its name. Returns NULL if not found */
variable* environLookup(const char* name, variable* head);

/* Releases all memory that was allocated for the chain */
void freeVarval(varval* head);

#endif 
