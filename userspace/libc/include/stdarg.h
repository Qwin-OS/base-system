#ifndef STDARG_H
#define STDARG_H

typedef __builtin_va_list va_list;

#define va_start(l, p)  __builtin_va_start(l, p)
#define va_arg(l, t)    __builtin_va_arg(l, t)
#define va_end(l)       __builtin_va_end(l)


#endif // STDARG_H
