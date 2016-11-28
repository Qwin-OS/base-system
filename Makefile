# Qwin-OS makefile
# forked from xv6

include build-config.mk
include profile.mk
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
        null.o\
        zero.o\

include config-options.mk
CFLAGS += $(CONFIG_CFLAGS)

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

system.img: mkfs environment passwd $(UPROGS) $(SPROGS)
	@./mkfs system.img environment passwd $(UPROGS) $(SPROGS)

-include *.d

clean:
	@rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*.o *.d *.asm *.sym vectors.S bootblock entryother \
	initcode initcode.out kernel boot.img system.img kernelmemfs mkfs \
	.gdbinit \
	$(UPROGS) $(SPROGS)

