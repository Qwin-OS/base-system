#ifndef __MODULE_H_
#define __MODULE_H_

#define MODULE(name) static char* __MODULE_NAME = name;
#define kprint(...) { cprintf("[%s]: ", __MODULE_NAME); cprintf(__VA_ARGS__); }

#endif
