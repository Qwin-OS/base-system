#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"

#define NULL 0

uint16_t SLP_TYPa;
uint16_t SLP_TYPb;

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
  uint8_t signature[8];
  uint8_t checksum;
  char oemid[6];
  uint8_t revision;
  uint32_t rsdtptr;
};

/* ACPI common table header */
#define ACPI_TABLE_HEADER_DEF                                                  \
  uint8_t  signature[4];          /* ACPI signature (4 ASCII characters) */         \
  uint32_t length;                /* Length of table, in uint8_ts, including header */ \
  uint8_t  revision;              /* ACPI Specification minor version # */          \
  uint8_t  checksum;              /* To make sum of entire table == 0 */            \
  uint8_t  oem_id[6];             /* OEM identification */                          \
  uint8_t  oem_table_id[8];       /* OEM table identification */                    \
  uint32_t oem_revision;          /* OEM revision number */                         \
  uint8_t  asl_compiler_id[4];    /* ASL compiler vendor ID */                      \
  uint32_t asl_compiler_revision; /* ASL compiler revision number */                \

struct RSDT
{
  ACPI_TABLE_HEADER_DEF
  uint32_t entry[];
};

/* FADT: fixed ACPI description table */
struct FADT
{
  ACPI_TABLE_HEADER_DEF
  uint32_t firmware_ctrl;          // Physical address of FACS
  uint32_t dsdt;                   // Physical address of DSDT                          
  uint8_t  model;                  // System Interrupt Model                            
  uint8_t  reserved1;              // Reserved                                          
  uint16_t sci_int;                // System vector of SCI interrupt                    
  uint32_t smi_cmd;                // Port address of SMI command port                  
  uint8_t  acpi_enable;            // Value to write to smi_cmd to enable ACPI          
  uint8_t  acpi_disable;           // Value to write to smi_cmd to disable ACPI         
  uint8_t  S4bios_req;             // Value to write to SMI CMD to enter S4BIOS state   
  uint8_t  reserved2;              // Reserved - must be zero                           
  uint32_t pm1a_evt_blk;           // Port address of Power Mgt 1a acpi_event Reg Blk   
  uint32_t pm1b_evt_blk;           // Port address of Power Mgt 1b acpi_event Reg Blk   
  uint32_t pm1a_cnt_blk;           // Port address of Power Mgt 1a Control Reg Blk      
  uint32_t pm1b_cnt_blk;           // Port address of Power Mgt 1b Control Reg Blk      
  uint32_t pm2_cnt_blk;            // Port address of Power Mgt 2 Control Reg Blk       
  uint32_t pm_tmr_blk;             // Port address of Power Mgt Timer Ctrl Reg Blk      
  uint32_t gpe0_blk;               // Port addr of General Purpose acpi_event 0 Reg Blk 
  uint32_t gpe1_blk;               // Port addr of General Purpose acpi_event 1 Reg Blk 
  uint8_t  pm1_evt_len;            // Byte length of ports at pm1_x_evt_blk             
  uint8_t  pm1_cnt_len;            // Byte length of ports at pm1_x_cnt_blk             
  uint8_t  pm2_cnt_len;            // Byte Length of ports at pm2_cnt_blk               
  uint8_t  pm_tmr_len;             // Byte Length of ports at pm_tm_blk                 
  uint8_t  gpe0_blk_len;           // Byte Length of ports at gpe0_blk                  
  uint8_t  gpe1_blk_len;           // Byte Length of ports at gpe1_blk                  
  uint8_t  gpe1_base;              // Offset in gpe model where gpe1 events start       
  uint8_t  reserved3;              // Reserved                                          
  uint16_t plvl2_lat;              // Worst case HW latency to enter/exit C2 state      
  uint16_t plvl3_lat;              // Worst case HW latency to enter/exit C3 state      
  uint16_t flush_size;             // Size of area read to flush caches                 
  uint16_t flush_stride;           // Stride used in flushing caches                    
  uint8_t  duty_offset;            // Bit location of duty cycle field in p_cnt reg     
  uint8_t  duty_width;             // Bit width of duty cycle field in p_cnt reg        
  uint8_t  day_alrm;               // Index to day-of-month alarm in RTC CMOS RAM       
  uint8_t  mon_alrm;               // Index to month-of-year alarm in RTC CMOS RAM      
  uint8_t  century;                // Index to century in RTC CMOS RAM                  
  uint8_t  reserved4a;             // Reserved                                          
  uint8_t  reserved4b;             // Reserved                                          
  uint8_t  reserved4c;             // Reserved                                          
  uint32_t flags;
} __attribute__((__packed__));

// DSDT
struct DSDT {
    ACPI_TABLE_HEADER_DEF
    uint8_t aml[];                   // AML code
};

// SSDT: (AML code)
struct SSDT {
    ACPI_TABLE_HEADER_DEF
    uint8_t aml[];
};


// scan RSDP
static
struct RSDT *scan_rsdptr(uint8_t *ptr)
{
   const char *sig = "RSD PTR ";
   struct RSDPtr *rsdp = (struct RSDPtr *)ptr;
   uint8_t *bptr;
   uint8_t sum = 0;

   if (memcmp(sig, rsdp, 8) == 0) {
      // sum rsdp
      bptr = (uint8_t *) ptr;

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

   uint8_t *beg = p2v(0x000E0000);
   uint8_t *end = p2v(0x00100000);

   // search from 1MB
   uint8_t *iter;
   for (iter = beg; iter < end; iter += 0x10) {
      rsdp = scan_rsdptr(iter);
      if (rsdp != NULL)
          return rsdp;
   }

   // get EBDA pointer from BDA
   int ebda = *((short *) p2v(0x40E));
   ebda = ebda << 4;

   beg = (uint8_t *) ebda;
   end = (uint8_t *) (ebda + 1024);

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
