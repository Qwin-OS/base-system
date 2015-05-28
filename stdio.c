#include <stdio.h>
#include <fcntl.h>

static FILE in = {
	.fd = 0,
	.buffer = 0,
	.read_off_beg= 0,
  	.read_off_pos = 0,
  	.read_off_end = 0,
  	.write_off_beg = 0,
  	.write_off_pos = 0,
  	.write_off_end = 0,
  	.error = 0,
  	.eof = 0,
  	.mode = O_RDONLY,
  	.flags = 0
};

static FILE out = {
        .fd = 1,
        .buffer = 0,
        .read_off_beg= 0,
        .read_off_pos = 0,
        .read_off_end = 0,
        .write_off_beg = 0,
        .write_off_pos = 0,
        .write_off_end = 0,
        .error = 0,
        .eof = 0,
        .mode = O_WRONLY,
        .flags = 0
};

static FILE err = {
        .fd = 2,
        .buffer = 0,
        .read_off_beg= 0,
        .read_off_pos = 0,
        .read_off_end = 0,
        .write_off_beg = 0,
        .write_off_pos = 0,
        .write_off_end = 0,
        .error = 0,
        .eof = 0,
        .mode = O_WRONLY,
        .flags = 0
};

FILE* const stdin  = &in;
FILE* const stdout = &out;
FILE* const stderr = &err;
