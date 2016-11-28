CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld.bfd
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump
#CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer
CFLAGS =  -fno-pic -Wno-error=pointer-arith -static -fno-builtin -fno-strict-aliasing -Wall -Wno-error=deprecated-declarations -MD -m32  -fno-omit-frame-pointer -std=gnu11 -pedantic
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
CFLAGS += -I./include
ASFLAGS = -m32 -gdwarf-2 -Wa,-divide -I./include
# FreeBSD ld wants ``elf_i386_fbsd''
LDFLAGS += -m $(shell $(LD) -V | grep elf_i386 2>/dev/null)

.PRECIOUS: %.o

%.o: %.c
	@$(CC) $(CFLAGS) -c -o $@ $*.c
	@echo "[CC] $@"

%.o: %.S
	@$(CC) $(ASFLAGS) -c -o $@ $*.S
	@echo "[AS] $@"

