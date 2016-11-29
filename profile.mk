CC = gcc
AS = gas
LD = ld.bfd
OBJCOPY = objcopy
OBJDUMP = objdump
CFLAGS =  -fno-pic -Wno-error=pointer-arith -static -fno-builtin -fno-strict-aliasing -Wall -Wno-error=deprecated-declarations -MD -m32  -fno-omit-frame-pointer -std=gnu11 -pedantic
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
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

