# Qwin-OS makefile
# forked from xv6

include build-config.mk
include profile.mk
ARCH=$ARCH

include config-options.mk
CFLAGS += $(CONFIG_CFLAGS)

_forktest: forktest.o $(ULIB)
	# forktest has less library code linked in - needs to be small
	# in order to be able to max out the proc table.
	@$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o _forktest forktest.o ulib.o usys.o
	@$(OBJDUMP) -S _forktest > forktest.asm

mkfs/mkfs: mkfs/mkfs.c include/fs.h
	@gcc -Wall -o mkfs/mkfs mkfs/mkfs.c

# Prevent deletion of intermediate files, e.g. cat.o, after first build, so
# that disk image changes after first build are persistent until clean.  More
# details:
# http://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.PRECIOUS: %.o

system.img: mkfs/mkfs files/environment files/passwd userspace/!* userspace/_*
	cp userspace/!* .
	cp userspace/_* .
	cp files/environment files/passwd .
	@./mkfs/mkfs system.img environment passwd _* !*
	rm !* _* environment passwd

-include *.d

clean:
	@rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*.o *.d *.asm *.sym vectors.S bootblock entryother \
	initcode initcode.out boot.img system.img kernelmemfs \
	.gdbinit \
	$(UPROGS) $(SPROGS)

