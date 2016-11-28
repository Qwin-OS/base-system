# Simple config options handler

# CC optimizations
ifeq ($(OPTIMIZE),size)
CFLAGS  += -Os
else ifeq ($(OPTIMIZE),speed)
CFLAGS   += -O3
else ifeq ($(OPTIMIZE),normal)
CFLAGS += -O2
endif

# Debugging support: if "y" - builds with gdb support, if "n" - builds stripped and without gdb
ifeq ($(DEBUG),y)
CFLAGS += -ggdb
else ifeq ($(DEBUG),n)
CFLAGS += -s
endif

# ACPI support
ifeq ($(ACPI),y)
CFLAGS += -DACPI
OBJS += acpi.o
endif

# Legacy colors for console
ifeq ($(LEGACY_FB),y)
CFLAGS += -DLEGACY_FB=1
endif
