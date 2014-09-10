#ifndef _RTC_H_
#define _RTC_H_

#define bcd2dec(bcd) ((((bcd) >> 4) * 0xa) + ((bcd) & 0xf))

typedef union {
  unsigned long time;
  struct {
    unsigned long hour:5;
    unsigned long minute:6;
    unsigned long second:6;
  }fields;
}TIME;

typedef union {
  unsigned long date;
  struct {
    unsigned long dow:3; /*Day of week*/
    unsigned long dom:5; /*Day of month*/
    unsigned long month:4;
    unsigned long year:7;
  }fields;
}DATE;

struct tm {
	int tm_sec;	//!< Seconds.
	int tm_min;	//!< Minutes.
	int tm_hour;	//!< Hours.
	int tm_mday;	//!< Day of the month.
	int tm_mon;	//!< Month.
	int tm_year;	//!< Year.
	int tm_wday;	//!< Day of the week.
	int tm_yday;	//!< Day in the year.
	int tm_isdst;	//!< Daylight saving time.
};

static time_t mktime( struct tm *tm )
{
	/* 1..12 -> 11,12,1..10 */
	if (0 >= (int) (tm->tm_mon -= 2)) {
		/* Puts Feb last since it has leap day */
		tm->tm_mon += 12;
		tm->tm_year -= 1;
	}

	return (((
		(unsigned long) (tm->tm_year/4 - tm->tm_year/100 + tm->tm_year/400 + 
367*tm->tm_mon/12 + tm->tm_mday) +
			tm->tm_year*365 - 719499
	    )*24 + tm->tm_hour /* now have hours */
	  )*60 + tm->tm_min /* now have minutes */
	)*60 + tm->tm_sec; /* finally seconds */
}

void init_rtc();
int get_date(DATE *date);
int get_time(TIME *time);

#endif
