# Qwin-OS makefile
# forked from xv6

include build-config.mk
include profile.mk
ARCH=$ARCH

include config-options.mk
CFLAGS += $(CONFIG_CFLAGS)

SUBDIRS = userspace/libc userspace kernel
.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

userspace/libc:
	@+make -C $@

userspace: userspace/libc
	@+make -C $@

kernel: system.img
	@+make -C $@
	@cp kernel/kernel QwinOS-binary


#_forktest: forktest.o $(ULIB)
#	# forktest has less library code linked in - needs to be small
#	# in order to be able to max out the proc table.
#	@$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o _forktest forktest.o ulib.o usys.o
#	@$(OBJDUMP) -S _forktest > forktest.asm

system.img: mkfs/mkfs files/environment files/passwd userspace
	@cp userspace/!* .
	@cp userspace/_* .
	@cp files/environment files/passwd .
	@./mkfs/mkfs system.img environment passwd _* !*
	@rm !* _* environment passwd

mkfs/mkfs: mkfs/mkfs.c kernel/include/fs.h
	@gcc -Wall -o mkfs/mkfs mkfs/mkfs.c

# Prevent deletion of intermediate files, e.g. cat.o, after first build, so
# that disk image changes after first build are persistent until clean.  More
# details:
# http://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.PRECIOUS: %.o

-include *.d

clean:
	@rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*.o *.d *.asm *.sym vectors.S bootblock entryother \
	initcode initcode.out boot.img system.img kernelmemfs \
	.gdbinit mkfs/mkfs boot/boot.o QwinOS-binary
	@make clean -C kernel
	@make clean -C userspace
	@make clean -C userspace/libc
