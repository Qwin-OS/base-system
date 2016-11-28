# Simple config options handler

# CC optimizations
ifeq ($(OPTIMIZE),size)
CONFIG_CFLAGS  += -Os
else ifeq ($(OPTIMIZE),speed)
CONFIG_CFLAGS   += -O3
else ifeq ($(OPTIMIZE),normal)
CONFIG_CFLAGS += -O2
endif

# Debugging support: if "y" - builds with gdb support, if "n" - builds stripped and without gdb
ifeq ($(DEBUG),y)
CONFIG_CFLAGS += -ggdb
else ifeq ($(DEBUG),n)
CONFIG_CFLAGS += -s
endif

# ACPI support
ifeq ($(ACPI),y)
CONFIG_CFLAGS += -DACPI
OBJS += acpi.o
endif

# Legacy colors for console
ifeq ($(LEGACY_FB),y)
CONFIG_CFLAGS += -DLEGACY_FB=1
endif
