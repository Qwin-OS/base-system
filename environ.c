
#include "common.h"
#include "environ.h"

void freeVarval(varval* head);
variable* addToEnvironment(char* name, variable* head);

variable* parseEnvFile(char* filename, variable* head) {
	char* varName;
	char* varValue;
	char* eq;
	char* tmpStr;
	int eqPos;
	int lineLen;
	int fp;
	fp = open(filename,O_RDONLY);
	char line[MAX_VAR_LINE];
	while (readln(line,MAX_VAR_LINE, fp)) {
		eq = strchr(line,VAR_VALUE_SEPERATOR);
		if (!eq || eq == NULL) {
			break;
		}
		eqPos = eq - line;
		tmpStr = malloc(eqPos+1);
		strncpy(tmpStr,line,eqPos);
		varName = trim(tmpStr);
		free(tmpStr);
		
		head = addToEnvironment(varName,head);
		
		lineLen = strlen(line);
		tmpStr = malloc(lineLen-eqPos);
		strncpy(tmpStr,line+eqPos+1,lineLen-eqPos-1);
		varValue = trim(tmpStr);
		free(tmpStr);
		
		head = addValueToVariable(varName ,head, varValue);
	}
	close(fp);
	return head;
}

int comp(const char* s1, const char* s2)
{
  return strcmp(s1,s2) == 0;
}

variable* environLookup(const char* name, variable* head)
{
  if (!name)
    return NULL;
  
  while (head)
  {
    if (comp(name, head->name))
      break;
    head = head->next;
  }
  return head;
}

variable* removeFromEnvironment(const char* name, variable* head)
{
  variable* tmp;
  if (!head)
    return NULL;
  if (!name || (*name == 0) )
    return head;
  
  if (comp(head->name,name))
  {
    tmp = head->next;
    freeVarval(head->values);
    free(head);
    return tmp;
  }
      
  head->next = removeFromEnvironment(name, head->next);
  return head;
}

variable* addToEnvironment(char* name, variable* head)
{
	variable* newVar;
	char* tmpName;
	if (!name)
		return head;
	if (head == NULL) {
		newVar = (variable*) malloc( sizeof(variable) );
		tmpName = name;
		strcpy(newVar->name, tmpName);
		newVar->next = NULL;
		head = newVar;
	}
	else
		head->next = addToEnvironment(name, head->next);
	return head;
}

variable* addValueToVariable(char* name, variable* head, char* value) {
	variable* var;
	varval* newVal;
	char* tmpValue;
	var = environLookup(name, head);
	if (!var)
		return head;
	newVal = (varval*) malloc( sizeof(varval) );
	tmpValue = value;
	strcpy(newVal->value, tmpValue);
	newVal->next = var->values;
	var->values = newVal;
	return head;
}

void freeEnvironment(variable* head)
{
  if (!head)
    return;  
  freeEnvironment(head->next);
  freeVarval(head->values);
  free(head);
}

void freeVarval(varval* head)
{
  if (!head)
    return;  
  freeVarval(head->next);
  free(head);
}

varval* getPaths(char* paths, varval* head) {
	char* nextSeperator;
	int pathLen;
	if (!paths)
		return head;
	if (head == NULL) {
		nextSeperator = strchr(paths,PATH_SEPERATOR);
		if (!nextSeperator) {
			pathLen = strlen(paths);
			head = (varval*) malloc(sizeof(varval));
			strncpy(head->value,paths,pathLen);
			head->value[pathLen] = '\0';
			head->next = NULL;
			return head;
		}
		else {
			pathLen = nextSeperator - paths;
			head = (varval*) malloc(sizeof(varval));
			strncpy(head->value,paths,pathLen);
			head->value[pathLen] = '\0';
			paths = nextSeperator;
			paths++;
		}
	}
	head->next = getPaths(paths,head->next);
	return head;
}
