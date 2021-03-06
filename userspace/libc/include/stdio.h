#include <types.h>
#include <stat.h>
#include <unistd.h>

typedef unsigned int fpos_t;

#define EOF (-1)
#define NULL 0

#define BUFSIZ 1024

typedef struct FILE {
  int    fd;
  char*  buffer;
  char*  rd_pos;
  char*  wr_pos;
  fpos_t read_off_beg;
  fpos_t read_off_pos;
  fpos_t read_off_end;
  fpos_t write_off_beg;
  fpos_t write_off_pos;
  fpos_t write_off_end;
  int    error;
  int    eof;
  int    mode;
  int    flags;
} FILE;


extern FILE* const stdin;
extern FILE* const stdout;
extern FILE* const stderr;

void fprintf(FILE*, char*, ...);

