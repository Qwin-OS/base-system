include $(basedir)/profile.mk

CFLAGS += -Iinclude -I$(basedir)/kernel/include
ASFLAGS += -Iinclude -I$(basedir)/kernel/include

LIBC_TARGETS = ulib.o usys.o printf.o umalloc.o foper.o stdio.o utsname.o scanf.o atob.o strncpy.o time.o getpwent.o

default: $(LIBC_TARGETS)

clean:
	@rm -f *.o *.d
