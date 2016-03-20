# Qwin-OS makefile
# forked from xv6

-include .config

ARCH=$ARCH

OBJS = \
	bio.o\
	bootx.o\
	device.o\
	tty.o\
	exec.o\
	file.o\
	fs.o\
	memdisk.o\
	ata.o\
	ioapic.o\
	kalloc.o\
	kbd.o\
	lapic.o\
	log.o\
	main.o\
	mp.o\
	panic.o\
	picirq.o\
	pipe.o\
	proc.o\
	rtc.o\
	spinlock.o\
	string.o\
	swtch.o\
	syscall.o\
	sysfile.o\
	sysproc.o\
	sysuser.o\
	timer.o\
	trapasm.o\
	trap.o\
	uart.o\
	vectors.o\
	vm.o\
	vfs.o\
        null.o\
        zero.o\

# Cross-compiling (e.g., on Mac OS X)
#TOOLPREFIX = i386-jos-elf-

# Using native tools (e.g., on X86 Linux)
#TOOLPREFIX = 

# Try to infer the correct TOOLPREFIX if not set
ifndef TOOLPREFIX
TOOLPREFIX := $(shell if i386-jos-elf-objdump -i 2>&1 | grep '^elf32-i386$$' >/dev/null 2>&1; \
	then echo 'i386-jos-elf-'; \
	elif objdump -i 2>&1 | grep 'elf32-i386' >/dev/null 2>&1; \
	then echo ''; \
	else echo "***" 1>&2; \
	echo "*** Error: Couldn't find an i386-*-elf version of GCC/binutils." 1>&2; \
	echo "*** Is the directory with i386-jos-elf-gcc in your PATH?" 1>&2; \
	echo "*** If your i386-*-elf toolchain is installed with a command" 1>&2; \
	echo "*** prefix other than 'i386-jos-elf-', set your TOOLPREFIX" 1>&2; \
	echo "*** environment variable to that prefix and run 'make' again." 1>&2; \
	echo "*** To turn off this error, run 'gmake TOOLPREFIX= ...'." 1>&2; \
	echo "***" 1>&2; exit 1; fi)
endif

CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump
#CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer
CFLAGS =  -fno-pic -Wno-error=pointer-arith -static -fno-builtin -fno-strict-aliasing -Wall -Wno-error=deprecated-declarations -MD -m32  -fno-omit-frame-pointer -std=gnu11 -pedantic
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
CFLAGS += -I./include
ifdef OPTIMIZE_FOR_SIZE
CFLAGS	+= -Os
else ifdef OPTIMIZE_FOR_SPEED
CFLAGS   += -O3
else ifdef OPTIMIZE_NORMALLY
CFLAGS += -O2
endif

ifndef NODBG
CFLAGS += -ggdb
else
CFLAGS += -s
endif

ASFLAGS = -m32 -gdwarf-2 -Wa,-divide -I./include
# FreeBSD ld wants ``elf_i386_fbsd''
LDFLAGS += -m $(shell $(LD) -V | grep elf_i386 2>/dev/null)

ifndef NOACPI
OBJS += acpi.o
else
CFLAGS += -DNOACPI
endif

ifdef LEGACY_FB
CFLAGS += -DLEGACY_FB
endif

kernel: $(OBJS) boot.o entryother initcode kernel.ld system.img
	@$(LD) $(LDFLAGS) -T kernel.ld -o kernel boot.o $(OBJS) -b binary initcode entryother system.img
	@$(OBJDUMP) -t kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > kernel.sym
	@echo "[LD] $@"

entryother: entryother.S
	@$(CC) $(CFLAGS) -fno-pic -nostdinc -I. -c entryother.S
	@$(LD) $(LDFLAGS) -N -e start -Ttext 0x7000 -o bootblockother.o entryother.o
	@$(OBJCOPY) -S -O binary -j .text bootblockother.o entryother

initcode: initcode.S
	@$(CC) $(CFLAGS) -nostdinc -I. -c initcode.S
	@$(LD) $(LDFLAGS) -N -e start -Ttext 0 -o initcode.out initcode.o
	@$(OBJCOPY) -S -O binary initcode.out initcode

tags: $(OBJS) entryother.S !init
	@etags *.S *.c

vectors.S: vectors.pl
	@perl vectors.pl > vectors.S

ULIB = ulib.o usys.o printf.o umalloc.o foper.o stdio.o utsname.o scanf.o atob.o strncpy.o time.o getpwent.o

_%: %.o $(ULIB)
	@$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^
	@echo "[CC] $@"

!%: %.o $(ULIB)
	@$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^
	@echo "[CC] $@"

_forktest: forktest.o $(ULIB)
	# forktest has less library code linked in - needs to be small
	# in order to be able to max out the proc table.
	@$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o _forktest forktest.o ulib.o usys.o
	@$(OBJDUMP) -S _forktest > forktest.asm

mkfs: mkfs.c include/fs.h
	@gcc -Wall -o mkfs mkfs.c

# Prevent deletion of intermediate files, e.g. cat.o, after first build, so
# that disk image changes after first build are persistent until clean.  More
# details:
# http://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.PRECIOUS: %.o

config_%: configs/%
	@(echo "CONFIG_DATE=`date`"; cat $^) > .config
	@echo "Sucessfully applied config '$^'"

SPROGS=\
	!halt\
	!init\
	!login\
	!reboot\

UPROGS=\
	_base64\
	_cat\
	_cowsay\
	_date\
	_echo\
	_grep\
	_head\
	_hostname\
	_kill\
	_ln\
	_ls\
	_mkdir\
	_rm\
	_sh\
	_sleep\
	_tail\
	_touch\
	_wc\
        _pwd\
	_su\
	_id\
        _mknod\
        _mv\
        _uptime\
        _false\
        _true\
        _uname\
	_whoami\

system.img: mkfs environment passwd $(UPROGS) $(SPROGS)
	@./mkfs system.img environment passwd $(UPROGS) $(SPROGS)

-include *.d

clean:
	@rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*.o *.d *.asm *.sym vectors.S bootblock entryother \
	initcode initcode.out kernel boot.img system.img kernelmemfs mkfs \
	.gdbinit \
	$(UPROGS) $(SPROGS)

floppy: floppy.img kernel
	mkdir floppy
	su -c 'mount floppy.img floppy; cp kernel floppy/kernel; umount floppy'
	@echo "[IMG] $@"

%.o: %.c
	@$(CC) $(CFLAGS) -c -o $@ $*.c
	@echo "[CC] $@"

%.o: %.S
	@$(CC) $(ASFLAGS) -c -o $@ $*.S
	@echo "[AS] $@"

config: config_default
