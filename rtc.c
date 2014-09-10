/* Very small RTC driver */

#include <types.h>
#include <defs.h>
#include <x86.h>
#include <traps.h>
#include <rtc.h>
#define NULL 0

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

int get_date(DATE *date)
{
  date->fields.dow = bcd2dec(read_rtc_address(6));
  date->fields.dom = bcd2dec(read_rtc_address(7));
  date->fields.month = bcd2dec(read_rtc_address(8));
  date->fields.year = bcd2dec(read_rtc_address(9));
  return 0;
}

int get_time(TIME *time)
{
  time->fields.hour = bcd2dec(read_rtc_address(4));
  time->fields.minute = bcd2dec(read_rtc_address(2));
  time->fields.second = bcd2dec(read_rtc_address(0));
  return 0;
}

void init_rtc()
{
  get_date(&sdate);
  get_time(&stime);
  picenable(IRQ_RTC);
  ioapicenable(IRQ_RTC, 1);
  read_rtc_address(0x0c);
  //cprintf("RTC date and time %d.%d.%d %d:%d:%d",sdate.fields.dom,sdate.fields.month,
			//sdate.fields.year + 2000,stime.fields.hour,stime.fields.minute,stime.fields.second);
  //cprintf("\n");
}

void update(void)
{
  get_date(&sdate);
  get_time(&stime);
  read_rtc_address(0x0c);
}

time_t get_date_time( time_t *t )
{
	struct tm tm;
	time_t ret = (time_t)(-1);

	if( get_date(&sdate) == 0 | get_time(&stime) )
	{
		// Copy real time clock values into the standard
		// structure.
		tm.tm_year = sdate.fields.year + 2000;
		tm.tm_mon = sdate.fields.month;
		tm.tm_mday = sdate.fields.dom;
		tm.tm_hour = stime.fields.hour;
		tm.tm_min = stime.fields.minute;
		tm.tm_sec = stime.fields.second;

		// Make the UNIX timestamp.
		ret = mktime( &tm );
	}
	if( t != NULL )
	{
		// Update the argument.
		*t = ret;
	}

	return( ret );
}
