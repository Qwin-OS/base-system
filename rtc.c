/* Very small RTC driver */

#include <types.h>
#include <defs.h>
#include <x86.h>
#include <traps.h>
#include <rtc.h>

static DATE sdate;
static TIME stime;

volatile unsigned char read_rtc_address(unsigned char address)
{
  outb(0x70,address);
  return inb(0x71);
}

volatile void write_rtc_address(unsigned char address, unsigned int val)
{
  outb(0x70,address);
  outb(0x71,val);
}

void get_date(DATE *date)
{
  date->fields.dow = bcd2dec(read_rtc_address(7));
  date->fields.month = bcd2dec(read_rtc_address(8));
  date->fields.year = bcd2dec(read_rtc_address(9));
}

void get_time(TIME *time)
{
  time->fields.hour = bcd2dec(read_rtc_address(4));
  time->fields.minute = bcd2dec(read_rtc_address(2));
  time->fields.second = bcd2dec(read_rtc_address(0));
  return time;
}

void init_rtc()
{
  get_date(&sdate);
  get_time(&stime);
  picenable(IRQ_RTC);
  ioapicenable(IRQ_RTC, 1);
  write_rtc_address(0xa,38);
  write_rtc_address(0xb,194);
  read_rtc_address(0xc);
}
