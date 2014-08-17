#ifndef COMMON_H
#define COMMON_H

#include "types.h"
#include "fcntl.h"
#include "unistd.h"

#define stdin 0
#define stdout 1
#define stderr 2

#define NULL 0

/*
 * works exactly as gets except it uses given file descriptor
 */
char* readln(char *buf, int max, int fd);

/*
 * copies n chars from src to dest if it doesnt encounter a null-char before.
 */
char* strncpy(char* dest, char* src, int n);

/*
 * trims leading and trailing whitespaces
 * returns a new string, dont forget to free the original.
 */ 
char* trim(char* orig);

/*
 * returns true if char is space,tab,line feed or carriage return
 */
int isspace(char c);

/*
 * convert int to string
 */
char* itoa(int);

#endif
