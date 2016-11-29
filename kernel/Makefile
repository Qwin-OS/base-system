include $(basedir)/profile.mk
include $(basedir)/build-config.mk

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

include $(basedir)/config-options.mk
CFLAGS += -Iinclude $(CONFIG_CFLAGS)
ASFLAGS += -Iinclude

kernel: $(OBJS) ../boot/boot.o entryother initcode kernel.ld ../system.img
	@cp ../system.img .
	@$(LD) $(LDFLAGS) -T kernel.ld -o kernel ../boot/boot.o $(OBJS) -b binary initcode entryother system.img
	@$(OBJDUMP) -t kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > kernel.sym
	@echo "[LD] $@"
	@rm system.img

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

clean:
	@rm -f *.o *.d *.out vectors.S initcode entryother kernel *.sym *.img
