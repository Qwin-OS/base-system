include ../profile.mk

CFLAGS += -Ilibc/include -I../kernel/include
ASFLAGS += -Ilibc/include -I../kernel/include

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

ULIB = libc/ulib.o libc/usys.o libc/printf.o libc/umalloc.o libc/foper.o libc/stdio.o libc/utsname.o libc/scanf.o libc/atob.o libc/strncpy.o libc/time.o libc/getpwent.o

default: $(SPROGS) $(UPROGS)

_%: %.o $(ULIB)
	@$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^
	@echo "[CC] $@"

!%: %.o $(ULIB)
	@$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^
	@echo "[CC] $@"

clean:
	@rm -f *.o *.d $(UPROGS) $(SPROGS) libc/*.o libc/*.d
