#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"

#define NULL 0

typedef unsigned char       byte;
typedef unsigned long       dword;

#define dbg(code, ...) ({       \
  cprintf("[%s] ", #code);      \
  cprintf(__VA_ARGS__);         \
  cprintf("\n");                \
})

#define err(code, ...) ({       \
  cprintf("[%s] ", #code);      \
  cprintf(__VA_ARGS__);         \
  cprintf("\n");                \
})

static struct FADT *fadt = NULL;

struct RSDPtr
{
  byte signature[8];
  byte checksum;
  char oemid[6];
  byte revision;
  dword rsdtptr;
};

/* ACPI common table header */
#define ACPI_TABLE_HEADER_DEF                                                  \
  uint8_t  signature[4];          /* ACPI signature (4 ASCII characters) */         \
  uint32_t length;                /* Length of table, in bytes, including header */ \
  uint8_t  revision;              /* ACPI Specification minor version # */          \
  uint8_t  checksum;              /* To make sum of entire table == 0 */            \
  uint8_t  oem_id[6];             /* OEM identification */                          \
  uint8_t  oem_table_id[8];       /* OEM table identification */                    \
  uint32_t oem_revision;          /* OEM revision number */                         \
  uint8_t  asl_compiler_id[4];    /* ASL compiler vendor ID */                      \
  uint32_t asl_compiler_revision; /* ASL compiler revision number */                \

// scan RSDP
static
struct RSDT *scan_rsdptr(byte *ptr)
{
   const char *sig = "RSD PTR ";
   struct RSDPtr *rsdp = (struct RSDPtr *)ptr;
   byte *bptr;
   byte sum = 0;

   if (memcmp(sig, rsdp, 8) == 0) {
      // sum rsdp
      bptr = (byte *) ptr;

      int i;
      for (i = 0; i < sizeof(struct RSDPtr); i ++) {
         sum += *bptr;
         bptr ++;
      }
      // found rsdp
      if (sum == 0) {
          dbg(acpi, "ACPI%d", rsdp->revision == 0 ? 1 : 2);
          dbg(acpi, "RSDT: %x", rsdp->rsdtptr);
         return p2v(rsdp->rsdtptr);
      }
   }

   return NULL;
}

/* finds rsdp pointer */
static
struct RSDT *get_rsdptr(void)
{
   struct RSDT *rsdp;

   byte *beg = p2v(0x000E0000);
   byte *end = p2v(0x00100000);

   // search from 1MB
   byte *iter;
   for (iter = beg; iter < end; iter += 0x10) {
      rsdp = scan_rsdptr(iter);
      if (rsdp != NULL)
          return rsdp;
   }

   // get EBDA pointer from BDA
   int ebda = *((short *) p2v(0x40E));
   ebda = ebda << 4;

   beg = (byte *) ebda;
   end = (byte *) (ebda + 1024);

   // scan EBDA
   for (iter = beg; iter < end; iter += 0x10) {
      rsdp = scan_rsdptr(iter);
      if (rsdp != NULL)
         return rsdp;
   }

   return NULL;
}

void acpiinit(void)
{
struct RSDT *rsdt = get_rsdptr();
}
